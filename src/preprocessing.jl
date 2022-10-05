
function checkismissing!(df::DataFrame,cols::Vector{Symbol},col_id::Symbol,sheet::String)
    if !isempty(df)
        for i in eachindex(df[!,col_id])
            for j in cols
                if ismissing(df[i,j])
                    throw(error(
                        "The row $i of column $j in Excel sheet [$sheet] is emtpy."
                    ))
                end
            end
        end
    end
end

# test if substance type and boundary condition type are compatible
function iscompatible(substance_type, bc_type, top)
    if top
        if bc_type in ["robin", "dirichlet"] && substance_type in
           ["solid", "dissolved", "dissolved_summed", "dissolved_summed_pH"]
            return true
        elseif bc_type in ["dirichlet"] &&
               substance_type in ["dissolved_adsorbed", "dissolved_adsorbed_summed"]
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


function check_illegal_char(df::DataFrame, reg = r"[^\+\-\*\/\{\}\[\]\(\)\=\w\.\,\^]")
    # check illegal characters in dataframe, throw errors
    for i in axes(df, 2)
        for j in axes(df, 1)
            str_match = passmissing(mymatch)(reg, passmissing(string)(df[j, i]))
            if !ismissing(str_match)
                if !isnothing(str_match)
                    throw(error(df[j, i] * " contains illegal characters " * str_match))
                end
            end
        end
    end
end


function checkerrorParameters!(param_model::DataFrame)

    #-----------------------------------------------------------------------------
    #error checking
    #-----------------------------------------------------------------------------
    for i in eachrow(param_model)
        if ismissing(i.parameter)
            throw(error("A parameter is missing at row `" * join(i, ";") * "`!"))
        elseif ismissing(i.value)
            throw(error("Parameter $(i.parameter)  does not have a value!"))
        end
    end


    Require = DataFrame(
        parm = [
            "L",
            "Ngrid",
            "depth",
            "salinity",
            "temp",
            "ds_rho",
            "phi_Inf",
            "Fsed",
            "gridtran",
            "phi",
            "Dbt",
            "Dbir",
        ],
        comment = [
            "model sediment section thickness",
            "number of model grid",
            "water depth",
            "bottom water salinity",
            "bottom water temperature",
            "dry sediment density",
            "porosity at infinite sediment depth",
            "total sediment flux",
            "grid transformation function",
            "porosity function",
            "bioturbation coefficient function",
            "bioirrgation coefficient function",
        ],
    )


    for i in eachrow(Require)
        if !(i.parm in param_model.parameter)
            throw(
                error(
                    "Parameter $(i.parm) [$(i.comment)] is required but not found in the spreadsheet!",
                ),
            )
        end
    end

end

function checkerrorSubstance!(substances::DataFrame)
    # check type
    allowed_type = ["solid","dissolved","dissolved_adsorbed","dissolved_adsorbed_summed","dissolved_summed","dissolved_summed_pH"]
    list_summed_species =
    ["TCO2", "TNH4", "TH3PO4", "TH2S", "THSO4", "TH3BO3", "THF", "TH4SiO4", "H"]

    for i in eachrow(substances)
        if !(i.type in allowed_type)
            throw(error("The type of $(i.substance) is $(i.type), which is not allowed. Allowed types are: $(join(allowed_type,","))"
            ))
        end
        if i.type in ["dissolved_summed","dissolved_summed_pH"]
            if !(i.substance in list_summed_species)
                throw(
                    error("A substance with dissolved_summed or dissolved_summed_pH type must be from this list: $(join(list_summed_species,",")). $(i.substance) is not from this list.")
                )
            else
                i.formula = join(EquilibriumInvariant(i.substance).species,",")
            end
        end
    end

    # check boundary conditions
    for i in eachrow(substances)
        if !(i.top_bc_type in ["robin", "neumann", "dirichlet"])
            throw(error("Boundary condition type " * top_bc_type * " is not recognized!"))
        end
        if !(i.bot_bc_type in ["robin", "neumann", "dirichlet"])
            throw(error("Boundary condition type " * bot_bc_type * " is not recognized!"))
        end

        if !iscompatible(i.type, i.top_bc_type, true)
            throw(
                error(
                    "Top boundary condition type of $(i.substance) " *
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
                    " is not compatible with substance type." *
                    i.type,
                ),
            )
        end
    end

