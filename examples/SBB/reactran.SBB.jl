function (f::Cache.Reactran)(dC, C, parms::Param.ParamStruct, t)
    @unpack TMnID,
    TFeID,
    TNH4ID,
    POCID,
    MnO2ID,
    FeOOHID,
    FeSID,
    FeS2ID,
    CaCO3ID,
    MnCO3ID,
    FeCO3ID,
    AgeID,
    BSiID,
    SMoID,
    O2ID,
    NO3ID,
    CH4ID,
    NO2ID,
    CaID,
    MoID,
    H4SiO4ID,
    TH3PO4ID,
    THSO4ID,
    HID,
    TCO2ID,
    TH2SID,
    TH3BO3ID,
    THFID,
    AmPOC,
    AmMnO2,
    AmFeOOH,
    AmFeS,
    AmFeS2,
    AmCaCO3,
    AmMnCO3,
    AmFeCO3,
    AmAge,
    AmBSi,
    AmSMo,
    AmO2,
    AmNO3,
    AmCH4,
    AmNO2,
    AmCa,
    AmMo,
    AmH4SiO4,
    AmH3PO4,
    AmH2PO4,
    AmHPO4,
    AmPO4,
    AmHSO4,
    AmSO4,
    AmH,
    AmOH,
    AmHCO3,
    AmCO3,
    AmCO2,
    AmH2S,
    AmHS,
    AmH3BO3,
    AmH4BO4,
    AmHF,
    AmF,
    AmMn,
    AmMn_ads,
    AmFe,
    AmFe_ads,
    AmNH4,
    AmNH4_ads,
    BcAmPOC,
    BcCmPOC,
    BcAmMnO2,
    BcCmMnO2,
    BcAmFeOOH,
    BcCmFeOOH,
    BcAmFeS,
    BcCmFeS,
    BcAmFeS2,
    BcCmFeS2,
    BcAmCaCO3,
    BcCmCaCO3,
    BcAmMnCO3,
    BcCmMnCO3,
    BcAmFeCO3,
    BcCmFeCO3,
    BcAmAge,
    BcCmAge,
    BcAmBSi,
    BcCmBSi,
    BcAmSMo,
    BcCmSMo,
    BcAmO2,
    BcCmO2,
    BcAmNO3,
    BcCmNO3,
    BcAmCH4,
    BcCmCH4,
    BcAmNO2,
    BcCmNO2,
    BcAmCa,
    BcCmCa,
    BcAmMo,
    BcCmMo,
    BcAmH4SiO4,
    BcCmH4SiO4,
    Ngrid,
    BcAmH3PO4,
    BcCmH3PO4,
    BcAmH2PO4,
    BcCmH2PO4,
    BcAmHPO4,
    BcCmHPO4,
    BcAmPO4,
    BcCmPO4,
    BcAmHSO4,
    BcCmHSO4,
    BcAmSO4,
    BcCmSO4,
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
    BcAmH3BO3,
    BcCmH3BO3,
    BcAmH4BO4,
    BcCmH4BO4,
    BcAmHF,
    BcCmHF,
    BcAmF,
    BcCmF,
    BcAmMn,
    BcCmMn,
    BcAmMn_ads,
    BcCmMn_ads,
    BcAmFe,
    BcCmFe,
    BcAmFe_ads,
    BcCmFe_ads,
    BcAmNH4,
    BcCmNH4,
    BcAmNH4_ads,
    BcCmNH4_ads,
    alpha,
    O2BW,
    NO3BW,
    CH4BW,
    NO2BW,
    CaBW,
    MoBW,
    H4SiO4BW,
    H3PO4BW,
    H2PO4BW,
    HPO4BW,
    PO4BW,
    HSO4BW,
    SO4BW,
    HBW,
    OHBW,
    HCO3BW,
    CO3BW,
    CO2BW,
    H2SBW,
    HSBW,
    H3BO3BW,
    H4BO4BW,
    HFBW,
    FBW,
    Mn0,
    Fe0,
    NH40,
    KMn_ads,
    dstopw,
    KFe_ads,
    KNH4_ads,
    KH3PO4,
    KH2PO4,
    KHPO4,
    KHSO4,
    KH2O,
    KCO2,
    KHCO3,
    KH2S,
    KH3BO3,
    KHF,
    Cl,
    KspFeS,
    KspCaCO3_dis,
    KspCaCO3_pre,
    KspMnCO3,
    KspFeCO3,
    H4SiO4_dis_sat,
    H4SiO4_pre_sat,
    KspCFA,
    rNC,
    rPC,
    pwtods,
    KO2,
    nu,
    a,
    KNO2,
    KNO3,
    KMnO2,
    KFeOOH,
    KTHSO4,
    kO2NO2,
    kO2NH4,
    kO2Mn,
    kO2Mn_ads,
    kO2Fe,
    kO2Fe_ads,
    kO2H2S,
    kO2FeS,
    kO2CH4,
    kNO2NH4,
    kNO3Mn,
    kNO3Fe,
    kNO3H2S,
    kAOM,
    KAOM,
    kMnO2Fe,
    kMnO2H2S,
    kFeOOHH2S,
    kFeSH2S,
    kFeSdis,
    kFeSpre,
    kCaCO3dis,
    kCaCO3pre,
    kMnCO3dis,
    kMnCO3pre,
    kFeCO3dis,
    kFeCO3pre,
    kBSidis,
    kASipre,
    kMoS4_pre,
    kCFA_pre = parms

    Mn = PreallocationTools.get_tmp(f.Mn, C)
    Mn_tran = PreallocationTools.get_tmp(f.Mn_tran, C)
    Mn_ads = PreallocationTools.get_tmp(f.Mn_ads, C)
    Mn_ads_tran = PreallocationTools.get_tmp(f.Mn_ads_tran, C)
    Fe = PreallocationTools.get_tmp(f.Fe, C)
    Fe_tran = PreallocationTools.get_tmp(f.Fe_tran, C)
    Fe_ads = PreallocationTools.get_tmp(f.Fe_ads, C)
    Fe_ads_tran = PreallocationTools.get_tmp(f.Fe_ads_tran, C)
    NH4 = PreallocationTools.get_tmp(f.NH4, C)
    NH4_tran = PreallocationTools.get_tmp(f.NH4_tran, C)
    NH4_ads = PreallocationTools.get_tmp(f.NH4_ads, C)
    NH4_ads_tran = PreallocationTools.get_tmp(f.NH4_ads_tran, C)
    H3PO4 = PreallocationTools.get_tmp(f.H3PO4, C)
    H2PO4 = PreallocationTools.get_tmp(f.H2PO4, C)
    HPO4 = PreallocationTools.get_tmp(f.HPO4, C)
    PO4 = PreallocationTools.get_tmp(f.PO4, C)
    HSO4 = PreallocationTools.get_tmp(f.HSO4, C)
    SO4 = PreallocationTools.get_tmp(f.SO4, C)
    OH = PreallocationTools.get_tmp(f.OH, C)
    HCO3 = PreallocationTools.get_tmp(f.HCO3, C)
    CO3 = PreallocationTools.get_tmp(f.CO3, C)
    CO2 = PreallocationTools.get_tmp(f.CO2, C)
    H2S = PreallocationTools.get_tmp(f.H2S, C)
    HS = PreallocationTools.get_tmp(f.HS, C)
    H3BO3 = PreallocationTools.get_tmp(f.H3BO3, C)
    H4BO4 = PreallocationTools.get_tmp(f.H4BO4, C)
    HF = PreallocationTools.get_tmp(f.HF, C)
    F = PreallocationTools.get_tmp(f.F, C)
    H3PO4_tran = PreallocationTools.get_tmp(f.H3PO4_tran, C)
    H2PO4_tran = PreallocationTools.get_tmp(f.H2PO4_tran, C)
    HPO4_tran = PreallocationTools.get_tmp(f.HPO4_tran, C)
    PO4_tran = PreallocationTools.get_tmp(f.PO4_tran, C)
    HSO4_tran = PreallocationTools.get_tmp(f.HSO4_tran, C)
    SO4_tran = PreallocationTools.get_tmp(f.SO4_tran, C)
    H_tran = PreallocationTools.get_tmp(f.H_tran, C)
    OH_tran = PreallocationTools.get_tmp(f.OH_tran, C)
    HCO3_tran = PreallocationTools.get_tmp(f.HCO3_tran, C)
    CO3_tran = PreallocationTools.get_tmp(f.CO3_tran, C)
    CO2_tran = PreallocationTools.get_tmp(f.CO2_tran, C)
    H2S_tran = PreallocationTools.get_tmp(f.H2S_tran, C)
    HS_tran = PreallocationTools.get_tmp(f.HS_tran, C)
    H3BO3_tran = PreallocationTools.get_tmp(f.H3BO3_tran, C)
    H4BO4_tran = PreallocationTools.get_tmp(f.H4BO4_tran, C)
    HF_tran = PreallocationTools.get_tmp(f.HF_tran, C)
    F_tran = PreallocationTools.get_tmp(f.F_tran, C)
    TA_tran = PreallocationTools.get_tmp(f.TA_tran, C)
    dTA_dH = PreallocationTools.get_tmp(f.dTA_dH, C)
    dTA_dTH3PO4 = PreallocationTools.get_tmp(f.dTA_dTH3PO4, C)
    dTA_dTHSO4 = PreallocationTools.get_tmp(f.dTA_dTHSO4, C)
    dTA_dTCO2 = PreallocationTools.get_tmp(f.dTA_dTCO2, C)
    dTA_dTH2S = PreallocationTools.get_tmp(f.dTA_dTH2S, C)
    dTA_dTH3BO3 = PreallocationTools.get_tmp(f.dTA_dTH3BO3, C)
    dTA_dTHF = PreallocationTools.get_tmp(f.dTA_dTHF, C)
    Fe_free = PreallocationTools.get_tmp(f.Fe_free, C)
    FeCl_aq = PreallocationTools.get_tmp(f.FeCl_aq, C)
    FeSO4_aq = PreallocationTools.get_tmp(f.FeSO4_aq, C)
    FeCO3_aq = PreallocationTools.get_tmp(f.FeCO3_aq, C)
    Fe_CO3_OH_aq = PreallocationTools.get_tmp(f.Fe_CO3_OH_aq, C)
    FeHS_aq = PreallocationTools.get_tmp(f.FeHS_aq, C)
    FeS_aq = PreallocationTools.get_tmp(f.FeS_aq, C)
    MoO4 = PreallocationTools.get_tmp(f.MoO4, C)
    MoO3S_aq = PreallocationTools.get_tmp(f.MoO3S_aq, C)
    MoO2S2_aq = PreallocationTools.get_tmp(f.MoO2S2_aq, C)
    MoOS3_aq = PreallocationTools.get_tmp(f.MoOS3_aq, C)
    MoS4_aq = PreallocationTools.get_tmp(f.MoS4_aq, C)
    Omega_RFeS_dis = PreallocationTools.get_tmp(f.Omega_RFeS_dis, C)
    Omega_RFeS_pre = PreallocationTools.get_tmp(f.Omega_RFeS_pre, C)
    Omega_RCaCO3_dis = PreallocationTools.get_tmp(f.Omega_RCaCO3_dis, C)
    Omega_RCaCO3_pre = PreallocationTools.get_tmp(f.Omega_RCaCO3_pre, C)
    Omega_RMnCO3_dis = PreallocationTools.get_tmp(f.Omega_RMnCO3_dis, C)
    Omega_RMnCO3_pre = PreallocationTools.get_tmp(f.Omega_RMnCO3_pre, C)
    Omega_RFeCO3_dis = PreallocationTools.get_tmp(f.Omega_RFeCO3_dis, C)
    Omega_RFeCO3_pre = PreallocationTools.get_tmp(f.Omega_RFeCO3_pre, C)
    Omega_RBSi_dis = PreallocationTools.get_tmp(f.Omega_RBSi_dis, C)
    Omega_RASi_pre = PreallocationTools.get_tmp(f.Omega_RASi_pre, C)
    Omega_RCFA_pre = PreallocationTools.get_tmp(f.Omega_RCFA_pre, C)
    RO2POC = PreallocationTools.get_tmp(f.RO2POC, C)
    RNO2POC = PreallocationTools.get_tmp(f.RNO2POC, C)
    RNO3POC = PreallocationTools.get_tmp(f.RNO3POC, C)
    RMnO2POC = PreallocationTools.get_tmp(f.RMnO2POC, C)
    RFeOOHPOC = PreallocationTools.get_tmp(f.RFeOOHPOC, C)
    RSO4POC = PreallocationTools.get_tmp(f.RSO4POC, C)
    RCH4POC = PreallocationTools.get_tmp(f.RCH4POC, C)
    RO2NO2 = PreallocationTools.get_tmp(f.RO2NO2, C)
    RO2NH4 = PreallocationTools.get_tmp(f.RO2NH4, C)
    RO2Mn = PreallocationTools.get_tmp(f.RO2Mn, C)
    RO2Mn_ads = PreallocationTools.get_tmp(f.RO2Mn_ads, C)
    RO2Fe = PreallocationTools.get_tmp(f.RO2Fe, C)
    RO2Fe_ads = PreallocationTools.get_tmp(f.RO2Fe_ads, C)
    RO2H2S = PreallocationTools.get_tmp(f.RO2H2S, C)
    RO2FeS = PreallocationTools.get_tmp(f.RO2FeS, C)
    RO2CH4 = PreallocationTools.get_tmp(f.RO2CH4, C)
    RNO2NH4 = PreallocationTools.get_tmp(f.RNO2NH4, C)
    RNO3Mn = PreallocationTools.get_tmp(f.RNO3Mn, C)
    RNO3Fe = PreallocationTools.get_tmp(f.RNO3Fe, C)
    RNO3H2S = PreallocationTools.get_tmp(f.RNO3H2S, C)
    RSO4CH4 = PreallocationTools.get_tmp(f.RSO4CH4, C)
    RMnO2Fe = PreallocationTools.get_tmp(f.RMnO2Fe, C)
    RMnO2H2S = PreallocationTools.get_tmp(f.RMnO2H2S, C)
    RFeOOHH2S = PreallocationTools.get_tmp(f.RFeOOHH2S, C)
    RFeSH2S = PreallocationTools.get_tmp(f.RFeSH2S, C)
    RFeS_dis = PreallocationTools.get_tmp(f.RFeS_dis, C)
    RFeS_pre = PreallocationTools.get_tmp(f.RFeS_pre, C)
    RCaCO3_dis = PreallocationTools.get_tmp(f.RCaCO3_dis, C)
    RCaCO3_pre = PreallocationTools.get_tmp(f.RCaCO3_pre, C)
    RMnCO3_dis = PreallocationTools.get_tmp(f.RMnCO3_dis, C)
    RMnCO3_pre = PreallocationTools.get_tmp(f.RMnCO3_pre, C)
    RFeCO3_dis = PreallocationTools.get_tmp(f.RFeCO3_dis, C)
    RFeCO3_pre = PreallocationTools.get_tmp(f.RFeCO3_pre, C)
    RBSi_dis = PreallocationTools.get_tmp(f.RBSi_dis, C)
    RASi_pre = PreallocationTools.get_tmp(f.RASi_pre, C)
    RMoS4_pre = PreallocationTools.get_tmp(f.RMoS4_pre, C)
    RCFA_pre = PreallocationTools.get_tmp(f.RCFA_pre, C)
    S_POC = PreallocationTools.get_tmp(f.S_POC, C)
    S_O2 = PreallocationTools.get_tmp(f.S_O2, C)
    S_TCO2 = PreallocationTools.get_tmp(f.S_TCO2, C)
    S_TNH4 = PreallocationTools.get_tmp(f.S_TNH4, C)
    S_TH3PO4 = PreallocationTools.get_tmp(f.S_TH3PO4, C)
    S_NO2 = PreallocationTools.get_tmp(f.S_NO2, C)
    S_NO3 = PreallocationTools.get_tmp(f.S_NO3, C)
    S_MnO2 = PreallocationTools.get_tmp(f.S_MnO2, C)
    S_TMn = PreallocationTools.get_tmp(f.S_TMn, C)
    S_FeOOH = PreallocationTools.get_tmp(f.S_FeOOH, C)
    S_TFe = PreallocationTools.get_tmp(f.S_TFe, C)
    S_THSO4 = PreallocationTools.get_tmp(f.S_THSO4, C)
    S_TH2S = PreallocationTools.get_tmp(f.S_TH2S, C)
    S_CH4 = PreallocationTools.get_tmp(f.S_CH4, C)
    S_FeS = PreallocationTools.get_tmp(f.S_FeS, C)
    S_FeS2 = PreallocationTools.get_tmp(f.S_FeS2, C)
    S_CaCO3 = PreallocationTools.get_tmp(f.S_CaCO3, C)
    S_Ca = PreallocationTools.get_tmp(f.S_Ca, C)
    S_MnCO3 = PreallocationTools.get_tmp(f.S_MnCO3, C)
    S_FeCO3 = PreallocationTools.get_tmp(f.S_FeCO3, C)
    S_BSi = PreallocationTools.get_tmp(f.S_BSi, C)
    S_H4SiO4 = PreallocationTools.get_tmp(f.S_H4SiO4, C)
    S_Mo = PreallocationTools.get_tmp(f.S_Mo, C)
    S_SMo = PreallocationTools.get_tmp(f.S_SMo, C)
    S_THF = PreallocationTools.get_tmp(f.S_THF, C)
    S_TA = PreallocationTools.get_tmp(f.S_TA, C)
    S_H = PreallocationTools.get_tmp(f.S_H, C)
    S_Age = PreallocationTools.get_tmp(f.S_Age, C)

    TMn = @view C[TMnID]
    TFe = @view C[TFeID]
    TNH4 = @view C[TNH4ID]
    POC = @view C[POCID]
    MnO2 = @view C[MnO2ID]
    FeOOH = @view C[FeOOHID]
    FeS = @view C[FeSID]
    FeS2 = @view C[FeS2ID]
    CaCO3 = @view C[CaCO3ID]
    MnCO3 = @view C[MnCO3ID]
    FeCO3 = @view C[FeCO3ID]
    Age = @view C[AgeID]
    BSi = @view C[BSiID]
    SMo = @view C[SMoID]
    O2 = @view C[O2ID]
    NO3 = @view C[NO3ID]
    CH4 = @view C[CH4ID]
    NO2 = @view C[NO2ID]
    Ca = @view C[CaID]
    Mo = @view C[MoID]
    H4SiO4 = @view C[H4SiO4ID]
    TH3PO4 = @view C[TH3PO4ID]
    THSO4 = @view C[THSO4ID]
    H = @view C[HID]
    TCO2 = @view C[TCO2ID]
    TH2S = @view C[TH2SID]
    TH3BO3 = @view C[TH3BO3ID]
    THF = @view C[THFID]

    dTMn = @view dC[TMnID]
    dTFe = @view dC[TFeID]
    dTNH4 = @view dC[TNH4ID]
    dPOC = @view dC[POCID]
    dMnO2 = @view dC[MnO2ID]
    dFeOOH = @view dC[FeOOHID]
    dFeS = @view dC[FeSID]
    dFeS2 = @view dC[FeS2ID]
    dCaCO3 = @view dC[CaCO3ID]
    dMnCO3 = @view dC[MnCO3ID]
    dFeCO3 = @view dC[FeCO3ID]
    dAge = @view dC[AgeID]
    dBSi = @view dC[BSiID]
    dSMo = @view dC[SMoID]
    dO2 = @view dC[O2ID]
    dNO3 = @view dC[NO3ID]
    dCH4 = @view dC[CH4ID]
    dNO2 = @view dC[NO2ID]
    dCa = @view dC[CaID]
    dMo = @view dC[MoID]
    dH4SiO4 = @view dC[H4SiO4ID]
    dTH3PO4 = @view dC[TH3PO4ID]
    dTHSO4 = @view dC[THSO4ID]
    dH = @view dC[HID]
    dTCO2 = @view dC[TCO2ID]
    dTH2S = @view dC[TH2SID]
    dTH3BO3 = @view dC[TH3BO3ID]
    dTHF = @view dC[THFID]

    mul!(dPOC, AmPOC, POC)
    mul!(dMnO2, AmMnO2, MnO2)
    mul!(dFeOOH, AmFeOOH, FeOOH)
    mul!(dFeS, AmFeS, FeS)
    mul!(dFeS2, AmFeS2, FeS2)
    mul!(dCaCO3, AmCaCO3, CaCO3)
    mul!(dMnCO3, AmMnCO3, MnCO3)
    mul!(dFeCO3, AmFeCO3, FeCO3)
    mul!(dAge, AmAge, Age)
    mul!(dBSi, AmBSi, BSi)
    mul!(dSMo, AmSMo, SMo)
    mul!(dO2, AmO2, O2)
    mul!(dNO3, AmNO3, NO3)
    mul!(dCH4, AmCH4, CH4)
    mul!(dNO2, AmNO2, NO2)
    mul!(dCa, AmCa, Ca)
    mul!(dMo, AmMo, Mo)
    mul!(dH4SiO4, AmH4SiO4, H4SiO4)

    dPOC[1] += BcAmPOC[1] ⊗ POC[1] ⊕ BcCmPOC[1]
    dMnO2[1] += BcAmMnO2[1] ⊗ MnO2[1] ⊕ BcCmMnO2[1]
    dFeOOH[1] += BcAmFeOOH[1] ⊗ FeOOH[1] ⊕ BcCmFeOOH[1]
    dFeS[1] += BcAmFeS[1] ⊗ FeS[1] ⊕ BcCmFeS[1]
    dFeS2[1] += BcAmFeS2[1] ⊗ FeS2[1] ⊕ BcCmFeS2[1]
    dCaCO3[1] += BcAmCaCO3[1] ⊗ CaCO3[1] ⊕ BcCmCaCO3[1]
    dMnCO3[1] += BcAmMnCO3[1] ⊗ MnCO3[1] ⊕ BcCmMnCO3[1]
    dFeCO3[1] += BcAmFeCO3[1] ⊗ FeCO3[1] ⊕ BcCmFeCO3[1]
    dAge[1] += BcAmAge[1] ⊗ Age[1] ⊕ BcCmAge[1]
    dBSi[1] += BcAmBSi[1] ⊗ BSi[1] ⊕ BcCmBSi[1]
    dSMo[1] += BcAmSMo[1] ⊗ SMo[1] ⊕ BcCmSMo[1]
    dO2[1] += BcAmO2[1] ⊗ O2[1] ⊕ BcCmO2[1]
    dNO3[1] += BcAmNO3[1] ⊗ NO3[1] ⊕ BcCmNO3[1]
    dCH4[1] += BcAmCH4[1] ⊗ CH4[1] ⊕ BcCmCH4[1]
    dNO2[1] += BcAmNO2[1] ⊗ NO2[1] ⊕ BcCmNO2[1]
    dCa[1] += BcAmCa[1] ⊗ Ca[1] ⊕ BcCmCa[1]
    dMo[1] += BcAmMo[1] ⊗ Mo[1] ⊕ BcCmMo[1]
    dH4SiO4[1] += BcAmH4SiO4[1] ⊗ H4SiO4[1] ⊕ BcCmH4SiO4[1]
    dPOC[Ngrid] += BcAmPOC[2] ⊗ POC[Ngrid] ⊕ BcCmPOC[2]
    dMnO2[Ngrid] += BcAmMnO2[2] ⊗ MnO2[Ngrid] ⊕ BcCmMnO2[2]
    dFeOOH[Ngrid] += BcAmFeOOH[2] ⊗ FeOOH[Ngrid] ⊕ BcCmFeOOH[2]
    dFeS[Ngrid] += BcAmFeS[2] ⊗ FeS[Ngrid] ⊕ BcCmFeS[2]
    dFeS2[Ngrid] += BcAmFeS2[2] ⊗ FeS2[Ngrid] ⊕ BcCmFeS2[2]
    dCaCO3[Ngrid] += BcAmCaCO3[2] ⊗ CaCO3[Ngrid] ⊕ BcCmCaCO3[2]
    dMnCO3[Ngrid] += BcAmMnCO3[2] ⊗ MnCO3[Ngrid] ⊕ BcCmMnCO3[2]
    dFeCO3[Ngrid] += BcAmFeCO3[2] ⊗ FeCO3[Ngrid] ⊕ BcCmFeCO3[2]
    dAge[Ngrid] += BcAmAge[2] ⊗ Age[Ngrid] ⊕ BcCmAge[2]
    dBSi[Ngrid] += BcAmBSi[2] ⊗ BSi[Ngrid] ⊕ BcCmBSi[2]
    dSMo[Ngrid] += BcAmSMo[2] ⊗ SMo[Ngrid] ⊕ BcCmSMo[2]
    dO2[Ngrid] += BcAmO2[2] ⊗ O2[Ngrid] ⊕ BcCmO2[2]
    dNO3[Ngrid] += BcAmNO3[2] ⊗ NO3[Ngrid] ⊕ BcCmNO3[2]
    dCH4[Ngrid] += BcAmCH4[2] ⊗ CH4[Ngrid] ⊕ BcCmCH4[2]
    dNO2[Ngrid] += BcAmNO2[2] ⊗ NO2[Ngrid] ⊕ BcCmNO2[2]
    dCa[Ngrid] += BcAmCa[2] ⊗ Ca[Ngrid] ⊕ BcCmCa[2]
    dMo[Ngrid] += BcAmMo[2] ⊗ Mo[Ngrid] ⊕ BcCmMo[2]
    dH4SiO4[Ngrid] += BcAmH4SiO4[2] ⊗ H4SiO4[Ngrid] ⊕ BcCmH4SiO4[2]

    @.. dO2 += alpha ⊗ (O2BW - O2)
    @.. dNO3 += alpha ⊗ (NO3BW - NO3)
    @.. dCH4 += alpha ⊗ (CH4BW - CH4)
    @.. dNO2 += alpha ⊗ (NO2BW - NO2)
    @.. dCa += alpha ⊗ (CaBW - Ca)
    @.. dMo += alpha ⊗ (MoBW - Mo)
    @.. dH4SiO4 += alpha ⊗ (H4SiO4BW - H4SiO4)

    @.. Mn = TMn / (KMn_ads ⊗ dstopw ⊕ 1)
    mul!(Mn_tran, AmMn, Mn)
    Mn_tran[1] += BcAmMn[1] ⊗ Mn[1] ⊕ BcCmMn[1]
    Mn_tran[Ngrid] += BcAmMn[2] ⊗ Mn[Ngrid] ⊕ BcCmMn[2]
    @.. Mn_ads = KMn_ads ⊗ Mn
    mul!(Mn_ads_tran, AmMn_ads, Mn_ads)
    Mn_ads_tran[1] += BcAmMn_ads[1] ⊗ Mn_ads[1] ⊕ BcCmMn_ads[1]
    Mn_ads_tran[Ngrid] += BcAmMn_ads[2] ⊗ Mn_ads[Ngrid] ⊕ BcCmMn_ads[2]
    @.. dTMn = Mn_ads_tran ⊗ dstopw ⊕ Mn_tran ⊗ 1
    @.. dTMn += alpha ⊗ (Mn0 - Mn)

    @.. Fe = TFe / (KFe_ads ⊗ dstopw ⊕ 1)
    mul!(Fe_tran, AmFe, Fe)
    Fe_tran[1] += BcAmFe[1] ⊗ Fe[1] ⊕ BcCmFe[1]
    Fe_tran[Ngrid] += BcAmFe[2] ⊗ Fe[Ngrid] ⊕ BcCmFe[2]
    @.. Fe_ads = KFe_ads ⊗ Fe
    mul!(Fe_ads_tran, AmFe_ads, Fe_ads)
    Fe_ads_tran[1] += BcAmFe_ads[1] ⊗ Fe_ads[1] ⊕ BcCmFe_ads[1]
    Fe_ads_tran[Ngrid] += BcAmFe_ads[2] ⊗ Fe_ads[Ngrid] ⊕ BcCmFe_ads[2]
    @.. dTFe = Fe_ads_tran ⊗ dstopw ⊕ Fe_tran ⊗ 1
    @.. dTFe += alpha ⊗ (Fe0 - Fe)

    @.. NH4 = TNH4 / (KNH4_ads ⊗ dstopw ⊕ 1)
    mul!(NH4_tran, AmNH4, NH4)
    NH4_tran[1] += BcAmNH4[1] ⊗ NH4[1] ⊕ BcCmNH4[1]
    NH4_tran[Ngrid] += BcAmNH4[2] ⊗ NH4[Ngrid] ⊕ BcCmNH4[2]
    @.. NH4_ads = KNH4_ads ⊗ NH4
    mul!(NH4_ads_tran, AmNH4_ads, NH4_ads)
    NH4_ads_tran[1] += BcAmNH4_ads[1] ⊗ NH4_ads[1] ⊕ BcCmNH4_ads[1]
    NH4_ads_tran[Ngrid] += BcAmNH4_ads[2] ⊗ NH4_ads[Ngrid] ⊕ BcCmNH4_ads[2]
    @.. dTNH4 = NH4_ads_tran ⊗ dstopw ⊕ NH4_tran ⊗ 1
    @.. dTNH4 += alpha ⊗ (NH40 - NH4)


    @.. H3PO4 =
        H^3 ⊗ TH3PO4 /
        (H^3 ⊕ H^2 ⊗ KH3PO4 ⊕ H ⊗ KH2PO4 ⊗ KH3PO4 ⊕ KH2PO4 ⊗ KH3PO4 ⊗ KHPO4)
    @.. H2PO4 =
        H^2 ⊗ KH3PO4 ⊗ TH3PO4 /
        (H^3 ⊕ H^2 ⊗ KH3PO4 ⊕ H ⊗ KH2PO4 ⊗ KH3PO4 ⊕ KH2PO4 ⊗ KH3PO4 ⊗ KHPO4)
    @.. HPO4 =
        H ⊗ KH2PO4 ⊗ KH3PO4 ⊗ TH3PO4 /
        (H^3 ⊕ H^2 ⊗ KH3PO4 ⊕ H ⊗ KH2PO4 ⊗ KH3PO4 ⊕ KH2PO4 ⊗ KH3PO4 ⊗ KHPO4)
    @.. PO4 =
        KH2PO4 ⊗ KH3PO4 ⊗ KHPO4 ⊗ TH3PO4 /
        (H^3 ⊕ H^2 ⊗ KH3PO4 ⊕ H ⊗ KH2PO4 ⊗ KH3PO4 ⊕ KH2PO4 ⊗ KH3PO4 ⊗ KHPO4)
    @.. HSO4 = H ⊗ THSO4 / (H ⊕ KHSO4)
    @.. SO4 = KHSO4 ⊗ THSO4 / (H ⊕ KHSO4)
    @.. OH = KH2O / H
    @.. HCO3 = H ⊗ KCO2 ⊗ TCO2 / (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)
    @.. CO3 = KCO2 ⊗ KHCO3 ⊗ TCO2 / (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)
    @.. CO2 = H^2 ⊗ TCO2 / (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)
    @.. H2S = H ⊗ TH2S / (H ⊕ KH2S)
    @.. HS = KH2S ⊗ TH2S / (H ⊕ KH2S)
    @.. H3BO3 = H ⊗ TH3BO3 / (H ⊕ KH3BO3)
    @.. H4BO4 = KH3BO3 ⊗ TH3BO3 / (H ⊕ KH3BO3)
    @.. HF = H ⊗ THF / (H ⊕ KHF)
    @.. F = KHF ⊗ THF / (H ⊕ KHF)

    @.. dTA_dTH3PO4 =
        H ⊗ KH2PO4 ⊗ KH3PO4 /
        (H^3 ⊕ H^2 ⊗ KH3PO4 ⊕ H ⊗ KH2PO4 ⊗ KH3PO4 ⊕ KH2PO4 ⊗ KH3PO4 ⊗ KHPO4) ⊕
        2 ⊗ KH2PO4 ⊗ KH3PO4 ⊗ KHPO4 /
        (H^3 ⊕ H^2 ⊗ KH3PO4 ⊕ H ⊗ KH2PO4 ⊗ KH3PO4 ⊕ KH2PO4 ⊗ KH3PO4 ⊗ KHPO4) ⊕
        -H^3 /
        (H^3 ⊕ H^2 ⊗ KH3PO4 ⊕ H ⊗ KH2PO4 ⊗ KH3PO4 ⊕ KH2PO4 ⊗ KH3PO4 ⊗ KHPO4)
    @.. dTA_dTHSO4 = -H / (H ⊕ KHSO4)
    @.. dTA_dTCO2 = KCO2 ⊗ (H ⊕ 2 ⊗ KHCO3) / (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)
    @.. dTA_dTH2S = KH2S / (H ⊕ KH2S)
    @.. dTA_dTH3BO3 = KH3BO3 / (H ⊕ KH3BO3)
    @.. dTA_dTHF = -H / (H ⊕ KHF)

    @.. dTA_dH =
        -KH2PO4 ⊗ KH3PO4 ⊗ TH3PO4 ⊗
        (2 ⊗ H^3 ⊕ H^2 ⊗ KH3PO4 - KH2PO4 ⊗ KH3PO4 ⊗ KHPO4) /
        (H^3 ⊕ H^2 ⊗ KH3PO4 ⊕ H ⊗ KH2PO4 ⊗ KH3PO4 ⊕ KH2PO4 ⊗ KH3PO4 ⊗ KHPO4)^2 ⊕
        -2 ⊗ KH2PO4 ⊗ KH3PO4 ⊗ KHPO4 ⊗ TH3PO4 ⊗
        (3 ⊗ H^2 ⊕ 2 ⊗ H ⊗ KH3PO4 ⊕ KH2PO4 ⊗ KH3PO4) /
        (H^3 ⊕ H^2 ⊗ KH3PO4 ⊕ H ⊗ KH2PO4 ⊗ KH3PO4 ⊕ KH2PO4 ⊗ KH3PO4 ⊗ KHPO4)^2 ⊕
        -H^2 ⊗ KH3PO4 ⊗ TH3PO4 ⊗ (H^2 ⊕ 2 ⊗ H ⊗ KH2PO4 ⊕ 3 ⊗ KH2PO4 ⊗ KHPO4) /
        (H^3 ⊕ H^2 ⊗ KH3PO4 ⊕ H ⊗ KH2PO4 ⊗ KH3PO4 ⊕ KH2PO4 ⊗ KH3PO4 ⊗ KHPO4)^2
    @.. dTA_dH += -KHSO4 ⊗ THSO4 / (H ⊕ KHSO4)^2
    @.. dTA_dH += -(H^2 ⊕ KH2O) / H^2
    @.. dTA_dH +=
        -KCO2 ⊗ TCO2 ⊗ (H^2 ⊕ 4 ⊗ H ⊗ KHCO3 ⊕ KCO2 ⊗ KHCO3) /
        (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)^2
    @.. dTA_dH += -KH2S ⊗ TH2S / (H ⊕ KH2S)^2
    @.. dTA_dH += -KH3BO3 ⊗ TH3BO3 / (H ⊕ KH3BO3)^2
    @.. dTA_dH += -KHF ⊗ THF / (H ⊕ KHF)^2


    mul!(H3PO4_tran, AmH3PO4, H3PO4)
    H3PO4_tran[1] += BcAmH3PO4[1] ⊗ H3PO4[1] ⊕ BcCmH3PO4[1]
    H3PO4_tran[Ngrid] += BcAmH3PO4[2] ⊗ H3PO4[Ngrid] ⊕ BcCmH3PO4[2]
    @.. H3PO4_tran += alpha ⊗ (H3PO4BW - H3PO4)

    mul!(H2PO4_tran, AmH2PO4, H2PO4)
    H2PO4_tran[1] += BcAmH2PO4[1] ⊗ H2PO4[1] ⊕ BcCmH2PO4[1]
    H2PO4_tran[Ngrid] += BcAmH2PO4[2] ⊗ H2PO4[Ngrid] ⊕ BcCmH2PO4[2]
    @.. H2PO4_tran += alpha ⊗ (H2PO4BW - H2PO4)

    mul!(HPO4_tran, AmHPO4, HPO4)
    HPO4_tran[1] += BcAmHPO4[1] ⊗ HPO4[1] ⊕ BcCmHPO4[1]
    HPO4_tran[Ngrid] += BcAmHPO4[2] ⊗ HPO4[Ngrid] ⊕ BcCmHPO4[2]
    @.. HPO4_tran += alpha ⊗ (HPO4BW - HPO4)

    mul!(PO4_tran, AmPO4, PO4)
    PO4_tran[1] += BcAmPO4[1] ⊗ PO4[1] ⊕ BcCmPO4[1]
    PO4_tran[Ngrid] += BcAmPO4[2] ⊗ PO4[Ngrid] ⊕ BcCmPO4[2]
    @.. PO4_tran += alpha ⊗ (PO4BW - PO4)

    mul!(HSO4_tran, AmHSO4, HSO4)
    HSO4_tran[1] += BcAmHSO4[1] ⊗ HSO4[1] ⊕ BcCmHSO4[1]
    HSO4_tran[Ngrid] += BcAmHSO4[2] ⊗ HSO4[Ngrid] ⊕ BcCmHSO4[2]
    @.. HSO4_tran += alpha ⊗ (HSO4BW - HSO4)

    mul!(SO4_tran, AmSO4, SO4)
    SO4_tran[1] += BcAmSO4[1] ⊗ SO4[1] ⊕ BcCmSO4[1]
    SO4_tran[Ngrid] += BcAmSO4[2] ⊗ SO4[Ngrid] ⊕ BcCmSO4[2]
    @.. SO4_tran += alpha ⊗ (SO4BW - SO4)

    mul!(H_tran, AmH, H)
    H_tran[1] += BcAmH[1] ⊗ H[1] ⊕ BcCmH[1]
    H_tran[Ngrid] += BcAmH[2] ⊗ H[Ngrid] ⊕ BcCmH[2]
    @.. H_tran += alpha ⊗ (HBW - H)

    mul!(OH_tran, AmOH, OH)
    OH_tran[1] += BcAmOH[1] ⊗ OH[1] ⊕ BcCmOH[1]
    OH_tran[Ngrid] += BcAmOH[2] ⊗ OH[Ngrid] ⊕ BcCmOH[2]
    @.. OH_tran += alpha ⊗ (OHBW - OH)

    mul!(HCO3_tran, AmHCO3, HCO3)
    HCO3_tran[1] += BcAmHCO3[1] ⊗ HCO3[1] ⊕ BcCmHCO3[1]
    HCO3_tran[Ngrid] += BcAmHCO3[2] ⊗ HCO3[Ngrid] ⊕ BcCmHCO3[2]
    @.. HCO3_tran += alpha ⊗ (HCO3BW - HCO3)

    mul!(CO3_tran, AmCO3, CO3)
    CO3_tran[1] += BcAmCO3[1] ⊗ CO3[1] ⊕ BcCmCO3[1]
    CO3_tran[Ngrid] += BcAmCO3[2] ⊗ CO3[Ngrid] ⊕ BcCmCO3[2]
    @.. CO3_tran += alpha ⊗ (CO3BW - CO3)

    mul!(CO2_tran, AmCO2, CO2)
    CO2_tran[1] += BcAmCO2[1] ⊗ CO2[1] ⊕ BcCmCO2[1]
    CO2_tran[Ngrid] += BcAmCO2[2] ⊗ CO2[Ngrid] ⊕ BcCmCO2[2]
    @.. CO2_tran += alpha ⊗ (CO2BW - CO2)

    mul!(H2S_tran, AmH2S, H2S)
    H2S_tran[1] += BcAmH2S[1] ⊗ H2S[1] ⊕ BcCmH2S[1]
    H2S_tran[Ngrid] += BcAmH2S[2] ⊗ H2S[Ngrid] ⊕ BcCmH2S[2]
    @.. H2S_tran += alpha ⊗ (H2SBW - H2S)

    mul!(HS_tran, AmHS, HS)
    HS_tran[1] += BcAmHS[1] ⊗ HS[1] ⊕ BcCmHS[1]
    HS_tran[Ngrid] += BcAmHS[2] ⊗ HS[Ngrid] ⊕ BcCmHS[2]
    @.. HS_tran += alpha ⊗ (HSBW - HS)

    mul!(H3BO3_tran, AmH3BO3, H3BO3)
    H3BO3_tran[1] += BcAmH3BO3[1] ⊗ H3BO3[1] ⊕ BcCmH3BO3[1]
    H3BO3_tran[Ngrid] += BcAmH3BO3[2] ⊗ H3BO3[Ngrid] ⊕ BcCmH3BO3[2]
    @.. H3BO3_tran += alpha ⊗ (H3BO3BW - H3BO3)

    mul!(H4BO4_tran, AmH4BO4, H4BO4)
    H4BO4_tran[1] += BcAmH4BO4[1] ⊗ H4BO4[1] ⊕ BcCmH4BO4[1]
    H4BO4_tran[Ngrid] += BcAmH4BO4[2] ⊗ H4BO4[Ngrid] ⊕ BcCmH4BO4[2]
    @.. H4BO4_tran += alpha ⊗ (H4BO4BW - H4BO4)

    mul!(HF_tran, AmHF, HF)
    HF_tran[1] += BcAmHF[1] ⊗ HF[1] ⊕ BcCmHF[1]
    HF_tran[Ngrid] += BcAmHF[2] ⊗ HF[Ngrid] ⊕ BcCmHF[2]
    @.. HF_tran += alpha ⊗ (HFBW - HF)

    mul!(F_tran, AmF, F)
    F_tran[1] += BcAmF[1] ⊗ F[1] ⊕ BcCmF[1]
    F_tran[Ngrid] += BcAmF[2] ⊗ F[Ngrid] ⊕ BcCmF[2]
    @.. F_tran += alpha ⊗ (FBW - F)


    @.. dTH3PO4 = H3PO4_tran ⊕ H2PO4_tran ⊕ HPO4_tran ⊕ PO4_tran
    @.. dTHSO4 = HSO4_tran ⊕ SO4_tran
    @.. dTCO2 = HCO3_tran ⊕ CO3_tran ⊕ CO2_tran
    @.. dTH2S = H2S_tran ⊕ HS_tran
    @.. dTH3BO3 = H3BO3_tran ⊕ H4BO4_tran
    @.. dTHF = HF_tran ⊕ F_tran

    @.. TA_tran =
        -1 ⊗ H3PO4_tran ⊕ 0 ⊗ H2PO4_tran ⊕ 1 ⊗ HPO4_tran ⊕ 2 ⊗ PO4_tran
    @.. TA_tran += -1 ⊗ HSO4_tran ⊕ 0 ⊗ SO4_tran
    @.. TA_tran += -1 ⊗ H_tran ⊕ 1 ⊗ OH_tran
    @.. TA_tran += 1 ⊗ HCO3_tran ⊕ 2 ⊗ CO3_tran ⊕ 0 ⊗ CO2_tran
    @.. TA_tran += 0 ⊗ H2S_tran ⊕ 1 ⊗ HS_tran
    @.. TA_tran += 0 ⊗ H3BO3_tran ⊕ 1 ⊗ H4BO4_tran
    @.. TA_tran += -1 ⊗ HF_tran ⊕ 0 ⊗ F_tran

    @.. dH = TA_tran
    @.. dH -= dTH3PO4 ⊗ dTA_dTH3PO4
    @.. dH -= dTHSO4 ⊗ dTA_dTHSO4
    @.. dH -= dTCO2 ⊗ dTA_dTCO2
    @.. dH -= dTH2S ⊗ dTA_dTH2S
    @.. dH -= dTH3BO3 ⊗ dTA_dTH3BO3
    @.. dH -= dTHF ⊗ dTA_dTHF
    @.. dH = dH / dTA_dH
    # speciation
    @.. Fe_free =
        1.258925411794166e-9 ⊗ Fe ⊗ H / (
            1.0 ⊗ CO3 ⊗ H ⊗ OH ⊕ 5.623413251903486e-6 ⊗ CO3 ⊗ H ⊕
            9.549925860214353e-10 ⊗ Cl ⊗ H ⊕ 0.0003162277660168379 ⊗ H ⊗ HS ⊕
            1.148153621496882e-8 ⊗ H ⊗ SO4 ⊕ 1.258925411794166e-9 ⊗ H ⊕
            7.943282347242806e-12 ⊗ HS
        )
    @.. FeCl_aq =
        9.549925860214353e-10 ⊗ Cl ⊗ Fe ⊗ H / (
            1.0 ⊗ CO3 ⊗ H ⊗ OH ⊕ 5.623413251903486e-6 ⊗ CO3 ⊗ H ⊕
            9.549925860214353e-10 ⊗ Cl ⊗ H ⊕ 0.0003162277660168379 ⊗ H ⊗ HS ⊕
            1.148153621496882e-8 ⊗ H ⊗ SO4 ⊕ 1.258925411794166e-9 ⊗ H ⊕
            7.943282347242806e-12 ⊗ HS
        )
    @.. FeSO4_aq =
        1.148153621496882e-8 ⊗ Fe ⊗ H ⊗ SO4 / (
            1.0 ⊗ CO3 ⊗ H ⊗ OH ⊕ 5.623413251903486e-6 ⊗ CO3 ⊗ H ⊕
            9.549925860214353e-10 ⊗ Cl ⊗ H ⊕ 0.0003162277660168379 ⊗ H ⊗ HS ⊕
            1.148153621496882e-8 ⊗ H ⊗ SO4 ⊕ 1.258925411794166e-9 ⊗ H ⊕
            7.943282347242806e-12 ⊗ HS
        )
    @.. FeCO3_aq =
        5.623413251903486e-6 ⊗ CO3 ⊗ Fe ⊗ H / (
            1.0 ⊗ CO3 ⊗ H ⊗ OH ⊕ 5.623413251903486e-6 ⊗ CO3 ⊗ H ⊕
            9.549925860214353e-10 ⊗ Cl ⊗ H ⊕ 0.0003162277660168379 ⊗ H ⊗ HS ⊕
            1.148153621496882e-8 ⊗ H ⊗ SO4 ⊕ 1.258925411794166e-9 ⊗ H ⊕
            7.943282347242806e-12 ⊗ HS
        )
    @.. Fe_CO3_OH_aq =
        1.0 ⊗ CO3 ⊗ Fe ⊗ H ⊗ OH / (
            1.0 ⊗ CO3 ⊗ H ⊗ OH ⊕ 5.623413251903486e-6 ⊗ CO3 ⊗ H ⊕
            9.549925860214353e-10 ⊗ Cl ⊗ H ⊕ 0.0003162277660168379 ⊗ H ⊗ HS ⊕
            1.148153621496882e-8 ⊗ H ⊗ SO4 ⊕ 1.258925411794166e-9 ⊗ H ⊕
            7.943282347242806e-12 ⊗ HS
        )
    @.. FeHS_aq =
        0.0003162277660168379 ⊗ Fe ⊗ H ⊗ HS / (
            1.0 ⊗ CO3 ⊗ H ⊗ OH ⊕ 5.623413251903486e-6 ⊗ CO3 ⊗ H ⊕
            9.549925860214353e-10 ⊗ Cl ⊗ H ⊕ 0.0003162277660168379 ⊗ H ⊗ HS ⊕
            1.148153621496882e-8 ⊗ H ⊗ SO4 ⊕ 1.258925411794166e-9 ⊗ H ⊕
            7.943282347242806e-12 ⊗ HS
        )
    @.. FeS_aq =
        7.943282347242806e-12 ⊗ Fe ⊗ HS / (
            1.0 ⊗ CO3 ⊗ H ⊗ OH ⊕ 5.623413251903486e-6 ⊗ CO3 ⊗ H ⊕
            9.549925860214353e-10 ⊗ Cl ⊗ H ⊕ 0.0003162277660168379 ⊗ H ⊗ HS ⊕
            1.148153621496882e-8 ⊗ H ⊗ SO4 ⊕ 1.258925411794166e-9 ⊗ H ⊕
            7.943282347242806e-12 ⊗ HS
        )
    @.. MoO4 =
        1.3489628825916504e-20 ⊗ Mo / (
            1.0 ⊗ H2S^4 ⊕ 1.3182567385564045e-5 ⊗ H2S^3 ⊕
            1.3182567385564045e-10 ⊗ H2S^2 ⊕ 2.0892961308540364e-15 ⊗ H2S ⊕
            1.3489628825916504e-20
        )
    @.. MoO3S_aq =
        2.0892961308540364e-15 ⊗ H2S ⊗ Mo / (
            1.0 ⊗ H2S^4 ⊕ 1.3182567385564045e-5 ⊗ H2S^3 ⊕
            1.3182567385564045e-10 ⊗ H2S^2 ⊕ 2.0892961308540364e-15 ⊗ H2S ⊕
            1.3489628825916504e-20
        )
    @.. MoO2S2_aq =
        1.3182567385564045e-10 ⊗ H2S^2 ⊗ Mo / (
            1.0 ⊗ H2S^4 ⊕ 1.3182567385564045e-5 ⊗ H2S^3 ⊕
            1.3182567385564045e-10 ⊗ H2S^2 ⊕ 2.0892961308540364e-15 ⊗ H2S ⊕
            1.3489628825916504e-20
        )
    @.. MoOS3_aq =
        1.3182567385564045e-5 ⊗ H2S^3 ⊗ Mo / (
            1.0 ⊗ H2S^4 ⊕ 1.3182567385564045e-5 ⊗ H2S^3 ⊕
            1.3182567385564045e-10 ⊗ H2S^2 ⊕ 2.0892961308540364e-15 ⊗ H2S ⊕
            1.3489628825916504e-20
        )
    @.. MoS4_aq =
        1.0 ⊗ H2S^4 ⊗ Mo / (
            1.0 ⊗ H2S^4 ⊕ 1.3182567385564045e-5 ⊗ H2S^3 ⊕
            1.3182567385564045e-10 ⊗ H2S^2 ⊕ 2.0892961308540364e-15 ⊗ H2S ⊕
            1.3489628825916504e-20
        )

    # reaction rates
    @.. Omega_RFeS_dis = Fe ⊗ HS / (H ⊗ KspFeS)
    @.. Omega_RFeS_pre = Fe ⊗ HS / (H ⊗ KspFeS)
    @.. Omega_RCaCO3_dis = Ca ⊗ CO3 / KspCaCO3_dis
    @.. Omega_RCaCO3_pre = Ca ⊗ CO3 / KspCaCO3_pre
    @.. Omega_RMnCO3_dis = Mn ⊗ CO3 / KspMnCO3
    @.. Omega_RMnCO3_pre = Mn ⊗ CO3 / KspMnCO3
    @.. Omega_RFeCO3_dis = Fe ⊗ CO3 / KspFeCO3
    @.. Omega_RFeCO3_pre = Fe ⊗ CO3 / KspFeCO3
    @.. Omega_RBSi_dis = H4SiO4 / H4SiO4_dis_sat
    @.. Omega_RASi_pre = H4SiO4 / H4SiO4_pre_sat
    @.. Omega_RCFA_pre = Ca^9.54 ⊗ PO4^4.8 ⊗ F^2.48 / CO3^1.1307 / KspCFA
    @.. RO2POC = O2 / (KO2 ⊕ O2) ⊗ nu / (a ⊕ Age) ⊗ POC
    @.. RNO2POC = NO2 / (KNO2 ⊕ NO2) ⊗ KO2 / (KO2 ⊕ O2) ⊗ nu / (a ⊕ Age) ⊗ POC
    @.. RNO3POC =
        NO3 / (KNO3 ⊕ NO3) ⊗ KNO2 / (KNO2 ⊕ NO2) ⊗ KO2 / (KO2 ⊕ O2) ⊗ nu /
        (a ⊕ Age) ⊗ POC
    @.. RMnO2POC =
        MnO2 / (KMnO2 ⊕ MnO2) ⊗ KNO3 / (KNO3 ⊕ NO3) ⊗ KNO2 / (KNO2 ⊕ NO2) ⊗
        KO2 / (KO2 ⊕ O2) ⊗ nu / (a ⊕ Age) ⊗ POC
    @.. RFeOOHPOC =
        FeOOH / (KFeOOH ⊕ FeOOH) ⊗ KMnO2 / (KMnO2 ⊕ MnO2) ⊗ KNO3 /
        (KNO3 ⊕ NO3) ⊗ KNO2 / (KNO2 ⊕ NO2) ⊗ KO2 / (KO2 ⊕ O2) ⊗ nu / (a ⊕ Age) ⊗
        POC
    @.. RSO4POC =
        THSO4 / (KTHSO4 ⊕ THSO4) ⊗ KFeOOH / (KFeOOH ⊕ FeOOH) ⊗ KMnO2 /
        (KMnO2 ⊕ MnO2) ⊗ KNO3 / (KNO3 ⊕ NO3) ⊗ KNO2 / (KNO2 ⊕ NO2) ⊗ KO2 /
        (KO2 ⊕ O2) ⊗ nu / (a ⊕ Age) ⊗ POC
    @.. RCH4POC =
        KTHSO4 / (KTHSO4 ⊕ THSO4) ⊗ KFeOOH / (KFeOOH ⊕ FeOOH) ⊗ KMnO2 /
        (KMnO2 ⊕ MnO2) ⊗ KNO3 / (KNO3 ⊕ NO3) ⊗ KNO2 / (KNO2 ⊕ NO2) ⊗ KO2 /
        (KO2 ⊕ O2) ⊗ nu / (a ⊕ Age) ⊗ POC
    @.. RO2NO2 = kO2NO2 ⊗ O2 ⊗ NO2
    @.. RO2NH4 = kO2NH4 ⊗ O2 ⊗ NH4
    @.. RO2Mn = kO2Mn ⊗ O2 ⊗ Mn
    @.. RO2Mn_ads = kO2Mn_ads ⊗ O2 ⊗ Mn_ads
    @.. RO2Fe = kO2Fe ⊗ O2 ⊗ Fe
    @.. RO2Fe_ads = kO2Fe_ads ⊗ O2 ⊗ Fe_ads
    @.. RO2H2S = kO2H2S ⊗ O2 ⊗ TH2S
    @.. RO2FeS = kO2FeS ⊗ O2 ⊗ FeS
    @.. RO2CH4 = kO2CH4 ⊗ O2 ⊗ CH4
    @.. RNO2NH4 = kNO2NH4 ⊗ NO2 ⊗ NH4
    @.. RNO3Mn = kNO3Mn ⊗ NO3 ⊗ Mn
    @.. RNO3Fe = kNO3Fe ⊗ NO3 ⊗ Fe
    @.. RNO3H2S = kNO3H2S ⊗ NO3 ⊗ TH2S
    @.. RSO4CH4 = kAOM ⊗ CH4 ⊗ THSO4 / (THSO4 ⊕ KAOM)
    @.. RMnO2Fe = kMnO2Fe ⊗ MnO2 ⊗ Fe
    @.. RMnO2H2S = kMnO2H2S ⊗ MnO2 ⊗ TH2S
    @.. RFeOOHH2S = kFeOOHH2S ⊗ FeOOH ⊗ TH2S
    @.. RFeSH2S = kFeSH2S ⊗ FeS ⊗ TH2S
    @.. RFeS_dis =
        (-tanh(1e3 ⊗ (Omega_RFeS_dis - 1.0)) / 2 ⊕ 0.5) ⊗
        (kFeSdis ⊗ FeS ⊗ (1 - Omega_RFeS_dis))
    @.. RFeS_pre =
        (tanh(1e3 ⊗ (Omega_RFeS_pre - 1.0)) / 2 ⊕ 0.5) ⊗
        (kFeSpre ⊗ (Omega_RFeS_pre - 1))
    @.. RCaCO3_dis =
        (-tanh(1e3 ⊗ (Omega_RCaCO3_dis - 1.0)) / 2 ⊕ 0.5) ⊗
        (kCaCO3dis ⊗ CaCO3 ⊗ (1 - Omega_RCaCO3_dis))
    @.. RCaCO3_pre =
        (tanh(1e3 ⊗ (Omega_RCaCO3_pre - 1.0)) / 2 ⊕ 0.5) ⊗
        (kCaCO3pre ⊗ (Omega_RCaCO3_pre - 1) ⊗ dstopw)
    @.. RMnCO3_dis =
        (-tanh(1e3 ⊗ (Omega_RMnCO3_dis - 1.0)) / 2 ⊕ 0.5) ⊗
        (kMnCO3dis ⊗ MnCO3 ⊗ (1 - Omega_RMnCO3_dis))
    @.. RMnCO3_pre =
        (tanh(1e3 ⊗ (Omega_RMnCO3_pre - 1.0)) / 2 ⊕ 0.5) ⊗
        (kMnCO3pre ⊗ (Omega_RMnCO3_pre - 1) ⊗ dstopw)
    @.. RFeCO3_dis =
        (-tanh(1e3 ⊗ (Omega_RFeCO3_dis - 1.0)) / 2 ⊕ 0.5) ⊗
        (kFeCO3dis ⊗ FeCO3 ⊗ (1 - Omega_RFeCO3_dis))
    @.. RFeCO3_pre =
        (tanh(1e3 ⊗ (Omega_RFeCO3_pre - 1.0)) / 2 ⊕ 0.5) ⊗
        (kFeCO3pre ⊗ (Omega_RFeCO3_pre - 1) ⊗ dstopw)
    @.. RBSi_dis =
        (-tanh(1e3 ⊗ (Omega_RBSi_dis - 1.0)) / 2 ⊕ 0.5) ⊗
        (kBSidis ⊗ (1 - Omega_RBSi_dis) ⊗ BSi)
    @.. RASi_pre =
        (tanh(1e3 ⊗ (Omega_RASi_pre - 1.0)) / 2 ⊕ 0.5) ⊗
        (kASipre ⊗ H4SiO4_pre_sat ⊗ (Omega_RASi_pre - 1))
    @.. RMoS4_pre = kMoS4_pre ⊗ MoS4_aq
    @.. RCFA_pre =
        (tanh(1e3 ⊗ (Omega_RCFA_pre - 1.0)) / 2 ⊕ 0.5) ⊗
        (kCFA_pre ⊗ (Omega_RCFA_pre - 1))

    # species rates
    @.. S_POC =
        -1 ⊗ RO2POC ⊕ -1 ⊗ RNO2POC ⊕ -1 ⊗ RNO3POC ⊕ -1 ⊗ RMnO2POC ⊕
        -1 ⊗ RFeOOHPOC ⊕ -1 ⊗ RSO4POC ⊕ -1 ⊗ RCH4POC
    @.. S_O2 =
        -1 ⊗ RO2POC ⊗ dstopw ⊕ -1 / 2 ⊗ RO2NO2 ⊕ -3 / 2 ⊗ RO2NH4 ⊕
        -1 / 2 ⊗ RO2Mn ⊕ -1 / 2 ⊗ RO2Mn_ads ⊗ dstopw ⊕ -1 / 4 ⊗ RO2Fe ⊕
        -1 / 4 ⊗ RO2Fe_ads ⊗ dstopw ⊕ -2 ⊗ RO2H2S ⊕ -9 / 4 ⊗ RO2FeS ⊗ dstopw ⊕
        -2 ⊗ RO2CH4
    @.. S_TCO2 =
        1 ⊗ RO2POC ⊗ dstopw ⊕ 1 ⊗ RNO2POC ⊗ dstopw ⊕ 1 ⊗ RNO3POC ⊗ dstopw ⊕
        1 ⊗ RMnO2POC ⊗ dstopw ⊕ 1 ⊗ RFeOOHPOC ⊗ dstopw ⊕ 1 ⊗ RSO4POC ⊗ dstopw ⊕
        1 / 2 ⊗ RCH4POC ⊗ dstopw ⊕ 1 ⊗ RO2CH4 ⊕ 1 ⊗ RSO4CH4 ⊕
        1 ⊗ RCaCO3_dis ⊗ dstopw ⊕ -1 ⊗ RCaCO3_pre ⊕ 1 ⊗ RMnCO3_dis ⊗ dstopw ⊕
        -1 ⊗ RMnCO3_pre ⊕ 1 ⊗ RFeCO3_dis ⊗ dstopw ⊕ -1 ⊗ RFeCO3_pre ⊕
        -1.2 ⊗ RCFA_pre
    @.. S_TNH4 =
        rNC ⊗ RO2POC ⊗ dstopw ⊕ rNC ⊗ RNO2POC ⊗ dstopw ⊕
        rNC ⊗ RNO3POC ⊗ dstopw ⊕ rNC ⊗ RMnO2POC ⊗ dstopw ⊕
        rNC ⊗ RFeOOHPOC ⊗ dstopw ⊕ rNC ⊗ RSO4POC ⊗ dstopw ⊕
        rNC ⊗ RCH4POC ⊗ dstopw ⊕ -1 ⊗ RO2NH4 ⊕ -1 ⊗ RNO2NH4 ⊕ 1 ⊗ RNO3H2S
    @.. S_TH3PO4 =
        rPC ⊗ RO2POC ⊗ dstopw ⊕ rPC ⊗ RNO2POC ⊗ dstopw ⊕
        rPC ⊗ RNO3POC ⊗ dstopw ⊕ rPC ⊗ RMnO2POC ⊗ dstopw ⊕
        rPC ⊗ RFeOOHPOC ⊗ dstopw ⊕ rPC ⊗ RSO4POC ⊗ dstopw ⊕
        rPC ⊗ RCH4POC ⊗ dstopw ⊕ -4.8 ⊗ RCFA_pre
    @.. S_NO2 =
        -4 / 3 ⊗ RNO2POC ⊗ dstopw ⊕ 2 ⊗ RNO3POC ⊗ dstopw ⊕ -1 ⊗ RO2NO2 ⊕
        1 ⊗ RO2NH4 ⊕ -1 ⊗ RNO2NH4
    @.. S_NO3 =
        -2 ⊗ RNO3POC ⊗ dstopw ⊕ 1 ⊗ RO2NO2 ⊕ -2 / 5 ⊗ RNO3Mn ⊕ -1 / 5 ⊗ RNO3Fe ⊕
        -1 ⊗ RNO3H2S
    @.. S_MnO2 =
        -2 ⊗ RMnO2POC ⊕ 1 ⊗ RO2Mn ⊗ pwtods ⊕ 1 ⊗ RO2Mn_ads ⊕
        1 ⊗ RNO3Mn ⊗ pwtods ⊕ -1 / 2 ⊗ RMnO2Fe ⊕ -1 ⊗ RMnO2H2S
    @.. S_TMn =
        2 ⊗ RMnO2POC ⊗ dstopw ⊕ -1 ⊗ RO2Mn ⊕ -1 ⊗ RO2Mn_ads ⊗ dstopw ⊕
        -1 ⊗ RNO3Mn ⊕ 1 / 2 ⊗ RMnO2Fe ⊗ dstopw ⊕ 1 ⊗ RMnO2H2S ⊗ dstopw ⊕
        1 ⊗ RMnCO3_dis ⊗ dstopw ⊕ -1 ⊗ RMnCO3_pre
    @.. S_FeOOH =
        -4 ⊗ RFeOOHPOC ⊕ 1 ⊗ RO2Fe ⊗ pwtods ⊕ 1 ⊗ RO2Fe_ads ⊕ 1 ⊗ RO2FeS ⊕
        1 ⊗ RNO3Fe ⊗ pwtods ⊕ 1 ⊗ RMnO2Fe ⊕ -2 ⊗ RFeOOHH2S
    @.. S_TFe =
        4 ⊗ RFeOOHPOC ⊗ dstopw ⊕ -1 ⊗ RO2Fe ⊕ -1 ⊗ RO2Fe_ads ⊗ dstopw ⊕
        -1 ⊗ RNO3Fe ⊕ -1 ⊗ RMnO2Fe ⊗ dstopw ⊕ 2 ⊗ RFeOOHH2S ⊗ dstopw ⊕
        1 ⊗ RFeS_dis ⊗ dstopw ⊕ -1 ⊗ RFeS_pre ⊕ 1 ⊗ RFeCO3_dis ⊗ dstopw ⊕
        -1 ⊗ RFeCO3_pre
    @.. S_THSO4 =
        -1 / 2 ⊗ RSO4POC ⊗ dstopw ⊕ 1 ⊗ RO2H2S ⊕ 1 ⊗ RO2FeS ⊗ dstopw ⊕
        1 ⊗ RNO3H2S ⊕ -1 ⊗ RSO4CH4
    @.. S_TH2S =
        1 / 2 ⊗ RSO4POC ⊗ dstopw ⊕ -1 ⊗ RO2H2S ⊕ -1 ⊗ RNO3H2S ⊕ 1 ⊗ RSO4CH4 ⊕
        -1 ⊗ RMnO2H2S ⊗ dstopw ⊕ -1 ⊗ RFeOOHH2S ⊗ dstopw ⊕
        -1 ⊗ RFeSH2S ⊗ dstopw ⊕ 1 ⊗ RFeS_dis ⊗ dstopw ⊕ -1 ⊗ RFeS_pre
    @.. S_CH4 = 1 / 2 ⊗ RCH4POC ⊗ dstopw ⊕ -1 ⊗ RO2CH4 ⊕ -1 ⊗ RSO4CH4
    @.. S_FeS =
        -1 ⊗ RO2FeS ⊕ -1 ⊗ RFeSH2S ⊕ -1 ⊗ RFeS_dis ⊕ 1 ⊗ RFeS_pre ⊗ pwtods
    @.. S_FeS2 = 1 ⊗ RFeSH2S
    @.. S_CaCO3 = -1 ⊗ RCaCO3_dis ⊕ 1 ⊗ RCaCO3_pre ⊗ pwtods
    @.. S_Ca = 1 ⊗ RCaCO3_dis ⊗ dstopw ⊕ -1 ⊗ RCaCO3_pre ⊕ -9.54 ⊗ RCFA_pre
    @.. S_MnCO3 = -1 ⊗ RMnCO3_dis ⊕ 1 ⊗ RMnCO3_pre ⊗ pwtods
    @.. S_FeCO3 = -1 ⊗ RFeCO3_dis ⊕ 1 ⊗ RFeCO3_pre ⊗ pwtods
    @.. S_BSi = -1 ⊗ RBSi_dis
    @.. S_H4SiO4 = 1 ⊗ RBSi_dis ⊗ dstopw ⊕ -1 ⊗ RASi_pre
    @.. S_Mo = -1 ⊗ RMoS4_pre
    @.. S_SMo = 1 ⊗ RMoS4_pre ⊗ pwtods
    @.. S_THF = -2.48 ⊗ RCFA_pre
    @.. S_TA =
        (rNC - rPC) ⊗ RO2POC ⊗ dstopw ⊕ (rNC - rPC ⊕ 4 / 3) ⊗ RNO2POC ⊗ dstopw ⊕
        (rNC - rPC) ⊗ RNO3POC ⊗ dstopw ⊕ (rNC - rPC ⊕ 4) ⊗ RMnO2POC ⊗ dstopw ⊕
        (rNC - rPC ⊕ 8) ⊗ RFeOOHPOC ⊗ dstopw ⊕
        (rNC - rPC ⊕ 1) ⊗ RSO4POC ⊗ dstopw ⊕ (rNC - rPC) ⊗ RCH4POC ⊗ dstopw ⊕
        -2 ⊗ RO2NH4 ⊕ -2 ⊗ RO2Mn ⊕ -1 ⊗ RO2Mn_ads ⊗ dstopw ⊕ -2 ⊗ RO2Fe ⊕
        -1 ⊗ RO2Fe_ads ⊗ dstopw ⊕ -2 ⊗ RO2H2S ⊕ -2 ⊗ RO2FeS ⊗ dstopw ⊕
        -8 / 5 ⊗ RNO3Mn ⊕ -9 / 5 ⊗ RNO3Fe ⊕ 2 ⊗ RSO4CH4 ⊕
        -1 ⊗ RMnO2Fe ⊗ dstopw ⊕ 2 ⊗ RMnO2H2S ⊗ dstopw ⊕ 4 ⊗ RFeOOHH2S ⊗ dstopw ⊕
        1 ⊗ RFeS_dis ⊗ dstopw ⊕ -1 ⊗ RFeS_pre ⊕ -39 / 100 ⊗ RCFA_pre
    @.. S_TA +=
        2 ⊗ RCaCO3_dis ⊗ dstopw ⊕ -2 ⊗ RCaCO3_pre ⊕ 2 ⊗ RMnCO3_dis ⊗ dstopw ⊕
        -2 ⊗ RMnCO3_pre ⊕ 2 ⊗ RFeCO3_dis ⊗ dstopw ⊕ -2 ⊗ RFeCO3_pre ⊕
        -12 / 5 ⊗ RCFA_pre
    @.. S_TA += -48 / 5 ⊗ RCFA_pre
    @.. S_TA += 1 ⊗ RFeS_dis ⊗ dstopw ⊕ -1 ⊗ RFeS_pre
    @.. S_H = S_TA
    @.. S_H -= S_TCO2 ⊗ dTA_dTCO2
    @.. S_H -= S_TH3PO4 ⊗ dTA_dTH3PO4
    @.. S_H -= S_THSO4 ⊗ dTA_dTHSO4
    @.. S_H -= S_TH2S ⊗ dTA_dTH2S
    @.. S_H -= S_THF ⊗ dTA_dTHF
    @.. S_H = S_H / dTA_dH
    @.. S_Age = 1

    @.. dTMn += S_TMn
    @.. dTFe += S_TFe
    @.. dTNH4 += S_TNH4
    @.. dPOC += S_POC
    @.. dMnO2 += S_MnO2
    @.. dFeOOH += S_FeOOH
    @.. dFeS += S_FeS
    @.. dFeS2 += S_FeS2
    @.. dCaCO3 += S_CaCO3
    @.. dMnCO3 += S_MnCO3
    @.. dFeCO3 += S_FeCO3
    @.. dAge += S_Age
    @.. dBSi += S_BSi
    @.. dSMo += S_SMo
    @.. dO2 += S_O2
    @.. dNO3 += S_NO3
    @.. dCH4 += S_CH4
    @.. dNO2 += S_NO2
    @.. dCa += S_Ca
    @.. dMo += S_Mo
    @.. dH4SiO4 += S_H4SiO4
    @.. dTH3PO4 += S_TH3PO4
    @.. dTHSO4 += S_THSO4
    @.. dH += S_H
    @.. dTCO2 += S_TCO2
    @.. dTH2S += S_TH2S
    @.. dTHF += S_THF

    return nothing
end
