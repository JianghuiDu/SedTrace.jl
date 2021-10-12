# module transport
function transport_code(substances, options,MTK)

    nsolid = sum(substances.type .== "solid")
    ndissolved = sum(substances.type .∈ Ref(["dissolved", "dissolved_adsorbed","dissolved_summed"]))
    nsummed = sum(substances.type .== "dissolved_summed_pH")

    cache_str = String[]
    C_views = String[]
    dC_views = String[]
    A_str = String[]
    bc_str1 = String[]
    bc_strN = String[]
    alpha_str = String[]
    ads_str = String[]

    # id_stride(x) =
    #     x == "solid" ? "" :
    #     (x ∈ ["dissolved", "dissolved_adsorbed"] ? ".+nsolid" : ".+nnoneq")
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
        push!(
            C_views,
            "$(i.substance) = @view C[$(i.substance)ID]",
        )
        # if !MTK
        push!(
            dC_views,
            "d$(i.substance) = @view dC[$(i.substance)ID]",
        )
        # end
        if i.type ∈ ["solid", "dissolved","dissolved_summed"]
            push!(A_str, 
            !MTK ?
            "mul!(d$(i.substance), Am$(i.substance), $(i.substance))" :
            "d$(i.substance) .= Am$(i.substance) * $(i.substance)")
            push!(
                bc_str1,
                "d$((i.substance))[1] += BcAm$((i.substance))[1]*$((i.substance))[1] + BcCm$((i.substance))[1]",
            )
            push!(
                bc_strN,
                "d$((i.substance))[Ngrid] += BcAm$((i.substance))[2]*$((i.substance))[Ngrid] + BcCm$((i.substance))[2]",
            )
        end
        if i.type ∈ ["dissolved","dissolved_summed"]
            push!(
                alpha_str,
                "@. d$(i.substance) += alpha*($(i.substance)$(bc_type(i.top_bc_type,i.substance))-$(i.substance))",
            )
        end
        if i.type == "dissolved_adsorbed"
            push!(cache_str,"$(i.substance)_ads")
            push!(ads_str, 
            !MTK ? 
            "@. $((i.substance))_ads = $(i.substance)*K$((i.substance))_ads" :
            "$((i.substance))_ads = @. $(i.substance)*K$((i.substance))_ads")
            push!(
                ads_str,
                !MTK ? 
                "mul!(d$(i.substance),Am$((i.substance))_ads,$((i.substance))_ads)" :
                "d$(i.substance) .= Am$((i.substance))_ads * $((i.substance))_ads",
            )
            push!(ads_str, "@. d$(i.substance) *= dstopw")
            push!(
                ads_str,
                !MTK ?
                "mul!(d$(i.substance), Am$(i.substance), $(i.substance),1.0,1.0)" :
                "d$(i.substance) += Am$(i.substance) * $(i.substance)",
            )
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
                "@. d$(i.substance) += alpha * ($((i.substance))0 - $(i.substance))",
            )
            # push!(ads_str, "@. d$(i.substance) /=1+dstopw*K$((i.substance))_ads")
            push!(ads_str, "@. d$(i.substance) *= 1/(1+dstopw*K$((i.substance))_ads)")

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
    append!(dH_str, ["dH = TA_tran"])
    dTA_dTsum_str = String[]
    dTA_dH_str = String[]

    n_summed = length(species_summed_pH.substance)
    # n_subspecies = sum(
    #     [3, 2, 4, 2, 2, 2, 2, 2, 1] .*
    #     [list[i] in species_summed_pH.substance for i = 1:length(list)],
    # )

    j = 0
    n_subspecies =  0
    for i in species_summed_pH.substance
        if !(i in list_summed_species)
            throw(
                error("dissolved_summed_pH species must be from this list: $list_summed_species. $i is not in the list."),
            )
        else
            tmp = EquilibriumInvariant(i)
            bc = getval!(species_summed_pH, :substance, i, :top_bc_type)
            append!(subspecies,tmp.species) 
            append!(subspecies_scrpt, fill(bc_type(bc, i), length(tmp.species)))
            append!(
                TA_tran_str,
                ["TA_tran" * ifelse(j == 0, " = ", " += ") * join(tmp.coef .* "*" .* tmp.species .* "_tran", "+")],
            )
            append!( dTA_dH_str, ["dTA_dH" *ifelse(j == 0, " = ", " += ") *tmp.dTAdH,])

            if i != "H"
                append!(Tsum_str, ["d$i = $(join(tmp.species .* "_tran", "+"))"])
                append!(dH_str, ["dH -= d$i*dTA_d$i"])
                append!(species_conc_str, tmp.species .* "=" .* tmp.expr)
                append!( dTA_dTsum_str, ["dTA_d$i = " * tmp.dTAdsum])    
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
                error("dissolved_summed species must be from this list: $list_summed_species. $i is not in the list."),
            )
        else
            tmp = EquilibriumInvariant(i)
            append!(subspecies_non_pH,tmp.species) 
            append!(species_conc_str_non_pH, tmp.species .* "=" .* tmp.expr)
        end
    end



    # list = ["TCO2", "TNH4", "TH3PO4", "TH2S", "THSO4", "TH3BO3", "THF", "TH4SiO4", "H"]

    # list_no = .![species_summed.substance[i] in list for i = 1:n_summed]

    # if any(list_no)
    #     throw(
    #         error(
    #             join(
    #                 "input :" .* string.(species_summed.substance[list_no]) .*
    #                 " is illegal",
    #                 "; ",
    #             ),
    #         ),
    #     )
    # end


    # j = 0
    # if "TCO2" in species_summed.substance
    #     append!(subspecies, ["HCO3", "CO3", "CO2"])        
    #     bc = getval!(species_summed, :substance, "TCO2", :top_bc_type)
    #     append!(subspecies_scrpt, fill(bc_type(bc, "TCO2"), 3))
    #     append!(Tsum_str, ["dTCO2 = HCO3_tran + CO3_tran + CO2_tran"])
    #     # push!(Tsum_str,"mul!(dTCO2,AmHCO3,HCO3)")
    #     # push!(Tsum_str,"mul!(dTCO2,AmCO3,CO3,1.0,1.0)")
    #     # push!(Tsum_str,"mul!(dTCO2,AmCO2,CO2,1.0,1.0)")
    #     # push!(Tsum_str,"dTCO2[1] += BcAmHCO3[1] * HCO3[1] + BcCmHCO3[1]")
    #     # push!(Tsum_str,"dTCO2[1] += BcAmCO3[1] * CO3[1] + BcCmCO3[1]")
    #     # push!(Tsum_str,"dTCO2[1] += BcAmCO2[1] * CO2[1] * BcCmCO2[1]")
    #     # push!(Tsum_str,"dTCO2[Ngrid] += BcAmHCO3[2] * HCO3[Ngrid] + BcCmHCO3[2]")
    #     # push!(Tsum_str,"dTCO2[Ngrid] += BcAmCO3[2] * CO3[Ngrid] + BcCmCO3[2]")
    #     # push!(Tsum_str,"dTCO2[Ngrid] += BcAmCO2[2] * CO2[Ngrid] * BcCmCO2[2]")
    #     # push!(Tsum_str,"@. dTCO2 += alpha*(TCO2$(bc_type(bc, "TCO2")) - TCO2)")

    #     append!(dH_str, ["dH -= dTCO2*dTA_dTCO2"])
    #     append!(
    #         TA_tran_str,
    #         ["TA_tran" * ifelse(j == 0, " = ", " += ") * "HCO3_tran + 2*CO3_tran"],
    #     )

    #     @vars H TA TCO2 CO2 HCO3 CO3 KCO2 KHCO3
    #     sol = SymPy.solve(
    #         [TCO2 - CO2 - HCO3 - CO3, KCO2 - H * HCO3 / CO2, KHCO3 - H * CO3 / HCO3],
    #         [CO2, HCO3, CO3],
    #     )
    #     append!(species_conc_str, string.(keys(sol)) .* " = " .* string.(values(sol)))
    #     TA = sol[HCO3] + 2 * sol[CO3]
    #     append!(
    #         dTA_dTsum_str,
    #         ["dTA_dTCO2 = " * string(SymPy.factor(SymPy.diff(TA, TCO2)))],
    #     )
    #     append!(
    #         dTA_dH_str,
    #         [
    #             "dTA_dH" *
    #             ifelse(j == 0, " = ", " += ") *
    #             string(SymPy.factor(SymPy.diff(TA, H))),
    #         ],
    #     )
    #     j += 1
    # end

    # if "TNH4" in species_summed.substance
    #     append!(subspecies, ["NH4", "NH3"])
    #     bc = getval!(species_summed, :substance, "TNH4", :top_bc_type)
    #     append!(subspecies_scrpt, fill(bc_type(bc, "TNH4"), 2))
    #     append!(Tsum_str, ["dTNH4 = NH4_tran + NH3_tran"])
    #     # push!(Tsum_str,"mul!(dTNH4, AmNH4,NH4)")
    #     # push!(Tsum_str,"mul!(dTNH4, AmNH3,NH3,1.0,1.0)")
    #     # push!(Tsum_str,"dTNH4[1] += BcAmNH4[1]*NH4[1]+BcCmNH4[1]")
    #     # push!(Tsum_str,"dTNH4[1] += BcAmNH3[1]*NH3[1]+BcCmNH3[1]")
    #     # push!(Tsum_str,"dTNH4[Ngrid] += BcAmNH4[2]*NH4[Ngrid]+BcCmNH4[2]")
    #     # push!(Tsum_str,"dTNH4[Ngrid] += BcAmNH3[2]*NH3[Ngrid]+BcCmNH3[2]")
    #     # push!(Tsum_str,"@. dTNH4 += alpha*(TNH4$(bc_type(bc, "TNH4")) - TNH4)")

    #     append!(dH_str, ["dH -= dTNH4*dTA_dTNH4"])
    #     append!(TA_tran_str, ["TA_tran" * ifelse(j == 0, " = ", " += ") * "NH3_tran"])
    #     @vars H TA TNH4 NH4 NH3 KNH4
    #     sol = SymPy.solve([TNH4 - NH4 - NH3, KNH4 - H * NH3 / NH4], [NH4, NH3])
    #     append!(species_conc_str, string.(keys(sol)) .* " = " .* string.(values(sol)))
    #     TA = sol[NH3]
    #     append!(
    #         dTA_dTsum_str,
    #         ["dTA_dTNH4 = " * string(SymPy.factor(SymPy.diff(TA, TNH4)))],
    #     )
    #     append!(
    #         dTA_dH_str,
    #         [
    #             "dTA_dH" *
    #             ifelse(j == 0, " = ", " += ") *
    #             string(SymPy.factor(SymPy.diff(TA, H))),
    #         ],
    #     )
    #     j += 1
    # end

    # if "TH3PO4" in species_summed.substance
    #     append!(subspecies, ["H3PO4", "H2PO4", "HPO4", "PO4"])
    #     bc = getval!(species_summed, :substance, "TH3PO4", :top_bc_type)
    #     append!(subspecies_scrpt, fill(bc_type(bc, "TH3PO4"), 4))
    #     append!(Tsum_str, ["dTH3PO4 = H3PO4_tran + H2PO4_tran + HPO4_tran + PO4_tran"])
    #     append!(dH_str, ["dH -= dTH3PO4*dTA_dTH3PO4"])
    #     append!(
    #         TA_tran_str,
    #         [
    #             "TA_tran" *
    #             ifelse(j == 0, " = ", " += ") *
    #             "HPO4_tran + 2*PO4_tran - H3PO4_tran",
    #         ],
    #     )
    #     @vars H TA TH3PO4 H3PO4 H2PO4 HPO4 PO4 KH3PO4 KH2PO4 KHPO4
    #     sol = SymPy.solve(
    #         [
    #             TH3PO4 - H3PO4 - H2PO4 - HPO4 - PO4,
    #             KH3PO4 - H * H2PO4 / H3PO4,
    #             KH2PO4 - H * HPO4 / H2PO4,
    #             KHPO4 - H * PO4 / HPO4,
    #         ],
    #         [H3PO4, H2PO4, HPO4, PO4],
    #     )
    #     append!(species_conc_str, string.(keys(sol)) .* " = " .* string.(values(sol)))
    #     TA = sol[HPO4] + 2 * sol[PO4] - sol[H3PO4]

    #     append!(dTA_dTsum_str, ["dTA_dTH3PO4 = " .* string(SymPy.diff(sol[HPO4], TH3PO4))])
    #     append!(
    #         dTA_dTsum_str,
    #         ["dTA_dTH3PO4 += " .* string(SymPy.diff(2 * sol[PO4], TH3PO4))],
    #     )
    #     append!(
    #         dTA_dTsum_str,
    #         ["dTA_dTH3PO4 += " .* string(SymPy.diff(-sol[H3PO4], TH3PO4))],
    #     )
    #     append!(
    #         dTA_dH_str,
    #         [
    #             "dTA_dH" *
    #             ifelse(j == 0, " = ", " += ") *
    #             string(SymPy.factor(SymPy.diff(sol[HPO4], H))),
    #         ],
    #     )
    #     append!(
    #         dTA_dH_str,
    #         ["dTA_dH += " * string(SymPy.factor(SymPy.diff(2 * sol[PO4], H)))],
    #     )
    #     append!(
    #         dTA_dH_str,
    #         ["dTA_dH += " * string(SymPy.factor(SymPy.diff(-sol[H3PO4], H)))],
    #     )
    #     j += 1
    # end

    # if "TH2S" in species_summed.substance
    #     append!(subspecies, ["H2S", "HS"])
    #     bc = getval!(species_summed, :substance, "TH2S", :top_bc_type)
    #     append!(subspecies_scrpt, fill(bc_type(bc, "TH2S"), 2))
    #     append!(Tsum_str, ["dTH2S = H2S_tran + HS_tran"])
    #     # push!(Tsum_str,"mul!(dTH2S, AmH2S,H2S)")
    #     # push!(Tsum_str,"mul!(dTH2S, AmHS,HS,1.0,1.0)")
    #     # push!(Tsum_str,"dTH2S[1] += BcAmH2S[1]*H2S[1]+BcCmH2S[1]")
    #     # push!(Tsum_str,"dTH2S[1] += BcAmHS[1]*HS[1]+BcCmHS[1]")
    #     # push!(Tsum_str,"dTH2S[Ngrid] += BcAmH2S[2]*H2S[Ngrid]+BcCmH2S[2]")
    #     # push!(Tsum_str,"dTH2S[Ngrid] += BcAmHS[2]*HS[Ngrid]+BcCmHS[2]")
    #     # push!(Tsum_str,"@. dTH2S += alpha*(TH2S$(bc_type(bc, "TH2S")) - TH2S)")

    #     append!(dH_str, ["dH -= dTH2S*dTA_dTH2S"])
    #     append!(TA_tran_str, ["TA_tran" * ifelse(j == 0, " = ", " += ") * "HS_tran"])
    #     @vars H TA TH2S H2S HS KH2S
    #     sol = SymPy.solve([TH2S - H2S - HS, KH2S - H * HS / H2S], [H2S, HS])
    #     append!(species_conc_str, string.(keys(sol)) .* " = " .* string.(values(sol)))
    #     TA = sol[HS]
    #     append!(
    #         dTA_dTsum_str,
    #         ["dTA_dTH2S = " * string(SymPy.factor(SymPy.diff(TA, TH2S)))],
    #     )
    #     append!(
    #         dTA_dH_str,
    #         [
    #             "dTA_dH" *
    #             ifelse(j == 0, " = ", " += ") *
    #             string(SymPy.factor(SymPy.diff(TA, H))),
    #         ],
    #     )
    #     j += 1
    # end

    # if "THSO4" in species_summed.substance
    #     append!(subspecies, ["HSO4", "SO4"])
    #     bc = getval!(species_summed, :substance, "THSO4", :top_bc_type)
    #     append!(subspecies_scrpt, fill(bc_type(bc, "THSO4"), 2))
    #     append!(Tsum_str, ["dTHSO4 = HSO4_tran + SO4_tran "])
    #     # push!(Tsum_str,"mul!(dTHSO4, AmHSO4,HSO4)")
    #     # push!(Tsum_str,"mul!(dTHSO4, AmSO4,SO4,1.0,1.0)")
    #     # push!(Tsum_str,"dTHSO4[1] += BcAmHSO4[1]*HSO4[1]+BcCmHSO4[1]")
    #     # push!(Tsum_str,"dTHSO4[1] += BcAmSO4[1]*SO4[1]+BcCmSO4[1]")
    #     # push!(Tsum_str,"dTHSO4[Ngrid] += BcAmHSO4[2]*HSO4[Ngrid]+BcCmHSO4[2]")
    #     # push!(Tsum_str,"dTHSO4[Ngrid] += BcAmSO4[2]*SO4[Ngrid]+BcCmSO4[2]")
    #     # push!(Tsum_str,"@. dTHSO4 += alpha*(THSO4$(bc_type(bc, "THSO4")) - THSO4)")

    #     append!(dH_str, ["dH -= dTHSO4*dTA_dTHSO4"])
    #     append!(TA_tran_str, ["TA_tran" * ifelse(j == 0, " = ", " += ") * "-HSO4_tran"])
    #     @vars H TA THSO4 HSO4 SO4 KHSO4
    #     sol = SymPy.solve([THSO4 - HSO4 - SO4, KHSO4 - H * SO4 / HSO4], [HSO4, SO4])
    #     append!(species_conc_str, string.(keys(sol)) .* " = " .* string.(values(sol)))
    #     TA = -sol[HSO4]
    #     append!(
    #         dTA_dTsum_str,
    #         ["dTA_dTHSO4 = " * string(SymPy.factor(SymPy.diff(TA, THSO4)))],
    #     )
    #     append!(
    #         dTA_dH_str,
    #         [
    #             "dTA_dH" *
    #             ifelse(j == 0, " = ", " += ") *
    #             string(SymPy.factor(SymPy.diff(TA, H))),
    #         ],
    #     )
    #     j += 1
    # end

    # if "TH3BO3" in species_summed.substance
    #     append!(subspecies, ["H3BO3", "H4BO4"])
    #     bc = getval!(species_summed, :substance, "TH3BO3", :top_bc_type)
    #     append!(subspecies_scrpt, fill(bc_type(bc, "TH3BO3"), 2))
    #     append!(Tsum_str, ["dTH3BO3 = H3BO3_tran + H4BO4_tran "])
    #     # push!(Tsum_str,"mul!(dTH3BO3, AmH3BO3,H3BO3)")
    #     # push!(Tsum_str,"mul!(dTH3BO3, AmH4BO4,H4BO4,1.0,1.0)")
    #     # push!(Tsum_str,"dTH3BO3[1] += BcAmH3BO3[1]*H3BO3[1]+BcCmH3BO3[1]")
    #     # push!(Tsum_str,"dTH3BO3[1] += BcAmH4BO4[1]*H4BO4[1]+BcCmH4BO4[1]")
    #     # push!(Tsum_str,"dTH3BO3[Ngrid] += BcAmH3BO3[2]*H3BO3[Ngrid]+BcCmH3BO3[2]")
    #     # push!(Tsum_str,"dTH3BO3[Ngrid] += BcAmH4BO4[2]*H4BO4[Ngrid]+BcCmH4BO4[2]")
    #     # push!(Tsum_str,"@. dTH3BO3 += alpha*(TH3BO3$(bc_type(bc, "TH3BO3")) - TH3BO3)")

    #     append!(dH_str, ["dH -= dTH3BO3*dTA_dTH3BO3"])
    #     append!(TA_tran_str, ["TA_tran" * ifelse(j == 0, " = ", " += ") * "H4BO4_tran"])
    #     @vars H TA TH3BO3 H3BO3 H4BO4 KH3BO3
    #     sol = SymPy.solve(
    #         [TH3BO3 - H3BO3 - H4BO4, KH3BO3 - H * H4BO4 / H3BO3],
    #         [H3BO3, H4BO4],
    #     )
    #     append!(species_conc_str, string.(keys(sol)) .* " = " .* string.(values(sol)))
    #     TA = sol[H4BO4]
    #     append!(
    #         dTA_dTsum_str,
    #         ["dTA_dTH3BO3 = " * string(SymPy.factor(SymPy.diff(TA, TH3BO3)))],
    #     )
    #     append!(
    #         dTA_dH_str,
    #         [
    #             "dTA_dH" *
    #             ifelse(j == 0, " = ", " += ") *
    #             string(SymPy.factor(SymPy.diff(TA, H))),
    #         ],
    #     )
    #     j += 1
    # end

    # if "THF" in species_summed.substance
    #     append!(subspecies, ["HF", "F"])
    #     bc = getval!(species_summed, :substance, "THF", :top_bc_type)
    #     append!(subspecies_scrpt, fill(bc_type(bc, "THF"), 2))
    #     append!(Tsum_str, ["dTHF = HF_tran + F_tran "])
    #     # push!(Tsum_str,"mul!(dTHF, AmHF,HF)")
    #     # push!(Tsum_str,"mul!(dTHF, AmF,F,1.0,1.0)")
    #     # push!(Tsum_str,"dTHF[1] += BcAmHF[1]*HF[1]+BcCmHF[1]")
    #     # push!(Tsum_str,"dTHF[1] += BcAmF[1]*F[1]+BcCmF[1]")
    #     # push!(Tsum_str,"dTHF[Ngrid] += BcAmHF[2]*HF[Ngrid]+BcCmHF[2]")
    #     # push!(Tsum_str,"dTHF[Ngrid] += BcAmF[2]*F[Ngrid]+BcCmF[2]")
    #     # push!(Tsum_str,"@. dTHF += alpha*(THF$(bc_type(bc, "THF")) - THF)")

    #     append!(dH_str, ["dH -= dTHF*dTA_dTHF"])
    #     append!(TA_tran_str, ["TA_tran" * ifelse(j == 0, " = ", " += ") * "-HF_tran"])
    #     @vars H TA THF HF F KHF
    #     sol = SymPy.solve([THF - HF - F, KHF - H * F / HF], [HF, F])
    #     append!(species_conc_str, string.(keys(sol)) .* " = " .* string.(values(sol)))
    #     TA = -sol[HF]
    #     append!(dTA_dTsum_str, ["dTA_dTHF = " * string(SymPy.factor(SymPy.diff(TA, THF)))])
    #     append!(
    #         dTA_dH_str,
    #         [
    #             "dTA_dH" *
    #             ifelse(j == 0, " = ", " += ") *
    #             string(SymPy.factor(SymPy.diff(TA, H))),
    #         ],
    #     )
    #     j += 1
    # end

    # if "TH4SiO4" in species_summed.substance
    #     append!(subspecies, ["H4SiO4", "H3SiO4"])
    #     bc = getval!(species_summed, :substance, "TH4SiO4", :top_bc_type)
    #     append!(subspecies_scrpt, fill(bc_type(bc, "TH4SiO4"), 2))
    #     append!(Tsum_str, ["dTH4SiO4 = H4SiO4_tran + H3SiO4_tran "])
    #     # push!(Tsum_str,"mul!(dTH4SiO4, AmH4SiO4,H4SiO4)")
    #     # push!(Tsum_str,"mul!(dTH4SiO4, AmH3SiO4,H3SiO4,1.0,1.0)")
    #     # push!(Tsum_str,"dTH4SiO4[1] += BcAmH4SiO4[1]*H4SiO4[1]+BcCmH4SiO4[1]")
    #     # push!(Tsum_str,"dTH4SiO4[1] += BcAmH3SiO4[1]*H3SiO4[1]+BcCmH3SiO4[1]")
    #     # push!(Tsum_str,"dTH4SiO4[Ngrid] += BcAmH4SiO4[2]*H4SiO4[Ngrid]+BcCmH4SiO4[2]")
    #     # push!(Tsum_str,"dTH4SiO4[Ngrid] += BcAmH3SiO4[2]*H3SiO4[Ngrid]+BcCmH3SiO4[2]")
    #     # push!(Tsum_str,"@. dTH4SiO4 += alpha*(TH4SiO4$(bc_type(bc, "TH4SiO4")) - TH4SiO4)")

    #     append!(dH_str, ["dH -= dTH4SiO4*dTA_dTH4SiO4"])
    #     append!(TA_tran_str, ["TA_tran" * ifelse(j == 0, " = ", " += ") * "H3SiO4_tran"])
    #     @vars H TA TH4SiO4 H4SiO4 H3SiO4 KH4SiO4
    #     sol = SymPy.solve(
    #         [TH4SiO4 - H4SiO4 - H3SiO4, KH4SiO4 - H * H3SiO4 / H4SiO4],
    #         [H4SiO4, H3SiO4],
    #     )
    #     append!(species_conc_str, string.(keys(sol)) .* " = " .* string.(values(sol)))
    #     TA = sol[H3SiO4]
    #     append!(
    #         dTA_dTsum_str,
    #         ["dTA_dTH4SiO4 = " * string(SymPy.factor(SymPy.diff(TA, TH4SiO4)))],
    #     )
    #     append!(
    #         dTA_dH_str,
    #         [
    #             "dTA_dH" *
    #             ifelse(j == 0, " = ", " += ") *
    #             string(SymPy.factor(SymPy.diff(TA, H))),
    #         ],
    #     )
    #     j += 1
    # end

    # if "H" in species_summed.substance
    #     append!(subspecies, ["H", "OH"])
    #     bc = getval!(species_summed, :substance, "H", :top_bc_type)
    #     append!(subspecies_scrpt, fill(bc_type(bc, "H"), 2))
    #     append!(
    #         TA_tran_str,
    #         ["TA_tran" * ifelse(j == 0, " = ", " += ") * "OH_tran - H_tran"],
    #     )
    #     @vars H TA OH KH2O
    #     sol = SymPy.solve([KH2O - H * OH], [OH])
    #     append!(species_conc_str, string.(keys(sol)) .* " = " .* string.(values(sol)))
    #     TA = sol[OH] - H
    #     append!(
    #         dTA_dH_str,
    #         [
    #             "dTA_dH" *
    #             ifelse(j == 0, " = ", " += ") *
    #             string(SymPy.factor(SymPy.diff(TA, H))),
    #         ],
    #     )
    #     j+=1
    # end

    # append!(dH_str, ["dH /= dTA_dH"])
    append!(dH_str, ["dH = dH/dTA_dH"])
    

    if !MTK
        pH_code = vcat(
            "@. " .* species_conc_str,
            "  ",
            "@. " .* dTA_dTsum_str,
            "  ",
            "@. " .* dTA_dH_str,
            "   ",
            "@. " .* species_conc_str_non_pH,
        )
    else
        pH_code = vcat(
            replace.(species_conc_str,r"\="=>"= @."),
            "  ",
            replace.(dTA_dTsum_str,r"\="=>"= @."),
            "  ",
            replace.(dTA_dH_str,r"\="=>"= @."),
            "   ",
            replace.(species_conc_str_non_pH,r"\="=>"= @."),

        )
    end

    append!(pH_code, [" "])

    for i = 1:length(subspecies)
        push!(pH_code, 
        !MTK ?
        "mul!($(subspecies[i])_tran, Am$(subspecies[i]) , $(subspecies[i]))" :
        "$(subspecies[i])_tran = Am$(subspecies[i]) * $(subspecies[i])")
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
        push!(pH_code, " ")
    end

    append!(pH_code, [" "])
    if !MTK
    append!(pH_code, "@. " .* Tsum_str)
    else
        append!(pH_code, replace.(Tsum_str,r"\="=>".="))
    end
    append!(pH_code, [" "])
    if !MTK
    append!(pH_code, "@. " .* TA_tran_str)
    else
        append!(pH_code, replace.(TA_tran_str,r"\="=>"= @."))
    end
    append!(pH_code, [" "])
    if !MTK
    append!(pH_code, "@. " .* dH_str)
    else
        append!(pH_code, ["dH .= TA_tran"])
        append!(pH_code, replace.(dH_str[2:end],r"\="=>"= @."))
    end

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

    append!(cache_str, vcat(species_conc_str,species_conc_str_non_pH,subspecies.*"_tran",TA_tran_str,dTA_dH_str,dTA_dTsum_str))
    cache_str = split.(cache_str,r"\=|\+\=|\*\=|\-\=|\/\=")
    cache_str = unique([replace(i[1],r"\s"=>"") for i in cache_str])

    if (j == n_summed) & (length(species_conc_str) == n_subspecies)
        # writedlm("transport_code.txt", "    " .* code)
        return  code, cache_str
    else
        throw(error("incorrect number of inputs"))
    end
end

# end
