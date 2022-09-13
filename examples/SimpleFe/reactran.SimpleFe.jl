function (f::Cache.Reactran)(dC, C, parms::Param.ParamStruct, t)
    @unpack TFeID,
    POCID,
    FeOOHID,
    FeSID,
    O2ID,
    SO4ID,
    HID,
    TCO2ID,
    TH2SID,
    AmPOC,
    AmFeOOH,
    AmFeS,
    AmO2,
    AmSO4,
    AmH,
    AmOH,
    AmHCO3,
    AmCO3,
    AmCO2,
    AmH2S,
    AmHS,
    AmFe,
    AmFe_ads,
    BcAmPOC,
    BcCmPOC,
    BcAmFeOOH,
    BcCmFeOOH,
    BcAmFeS,
    BcCmFeS,
    BcAmO2,
    BcCmO2,
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
    BcAmFe,
    BcCmFe,
    BcAmFe_ads,
    BcCmFe_ads,
    alpha,
    O20,
    SO40,
    H0,
    OH0,
    HCO30,
    CO30,
    CO20,
    H2S0,
    HS0,
    Fe0,
    KFe_ads,
    dstopw,
    KH2O,
    KCO2,
    KHCO3,
    KH2S,
    Cl,
    KspFeS,
    pwtods,
    KO2,
    k_POC,
    KFeOOH,
    KSO4,
    kO2Fe,
    kO2Fe_ads,
    kO2H2S,
    kFeOOHH2S,
    kFeSdis,
    kFeSpre = parms

    Fe = PreallocationTools.get_tmp(f.Fe, C)
    Fe_tran = PreallocationTools.get_tmp(f.Fe_tran, C)
    Fe_ads = PreallocationTools.get_tmp(f.Fe_ads, C)
    Fe_ads_tran = PreallocationTools.get_tmp(f.Fe_ads_tran, C)
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
    Fe_free = PreallocationTools.get_tmp(f.Fe_free, C)
    FeCl_aq = PreallocationTools.get_tmp(f.FeCl_aq, C)
    FeSO4_aq = PreallocationTools.get_tmp(f.FeSO4_aq, C)
    FeCO3_aq = PreallocationTools.get_tmp(f.FeCO3_aq, C)
    FeHS_aq = PreallocationTools.get_tmp(f.FeHS_aq, C)
    Omega_RFeS_dis = PreallocationTools.get_tmp(f.Omega_RFeS_dis, C)
    Omega_RFeS_pre = PreallocationTools.get_tmp(f.Omega_RFeS_pre, C)
    RO2POC = PreallocationTools.get_tmp(f.RO2POC, C)
    RFeOOHPOC = PreallocationTools.get_tmp(f.RFeOOHPOC, C)
    RSO4POC = PreallocationTools.get_tmp(f.RSO4POC, C)
    RO2Fe = PreallocationTools.get_tmp(f.RO2Fe, C)
    RO2Fe_ads = PreallocationTools.get_tmp(f.RO2Fe_ads, C)
    RO2H2S = PreallocationTools.get_tmp(f.RO2H2S, C)
    RFeOOHH2S = PreallocationTools.get_tmp(f.RFeOOHH2S, C)
    RFeS_dis = PreallocationTools.get_tmp(f.RFeS_dis, C)
    RFeS_pre = PreallocationTools.get_tmp(f.RFeS_pre, C)
    S_POC = PreallocationTools.get_tmp(f.S_POC, C)
    S_O2 = PreallocationTools.get_tmp(f.S_O2, C)
    S_TCO2 = PreallocationTools.get_tmp(f.S_TCO2, C)
    S_FeOOH = PreallocationTools.get_tmp(f.S_FeOOH, C)
    S_TFe = PreallocationTools.get_tmp(f.S_TFe, C)
    S_SO4 = PreallocationTools.get_tmp(f.S_SO4, C)
    S_TH2S = PreallocationTools.get_tmp(f.S_TH2S, C)
    S_FeS = PreallocationTools.get_tmp(f.S_FeS, C)
    S_TA = PreallocationTools.get_tmp(f.S_TA, C)
    S_H = PreallocationTools.get_tmp(f.S_H, C)

    TFe = @view C[TFeID]
    POC = @view C[POCID]
    FeOOH = @view C[FeOOHID]
    FeS = @view C[FeSID]
    O2 = @view C[O2ID]
    SO4 = @view C[SO4ID]
    H = @view C[HID]
    TCO2 = @view C[TCO2ID]
    TH2S = @view C[TH2SID]

    dTFe = @view dC[TFeID]
    dPOC = @view dC[POCID]
    dFeOOH = @view dC[FeOOHID]
    dFeS = @view dC[FeSID]
    dO2 = @view dC[O2ID]
    dSO4 = @view dC[SO4ID]
    dH = @view dC[HID]
    dTCO2 = @view dC[TCO2ID]
    dTH2S = @view dC[TH2SID]

    mul!(dPOC, AmPOC, POC)
    mul!(dFeOOH, AmFeOOH, FeOOH)
    mul!(dFeS, AmFeS, FeS)
    mul!(dO2, AmO2, O2)
    mul!(dSO4, AmSO4, SO4)

    dPOC[1] += BcAmPOC[1] ⊗ POC[1] ⊕ BcCmPOC[1]
    dFeOOH[1] += BcAmFeOOH[1] ⊗ FeOOH[1] ⊕ BcCmFeOOH[1]
    dFeS[1] += BcAmFeS[1] ⊗ FeS[1] ⊕ BcCmFeS[1]
    dO2[1] += BcAmO2[1] ⊗ O2[1] ⊕ BcCmO2[1]
    dSO4[1] += BcAmSO4[1] ⊗ SO4[1] ⊕ BcCmSO4[1]
    dPOC[Ngrid] += BcAmPOC[2] ⊗ POC[Ngrid] ⊕ BcCmPOC[2]
    dFeOOH[Ngrid] += BcAmFeOOH[2] ⊗ FeOOH[Ngrid] ⊕ BcCmFeOOH[2]
    dFeS[Ngrid] += BcAmFeS[2] ⊗ FeS[Ngrid] ⊕ BcCmFeS[2]
    dO2[Ngrid] += BcAmO2[2] ⊗ O2[Ngrid] ⊕ BcCmO2[2]
    dSO4[Ngrid] += BcAmSO4[2] ⊗ SO4[Ngrid] ⊕ BcCmSO4[2]

    @.. dO2 += alpha ⊗ (O20 - O2)
    @.. dSO4 += alpha ⊗ (SO40 - SO4)

    @.. Fe = TFe / (KFe_ads ⊗ POC ⊗ dstopw ⊕ 1)
    mul!(Fe_tran, AmFe, Fe)
    Fe_tran[1] += BcAmFe[1] ⊗ Fe[1] ⊕ BcCmFe[1]
    Fe_tran[Ngrid] += BcAmFe[2] ⊗ Fe[Ngrid] ⊕ BcCmFe[2]
    @.. Fe_ads = KFe_ads ⊗ POC ⊗ Fe
    mul!(Fe_ads_tran, AmFe_ads, Fe_ads)
    Fe_ads_tran[1] += BcAmFe_ads[1] ⊗ Fe_ads[1] ⊕ BcCmFe_ads[1]
    Fe_ads_tran[Ngrid] += BcAmFe_ads[2] ⊗ Fe_ads[Ngrid] ⊕ BcCmFe_ads[2]
    @.. dTFe = Fe_ads_tran ⊗ dstopw ⊕ Fe_tran ⊗ 1
    @.. dTFe += alpha ⊗ (Fe0 - Fe)


    @.. OH = KH2O / H
    @.. HCO3 = H ⊗ KCO2 ⊗ TCO2 / (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)
    @.. CO3 = KCO2 ⊗ KHCO3 ⊗ TCO2 / (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)
    @.. CO2 = H^2 ⊗ TCO2 / (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)
    @.. H2S = H ⊗ TH2S / (H ⊕ KH2S)
    @.. HS = KH2S ⊗ TH2S / (H ⊕ KH2S)

    @.. dTA_dTCO2 = KCO2 ⊗ (H ⊕ 2 ⊗ KHCO3) / (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)
    @.. dTA_dTH2S = KH2S / (H ⊕ KH2S)

    @.. dTA_dH = -(H^2 ⊕ KH2O) / H^2
    @.. dTA_dH +=
        -KCO2 ⊗ TCO2 ⊗ (H^2 ⊕ 4 ⊗ H ⊗ KHCO3 ⊕ KCO2 ⊗ KHCO3) /
        (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)^2
    @.. dTA_dH += -KH2S ⊗ TH2S / (H ⊕ KH2S)^2


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


    @.. dTCO2 = HCO3_tran ⊕ CO3_tran ⊕ CO2_tran
    @.. dTH2S = H2S_tran ⊕ HS_tran

    @.. TA_tran = -1 ⊗ H_tran ⊕ 1 ⊗ OH_tran
    @.. TA_tran += 1 ⊗ HCO3_tran ⊕ 2 ⊗ CO3_tran ⊕ 0 ⊗ CO2_tran
    @.. TA_tran += 0 ⊗ H2S_tran ⊕ 1 ⊗ HS_tran

    @.. dH = TA_tran
    @.. dH -= dTCO2 ⊗ dTA_dTCO2
    @.. dH -= dTH2S ⊗ dTA_dTH2S
    @.. dH = dH / dTA_dH
    # speciation
    @.. Fe_free =
        3.98107170553497e-6 ⊗ Fe / (
            0.01778279410038921 ⊗ CO3 ⊕ 3.019951720402014e-6 ⊗ Cl ⊕ 1.0 ⊗ HS ⊕
            3.630780547701011e-5 ⊗ SO4 ⊕ 3.98107170553497e-6
        )
    @.. FeCl_aq =
        3.019951720402014e-6 ⊗ Cl ⊗ Fe / (
            0.01778279410038921 ⊗ CO3 ⊕ 3.019951720402014e-6 ⊗ Cl ⊕ 1.0 ⊗ HS ⊕
            3.630780547701011e-5 ⊗ SO4 ⊕ 3.98107170553497e-6
        )
    @.. FeSO4_aq =
        3.630780547701011e-5 ⊗ Fe ⊗ SO4 / (
            0.01778279410038921 ⊗ CO3 ⊕ 3.019951720402014e-6 ⊗ Cl ⊕ 1.0 ⊗ HS ⊕
            3.630780547701011e-5 ⊗ SO4 ⊕ 3.98107170553497e-6
        )
    @.. FeCO3_aq =
        0.01778279410038921 ⊗ CO3 ⊗ Fe / (
            0.01778279410038921 ⊗ CO3 ⊕ 3.019951720402014e-6 ⊗ Cl ⊕ 1.0 ⊗ HS ⊕
            3.630780547701011e-5 ⊗ SO4 ⊕ 3.98107170553497e-6
        )
    @.. FeHS_aq =
        1.0 ⊗ Fe ⊗ HS / (
            0.01778279410038921 ⊗ CO3 ⊕ 3.019951720402014e-6 ⊗ Cl ⊕ 1.0 ⊗ HS ⊕
            3.630780547701011e-5 ⊗ SO4 ⊕ 3.98107170553497e-6
        )

    # reaction rates
    @.. Omega_RFeS_dis = Fe_free ⊗ HS / (H ⊗ KspFeS)
    @.. Omega_RFeS_pre = Fe_free ⊗ HS / (H ⊗ KspFeS)
    @.. RO2POC = O2 / (KO2 ⊕ O2) ⊗ k_POC ⊗ POC
    @.. RFeOOHPOC = FeOOH / (KFeOOH ⊕ FeOOH) ⊗ KO2 / (KO2 ⊕ O2) ⊗ k_POC ⊗ POC
    @.. RSO4POC =
        SO4 / (KSO4 ⊕ SO4) ⊗ KFeOOH / (KFeOOH ⊕ FeOOH) ⊗ KO2 / (KO2 ⊕ O2) ⊗
        k_POC ⊗ POC
    @.. RO2Fe = kO2Fe ⊗ O2 ⊗ Fe
    @.. RO2Fe_ads = kO2Fe_ads ⊗ O2 ⊗ Fe_ads
    @.. RO2H2S = kO2H2S ⊗ O2 ⊗ TH2S
    @.. RFeOOHH2S = kFeOOHH2S ⊗ FeOOH ⊗ TH2S
    @.. RFeS_dis =
        (-tanh(1e3 ⊗ (Omega_RFeS_dis - 1.0)) / 2 ⊕ 0.5) ⊗
        (kFeSdis ⊗ FeS ⊗ (1 - Omega_RFeS_dis))
    @.. RFeS_pre =
        (tanh(1e3 ⊗ (Omega_RFeS_pre - 1.0)) / 2 ⊕ 0.5) ⊗
        (kFeSpre ⊗ (Omega_RFeS_pre - 1))

    # species rates
    @.. S_POC = -1 ⊗ RO2POC ⊕ -1 ⊗ RFeOOHPOC ⊕ -1 ⊗ RSO4POC
    @.. S_O2 =
        -1 ⊗ RO2POC ⊗ dstopw ⊕ -1 / 4 ⊗ RO2Fe ⊕ -1 / 4 ⊗ RO2Fe_ads ⊗ dstopw ⊕
        -2 ⊗ RO2H2S
    @.. S_TCO2 =
        1 ⊗ RO2POC ⊗ dstopw ⊕ 1 ⊗ RFeOOHPOC ⊗ dstopw ⊕ 1 ⊗ RSO4POC ⊗ dstopw
    @.. S_FeOOH =
        -4 ⊗ RFeOOHPOC ⊕ 1 ⊗ RO2Fe ⊗ pwtods ⊕ 1 ⊗ RO2Fe_ads ⊕ -2 ⊗ RFeOOHH2S
    @.. S_TFe =
        4 ⊗ RFeOOHPOC ⊗ dstopw ⊕ -1 ⊗ RO2Fe ⊕ -1 ⊗ RO2Fe_ads ⊗ dstopw ⊕
        2 ⊗ RFeOOHH2S ⊗ dstopw ⊕ 1 ⊗ RFeS_dis ⊗ dstopw ⊕ -1 ⊗ RFeS_pre
    @.. S_SO4 = -1 / 2 ⊗ RSO4POC ⊗ dstopw ⊕ 1 ⊗ RO2H2S
    @.. S_TH2S =
        1 / 2 ⊗ RSO4POC ⊗ dstopw ⊕ -1 ⊗ RO2H2S ⊕ -1 ⊗ RFeOOHH2S ⊗ dstopw ⊕
        1 ⊗ RFeS_dis ⊗ dstopw ⊕ -1 ⊗ RFeS_pre
    @.. S_FeS = -1 ⊗ RFeS_dis ⊕ 1 ⊗ RFeS_pre ⊗ pwtods
    @.. S_TA =
        8 ⊗ RFeOOHPOC ⊗ dstopw ⊕ 1 ⊗ RSO4POC ⊗ dstopw ⊕ -2 ⊗ RO2Fe ⊕
        -2 ⊗ RO2H2S ⊕ 4 ⊗ RFeOOHH2S ⊗ dstopw ⊕ 1 ⊗ RFeS_dis ⊗ dstopw ⊕
        -1 ⊗ RFeS_pre
    @.. S_TA += 1 ⊗ RFeS_dis ⊗ dstopw ⊕ -1 ⊗ RFeS_pre
    @.. S_H = S_TA
    @.. S_H -= S_TCO2 ⊗ dTA_dTCO2
    @.. S_H -= S_TH2S ⊗ dTA_dTH2S
    @.. S_H = S_H / dTA_dH

    @.. dTFe += S_TFe
    @.. dPOC += S_POC
    @.. dFeOOH += S_FeOOH
    @.. dFeS += S_FeS
    @.. dO2 += S_O2
    @.. dSO4 += S_SO4
    @.. dH += S_H
    @.. dTCO2 += S_TCO2
    @.. dTH2S += S_TH2S

    return nothing
end
