function generat_parameter_template(input_path::String)
    template_path = replace(input_path, r".xlsx" => "_parameter_template.xlsx")
    if template_path in readdir()
            throw(
                error(
                    "A parameter template $template_path already exist in the directory. If you want to generate a new one, delete the template first!",
                ),
            )
        else
            param_template = generat_template(input_path)
        end
end

function generat_template(input_path::String)

    model_config = XLSX.readxlsx(input_path)

    options = @chain begin
        DataFrame(XLSX.gettable(model_config["options"]))
        @transform(:options = replace.(:options, r"\s" => ""))
        @transform(:value = replace.(:value, r"\s" => ""))
        @transform(:value = lowercase.(:value))
    end

    uniform_grid = getval!(options, :options, "uniform_grid", :value) == "yes"
    constant_porosity_profile =
        getval!(options, :options, "constant_porosity_profile", :value) == "yes"
    default_porosity_constant =
        getval!(options, :options, "default_porosity_constant", :value) == "yes"
    constant_bioturbation_profile =
        getval!(options, :options, "constant_bioturbation_profile", :value) ==
        "yes"
    default_bioturbation_constant =
        getval!(options, :options, "default_bioturbation_constant", :value) ==
        "yes"
    constant_bioirrigation_profile =
        getval!(options, :options, "constant_bioirrigation_profile", :value) ==
        "yes"
    default_bioirrigation_constant =
        getval!(options, :options, "default_bioirrigation_constant", :value) ==
        "yes"
    default_total_sediment_flux =
        getval!(options, :options, "default_total_sediment_flux", :value) ==
        "yes"


    globalParam = @chain begin
        newdf()
        push!(["const", "depth", "", "m", "water depth"],)
        push!(["const", "salinity", "", "psu", "bottom water salinity"],)
        push!(["const", "temp", "", "Celsius", "bottom water temperature"],)
        push!(["const", "ds_rho", "", "g cm^-3", "dry sediment density"],)
        @transform(:class = "global")
    end


    gridParam = @chain begin
        newdf()
        push!(["const", "L", "", "cm", "model sediment section thickness"],)
        push!(["const", "Ngrid", "", "integer", "number of model grid"],)
        if !uniform_grid
            push!(
                _,
                [
                    "function",
                    "gridtran(x)",
                    "",
                    "cm",
                    "return a non-uniform grid by transforming a uniform one, if the functions requires external constants, enter in the row underneath",
                ],
            )
        else
            _
        end
        @transform(:class = "grid")
    end

    porosityParam = @chain begin
        newdf()
        if !constant_porosity_profile
            push!(
                _,
                [
                    "function",
                    "phi(x)",
                    "",
                    "dimentionless",
                    "return a depth-dependent porosity profile, if the functions requires external constants, enter in the row underneath",
                ],
            )
            push!(
                _,
                [
                    "const",
                    "phi_Inf",
                    "",
                    "dimentionless",
                    "porosity at infinite sediment depth (normally where porosity stops changing). Needed to calculate burial velocities. If constant_porosity_profile = no, then phi_Inf should be consistent with the depth dependent porosity function",
                ],
            )
        else
            if !default_porosity_constant
                push!(_, ["const", "phi", "", "dimentionless", "constant porosity"])
                push!(
                    _,
                    [
                        "const",
                        "phi_Inf",
                        "",
                        "dimentionless",
                        "porosity at infinite sediment depth (normally where porosity stops changing). Needed to calculate burial velocities. If constant_porosity_profile = yes, then phi_Inf should be the same as the porosity constant.",
                    ],
                )
            else
                _
            end
        end
        @transform(:class = "porosity")
    end

    burialParam = @chain begin
        newdf()
        if !default_total_sediment_flux
            push!(_, ["const", "Fsed", "", "g cm^-2 yr^-1", "total sediment flux"])
        else
            _
        end
        @transform(:class = "burial")
    end


    bioturbationParam = @chain begin
        newdf()

        if !constant_bioturbation_profile
            push!(
                _,
                [
                    "function",
                    "Dbt(x)",
                    "",
                    "dimentionless",
                    "return a depth-dependent bioturbation profile, if the functions requires external constants, enter in the row underneath",
                ],
            )
        else
            if !default_bioturbation_constant
                push!(
                    _,
                    [
                        "const",
                        "Dbt",
                        "",
                        "dimentionless",
                        "constant bioturbation",
                    ],
                )
            else
                _
            end
        end
        @transform(:class = "bioturbation")
    end



    bioirrigationParam = @chain begin
        newdf()
        if !constant_bioirrigation_profile
            push!(
                _,
                [
                    "function",
                    "Dbir(x)",
                    "",
                    "dimentionless",
                    "return a depth-dependent bioirrigation profile, if the functions requires external constants, enter in the row underneath",
                ],
            )
        else
            if !default_bioirrigation_constant
                push!(
                    _,
                    [
                        "const",
                        "Dbir",
                        "",
                        "dimentionless",
                        "constant bioirrigation",
                    ],
                )
            else
                _
            end
        end
        @transform(:class = "bioirrigation")
    end


    substances = @chain begin
        DataFrame(XLSX.gettable(model_config["substances"]))
        @transform(:substance = replace(:substance, r"\s" => ""))
        @transform(:type = replace(:type, r"\s" => ""))
        @transform(:top_bc_type = lowercase.(replace(:top_bc_type, r"\s" => "")))
        @transform(:bot_bc_type = lowercase.(replace(:bot_bc_type, r"\s" => "")))
    end

    adsParam = @chain begin
        newdf()
    end
    dissolved_ads = @subset(substances,:type.=="dissolved_adsorbed")
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
    adsParam = @transform(adsParam,:class = "adsorption")

    bc_options = @chain begin
        DataFrame(XLSX.gettable(model_config["substances"]))
        @transform(:substance = replace(:substance, r"\s" => ""))
        @transform(:type = replace(:type, r"\s" => ""))
        @transform(:top_bc_type = lowercase.(replace(:top_bc_type, r"\s" => "")))
        @transform(:bot_bc_type = lowercase.(replace(:bot_bc_type, r"\s" => "")))
    end


    bcParam = @chain begin
        newdf()
    end

    if "H" ∈ bc_options.substance
        if length(unique(getvalALL!(bc_options,:type,"dissolved_summed_pH",:top_bc_type)))!=1
             throw(error("Dissolved_summed substances must have the same type of TOP boundary conditions!"))
        end
        if length(unique(getvalALL!(bc_options,:type,"dissolved_summed_pH",:bot_bc_type)))!=1
            throw(error("Dissolved_summed substances must have the same type of BOTTOM boundary conditions!"))
        end
    end

    option_beta = any((bc_options.type .∈ Ref(["dissolved","dissolved_summed","dissolved_summed_pH"])).& (bc_options.top_bc_type .== "robin"))

        if option_beta
            push!(bcParam,
            [
                "const",
                "delta",
                "",
                "cm",
                "thickness of the diffusive boundary layer",
            ],)
        end



    # test if substance type and boundary condition type are compatible
    function iscompatible(substance_type, bc_type, top)
        if top
            if bc_type in ["robin", "dirichlet"] &&
               substance_type in ["solid", "dissolved", "dissolved_summed","dissolved_summed_pH"]
                return true
            elseif bc_type in ["dirichlet"] &&
                   substance_type in ["dissolved_adsorbed","dissolved_adsorbed_summed"]
                return true
            else
                return false
            end
        else
            if bc_type in ["neumann", "dirichlet"]
                return true
            else
                return false
            end
        end
    end

    # error checking
    for i in eachrow(bc_options)
        if !(i.top_bc_type in ["robin", "neumann", "dirichlet"])
            throw(
                error(
                    "Boundary condition type " *
                    top_bc_type *
                    " is not recognized!",
                ),
            )
        end
        if !(i.bot_bc_type in ["robin", "neumann", "dirichlet"])
            throw(
                error(
                    "Boundary condition type " *
                    bot_bc_type *
                    " is not recognized!",
                ),
            )
        end

        if !iscompatible(i.type, i.top_bc_type, true)
            throw(
                error(
                    "Top boundary condition type " *
                    i.top_bc_type *
                    " is not compatible with substance type " *
                    i.type,
                ),
            )
        end
        if !iscompatible(i.type, i.bot_bc_type, false)
            throw(
                error(
                    "Bottom boundary condition type " *
                    i.bot_bc_type *
                    " is not compatible with substance type " *
                    i.type,
                ),
            )
        end
    end




    function fill_bcParam!(df, substance,top, bc_type, substance_type)
        if bc_type == "robin"
            if substance_type == "solid"
                push!(
                    df,
                    [
                        "const",
                        "F" * substance * "0",
                        "",
                        "mmol cm^-2 yr^-1",
                        "Flux of " *
                        substance *
                        " at the  TOP of sediment column",
                    ],
                )
            elseif substance_type in
                   ["dissolved", "dissolved_summed", "dissolved_adsorbed","dissolved_summed_pH","dissolved_adsorbed_summed"]
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
                    (substance == "H" ? "pH" : substance) *
                    (top ? "0" : "L"),
                    "",
                    substance == "H" ? "free pH scale" : "mmol cm^-3",
                    (
                        substance == "H" ? "pH" :
                        "Concentration of " * substance
                    ) *
                    " at the " *
                    (top ? "TOP" : "BOTTOM") *
                    " of sediment column",
                ],
            )
        end
    end

    for i in eachrow(bc_options)
        fill_bcParam!(bcParam,i.substance, true, i.top_bc_type, i.type)
    end
    for i in eachrow(bc_options)
        fill_bcParam!(bcParam,i.substance, false, i.bot_bc_type, i.type)
    end

    bcParam = @transform(bcParam, :class = "BoundaryCondition")



    parameters = @chain begin
        globalParam
        append!(gridParam)
        append!(porosityParam)
        append!(burialParam)
        append!(bioturbationParam)
        append!(bioirrigationParam)
        append!(adsParam)
        append!(bcParam)
        select!(:class, :type, :parameter, :value, :unit, :comment)
    end
    return parameters

    # println(
    #     "A template to enter parameters is created and save to " *
    #     template_path,
    # )
    # println(
    #     "Copy and paste the `parameters` spreadsheet to " *
    #     input_path *
    #     " and enter the parameter values.",
    # )

    # XLSX.writetable(
    #     template_path,
    #     overwrite = true,
    #     parameters = (
    #         collect(DataFrames.eachcol(parameters)),
    #         DataFrames.names(parameters),
    #     ),
    # )

end
