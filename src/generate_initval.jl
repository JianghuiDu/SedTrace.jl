function initval_code(jac_type, substances, param_str)
    # inival_str = String[]

    indexParam = newdf()
    abtolParam = newdf()


    if jac_type == "banded"
        ini_type = "outer"
    elseif jac_type == "Notbanded"
        ini_type = "inner"
    end

    push!(
        param_str,
        "const C_uni = repeat(C_ini,$(ini_type) = Ngrid) # initial conditions",
    )

    if "abtol" ∈ names(substances)

        push!(
            abtolParam,
            [
                "const",
                "abtol",
                "repeat(abtol0,$(ini_type) = Ngrid)",
                "",
                "absolute tolerance",
            ],
        )
    end
    indexDict = String[]

    for i in eachrow(substances)
        if jac_type == "banded"
            push!(
                indexParam,
                ["const", "$(i.substance)ID"," ((1:Ngrid).-1)nspec.+$(i.order)","", "$(i.substance) index"],
            )
        elseif jac_type == "Notbanded"
            push!(
                indexParam,
                ["const", "$(i.substance)ID", "($((i.order)-1)*Ngrid+1):1:($(i.order)*Ngrid)","", "$(i.substance) index"],
            )
        end
        push!(indexDict,"\"$(i.substance)\"=>$(i.substance)ID")
    end

    appendtostr!(param_str, abtolParam, "Tolerance parameters")
    appendtostr!(param_str, indexParam, "Indices")

    push!(param_str,
    "const IDdict = Dict($(join(indexDict,",")))")

    return nothing
end