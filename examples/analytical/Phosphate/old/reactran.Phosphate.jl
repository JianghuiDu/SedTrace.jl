function (f::Cache.Reactran)(dC, C, parms::Param.ParamStruct, t)
    @unpack TH3PO4ID,
    PorgID,
    AmPorg,
    AmH3PO4,
    AmP_ads,
    BcAmPorg,
    BcCmPorg,
    Ngrid,
    BcAmH3PO4,
    BcCmH3PO4,
    BcAmP_ads,
    BcCmP_ads,
    alpha,
    H3PO40,
    K_ads,
    dstopw,
    k_P,
    k_pre,
    Csat = parms

    H3PO4 = PreallocationTools.get_tmp(f.H3PO4, C)
    H3PO4_tran = PreallocationTools.get_tmp(f.H3PO4_tran, C)
    P_ads = PreallocationTools.get_tmp(f.P_ads, C)
    P_ads_tran = PreallocationTools.get_tmp(f.P_ads_tran, C)
    Rremin = PreallocationTools.get_tmp(f.Rremin, C)
    Rpre = PreallocationTools.get_tmp(f.Rpre, C)
    S_Porg = PreallocationTools.get_tmp(f.S_Porg, C)
    S_TH3PO4 = PreallocationTools.get_tmp(f.S_TH3PO4, C)

    TH3PO4 = @view C[TH3PO4ID]
    Porg = @view C[PorgID]

    dTH3PO4 = @view dC[TH3PO4ID]
    dPorg = @view dC[PorgID]

    mul!(dPorg, AmPorg, Porg)

    dPorg[1] += BcAmPorg[1] ⊗ Porg[1] ⊕ BcCmPorg[1]
    dPorg[Ngrid] += BcAmPorg[2] ⊗ Porg[Ngrid] ⊕ BcCmPorg[2]


    @.. H3PO4 = TH3PO4 / (K_ads ⊗ dstopw ⊕ 1)
    mul!(H3PO4_tran, AmH3PO4, H3PO4)
    H3PO4_tran[1] += BcAmH3PO4[1] ⊗ H3PO4[1] ⊕ BcCmH3PO4[1]
    H3PO4_tran[Ngrid] += BcAmH3PO4[2] ⊗ H3PO4[Ngrid] ⊕ BcCmH3PO4[2]
    @.. P_ads = K_ads ⊗ H3PO4
    mul!(P_ads_tran, AmP_ads, P_ads)
    P_ads_tran[1] += BcAmP_ads[1] ⊗ P_ads[1] ⊕ BcCmP_ads[1]
    P_ads_tran[Ngrid] += BcAmP_ads[2] ⊗ P_ads[Ngrid] ⊕ BcCmP_ads[2]
    @.. dTH3PO4 = P_ads_tran ⊗ dstopw ⊕ H3PO4_tran ⊗ 1
    @.. dTH3PO4 += alpha ⊗ (H3PO40 - H3PO4)



    # reaction rates
    @.. Rremin = k_P ⊗ Porg
    @.. Rpre = k_pre ⊗ (H3PO4 - Csat)

    # species rates
    @.. S_Porg = -1 ⊗ Rremin
    @.. S_TH3PO4 = 1 ⊗ Rremin ⊗ dstopw ⊕ -1 ⊗ Rpre

    @.. dTH3PO4 += S_TH3PO4
    @.. dPorg += S_Porg

    return nothing
end
