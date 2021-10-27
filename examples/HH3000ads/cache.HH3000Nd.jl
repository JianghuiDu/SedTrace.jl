module Cache
using PreallocationTools, ForwardDiff
mutable struct Reactran{T,chunk_size}
    Ndnr::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    Ndnr_tran::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    Ndnr_ads_Mn::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    Ndnr_ads_Mn_tran::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    Ndnr_ads_Fe::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    Ndnr_ads_Fe_tran::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    Ndr::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    Ndr_tran::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    Ndr_ads_Mn::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    Ndr_ads_Mn_tran::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    Ndr_ads_Fe::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    Ndr_ads_Fe_tran::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    Mn_ads::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    Fe_ads::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    NH4_ads::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    HCO3::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    CO3::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    CO2::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    H2S::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    HS::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    H3BO3::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    H4BO4::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    OH::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    H4SiO4::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    H3SiO4::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    H3PO4::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    H2PO4::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    HPO4::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    PO4::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    HCO3_tran::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    CO3_tran::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    CO2_tran::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    H2S_tran::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    HS_tran::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    H3BO3_tran::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    H4BO4_tran::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    H_tran::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    OH_tran::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    TA_tran::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    dTA_dH::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    dTA_dTCO2::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    dTA_dTH2S::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    dTA_dTH3BO3::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    Fe_free::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    Al_free::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    Ndnr_free::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    Ndr_free::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    Omega_RFeS_dis::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    Omega_RFeS_pre::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    Omega_RCaCO3_dis::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    Omega_RCaCO3_pre::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    Omega_RMnCO3_dis::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    Omega_RMnCO3_pre::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    Omega_RFeCO3_dis::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    Omega_RFeCO3_pre::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    Omega_RBSi_dis::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    Omega_RNdnrPO4_pre::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    Omega_RNdrPO4_pre::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RO2POC::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RNO2POC::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RNO3POC::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RMnO2POC::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RFeOOHPOC::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RSO4POC::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RCH4POC::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RO2NO2::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RO2NH4::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RO2Mn::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RO2Mn_ads::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RO2Fe::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RO2Fe_ads::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RO2H2S::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RO2FeS::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RO2CH4::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RNO2NH4::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RNO3Mn::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RNO3Fe::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RNO3H2S::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RSO4CH4::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RMnO2Fe::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RMnO2H2S::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RFeOOHH2S::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RFeSH2S::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RFeS_dis::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RFeS_pre::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RCaCO3_dis::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RCaCO3_pre::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RMnCO3_dis::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RMnCO3_pre::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RFeCO3_dis::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RFeCO3_pre::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RBSi_dis::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RNdnrPO4_pre::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    RNdrPO4_pre::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_POC::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_O2::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_TCO2::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_NH4::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_TH3PO4::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_NO2::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_NO3::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_MnO2::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_Mn::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_FeOOH::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_Fe::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_SO4::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_TH2S::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_CH4::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_FeS::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_FeS2::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_CaCO3::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_Ca::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_MnCO3::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_FeCO3::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_BSi::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_TH4SiO4::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_TNdnr::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_NdnrPO4::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_TNdr::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_NdrPO4::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_TA::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_H::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
    S_Age::PreallocationTools.DiffCache{
        Array{T,1},
        Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
    }
end

