function initval_code!(substances, param_str,assemble)
    # inival_str = String[]

    indexParam = newdf()
    abtolParam = newdf()

    header = assemble ? "" : "const "
    push!(
        param_str,
        header*"C0 = repeat(C_ini,outer = Ngrid) # initial conditions",
    )

    if "abtol" ∈ names(substances)

        push!(
            abtolParam,
            [
                "const",
                "abtol",
                "repeat(abtol0,outer = Ngrid)",
                "",
                "absolute tolerance",
            ],
        )
    end
    indexDict = String[]

    for i in eachrow(substances)
        push!(
                indexParam,
                ["const", "$(i.substance)ID"," ((1:Ngrid).-1)nspec.+$(i.order)","", "$(i.substance) index"],
        )
        push!(indexDict,":$(i.substance)ID=>$(i.substance)ID")
    end

    appendtostr!(param_str, abtolParam, "Tolerance parameters",assemble)
    appendtostr!(param_str, indexParam, "Indices",assemble)

    push!(param_str,
    "$(assemble ? "" : "const ") IDdict = Dict($(join(indexDict,",")))")

    return nothing
end