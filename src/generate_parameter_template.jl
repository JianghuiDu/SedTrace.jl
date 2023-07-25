module TemplateGeneration
using SedTrace: ModelConfig
import XLSX
import SymPy
using DataFrames, DataFramesMeta, Chain, UnPack

include("helpers.jl")
include("generate_reaction.jl")
include("generate_transport.jl")
include("preprocessing.jl")
include("moleculardiff.jl")
include("pH_helpers.jl")
include("identify_parameters.jl")
include("parsing_jacobian.jl")
include("speciation_code.jl")

function generate_parameter_template(
    modelconfig::ModelConfig;
    EnableList::Dict = Dict(),
    overwrite = false,
)
    # model_path = modelconfig.ModelDirectory * "model_parameter_template."*modelconfig.ModelName*".xlsx"
    template_path = joinpath(modelconfig.ModelDirectory , "model_parameter_template."*modelconfig.ModelName*".xlsx")
    if template_path in readdir(modelconfig.ModelDirectory, join = true)
        throw(
            error(
                "A parameter template [$template_path] already exist in the directory. If you want to generate a new one, delete the template first!",
            ),
        )
    else
        param_template = generate_template(modelconfig, EnableList = EnableList)
        XLSX.writetable(
            template_path,
            overwrite = false,
            parameters = (
                collect(DataFrames.eachcol(param_template)),
                DataFrames.names(param_template),
            ),
        )
    end

end