end



function preprocessSubstances!(substances::DataFrame, EnableList::Dict = Dict())
    for i in [
        "substance",
        "type",
        "formula",
        "top_bc_type",
        "bot_bc_type",
        "bioirrigation_scale",
        "include",
    ]
        if !(i in names(substances))
            throw(error("Column $i is not found in Sheet substances."))
        end
    end

    if haskey(EnableList, "substances")
        for i in EnableList["substances"]
            if !in(i, substances.substance)
                throw(error("$i is not a substance!"))
            else
                setval!(substances, :substance, i, :include, 1)
            end
        end
    end

    # remove empty space or weird minus signs
    df_str_replace!(substances, [r"\s", r"[\u2212\u2014\u2013]"], ["", "\u002D"])

    subset!(substances, :include => ByRow(!ismissing))
    select!(substances, Not(:include))

    check_illegal_char(substances)
    checkismissing!(substances,[:substance,:type,:top_bc_type,:bot_bc_type],:substance,"substances")

    transform!(
        substances,
        :bioirrigation_scale => x -> ifelse.(ismissing.(x), "", x),
        renamecols = false,
    )


    transform!(
        substances,
        [:top_bc_type, :bot_bc_type] .=> ByRow(x -> lowercase(x)),
        renamecols = false,
    )
    checkerrorSubstance!(substances)

    # ord = [
    #     "dissolved_adsorbed_summed",
    #     "solid",
    #     "dissolved",
    #     "dissolved_adsorbed",
    #     "dissolved_summed",
    #     "dissolved_summed_pH",
    # ]
    # orderdict = Dict(x => i for (i, x) in enumerate(ord))
    # sort!(substances, :type, by = x -> orderdict[x])
    insertcols!(substances, :order => 1:length(substances.substance))
    select!(substances,:substance,:type,:formula,:top_bc_type,:bot_bc_type,:bioirrigation_scale,:order)
end






function preprocessReactions!(reactions::DataFrame, EnableList::Dict = Dict())
    for i in ["label", "equation", "rate", "Omega", "check", "include"]
        if !(i in names(reactions))
            throw(error("Column $i is not found in Sheet reactions."))
        end
    end
    if haskey(EnableList, "reactions")
        for i in EnableList["reactions"]
            if !in(i, reactions.label)
                throw(error("$i is not a reaction!"))
            else
                setval!(reactions, :label, i, :include, 1)
            end
        end
    end

    subset!(reactions, :include => ByRow(!ismissing))
    select!(reactions, Not(:include))
    df_str_replace!(reactions, [r"\s", r"[\u2212\u2014\u2013]"], ["", "\u002D"])
    check_illegal_char(reactions)

    checkismissing!(reactions,	[ :label, :equation, :rate],:label,"reactions")

    select!(reactions,	:check, :label, :equation, :rate, :Omega)
end






function preprocessSpeciation!(speciation::DataFrame, EnableList::Dict = Dict())
    for i in ["substance", "dissolved","formula", "equation", "logK", "include"]
        if !(i in names(speciation))
            throw(error("Column $i is not found in Sheet speciation."))
        end
    end
    if haskey(EnableList, "speciation")
        for i in EnableList["speciation"]
            if !in(i, speciation.label)
                throw(error("$i is not an aqueous species"))
            else
                setval!(speciation, :dissolved, i, :include, 1)
            end
        end
    end

    subset!(speciation, :include => ByRow(!ismissing))
    select!(speciation, Not(:include))
    df_str_replace!(speciation, [r"\s", r"[\u2212\u2014\u2013]"], ["", "\u002D"])

    check_illegal_char(speciation)
    checkismissing!(speciation,[:substance,:dissolved,:formula,:equation,:logK],:dissolved,"speciation")

    @transform!(speciation,:formula_ = split.(:formula,"{"))
    @transform!(speciation,:formula_ = getindex.(:formula_,1))
    insertcols!(speciation, :K => 10.0 .^ parse.(Float64, speciation.logK))
    select!(speciation, Not(:logK))
    insertcols!(speciation, :check .=> 1)
    select!(speciation,:check,:substance,:dissolved,:formula,:formula_,:equation,:K)
