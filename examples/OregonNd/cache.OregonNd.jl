module Cache
using PreallocationTools, ForwardDiff
mutable struct Reactran{T}
    Mn::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Mn_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Mn_ads_Fe::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Mn_ads_Fe_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Mn_ads_Mn::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Mn_ads_Mn_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Fe::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Fe_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Fe_ads_Fe::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Fe_ads_Fe_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Fe_ads_Mn::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Fe_ads_Mn_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    NH4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    NH4_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    NH4_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    NH4_ads_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Ndnr::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Ndnr_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Ndnr_ads_Fe::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Ndnr_ads_Fe_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Ndnr_ads_Mn::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Ndnr_ads_Mn_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Ndr::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Ndr_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Ndr_ads_Fe::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Ndr_ads_Fe_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Ndr_ads_Mn::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Ndr_ads_Mn_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
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
    H4SiO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H3SiO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
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
    dTA_dTCO2::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    dTA_dTH2S::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    dTA_dTH3BO3::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    dTA_dTH3PO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Fe_free::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Fe_OH_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Fe_OH_2_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    FeHCO3_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    FeCO3_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Fe_CO3_2_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    FeSO4_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    FeCl_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    FeS_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Al_free::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Al_OH_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Al_OH_2_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Al_OH_3_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Al_OH_4_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Ndnr_free::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    NdnrCO3_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Ndnr_CO3_2_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    NdnrHCO3_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    NdnrCl_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    NdnrSO4_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    NdnrOH_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    NdnrH3SiO4_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Ndnr_H3SiO4_2_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Ndr_free::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    NdrCO3_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Ndr_CO3_2_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    NdrHCO3_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    NdrCl_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    NdrSO4_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    NdrOH_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    NdrH3SiO4_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Ndr_H3SiO4_2_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Mn_free::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Mn_OH_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Mn_OH_2_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    MnHCO3_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    MnCO3_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    MnSO4_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    MnCl_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Omega_RFeS_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Omega_RFeS_pre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Omega_RCaCO3_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Omega_RBSi_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Omega_RNdnrPO4_pre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Omega_RNdrPO4_pre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
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
    S_TA::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_H::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_Age::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
end

