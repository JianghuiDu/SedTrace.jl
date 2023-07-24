function (f::Cache.Reactran)(dC, C, parms::Param.ParamStruct, t)
    #---------------------------------------------------------------------
    #  Parameters
    #---------------------------------------------------------------------
    @unpack MnO2ID,
    FeOOHID,
    POCID,
    FeSID,
    FeS2ID,
    CaCO3ID,
    AgeID,
    BSiID,
    NdnrPO4ID,
    NdrPO4ID,
    SurfMn_NdnrID,
    SurfMn_NdrID,
    SurfFe_NdnrID,
    SurfFe_NdrID,
    IlliteID,
    BasaltID,
    O2ID,
    NO3ID,
    CH4ID,
    NO2ID,
    CaID,
    SO4ID,
    TMnID,
    TFeID,
    AlID,
    TNH4ID,
    TNdnrID,
    TNdrID,
    TH4SiO4ID,
    TCO2ID,
    TH2SID,
    TH3BO3ID,
    TH3PO4ID,
    HID,
    AmMnO2,
    AmFeOOH,
    AmPOC,
    AmFeS,
    AmFeS2,
    AmCaCO3,
    AmAge,
    AmBSi,
    AmNdnrPO4,
    AmNdrPO4,
    AmSurfMn_Ndnr,
    AmSurfMn_Ndr,
    AmSurfFe_Ndnr,
    AmSurfFe_Ndr,
    AmIllite,
    AmBasalt,
    AmO2,
    AmNO3,
    AmCH4,
    AmNO2,
    AmCa,
    AmSO4,
    AmH4SiO4,
    AmH3SiO4,
    AmHCO3,
    AmCO3,
    AmCO2,
    AmH2S,
    AmHS,
    AmH3BO3,
    AmH4BO4,
    AmH3PO4,
    AmH2PO4,
    AmHPO4,
    AmPO4,
    AmH,
    AmOH,
    AmTMn_dis,
    AmTMn_ads,
    AmTFe_dis,
    AmTFe_ads,
    AmAl_dis,
    AmTNH4_dis,
    AmTNH4_ads,
    AmTNdnr_dis,
    AmTNdnr_ads,
    AmTNdr_dis,
    AmTNdr_ads,
    BcAmMnO2,
    BcCmMnO2,
    BcAmFeOOH,
    BcCmFeOOH,
    BcAmPOC,
    BcCmPOC,
    BcAmFeS,
    BcCmFeS,
    BcAmFeS2,
    BcCmFeS2,
    BcAmCaCO3,
    BcCmCaCO3,
    BcAmAge,
    BcCmAge,
    BcAmBSi,
    BcCmBSi,
    BcAmNdnrPO4,
    BcCmNdnrPO4,
    BcAmNdrPO4,
    BcCmNdrPO4,
    BcAmSurfMn_Ndnr,
    BcCmSurfMn_Ndnr,
    BcAmSurfMn_Ndr,
    BcCmSurfMn_Ndr,
    BcAmSurfFe_Ndnr,
    BcCmSurfFe_Ndnr,
    BcAmSurfFe_Ndr,
    BcCmSurfFe_Ndr,
    BcAmIllite,
    BcCmIllite,
    BcAmBasalt,
    BcCmBasalt,
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
    BcAmSO4,
    BcCmSO4,
    Ngrid,
    BcAmH4SiO4,
    BcCmH4SiO4,
    BcAmH3SiO4,
    BcCmH3SiO4,
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
    BcAmH3PO4,
    BcCmH3PO4,
    BcAmH2PO4,
    BcCmH2PO4,
    BcAmHPO4,
    BcCmHPO4,
    BcAmPO4,
    BcCmPO4,
    BcAmH,
    BcCmH,
    BcAmOH,
    BcCmOH,
    BcAmTMn_dis,
    BcCmTMn_dis,
    BcAmTMn_ads,
    BcCmTMn_ads,
    BcAmTFe_dis,
    BcCmTFe_dis,
    BcAmTFe_ads,
    BcCmTFe_ads,
    BcAmAl_dis,
    BcCmAl_dis,
    BcAmTNH4_dis,
    BcCmTNH4_dis,
    BcAmTNH4_ads,
    BcCmTNH4_ads,
    BcAmTNdnr_dis,
    BcCmTNdnr_dis,
    BcAmTNdnr_ads,
    BcCmTNdnr_ads,
    BcAmTNdr_dis,
    BcCmTNdr_dis,
    BcAmTNdr_ads,
    BcCmTNdr_ads,
    alpha,
    O2BW,
    NO3BW,
    CH4BW,
    NO2BW,
    CaBW,
    SO4BW,
    H4SiO4BW,
    H3SiO4BW,
    HCO3BW,
    CO3BW,
    CO2BW,
    H2SBW,
    HSBW,
    H3BO3BW,
    H4BO4BW,
    H3PO4BW,
    H2PO4BW,
    HPO4BW,
    PO4BW,
    HBW,
    OHBW,
    TMn_dis0,
    TFe_dis0,
    Al_disBW,
    TNH4_dis0,
    TNdnr_dis0,
    TNdr_dis0,
    dstopw,
    KH4SiO4,
    KCO2,
    KHCO3,
    KH2S,
    KH3BO3,
    KH3PO4,
    KH2PO4,
    KHPO4,
    KH2O,
    KMn_ads_Fe,
    KMn_ads_Mn,
    Cl,
    KFe_ads_Fe,
    KFe_ads_Mn,
    KNH4_ads,
    KNd_ads_Fe,
    KNd_ads_Mn,
    KspFeS,
    KspCaCO3_dis,
    H4SiO4_dis_sat,
    KspBasalt,
    rNC,
    rPC,
    pwtods,
    rAlSi,
    rNdnrSi_lith,
    rNdrSi_lith,
    KO2,
    nu,
    a,
    KNO2,
    KNO3,
    KMnO2,
    KFeOOH,
    KSO4,
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
    kAOM,
    KAOM,
    kMnO2Fe,
    kMnO2H2S,
    kFeOOHH2S,
    kFeSH2S,
    kFeSdis,
    kFeSpre,
    kCaCO3dis0,
    kCaCO3dis1,
    nCaCO3dis,
    kBSi_dis,
    DNdMn,
    DNdFe,
    kNdPO4_pre,
    KspNdPO4,
    kIllite,
    KspIllite,
    kBasalt,
    a_lith0 = parms
    #---------------------------------------------------------------------
    #  Cache
    #---------------------------------------------------------------------
    TMn_dis = PreallocationTools.get_tmp(f.TMn_dis, C)
    Mn_aq = PreallocationTools.get_tmp(f.Mn_aq, C)
    Mn_ads_Mn = PreallocationTools.get_tmp(f.Mn_ads_Mn, C)
    Mn_ads_Fe = PreallocationTools.get_tmp(f.Mn_ads_Fe, C)
    TMn_ads_MnO2 = PreallocationTools.get_tmp(f.TMn_ads_MnO2, C)
    TMn_ads_FeOOH = PreallocationTools.get_tmp(f.TMn_ads_FeOOH, C)
    TMn_ads = PreallocationTools.get_tmp(f.TMn_ads, C)
    TFe_dis = PreallocationTools.get_tmp(f.TFe_dis, C)
    Fe_aq = PreallocationTools.get_tmp(f.Fe_aq, C)
    Fe_ads_Mn = PreallocationTools.get_tmp(f.Fe_ads_Mn, C)
    Fe_ads_Fe = PreallocationTools.get_tmp(f.Fe_ads_Fe, C)
    TFe_ads_MnO2 = PreallocationTools.get_tmp(f.TFe_ads_MnO2, C)
    TFe_ads_FeOOH = PreallocationTools.get_tmp(f.TFe_ads_FeOOH, C)
    TFe_ads = PreallocationTools.get_tmp(f.TFe_ads, C)
    Al_dis = PreallocationTools.get_tmp(f.Al_dis, C)
    Al_aq = PreallocationTools.get_tmp(f.Al_aq, C)
    TNH4_dis = PreallocationTools.get_tmp(f.TNH4_dis, C)
    NH4 = PreallocationTools.get_tmp(f.NH4, C)
    NH4_ads = PreallocationTools.get_tmp(f.NH4_ads, C)
    TNH4_ads_nsf = PreallocationTools.get_tmp(f.TNH4_ads_nsf, C)
    TNH4_ads = PreallocationTools.get_tmp(f.TNH4_ads, C)
    TNdnr_dis = PreallocationTools.get_tmp(f.TNdnr_dis, C)
    Ndnr_aq = PreallocationTools.get_tmp(f.Ndnr_aq, C)
    Ndnr_ads_Mn = PreallocationTools.get_tmp(f.Ndnr_ads_Mn, C)
    Ndnr_ads_Fe = PreallocationTools.get_tmp(f.Ndnr_ads_Fe, C)
    TNdnr_ads_MnO2 = PreallocationTools.get_tmp(f.TNdnr_ads_MnO2, C)
    TNdnr_ads_FeOOH = PreallocationTools.get_tmp(f.TNdnr_ads_FeOOH, C)
    TNdnr_ads = PreallocationTools.get_tmp(f.TNdnr_ads, C)
    TNdr_dis = PreallocationTools.get_tmp(f.TNdr_dis, C)
    Ndr_aq = PreallocationTools.get_tmp(f.Ndr_aq, C)
    Ndr_ads_Mn = PreallocationTools.get_tmp(f.Ndr_ads_Mn, C)
    Ndr_ads_Fe = PreallocationTools.get_tmp(f.Ndr_ads_Fe, C)
    TNdr_ads_MnO2 = PreallocationTools.get_tmp(f.TNdr_ads_MnO2, C)
    TNdr_ads_FeOOH = PreallocationTools.get_tmp(f.TNdr_ads_FeOOH, C)
    TNdr_ads = PreallocationTools.get_tmp(f.TNdr_ads, C)
    TMn_dis_tran = PreallocationTools.get_tmp(f.TMn_dis_tran, C)
    TMn_ads_tran = PreallocationTools.get_tmp(f.TMn_ads_tran, C)
    TFe_dis_tran = PreallocationTools.get_tmp(f.TFe_dis_tran, C)
    TFe_ads_tran = PreallocationTools.get_tmp(f.TFe_ads_tran, C)
    Al_dis_tran = PreallocationTools.get_tmp(f.Al_dis_tran, C)
    TNH4_dis_tran = PreallocationTools.get_tmp(f.TNH4_dis_tran, C)
    TNH4_ads_tran = PreallocationTools.get_tmp(f.TNH4_ads_tran, C)
    TNdnr_dis_tran = PreallocationTools.get_tmp(f.TNdnr_dis_tran, C)
    TNdnr_ads_tran = PreallocationTools.get_tmp(f.TNdnr_ads_tran, C)
    TNdr_dis_tran = PreallocationTools.get_tmp(f.TNdr_dis_tran, C)
    TNdr_ads_tran = PreallocationTools.get_tmp(f.TNdr_ads_tran, C)
    H4SiO4 = PreallocationTools.get_tmp(f.H4SiO4, C)
    H3SiO4 = PreallocationTools.get_tmp(f.H3SiO4, C)
    HCO3 = PreallocationTools.get_tmp(f.HCO3, C)
    CO3 = PreallocationTools.get_tmp(f.CO3, C)
    CO2 = PreallocationTools.get_tmp(f.CO2, C)
    H2S = PreallocationTools.get_tmp(f.H2S, C)
    HS = PreallocationTools.get_tmp(f.HS, C)
    H3BO3 = PreallocationTools.get_tmp(f.H3BO3, C)
    H4BO4 = PreallocationTools.get_tmp(f.H4BO4, C)
    H3PO4 = PreallocationTools.get_tmp(f.H3PO4, C)
    H2PO4 = PreallocationTools.get_tmp(f.H2PO4, C)
    HPO4 = PreallocationTools.get_tmp(f.HPO4, C)
    PO4 = PreallocationTools.get_tmp(f.PO4, C)
    OH = PreallocationTools.get_tmp(f.OH, C)
    H4SiO4_tran = PreallocationTools.get_tmp(f.H4SiO4_tran, C)
    H3SiO4_tran = PreallocationTools.get_tmp(f.H3SiO4_tran, C)
    HCO3_tran = PreallocationTools.get_tmp(f.HCO3_tran, C)
    CO3_tran = PreallocationTools.get_tmp(f.CO3_tran, C)
    CO2_tran = PreallocationTools.get_tmp(f.CO2_tran, C)
    H2S_tran = PreallocationTools.get_tmp(f.H2S_tran, C)
    HS_tran = PreallocationTools.get_tmp(f.HS_tran, C)
    H3BO3_tran = PreallocationTools.get_tmp(f.H3BO3_tran, C)
    H4BO4_tran = PreallocationTools.get_tmp(f.H4BO4_tran, C)
    H3PO4_tran = PreallocationTools.get_tmp(f.H3PO4_tran, C)
    H2PO4_tran = PreallocationTools.get_tmp(f.H2PO4_tran, C)
    HPO4_tran = PreallocationTools.get_tmp(f.HPO4_tran, C)
    PO4_tran = PreallocationTools.get_tmp(f.PO4_tran, C)
    H_tran = PreallocationTools.get_tmp(f.H_tran, C)
    OH_tran = PreallocationTools.get_tmp(f.OH_tran, C)
    TA_tran = PreallocationTools.get_tmp(f.TA_tran, C)
    dTA_dH = PreallocationTools.get_tmp(f.dTA_dH, C)
    dTA_dTH4SiO4 = PreallocationTools.get_tmp(f.dTA_dTH4SiO4, C)
    dTA_dTCO2 = PreallocationTools.get_tmp(f.dTA_dTCO2, C)
    dTA_dTH2S = PreallocationTools.get_tmp(f.dTA_dTH2S, C)
    dTA_dTH3BO3 = PreallocationTools.get_tmp(f.dTA_dTH3BO3, C)
    dTA_dTH3PO4 = PreallocationTools.get_tmp(f.dTA_dTH3PO4, C)
    Omega_RFeS_dis = PreallocationTools.get_tmp(f.Omega_RFeS_dis, C)
    Omega_RFeS_pre = PreallocationTools.get_tmp(f.Omega_RFeS_pre, C)
    Omega_RCaCO3_dis = PreallocationTools.get_tmp(f.Omega_RCaCO3_dis, C)
    Omega_RBSi_dis = PreallocationTools.get_tmp(f.Omega_RBSi_dis, C)
    Omega_RBasalt_dis = PreallocationTools.get_tmp(f.Omega_RBasalt_dis, C)
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
    RSO4CH4 = PreallocationTools.get_tmp(f.RSO4CH4, C)
    RMnO2Fe = PreallocationTools.get_tmp(f.RMnO2Fe, C)
    RMnO2H2S = PreallocationTools.get_tmp(f.RMnO2H2S, C)
    RFeOOHH2S = PreallocationTools.get_tmp(f.RFeOOHH2S, C)
    RFeSH2S = PreallocationTools.get_tmp(f.RFeSH2S, C)
    RFeS_dis = PreallocationTools.get_tmp(f.RFeS_dis, C)
    RFeS_pre = PreallocationTools.get_tmp(f.RFeS_pre, C)
    RCaCO3_dis = PreallocationTools.get_tmp(f.RCaCO3_dis, C)
    RBSi_dis = PreallocationTools.get_tmp(f.RBSi_dis, C)
    RMnRe_Ndnr = PreallocationTools.get_tmp(f.RMnRe_Ndnr, C)
    RMnRe_Ndr = PreallocationTools.get_tmp(f.RMnRe_Ndr, C)
    RMnOx_Ndnr = PreallocationTools.get_tmp(f.RMnOx_Ndnr, C)
    RMnOx_Ndr = PreallocationTools.get_tmp(f.RMnOx_Ndr, C)
    RFeRe_Ndnr = PreallocationTools.get_tmp(f.RFeRe_Ndnr, C)
    RFeRe_Ndr = PreallocationTools.get_tmp(f.RFeRe_Ndr, C)
    RFeOx_Ndnr = PreallocationTools.get_tmp(f.RFeOx_Ndnr, C)
    RFeOx_Ndr = PreallocationTools.get_tmp(f.RFeOx_Ndr, C)
    RNdnrPO4_pre = PreallocationTools.get_tmp(f.RNdnrPO4_pre, C)
    RNdrPO4_pre = PreallocationTools.get_tmp(f.RNdrPO4_pre, C)
    RIllite_pre = PreallocationTools.get_tmp(f.RIllite_pre, C)
    RBasalt_dis = PreallocationTools.get_tmp(f.RBasalt_dis, C)
    RBasalt_dis_Nd = PreallocationTools.get_tmp(f.RBasalt_dis_Nd, C)
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
    S_SO4 = PreallocationTools.get_tmp(f.S_SO4, C)
    S_TH2S = PreallocationTools.get_tmp(f.S_TH2S, C)
    S_CH4 = PreallocationTools.get_tmp(f.S_CH4, C)
    S_FeS = PreallocationTools.get_tmp(f.S_FeS, C)
    S_FeS2 = PreallocationTools.get_tmp(f.S_FeS2, C)
    S_CaCO3 = PreallocationTools.get_tmp(f.S_CaCO3, C)
    S_Ca = PreallocationTools.get_tmp(f.S_Ca, C)
    S_BSi = PreallocationTools.get_tmp(f.S_BSi, C)
    S_TH4SiO4 = PreallocationTools.get_tmp(f.S_TH4SiO4, C)
    S_Al = PreallocationTools.get_tmp(f.S_Al, C)
    S_SurfMn_Ndnr = PreallocationTools.get_tmp(f.S_SurfMn_Ndnr, C)
    S_TNdnr = PreallocationTools.get_tmp(f.S_TNdnr, C)
    S_SurfMn_Ndr = PreallocationTools.get_tmp(f.S_SurfMn_Ndr, C)
    S_TNdr = PreallocationTools.get_tmp(f.S_TNdr, C)
    S_SurfFe_Ndnr = PreallocationTools.get_tmp(f.S_SurfFe_Ndnr, C)
    S_SurfFe_Ndr = PreallocationTools.get_tmp(f.S_SurfFe_Ndr, C)
    S_NdnrPO4 = PreallocationTools.get_tmp(f.S_NdnrPO4, C)
    S_NdrPO4 = PreallocationTools.get_tmp(f.S_NdrPO4, C)
    S_Illite = PreallocationTools.get_tmp(f.S_Illite, C)
    S_Basalt = PreallocationTools.get_tmp(f.S_Basalt, C)
    S_TA = PreallocationTools.get_tmp(f.S_TA, C)
    S_H = PreallocationTools.get_tmp(f.S_H, C)
    S_Age = PreallocationTools.get_tmp(f.S_Age, C)

    #---------------------------------------------------------------------
    #  Model state
    #---------------------------------------------------------------------
    MnO2 = @view C[MnO2ID]
    FeOOH = @view C[FeOOHID]
    POC = @view C[POCID]
    FeS = @view C[FeSID]
    FeS2 = @view C[FeS2ID]
    CaCO3 = @view C[CaCO3ID]
    Age = @view C[AgeID]
    BSi = @view C[BSiID]
    NdnrPO4 = @view C[NdnrPO4ID]
    NdrPO4 = @view C[NdrPO4ID]
    SurfMn_Ndnr = @view C[SurfMn_NdnrID]
    SurfMn_Ndr = @view C[SurfMn_NdrID]
    SurfFe_Ndnr = @view C[SurfFe_NdnrID]
    SurfFe_Ndr = @view C[SurfFe_NdrID]
    Illite = @view C[IlliteID]
    Basalt = @view C[BasaltID]
    O2 = @view C[O2ID]
    NO3 = @view C[NO3ID]
    CH4 = @view C[CH4ID]
    NO2 = @view C[NO2ID]
    Ca = @view C[CaID]
    SO4 = @view C[SO4ID]
    TMn = @view C[TMnID]
    TFe = @view C[TFeID]
    Al = @view C[AlID]
    TNH4 = @view C[TNH4ID]
    TNdnr = @view C[TNdnrID]
    TNdr = @view C[TNdrID]
    TH4SiO4 = @view C[TH4SiO4ID]
    TCO2 = @view C[TCO2ID]
    TH2S = @view C[TH2SID]
    TH3BO3 = @view C[TH3BO3ID]
    TH3PO4 = @view C[TH3PO4ID]
    H = @view C[HID]
    dMnO2 = @view dC[MnO2ID]
    dFeOOH = @view dC[FeOOHID]
    dPOC = @view dC[POCID]
    dFeS = @view dC[FeSID]
    dFeS2 = @view dC[FeS2ID]
    dCaCO3 = @view dC[CaCO3ID]
    dAge = @view dC[AgeID]
    dBSi = @view dC[BSiID]
    dNdnrPO4 = @view dC[NdnrPO4ID]
    dNdrPO4 = @view dC[NdrPO4ID]
    dSurfMn_Ndnr = @view dC[SurfMn_NdnrID]
    dSurfMn_Ndr = @view dC[SurfMn_NdrID]
    dSurfFe_Ndnr = @view dC[SurfFe_NdnrID]
    dSurfFe_Ndr = @view dC[SurfFe_NdrID]
    dIllite = @view dC[IlliteID]
    dBasalt = @view dC[BasaltID]
    dO2 = @view dC[O2ID]
    dNO3 = @view dC[NO3ID]
    dCH4 = @view dC[CH4ID]
    dNO2 = @view dC[NO2ID]
    dCa = @view dC[CaID]
    dSO4 = @view dC[SO4ID]
    dTMn = @view dC[TMnID]
    dTFe = @view dC[TFeID]
    dAl = @view dC[AlID]
    dTNH4 = @view dC[TNH4ID]
    dTNdnr = @view dC[TNdnrID]
    dTNdr = @view dC[TNdrID]
    dTH4SiO4 = @view dC[TH4SiO4ID]
    dTCO2 = @view dC[TCO2ID]
    dTH2S = @view dC[TH2SID]
    dTH3BO3 = @view dC[TH3BO3ID]
    dTH3PO4 = @view dC[TH3PO4ID]
    dH = @view dC[HID]
    #---------------------------------------------------------------------
    #  Transport of solid and dissolved substances
    #---------------------------------------------------------------------
    mul!(dMnO2, AmMnO2, MnO2)
    mul!(dFeOOH, AmFeOOH, FeOOH)
    mul!(dPOC, AmPOC, POC)
    mul!(dFeS, AmFeS, FeS)
    mul!(dFeS2, AmFeS2, FeS2)
    mul!(dCaCO3, AmCaCO3, CaCO3)
    mul!(dAge, AmAge, Age)
    mul!(dBSi, AmBSi, BSi)
    mul!(dNdnrPO4, AmNdnrPO4, NdnrPO4)
    mul!(dNdrPO4, AmNdrPO4, NdrPO4)
    mul!(dSurfMn_Ndnr, AmSurfMn_Ndnr, SurfMn_Ndnr)
    mul!(dSurfMn_Ndr, AmSurfMn_Ndr, SurfMn_Ndr)
    mul!(dSurfFe_Ndnr, AmSurfFe_Ndnr, SurfFe_Ndnr)
    mul!(dSurfFe_Ndr, AmSurfFe_Ndr, SurfFe_Ndr)
    mul!(dIllite, AmIllite, Illite)
    mul!(dBasalt, AmBasalt, Basalt)
    mul!(dO2, AmO2, O2)
    mul!(dNO3, AmNO3, NO3)
    mul!(dCH4, AmCH4, CH4)
    mul!(dNO2, AmNO2, NO2)
    mul!(dCa, AmCa, Ca)
    mul!(dSO4, AmSO4, SO4)
    dMnO2[1] += BcAmMnO2[1] ⊗ MnO2[1] ⊕ BcCmMnO2[1]
    dFeOOH[1] += BcAmFeOOH[1] ⊗ FeOOH[1] ⊕ BcCmFeOOH[1]
    dPOC[1] += BcAmPOC[1] ⊗ POC[1] ⊕ BcCmPOC[1]
    dFeS[1] += BcAmFeS[1] ⊗ FeS[1] ⊕ BcCmFeS[1]
    dFeS2[1] += BcAmFeS2[1] ⊗ FeS2[1] ⊕ BcCmFeS2[1]
    dCaCO3[1] += BcAmCaCO3[1] ⊗ CaCO3[1] ⊕ BcCmCaCO3[1]
    dAge[1] += BcAmAge[1] ⊗ Age[1] ⊕ BcCmAge[1]
    dBSi[1] += BcAmBSi[1] ⊗ BSi[1] ⊕ BcCmBSi[1]
    dNdnrPO4[1] += BcAmNdnrPO4[1] ⊗ NdnrPO4[1] ⊕ BcCmNdnrPO4[1]
    dNdrPO4[1] += BcAmNdrPO4[1] ⊗ NdrPO4[1] ⊕ BcCmNdrPO4[1]
    dSurfMn_Ndnr[1] += BcAmSurfMn_Ndnr[1] ⊗ SurfMn_Ndnr[1] ⊕ BcCmSurfMn_Ndnr[1]
    dSurfMn_Ndr[1] += BcAmSurfMn_Ndr[1] ⊗ SurfMn_Ndr[1] ⊕ BcCmSurfMn_Ndr[1]
    dSurfFe_Ndnr[1] += BcAmSurfFe_Ndnr[1] ⊗ SurfFe_Ndnr[1] ⊕ BcCmSurfFe_Ndnr[1]
    dSurfFe_Ndr[1] += BcAmSurfFe_Ndr[1] ⊗ SurfFe_Ndr[1] ⊕ BcCmSurfFe_Ndr[1]
    dIllite[1] += BcAmIllite[1] ⊗ Illite[1] ⊕ BcCmIllite[1]
    dBasalt[1] += BcAmBasalt[1] ⊗ Basalt[1] ⊕ BcCmBasalt[1]
    dO2[1] += BcAmO2[1] ⊗ O2[1] ⊕ BcCmO2[1]
    dNO3[1] += BcAmNO3[1] ⊗ NO3[1] ⊕ BcCmNO3[1]
    dCH4[1] += BcAmCH4[1] ⊗ CH4[1] ⊕ BcCmCH4[1]
    dNO2[1] += BcAmNO2[1] ⊗ NO2[1] ⊕ BcCmNO2[1]
    dCa[1] += BcAmCa[1] ⊗ Ca[1] ⊕ BcCmCa[1]
    dSO4[1] += BcAmSO4[1] ⊗ SO4[1] ⊕ BcCmSO4[1]
    dMnO2[Ngrid] += BcAmMnO2[2] ⊗ MnO2[Ngrid] ⊕ BcCmMnO2[2]
    dFeOOH[Ngrid] += BcAmFeOOH[2] ⊗ FeOOH[Ngrid] ⊕ BcCmFeOOH[2]
    dPOC[Ngrid] += BcAmPOC[2] ⊗ POC[Ngrid] ⊕ BcCmPOC[2]
    dFeS[Ngrid] += BcAmFeS[2] ⊗ FeS[Ngrid] ⊕ BcCmFeS[2]
    dFeS2[Ngrid] += BcAmFeS2[2] ⊗ FeS2[Ngrid] ⊕ BcCmFeS2[2]
    dCaCO3[Ngrid] += BcAmCaCO3[2] ⊗ CaCO3[Ngrid] ⊕ BcCmCaCO3[2]
    dAge[Ngrid] += BcAmAge[2] ⊗ Age[Ngrid] ⊕ BcCmAge[2]
    dBSi[Ngrid] += BcAmBSi[2] ⊗ BSi[Ngrid] ⊕ BcCmBSi[2]
    dNdnrPO4[Ngrid] += BcAmNdnrPO4[2] ⊗ NdnrPO4[Ngrid] ⊕ BcCmNdnrPO4[2]
    dNdrPO4[Ngrid] += BcAmNdrPO4[2] ⊗ NdrPO4[Ngrid] ⊕ BcCmNdrPO4[2]
    dSurfMn_Ndnr[Ngrid] +=
        BcAmSurfMn_Ndnr[2] ⊗ SurfMn_Ndnr[Ngrid] ⊕ BcCmSurfMn_Ndnr[2]
    dSurfMn_Ndr[Ngrid] +=
        BcAmSurfMn_Ndr[2] ⊗ SurfMn_Ndr[Ngrid] ⊕ BcCmSurfMn_Ndr[2]
    dSurfFe_Ndnr[Ngrid] +=
        BcAmSurfFe_Ndnr[2] ⊗ SurfFe_Ndnr[Ngrid] ⊕ BcCmSurfFe_Ndnr[2]
    dSurfFe_Ndr[Ngrid] +=
        BcAmSurfFe_Ndr[2] ⊗ SurfFe_Ndr[Ngrid] ⊕ BcCmSurfFe_Ndr[2]
    dIllite[Ngrid] += BcAmIllite[2] ⊗ Illite[Ngrid] ⊕ BcCmIllite[2]
    dBasalt[Ngrid] += BcAmBasalt[2] ⊗ Basalt[Ngrid] ⊕ BcCmBasalt[2]
    dO2[Ngrid] += BcAmO2[2] ⊗ O2[Ngrid] ⊕ BcCmO2[2]
    dNO3[Ngrid] += BcAmNO3[2] ⊗ NO3[Ngrid] ⊕ BcCmNO3[2]
    dCH4[Ngrid] += BcAmCH4[2] ⊗ CH4[Ngrid] ⊕ BcCmCH4[2]
    dNO2[Ngrid] += BcAmNO2[2] ⊗ NO2[Ngrid] ⊕ BcCmNO2[2]
    dCa[Ngrid] += BcAmCa[2] ⊗ Ca[Ngrid] ⊕ BcCmCa[2]
    dSO4[Ngrid] += BcAmSO4[2] ⊗ SO4[Ngrid] ⊕ BcCmSO4[2]
    @.. dO2 += alpha ⊗ (O2BW - O2)
    @.. dNO3 += alpha ⊗ (NO3BW - NO3)
    @.. dCH4 += alpha ⊗ (CH4BW - CH4)
    @.. dNO2 += alpha ⊗ (NO2BW - NO2)
    @.. dCa += alpha ⊗ (CaBW - Ca)
    @.. dSO4 += alpha ⊗ (SO4BW - SO4)
    #---------------------------------------------------------------------
    #  pH code
    #---------------------------------------------------------------------
    #  Concentrations of pH related species
    @.. H4SiO4 = H ⊗ TH4SiO4 / (H ⊕ KH4SiO4)
    @.. H3SiO4 = KH4SiO4 ⊗ TH4SiO4 / (H ⊕ KH4SiO4)
    @.. HCO3 = H ⊗ KCO2 ⊗ TCO2 / (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)
    @.. CO3 = KCO2 ⊗ KHCO3 ⊗ TCO2 / (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)
    @.. CO2 = H^2 ⊗ TCO2 / (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)
    @.. H2S = H ⊗ TH2S / (H ⊕ KH2S)
    @.. HS = KH2S ⊗ TH2S / (H ⊕ KH2S)
    @.. H3BO3 = H ⊗ TH3BO3 / (H ⊕ KH3BO3)
    @.. H4BO4 = KH3BO3 ⊗ TH3BO3 / (H ⊕ KH3BO3)
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
    @.. OH = KH2O / H
    #  dTA/dEIs
    @.. dTA_dTH4SiO4 = KH4SiO4 / (H ⊕ KH4SiO4)
    @.. dTA_dTCO2 = KCO2 ⊗ (H ⊕ 2 ⊗ KHCO3) / (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)
    @.. dTA_dTH2S = KH2S / (H ⊕ KH2S)
    @.. dTA_dTH3BO3 = KH3BO3 / (H ⊕ KH3BO3)
    @.. dTA_dTH3PO4 =
        H ⊗ KH2PO4 ⊗ KH3PO4 /
        (H^3 ⊕ H^2 ⊗ KH3PO4 ⊕ H ⊗ KH2PO4 ⊗ KH3PO4 ⊕ KH2PO4 ⊗ KH3PO4 ⊗ KHPO4) ⊕
        2 ⊗ KH2PO4 ⊗ KH3PO4 ⊗ KHPO4 /
        (H^3 ⊕ H^2 ⊗ KH3PO4 ⊕ H ⊗ KH2PO4 ⊗ KH3PO4 ⊕ KH2PO4 ⊗ KH3PO4 ⊗ KHPO4) ⊕
        -H^3 /
        (H^3 ⊕ H^2 ⊗ KH3PO4 ⊕ H ⊗ KH2PO4 ⊗ KH3PO4 ⊕ KH2PO4 ⊗ KH3PO4 ⊗ KHPO4)
    #  dTA/dH
    @.. dTA_dH = -KH4SiO4 ⊗ TH4SiO4 / (H ⊕ KH4SiO4)^2
    @.. dTA_dH +=
        -KCO2 ⊗ TCO2 ⊗ (H^2 ⊕ 4 ⊗ H ⊗ KHCO3 ⊕ KCO2 ⊗ KHCO3) /
        (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)^2
    @.. dTA_dH += -KH2S ⊗ TH2S / (H ⊕ KH2S)^2
    @.. dTA_dH += -KH3BO3 ⊗ TH3BO3 / (H ⊕ KH3BO3)^2
    @.. dTA_dH +=
        -KH2PO4 ⊗ KH3PO4 ⊗ TH3PO4 ⊗
        (2 ⊗ H^3 ⊕ H^2 ⊗ KH3PO4 - KH2PO4 ⊗ KH3PO4 ⊗ KHPO4) /
        (H^3 ⊕ H^2 ⊗ KH3PO4 ⊕ H ⊗ KH2PO4 ⊗ KH3PO4 ⊕ KH2PO4 ⊗ KH3PO4 ⊗ KHPO4)^2 ⊕
        -2 ⊗ KH2PO4 ⊗ KH3PO4 ⊗ KHPO4 ⊗ TH3PO4 ⊗
        (3 ⊗ H^2 ⊕ 2 ⊗ H ⊗ KH3PO4 ⊕ KH2PO4 ⊗ KH3PO4) /
        (H^3 ⊕ H^2 ⊗ KH3PO4 ⊕ H ⊗ KH2PO4 ⊗ KH3PO4 ⊕ KH2PO4 ⊗ KH3PO4 ⊗ KHPO4)^2 ⊕
        -H^2 ⊗ KH3PO4 ⊗ TH3PO4 ⊗ (H^2 ⊕ 2 ⊗ H ⊗ KH2PO4 ⊕ 3 ⊗ KH2PO4 ⊗ KHPO4) /
        (H^3 ⊕ H^2 ⊗ KH3PO4 ⊕ H ⊗ KH2PO4 ⊗ KH3PO4 ⊕ KH2PO4 ⊗ KH3PO4 ⊗ KHPO4)^2
    @.. dTA_dH += -(H^2 ⊕ KH2O) / H^2
    #  Transport of individual species
    mul!(H4SiO4_tran, AmH4SiO4, H4SiO4)
    H4SiO4_tran[1] += BcAmH4SiO4[1] ⊗ H4SiO4[1] ⊕ BcCmH4SiO4[1]
    H4SiO4_tran[Ngrid] += BcAmH4SiO4[2] ⊗ H4SiO4[Ngrid] ⊕ BcCmH4SiO4[2]
    @.. H4SiO4_tran += alpha ⊗ (H4SiO4BW - H4SiO4)
    mul!(H3SiO4_tran, AmH3SiO4, H3SiO4)
    H3SiO4_tran[1] += BcAmH3SiO4[1] ⊗ H3SiO4[1] ⊕ BcCmH3SiO4[1]
    H3SiO4_tran[Ngrid] += BcAmH3SiO4[2] ⊗ H3SiO4[Ngrid] ⊕ BcCmH3SiO4[2]
    @.. H3SiO4_tran += alpha ⊗ (H3SiO4BW - H3SiO4)
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
    mul!(H_tran, AmH, H)
    H_tran[1] += BcAmH[1] ⊗ H[1] ⊕ BcCmH[1]
    H_tran[Ngrid] += BcAmH[2] ⊗ H[Ngrid] ⊕ BcCmH[2]
    @.. H_tran += alpha ⊗ (HBW - H)
    mul!(OH_tran, AmOH, OH)
    OH_tran[1] += BcAmOH[1] ⊗ OH[1] ⊕ BcCmOH[1]
    OH_tran[Ngrid] += BcAmOH[2] ⊗ OH[Ngrid] ⊕ BcCmOH[2]
    @.. OH_tran += alpha ⊗ (OHBW - OH)
    #  Transport of EIs
    @.. dTH4SiO4 = H4SiO4_tran ⊕ H3SiO4_tran
    @.. dTCO2 = HCO3_tran ⊕ CO3_tran ⊕ CO2_tran
    @.. dTH2S = H2S_tran ⊕ HS_tran
    @.. dTH3BO3 = H3BO3_tran ⊕ H4BO4_tran
    @.. dTH3PO4 = H3PO4_tran ⊕ H2PO4_tran ⊕ HPO4_tran ⊕ PO4_tran
    # Transport of TA
    @.. TA_tran = 0 ⊗ H4SiO4_tran ⊕ 1 ⊗ H3SiO4_tran
    @.. TA_tran += 1 ⊗ HCO3_tran ⊕ 2 ⊗ CO3_tran ⊕ 0 ⊗ CO2_tran
    @.. TA_tran += 0 ⊗ H2S_tran ⊕ 1 ⊗ HS_tran
    @.. TA_tran += 0 ⊗ H3BO3_tran ⊕ 1 ⊗ H4BO4_tran
    @.. TA_tran +=
        -1 ⊗ H3PO4_tran ⊕ 0 ⊗ H2PO4_tran ⊕ 1 ⊗ HPO4_tran ⊕ 2 ⊗ PO4_tran
    @.. TA_tran += -1 ⊗ H_tran ⊕ 1 ⊗ OH_tran
    # Transport of proton
    @.. dH = TA_tran
    @.. dH -= dTH4SiO4 ⊗ dTA_dTH4SiO4
    @.. dH -= dTCO2 ⊗ dTA_dTCO2
    @.. dH -= dTH2S ⊗ dTA_dTH2S
    @.. dH -= dTH3BO3 ⊗ dTA_dTH3BO3
    @.. dH -= dTH3PO4 ⊗ dTA_dTH3PO4
    @.. dH = dH / dTA_dH
    #---------------------------------------------------------------------
    #  Speciation code
    #---------------------------------------------------------------------
    #  Concentrations of adsorbed/dissolved species
    @.. TMn_dis =
        TMn / (FeOOH ⊗ KMn_ads_Fe ⊗ dstopw ⊕ KMn_ads_Mn ⊗ MnO2 ⊗ dstopw ⊕ 1)
    @.. Mn_aq =
        0.00016127682873042885 ⊗ TMn_dis / (
            0.0067789448502993896 ⊗ CO3 ⊕ 9.4394261241973181e-5 ⊗ Cl ⊕
            0.0003606081355498782 ⊗ HCO3 ⊕ 1.0 ⊗ OH^2 ⊕
            0.038706772674900833 ⊗ OH ⊕ 0.0011040350157855885 ⊗ SO4 ⊕
            0.00016127682873042885
        )
    @.. Mn_ads_Mn = KMn_ads_Mn ⊗ MnO2 ⊗ TMn_dis
    @.. Mn_ads_Fe = KMn_ads_Fe ⊗ FeOOH ⊗ TMn_dis
    @.. TMn_ads_MnO2 = Mn_ads_Mn
    @.. TMn_ads_FeOOH = Mn_ads_Fe
    @.. TMn_ads = Mn_ads_Mn ⊕ Mn_ads_Fe
    @.. TFe_dis =
        TFe / (FeOOH ⊗ KFe_ads_Fe ⊗ dstopw ⊕ KFe_ads_Mn ⊗ MnO2 ⊗ dstopw ⊕ 1)
    @.. Fe_aq =
        2.0879303289311948e-6 ⊗ H ⊗ TFe_dis / (
            0.08648903884153634 ⊗ CO3^2 ⊗ H ⊕ 0.0020160662890120839 ⊗ CO3 ⊗ H ⊕
            1.142466716617443e-6 ⊗ Cl ⊗ H ⊕ 7.9420658795994663e-6 ⊗ H ⊗ HCO3 ⊕
            1.0 ⊗ H ⊗ OH^2 ⊕ 0.0099403195550670743 ⊗ H ⊗ OH ⊕
            1.3673535186149135e-5 ⊗ H ⊗ SO4 ⊕ 2.0879303289311948e-6 ⊗ H ⊕
            3.1365432229402516e-9 ⊗ HS
        )
    @.. Fe_ads_Mn = KFe_ads_Mn ⊗ MnO2 ⊗ TFe_dis
    @.. Fe_ads_Fe = KFe_ads_Fe ⊗ FeOOH ⊗ TFe_dis
    @.. TFe_ads_MnO2 = Fe_ads_Mn
    @.. TFe_ads_FeOOH = Fe_ads_Fe
    @.. TFe_ads = Fe_ads_Mn ⊕ Fe_ads_Fe
    @.. Al_dis = Al
    @.. Al_aq =
        1.0 ⊗ Al_dis ⊗ H^4 / (
            1.0 ⊗ H^4 ⊕ 2.3656029049664013e-6 ⊗ H^3 ⊕
            1.818545012275907e-13 ⊗ H^2 ⊕ 5.913794075678346e-19 ⊗ H ⊕
            1.4102686989672256e-26
        )
    @.. TNH4_dis = TNH4 / (KNH4_ads ⊗ dstopw ⊕ 1)
    @.. NH4 = TNH4_dis
    @.. NH4_ads = KNH4_ads ⊗ TNH4_dis
    @.. TNH4_ads_nsf = NH4_ads
    @.. TNH4_ads = NH4_ads
    @.. TNdnr_dis =
        TNdnr / (FeOOH ⊗ KNd_ads_Fe ⊗ dstopw ⊕ KNd_ads_Mn ⊗ MnO2 ⊗ dstopw ⊕ 1)
    @.. Ndnr_aq =
        1.5848931924611108e-11 ⊗ H ⊗ TNdnr_dis / (
            0.057570705746633922 ⊗ CO3^2 ⊗ H ⊕ 4.6030320987039934e-6 ⊗ CO3 ⊗ H ⊕
            5.440449431261466e-12 ⊗ Cl ⊗ H ⊕ 1.0 ⊗ H ⊗ H3SiO4^2 ⊕
            2.5118864315095768e-6 ⊗ H ⊗ H3SiO4 ⊕
            1.1705587843158866e-10 ⊗ H ⊗ HCO3 ⊕
            8.8776628918825467e-10 ⊗ H ⊗ SO4 ⊕ 1.5848931924611108e-11 ⊗ H ⊕
            1.5261884035337975e-20
        )
    @.. Ndnr_ads_Mn = KNd_ads_Mn ⊗ TNdnr_dis ⊗ MnO2
    @.. Ndnr_ads_Fe = KNd_ads_Fe ⊗ TNdnr_dis ⊗ FeOOH
    @.. TNdnr_ads_MnO2 = Ndnr_ads_Mn
    @.. TNdnr_ads_FeOOH = Ndnr_ads_Fe
    @.. TNdnr_ads = Ndnr_ads_Mn ⊕ Ndnr_ads_Fe
    @.. TNdr_dis =
        TNdr / (FeOOH ⊗ KNd_ads_Fe ⊗ dstopw ⊕ KNd_ads_Mn ⊗ MnO2 ⊗ dstopw ⊕ 1)
    @.. Ndr_aq =
        1.5848931924611108e-11 ⊗ H ⊗ TNdr_dis / (
            0.057570705746633922 ⊗ CO3^2 ⊗ H ⊕ 4.6030320987039934e-6 ⊗ CO3 ⊗ H ⊕
            5.440449431261466e-12 ⊗ Cl ⊗ H ⊕ 1.0 ⊗ H ⊗ H3SiO4^2 ⊕
            2.5118864315095768e-6 ⊗ H ⊗ H3SiO4 ⊕
            1.170558784315887e-10 ⊗ H ⊗ HCO3 ⊕
            8.8776628918825467e-10 ⊗ H ⊗ SO4 ⊕ 1.5848931924611108e-11 ⊗ H ⊕
            1.5261884035337975e-20
        )
    @.. Ndr_ads_Mn = KNd_ads_Mn ⊗ TNdr_dis ⊗ MnO2
    @.. Ndr_ads_Fe = KNd_ads_Fe ⊗ TNdr_dis ⊗ FeOOH
    @.. TNdr_ads_MnO2 = Ndr_ads_Mn
    @.. TNdr_ads_FeOOH = Ndr_ads_Fe
    @.. TNdr_ads = Ndr_ads_Mn ⊕ Ndr_ads_Fe
    #  Transport of adsorbed/dissolved species
    mul!(TMn_dis_tran, AmTMn_dis, TMn_dis)
    TMn_dis_tran[1] += BcAmTMn_dis[1] ⊗ TMn_dis[1] ⊕ BcCmTMn_dis[1]
    TMn_dis_tran[Ngrid] += BcAmTMn_dis[2] ⊗ TMn_dis[Ngrid] ⊕ BcCmTMn_dis[2]
    mul!(TMn_ads_tran, AmTMn_ads, TMn_ads)
    TMn_ads_tran[1] += BcAmTMn_ads[1] ⊗ TMn_ads[1] ⊕ BcCmTMn_ads[1]
    TMn_ads_tran[Ngrid] += BcAmTMn_ads[2] ⊗ TMn_ads[Ngrid] ⊕ BcCmTMn_ads[2]
    @.. dTMn = TMn_dis_tran ⊗ 1 ⊕ TMn_ads_tran ⊗ dstopw
    @.. dTMn += alpha ⊗ (TMn_dis0 - TMn_dis)

    mul!(TFe_dis_tran, AmTFe_dis, TFe_dis)
    TFe_dis_tran[1] += BcAmTFe_dis[1] ⊗ TFe_dis[1] ⊕ BcCmTFe_dis[1]
    TFe_dis_tran[Ngrid] += BcAmTFe_dis[2] ⊗ TFe_dis[Ngrid] ⊕ BcCmTFe_dis[2]
    mul!(TFe_ads_tran, AmTFe_ads, TFe_ads)
    TFe_ads_tran[1] += BcAmTFe_ads[1] ⊗ TFe_ads[1] ⊕ BcCmTFe_ads[1]
    TFe_ads_tran[Ngrid] += BcAmTFe_ads[2] ⊗ TFe_ads[Ngrid] ⊕ BcCmTFe_ads[2]
    @.. dTFe = TFe_dis_tran ⊗ 1 ⊕ TFe_ads_tran ⊗ dstopw
    @.. dTFe += alpha ⊗ (TFe_dis0 - TFe_dis)

    mul!(Al_dis_tran, AmAl_dis, Al_dis)
    Al_dis_tran[1] += BcAmAl_dis[1] ⊗ Al_dis[1] ⊕ BcCmAl_dis[1]
    Al_dis_tran[Ngrid] += BcAmAl_dis[2] ⊗ Al_dis[Ngrid] ⊕ BcCmAl_dis[2]
    @.. dAl = Al_dis_tran ⊗ 1
    @.. dAl += alpha ⊗ (Al_disBW - Al_dis)

    mul!(TNH4_dis_tran, AmTNH4_dis, TNH4_dis)
    TNH4_dis_tran[1] += BcAmTNH4_dis[1] ⊗ TNH4_dis[1] ⊕ BcCmTNH4_dis[1]
    TNH4_dis_tran[Ngrid] += BcAmTNH4_dis[2] ⊗ TNH4_dis[Ngrid] ⊕ BcCmTNH4_dis[2]
    mul!(TNH4_ads_tran, AmTNH4_ads, TNH4_ads)
    TNH4_ads_tran[1] += BcAmTNH4_ads[1] ⊗ TNH4_ads[1] ⊕ BcCmTNH4_ads[1]
    TNH4_ads_tran[Ngrid] += BcAmTNH4_ads[2] ⊗ TNH4_ads[Ngrid] ⊕ BcCmTNH4_ads[2]
    @.. dTNH4 = TNH4_dis_tran ⊗ 1 ⊕ TNH4_ads_tran ⊗ dstopw
    @.. dTNH4 += alpha ⊗ (TNH4_dis0 - TNH4_dis)

    mul!(TNdnr_dis_tran, AmTNdnr_dis, TNdnr_dis)
    TNdnr_dis_tran[1] += BcAmTNdnr_dis[1] ⊗ TNdnr_dis[1] ⊕ BcCmTNdnr_dis[1]
    TNdnr_dis_tran[Ngrid] +=
        BcAmTNdnr_dis[2] ⊗ TNdnr_dis[Ngrid] ⊕ BcCmTNdnr_dis[2]
    mul!(TNdnr_ads_tran, AmTNdnr_ads, TNdnr_ads)
    TNdnr_ads_tran[1] += BcAmTNdnr_ads[1] ⊗ TNdnr_ads[1] ⊕ BcCmTNdnr_ads[1]
    TNdnr_ads_tran[Ngrid] +=
        BcAmTNdnr_ads[2] ⊗ TNdnr_ads[Ngrid] ⊕ BcCmTNdnr_ads[2]
    @.. dTNdnr = TNdnr_dis_tran ⊗ 1 ⊕ TNdnr_ads_tran ⊗ dstopw
    @.. dTNdnr += alpha ⊗ (TNdnr_dis0 - TNdnr_dis)

    mul!(TNdr_dis_tran, AmTNdr_dis, TNdr_dis)
    TNdr_dis_tran[1] += BcAmTNdr_dis[1] ⊗ TNdr_dis[1] ⊕ BcCmTNdr_dis[1]
    TNdr_dis_tran[Ngrid] += BcAmTNdr_dis[2] ⊗ TNdr_dis[Ngrid] ⊕ BcCmTNdr_dis[2]
    mul!(TNdr_ads_tran, AmTNdr_ads, TNdr_ads)
    TNdr_ads_tran[1] += BcAmTNdr_ads[1] ⊗ TNdr_ads[1] ⊕ BcCmTNdr_ads[1]
    TNdr_ads_tran[Ngrid] += BcAmTNdr_ads[2] ⊗ TNdr_ads[Ngrid] ⊕ BcCmTNdr_ads[2]
    @.. dTNdr = TNdr_dis_tran ⊗ 1 ⊕ TNdr_ads_tran ⊗ dstopw
    @.. dTNdr += alpha ⊗ (TNdr_dis0 - TNdr_dis)

    #---------------------------------------------------------------------
    #  Reaction code
    #---------------------------------------------------------------------
    # Individual reaction rates
    @.. Omega_RFeS_dis = Fe_aq ⊗ HS / (H ⊗ KspFeS)
    @.. Omega_RFeS_pre = Fe_aq ⊗ HS / (H ⊗ KspFeS)
    @.. Omega_RCaCO3_dis = Ca ⊗ CO3 / KspCaCO3_dis
    @.. Omega_RBSi_dis = TH4SiO4 / H4SiO4_dis_sat
    @.. Omega_RBasalt_dis = H4SiO4 ⊗ Al_aq^0.36 / H^1.08 / KspBasalt
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
        SO4 / (KSO4 ⊕ SO4) ⊗ KFeOOH / (KFeOOH ⊕ FeOOH) ⊗ KMnO2 /
        (KMnO2 ⊕ MnO2) ⊗ KNO3 / (KNO3 ⊕ NO3) ⊗ KNO2 / (KNO2 ⊕ NO2) ⊗ KO2 /
        (KO2 ⊕ O2) ⊗ nu / (a ⊕ Age) ⊗ POC
    @.. RCH4POC =
        KSO4 / (KSO4 ⊕ SO4) ⊗ KFeOOH / (KFeOOH ⊕ FeOOH) ⊗ KMnO2 /
        (KMnO2 ⊕ MnO2) ⊗ KNO3 / (KNO3 ⊕ NO3) ⊗ KNO2 / (KNO2 ⊕ NO2) ⊗ KO2 /
        (KO2 ⊕ O2) ⊗ nu / (a ⊕ Age) ⊗ POC
    @.. RO2NO2 = kO2NO2 ⊗ O2 ⊗ NO2
    @.. RO2NH4 = kO2NH4 ⊗ O2 ⊗ TNH4_dis
    @.. RO2Mn = kO2Mn ⊗ O2 ⊗ TMn_dis
    @.. RO2Mn_ads = kO2Mn_ads ⊗ O2 ⊗ TMn_ads
    @.. RO2Fe = kO2Fe ⊗ O2 ⊗ TFe_dis
    @.. RO2Fe_ads = kO2Fe_ads ⊗ O2 ⊗ TFe_ads
    @.. RO2H2S = kO2H2S ⊗ O2 ⊗ TH2S
    @.. RO2FeS = kO2FeS ⊗ O2 ⊗ FeS
    @.. RO2CH4 = kO2CH4 ⊗ O2 ⊗ CH4
    @.. RNO2NH4 = kNO2NH4 ⊗ NO2 ⊗ TNH4_dis
    @.. RSO4CH4 = kAOM ⊗ CH4 ⊗ SO4 / (SO4 ⊕ KAOM)
    @.. RMnO2Fe = kMnO2Fe ⊗ MnO2 ⊗ TFe_dis
    @.. RMnO2H2S = kMnO2H2S ⊗ MnO2 ⊗ TH2S
    @.. RFeOOHH2S = kFeOOHH2S ⊗ FeOOH ⊗ TH2S
    @.. RFeSH2S = kFeSH2S ⊗ FeS ⊗ TH2S
    @.. RFeS_dis =
        (-tanh(1e3 ⊗ (Omega_RFeS_dis - 1.0)) / 2 ⊕ 0.5) ⊗
        (kFeSdis ⊗ FeS ⊗ (1 - Omega_RFeS_dis))
    @.. RFeS_pre =
        (tanh(1e3 ⊗ (Omega_RFeS_pre - 1.0)) / 2 ⊕ 0.5) ⊗
        (kFeSpre ⊗ TFe_dis ⊗ TH2S ⊗ (Omega_RFeS_pre - 1))
    @.. RCaCO3_dis =
        (-tanh(1e3 ⊗ (Omega_RCaCO3_dis - 1.0)) / 2 ⊕ 0.5) ⊗ (
            kCaCO3dis0 ⊗ CaCO3 ⊕
            kCaCO3dis1 ⊗ CaCO3 ⊗ (1 - Omega_RCaCO3_dis)^nCaCO3dis
        )
    @.. RBSi_dis =
        (-tanh(1e3 ⊗ (Omega_RBSi_dis - 1.0)) / 2 ⊕ 0.5) ⊗
        (kBSi_dis ⊗ BSi ⊗ (1 - Omega_RBSi_dis))
    @.. RMnRe_Ndnr =
        (RMnO2POC ⊗ 2 ⊕ RMnO2H2S ⊕ RMnO2Fe / 2) ⊗ SurfMn_Ndnr / MnO2
    @.. RMnRe_Ndr = (RMnO2POC ⊗ 2 ⊕ RMnO2H2S ⊕ RMnO2Fe / 2) ⊗ SurfMn_Ndr / MnO2
    @.. RMnOx_Ndnr = (RO2Mn ⊕ RO2Mn_ads ⊗ dstopw) ⊗ TNdnr_dis / TMn_dis ⊗ DNdMn
    @.. RMnOx_Ndr = (RO2Mn ⊕ RO2Mn_ads ⊗ dstopw) ⊗ TNdr_dis / TMn_dis ⊗ DNdMn
    @.. RFeRe_Ndnr = (RFeOOHPOC ⊗ 4 ⊕ RFeOOHH2S ⊗ 2) ⊗ SurfFe_Ndnr / FeOOH
    @.. RFeRe_Ndr = (RFeOOHPOC ⊗ 4 ⊕ RFeOOHH2S ⊗ 2) ⊗ SurfFe_Ndr / FeOOH
    @.. RFeOx_Ndnr =
        (RO2Fe ⊕ RO2Fe_ads ⊗ dstopw ⊕ RMnO2Fe ⊗ dstopw) ⊗ TNdnr_dis / TFe_dis ⊗
        DNdFe
    @.. RFeOx_Ndr =
        (RO2Fe ⊕ RO2Fe_ads ⊗ dstopw ⊕ RMnO2Fe ⊗ dstopw) ⊗ TNdr_dis / TFe_dis ⊗
        DNdFe
    @.. RNdnrPO4_pre =
        kNdPO4_pre ⊗ (Ndnr_aq ⊗ PO4 / KspNdPO4 - NdnrPO4 / (NdnrPO4 ⊕ NdrPO4))
    @.. RNdrPO4_pre =
        kNdPO4_pre ⊗ (Ndr_aq ⊗ PO4 / KspNdPO4 - NdrPO4 / (NdnrPO4 ⊕ NdrPO4))
    @.. RIllite_pre =
        kIllite ⊗ Illite ⊗ (
            10^(
                log10(0.0106) ⊗ 0.85 ⊕ log10(Al_aq) ⊗ 2.85 ⊕
                log10(H4SiO4) ⊗ 3.15 - log10(H) ⊗ 9.4 - log10(KspIllite)
            ) - 1
        ) ⊗ dstopw
    @.. RBasalt_dis =
        (-tanh(1e3 ⊗ (Omega_RBasalt_dis - 1.0)) / 2 ⊕ 0.5) ⊗ (
            kBasalt ⊗ Basalt ⊗ H ⊗ 0.6701 / (Al_aq ⊗ 0.0781)^(1 / 3) ⊗
            (1 - Omega_RBasalt_dis) / a_lith0
        )
    @.. RBasalt_dis_Nd = RBasalt_dis ⊗ dstopw

    # Summed rates for model substances
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
        1 ⊗ RCaCO3_dis ⊗ dstopw
    @.. S_TNH4 =
        rNC ⊗ RO2POC ⊗ dstopw ⊕ rNC ⊗ RNO2POC ⊗ dstopw ⊕
        rNC ⊗ RNO3POC ⊗ dstopw ⊕ rNC ⊗ RMnO2POC ⊗ dstopw ⊕
        rNC ⊗ RFeOOHPOC ⊗ dstopw ⊕ rNC ⊗ RSO4POC ⊗ dstopw ⊕
        rNC ⊗ RCH4POC ⊗ dstopw ⊕ -1 ⊗ RO2NH4 ⊕ -1 ⊗ RNO2NH4
    @.. S_TH3PO4 =
        rPC ⊗ RO2POC ⊗ dstopw ⊕ rPC ⊗ RNO2POC ⊗ dstopw ⊕
        rPC ⊗ RNO3POC ⊗ dstopw ⊕ rPC ⊗ RMnO2POC ⊗ dstopw ⊕
        rPC ⊗ RFeOOHPOC ⊗ dstopw ⊕ rPC ⊗ RSO4POC ⊗ dstopw ⊕
        rPC ⊗ RCH4POC ⊗ dstopw ⊕ -1 ⊗ RNdnrPO4_pre ⊕ -1 ⊗ RNdrPO4_pre
    @.. S_NO2 =
        -4 / 3 ⊗ RNO2POC ⊗ dstopw ⊕ 2 ⊗ RNO3POC ⊗ dstopw ⊕ -1 ⊗ RO2NO2 ⊕
        1 ⊗ RO2NH4 ⊕ -1 ⊗ RNO2NH4
    @.. S_NO3 = -2 ⊗ RNO3POC ⊗ dstopw ⊕ 1 ⊗ RO2NO2
    @.. S_MnO2 =
        -2 ⊗ RMnO2POC ⊕ 1 ⊗ RO2Mn ⊗ pwtods ⊕ 1 ⊗ RO2Mn_ads ⊕ -1 / 2 ⊗ RMnO2Fe ⊕
        -1 ⊗ RMnO2H2S
    @.. S_TMn =
        2 ⊗ RMnO2POC ⊗ dstopw ⊕ -1 ⊗ RO2Mn ⊕ -1 ⊗ RO2Mn_ads ⊗ dstopw ⊕
        1 / 2 ⊗ RMnO2Fe ⊗ dstopw ⊕ 1 ⊗ RMnO2H2S ⊗ dstopw
    @.. S_FeOOH =
        -4 ⊗ RFeOOHPOC ⊕ 1 ⊗ RO2Fe ⊗ pwtods ⊕ 1 ⊗ RO2Fe_ads ⊕ 1 ⊗ RO2FeS ⊕
        1 ⊗ RMnO2Fe ⊕ -2 ⊗ RFeOOHH2S
    @.. S_TFe =
        4 ⊗ RFeOOHPOC ⊗ dstopw ⊕ -1 ⊗ RO2Fe ⊕ -1 ⊗ RO2Fe_ads ⊗ dstopw ⊕
        -1 ⊗ RMnO2Fe ⊗ dstopw ⊕ 2 ⊗ RFeOOHH2S ⊗ dstopw ⊕ 1 ⊗ RFeS_dis ⊗ dstopw ⊕
        -1 ⊗ RFeS_pre
    @.. S_SO4 =
        -1 / 2 ⊗ RSO4POC ⊗ dstopw ⊕ 1 ⊗ RO2H2S ⊕ 1 ⊗ RO2FeS ⊗ dstopw ⊕
        -1 ⊗ RSO4CH4
    @.. S_TH2S =
        1 / 2 ⊗ RSO4POC ⊗ dstopw ⊕ -1 ⊗ RO2H2S ⊕ 1 ⊗ RSO4CH4 ⊕
        -1 ⊗ RMnO2H2S ⊗ dstopw ⊕ -1 ⊗ RFeOOHH2S ⊗ dstopw ⊕
        -1 ⊗ RFeSH2S ⊗ dstopw ⊕ 1 ⊗ RFeS_dis ⊗ dstopw ⊕ -1 ⊗ RFeS_pre
    @.. S_CH4 = 1 / 2 ⊗ RCH4POC ⊗ dstopw ⊕ -1 ⊗ RO2CH4 ⊕ -1 ⊗ RSO4CH4
    @.. S_FeS =
        -1 ⊗ RO2FeS ⊕ -1 ⊗ RFeSH2S ⊕ -1 ⊗ RFeS_dis ⊕ 1 ⊗ RFeS_pre ⊗ pwtods
    @.. S_FeS2 = 1 ⊗ RFeSH2S
    @.. S_CaCO3 = -1 ⊗ RCaCO3_dis
    @.. S_Ca = 1 ⊗ RCaCO3_dis ⊗ dstopw
    @.. S_BSi = -1 ⊗ RBSi_dis
    @.. S_TH4SiO4 =
        1 ⊗ RBSi_dis ⊗ dstopw ⊕ -3.15 ⊗ RIllite_pre ⊕ 1 ⊗ RBasalt_dis ⊗ dstopw
    @.. S_Al =
        rAlSi ⊗ RBSi_dis ⊗ dstopw ⊕ -2.85 ⊗ RIllite_pre ⊕
        0.36 ⊗ RBasalt_dis ⊗ dstopw
    @.. S_SurfMn_Ndnr = -1 ⊗ RMnRe_Ndnr ⊕ 1 ⊗ RMnOx_Ndnr ⊗ pwtods
    @.. S_TNdnr =
        1 ⊗ RMnRe_Ndnr ⊗ dstopw ⊕ -1 ⊗ RMnOx_Ndnr ⊕ 1 ⊗ RFeRe_Ndnr ⊗ dstopw ⊕
        -1 ⊗ RFeOx_Ndnr ⊕ -1 ⊗ RNdnrPO4_pre ⊕ rNdnrSi_lith ⊗ RBasalt_dis_Nd
    @.. S_SurfMn_Ndr = -1 ⊗ RMnRe_Ndr ⊕ 1 ⊗ RMnOx_Ndr ⊗ pwtods
    @.. S_TNdr =
        1 ⊗ RMnRe_Ndr ⊗ dstopw ⊕ -1 ⊗ RMnOx_Ndr ⊕ 1 ⊗ RFeRe_Ndr ⊗ dstopw ⊕
        -1 ⊗ RFeOx_Ndr ⊕ -1 ⊗ RNdrPO4_pre ⊕ rNdrSi_lith ⊗ RBasalt_dis_Nd
    @.. S_SurfFe_Ndnr = -1 ⊗ RFeRe_Ndnr ⊕ 1 ⊗ RFeOx_Ndnr ⊗ pwtods
    @.. S_SurfFe_Ndr = -1 ⊗ RFeRe_Ndr ⊕ 1 ⊗ RFeOx_Ndr ⊗ pwtods
    @.. S_NdnrPO4 = 1 ⊗ RNdnrPO4_pre ⊗ pwtods
    @.. S_NdrPO4 = 1 ⊗ RNdrPO4_pre ⊗ pwtods
    @.. S_Illite = 1 ⊗ RIllite_pre ⊗ pwtods
    @.. S_Basalt = -1 ⊗ RBasalt_dis
    @.. S_TA =
        (rNC - rPC) ⊗ RO2POC ⊗ dstopw ⊕ (rNC - rPC ⊕ 4 / 3) ⊗ RNO2POC ⊗ dstopw ⊕
        (rNC - rPC) ⊗ RNO3POC ⊗ dstopw ⊕ (rNC - rPC ⊕ 4) ⊗ RMnO2POC ⊗ dstopw ⊕
        (rNC - rPC ⊕ 8) ⊗ RFeOOHPOC ⊗ dstopw ⊕
        (rNC - rPC ⊕ 1) ⊗ RSO4POC ⊗ dstopw ⊕ (rNC - rPC) ⊗ RCH4POC ⊗ dstopw ⊕
        -2 ⊗ RO2NH4 ⊕ -2 ⊗ RO2Mn ⊕ -2 ⊗ RO2Mn_ads ⊗ dstopw ⊕ -2 ⊗ RO2Fe ⊕
        -2 ⊗ RO2Fe_ads ⊗ dstopw ⊕ -2 ⊗ RO2H2S ⊕ -2 ⊗ RO2FeS ⊗ dstopw ⊕
        2 ⊗ RSO4CH4 ⊕ -1 ⊗ RMnO2Fe ⊗ dstopw ⊕ 2 ⊗ RMnO2H2S ⊗ dstopw ⊕
        4 ⊗ RFeOOHH2S ⊗ dstopw ⊕ 1 ⊗ RFeS_dis ⊗ dstopw ⊕ -1 ⊗ RFeS_pre ⊕
        -47 / 5 ⊗ RIllite_pre ⊕ 27 / 25 ⊗ RBasalt_dis ⊗ dstopw
    @.. S_TA += 2 ⊗ RCaCO3_dis ⊗ dstopw
    @.. S_TA += -2 ⊗ RNdnrPO4_pre ⊕ -2 ⊗ RNdrPO4_pre
    @.. S_TA += 1 ⊗ RFeS_dis ⊗ dstopw ⊕ -1 ⊗ RFeS_pre
    @.. S_H = S_TA
    @.. S_H -= S_TCO2 ⊗ dTA_dTCO2
    @.. S_H -= S_TH3PO4 ⊗ dTA_dTH3PO4
    @.. S_H -= S_TH2S ⊗ dTA_dTH2S
    @.. S_H -= S_TH4SiO4 ⊗ dTA_dTH4SiO4
    @.. S_H = S_H / dTA_dH
    @.. S_Age = 1

    @.. dMnO2 += S_MnO2
    @.. dFeOOH += S_FeOOH
    @.. dPOC += S_POC
    @.. dFeS += S_FeS
    @.. dFeS2 += S_FeS2
    @.. dCaCO3 += S_CaCO3
    @.. dAge += S_Age
    @.. dBSi += S_BSi
    @.. dNdnrPO4 += S_NdnrPO4
    @.. dNdrPO4 += S_NdrPO4
    @.. dSurfMn_Ndnr += S_SurfMn_Ndnr
    @.. dSurfMn_Ndr += S_SurfMn_Ndr
    @.. dSurfFe_Ndnr += S_SurfFe_Ndnr
    @.. dSurfFe_Ndr += S_SurfFe_Ndr
    @.. dIllite += S_Illite
    @.. dBasalt += S_Basalt
    @.. dO2 += S_O2
    @.. dNO3 += S_NO3
    @.. dCH4 += S_CH4
    @.. dNO2 += S_NO2
    @.. dCa += S_Ca
    @.. dSO4 += S_SO4
    @.. dTMn += S_TMn
    @.. dTFe += S_TFe
    @.. dAl += S_Al
    @.. dTNH4 += S_TNH4
    @.. dTNdnr += S_TNdnr
    @.. dTNdr += S_TNdr
    @.. dTH4SiO4 += S_TH4SiO4
    @.. dTCO2 += S_TCO2
    @.. dTH2S += S_TH2S
    @.. dTH3PO4 += S_TH3PO4
    @.. dH += S_H

    return nothing
end
