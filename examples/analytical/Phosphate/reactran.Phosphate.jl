function (f::Cache.Reactran)(dC, C, parms::Param.ParamStruct, t)
    #---------------------------------------------------------------------
    #  Parameters
    #---------------------------------------------------------------------
    @unpack PorgID,
    TH3PO4ID,
    AmPorg,
    AmTH3PO4_dis,
    AmTH3PO4_ads,
    BcAmPorg,
    BcCmPorg,
    Ngrid,
    BcAmTH3PO4_dis,
    BcCmTH3PO4_dis,
    BcAmTH3PO4_ads,
    BcCmTH3PO4_ads,
    alpha,
    TH3PO4_dis0,
    dstopw,
    K_ads,
    k_P,
    k_pre,
    Csat = parms
    #---------------------------------------------------------------------
    #  Cache
    #---------------------------------------------------------------------
    P_ads = PreallocationTools.get_tmp(f.P_ads, C)
    TH3PO4_ads_nsf = PreallocationTools.get_tmp(f.TH3PO4_ads_nsf, C)
    TH3PO4_ads = PreallocationTools.get_tmp(f.TH3PO4_ads, C)
    TH3PO4_dis = PreallocationTools.get_tmp(f.TH3PO4_dis, C)
    TH3PO4_dis_tran = PreallocationTools.get_tmp(f.TH3PO4_dis_tran, C)
    TH3PO4_ads_tran = PreallocationTools.get_tmp(f.TH3PO4_ads_tran, C)
    Rremin = PreallocationTools.get_tmp(f.Rremin, C)
    Rpre = PreallocationTools.get_tmp(f.Rpre, C)
    S_Porg = PreallocationTools.get_tmp(f.S_Porg, C)
    S_TH3PO4 = PreallocationTools.get_tmp(f.S_TH3PO4, C)

    #---------------------------------------------------------------------
    #  Model state
    #---------------------------------------------------------------------
    Porg = @view C[PorgID]
    TH3PO4 = @view C[TH3PO4ID]
    dPorg = @view dC[PorgID]
    dTH3PO4 = @view dC[TH3PO4ID]
    #---------------------------------------------------------------------
    #  Transport of solid and dissolved substances
    #---------------------------------------------------------------------
    mul!(dPorg, AmPorg, Porg)
    dPorg[1] += BcAmPorg[1] ⊗ Porg[1] ⊕ BcCmPorg[1]
    dPorg[Ngrid] += BcAmPorg[2] ⊗ Porg[Ngrid] ⊕ BcCmPorg[2]
    #---------------------------------------------------------------------
    #  pH code
    #---------------------------------------------------------------------
    #---------------------------------------------------------------------
    #  Speciation code
    #---------------------------------------------------------------------
    #  Concentrations of adsorbed/dissolved species
    @.. TH3PO4_dis = TH3PO4 / (K_ads ⊗ dstopw ⊕ 1)
    @.. P_ads = K_ads ⊗ TH3PO4_dis
    @.. TH3PO4_ads_nsf = P_ads
    @.. TH3PO4_ads = P_ads
    #  Transport of adsorbed/dissolved species
    mul!(TH3PO4_dis_tran, AmTH3PO4_dis, TH3PO4_dis)
    TH3PO4_dis_tran[1] += BcAmTH3PO4_dis[1] ⊗ TH3PO4_dis[1] ⊕ BcCmTH3PO4_dis[1]
    TH3PO4_dis_tran[Ngrid] +=
        BcAmTH3PO4_dis[2] ⊗ TH3PO4_dis[Ngrid] ⊕ BcCmTH3PO4_dis[2]
    mul!(TH3PO4_ads_tran, AmTH3PO4_ads, TH3PO4_ads)
    TH3PO4_ads_tran[1] += BcAmTH3PO4_ads[1] ⊗ TH3PO4_ads[1] ⊕ BcCmTH3PO4_ads[1]
    TH3PO4_ads_tran[Ngrid] +=
        BcAmTH3PO4_ads[2] ⊗ TH3PO4_ads[Ngrid] ⊕ BcCmTH3PO4_ads[2]
    @.. dTH3PO4 = TH3PO4_dis_tran ⊗ 1 ⊕ TH3PO4_ads_tran ⊗ dstopw
    @.. dTH3PO4 += alpha ⊗ (TH3PO4_dis0 - TH3PO4_dis)

    #---------------------------------------------------------------------
    #  Reaction code
    #---------------------------------------------------------------------
    # Individual reaction rates
    @.. Rremin = k_P ⊗ Porg
    @.. Rpre = k_pre ⊗ (TH3PO4_dis - Csat)

    # Summed rates for model substances
    @.. S_Porg = -1 ⊗ Rremin
    @.. S_TH3PO4 = 1 ⊗ Rremin ⊗ dstopw ⊕ -1 ⊗ Rpre

    @.. dPorg += S_Porg
    @.. dTH3PO4 += S_TH3PO4

    return nothing
end