end






function preprocessAdsorption!(adsorption::DataFrame, EnableList::Dict = Dict())
    for i in [
        "substance",
        "dissolved",
        "adsorbed",
        "surface",
        "expression",
        "top_bc_type",
        "bot_bc_type",
        "include",
    ]
        if !(i in names(adsorption))
            throw(error("Column $i is not found in Sheet adsorption."))
        end
    end
    if haskey(EnableList, "adsorption")
        for i in EnableList["adsorption"]
            if !in(i, adsorption.adsorbed)
                throw(error("$i is not an adsorbed species"))
            else
                setval!(adsorption, :adsorbed, i, :include, 1)
            end
        end
    end
    subset!(adsorption, :include => ByRow(!ismissing))
    select!(adsorption, Not(:include))
    df_str_replace!(adsorption, [r"\s", r"[\u2212\u2014\u2013]"], ["", "\u002D"])


    check_illegal_char(adsorption)
    checkismissing!(
        adsorption,
        [:substance,:dissolved,:adsorbed,:expression, :top_bc_type,:bot_bc_type],
        :adsorbed,"adsorption"
    )


    transform!(
        adsorption,
        [:top_bc_type, :bot_bc_type] .=> ByRow(x -> lowercase(x)),
        renamecols = false,
    )
    select!(adsorption,:substance,
    :dissolved,
    :adsorbed,
    :surface,
    :expression,
    :top_bc_type,
    :bot_bc_type)
end






function preprocessParameters!(
    parameters::DataFrame,
    ParamDict::Dict = Dict(),
    EnableList::Dict = Dict(),
)
    for i in ["class", "type", "parameter", "value", "unit", "include"]
        if !(i in names(parameters))
            throw(error("Column $i is not found in Sheet parameters."))
        end
    end
    if !isempty(ParamDict)
        for (key, value) in ParamDict
            if !in(key, parameters.parameter)
                throw(error("$key is not a parameter!"))
            else
                setval!(parameters, :parameter, key, :value, value)
            end
        end
    end
    if haskey(EnableList, "parameters")
        for i in EnableList["parameters"]
            if !in(i, parameters.parameter)
                throw(error("$i is not a parameter!"))
            else
                setval!(parameters, :parameter, i, :include, 1)
            end
        end
    end

    subset!(parameters, :include => ByRow(!ismissing))
    select!(parameters, Not(:include))
    checkismissing!(parameters,[:class, :type, :parameter, :value],:parameter,"parameters")


    transform!(
        parameters,
        [:class, :type, :parameter] .=> ByRow(x -> replace(x, r"\s" => "")),
        renamecols = false,
    )
    transform!(
        parameters,
        :value => ByRow(
            x ->
                (typeof(x) <: Real || !isnothing(tryparse(Float64, x))) ? x :
                replace(x, r"\s" => ""),
        ),
        renamecols = false,
    )

    check_illegal_char(select(parameters, :class, :type, :parameter, :value))

    checkerrorParameters!(parameters)
    select!(parameters,:class, :type, :parameter, :value, :unit,:comment)
end







function preprocessOutput!(output::DataFrame, EnableList::Dict = Dict())
    for i in ["name", "expression", "conversion_profile", "unit_profile", "include","flux_top","conversion_flux","unit_flux","flux_top_measured"]
        if !(i in names(output))
            throw(error("Column $i is not found in Sheet output."))
        end
    end
    if haskey(EnableList, "output")
        for i in EnableList["output"]
            if !in(i,output.name)
                throw(error("$i is not in the output!"))
            else
                setval!(output, :name, i, :include, 1)
            end
        end
    end

    subset!(output, :include => ByRow(!ismissing))
    select!(output, Not(:include))
    df_str_replace!(output, [r"\s", r"[\u2212\u2014\u2013]"], ["", "\u002D"])

    check_illegal_char(select(output,:name,:expression,:conversion_profile))
    checkismissing!(output,[:name,:conversion_profile],:name,"output")

end