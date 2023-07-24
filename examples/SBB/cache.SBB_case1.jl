module Cache
using PreallocationTools, ForwardDiff
struct Reactran{T}
    TMn_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Mn::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Mn_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TMn_ads_nsf::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TMn_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TFe_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Fe_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Fe_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TFe_ads_nsf::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TFe_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNH4_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    NH4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    NH4_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNH4_ads_nsf::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNH4_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Mol_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    MolO4_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    MolO3S_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    MolO2S2_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    MolOS3_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    MolS4_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Moh_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    MohO4_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    MohO3S_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    MohO2S2_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    MohOS3_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    MohS4_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TMn_dis_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TMn_ads_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TFe_dis_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TFe_ads_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNH4_dis_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNH4_ads_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
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
    RMol_rm1::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RMoh_rm1::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
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
    S_FeCO3::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
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

function init(u0::Array{T,1}, Ngrid::Int) where {T}
    TMn_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Mn = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Mn_ads = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TMn_ads_nsf = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TMn_ads = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TFe_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Fe_aq = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Fe_ads = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TFe_ads_nsf = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TFe_ads = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TNH4_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    NH4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    NH4_ads = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TNH4_ads_nsf = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TNH4_ads = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Mol_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    MolO4_aq = PreallocationTools.DiffCache(zeros(T, Ngrid))
    MolO3S_aq = PreallocationTools.DiffCache(zeros(T, Ngrid))
    MolO2S2_aq = PreallocationTools.DiffCache(zeros(T, Ngrid))
    MolOS3_aq = PreallocationTools.DiffCache(zeros(T, Ngrid))
    MolS4_aq = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Moh_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    MohO4_aq = PreallocationTools.DiffCache(zeros(T, Ngrid))
    MohO3S_aq = PreallocationTools.DiffCache(zeros(T, Ngrid))
    MohO2S2_aq = PreallocationTools.DiffCache(zeros(T, Ngrid))
    MohOS3_aq = PreallocationTools.DiffCache(zeros(T, Ngrid))
    MohS4_aq = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TMn_dis_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TMn_ads_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TFe_dis_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TFe_ads_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TNH4_dis_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TNH4_ads_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Mol_dis_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Moh_dis_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H3PO4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H2PO4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    HPO4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    PO4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    HSO4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    SO4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    OH = PreallocationTools.DiffCache(zeros(T, Ngrid))
    HCO3 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    CO3 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    CO2 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H2S = PreallocationTools.DiffCache(zeros(T, Ngrid))
    HS = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H3BO3 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H4BO4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    HF = PreallocationTools.DiffCache(zeros(T, Ngrid))
    F = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H3PO4_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H2PO4_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    HPO4_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    PO4_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    HSO4_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    SO4_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    OH_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    HCO3_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    CO3_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    CO2_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H2S_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    HS_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H3BO3_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H4BO4_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    HF_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    F_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TA_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    dTA_dH = PreallocationTools.DiffCache(zeros(T, Ngrid))
    dTA_dTH3PO4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    dTA_dTHSO4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    dTA_dTCO2 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    dTA_dTH2S = PreallocationTools.DiffCache(zeros(T, Ngrid))
    dTA_dTH3BO3 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    dTA_dTHF = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Omega_RFeS_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Omega_RFeS_pre = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Omega_RCaCO3_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Omega_RCaCO3_pre = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Omega_RMnCO3_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Omega_RMnCO3_pre = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Omega_RFeCO3_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Omega_RFeCO3_pre = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Omega_RBSi_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Omega_RASi_pre = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Omega_RCFA_pre = PreallocationTools.DiffCache(zeros(T, Ngrid))
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
    RNO3Mn = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RNO3Fe = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RNO3H2S = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RSO4CH4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RMnO2Fe = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RMnO2H2S = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RFeOOHH2S = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RFeSH2S = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RFeS_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RFeS_pre = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RCaCO3_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RCaCO3_pre = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RMnCO3_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RMnCO3_pre = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RFeCO3_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RFeCO3_pre = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RBSi_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RASi_pre = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RCFA_pre = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RMol_rm1 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RMoh_rm1 = PreallocationTools.DiffCache(zeros(T, Ngrid))
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
    S_THSO4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_TH2S = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_CH4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_FeS = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_FeS2 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_CaCO3 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_Ca = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_MnCO3 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_FeCO3 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_BSi = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_H4SiO4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_THF = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_Mol = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_SMol = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_Moh = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_SMoh = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_TA = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_H = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_Age = PreallocationTools.DiffCache(zeros(T, Ngrid))

    cache = Reactran(
        TMn_dis,
        Mn,
        Mn_ads,
        TMn_ads_nsf,
        TMn_ads,
        TFe_dis,
        Fe_aq,
        Fe_ads,
        TFe_ads_nsf,
        TFe_ads,
        TNH4_dis,
        NH4,
        NH4_ads,
        TNH4_ads_nsf,
        TNH4_ads,
        Mol_dis,
        MolO4_aq,
        MolO3S_aq,
        MolO2S2_aq,
        MolOS3_aq,
        MolS4_aq,
        Moh_dis,
        MohO4_aq,
        MohO3S_aq,
        MohO2S2_aq,
        MohOS3_aq,
        MohS4_aq,
        TMn_dis_tran,
        TMn_ads_tran,
        TFe_dis_tran,
        TFe_ads_tran,
        TNH4_dis_tran,
        TNH4_ads_tran,
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
        RMol_rm1,
        RMoh_rm1,
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
        S_FeCO3,
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
