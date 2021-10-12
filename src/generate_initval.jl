function initval_code(jac_type, substances)
    inival_str = String[]

    if jac_type == "banded"
        ini_type = "outer"
    elseif jac_type == "Notbanded"
        ini_type = "inner"
    end

    push!(
        inival_str,
        "const C_uni = repeat(C_ini,$(ini_type) = Ngrid); # initial conditions",
    )
    if "abtol" ∈ names(substances)
        push!(
            inival_str,
            "const abtol = repeat(abtol0,$(ini_type) = Ngrid); # absolute tolerance",
        )
    end

    for i in eachrow(substances)
        if jac_type == "banded"
            push!(
                inival_str,
                "const $(i.substance)ID = ((1:Ngrid).-1)nspec.+$(i.order) # $(i.substance) index",
            )
        elseif jac_type == "Notbanded"
            push!(
                inival_str,
                "const $(i.substance)ID = ($((i.order)-1)*Ngrid+1):1:($(i.order)*Ngrid) # $(i.substance) index",
            )
        end
    end

    return inival_str
end