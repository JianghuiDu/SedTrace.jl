function transport_code(substances, options, ::Val{true})
    MTK = true
    nsolid = sum(substances.type .== "solid")
    ndissolved =
        sum(substances.type .∈ Ref(["dissolved", "dissolved_adsorbed", "dissolved_summed"]))
    nsummed = sum(substances.type .== "dissolved_summed_pH")

    tran_cache = String[]
    C_views = String[]
    dC_views = String[]
    A_str = String[]
    bc_str1 = String[]
    bc_strN = String[]
    alpha_str = String[]
    ads_str = String[]

    bc_type(x, y) =
        x == "robin" ? "BW" :
        (
            x == "dirichlet" ? "0" :
            throw(error("Boundary condition of type $x is not allowed for $y !"))
        )

    constant_porosity_profile =
        getval!(options, :options, "constant_porosity_profile", :value) == "yes"
    dstopw1 = constant_porosity_profile ? "dstopw" : "dstopw[1]"
    dstopwN = constant_porosity_profile ? "dstopw" : "dstopw[Ngrid]"

    for i in eachrow(substances)
        push!(C_views, "$(i.substance) = @view C[$(i.substance)ID]")
        push!(dC_views, "d$(i.substance) = @view dC[$(i.substance)ID]")
        if i.type ∈ ["solid", "dissolved", "dissolved_summed"]
            push!(A_str, "d$(i.substance) .= Am$(i.substance) * $(i.substance)")
            push!(
                bc_str1,
                "d$((i.substance))[1] += BcAm$((i.substance))[1]*$((i.substance))[1] + BcCm$((i.substance))[1]",
            )
            push!(
                bc_strN,
                "d$((i.substance))[Ngrid] += BcAm$((i.substance))[2]*$((i.substance))[Ngrid] + BcCm$((i.substance))[2]",
            )
        end
        if i.type ∈ ["dissolved", "dissolved_summed"]
            push!(
                alpha_str,
                "d$(i.substance) += alpha.*($(i.substance)$(bc_type(i.top_bc_type,i.substance)).-$(i.substance))",
            )
        end
        if i.type == "dissolved_adsorbed"
            push!(tran_cache, "$(i.substance)_ads")
            push!(ads_str, "$((i.substance))_ads = $(i.substance).*K$((i.substance))_ads")
            push!(
                ads_str,
                "d$(i.substance) .= Am$((i.substance))_ads * $((i.substance))_ads",
            )
            push!(ads_str, "d$(i.substance) = d$(i.substance).*dstopw")
            push!(ads_str, "d$(i.substance) += Am$(i.substance) * $(i.substance)")
            push!(
                ads_str,
                "d$(i.substance)[1] += (BcAm$((i.substance))_ads[1]*$((i.substance))_ads[1]+BcCm$((i.substance))_ads[1])*$dstopw1",
            )
            push!(
                ads_str,
                "d$(i.substance)[1] += BcAm$(i.substance)[1]*$(i.substance)[1]+BcCm$(i.substance)[1]",
            )
            push!(
                ads_str,
                "d$(i.substance)[Ngrid] += (BcAm$((i.substance))_ads[2]*$((i.substance))_ads[Ngrid]+BcCm$((i.substance))_ads[2])*$dstopwN",
            )
            push!(
                ads_str,
                "d$(i.substance)[Ngrid] += BcAm$(i.substance)[2]*$(i.substance)[Ngrid]+BcCm$(i.substance)[2]",
            )
            push!(
                ads_str,
                "d$(i.substance) += alpha .* ($((i.substance))0 .- $(i.substance))",
            )
            push!(
                ads_str,
                "d$(i.substance) = d$(i.substance)./(1.0.+dstopw.*K$((i.substance))_ads)",
            )

            push!(ads_str, " ")
        end
    end

    species_summed_pH = @subset(substances, :type .== "dissolved_summed_pH")

    if length(species_summed_pH.substance) != 0
        if !("H" ∈ species_summed_pH.substance)
            throw(error("Proton H must be included in the dissolved_summed_pH species!"))
        end
    end

    subspecies = String[]
    subspecies_scrpt = String[]
    species_conc_str = String[]
    TA_tran_str = String[]
    Tsum_str = String[]
    dH_str = String[]
    append!(dH_str, ["dH .= TA_tran"])
    dTA_dTsum_str = String[]
    dTA_dH_str = String[]

    n_summed = length(species_summed_pH.substance)


    j = 0
    n_subspecies = 0
    for i in species_summed_pH.substance
        if !(i in list_summed_species)
            throw(
                error(
                    "dissolved_summed_pH species must be from this list: $list_summed_species. $i is not in the list.",
                ),
            )
        else
            tmp = EquilibriumInvariant(i)
            bc = getval!(species_summed_pH, :substance, i, :top_bc_type)
            append!(subspecies, tmp.species)
            append!(subspecies_scrpt, fill(bc_type(bc, i), length(tmp.species)))
            append!(
                TA_tran_str,
                [
                    "TA_tran" *
                    ifelse(j == 0, " = ", " += ") *
                    join(tmp.coef .* "*" .* tmp.species .* "_tran", "+"),
                ],
            )
            append!(dTA_dH_str, ["dTA_dH" * ifelse(j == 0, " = ", " += ") * tmp.dTAdH])

            if i != "H"
                append!(Tsum_str, ["d$i = $(join(tmp.species .* "_tran", "+"))"])
                append!(dH_str, ["dH -= d$i*dTA_d$i"])
                append!(species_conc_str, tmp.species .* "=" .* tmp.expr)
                append!(dTA_dTsum_str, ["dTA_d$i = " * tmp.dTAdsum])
                n_subspecies += length(tmp.species)
            else
                push!(species_conc_str, tmp.species[2] .* "=" .* tmp.expr[2])
                n_subspecies += 1

            end

            j += 1
        end
    end

    species_summed = @subset(substances, :type .== "dissolved_summed")

    subspecies_non_pH = String[]
    species_conc_str_non_pH = String[]
    for i in species_summed.substance
        if !(i in list_summed_species)
            throw(
                error(
                    "dissolved_summed species must be from this list: $list_summed_species. $i is not in the list.",
                ),
            )
        else
            tmp = EquilibriumInvariant(i)
            append!(subspecies_non_pH, tmp.species)
            append!(species_conc_str_non_pH, tmp.species .* "=" .* tmp.expr)
        end
    end



    append!(dH_str, ["dH = dH/dTA_dH"])


        pH_code = vcat(
            replace.(species_conc_str, r"(?<!\de)[\+\-\*\/\^](?!\=)" => s" .\g<0>"),
            "  ",
            replace.(dTA_dTsum_str, r"(?<!\de)[\+\-\*\/\^](?!\=)" => s" .\g<0>"),
            "  ",
            replace.(dTA_dH_str, r"(?<!\de)[\+\-\*\/\^](?!\=)" => s" .\g<0>"),
            "   ",
            replace.(species_conc_str_non_pH, r"(?<!\de)[\+\-\*\/\^](?!\=)" => s" .\g<0>")
        )


    append!(pH_code, [" "])

    for i = 1:length(subspecies)
        push!(
            pH_code,
            "$(subspecies[i])_tran = Am$(subspecies[i]) * $(subspecies[i])",
        )
        push!(
            pH_code,
            "$(subspecies[i])_tran[1] += BcAm$(subspecies[i])[1]*$(subspecies[i])[1]+BcCm$(subspecies[i])[1]",
        )
        push!(
            pH_code,
            "$(subspecies[i])_tran[Ngrid] += BcAm$(subspecies[i])[2]*$(subspecies[i])[Ngrid]+BcCm$(subspecies[i])[2]",
        )
        push!(
            pH_code,
            "$(subspecies[i])_tran += alpha .* ($(subspecies[i])$(subspecies_scrpt[i]) .- $(subspecies[i]))",
        )
        push!(pH_code, " ")
    end

    append!(pH_code, [" "])
    append!(pH_code, replace.(Tsum_str, r"\=" => ".="))
    append!(pH_code, [" "])
    append!(pH_code, replace.(TA_tran_str, r"(?<!\de)[\+\-\*\/\^](?!\=)" => s" .\g<0>"))
    append!(pH_code, [" "])
    append!(pH_code, replace.(dH_str, r"(?<!\de)[\+\-\*\/\^](?!\=)" => s" .\g<0>"))


    code = vcat(
        C_views,
        "",
        dC_views,
        "",
        A_str,
        "  ",
        bc_str1,
        bc_strN,
        "  ",
        alpha_str,
        "  ",
        ads_str,
        " ",
        pH_code,
    )

    append!(
        tran_cache,
        vcat(
            species_conc_str,
            species_conc_str_non_pH,
            subspecies .* "_tran",
            TA_tran_str,
            dTA_dH_str,
            dTA_dTsum_str,
        ),
    )
    tran_cache = split.(tran_cache, r"\=|\+\=|\*\=|\-\=|\/\=")
    tran_cache = unique([replace(i[1], r"\s" => "") for i in tran_cache])

    tran_expr =
        vcat(C_views, dC_views, A_str, bc_str1, bc_strN, alpha_str, ads_str, pH_code)
    filter!(x -> x != " ", tran_expr)
    tran_expr = replace.(tran_expr, r"@view C" => "")
    tran_expr = replace.(tran_expr, r"@view dC" => "")


    if !(j == n_summed) || !(length(species_conc_str) == n_subspecies)
        throw(error("incorrect number of inputs"))
    end

    return code, tran_expr, tran_cache

end

