module Cache
using PreallocationTools, ForwardDiff
struct Reactran{T}
    TMn_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Mn_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Mn_ads_Mn::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Mn_ads_Fe::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TMn_ads_MnO2::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TMn_ads_FeOOH::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TMn_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TFe_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Fe_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Fe_ads_Mn::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Fe_ads_Fe::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TFe_ads_MnO2::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TFe_ads_FeOOH::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TFe_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Al_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Al_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNH4_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    NH4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    NH4_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNH4_ads_nsf::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNH4_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNdnr_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Ndnr_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Ndnr_ads_Mn::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Ndnr_ads_Fe::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNdnr_ads_MnO2::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNdnr_ads_FeOOH::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNdnr_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNdr_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Ndr_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Ndr_ads_Mn::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Ndr_ads_Fe::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNdr_ads_MnO2::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNdr_ads_FeOOH::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNdr_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TMn_dis_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TMn_ads_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TFe_dis_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TFe_ads_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Al_dis_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNH4_dis_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNH4_ads_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNdnr_dis_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNdnr_ads_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNdr_dis_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNdr_ads_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H4SiO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H3SiO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    HCO3::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    CO3::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    CO2::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H2S::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    HS::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H3BO3::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H4BO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H3PO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H2PO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    HPO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    PO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    OH::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H4SiO4_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H3SiO4_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    HCO3_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    CO3_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    CO2_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H2S_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    HS_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H3BO3_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H4BO4_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H3PO4_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H2PO4_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    HPO4_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    PO4_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    OH_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TA_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    dTA_dH::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    dTA_dTH4SiO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    dTA_dTCO2::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    dTA_dTH2S::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    dTA_dTH3BO3::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    dTA_dTH3PO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Omega_RFeS_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Omega_RFeS_pre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Omega_RCaCO3_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Omega_RBSi_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Omega_RBasalt_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RO2POC::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RNO2POC::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RNO3POC::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RMnO2POC::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RFeOOHPOC::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RSO4POC::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RCH4POC::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RO2NO2::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RO2NH4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RO2Mn::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RO2Mn_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RO2Fe::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RO2Fe_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RO2H2S::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RO2FeS::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RO2CH4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RNO2NH4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RSO4CH4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RMnO2Fe::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RMnO2H2S::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RFeOOHH2S::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RFeSH2S::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RFeS_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RFeS_pre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RCaCO3_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RBSi_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RMnRe_Ndnr::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RMnRe_Ndr::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RMnOx_Ndnr::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RMnOx_Ndr::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RFeRe_Ndnr::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RFeRe_Ndr::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RFeOx_Ndnr::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RFeOx_Ndr::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RNdnrPO4_pre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RNdrPO4_pre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RIllite_pre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RBasalt_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RBasalt_dis_Nd::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_POC::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_O2::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_TCO2::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_TNH4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_TH3PO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_NO2::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_NO3::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_MnO2::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_TMn::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_FeOOH::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_TFe::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_SO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_TH2S::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_CH4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_FeS::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_FeS2::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_CaCO3::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_Ca::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_BSi::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_TH4SiO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_Al::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_SurfMn_Ndnr::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_TNdnr::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_SurfMn_Ndr::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_TNdr::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_SurfFe_Ndnr::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_SurfFe_Ndr::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_NdnrPO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_NdrPO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_Illite::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_Basalt::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_TA::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_H::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_Age::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
end

