function (f::Cache.Reactran)(dC, C, parms, t)
    Mn = PreallocationTools.get_tmp(f.Mn, C)
    Mn_tran = PreallocationTools.get_tmp(f.Mn_tran, C)
    Mn_ads_Mn = PreallocationTools.get_tmp(f.Mn_ads_Mn, C)
    Mn_ads_Mn_tran = PreallocationTools.get_tmp(f.Mn_ads_Mn_tran, C)
    Mn_ads_Fe = PreallocationTools.get_tmp(f.Mn_ads_Fe, C)
    Mn_ads_Fe_tran = PreallocationTools.get_tmp(f.Mn_ads_Fe_tran, C)
    Fe = PreallocationTools.get_tmp(f.Fe, C)
    Fe_tran = PreallocationTools.get_tmp(f.Fe_tran, C)
    Fe_ads_Mn = PreallocationTools.get_tmp(f.Fe_ads_Mn, C)
    Fe_ads_Mn_tran = PreallocationTools.get_tmp(f.Fe_ads_Mn_tran, C)
    Fe_ads_Fe = PreallocationTools.get_tmp(f.Fe_ads_Fe, C)
    Fe_ads_Fe_tran = PreallocationTools.get_tmp(f.Fe_ads_Fe_tran, C)
    Ndnr = PreallocationTools.get_tmp(f.Ndnr, C)
    Ndnr_tran = PreallocationTools.get_tmp(f.Ndnr_tran, C)
    Ndnr_ads_Mn = PreallocationTools.get_tmp(f.Ndnr_ads_Mn, C)
    Ndnr_ads_Mn_tran = PreallocationTools.get_tmp(f.Ndnr_ads_Mn_tran, C)
    Ndnr_ads_Fe = PreallocationTools.get_tmp(f.Ndnr_ads_Fe, C)
    Ndnr_ads_Fe_tran = PreallocationTools.get_tmp(f.Ndnr_ads_Fe_tran, C)
    Ndr = PreallocationTools.get_tmp(f.Ndr, C)
    Ndr_tran = PreallocationTools.get_tmp(f.Ndr_tran, C)
    Ndr_ads_Mn = PreallocationTools.get_tmp(f.Ndr_ads_Mn, C)
    Ndr_ads_Mn_tran = PreallocationTools.get_tmp(f.Ndr_ads_Mn_tran, C)
    Ndr_ads_Fe = PreallocationTools.get_tmp(f.Ndr_ads_Fe, C)
    Ndr_ads_Fe_tran = PreallocationTools.get_tmp(f.Ndr_ads_Fe_tran, C)
    NH4_ads = PreallocationTools.get_tmp(f.NH4_ads, C)
    HCO3 = PreallocationTools.get_tmp(f.HCO3, C)
    CO3 = PreallocationTools.get_tmp(f.CO3, C)
    CO2 = PreallocationTools.get_tmp(f.CO2, C)
    H2S = PreallocationTools.get_tmp(f.H2S, C)
    HS = PreallocationTools.get_tmp(f.HS, C)
    H3BO3 = PreallocationTools.get_tmp(f.H3BO3, C)
    H4BO4 = PreallocationTools.get_tmp(f.H4BO4, C)
    OH = PreallocationTools.get_tmp(f.OH, C)
    H4SiO4 = PreallocationTools.get_tmp(f.H4SiO4, C)
    H3SiO4 = PreallocationTools.get_tmp(f.H3SiO4, C)
    H3PO4 = PreallocationTools.get_tmp(f.H3PO4, C)
    H2PO4 = PreallocationTools.get_tmp(f.H2PO4, C)
    HPO4 = PreallocationTools.get_tmp(f.HPO4, C)
    PO4 = PreallocationTools.get_tmp(f.PO4, C)
    HCO3_tran = PreallocationTools.get_tmp(f.HCO3_tran, C)
    CO3_tran = PreallocationTools.get_tmp(f.CO3_tran, C)
    CO2_tran = PreallocationTools.get_tmp(f.CO2_tran, C)
    H2S_tran = PreallocationTools.get_tmp(f.H2S_tran, C)
    HS_tran = PreallocationTools.get_tmp(f.HS_tran, C)
    H3BO3_tran = PreallocationTools.get_tmp(f.H3BO3_tran, C)
    H4BO4_tran = PreallocationTools.get_tmp(f.H4BO4_tran, C)
    H_tran = PreallocationTools.get_tmp(f.H_tran, C)
    OH_tran = PreallocationTools.get_tmp(f.OH_tran, C)
    TA_tran = PreallocationTools.get_tmp(f.TA_tran, C)
    dTA_dH = PreallocationTools.get_tmp(f.dTA_dH, C)
    dTA_dTCO2 = PreallocationTools.get_tmp(f.dTA_dTCO2, C)
    dTA_dTH2S = PreallocationTools.get_tmp(f.dTA_dTH2S, C)
    dTA_dTH3BO3 = PreallocationTools.get_tmp(f.dTA_dTH3BO3, C)
    Fe_free = PreallocationTools.get_tmp(f.Fe_free, C)
    Al_free = PreallocationTools.get_tmp(f.Al_free, C)
    Ndnr_free = PreallocationTools.get_tmp(f.Ndnr_free, C)
    Ndr_free = PreallocationTools.get_tmp(f.Ndr_free, C)
    Mn_free = PreallocationTools.get_tmp(f.Mn_free, C)
    Omega_RFeS_dis = PreallocationTools.get_tmp(f.Omega_RFeS_dis, C)
    Omega_RFeS_pre = PreallocationTools.get_tmp(f.Omega_RFeS_pre, C)
    Omega_RCaCO3_dis = PreallocationTools.get_tmp(f.Omega_RCaCO3_dis, C)
    Omega_RCaCO3_pre = PreallocationTools.get_tmp(f.Omega_RCaCO3_pre, C)
    Omega_RMnCO3_dis = PreallocationTools.get_tmp(f.Omega_RMnCO3_dis, C)
    Omega_RMnCO3_pre = PreallocationTools.get_tmp(f.Omega_RMnCO3_pre, C)
    Omega_RFeCO3_dis = PreallocationTools.get_tmp(f.Omega_RFeCO3_dis, C)
    Omega_RFeCO3_pre = PreallocationTools.get_tmp(f.Omega_RFeCO3_pre, C)
    Omega_RBSi_dis = PreallocationTools.get_tmp(f.Omega_RBSi_dis, C)
    Omega_RBasalt_dis = PreallocationTools.get_tmp(f.Omega_RBasalt_dis, C)
    Omega_RNdnrPO4_pre = PreallocationTools.get_tmp(f.Omega_RNdnrPO4_pre, C)
    Omega_RNdrPO4_pre = PreallocationTools.get_tmp(f.Omega_RNdrPO4_pre, C)
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
    RBasalt_dis = PreallocationTools.get_tmp(f.RBasalt_dis, C)
    RBasalt_dis_Nd = PreallocationTools.get_tmp(f.RBasalt_dis_Nd, C)
    RNdnrPO4_pre = PreallocationTools.get_tmp(f.RNdnrPO4_pre, C)
    RNdrPO4_pre = PreallocationTools.get_tmp(f.RNdrPO4_pre, C)
    RMnRe_Ndnr = PreallocationTools.get_tmp(f.RMnRe_Ndnr, C)
    RMnRe_Ndr = PreallocationTools.get_tmp(f.RMnRe_Ndr, C)
    RMnOx_Ndnr = PreallocationTools.get_tmp(f.RMnOx_Ndnr, C)
    RMnOx_Ndr = PreallocationTools.get_tmp(f.RMnOx_Ndr, C)
    RFeRe_Ndnr = PreallocationTools.get_tmp(f.RFeRe_Ndnr, C)
    RFeRe_Ndr = PreallocationTools.get_tmp(f.RFeRe_Ndr, C)
    RFeOx_Ndnr = PreallocationTools.get_tmp(f.RFeOx_Ndnr, C)
    RFeOx_Ndr = PreallocationTools.get_tmp(f.RFeOx_Ndr, C)
    S_POC = PreallocationTools.get_tmp(f.S_POC, C)
    S_O2 = PreallocationTools.get_tmp(f.S_O2, C)
    S_TCO2 = PreallocationTools.get_tmp(f.S_TCO2, C)
    S_NH4 = PreallocationTools.get_tmp(f.S_NH4, C)
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
    S_MnCO3 = PreallocationTools.get_tmp(f.S_MnCO3, C)
    S_FeCO3 = PreallocationTools.get_tmp(f.S_FeCO3, C)
    S_BSi = PreallocationTools.get_tmp(f.S_BSi, C)
    S_TH4SiO4 = PreallocationTools.get_tmp(f.S_TH4SiO4, C)
    S_Basalt = PreallocationTools.get_tmp(f.S_Basalt, C)
    S_Al = PreallocationTools.get_tmp(f.S_Al, C)
    S_TNdnr = PreallocationTools.get_tmp(f.S_TNdnr, C)
    S_TNdr = PreallocationTools.get_tmp(f.S_TNdr, C)
    S_NdnrPO4 = PreallocationTools.get_tmp(f.S_NdnrPO4, C)
    S_NdrPO4 = PreallocationTools.get_tmp(f.S_NdrPO4, C)
    S_SurfMn_Ndnr = PreallocationTools.get_tmp(f.S_SurfMn_Ndnr, C)
    S_SurfMn_Ndr = PreallocationTools.get_tmp(f.S_SurfMn_Ndr, C)
    S_SurfFe_Ndnr = PreallocationTools.get_tmp(f.S_SurfFe_Ndnr, C)
    S_SurfFe_Ndr = PreallocationTools.get_tmp(f.S_SurfFe_Ndr, C)
    S_TA = PreallocationTools.get_tmp(f.S_TA, C)
    S_H = PreallocationTools.get_tmp(f.S_H, C)
    S_Age = PreallocationTools.get_tmp(f.S_Age, C)

    TMn = @view C[TMnID]
    TFe = @view C[TFeID]
    TNdnr = @view C[TNdnrID]
    TNdr = @view C[TNdrID]
    MnO2 = @view C[MnO2ID]
    FeOOH = @view C[FeOOHID]
    POC = @view C[POCID]
    FeS = @view C[FeSID]
    FeS2 = @view C[FeS2ID]
    CaCO3 = @view C[CaCO3ID]
    MnCO3 = @view C[MnCO3ID]
    FeCO3 = @view C[FeCO3ID]
    Age = @view C[AgeID]
    BSi = @view C[BSiID]
    Basalt = @view C[BasaltID]
    NdnrPO4 = @view C[NdnrPO4ID]
    NdrPO4 = @view C[NdrPO4ID]
    SurfMn_Ndnr = @view C[SurfMn_NdnrID]
    SurfMn_Ndr = @view C[SurfMn_NdrID]
    SurfFe_Ndnr = @view C[SurfFe_NdnrID]
    SurfFe_Ndr = @view C[SurfFe_NdrID]
    O2 = @view C[O2ID]
    NO3 = @view C[NO3ID]
    CH4 = @view C[CH4ID]
    NO2 = @view C[NO2ID]
    Ca = @view C[CaID]
    Al = @view C[AlID]
    SO4 = @view C[SO4ID]
    NH4 = @view C[NH4ID]
    TH4SiO4 = @view C[TH4SiO4ID]
    TH3PO4 = @view C[TH3PO4ID]
    TCO2 = @view C[TCO2ID]
    TH2S = @view C[TH2SID]
    TH3BO3 = @view C[TH3BO3ID]
    H = @view C[HID]

    dTMn = @view dC[TMnID]
    dTFe = @view dC[TFeID]
    dTNdnr = @view dC[TNdnrID]
    dTNdr = @view dC[TNdrID]
    dMnO2 = @view dC[MnO2ID]
    dFeOOH = @view dC[FeOOHID]
    dPOC = @view dC[POCID]
    dFeS = @view dC[FeSID]
    dFeS2 = @view dC[FeS2ID]
    dCaCO3 = @view dC[CaCO3ID]
    dMnCO3 = @view dC[MnCO3ID]
    dFeCO3 = @view dC[FeCO3ID]
    dAge = @view dC[AgeID]
    dBSi = @view dC[BSiID]
    dBasalt = @view dC[BasaltID]
    dNdnrPO4 = @view dC[NdnrPO4ID]
    dNdrPO4 = @view dC[NdrPO4ID]
    dSurfMn_Ndnr = @view dC[SurfMn_NdnrID]
    dSurfMn_Ndr = @view dC[SurfMn_NdrID]
    dSurfFe_Ndnr = @view dC[SurfFe_NdnrID]
    dSurfFe_Ndr = @view dC[SurfFe_NdrID]
    dO2 = @view dC[O2ID]
    dNO3 = @view dC[NO3ID]
    dCH4 = @view dC[CH4ID]
    dNO2 = @view dC[NO2ID]
    dCa = @view dC[CaID]
    dAl = @view dC[AlID]
    dSO4 = @view dC[SO4ID]
    dNH4 = @view dC[NH4ID]
    dTH4SiO4 = @view dC[TH4SiO4ID]
    dTH3PO4 = @view dC[TH3PO4ID]
    dTCO2 = @view dC[TCO2ID]
    dTH2S = @view dC[TH2SID]
    dTH3BO3 = @view dC[TH3BO3ID]
    dH = @view dC[HID]

    mul!(dMnO2, AmMnO2, MnO2)
    mul!(dFeOOH, AmFeOOH, FeOOH)
    mul!(dPOC, AmPOC, POC)
    mul!(dFeS, AmFeS, FeS)
    mul!(dFeS2, AmFeS2, FeS2)
    mul!(dCaCO3, AmCaCO3, CaCO3)
    mul!(dMnCO3, AmMnCO3, MnCO3)
    mul!(dFeCO3, AmFeCO3, FeCO3)
    mul!(dAge, AmAge, Age)
    mul!(dBSi, AmBSi, BSi)
    mul!(dBasalt, AmBasalt, Basalt)
    mul!(dNdnrPO4, AmNdnrPO4, NdnrPO4)
    mul!(dNdrPO4, AmNdrPO4, NdrPO4)
    mul!(dSurfMn_Ndnr, AmSurfMn_Ndnr, SurfMn_Ndnr)
    mul!(dSurfMn_Ndr, AmSurfMn_Ndr, SurfMn_Ndr)
    mul!(dSurfFe_Ndnr, AmSurfFe_Ndnr, SurfFe_Ndnr)
    mul!(dSurfFe_Ndr, AmSurfFe_Ndr, SurfFe_Ndr)
    mul!(dO2, AmO2, O2)
    mul!(dNO3, AmNO3, NO3)
    mul!(dCH4, AmCH4, CH4)
    mul!(dNO2, AmNO2, NO2)
    mul!(dCa, AmCa, Ca)
    mul!(dAl, AmAl, Al)
    mul!(dSO4, AmSO4, SO4)
    mul!(dTH4SiO4, AmTH4SiO4, TH4SiO4)
    mul!(dTH3PO4, AmTH3PO4, TH3PO4)

    dMnO2[1] += BcAmMnO2[1] ⊗ MnO2[1] ⊕ BcCmMnO2[1]
    dFeOOH[1] += BcAmFeOOH[1] ⊗ FeOOH[1] ⊕ BcCmFeOOH[1]
    dPOC[1] += BcAmPOC[1] ⊗ POC[1] ⊕ BcCmPOC[1]
    dFeS[1] += BcAmFeS[1] ⊗ FeS[1] ⊕ BcCmFeS[1]
    dFeS2[1] += BcAmFeS2[1] ⊗ FeS2[1] ⊕ BcCmFeS2[1]
    dCaCO3[1] += BcAmCaCO3[1] ⊗ CaCO3[1] ⊕ BcCmCaCO3[1]
    dMnCO3[1] += BcAmMnCO3[1] ⊗ MnCO3[1] ⊕ BcCmMnCO3[1]
    dFeCO3[1] += BcAmFeCO3[1] ⊗ FeCO3[1] ⊕ BcCmFeCO3[1]
    dAge[1] += BcAmAge[1] ⊗ Age[1] ⊕ BcCmAge[1]
    dBSi[1] += BcAmBSi[1] ⊗ BSi[1] ⊕ BcCmBSi[1]
    dBasalt[1] += BcAmBasalt[1] ⊗ Basalt[1] ⊕ BcCmBasalt[1]
    dNdnrPO4[1] += BcAmNdnrPO4[1] ⊗ NdnrPO4[1] ⊕ BcCmNdnrPO4[1]
    dNdrPO4[1] += BcAmNdrPO4[1] ⊗ NdrPO4[1] ⊕ BcCmNdrPO4[1]
    dSurfMn_Ndnr[1] += BcAmSurfMn_Ndnr[1] ⊗ SurfMn_Ndnr[1] ⊕ BcCmSurfMn_Ndnr[1]
    dSurfMn_Ndr[1] += BcAmSurfMn_Ndr[1] ⊗ SurfMn_Ndr[1] ⊕ BcCmSurfMn_Ndr[1]
    dSurfFe_Ndnr[1] += BcAmSurfFe_Ndnr[1] ⊗ SurfFe_Ndnr[1] ⊕ BcCmSurfFe_Ndnr[1]
    dSurfFe_Ndr[1] += BcAmSurfFe_Ndr[1] ⊗ SurfFe_Ndr[1] ⊕ BcCmSurfFe_Ndr[1]
    dO2[1] += BcAmO2[1] ⊗ O2[1] ⊕ BcCmO2[1]
    dNO3[1] += BcAmNO3[1] ⊗ NO3[1] ⊕ BcCmNO3[1]
    dCH4[1] += BcAmCH4[1] ⊗ CH4[1] ⊕ BcCmCH4[1]
    dNO2[1] += BcAmNO2[1] ⊗ NO2[1] ⊕ BcCmNO2[1]
    dCa[1] += BcAmCa[1] ⊗ Ca[1] ⊕ BcCmCa[1]
    dAl[1] += BcAmAl[1] ⊗ Al[1] ⊕ BcCmAl[1]
    dSO4[1] += BcAmSO4[1] ⊗ SO4[1] ⊕ BcCmSO4[1]
    dTH4SiO4[1] += BcAmTH4SiO4[1] ⊗ TH4SiO4[1] ⊕ BcCmTH4SiO4[1]
    dTH3PO4[1] += BcAmTH3PO4[1] ⊗ TH3PO4[1] ⊕ BcCmTH3PO4[1]
    dMnO2[Ngrid] += BcAmMnO2[2] ⊗ MnO2[Ngrid] ⊕ BcCmMnO2[2]
    dFeOOH[Ngrid] += BcAmFeOOH[2] ⊗ FeOOH[Ngrid] ⊕ BcCmFeOOH[2]
    dPOC[Ngrid] += BcAmPOC[2] ⊗ POC[Ngrid] ⊕ BcCmPOC[2]
    dFeS[Ngrid] += BcAmFeS[2] ⊗ FeS[Ngrid] ⊕ BcCmFeS[2]
    dFeS2[Ngrid] += BcAmFeS2[2] ⊗ FeS2[Ngrid] ⊕ BcCmFeS2[2]
    dCaCO3[Ngrid] += BcAmCaCO3[2] ⊗ CaCO3[Ngrid] ⊕ BcCmCaCO3[2]
    dMnCO3[Ngrid] += BcAmMnCO3[2] ⊗ MnCO3[Ngrid] ⊕ BcCmMnCO3[2]
    dFeCO3[Ngrid] += BcAmFeCO3[2] ⊗ FeCO3[Ngrid] ⊕ BcCmFeCO3[2]
    dAge[Ngrid] += BcAmAge[2] ⊗ Age[Ngrid] ⊕ BcCmAge[2]
    dBSi[Ngrid] += BcAmBSi[2] ⊗ BSi[Ngrid] ⊕ BcCmBSi[2]
    dBasalt[Ngrid] += BcAmBasalt[2] ⊗ Basalt[Ngrid] ⊕ BcCmBasalt[2]
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
    dO2[Ngrid] += BcAmO2[2] ⊗ O2[Ngrid] ⊕ BcCmO2[2]
    dNO3[Ngrid] += BcAmNO3[2] ⊗ NO3[Ngrid] ⊕ BcCmNO3[2]
    dCH4[Ngrid] += BcAmCH4[2] ⊗ CH4[Ngrid] ⊕ BcCmCH4[2]
    dNO2[Ngrid] += BcAmNO2[2] ⊗ NO2[Ngrid] ⊕ BcCmNO2[2]
    dCa[Ngrid] += BcAmCa[2] ⊗ Ca[Ngrid] ⊕ BcCmCa[2]
    dAl[Ngrid] += BcAmAl[2] ⊗ Al[Ngrid] ⊕ BcCmAl[2]
    dSO4[Ngrid] += BcAmSO4[2] ⊗ SO4[Ngrid] ⊕ BcCmSO4[2]
    dTH4SiO4[Ngrid] += BcAmTH4SiO4[2] ⊗ TH4SiO4[Ngrid] ⊕ BcCmTH4SiO4[2]
    dTH3PO4[Ngrid] += BcAmTH3PO4[2] ⊗ TH3PO4[Ngrid] ⊕ BcCmTH3PO4[2]

    @.. dO2 += alpha ⊗ (O2BW - O2)
    @.. dNO3 += alpha ⊗ (NO3BW - NO3)
    @.. dCH4 += alpha ⊗ (CH4BW - CH4)
    @.. dNO2 += alpha ⊗ (NO2BW - NO2)
    @.. dCa += alpha ⊗ (CaBW - Ca)
    @.. dAl += alpha ⊗ (AlBW - Al)
    @.. dSO4 += alpha ⊗ (SO4BW - SO4)
    @.. dTH4SiO4 += alpha ⊗ (TH4SiO4BW - TH4SiO4)
    @.. dTH3PO4 += alpha ⊗ (TH3PO4BW - TH3PO4)

    @.. Mn =
        TMn / (FeOOH ⊗ KMn_ads_Fe ⊗ dstopw ⊕ KMn_ads_Mn ⊗ MnO2 ⊗ dstopw ⊕ 1)
    mul!(Mn_tran, AmMn, Mn)
    Mn_tran[1] += BcAmMn[1] ⊗ Mn[1] ⊕ BcCmMn[1]
    Mn_tran[Ngrid] += BcAmMn[2] ⊗ Mn[Ngrid] ⊕ BcCmMn[2]
    @.. Mn_ads_Mn = KMn_ads_Mn ⊗ MnO2 ⊗ Mn
    mul!(Mn_ads_Mn_tran, AmMn_ads_Mn, Mn_ads_Mn)
    Mn_ads_Mn_tran[1] += BcAmMn_ads_Mn[1] ⊗ Mn_ads_Mn[1] ⊕ BcCmMn_ads_Mn[1]
    Mn_ads_Mn_tran[Ngrid] +=
        BcAmMn_ads_Mn[2] ⊗ Mn_ads_Mn[Ngrid] ⊕ BcCmMn_ads_Mn[2]
    @.. Mn_ads_Fe = KMn_ads_Fe ⊗ FeOOH ⊗ Mn
    mul!(Mn_ads_Fe_tran, AmMn_ads_Fe, Mn_ads_Fe)
    Mn_ads_Fe_tran[1] += BcAmMn_ads_Fe[1] ⊗ Mn_ads_Fe[1] ⊕ BcCmMn_ads_Fe[1]
    Mn_ads_Fe_tran[Ngrid] +=
        BcAmMn_ads_Fe[2] ⊗ Mn_ads_Fe[Ngrid] ⊕ BcCmMn_ads_Fe[2]
    @.. dTMn = Mn_tran ⊗ 1 ⊕ Mn_ads_Mn_tran ⊗ dstopw ⊕ Mn_ads_Fe_tran ⊗ dstopw
    @.. dTMn += alpha ⊗ (Mn0 - Mn)

    @.. Fe =
        TFe / (FeOOH ⊗ KFe_ads_Fe ⊗ dstopw ⊕ KFe_ads_Mn ⊗ MnO2 ⊗ dstopw ⊕ 1)
    mul!(Fe_tran, AmFe, Fe)
    Fe_tran[1] += BcAmFe[1] ⊗ Fe[1] ⊕ BcCmFe[1]
    Fe_tran[Ngrid] += BcAmFe[2] ⊗ Fe[Ngrid] ⊕ BcCmFe[2]
    @.. Fe_ads_Mn = KFe_ads_Mn ⊗ MnO2 ⊗ Fe
    mul!(Fe_ads_Mn_tran, AmFe_ads_Mn, Fe_ads_Mn)
    Fe_ads_Mn_tran[1] += BcAmFe_ads_Mn[1] ⊗ Fe_ads_Mn[1] ⊕ BcCmFe_ads_Mn[1]
    Fe_ads_Mn_tran[Ngrid] +=
        BcAmFe_ads_Mn[2] ⊗ Fe_ads_Mn[Ngrid] ⊕ BcCmFe_ads_Mn[2]
    @.. Fe_ads_Fe = KFe_ads_Fe ⊗ FeOOH ⊗ Fe
    mul!(Fe_ads_Fe_tran, AmFe_ads_Fe, Fe_ads_Fe)
    Fe_ads_Fe_tran[1] += BcAmFe_ads_Fe[1] ⊗ Fe_ads_Fe[1] ⊕ BcCmFe_ads_Fe[1]
    Fe_ads_Fe_tran[Ngrid] +=
        BcAmFe_ads_Fe[2] ⊗ Fe_ads_Fe[Ngrid] ⊕ BcCmFe_ads_Fe[2]
    @.. dTFe = Fe_tran ⊗ 1 ⊕ Fe_ads_Mn_tran ⊗ dstopw ⊕ Fe_ads_Fe_tran ⊗ dstopw
    @.. dTFe += alpha ⊗ (Fe0 - Fe)

    @.. Ndnr =
        TNdnr / (FeOOH ⊗ KNd_ads_Fe ⊗ dstopw ⊕ KNd_ads_Mn ⊗ MnO2 ⊗ dstopw ⊕ 1)
    mul!(Ndnr_tran, AmNdnr, Ndnr)
    Ndnr_tran[1] += BcAmNdnr[1] ⊗ Ndnr[1] ⊕ BcCmNdnr[1]
    Ndnr_tran[Ngrid] += BcAmNdnr[2] ⊗ Ndnr[Ngrid] ⊕ BcCmNdnr[2]
    @.. Ndnr_ads_Mn = KNd_ads_Mn ⊗ Ndnr ⊗ MnO2
    mul!(Ndnr_ads_Mn_tran, AmNdnr_ads_Mn, Ndnr_ads_Mn)
    Ndnr_ads_Mn_tran[1] +=
        BcAmNdnr_ads_Mn[1] ⊗ Ndnr_ads_Mn[1] ⊕ BcCmNdnr_ads_Mn[1]
    Ndnr_ads_Mn_tran[Ngrid] +=
        BcAmNdnr_ads_Mn[2] ⊗ Ndnr_ads_Mn[Ngrid] ⊕ BcCmNdnr_ads_Mn[2]
    @.. Ndnr_ads_Fe = KNd_ads_Fe ⊗ Ndnr ⊗ FeOOH
    mul!(Ndnr_ads_Fe_tran, AmNdnr_ads_Fe, Ndnr_ads_Fe)
    Ndnr_ads_Fe_tran[1] +=
        BcAmNdnr_ads_Fe[1] ⊗ Ndnr_ads_Fe[1] ⊕ BcCmNdnr_ads_Fe[1]
    Ndnr_ads_Fe_tran[Ngrid] +=
        BcAmNdnr_ads_Fe[2] ⊗ Ndnr_ads_Fe[Ngrid] ⊕ BcCmNdnr_ads_Fe[2]
    @.. dTNdnr =
        Ndnr_tran ⊗ 1 ⊕ Ndnr_ads_Mn_tran ⊗ dstopw ⊕ Ndnr_ads_Fe_tran ⊗ dstopw
    @.. dTNdnr += alpha ⊗ (Ndnr0 - Ndnr)

    @.. Ndr =
        TNdr / (FeOOH ⊗ KNd_ads_Fe ⊗ dstopw ⊕ KNd_ads_Mn ⊗ MnO2 ⊗ dstopw ⊕ 1)
    mul!(Ndr_tran, AmNdr, Ndr)
    Ndr_tran[1] += BcAmNdr[1] ⊗ Ndr[1] ⊕ BcCmNdr[1]
    Ndr_tran[Ngrid] += BcAmNdr[2] ⊗ Ndr[Ngrid] ⊕ BcCmNdr[2]
    @.. Ndr_ads_Mn = KNd_ads_Mn ⊗ Ndr ⊗ MnO2
    mul!(Ndr_ads_Mn_tran, AmNdr_ads_Mn, Ndr_ads_Mn)
    Ndr_ads_Mn_tran[1] += BcAmNdr_ads_Mn[1] ⊗ Ndr_ads_Mn[1] ⊕ BcCmNdr_ads_Mn[1]
    Ndr_ads_Mn_tran[Ngrid] +=
        BcAmNdr_ads_Mn[2] ⊗ Ndr_ads_Mn[Ngrid] ⊕ BcCmNdr_ads_Mn[2]
    @.. Ndr_ads_Fe = KNd_ads_Fe ⊗ Ndr ⊗ FeOOH
    mul!(Ndr_ads_Fe_tran, AmNdr_ads_Fe, Ndr_ads_Fe)
    Ndr_ads_Fe_tran[1] += BcAmNdr_ads_Fe[1] ⊗ Ndr_ads_Fe[1] ⊕ BcCmNdr_ads_Fe[1]
    Ndr_ads_Fe_tran[Ngrid] +=
        BcAmNdr_ads_Fe[2] ⊗ Ndr_ads_Fe[Ngrid] ⊕ BcCmNdr_ads_Fe[2]
    @.. dTNdr =
        Ndr_tran ⊗ 1 ⊕ Ndr_ads_Mn_tran ⊗ dstopw ⊕ Ndr_ads_Fe_tran ⊗ dstopw
    @.. dTNdr += alpha ⊗ (Ndr0 - Ndr)

    @.. NH4_ads = NH4 ⊗ KNH4_ads
    mul!(dNH4, AmNH4_ads, NH4_ads)
    @.. dNH4 *= dstopw
    mul!(dNH4, AmNH4, NH4, 1.0, 1.0)
    dNH4[1] += (BcAmNH4_ads[1] ⊗ NH4_ads[1] ⊕ BcCmNH4_ads[1]) ⊗ dstopw[1]
    dNH4[1] += BcAmNH4[1] ⊗ NH4[1] ⊕ BcCmNH4[1]
    dNH4[Ngrid] +=
        (BcAmNH4_ads[2] ⊗ NH4_ads[Ngrid] ⊕ BcCmNH4_ads[2]) ⊗ dstopw[Ngrid]
    dNH4[Ngrid] += BcAmNH4[2] ⊗ NH4[Ngrid] ⊕ BcCmNH4[2]
    @.. dNH4 += alpha ⊗ (NH40 - NH4)
    @.. dNH4 *= 1 / (1 ⊕ dstopw ⊗ KNH4_ads)


    @.. HCO3 = H ⊗ KCO2 ⊗ TCO2 / (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)
    @.. CO3 = KCO2 ⊗ KHCO3 ⊗ TCO2 / (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)
    @.. CO2 = H^2 ⊗ TCO2 / (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)
    @.. H2S = H ⊗ TH2S / (H ⊕ KH2S)
    @.. HS = KH2S ⊗ TH2S / (H ⊕ KH2S)
    @.. H3BO3 = H ⊗ TH3BO3 / (H ⊕ KH3BO3)
    @.. H4BO4 = KH3BO3 ⊗ TH3BO3 / (H ⊕ KH3BO3)
    @.. OH = KH2O / H

    @.. dTA_dTCO2 = KCO2 ⊗ (H ⊕ 2 ⊗ KHCO3) / (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)
    @.. dTA_dTH2S = KH2S / (H ⊕ KH2S)
    @.. dTA_dTH3BO3 = KH3BO3 / (H ⊕ KH3BO3)

    @.. dTA_dH =
        -KCO2 ⊗ TCO2 ⊗ (H^2 ⊕ 4 ⊗ H ⊗ KHCO3 ⊕ KCO2 ⊗ KHCO3) /
        (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)^2
    @.. dTA_dH += -KH2S ⊗ TH2S / (H ⊕ KH2S)^2
    @.. dTA_dH += -KH3BO3 ⊗ TH3BO3 / (H ⊕ KH3BO3)^2
    @.. dTA_dH += -(H^2 ⊕ KH2O) / H^2

    @.. H4SiO4 = H ⊗ TH4SiO4 / (H ⊕ KH4SiO4)
    @.. H3SiO4 = KH4SiO4 ⊗ TH4SiO4 / (H ⊕ KH4SiO4)
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

    mul!(H_tran, AmH, H)
    H_tran[1] += BcAmH[1] ⊗ H[1] ⊕ BcCmH[1]
    H_tran[Ngrid] += BcAmH[2] ⊗ H[Ngrid] ⊕ BcCmH[2]
    @.. H_tran += alpha ⊗ (HBW - H)

    mul!(OH_tran, AmOH, OH)
    OH_tran[1] += BcAmOH[1] ⊗ OH[1] ⊕ BcCmOH[1]
    OH_tran[Ngrid] += BcAmOH[2] ⊗ OH[Ngrid] ⊕ BcCmOH[2]
    @.. OH_tran += alpha ⊗ (OHBW - OH)


    @.. dTCO2 = HCO3_tran ⊕ CO3_tran ⊕ CO2_tran
    @.. dTH2S = H2S_tran ⊕ HS_tran
    @.. dTH3BO3 = H3BO3_tran ⊕ H4BO4_tran

    @.. TA_tran = 1 ⊗ HCO3_tran ⊕ 2 ⊗ CO3_tran ⊕ 0 ⊗ CO2_tran
    @.. TA_tran += 0 ⊗ H2S_tran ⊕ 1 ⊗ HS_tran
    @.. TA_tran += 0 ⊗ H3BO3_tran ⊕ 1 ⊗ H4BO4_tran
    @.. TA_tran += -1 ⊗ H_tran ⊕ 1 ⊗ OH_tran

    @.. dH = TA_tran
    @.. dH -= dTCO2 ⊗ dTA_dTCO2
    @.. dH -= dTH2S ⊗ dTA_dTH2S
    @.. dH -= dTH3BO3 ⊗ dTA_dTH3BO3
    @.. dH = dH / dTA_dH
    # speciation
    @.. Fe_free =
        Fe ⊗ H / (
            H ⊗ (
                41423.3356559411 ⊗ CO3^2 ⊕ 965.581207896004 ⊗ CO3 ⊕
                0.5471766470303 ⊗ Cl ⊕ 3.80379832102204 ⊗ HCO3 ⊕
                478943.184139625 ⊗ OH^2 ⊕ 4760.8482990692 ⊗ OH ⊕
                6.54884648049946 ⊗ SO4
            ) ⊕ H ⊕ 0.00150222599838656 ⊗ HS
        )
    @.. Al_free =
        Al / (
            2043875.64835082 ⊗ CO3 ⊕ 5.53585106798541e+42 ⊗ OH^4 ⊕
            1.58901384036693e+33 ⊗ OH^3 ⊕ 9.58706888366951e+21 ⊗ OH^2 ⊕
            24217393210.2891 ⊗ OH ⊕ 1
        )
    @.. Ndnr_free =
        H ⊗ Ndnr / (
            H ⊗ (
                3632465961.77468 ⊗ CO3^2 ⊕ 290431.690955537 ⊗ CO3 ⊕
                0.343269152592752 ⊗ Cl ⊕ 63095734448.0194 ⊗ H3SiO4^2 ⊕
                158489.319246111 ⊗ H3SiO4 ⊕ 7.38572662109916 ⊗ HCO3 ⊕
                56.0142660345257 ⊗ SO4
            ) ⊕ H ⊕ 9.62959782270152e-10
        )
    @.. Ndr_free =
        H ⊗ Ndr / (
            H ⊗ (
                3632465961.77468 ⊗ CO3^2 ⊕ 290431.690955537 ⊗ CO3 ⊕
                0.343269152592752 ⊗ Cl ⊕ 63095734448.0194 ⊗ H3SiO4^2 ⊕
                158489.319246111 ⊗ H3SiO4 ⊕ 7.38572662109917 ⊗ HCO3 ⊕
                56.0142660345257 ⊗ SO4
            ) ⊕ H ⊕ 9.62959782270152e-10
        )
    @.. Mn_free =
        Mn / (
            42.0329746291717 ⊗ CO3 ⊕ 0.585293386440227 ⊗ Cl ⊕
            2.23595750479834 ⊗ HCO3 ⊕ 6200.51874700166 ⊗ OH^2 ⊕
            240.002069606654 ⊗ OH ⊕ 6.84558981272481 ⊗ SO4 ⊕ 1
        )

    # reaction rates
    @.. Omega_RFeS_dis = Fe_free ⊗ HS / (H ⊗ KspFeS)
    @.. Omega_RFeS_pre = Fe_free ⊗ HS / (H ⊗ KspFeS)
    @.. Omega_RCaCO3_dis = Ca ⊗ CO3 / KspCaCO3_dis
    @.. Omega_RCaCO3_pre = Ca ⊗ CO3 / KspCaCO3_pre
    @.. Omega_RMnCO3_dis = Mn_free ⊗ CO3 / KspMnCO3
    @.. Omega_RMnCO3_pre = Mn_free ⊗ CO3 / KspMnCO3
    @.. Omega_RFeCO3_dis = Fe_free ⊗ CO3 / KspFeCO3
    @.. Omega_RFeCO3_pre = Fe_free ⊗ CO3 / KspFeCO3
    @.. Omega_RBSi_dis = H4SiO4 / H4SiO4_dis_sat
    @.. Omega_RBasalt_dis = H4SiO4 ⊗ Al_free^0.35 / H^1.05 / KspBasalt
    @.. Omega_RNdnrPO4_pre =
        Ndnr_free ⊗ PO4 / (KspNdPO4 ⊗ NdnrPO4 / (NdnrPO4 ⊕ NdrPO4))
    @.. Omega_RNdrPO4_pre =
        Ndr_free ⊗ PO4 / (KspNdPO4 ⊗ NdrPO4 / (NdnrPO4 ⊕ NdrPO4))
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
    @.. RO2NH4 = kO2NH4 ⊗ O2 ⊗ NH4
    @.. RO2Mn = kO2Mn ⊗ O2 ⊗ Mn
    @.. RO2Mn_ads = kO2Mn_ads ⊗ O2 ⊗ (Mn_ads_Mn ⊕ Mn_ads_Fe) ⊗ dstopw
    @.. RO2Fe = kO2Fe ⊗ O2 ⊗ Fe
    @.. RO2Fe_ads = kO2Fe_ads ⊗ O2 ⊗ (Fe_ads_Mn ⊕ Fe_ads_Fe) ⊗ dstopw
    @.. RO2H2S = kO2H2S ⊗ O2 ⊗ TH2S
    @.. RO2FeS = kO2FeS ⊗ O2 ⊗ FeS
    @.. RO2CH4 = kO2CH4 ⊗ O2 ⊗ CH4
    @.. RNO2NH4 = kNO2NH4 ⊗ NO2 ⊗ NH4
    @.. RNO3Mn = kNO3Mn ⊗ NO3 ⊗ Mn
    @.. RNO3Fe = kNO3Fe ⊗ NO3 ⊗ Fe
    @.. RNO3H2S = kNO3H2S ⊗ NO3 ⊗ TH2S
    @.. RSO4CH4 = kAOM ⊗ CH4 ⊗ SO4 / (SO4 ⊕ KAOM)
    @.. RMnO2Fe = kMnO2Fe ⊗ MnO2 ⊗ Fe
    @.. RMnO2H2S = kMnO2H2S ⊗ MnO2 ⊗ TH2S
    @.. RFeOOHH2S = kFeOOHH2S ⊗ FeOOH ⊗ TH2S
    @.. RFeSH2S = kFeSH2S ⊗ FeS ⊗ TH2S
    @.. RFeS_dis =
        (-tanh(100.0 ⊗ (Omega_RFeS_dis - 1.0)) / 2 ⊕ 0.5) ⊗
        (kFeSdis ⊗ FeS ⊗ (1 - Omega_RFeS_dis))
    @.. RFeS_pre =
        (tanh(100.0 ⊗ (Omega_RFeS_pre - 1.0)) / 2 ⊕ 0.5) ⊗
        (kFeSpre ⊗ Fe ⊗ TH2S ⊗ (Omega_RFeS_pre - 1))
    @.. RCaCO3_dis =
        (-tanh(100.0 ⊗ (Omega_RCaCO3_dis - 1.0)) / 2 ⊕ 0.5) ⊗ (
            kCaCO3dis0 ⊗ CaCO3 ⊕
            kCaCO3dis1 ⊗ CaCO3 ⊗ (1 - Omega_RCaCO3_dis)^nCaCO3dis
        )
    @.. RCaCO3_pre =
        (tanh(100.0 ⊗ (Omega_RCaCO3_pre - 1.0)) / 2 ⊕ 0.5) ⊗
        (kCaCO3pre ⊗ CaCO3 ⊗ (Omega_RCaCO3_pre - 1))
    @.. RMnCO3_dis =
        (-tanh(100.0 ⊗ (Omega_RMnCO3_dis - 1.0)) / 2 ⊕ 0.5) ⊗
        (kMnCO3dis ⊗ MnCO3 ⊗ (1 - Omega_RMnCO3_dis))
    @.. RMnCO3_pre =
        (tanh(100.0 ⊗ (Omega_RMnCO3_pre - 1.0)) / 2 ⊕ 0.5) ⊗
        (kMnCO3pre ⊗ (Omega_RMnCO3_pre - 1))
    @.. RFeCO3_dis =
        (-tanh(100.0 ⊗ (Omega_RFeCO3_dis - 1.0)) / 2 ⊕ 0.5) ⊗
        (kFeCO3dis ⊗ FeCO3 ⊗ (1 - Omega_RFeCO3_dis))
    @.. RFeCO3_pre =
        (tanh(100.0 ⊗ (Omega_RFeCO3_pre - 1.0)) / 2 ⊕ 0.5) ⊗
        (kFeCO3pre ⊗ (Omega_RFeCO3_pre - 1))
    @.. RBSi_dis =
        (-tanh(100.0 ⊗ (Omega_RBSi_dis - 1.0)) / 2 ⊕ 0.5) ⊗
        ((1 - Omega_RBSi_dis) ⊗ BSi ⊗ kBSi_dis)
    @.. RBasalt_dis =
        (-tanh(100.0 ⊗ (Omega_RBasalt_dis - 1.0)) / 2 ⊕ 0.5) ⊗ (
            kBasalt ⊗ Basalt ⊗ H / (Al_free)^(1 / 3) ⊗ (1 - Omega_RBasalt_dis) /
            (aBasalt ⊕ Age)^pBasalt
        )
    @.. RBasalt_dis_Nd = RBasalt_dis
    @.. RNdnrPO4_pre =
        (tanh(100.0 ⊗ (Omega_RNdnrPO4_pre - 1.0)) / 2 ⊕ 0.5) ⊗
        (kNdPO4_pre ⊗ NdnrPO4 / (NdnrPO4 ⊕ NdrPO4) ⊗ (Omega_RNdnrPO4_pre - 1))
    @.. RNdrPO4_pre =
        (tanh(100.0 ⊗ (Omega_RNdrPO4_pre - 1.0)) / 2 ⊕ 0.5) ⊗
        (kNdPO4_pre ⊗ NdrPO4 / (NdnrPO4 ⊕ NdrPO4) ⊗ (Omega_RNdrPO4_pre - 1))
    @.. RMnRe_Ndnr = (RMnO2POC ⊗ 2 ⊕ RMnO2H2S ⊕ RMnO2Fe) ⊗ SurfMn_Ndnr / MnO2
    @.. RMnRe_Ndr = (RMnO2POC ⊗ 2 ⊕ RMnO2H2S ⊕ RMnO2Fe) ⊗ SurfMn_Ndr / MnO2
    @.. RMnOx_Ndnr =
        (RO2Mn ⊕ RO2Mn_ads ⊗ dstopw ⊕ RNO3Mn) ⊗ Ndnr / Mn ⊗ DNdMn_sed
    @.. RMnOx_Ndr = (RO2Mn ⊕ RO2Mn_ads ⊗ dstopw ⊕ RNO3Mn) ⊗ Ndr / Mn ⊗ DNdMn_sed
    @.. RFeRe_Ndnr = (RFeOOHPOC ⊕ RFeOOHH2S) ⊗ SurfFe_Ndnr / FeOOH
    @.. RFeRe_Ndr = (RFeOOHPOC ⊕ RFeOOHH2S) ⊗ SurfFe_Ndr / FeOOH
    @.. RFeOx_Ndnr =
        (RO2Fe ⊕ RO2Fe_ads ⊗ dstopw ⊕ RNO3Fe ⊕ RMnO2Fe ⊗ dstopw) ⊗ Ndnr / Fe ⊗
        DNdFe_sed
    @.. RFeOx_Ndr =
        (RO2Fe ⊕ RO2Fe_ads ⊗ dstopw ⊕ RNO3Fe ⊕ RMnO2Fe ⊗ dstopw) ⊗ Ndr / Fe ⊗
        DNdFe_sed

    # species rates
    @.. S_POC =
        -1 ⊗ RO2POC ⊕ -1 ⊗ RNO2POC ⊕ -1 ⊗ RNO3POC ⊕ -1 ⊗ RMnO2POC ⊕
        -1 ⊗ RFeOOHPOC ⊕ -1 ⊗ RSO4POC ⊕ -1 ⊗ RCH4POC
    @.. S_O2 =
        -1 ⊗ RO2POC ⊗ dstopw ⊕ -1 / 2 ⊗ RO2NO2 ⊕ -3 / 2 ⊗ RO2NH4 ⊕
        -1 / 2 ⊗ RO2Mn ⊕ -1 / 2 ⊗ RO2Mn_ads ⊕ -1 / 4 ⊗ RO2Fe ⊕
        -1 / 4 ⊗ RO2Fe_ads ⊕ -2 ⊗ RO2H2S ⊕ -9 / 4 ⊗ RO2FeS ⊗ dstopw ⊕
        -2 ⊗ RO2CH4
    @.. S_TCO2 =
        1 ⊗ RO2POC ⊗ dstopw ⊕ 1 ⊗ RNO2POC ⊗ dstopw ⊕ 1 ⊗ RNO3POC ⊗ dstopw ⊕
        1 ⊗ RMnO2POC ⊗ dstopw ⊕ 1 ⊗ RFeOOHPOC ⊗ dstopw ⊕ 1 ⊗ RSO4POC ⊗ dstopw ⊕
        1 / 2 ⊗ RCH4POC ⊗ dstopw ⊕ 1 ⊗ RO2CH4 ⊕ 1 ⊗ RSO4CH4 ⊕
        1 ⊗ RCaCO3_dis ⊗ dstopw ⊕ -1 ⊗ RCaCO3_pre ⊗ dstopw ⊕
        1 ⊗ RMnCO3_dis ⊗ dstopw ⊕ -1 ⊗ RMnCO3_pre ⊗ dstopw ⊕
        1 ⊗ RFeCO3_dis ⊗ dstopw ⊕ -1 ⊗ RFeCO3_pre ⊗ dstopw
    @.. S_NH4 =
        rNC ⊗ RO2POC / (pwtods ⊕ KNH4_ads) ⊕
        rNC ⊗ RNO2POC / (pwtods ⊕ KNH4_ads) ⊕
        rNC ⊗ RNO3POC / (pwtods ⊕ KNH4_ads) ⊕
        rNC ⊗ RMnO2POC / (pwtods ⊕ KNH4_ads) ⊕
        rNC ⊗ RFeOOHPOC / (pwtods ⊕ KNH4_ads) ⊕
        rNC ⊗ RSO4POC / (pwtods ⊕ KNH4_ads) ⊕
        rNC ⊗ RCH4POC / (pwtods ⊕ KNH4_ads) ⊕
        -1 ⊗ RO2NH4 / (1 ⊕ dstopw ⊗ KNH4_ads) ⊕
        -1 ⊗ RNO2NH4 / (1 ⊕ dstopw ⊗ KNH4_ads) ⊕
        1 ⊗ RNO3H2S / (1 ⊕ dstopw ⊗ KNH4_ads)
    @.. S_TH3PO4 =
        rPC ⊗ RO2POC ⊗ dstopw ⊕ rPC ⊗ RNO2POC ⊗ dstopw ⊕
        rPC ⊗ RNO3POC ⊗ dstopw ⊕ rPC ⊗ RMnO2POC ⊗ dstopw ⊕
        rPC ⊗ RFeOOHPOC ⊗ dstopw ⊕ rPC ⊗ RSO4POC ⊗ dstopw ⊕
        rPC ⊗ RCH4POC ⊗ dstopw ⊕ -1 ⊗ RNdnrPO4_pre ⊕ -1 ⊗ RNdrPO4_pre
    @.. S_NO2 =
        -4 / 3 ⊗ RNO2POC ⊗ dstopw ⊕ 2 ⊗ RNO3POC ⊗ dstopw ⊕ -1 ⊗ RO2NO2 ⊕
        1 ⊗ RO2NH4 ⊕ -1 ⊗ RNO2NH4
    @.. S_NO3 =
        -2 ⊗ RNO3POC ⊗ dstopw ⊕ 1 ⊗ RO2NO2 ⊕ -2 / 5 ⊗ RNO3Mn ⊕ -1 / 5 ⊗ RNO3Fe ⊕
        -1 ⊗ RNO3H2S
    @.. S_MnO2 =
        -2 ⊗ RMnO2POC ⊕ 1 ⊗ RO2Mn ⊗ pwtods ⊕ 1 ⊗ RO2Mn_ads ⊗ pwtods ⊕
        1 ⊗ RNO3Mn ⊗ pwtods ⊕ -1 / 2 ⊗ RMnO2Fe ⊕ -1 ⊗ RMnO2H2S
    @.. S_TMn =
        2 ⊗ RMnO2POC ⊗ dstopw ⊕ -1 ⊗ RO2Mn ⊕ -1 ⊗ RO2Mn_ads ⊕ -1 ⊗ RNO3Mn ⊕
        1 / 2 ⊗ RMnO2Fe ⊗ dstopw ⊕ 1 ⊗ RMnO2H2S ⊗ dstopw ⊕
        1 ⊗ RMnCO3_dis ⊗ dstopw ⊕ -1 ⊗ RMnCO3_pre ⊗ dstopw
    @.. S_FeOOH =
        -4 ⊗ RFeOOHPOC ⊕ 1 ⊗ RO2Fe ⊗ pwtods ⊕ 1 ⊗ RO2Fe_ads ⊗ pwtods ⊕
        1 ⊗ RO2FeS ⊕ 1 ⊗ RNO3Fe ⊗ pwtods ⊕ 1 ⊗ RMnO2Fe ⊕ -2 ⊗ RFeOOHH2S
    @.. S_TFe =
        4 ⊗ RFeOOHPOC ⊗ dstopw ⊕ -1 ⊗ RO2Fe ⊕ -1 ⊗ RO2Fe_ads ⊕ -1 ⊗ RNO3Fe ⊕
        -1 ⊗ RMnO2Fe ⊗ dstopw ⊕ 2 ⊗ RFeOOHH2S ⊗ dstopw ⊕ 1 ⊗ RFeS_dis ⊗ dstopw ⊕
        -1 ⊗ RFeS_pre ⊕ 1 ⊗ RFeCO3_dis ⊗ dstopw ⊕ -1 ⊗ RFeCO3_pre ⊗ dstopw
    @.. S_SO4 =
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
    @.. S_CaCO3 = -1 ⊗ RCaCO3_dis ⊕ 1 ⊗ RCaCO3_pre
    @.. S_Ca = 1 ⊗ RCaCO3_dis ⊗ dstopw ⊕ -1 ⊗ RCaCO3_pre ⊗ dstopw
    @.. S_MnCO3 = -1 ⊗ RMnCO3_dis ⊕ 1 ⊗ RMnCO3_pre
    @.. S_FeCO3 = -1 ⊗ RFeCO3_dis ⊕ 1 ⊗ RFeCO3_pre
    @.. S_BSi = -1 ⊗ RBSi_dis
    @.. S_TH4SiO4 = 1 ⊗ RBSi_dis ⊗ dstopw ⊕ 1 ⊗ RBasalt_dis ⊗ dstopw
    @.. S_Basalt = -1 ⊗ RBasalt_dis
    @.. S_Al = 0.35 ⊗ RBasalt_dis ⊗ dstopw
    @.. S_TNdnr =
        rNdnrSi ⊗ RBasalt_dis_Nd ⊕ -1 ⊗ RNdnrPO4_pre ⊕ 1 ⊗ RMnRe_Ndnr ⊗ dstopw ⊕
        -1 ⊗ RMnOx_Ndnr ⊕ 1 ⊗ RFeRe_Ndnr ⊗ dstopw ⊕ -1 ⊗ RFeOx_Ndnr
    @.. S_TNdr =
        rNdrSi ⊗ RBasalt_dis_Nd ⊕ -1 ⊗ RNdrPO4_pre ⊕ 1 ⊗ RMnRe_Ndr ⊗ dstopw ⊕
        -1 ⊗ RMnOx_Ndr ⊕ 1 ⊗ RFeRe_Ndr ⊗ dstopw ⊕ -1 ⊗ RFeOx_Ndr
    @.. S_NdnrPO4 = 1 ⊗ RNdnrPO4_pre ⊗ pwtods
    @.. S_NdrPO4 = 1 ⊗ RNdrPO4_pre ⊗ pwtods
    @.. S_SurfMn_Ndnr = -1 ⊗ RMnRe_Ndnr ⊕ 1 ⊗ RMnOx_Ndnr ⊗ pwtods
    @.. S_SurfMn_Ndr = -1 ⊗ RMnRe_Ndr ⊕ 1 ⊗ RMnOx_Ndr ⊗ pwtods
    @.. S_SurfFe_Ndnr = -1 ⊗ RFeRe_Ndnr ⊕ 1 ⊗ RFeOx_Ndnr ⊗ pwtods
    @.. S_SurfFe_Ndr = -1 ⊗ RFeRe_Ndr ⊕ 1 ⊗ RFeOx_Ndr ⊗ pwtods
    @.. S_TA =
        (rNC - rPC) ⊗ RO2POC ⊗ dstopw ⊕ (rNC - rPC ⊕ 4 / 3) ⊗ RNO2POC ⊗ dstopw ⊕
        (rNC - rPC) ⊗ RNO3POC ⊗ dstopw ⊕ (rNC - rPC ⊕ 4) ⊗ RMnO2POC ⊗ dstopw ⊕
        (rNC - rPC ⊕ 8) ⊗ RFeOOHPOC ⊗ dstopw ⊕
        (rNC - rPC ⊕ 1) ⊗ RSO4POC ⊗ dstopw ⊕ (rNC - rPC) ⊗ RCH4POC ⊗ dstopw ⊕
        -2 ⊗ RO2NH4 ⊕ -2 ⊗ RO2Mn ⊕ -2 ⊗ RO2Mn_ads ⊕ -2 ⊗ RO2Fe ⊕
        -2 ⊗ RO2Fe_ads ⊕ -2 ⊗ RO2H2S ⊕ -2 ⊗ RO2FeS ⊗ dstopw ⊕ -8 / 5 ⊗ RNO3Mn ⊕
        -9 / 5 ⊗ RNO3Fe ⊕ 2 ⊗ RSO4CH4 ⊕ -1 ⊗ RMnO2Fe ⊗ dstopw ⊕
        2 ⊗ RMnO2H2S ⊗ dstopw ⊕ 4 ⊗ RFeOOHH2S ⊗ dstopw ⊕ 1 ⊗ RFeS_dis ⊗ dstopw ⊕
        -1 ⊗ RFeS_pre ⊕ 21 / 20 ⊗ RBasalt_dis ⊗ dstopw
    @.. S_TA +=
        2 ⊗ RCaCO3_dis ⊗ dstopw ⊕ -2 ⊗ RCaCO3_pre ⊗ dstopw ⊕
        2 ⊗ RMnCO3_dis ⊗ dstopw ⊕ -2 ⊗ RMnCO3_pre ⊗ dstopw ⊕
        2 ⊗ RFeCO3_dis ⊗ dstopw ⊕ -2 ⊗ RFeCO3_pre ⊗ dstopw
    @.. S_TA += 1 ⊗ RFeS_dis ⊗ dstopw ⊕ -1 ⊗ RFeS_pre
    @.. S_H = S_TA
    @.. S_H -= S_TCO2 ⊗ dTA_dTCO2
    @.. S_H -= S_TH2S ⊗ dTA_dTH2S
    @.. S_H = S_H / dTA_dH
    @.. S_Age = 1

    @.. dTMn += S_TMn
    @.. dTFe += S_TFe
    @.. dTNdnr += S_TNdnr
    @.. dTNdr += S_TNdr
    @.. dMnO2 += S_MnO2
    @.. dFeOOH += S_FeOOH
    @.. dPOC += S_POC
    @.. dFeS += S_FeS
    @.. dFeS2 += S_FeS2
    @.. dCaCO3 += S_CaCO3
    @.. dMnCO3 += S_MnCO3
    @.. dFeCO3 += S_FeCO3
    @.. dAge += S_Age
    @.. dBSi += S_BSi
    @.. dBasalt += S_Basalt
    @.. dNdnrPO4 += S_NdnrPO4
    @.. dNdrPO4 += S_NdrPO4
    @.. dSurfMn_Ndnr += S_SurfMn_Ndnr
    @.. dSurfMn_Ndr += S_SurfMn_Ndr
    @.. dSurfFe_Ndnr += S_SurfFe_Ndnr
    @.. dSurfFe_Ndr += S_SurfFe_Ndr
    @.. dO2 += S_O2
    @.. dNO3 += S_NO3
    @.. dCH4 += S_CH4
    @.. dNO2 += S_NO2
    @.. dCa += S_Ca
    @.. dAl += S_Al
    @.. dSO4 += S_SO4
    @.. dNH4 += S_NH4
    @.. dTH4SiO4 += S_TH4SiO4
    @.. dTH3PO4 += S_TH3PO4
    @.. dTCO2 += S_TCO2
    @.. dTH2S += S_TH2S
    @.. dH += S_H

    return nothing
end