function generate_template(modelconfig::ModelConfig; EnableList::Dict = Dict())
    model_path = joinpath(modelconfig.ModelDirectory , modelconfig.ModelFile)

    model_config = XLSX.readxlsx(model_path)

    for i in ["substances", "reactions", "speciation", "adsorption"]
        if !(i in XLSX.sheetnames(model_config))
            throw(error("Sheet $i is not found in $model_path."))
        end
    end

    substances = DataFrame(XLSX.gettable(model_config["substances"]))
    reactions = DataFrame(XLSX.gettable(model_config["reactions"]))
    speciation = DataFrame(XLSX.gettable(model_config["speciation"]))
    adsorption = DataFrame(XLSX.gettable(model_config["adsorption"]))
    diffusion = DataFrame(XLSX.gettable(model_config["diffusion"]))

    preprocessSubstances!(substances, EnableList)
    preprocessReactions!(reactions, EnableList)
    preprocessDiffusion!(diffusion, substances)
    preprocessSpeciation!(speciation, substances, EnableList)
    preprocessAdsorption!(adsorption, substances, speciation, EnableList)


    globalParam = @chain begin
        newdf()
        push!(["const", "depth", "", "m", "water depth"],)
        push!(["const", "salinity", "", "psu", "bottom water salinity"],)
        push!(["const", "temp", "", "Celsius", "bottom water temperature"],)
        push!(["const", "ds_rho", "", "g cm^-3", "dry sediment density"],)
        @transform!(:class = "global")
    end


    gridParam = @chain begin
        newdf()
        push!(["const", "L", "", "cm", "model sediment section thickness"],)
        push!(["const", "Ngrid", "", "integer", "number of model grid"],)
        push!(_, ["function", "gridtran", "", "cm", "grid transformation function"])
        @transform!(:class = "grid")
    end

    porosityParam = @chain begin
        newdf()
        push!(
            _,
            ["function", "phi", "", "dimensionless", "porosity"],
        )
        push!(_, ["const", "phi_Inf", "", "dimensionless", "porosity at infinite depth"])
        @transform!(:class = "porosity")
    end

    burialParam = @chain begin
        newdf()
        push!(_, ["const", "Fsed", "", "g cm^-2 yr^-1", "total sediment flux"])
        @transform!(:class = "burial")
    end


    bioturbationParam = @chain begin
        newdf()
        push!(
            _,
            [
                "function",
                "Dbt",
                "",
                "cm^2/yr",
                "bioturbation coefficient",
            ],
        )
        @transform!(:class = "bioturbation")
    end



    bioirrigationParam = @chain begin
        newdf()
        push!(
            _,
            [
                "function",
                "Dbir",
                "",
                "yr^-1",
                "bioirrigation coefficient",
            ],
        )
        @transform!(:class = "bioirrigation")
    end

    bcParam = newdf()

    option_beta = any(
        (substances.type .∈ Ref(["dissolved", "dissolved_pH"])) .&&
        (substances.top_bc_type .== "robin"),
    )

    if option_beta
        push!(
            bcParam,
            ["const", "delta", "", "cm", "thickness of the diffusive boundary layer"],
        )
    end

    function fill_bcParam_age!(df, top, bc_type)
        if bc_type == "robin"
            push!(
                df,
                [
                    "const",
                    "FAge0",
                    "",
                    "cm",
                    "Flux of age at the  TOP",
                ],
            )
        elseif bc_type == "dirichlet"
            push!(
                df,
                [
                    "const",
                    top ? "Age0" : "AgeL",
                    "",
                    "year",
                    "Age at the " *
                    (top ? "TOP" : "BOTTOM") *
                    "",
                ],
            )
        end
    end
    function fill_bcParam!(df, substance, top, bc_type, substance_type)
        if bc_type == "robin"
            if substance_type == "solid"
                push!(
                    df,
                    [
                        "const",
                        "F" * substance * "0",
                        "",
                        "mmol cm^-2 yr^-1",
                        "Flux of " * substance * " at the  TOP",
                    ],
                )
            elseif substance_type in ["dissolved", "dissolved_pH"]
                push!(
                    df,
                    [
                        "const",
                        substance == "H" ? "pHBW" : substance * "BW",
                        "",
                        substance == "H" ? "free pH scale" : "mmol cm^-3",
                        substance == "H" ? "Bottom water pH" :
                        "Bottom water concentration of " * substance,
                    ],
                )
            end
        elseif bc_type == "dirichlet"
            push!(
                df,
                [
                    "const",
                    (substance == "H" ? "pH" : substance) * (top ? "0" : "L"),
                    "",
                    substance == "H" ? "free pH scale" : "mmol cm^-3",
                    (substance == "H" ? "pH" : "Concentration of " * substance) *
                    " at the " *
                    (top ? "TOP" : "BOTTOM") *
                    "",
                ],
            )
        end
    end

    for i in eachrow(substances)
        if i.substance == "Age"
            fill_bcParam_age!(bcParam, true, i.top_bc_type)
            fill_bcParam_age!(bcParam, false, i.bot_bc_type)
        else
            if i.type == "dissolved_speciation"
                dis_sp = i.substance * "_dis"
                fill_bcParam!(bcParam, dis_sp, true, i.top_bc_type, "dissolved")
                fill_bcParam!(bcParam, dis_sp, false, i.bot_bc_type, "dissolved")
                ads_df = @subset(adsorption, :substance .== i.substance)

                if !isempty(ads_df)
                    ads_spec = i.substance * "_ads"
                    fill_bcParam!(bcParam, ads_spec, true, ads_df.top_bc_type[1], "solid")
                    fill_bcParam!(bcParam, ads_spec, false, ads_df.bot_bc_type[1], "solid")
                end
            else
                fill_bcParam!(bcParam, i.substance, true, i.top_bc_type, i.type)
                fill_bcParam!(bcParam, i.substance, false, i.bot_bc_type, i.type)
            end
        end
    end

    bcParam = @transform!(bcParam, :class = "BoundaryCondition")


    view_code, tran_code, tran_expr, tran_cache = transport_code(substances, adsorption)

    spec_code, spec_expr, spec_cache, speciation_df =
        speciation_code(substances, speciation, adsorption)

    react_code, parsing_df, species_modelled, react_expr, react_cache, pHspecies =
        reaction_code(
            reactions,
            substances,
            speciation_df,
            modelconfig.CompleteFlux,
            modelconfig.AllowDiscontinuity,
        )



    cache_str = unique(vcat(spec_cache, react_cache, tran_cache))
    @unpack species_model_df, species_extra_df, elements_df = parsing_df

    tran_param = identify_tran_param(species_modelled, tran_expr, cache_str)

    react_jp, react_param = jac_react_dependence(
        species_model_df,
        species_modelled,
        spec_expr,
        react_expr,
        cache_str,
        pHspecies,
    )

    @subset!(
        react_param,
        .!in.(:parameter, Ref(["dstopw", "pwtods", "phi", "Dbt", "Dbir", "alpha", "x"]))
    )


    adsParam = @subset(react_param, :type .== "speciation")
    select!(adsParam, :parameter, :type)
    @transform!(adsParam, :type = "const")
    @transform!(adsParam, :value = "")
    @transform!(adsParam, :unit = "")
    @transform!(adsParam, :comment = "speciation constant")
    @select!(adsParam, :type, :parameter, :value, :unit, :comment)
    @transform!(adsParam, :class = "speciation")


    reacParam = @subset(react_param, :type .!= "speciation")
    @transform!(reacParam, :type = "const")
    @transform!(reacParam, :value = "")
    @transform!(reacParam, :unit = "")
    @transform!(reacParam, :comment = "appears in " .* :comment)
    @select!(reacParam, :type, :parameter, :value, :unit, :comment)
    @transform!(reacParam, :class = "Reaction")


    dissolved =
        subset(substances, :type => x -> x .∈ Ref(["dissolved", "dissolved_speciation"]))
    @transform!(
        dissolved,
        :species =
            ifelse.(:type .== "dissolved_speciation", :substance .* "_dis", :substance)
    )


    diffusionParam = newdf()
    for i in dissolved.species
        if !in(i, diffusion.model_name)
            push!(
                diffusionParam,
                [
                    "const",
                    "D" * i,
                    "",
                    "cm^2 yr^-1",
                    "Moledular diffusivity of $i at in situ condition",
                ],
            )
        end
    end
    @select!(diffusionParam, :type, :parameter, :value, :unit, :comment)
    @transform!(diffusionParam, :class = "diffusion")


    parameters = @chain begin
        globalParam
        append!(gridParam)
        append!(porosityParam)
        append!(burialParam)
        append!(diffusionParam)
        append!(bioturbationParam)
        append!(bioirrigationParam)
        append!(adsParam)
        append!(bcParam)
        append!(reacParam)
        select!(:class, :type, :parameter, :value, :unit, :comment)
    end
    @transform!(parameters, :include = 1)

    return parameters
end

end