function init(u0::Array{T,1}, Ngrid::Int) where {T}
    TMn_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Mn_aq = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Mn_ads_Mn = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Mn_ads_Fe = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TMn_ads_MnO2 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TMn_ads_FeOOH = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TMn_ads = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TFe_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Fe_aq = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Fe_ads_Mn = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Fe_ads_Fe = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TFe_ads_MnO2 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TFe_ads_FeOOH = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TFe_ads = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Al_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Al_aq = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TNH4_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    NH4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    NH4_ads = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TNH4_ads_nsf = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TNH4_ads = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TNdnr_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Ndnr_aq = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Ndnr_ads_Mn = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Ndnr_ads_Fe = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TNdnr_ads_MnO2 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TNdnr_ads_FeOOH = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TNdnr_ads = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TNdr_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Ndr_aq = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Ndr_ads_Mn = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Ndr_ads_Fe = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TNdr_ads_MnO2 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TNdr_ads_FeOOH = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TNdr_ads = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TMn_dis_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TMn_ads_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TFe_dis_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TFe_ads_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Al_dis_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TNH4_dis_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TNH4_ads_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TNdnr_dis_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TNdnr_ads_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TNdr_dis_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TNdr_ads_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H4SiO4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H3SiO4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    HCO3 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    CO3 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    CO2 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H2S = PreallocationTools.DiffCache(zeros(T, Ngrid))
    HS = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H3BO3 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H4BO4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H3PO4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H2PO4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    HPO4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    PO4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    OH = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H4SiO4_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H3SiO4_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    HCO3_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    CO3_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    CO2_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H2S_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    HS_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H3BO3_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H4BO4_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H3PO4_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H2PO4_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    HPO4_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    PO4_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    OH_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TA_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    dTA_dH = PreallocationTools.DiffCache(zeros(T, Ngrid))
    dTA_dTH4SiO4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    dTA_dTCO2 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    dTA_dTH2S = PreallocationTools.DiffCache(zeros(T, Ngrid))
    dTA_dTH3BO3 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    dTA_dTH3PO4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Omega_RFeS_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Omega_RFeS_pre = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Omega_RCaCO3_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Omega_RBSi_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Omega_RBasalt_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RO2POC = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RNO2POC = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RNO3POC = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RMnO2POC = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RFeOOHPOC = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RSO4POC = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RCH4POC = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RO2NO2 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RO2NH4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RO2Mn = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RO2Mn_ads = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RO2Fe = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RO2Fe_ads = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RO2H2S = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RO2FeS = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RO2CH4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RNO2NH4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RSO4CH4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RMnO2Fe = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RMnO2H2S = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RFeOOHH2S = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RFeSH2S = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RFeS_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RFeS_pre = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RCaCO3_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RBSi_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RMnRe_Ndnr = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RMnRe_Ndr = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RMnOx_Ndnr = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RMnOx_Ndr = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RFeRe_Ndnr = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RFeRe_Ndr = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RFeOx_Ndnr = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RFeOx_Ndr = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RNdnrPO4_pre = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RNdrPO4_pre = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RIllite_pre = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RBasalt_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RBasalt_dis_Nd = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_POC = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_O2 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_TCO2 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_TNH4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_TH3PO4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_NO2 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_NO3 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_MnO2 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_TMn = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_FeOOH = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_TFe = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_SO4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_TH2S = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_CH4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_FeS = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_FeS2 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_CaCO3 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_Ca = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_BSi = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_TH4SiO4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_Al = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_SurfMn_Ndnr = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_TNdnr = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_SurfMn_Ndr = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_TNdr = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_SurfFe_Ndnr = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_SurfFe_Ndr = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_NdnrPO4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_NdrPO4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_Illite = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_Basalt = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_TA = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_H = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_Age = PreallocationTools.DiffCache(zeros(T, Ngrid))

    cache = Reactran(
        TMn_dis,
        Mn_aq,
        Mn_ads_Mn,
        Mn_ads_Fe,
        TMn_ads_MnO2,
        TMn_ads_FeOOH,
        TMn_ads,
        TFe_dis,
        Fe_aq,
        Fe_ads_Mn,
        Fe_ads_Fe,
        TFe_ads_MnO2,
        TFe_ads_FeOOH,
        TFe_ads,
        Al_dis,
        Al_aq,
        TNH4_dis,
        NH4,
        NH4_ads,
        TNH4_ads_nsf,
        TNH4_ads,
        TNdnr_dis,
        Ndnr_aq,
        Ndnr_ads_Mn,
        Ndnr_ads_Fe,
        TNdnr_ads_MnO2,
        TNdnr_ads_FeOOH,
        TNdnr_ads,
        TNdr_dis,
        Ndr_aq,
        Ndr_ads_Mn,
        Ndr_ads_Fe,
        TNdr_ads_MnO2,
        TNdr_ads_FeOOH,
        TNdr_ads,
        TMn_dis_tran,
        TMn_ads_tran,
        TFe_dis_tran,
        TFe_ads_tran,
        Al_dis_tran,
        TNH4_dis_tran,
        TNH4_ads_tran,
        TNdnr_dis_tran,
        TNdnr_ads_tran,
        TNdr_dis_tran,
        TNdr_ads_tran,
        H4SiO4,
        H3SiO4,
        HCO3,
        CO3,
        CO2,
        H2S,
        HS,
        H3BO3,
        H4BO4,
        H3PO4,
        H2PO4,
        HPO4,
        PO4,
        OH,
        H4SiO4_tran,
        H3SiO4_tran,
        HCO3_tran,
        CO3_tran,
        CO2_tran,
        H2S_tran,
        HS_tran,
        H3BO3_tran,
        H4BO4_tran,
        H3PO4_tran,
        H2PO4_tran,
        HPO4_tran,
        PO4_tran,
        H_tran,
        OH_tran,
        TA_tran,
        dTA_dH,
        dTA_dTH4SiO4,
        dTA_dTCO2,
        dTA_dTH2S,
        dTA_dTH3BO3,
        dTA_dTH3PO4,
        Omega_RFeS_dis,
        Omega_RFeS_pre,
        Omega_RCaCO3_dis,
        Omega_RBSi_dis,
        Omega_RBasalt_dis,
        RO2POC,
        RNO2POC,
        RNO3POC,
        RMnO2POC,
        RFeOOHPOC,
        RSO4POC,
        RCH4POC,
        RO2NO2,
        RO2NH4,
        RO2Mn,
        RO2Mn_ads,
        RO2Fe,
        RO2Fe_ads,
        RO2H2S,
        RO2FeS,
        RO2CH4,
        RNO2NH4,
        RSO4CH4,
        RMnO2Fe,
        RMnO2H2S,
        RFeOOHH2S,
        RFeSH2S,
        RFeS_dis,
        RFeS_pre,
        RCaCO3_dis,
        RBSi_dis,
        RMnRe_Ndnr,
        RMnRe_Ndr,
        RMnOx_Ndnr,
        RMnOx_Ndr,
        RFeRe_Ndnr,
        RFeRe_Ndr,
        RFeOx_Ndnr,
        RFeOx_Ndr,
        RNdnrPO4_pre,
        RNdrPO4_pre,
        RIllite_pre,
        RBasalt_dis,
        RBasalt_dis_Nd,
        S_POC,
        S_O2,
        S_TCO2,
        S_TNH4,
        S_TH3PO4,
        S_NO2,
        S_NO3,
        S_MnO2,
        S_TMn,
        S_FeOOH,
        S_TFe,
        S_SO4,
        S_TH2S,
        S_CH4,
        S_FeS,
        S_FeS2,
        S_CaCO3,
        S_Ca,
        S_BSi,
        S_TH4SiO4,
        S_Al,
        S_SurfMn_Ndnr,
        S_TNdnr,
        S_SurfMn_Ndr,
        S_TNdr,
        S_SurfFe_Ndnr,
        S_SurfFe_Ndr,
        S_NdnrPO4,
        S_NdrPO4,
        S_Illite,
        S_Basalt,
        S_TA,
        S_H,
        S_Age,
    )
    return cache
end
end
