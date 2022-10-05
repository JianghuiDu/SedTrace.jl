module Cache
using PreallocationTools, ForwardDiff
mutable struct Reactran{T}
    Mn_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TMn_ads_nsf::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TMn_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Fe_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TFe_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    FeCl_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    FeSO4_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    FeCO3_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Fe_CO3_OH_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    FeHS_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    FeS_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Fe_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TFe_ads_nsf::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TFe_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    NH4_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNH4_ads_nsf::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNH4_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    MolO4_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Mol_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    MolO3S_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    MolO2S2_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    MolOS3_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    MolS4_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    MohO4_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Moh_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    MohO3S_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    MohO2S2_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    MohOS3_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    MohS4_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TMn_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TMn_dis_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TMn_ads_nsf_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TFe_dis_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TFe_ads_nsf_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNH4_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNH4_dis_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNH4_ads_nsf_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Mol_dis_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Moh_dis_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H3PO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H2PO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    HPO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    PO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    HSO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    SO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    OH::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    HCO3::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    CO3::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    CO2::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H2S::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    HS::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H3BO3::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H4BO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    HF::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    F::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H3PO4_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H2PO4_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    HPO4_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    PO4_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    HSO4_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    SO4_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    OH_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    HCO3_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    CO3_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    CO2_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H2S_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    HS_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H3BO3_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H4BO4_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    HF_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    F_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TA_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    dTA_dH::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    dTA_dTH3PO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    dTA_dTHSO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    dTA_dTCO2::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    dTA_dTH2S::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    dTA_dTH3BO3::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    dTA_dTHF::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Omega_RFeS_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Omega_RFeS_pre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Omega_RCaCO3_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Omega_RCaCO3_pre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Omega_RMnCO3_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Omega_RMnCO3_pre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Omega_RFeCO3_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Omega_RFeCO3_pre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Omega_RBSi_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Omega_RASi_pre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Omega_RCFA_pre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
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
    RNO3Mn::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RNO3Fe::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RNO3H2S::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RSO4CH4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RMnO2Fe::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RMnO2H2S::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RFeOOHH2S::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RFeSH2S::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RFeS_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RFeS_pre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RCaCO3_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RCaCO3_pre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RMnCO3_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RMnCO3_pre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RFeCO3_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RFeCO3_pre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RBSi_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RASi_pre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RCFA_pre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RMolS4_pre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RMohS4_pre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
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
    S_THSO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_TH2S::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_CH4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_FeS::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_FeS2::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_CaCO3::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_Ca::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_MnCO3::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_BSi::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_H4SiO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_THF::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_Mol::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_SMol::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_Moh::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_SMoh::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_TA::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_H::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_Age::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
end

