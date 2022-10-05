function (f::Cache.Reactran)(dC, C, parms::Param.ParamStruct, t)
    #---------------------------------------------------------------------
    #  Parameters
    #---------------------------------------------------------------------
    @unpack POCID,
    FeOOHID,
    FeSID,
    SO4ID,
    TFeID,
    HID,
    TCO2ID,
    TH2SID,
    AmPOC,
    AmFeOOH,
    AmFeS,
    AmSO4,
    AmH,
    AmOH,
    AmHCO3,
    AmCO3,
    AmCO2,
    AmH2S,
    AmHS,
    AmTFe_dis,
    AmTFe_ads_POC,
    BcAmPOC,
    BcCmPOC,
    BcAmFeOOH,
    BcCmFeOOH,
    BcAmFeS,
    BcCmFeS,
    BcAmSO4,
    BcCmSO4,
    Ngrid,
    BcAmH,
    BcCmH,
    BcAmOH,
    BcCmOH,
    BcAmHCO3,
    BcCmHCO3,
    BcAmCO3,
    BcCmCO3,
    BcAmCO2,
    BcCmCO2,
    BcAmH2S,
    BcCmH2S,
    BcAmHS,
    BcCmHS,
    BcAmTFe_dis,
    BcCmTFe_dis,
    BcAmTFe_ads_POC,
    BcCmTFe_ads_POC,
    alpha,
    SO40,
    H0,
    OH0,
    HCO30,
    CO30,
    CO20,
    H2S0,
    HS0,
    TFe_dis0,
    dstopw,
    KH2O,
    KCO2,
    KHCO3,
    KH2S,
    KFe_ads,
    Cl,
    KspFeS,
    pwtods,
    KFeOOH,
    k_POC,
    KSO4,
    kFeOOHH2S,
    kFeSpre = parms
    #---------------------------------------------------------------------
    #  Cache
    #---------------------------------------------------------------------
    Fe_aq = PreallocationTools.get_tmp(f.Fe_aq, C)
    TFe_dis = PreallocationTools.get_tmp(f.TFe_dis, C)
    FeCl_aq = PreallocationTools.get_tmp(f.FeCl_aq, C)
    FeSO4_aq = PreallocationTools.get_tmp(f.FeSO4_aq, C)
    FeCO3_aq = PreallocationTools.get_tmp(f.FeCO3_aq, C)
    FeHS_aq = PreallocationTools.get_tmp(f.FeHS_aq, C)
    Fe_ads = PreallocationTools.get_tmp(f.Fe_ads, C)
    TFe_ads_POC = PreallocationTools.get_tmp(f.TFe_ads_POC, C)
    TFe_ads = PreallocationTools.get_tmp(f.TFe_ads, C)
    TFe_dis_tran = PreallocationTools.get_tmp(f.TFe_dis_tran, C)
    TFe_ads_POC_tran = PreallocationTools.get_tmp(f.TFe_ads_POC_tran, C)
    OH = PreallocationTools.get_tmp(f.OH, C)
    HCO3 = PreallocationTools.get_tmp(f.HCO3, C)
    CO3 = PreallocationTools.get_tmp(f.CO3, C)
    CO2 = PreallocationTools.get_tmp(f.CO2, C)
    H2S = PreallocationTools.get_tmp(f.H2S, C)
    HS = PreallocationTools.get_tmp(f.HS, C)
    H_tran = PreallocationTools.get_tmp(f.H_tran, C)
    OH_tran = PreallocationTools.get_tmp(f.OH_tran, C)
    HCO3_tran = PreallocationTools.get_tmp(f.HCO3_tran, C)
    CO3_tran = PreallocationTools.get_tmp(f.CO3_tran, C)
    CO2_tran = PreallocationTools.get_tmp(f.CO2_tran, C)
    H2S_tran = PreallocationTools.get_tmp(f.H2S_tran, C)
    HS_tran = PreallocationTools.get_tmp(f.HS_tran, C)
    TA_tran = PreallocationTools.get_tmp(f.TA_tran, C)
    dTA_dH = PreallocationTools.get_tmp(f.dTA_dH, C)
    dTA_dTCO2 = PreallocationTools.get_tmp(f.dTA_dTCO2, C)
    dTA_dTH2S = PreallocationTools.get_tmp(f.dTA_dTH2S, C)
    Omega_RFeS_pre = PreallocationTools.get_tmp(f.Omega_RFeS_pre, C)
    RFeOOHPOC = PreallocationTools.get_tmp(f.RFeOOHPOC, C)
    RSO4POC = PreallocationTools.get_tmp(f.RSO4POC, C)
    RFeOOHH2S = PreallocationTools.get_tmp(f.RFeOOHH2S, C)
    RFeS_pre = PreallocationTools.get_tmp(f.RFeS_pre, C)
    S_POC = PreallocationTools.get_tmp(f.S_POC, C)
    S_FeOOH = PreallocationTools.get_tmp(f.S_FeOOH, C)
    S_TCO2 = PreallocationTools.get_tmp(f.S_TCO2, C)
    S_TFe = PreallocationTools.get_tmp(f.S_TFe, C)
    S_SO4 = PreallocationTools.get_tmp(f.S_SO4, C)
    S_TH2S = PreallocationTools.get_tmp(f.S_TH2S, C)
    S_FeS = PreallocationTools.get_tmp(f.S_FeS, C)
    S_TA = PreallocationTools.get_tmp(f.S_TA, C)
    S_H = PreallocationTools.get_tmp(f.S_H, C)

    #---------------------------------------------------------------------
    #  Model state
    #---------------------------------------------------------------------
    POC = @view C[POCID]
    FeOOH = @view C[FeOOHID]
    FeS = @view C[FeSID]
    SO4 = @view C[SO4ID]
    TFe = @view C[TFeID]
    H = @view C[HID]
    TCO2 = @view C[TCO2ID]
    TH2S = @view C[TH2SID]
    dPOC = @view dC[POCID]
    dFeOOH = @view dC[FeOOHID]
    dFeS = @view dC[FeSID]
    dSO4 = @view dC[SO4ID]
    dTFe = @view dC[TFeID]
    dH = @view dC[HID]
    dTCO2 = @view dC[TCO2ID]
    dTH2S = @view dC[TH2SID]
    #---------------------------------------------------------------------
    #  Transport of solid and dissolved substances
    #---------------------------------------------------------------------
    mul!(dPOC, AmPOC, POC)
    mul!(dFeOOH, AmFeOOH, FeOOH)
    mul!(dFeS, AmFeS, FeS)
    mul!(dSO4, AmSO4, SO4)
    dPOC[1] += BcAmPOC[1] ⊗ POC[1] ⊕ BcCmPOC[1]
    dFeOOH[1] += BcAmFeOOH[1] ⊗ FeOOH[1] ⊕ BcCmFeOOH[1]
    dFeS[1] += BcAmFeS[1] ⊗ FeS[1] ⊕ BcCmFeS[1]
    dSO4[1] += BcAmSO4[1] ⊗ SO4[1] ⊕ BcCmSO4[1]
    dPOC[Ngrid] += BcAmPOC[2] ⊗ POC[Ngrid] ⊕ BcCmPOC[2]
    dFeOOH[Ngrid] += BcAmFeOOH[2] ⊗ FeOOH[Ngrid] ⊕ BcCmFeOOH[2]
    dFeS[Ngrid] += BcAmFeS[2] ⊗ FeS[Ngrid] ⊕ BcCmFeS[2]
    dSO4[Ngrid] += BcAmSO4[2] ⊗ SO4[Ngrid] ⊕ BcCmSO4[2]
    @.. dSO4 += alpha ⊗ (SO40 - SO4)
    #---------------------------------------------------------------------
    #  pH code
    #---------------------------------------------------------------------
    #  Concentrations of pH related species
    @.. OH = KH2O / H
    @.. HCO3 = H ⊗ KCO2 ⊗ TCO2 / (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)
    @.. CO3 = KCO2 ⊗ KHCO3 ⊗ TCO2 / (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)
    @.. CO2 = H^2 ⊗ TCO2 / (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)
    @.. H2S = H ⊗ TH2S / (H ⊕ KH2S)
    @.. HS = KH2S ⊗ TH2S / (H ⊕ KH2S)
    #  dTA/dEIs
    @.. dTA_dTCO2 = KCO2 ⊗ (H ⊕ 2 ⊗ KHCO3) / (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)
    @.. dTA_dTH2S = KH2S / (H ⊕ KH2S)
    #  dTA/dH
    @.. dTA_dH = -(H^2 ⊕ KH2O) / H^2
    @.. dTA_dH +=
        -KCO2 ⊗ TCO2 ⊗ (H^2 ⊕ 4 ⊗ H ⊗ KHCO3 ⊕ KCO2 ⊗ KHCO3) /
        (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)^2
    @.. dTA_dH += -KH2S ⊗ TH2S / (H ⊕ KH2S)^2
    #  Transport of individual species
    mul!(H_tran, AmH, H)
    H_tran[1] += BcAmH[1] ⊗ H[1] ⊕ BcCmH[1]
    H_tran[Ngrid] += BcAmH[2] ⊗ H[Ngrid] ⊕ BcCmH[2]
    @.. H_tran += alpha ⊗ (H0 - H)
    mul!(OH_tran, AmOH, OH)
    OH_tran[1] += BcAmOH[1] ⊗ OH[1] ⊕ BcCmOH[1]
    OH_tran[Ngrid] += BcAmOH[2] ⊗ OH[Ngrid] ⊕ BcCmOH[2]
    @.. OH_tran += alpha ⊗ (OH0 - OH)
    mul!(HCO3_tran, AmHCO3, HCO3)
    HCO3_tran[1] += BcAmHCO3[1] ⊗ HCO3[1] ⊕ BcCmHCO3[1]
    HCO3_tran[Ngrid] += BcAmHCO3[2] ⊗ HCO3[Ngrid] ⊕ BcCmHCO3[2]
    @.. HCO3_tran += alpha ⊗ (HCO30 - HCO3)
    mul!(CO3_tran, AmCO3, CO3)
    CO3_tran[1] += BcAmCO3[1] ⊗ CO3[1] ⊕ BcCmCO3[1]
    CO3_tran[Ngrid] += BcAmCO3[2] ⊗ CO3[Ngrid] ⊕ BcCmCO3[2]
    @.. CO3_tran += alpha ⊗ (CO30 - CO3)
    mul!(CO2_tran, AmCO2, CO2)
    CO2_tran[1] += BcAmCO2[1] ⊗ CO2[1] ⊕ BcCmCO2[1]
    CO2_tran[Ngrid] += BcAmCO2[2] ⊗ CO2[Ngrid] ⊕ BcCmCO2[2]
    @.. CO2_tran += alpha ⊗ (CO20 - CO2)
    mul!(H2S_tran, AmH2S, H2S)
    H2S_tran[1] += BcAmH2S[1] ⊗ H2S[1] ⊕ BcCmH2S[1]
    H2S_tran[Ngrid] += BcAmH2S[2] ⊗ H2S[Ngrid] ⊕ BcCmH2S[2]
    @.. H2S_tran += alpha ⊗ (H2S0 - H2S)
    mul!(HS_tran, AmHS, HS)
    HS_tran[1] += BcAmHS[1] ⊗ HS[1] ⊕ BcCmHS[1]
    HS_tran[Ngrid] += BcAmHS[2] ⊗ HS[Ngrid] ⊕ BcCmHS[2]
    @.. HS_tran += alpha ⊗ (HS0 - HS)
    #  Transport of EIs
    @.. dTCO2 = HCO3_tran ⊕ CO3_tran ⊕ CO2_tran
    @.. dTH2S = H2S_tran ⊕ HS_tran
    # Transport of TA
    @.. TA_tran = -1 ⊗ H_tran ⊕ 1 ⊗ OH_tran
    @.. TA_tran += 1 ⊗ HCO3_tran ⊕ 2 ⊗ CO3_tran ⊕ 0 ⊗ CO2_tran
    @.. TA_tran += 0 ⊗ H2S_tran ⊕ 1 ⊗ HS_tran
    # Transport of proton
    @.. dH = TA_tran
    @.. dH -= dTCO2 ⊗ dTA_dTCO2
    @.. dH -= dTH2S ⊗ dTA_dTH2S
    @.. dH = dH / dTA_dH
    #---------------------------------------------------------------------
    #  Speciation code
    #---------------------------------------------------------------------
    #  Concentrations of adsorbed/dissolved species
    @.. TFe_dis = TFe / (KFe_ads ⊗ POC ⊗ dstopw ⊕ 1)
    @.. Fe_aq =
        3.98107170553497e-6 ⊗ TFe_dis / (
            0.01778279410038921 ⊗ CO3 ⊕ 3.019951720402014e-6 ⊗ Cl ⊕ 1.0 ⊗ HS ⊕
            3.630780547701011e-5 ⊗ SO4 ⊕ 3.98107170553497e-6
        )
    @.. FeCl_aq =
        3.019951720402014e-6 ⊗ Cl ⊗ TFe_dis / (
            0.01778279410038921 ⊗ CO3 ⊕ 3.019951720402014e-6 ⊗ Cl ⊕ 1.0 ⊗ HS ⊕
            3.630780547701011e-5 ⊗ SO4 ⊕ 3.98107170553497e-6
        )
    @.. FeSO4_aq =
        3.630780547701011e-5 ⊗ SO4 ⊗ TFe_dis / (
            0.01778279410038921 ⊗ CO3 ⊕ 3.019951720402014e-6 ⊗ Cl ⊕ 1.0 ⊗ HS ⊕
            3.630780547701011e-5 ⊗ SO4 ⊕ 3.98107170553497e-6
        )
    @.. FeCO3_aq =
        0.01778279410038921 ⊗ CO3 ⊗ TFe_dis / (
            0.01778279410038921 ⊗ CO3 ⊕ 3.019951720402014e-6 ⊗ Cl ⊕ 1.0 ⊗ HS ⊕
            3.630780547701011e-5 ⊗ SO4 ⊕ 3.98107170553497e-6
        )
    @.. FeHS_aq =
        1.0 ⊗ HS ⊗ TFe_dis / (
            0.01778279410038921 ⊗ CO3 ⊕ 3.019951720402014e-6 ⊗ Cl ⊕ 1.0 ⊗ HS ⊕
            3.630780547701011e-5 ⊗ SO4 ⊕ 3.98107170553497e-6
        )
    @.. Fe_ads = KFe_ads ⊗ POC ⊗ TFe_dis
    @.. TFe_ads_POC = Fe_ads
    @.. TFe_ads = Fe_ads
    #  Transport of adsorbed/dissolved species
    mul!(TFe_dis_tran, AmTFe_dis, TFe_dis)
    TFe_dis_tran[1] += BcAmTFe_dis[1] ⊗ TFe_dis[1] ⊕ BcCmTFe_dis[1]
    TFe_dis_tran[Ngrid] += BcAmTFe_dis[2] ⊗ TFe_dis[Ngrid] ⊕ BcCmTFe_dis[2]
    mul!(TFe_ads_POC_tran, AmTFe_ads_POC, TFe_ads_POC)
    TFe_ads_POC_tran[1] +=
        BcAmTFe_ads_POC[1] ⊗ TFe_ads_POC[1] ⊕ BcCmTFe_ads_POC[1]
    TFe_ads_POC_tran[Ngrid] +=
        BcAmTFe_ads_POC[2] ⊗ TFe_ads_POC[Ngrid] ⊕ BcCmTFe_ads_POC[2]
    @.. dTFe = TFe_dis_tran ⊗ 1 ⊕ TFe_ads_POC_tran ⊗ dstopw
    @.. dTFe += alpha ⊗ (TFe_dis0 - TFe_dis)

    #---------------------------------------------------------------------
    #  Reaction code
    #---------------------------------------------------------------------
    # Individual reaction rates
    @.. Omega_RFeS_pre = Fe_aq ⊗ HS / (H ⊗ KspFeS)
    @.. RFeOOHPOC = FeOOH / (KFeOOH ⊕ FeOOH) ⊗ k_POC ⊗ POC
    @.. RSO4POC = SO4 / (KSO4 ⊕ SO4) ⊗ KFeOOH / (KFeOOH ⊕ FeOOH) ⊗ k_POC ⊗ POC
    @.. RFeOOHH2S = kFeOOHH2S ⊗ FeOOH ⊗ TH2S
    @.. RFeS_pre =
        (tanh(1e3 ⊗ (Omega_RFeS_pre - 1.0)) / 2 ⊕ 0.5) ⊗
        (kFeSpre ⊗ (Omega_RFeS_pre - 1))

    # Summed rates for model substances
    @.. S_POC = -1 ⊗ RFeOOHPOC ⊕ -1 ⊗ RSO4POC
    @.. S_FeOOH = -4 ⊗ RFeOOHPOC ⊕ -2 ⊗ RFeOOHH2S
    @.. S_TCO2 = 1 ⊗ RFeOOHPOC ⊗ dstopw ⊕ 1 ⊗ RSO4POC ⊗ dstopw
    @.. S_TFe = 4 ⊗ RFeOOHPOC ⊗ dstopw ⊕ 2 ⊗ RFeOOHH2S ⊗ dstopw ⊕ -1 ⊗ RFeS_pre
    @.. S_SO4 = -1 / 2 ⊗ RSO4POC ⊗ dstopw
    @.. S_TH2S =
        1 / 2 ⊗ RSO4POC ⊗ dstopw ⊕ -1 ⊗ RFeOOHH2S ⊗ dstopw ⊕ -1 ⊗ RFeS_pre
    @.. S_FeS = 1 ⊗ RFeS_pre ⊗ pwtods
    @.. S_TA =
        8 ⊗ RFeOOHPOC ⊗ dstopw ⊕ 1 ⊗ RSO4POC ⊗ dstopw ⊕ 4 ⊗ RFeOOHH2S ⊗ dstopw ⊕
        -1 ⊗ RFeS_pre
    @.. S_TA += -1 ⊗ RFeS_pre
    @.. S_H = S_TA
    @.. S_H -= S_TCO2 ⊗ dTA_dTCO2
    @.. S_H -= S_TH2S ⊗ dTA_dTH2S
    @.. S_H = S_H / dTA_dH

    @.. dPOC += S_POC
    @.. dFeOOH += S_FeOOH
    @.. dFeS += S_FeS
    @.. dSO4 += S_SO4
    @.. dTFe += S_TFe
    @.. dH += S_H
    @.. dTCO2 += S_TCO2
    @.. dTH2S += S_TH2S

    return nothing
end
