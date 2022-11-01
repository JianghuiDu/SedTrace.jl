function transport_code(substances, adsorption)

    nsolid = sum(substances.type .== "solid")
    ndissolved = sum(
        substances.type .∈ Ref([
            "dissolved",
            # "dissolved_adsorbed",
            "dissolved_speciation",
        ]),
    )
    nsummed = sum(substances.type .== "dissolved_pH")

    tran_cache = String[]
    C_views = String[]
    dC_views = String[]
    A_str = String[]
    bc_str1 = String[]
    bc_strN = String[]
    alpha_str = String[]
    ads_str = String[]
    # ads_summed_expr_str = String[]

    bc_type(x, y) =
        x == "robin" ? "BW" :
        (
            x == "dirichlet" ? "0" :
            throw(error("Boundary condition of type $x is not allowed for $y !"))
        )
    dstopw1 = "dstopw[1]"
    dstopwN = "dstopw[Ngrid]"

    for i in eachrow(substances)
        push!(C_views, "$(i.substance) = @view C[$(i.substance)ID]")
        push!(dC_views, "d$(i.substance) = @view dC[$(i.substance)ID]")
        if i.type ∈ ["solid", "dissolved"]
            push!(A_str, "mul!(d$(i.substance), Am$(i.substance), $(i.substance))")
            push!(
                bc_str1,
                "d$((i.substance))[1] += BcAm$((i.substance))[1]*$((i.substance))[1] + BcCm$((i.substance))[1]",
            )
            push!(
                bc_strN,
                "d$((i.substance))[Ngrid] += BcAm$((i.substance))[2]*$((i.substance))[Ngrid] + BcCm$((i.substance))[2]",
            )
        end
        if i.type ∈ ["dissolved"]
            push!(
                alpha_str,
                "@. d$(i.substance) += $(i.bioirrigation_scale)alpha*($(i.substance)$(bc_type(i.top_bc_type,i.substance))-$(i.substance))",
            )
        end
        # if i.type == "dissolved_adsorbed"
        #     push!(tran_cache, "$(i.substance)_ads")
        #     push!(ads_str, "@. $((i.substance))_ads = $(i.substance)*K$((i.substance))_ads")
        #     push!(
        #         ads_str,
        #         "mul!(d$(i.substance),Am$((i.substance))_ads,$((i.substance))_ads)",
        #     )
        #     push!(ads_str, "@. d$(i.substance) *= dstopw")
        #     push!(
        #         ads_str,
        #         "mul!(d$(i.substance), Am$(i.substance), $(i.substance),1.0,1.0)",
        #     )
        #     push!(
        #         ads_str,
        #         "d$(i.substance)[1] += (BcAm$((i.substance))_ads[1]*$((i.substance))_ads[1]+BcCm$((i.substance))_ads[1])*$dstopw1",
        #     )
        #     push!(
        #         ads_str,
        #         "d$(i.substance)[1] += BcAm$(i.substance)[1]*$(i.substance)[1]+BcCm$(i.substance)[1]",
        #     )
        #     push!(
        #         ads_str,
        #         "d$(i.substance)[Ngrid] += (BcAm$((i.substance))_ads[2]*$((i.substance))_ads[Ngrid]+BcCm$((i.substance))_ads[2])*$dstopwN",
        #     )
        #     push!(
        #         ads_str,
        #         "d$(i.substance)[Ngrid] += BcAm$(i.substance)[2]*$(i.substance)[Ngrid]+BcCm$(i.substance)[2]",
        #     )
        #     push!(
        #         ads_str,
        #         "@. d$(i.substance) += $(i.bioirrigation_scale)alpha * ($((i.substance))0 - $(i.substance))",
        #     )
        #     # push!(ads_str, "@. d$(i.substance) /=1+dstopw*K$((i.substance))_ads")
        #     push!(ads_str, "@. d$(i.substance) *= 1/(1+dstopw*K$((i.substance))_ads)")

        #     push!(ads_str, " ")
        # end
        if i.type == "dissolved_speciation"
            ads_df = @subset(adsorption, :substance .== i.substance)
            @transform!(ads_df,:species = :substance .*"_ads",:type = "solid",:convfac = "dstopw")
            @select!(ads_df,:substance,:species,:type,:convfac)
            unique!(ads_df)
            # @select!(ads_df,:substance,:surface)
            # unique!(ads_df)
            # @transform!(ads_df,:species = ifelse.(ismissing.(:surface),:substance.*"_ads_nsf",:substance.*"_ads_".*:surface))
            # @select!(ads_df,:substance,:species)
            # @transform!(ads_df,:type="solid",:convfac ="dstopw")

            dis_sp = i.substance*"_dis"
            dis_df = DataFrame(substance=i.substance,species=dis_sp,type="dissolved",convfac="1")
            append!(dis_df,ads_df)

            for j in eachrow(dis_df)
                # push!(ads_summed_expr_str, "$(j.adsorbed) = $(j.expression)")
                push!(tran_cache, "$(j.species)")
                push!(tran_cache, "$(j.species)_tran")
                # push!(ads_str, "@. $(j.adsorbed) = $(j.expression)")
                push!(ads_str, "mul!($(j.species)_tran, Am$(j.species), $(j.species))")
                push!(
                    ads_str,
                    "$((j.species))_tran[1] += BcAm$((j.species))[1]*$((j.species))[1] + BcCm$((j.species))[1]",
                )
                push!(
                    ads_str,
                    "$((j.species))_tran[Ngrid] += BcAm$((j.species))[2]*$((j.species))[Ngrid] + BcCm$((j.species))[2]",
                )
            end
            push!(
                ads_str,
                "@. d$(i.substance) = "  *
                join(dis_df.species .* "_tran*" .* dis_df.convfac, "+"),
            )
            push!(
                ads_str,
                "@. d$(i.substance) += $(i.bioirrigation_scale)alpha*($(dis_sp)$(bc_type(i.top_bc_type,i.substance))-$(dis_sp))",
            )
            push!(ads_str, " ")
        end
    end

    if nsummed != 0
        species_summed_pH = @subset(substances, :type .== "dissolved_pH")

        subspecies = String[]
        subspecies_scrpt = String[]
        species_conc_str = String[]
        TA_tran_str = String[]
        Tsum_str = String[]
        dH_str = String[]
        append!(dH_str, ["dH = TA_tran"])
        dTA_dTsum_str = String[]
        dTA_dH_str = String[]

        n_summed = length(species_summed_pH.substance)
        # n_subspecies = sum(
        #     [3, 2, 4, 2, 2, 2, 2, 2, 1] .*
        #     [list[i] in species_summed_pH.substance for i = 1:length(list)],
        # )

        j = 0
        n_subspecies = 0
        for i in species_summed_pH.substance
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
                    append!(dTA_dTsum_str, ["dTA_d$i = " * tmp.dTAdEI])
                    n_subspecies += length(tmp.species)
                else
                    push!(species_conc_str, tmp.species[2] .* "=" .* tmp.expr[2])
                    n_subspecies += 1

                end

                j += 1
        end

        # species_summed = @subset(substances, :type .== "dissolved_summed")

        # subspecies_non_pH = String[]
        # species_conc_str_non_pH = String[]
        # for i in species_summed.substance
        #     if !(i in list_summed_species)
        #         throw(
        #             error(
        #                 "dissolved_summed species must be from this list: $list_summed_species. $i is not in the list.",
        #             ),
        #         )
        #     else
        #         tmp = EquilibriumInvariant(i)
        #         append!(subspecies_non_pH, tmp.species)
        #         append!(species_conc_str_non_pH, tmp.species .* "=" .* tmp.expr)
        #     end
        # end

        append!(dH_str, ["dH = dH/dTA_dH"])

        pH_code = vcat(
            "#  Concentrations of pH related species",
            "@. " .* species_conc_str,
            "#  dTA/dEIs",
            "@. " .* dTA_dTsum_str,
            "#  dTA/dH",
            "@. " .* dTA_dH_str)
            # if !isempty(species_conc_str_non_pH)
            #     pH_code = vcat(
            #         pH_code,
            #         "#  Speciation of non-EIs",
            #         "@. " .* species_conc_str_non_pH,
            #     )
            # end

        append!(pH_code, ["#  Transport of individual species"])

        for i in eachindex(subspecies)
            push!(
                pH_code,
                "mul!($(subspecies[i])_tran, Am$(subspecies[i]) , $(subspecies[i]))",
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
                "@. $(subspecies[i])_tran += alpha * ($(subspecies[i])$(subspecies_scrpt[i]) - $(subspecies[i]))",
            )
            # push!(pH_code, " ")
        end

        append!(pH_code, ["#  Transport of EIs"])
        append!(pH_code, "@. " .* Tsum_str)
        append!(pH_code, ["# Transport of TA"])
        append!(pH_code, "@. " .* TA_tran_str)
        append!(pH_code, ["# Transport of proton"])
        append!(pH_code, "@. " .* dH_str)

        if !(j == n_summed) || !(length(species_conc_str) == n_subspecies)
            throw(error("incorrect number of inputs"))
        end
    else
        pH_code = String[]
    end

    view_code =  vcat(
        C_views,
        # "",
        dC_views,
    )
    code = (
        vcat(A_str,
        bc_str1,
        bc_strN,
        alpha_str),
        pH_code,
        ads_str,
    )

    if nsummed != 0
        append!(
            tran_cache,
            vcat(
                species_conc_str,
                # species_conc_str_non_pH,
                subspecies .* "_tran",
                TA_tran_str,
                dTA_dH_str,
                dTA_dTsum_str,
            ),
        )
    end
    tran_cache = split.(tran_cache, r"\=|\+\=|\*\=|\-\=|\/\=")
    tran_cache = unique([replace(i[1], r"\s" => "") for i in tran_cache])

    # tran_expr = vcat(C_views,dC_views,A_str,bc_str1,bc_strN,alpha_str,ads_str,pH_code)
    # filter!(x -> x != " ", tran_expr)
    # tran_expr = replace.(tran_expr, r"@view C" => "")
    # tran_expr = replace.(tran_expr, r"@view dC" => "")
    # tran_expr = replace.(tran_expr, r"mul\!" => "")

    ads_str = [replace(i, r"\s" => "") for i in ads_str]
    filter!(x -> x != "", ads_str)

    pH_code = [replace(i, r"\s" => "") for i in pH_code]
    filter!(x -> x != "", pH_code)


    function partition(str,reg,from_str,to_str,i,marker)
        if occursin(reg,str)
            push!(to_str,str)
            marker[i] = 1.0
        end
    end

    regs = [
        r"\[((1)|(Ngrid))\]\+=[\(]?BcAm",
        r"mul!\(",
        r"alpha\*\([\w]+\-?\w+\)" 
    ]

    bc_str = vcat(bc_str1,bc_strN)
    strcol = (bc_str,A_str,alpha_str)

    marker1 = zeros(length(pH_code));

    for i in eachindex(pH_code)
        for j in eachindex(regs)
            partition(pH_code[i],regs[j],pH_code,strcol[j],i,marker1)
        end
    end
    
    marker2 = zeros(length(ads_str));

    for i in eachindex(ads_str)
        for j in eachindex(regs)
            partition(ads_str[i],regs[j],ads_str,strcol[j],i,marker2)
        end
    end
    

    function tran_format(expr)
        filter!(x -> x != " ", expr)
        filter!(x-> !occursin(r"^#",x),expr)
        expr = replace.(expr, r"@view C" => "")
        expr = replace.(expr, r"@view dC" => "")
        expr = replace.(expr, r"mul\!" => "")
        expr = replace.(expr, r"@." => "")
    end

    tran_expr = (
        C_views = tran_format(vcat(C_views,dC_views)),
        A_str = tran_format(A_str),
        bc_str = tran_format(bc_str),
        alpha_str = tran_format(alpha_str),
        ads_str = tran_format(ads_str[marker2.==0]),
        pH_str = tran_format(pH_code[marker1.==0]),
    )


    # return code, tran_expr, tran_cache, ads_summed_expr_str
    return view_code,code, tran_expr, tran_cache

end