function init(u0::Array{T,1}, Ngrid::Int, chunk_size::Int) where {T}
    Mn_ads = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TMn_ads_nsf = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TMn_ads = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Fe_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TFe_dis = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    FeCl_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    FeSO4_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    FeCO3_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Fe_CO3_OH_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    FeHS_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    FeS_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Fe_ads = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TFe_ads_nsf = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TFe_ads = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    NH4_ads = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TNH4_ads_nsf = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TNH4_ads = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    MolO4_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Mol_dis = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    MolO3S_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    MolO2S2_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    MolOS3_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    MolS4_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    MohO4_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Moh_dis = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    MohO3S_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    MohO2S2_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    MohOS3_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    MohS4_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TMn_dis = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TMn_dis_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TMn_ads_nsf_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TFe_dis_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TFe_ads_nsf_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TNH4_dis = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TNH4_dis_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TNH4_ads_nsf_tran =
        PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Mol_dis_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Moh_dis_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H3PO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H2PO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    HPO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    PO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    HSO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    SO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    OH = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    HCO3 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    CO3 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    CO2 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H2S = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    HS = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H3BO3 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H4BO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    HF = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    F = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H3PO4_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H2PO4_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    HPO4_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    PO4_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    HSO4_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    SO4_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    OH_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    HCO3_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    CO3_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    CO2_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H2S_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    HS_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H3BO3_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H4BO4_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    HF_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    F_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TA_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    dTA_dH = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    dTA_dTH3PO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    dTA_dTHSO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    dTA_dTCO2 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    dTA_dTH2S = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    dTA_dTH3BO3 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    dTA_dTHF = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Omega_RFeS_dis = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Omega_RFeS_pre = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Omega_RCaCO3_dis = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Omega_RCaCO3_pre = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Omega_RMnCO3_dis = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Omega_RMnCO3_pre = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Omega_RFeCO3_dis = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Omega_RFeCO3_pre = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Omega_RBSi_dis = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Omega_RASi_pre = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Omega_RCFA_pre = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
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
    RNO3Mn = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RNO3Fe = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RNO3H2S = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RSO4CH4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RMnO2Fe = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RMnO2H2S = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RFeOOHH2S = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RFeSH2S = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RFeS_dis = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RFeS_pre = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RCaCO3_dis = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RCaCO3_pre = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RMnCO3_dis = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RMnCO3_pre = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RFeCO3_dis = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RFeCO3_pre = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RBSi_dis = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RASi_pre = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RCFA_pre = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RMolS4_pre = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RMohS4_pre = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
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
    S_THSO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_TH2S = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_CH4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_FeS = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_FeS2 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_CaCO3 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_Ca = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_MnCO3 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_BSi = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_H4SiO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_THF = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_Mol = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_SMol = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_Moh = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_SMoh = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_TA = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_H = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_Age = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)

    cache = Reactran(
        Mn_ads,
        TMn_ads_nsf,
        TMn_ads,
        Fe_aq,
        TFe_dis,
        FeCl_aq,
        FeSO4_aq,
        FeCO3_aq,
        Fe_CO3_OH_aq,
        FeHS_aq,
        FeS_aq,
        Fe_ads,
        TFe_ads_nsf,
        TFe_ads,
        NH4_ads,
        TNH4_ads_nsf,
        TNH4_ads,
        MolO4_aq,
        Mol_dis,
        MolO3S_aq,
        MolO2S2_aq,
        MolOS3_aq,
        MolS4_aq,
        MohO4_aq,
        Moh_dis,
        MohO3S_aq,
        MohO2S2_aq,
        MohOS3_aq,
        MohS4_aq,
        TMn_dis,
        TMn_dis_tran,
        TMn_ads_nsf_tran,
        TFe_dis_tran,
        TFe_ads_nsf_tran,
        TNH4_dis,
        TNH4_dis_tran,
        TNH4_ads_nsf_tran,
        Mol_dis_tran,
        Moh_dis_tran,
        H3PO4,
        H2PO4,
        HPO4,
        PO4,
        HSO4,
        SO4,
        OH,
        HCO3,
        CO3,
        CO2,
        H2S,
        HS,
        H3BO3,
        H4BO4,
        HF,
        F,
        H3PO4_tran,
        H2PO4_tran,
        HPO4_tran,
        PO4_tran,
        HSO4_tran,
        SO4_tran,
        H_tran,
        OH_tran,
        HCO3_tran,
        CO3_tran,
        CO2_tran,
        H2S_tran,
        HS_tran,
        H3BO3_tran,
        H4BO4_tran,
        HF_tran,
        F_tran,
        TA_tran,
        dTA_dH,
        dTA_dTH3PO4,
        dTA_dTHSO4,
        dTA_dTCO2,
        dTA_dTH2S,
        dTA_dTH3BO3,
        dTA_dTHF,
        Omega_RFeS_dis,
        Omega_RFeS_pre,
        Omega_RCaCO3_dis,
        Omega_RCaCO3_pre,
        Omega_RMnCO3_dis,
        Omega_RMnCO3_pre,
        Omega_RFeCO3_dis,
        Omega_RFeCO3_pre,
        Omega_RBSi_dis,
        Omega_RASi_pre,
        Omega_RCFA_pre,
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
        RASi_pre,
        RCFA_pre,
        RMolS4_pre,
        RMohS4_pre,
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
        S_THSO4,
        S_TH2S,
        S_CH4,
        S_FeS,
        S_FeS2,
        S_CaCO3,
        S_Ca,
        S_MnCO3,
        S_BSi,
        S_H4SiO4,
        S_THF,
        S_Mol,
        S_SMol,
        S_Moh,
        S_SMoh,
        S_TA,
        S_H,
        S_Age,
    )
    return cache
end
end