function init(
    u0::Array{T,1},
    Ngrid::Int,
    ::Val{chunk_size},
) where {T,chunk_size}
    Ndnr = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    Ndnr_tran = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    Ndnr_ads_Mn = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    Ndnr_ads_Mn_tran =
        PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    Ndnr_ads_Fe = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    Ndnr_ads_Fe_tran =
        PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    Ndr = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    Ndr_tran = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    Ndr_ads_Mn = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    Ndr_ads_Mn_tran =
        PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    Ndr_ads_Fe = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    Ndr_ads_Fe_tran =
        PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    Mn_ads = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    Fe_ads = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    NH4_ads = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    HCO3 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    CO3 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    CO2 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    H2S = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    HS = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    H3BO3 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    H4BO4 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    OH = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    H4SiO4 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    H3SiO4 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    H3PO4 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    H2PO4 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    HPO4 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    PO4 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    HCO3_tran = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    CO3_tran = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    CO2_tran = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    H2S_tran = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    HS_tran = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    H3BO3_tran = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    H4BO4_tran = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    H_tran = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    OH_tran = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    TA_tran = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    dTA_dH = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    dTA_dTCO2 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    dTA_dTH2S = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    dTA_dTH3BO3 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    Fe_free = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    Al_free = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    Ndnr_free = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    Ndr_free = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    Omega_RFeS_dis =
        PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    Omega_RFeS_pre =
        PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    Omega_RCaCO3_dis =
        PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    Omega_RCaCO3_pre =
        PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    Omega_RMnCO3_dis =
        PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    Omega_RMnCO3_pre =
        PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    Omega_RFeCO3_dis =
        PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    Omega_RFeCO3_pre =
        PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    Omega_RBSi_dis =
        PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    Omega_RNdnrPO4_pre =
        PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    Omega_RNdrPO4_pre =
        PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RO2POC = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RNO2POC = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RNO3POC = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RMnO2POC = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RFeOOHPOC = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RSO4POC = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RCH4POC = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RO2NO2 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RO2NH4 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RO2Mn = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RO2Mn_ads = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RO2Fe = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RO2Fe_ads = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RO2H2S = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RO2FeS = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RO2CH4 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RNO2NH4 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RNO3Mn = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RNO3Fe = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RNO3H2S = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RSO4CH4 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RMnO2Fe = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RMnO2H2S = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RFeOOHH2S = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RFeSH2S = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RFeS_dis = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RFeS_pre = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RCaCO3_dis = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RCaCO3_pre = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RMnCO3_dis = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RMnCO3_pre = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RFeCO3_dis = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RFeCO3_pre = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RBSi_dis = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RNdnrPO4_pre =
        PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    RNdrPO4_pre = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_POC = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_O2 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_TCO2 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_NH4 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_TH3PO4 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_NO2 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_NO3 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_MnO2 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_Mn = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_FeOOH = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_Fe = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_SO4 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_TH2S = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_CH4 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_FeS = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_FeS2 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_CaCO3 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_Ca = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_MnCO3 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_FeCO3 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_BSi = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_TH4SiO4 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_TNdnr = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_NdnrPO4 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_TNdr = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_NdrPO4 = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_TA = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_H = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})
    S_Age = PreallocationTools.dualcache(zeros(T, Ngrid), Val{chunk_size})

    cache = Reactran(
        Ndnr,
        Ndnr_tran,
        Ndnr_ads_Mn,
        Ndnr_ads_Mn_tran,
        Ndnr_ads_Fe,
        Ndnr_ads_Fe_tran,
        Ndr,
        Ndr_tran,
        Ndr_ads_Mn,
        Ndr_ads_Mn_tran,
        Ndr_ads_Fe,
        Ndr_ads_Fe_tran,
        Mn_ads,
        Fe_ads,
        NH4_ads,
        HCO3,
        CO3,
        CO2,
        H2S,
        HS,
        H3BO3,
        H4BO4,
        OH,
        H4SiO4,
        H3SiO4,
        H3PO4,
        H2PO4,
        HPO4,
        PO4,
        HCO3_tran,
        CO3_tran,
        CO2_tran,
        H2S_tran,
        HS_tran,
        H3BO3_tran,
        H4BO4_tran,
        H_tran,
        OH_tran,
        TA_tran,
        dTA_dH,
        dTA_dTCO2,
        dTA_dTH2S,
        dTA_dTH3BO3,
        Fe_free,
        Al_free,
        Ndnr_free,
        Ndr_free,
        Omega_RFeS_dis,
        Omega_RFeS_pre,
        Omega_RCaCO3_dis,
        Omega_RCaCO3_pre,
        Omega_RMnCO3_dis,
        Omega_RMnCO3_pre,
        Omega_RFeCO3_dis,
        Omega_RFeCO3_pre,
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
        RNO3Mn,
        RNO3Fe,
        RNO3H2S,
        RSO4CH4,
        RMnO2Fe,
        RMnO2H2S,
        RFeOOHH2S,
        RFeSH2S,
        RFeS_dis,
        RFeS_pre,
        RCaCO3_dis,
        RCaCO3_pre,
        RMnCO3_dis,
        RMnCO3_pre,
        RFeCO3_dis,
        RFeCO3_pre,
        RBSi_dis,
        RNdnrPO4_pre,
        RNdrPO4_pre,
        S_POC,
        S_O2,
        S_TCO2,
        S_NH4,
        S_TH3PO4,
        S_NO2,
        S_NO3,
        S_MnO2,
        S_Mn,
        S_FeOOH,
        S_Fe,
        S_SO4,
        S_TH2S,
        S_CH4,
        S_FeS,
        S_FeS2,
        S_CaCO3,
        S_Ca,
        S_MnCO3,
        S_FeCO3,
        S_BSi,
        S_TH4SiO4,
        S_TNdnr,
        S_NdnrPO4,
        S_TNdr,
        S_NdrPO4,
        S_TA,
        S_H,
        S_Age,
    )
    return cache
end
end
nothing
