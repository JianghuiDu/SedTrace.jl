module TemplateGeneration
using SedTrace: ModelConfig
import XLSX
import SymPy
using DataFrames,
    DataFramesMeta, Chain, UnPack

include("helpers.jl")
include("generate_reaction.jl")
include("generate_transport.jl")
include("preprocessing.jl")
include("moleculardiff.jl")
include("pH_helpers.jl")
include("identify_parameters.jl")
include("parsing_jacobian.jl")

function generate_parameter_template(modelconfig::ModelConfig)
    model_path = modelconfig.ModelDirectory * modelconfig.ModelFile
    template_path = replace(model_path, r".xlsx" => ".parameter_template.xlsx")
    if template_path in readdir(modelconfig.ModelDirectory, join = true)
        throw(
            error(
                "A parameter template [$template_path] already exist in the directory. If you want to generate a new one, delete the template first!",
            ),
        )
    else
        param_template = generate_template(modelconfig)
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

function generate_template(modelconfig::ModelConfig)
    model_path = modelconfig.ModelDirectory * modelconfig.ModelFile

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

    preprocessSubstances!(substances)
    preprocessReactions!(reactions)
    preprocessAdsorption!(adsorption)
    preprocessSpeciation!(speciation)


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
        push!(
            _,
            [
                "function",
                "gridtran",
                "",
                "cm",
                "grid transformation function",
            ],
        )
        @transform!(:class = "grid")
    end

    porosityParam = @chain begin
        newdf()
        push!(
            _,
            [
                "function",
                "phi",
                "",
                "dimensionless",
                "porosity as a function of depth",
            ],
        )
        push!(
            _,
            [
                "const",
                "phi_Inf",
                "",
                "dimensionless",
                "porosity at burial depth",
            ],
        )
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
                "bioburbation coefficient as a function of depth",
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
                "bioirrigation coefficient as a function of depth",
            ],
        )
        @transform!(:class = "bioirrigation")
    end

    bcParam = newdf()

    option_beta = any(
        (
            substances.type .∈
            Ref(["dissolved", "dissolved_summed", "dissolved_summed_pH"])
        ) .& (substances.top_bc_type .== "robin"),
    )

    if option_beta
        push!(
            bcParam,
            ["const", "delta", "", "cm", "thickness of the diffusive boundary layer"],
        )
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
                        "Flux of " * substance * " at the  TOP of sediment column",
                    ],
                )
            elseif substance_type in [
                "dissolved",
                "dissolved_summed",
                "dissolved_adsorbed",
                "dissolved_summed_pH",
            ]
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
                    " of sediment column",
                ],
            )
        end
    end

    for i in eachrow(substances)
        if i.type == "dissolved_adsorbed_summed"
            ads_df = @subset(adsorption, :substance .== i.substance)
            dis_spec = ads_df.dissolved[1]
            fill_bcParam!(bcParam, dis_spec, true, i.top_bc_type, "dissolved")
            fill_bcParam!(bcParam, dis_spec, false, i.bot_bc_type, "dissolved")
            for j in eachrow(ads_df)
                fill_bcParam!(bcParam, j.adsorbed, true, j.top_bc_type, "solid")
                fill_bcParam!(bcParam, j.adsorbed, false, j.bot_bc_type, "solid")
            end
        else
            fill_bcParam!(bcParam, i.substance, true, i.top_bc_type, i.type)
            fill_bcParam!(bcParam, i.substance, false, i.bot_bc_type, i.type)
        end
    end

    bcParam = @transform!(bcParam, :class = "BoundaryCondition")




    tran_code, tran_expr, tran_cache, ads_str = transport_code(substances, adsorption)


    react_code, parsing_df, species_modelled, react_expr, react_cache, pHspecies =
        reaction_code(
            reactions,
            substances,
            speciation,
            adsorption,
            modelconfig.CompleteFlux,
            modelconfig.AllowDiscontinuity,
        )

    cache_str = unique(vcat(react_cache, tran_cache))
    @unpack species_model_df, species_extra_df, elements_df = parsing_df


    react_jp, react_param = jac_react_dependence(
        species_model_df,
        species_modelled,
        react_expr,
        cache_str,
        ads_str,
        adsorption,
        pHspecies,
    )

    @subset!(
        react_param,
        .!in.(:parameter, Ref(["dstopw", "pwtods", "phi", "Dbt", "Dbir", "alpha", "x"]))
    )


    adsParam = @subset(react_param, :type .== "adsorption")
    select!(adsParam, :parameter, :type)
    @transform!(adsParam, :class = "adsorption")
    @transform!(adsParam, :type = "const")
    @transform!(adsParam, :value = "")
    @transform!(adsParam, :unit = "")
    @transform!(adsParam, :comment = "Adsorption constant")
    @select!(adsParam, :type, :parameter, :value, :unit, :comment)


    dissolved_ads = @subset(substances, :type .== "dissolved_adsorbed")
    for i in eachrow(dissolved_ads)
        push!(
            adsParam,
            [
                "const",
                "K$(i.substance)_ads",
                "",
                "cm^3(porewater) cm^-3(dry sediment)",
                "Adsorption constant",
            ],
        )
    end
    @transform!(adsParam, :class = "adsorption")


    reacParam = @subset(react_param, :type .!= "adsorption")
    @transform!(reacParam, :type = "const")
    @transform!(reacParam, :value = "")
    @transform!(reacParam, :unit = "")
    @transform!(reacParam, :comment = "appears in " .* :comment)
    @select!(reacParam, :type, :parameter, :value, :unit, :comment)
    @transform!(reacParam, :class = "Reaction")


    dissolved =
        subset(substances, :type => x -> x .∈ Ref(["dissolved", "dissolved_adsorbed"]))

    dis_sp_all = vcat(dissolved.substance, adsorption.dissolved)



    model_name1 = ["TH3PO4", "TNH4", "TH4SiO4", "TH2S", "THF", "TH3BO3", "THSO4", "TCO2"]
    species_name1 = ["HPO4", "NH4", "H4SiO4", "HS", "F", "H3BO3", "SO4", "HCO3"]

    model_name2 = ["Al", "Mo"]
    species_name2 = ["Al(OH)[4]", "MoO4"]

    model_name = [model_name1; model_name2]
    species_name = [species_name1; species_name2]

    dict = Dict(model_name[i] => species_name[i] for i in eachindex(model_name))

    dis_sp_all_new =
        ifelse.(
            in.(dis_sp_all, Ref(keys(dict))),
            get.(Ref(dict), dis_sp_all, missing),
            dis_sp_all,
        )

    species_default = [
        "O2",
        "NO3",
        "NO2",
        "Mn",
        "Fe",
        "SO4",
        "HSO4",
        "NH4",
        "NH3",
        "PO4",
        "HPO4",
        "H2PO4",
        "H3PO4",
        "CO2",
        "HCO3",
        "CO3",
        "H2S",
        "HS",
        "CH4",
        "H",
        "Ca",
        "H4SiO4",
        "H3SiO4",
        "HF",
        "F",
        "OH",
        "H3BO3",
        "H4BO4",
        "Al(OH)[4]",
        "MoO4",
        "Nd",
        "Nd144",
        "Nd143",
        "Ndnr",
        "Ndr",
    ]

    diffusionParam = newdf()
    for i in dis_sp_all_new
        if !(i in species_default)
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
    @transform!(parameters,:include = 1)

    return parameters
end

end