function init(u0::Array{T,1}, Ngrid::Int, chunk_size::Int) where {T}
    Mn = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Mn_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Mn_ads_Fe = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Mn_ads_Fe_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Mn_ads_Mn = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Mn_ads_Mn_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Fe = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Fe_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Fe_ads_Fe = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Fe_ads_Fe_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Fe_ads_Mn = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Fe_ads_Mn_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    NH4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    NH4_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    NH4_ads = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    NH4_ads_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Ndnr = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Ndnr_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Ndnr_ads_Fe = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Ndnr_ads_Fe_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Ndnr_ads_Mn = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Ndnr_ads_Mn_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Ndr = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Ndr_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Ndr_ads_Fe = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Ndr_ads_Fe_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Ndr_ads_Mn = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Ndr_ads_Mn_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    HCO3 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    CO3 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    CO2 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H2S = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    HS = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H3BO3 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H4BO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H3PO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H2PO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    HPO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    PO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    OH = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H4SiO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H3SiO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    HCO3_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    CO3_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    CO2_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H2S_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    HS_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H3BO3_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H4BO4_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H3PO4_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H2PO4_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    HPO4_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    PO4_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    OH_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TA_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    dTA_dH = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    dTA_dTCO2 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    dTA_dTH2S = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    dTA_dTH3BO3 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    dTA_dTH3PO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Fe_free = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Fe_OH_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Fe_OH_2_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    FeHCO3_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    FeCO3_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Fe_CO3_2_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    FeSO4_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    FeCl_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    FeS_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Al_free = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Al_OH_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Al_OH_2_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Al_OH_3_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Al_OH_4_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Ndnr_free = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    NdnrCO3_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Ndnr_CO3_2_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    NdnrHCO3_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    NdnrCl_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    NdnrSO4_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    NdnrOH_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    NdnrH3SiO4_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Ndnr_H3SiO4_2_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Ndr_free = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    NdrCO3_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Ndr_CO3_2_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    NdrHCO3_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    NdrCl_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    NdrSO4_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    NdrOH_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    NdrH3SiO4_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Ndr_H3SiO4_2_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Mn_free = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Mn_OH_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Mn_OH_2_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    MnHCO3_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    MnCO3_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    MnSO4_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    MnCl_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Omega_RFeS_dis = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Omega_RFeS_pre = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Omega_RCaCO3_dis = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Omega_RBSi_dis = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Omega_RNdnrPO4_pre =
        PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Omega_RNdrPO4_pre =
        PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RO2POC = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RNO2POC = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RNO3POC = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RMnO2POC = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RFeOOHPOC = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RSO4POC = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RCH4POC = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RO2NO2 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RO2NH4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RO2Mn = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RO2Mn_ads = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RO2Fe = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RO2Fe_ads = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RO2H2S = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RO2FeS = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RO2CH4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RNO2NH4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RSO4CH4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RMnO2Fe = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RMnO2H2S = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RFeOOHH2S = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RFeSH2S = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RFeS_dis = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RFeS_pre = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RCaCO3_dis = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RBSi_dis = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RMnRe_Ndnr = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RMnRe_Ndr = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RMnOx_Ndnr = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RMnOx_Ndr = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RFeRe_Ndnr = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RFeRe_Ndr = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RFeOx_Ndnr = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RFeOx_Ndr = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RNdnrPO4_pre = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RNdrPO4_pre = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_POC = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_O2 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_TCO2 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_TNH4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_TH3PO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_NO2 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_NO3 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_MnO2 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_TMn = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_FeOOH = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_TFe = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_SO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_TH2S = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_CH4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_FeS = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_FeS2 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_CaCO3 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_Ca = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_BSi = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_TH4SiO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_Al = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_SurfMn_Ndnr = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_TNdnr = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_SurfMn_Ndr = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_TNdr = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_SurfFe_Ndnr = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_SurfFe_Ndr = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_NdnrPO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_NdrPO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_TA = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_H = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_Age = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)

    cache = Reactran(
        Mn,
        Mn_tran,
        Mn_ads_Fe,
        Mn_ads_Fe_tran,
        Mn_ads_Mn,
        Mn_ads_Mn_tran,
        Fe,
        Fe_tran,
        Fe_ads_Fe,
        Fe_ads_Fe_tran,
        Fe_ads_Mn,
        Fe_ads_Mn_tran,
        NH4,
        NH4_tran,
        NH4_ads,
        NH4_ads_tran,
        Ndnr,
        Ndnr_tran,
        Ndnr_ads_Fe,
        Ndnr_ads_Fe_tran,
        Ndnr_ads_Mn,
        Ndnr_ads_Mn_tran,
        Ndr,
        Ndr_tran,
        Ndr_ads_Fe,
        Ndr_ads_Fe_tran,
        Ndr_ads_Mn,
        Ndr_ads_Mn_tran,
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
        H4SiO4,
        H3SiO4,
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
        dTA_dTCO2,
        dTA_dTH2S,
        dTA_dTH3BO3,
        dTA_dTH3PO4,
        Fe_free,
        Fe_OH_aq,
        Fe_OH_2_aq,
        FeHCO3_aq,
        FeCO3_aq,
        Fe_CO3_2_aq,
        FeSO4_aq,
        FeCl_aq,
        FeS_aq,
        Al_free,
        Al_OH_aq,
        Al_OH_2_aq,
        Al_OH_3_aq,
        Al_OH_4_aq,
        Ndnr_free,
        NdnrCO3_aq,
        Ndnr_CO3_2_aq,
        NdnrHCO3_aq,
        NdnrCl_aq,
        NdnrSO4_aq,
        NdnrOH_aq,
        NdnrH3SiO4_aq,
        Ndnr_H3SiO4_2_aq,
        Ndr_free,
        NdrCO3_aq,
        Ndr_CO3_2_aq,
        NdrHCO3_aq,
        NdrCl_aq,
        NdrSO4_aq,
        NdrOH_aq,
        NdrH3SiO4_aq,
        Ndr_H3SiO4_2_aq,
        Mn_free,
        Mn_OH_aq,
        Mn_OH_2_aq,
        MnHCO3_aq,
        MnCO3_aq,
        MnSO4_aq,
        MnCl_aq,
        Omega_RFeS_dis,
        Omega_RFeS_pre,
        Omega_RCaCO3_dis,
        Omega_RBSi_dis,
        Omega_RNdnrPO4_pre,
        Omega_RNdrPO4_pre,
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
        S_TA,
        S_H,
        S_Age,
    )
    return cache
end
end
