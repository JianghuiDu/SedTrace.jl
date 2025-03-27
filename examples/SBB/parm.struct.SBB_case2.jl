module Param
using SedTrace: fvcf, fvcf_bc
using Parameters, LinearAlgebra, SpecialFunctions, DelimitedFiles
include(
    "/Users/pkudujianghui/Documents/SedTrace/examples/SBB/parm.SBB_case2.jl",
)

#---------------------------------------------------------------
# assemble parameter struct
#---------------------------------------------------------------
@with_kw struct ParamStruct{T}
    POCID::StepRange{Int64,Int64} = POCID
    MnO2ID::StepRange{Int64,Int64} = MnO2ID
    FeOOHID::StepRange{Int64,Int64} = FeOOHID
    FeSID::StepRange{Int64,Int64} = FeSID
    FeS2ID::StepRange{Int64,Int64} = FeS2ID
    CaCO3ID::StepRange{Int64,Int64} = CaCO3ID
    MnCO3ID::StepRange{Int64,Int64} = MnCO3ID
    FeCO3ID::StepRange{Int64,Int64} = FeCO3ID
    AgeID::StepRange{Int64,Int64} = AgeID
    BSiID::StepRange{Int64,Int64} = BSiID
    SMolID::StepRange{Int64,Int64} = SMolID
    SMohID::StepRange{Int64,Int64} = SMohID
    LMolID::StepRange{Int64,Int64} = LMolID
    LMohID::StepRange{Int64,Int64} = LMohID
    O2ID::StepRange{Int64,Int64} = O2ID
    NO3ID::StepRange{Int64,Int64} = NO3ID
    CH4ID::StepRange{Int64,Int64} = CH4ID
    NO2ID::StepRange{Int64,Int64} = NO2ID
    CaID::StepRange{Int64,Int64} = CaID
    H4SiO4ID::StepRange{Int64,Int64} = H4SiO4ID
    TMnID::StepRange{Int64,Int64} = TMnID
    TFeID::StepRange{Int64,Int64} = TFeID
    TNH4ID::StepRange{Int64,Int64} = TNH4ID
    MolID::StepRange{Int64,Int64} = MolID
    MohID::StepRange{Int64,Int64} = MohID
    TH3PO4ID::StepRange{Int64,Int64} = TH3PO4ID
    THSO4ID::StepRange{Int64,Int64} = THSO4ID
    HID::StepRange{Int64,Int64} = HID
    TCO2ID::StepRange{Int64,Int64} = TCO2ID
    TH2SID::StepRange{Int64,Int64} = TH2SID
    TH3BO3ID::StepRange{Int64,Int64} = TH3BO3ID
    THFID::StepRange{Int64,Int64} = THFID
    AmPOC::Tridiagonal{T,Vector{T}} = AmPOC
    AmMnO2::Tridiagonal{T,Vector{T}} = AmMnO2
    AmFeOOH::Tridiagonal{T,Vector{T}} = AmFeOOH
    AmFeS::Tridiagonal{T,Vector{T}} = AmFeS
    AmFeS2::Tridiagonal{T,Vector{T}} = AmFeS2
    AmCaCO3::Tridiagonal{T,Vector{T}} = AmCaCO3
    AmMnCO3::Tridiagonal{T,Vector{T}} = AmMnCO3
    AmFeCO3::Tridiagonal{T,Vector{T}} = AmFeCO3
    AmAge::Tridiagonal{T,Vector{T}} = AmAge
    AmBSi::Tridiagonal{T,Vector{T}} = AmBSi
    AmSMol::Tridiagonal{T,Vector{T}} = AmSMol
    AmSMoh::Tridiagonal{T,Vector{T}} = AmSMoh
    AmLMol::Tridiagonal{T,Vector{T}} = AmLMol
    AmLMoh::Tridiagonal{T,Vector{T}} = AmLMoh
    AmO2::Tridiagonal{T,Vector{T}} = AmO2
    AmNO3::Tridiagonal{T,Vector{T}} = AmNO3
    AmCH4::Tridiagonal{T,Vector{T}} = AmCH4
    AmNO2::Tridiagonal{T,Vector{T}} = AmNO2
    AmCa::Tridiagonal{T,Vector{T}} = AmCa
    AmH4SiO4::Tridiagonal{T,Vector{T}} = AmH4SiO4
    AmH3PO4::Tridiagonal{T,Vector{T}} = AmH3PO4
    AmH2PO4::Tridiagonal{T,Vector{T}} = AmH2PO4
    AmHPO4::Tridiagonal{T,Vector{T}} = AmHPO4
    AmPO4::Tridiagonal{T,Vector{T}} = AmPO4
    AmHSO4::Tridiagonal{T,Vector{T}} = AmHSO4
    AmSO4::Tridiagonal{T,Vector{T}} = AmSO4
    AmH::Tridiagonal{T,Vector{T}} = AmH
    AmOH::Tridiagonal{T,Vector{T}} = AmOH
    AmHCO3::Tridiagonal{T,Vector{T}} = AmHCO3
    AmCO3::Tridiagonal{T,Vector{T}} = AmCO3
    AmCO2::Tridiagonal{T,Vector{T}} = AmCO2
    AmH2S::Tridiagonal{T,Vector{T}} = AmH2S
    AmHS::Tridiagonal{T,Vector{T}} = AmHS
    AmH3BO3::Tridiagonal{T,Vector{T}} = AmH3BO3
    AmH4BO4::Tridiagonal{T,Vector{T}} = AmH4BO4
    AmHF::Tridiagonal{T,Vector{T}} = AmHF
    AmF::Tridiagonal{T,Vector{T}} = AmF
    AmTMn_dis::Tridiagonal{T,Vector{T}} = AmTMn_dis
    AmTMn_ads::Tridiagonal{T,Vector{T}} = AmTMn_ads
    AmTFe_dis::Tridiagonal{T,Vector{T}} = AmTFe_dis
    AmTFe_ads::Tridiagonal{T,Vector{T}} = AmTFe_ads
    AmTNH4_dis::Tridiagonal{T,Vector{T}} = AmTNH4_dis
    AmTNH4_ads::Tridiagonal{T,Vector{T}} = AmTNH4_ads
    AmMol_dis::Tridiagonal{T,Vector{T}} = AmMol_dis
    AmMoh_dis::Tridiagonal{T,Vector{T}} = AmMoh_dis
    BcAmPOC::Vector{T} = BcAmPOC
    BcCmPOC::Vector{T} = BcCmPOC
    BcAmMnO2::Vector{T} = BcAmMnO2
    BcCmMnO2::Vector{T} = BcCmMnO2
    BcAmFeOOH::Vector{T} = BcAmFeOOH
    BcCmFeOOH::Vector{T} = BcCmFeOOH
    BcAmFeS::Vector{T} = BcAmFeS
    BcCmFeS::Vector{T} = BcCmFeS
    BcAmFeS2::Vector{T} = BcAmFeS2
    BcCmFeS2::Vector{T} = BcCmFeS2
    BcAmCaCO3::Vector{T} = BcAmCaCO3
    BcCmCaCO3::Vector{T} = BcCmCaCO3
    BcAmMnCO3::Vector{T} = BcAmMnCO3
    BcCmMnCO3::Vector{T} = BcCmMnCO3
    BcAmFeCO3::Vector{T} = BcAmFeCO3
    BcCmFeCO3::Vector{T} = BcCmFeCO3
    BcAmAge::Vector{T} = BcAmAge
    BcCmAge::Vector{T} = BcCmAge
    BcAmBSi::Vector{T} = BcAmBSi
    BcCmBSi::Vector{T} = BcCmBSi
    BcAmSMol::Vector{T} = BcAmSMol
    BcCmSMol::Vector{T} = BcCmSMol
    BcAmSMoh::Vector{T} = BcAmSMoh
    BcCmSMoh::Vector{T} = BcCmSMoh
    BcAmLMol::Vector{T} = BcAmLMol
    BcCmLMol::Vector{T} = BcCmLMol
    BcAmLMoh::Vector{T} = BcAmLMoh
    BcCmLMoh::Vector{T} = BcCmLMoh
    BcAmO2::Vector{T} = BcAmO2
    BcCmO2::Vector{T} = BcCmO2
    BcAmNO3::Vector{T} = BcAmNO3
    BcCmNO3::Vector{T} = BcCmNO3
    BcAmCH4::Vector{T} = BcAmCH4
    BcCmCH4::Vector{T} = BcCmCH4
    BcAmNO2::Vector{T} = BcAmNO2
    BcCmNO2::Vector{T} = BcCmNO2
    BcAmCa::Vector{T} = BcAmCa
    BcCmCa::Vector{T} = BcCmCa
    BcAmH4SiO4::Vector{T} = BcAmH4SiO4
    BcCmH4SiO4::Vector{T} = BcCmH4SiO4
    Ngrid::Int64 = Ngrid
    BcAmH3PO4::Vector{T} = BcAmH3PO4
    BcCmH3PO4::Vector{T} = BcCmH3PO4
    BcAmH2PO4::Vector{T} = BcAmH2PO4
    BcCmH2PO4::Vector{T} = BcCmH2PO4
    BcAmHPO4::Vector{T} = BcAmHPO4
    BcCmHPO4::Vector{T} = BcCmHPO4
    BcAmPO4::Vector{T} = BcAmPO4
    BcCmPO4::Vector{T} = BcCmPO4
    BcAmHSO4::Vector{T} = BcAmHSO4
    BcCmHSO4::Vector{T} = BcCmHSO4
    BcAmSO4::Vector{T} = BcAmSO4
    BcCmSO4::Vector{T} = BcCmSO4
    BcAmH::Vector{T} = BcAmH
    BcCmH::Vector{T} = BcCmH
    BcAmOH::Vector{T} = BcAmOH
    BcCmOH::Vector{T} = BcCmOH
    BcAmHCO3::Vector{T} = BcAmHCO3
    BcCmHCO3::Vector{T} = BcCmHCO3
    BcAmCO3::Vector{T} = BcAmCO3
    BcCmCO3::Vector{T} = BcCmCO3
    BcAmCO2::Vector{T} = BcAmCO2
    BcCmCO2::Vector{T} = BcCmCO2
    BcAmH2S::Vector{T} = BcAmH2S
    BcCmH2S::Vector{T} = BcCmH2S
    BcAmHS::Vector{T} = BcAmHS
    BcCmHS::Vector{T} = BcCmHS
    BcAmH3BO3::Vector{T} = BcAmH3BO3
    BcCmH3BO3::Vector{T} = BcCmH3BO3
    BcAmH4BO4::Vector{T} = BcAmH4BO4
    BcCmH4BO4::Vector{T} = BcCmH4BO4
    BcAmHF::Vector{T} = BcAmHF
    BcCmHF::Vector{T} = BcCmHF
    BcAmF::Vector{T} = BcAmF
    BcCmF::Vector{T} = BcCmF
    BcAmTMn_dis::Vector{T} = BcAmTMn_dis
    BcCmTMn_dis::Vector{T} = BcCmTMn_dis
    BcAmTMn_ads::Vector{T} = BcAmTMn_ads
    BcCmTMn_ads::Vector{T} = BcCmTMn_ads
    BcAmTFe_dis::Vector{T} = BcAmTFe_dis
    BcCmTFe_dis::Vector{T} = BcCmTFe_dis
    BcAmTFe_ads::Vector{T} = BcAmTFe_ads
    BcCmTFe_ads::Vector{T} = BcCmTFe_ads
    BcAmTNH4_dis::Vector{T} = BcAmTNH4_dis
    BcCmTNH4_dis::Vector{T} = BcCmTNH4_dis
    BcAmTNH4_ads::Vector{T} = BcAmTNH4_ads
    BcCmTNH4_ads::Vector{T} = BcCmTNH4_ads
    BcAmMol_dis::Vector{T} = BcAmMol_dis
    BcCmMol_dis::Vector{T} = BcCmMol_dis
    BcAmMoh_dis::Vector{T} = BcAmMoh_dis
    BcCmMoh_dis::Vector{T} = BcCmMoh_dis
    alpha::Vector{T} = alpha
    O2BW::T = O2BW
    NO3BW::T = NO3BW
    CH4BW::T = CH4BW
    NO2BW::T = NO2BW
    CaBW::T = CaBW
    H4SiO4BW::T = H4SiO4BW
    H3PO4BW::T = H3PO4BW
    H2PO4BW::T = H2PO4BW
    HPO4BW::T = HPO4BW
    PO4BW::T = PO4BW
    HSO4BW::T = HSO4BW
    SO4BW::T = SO4BW
    HBW::T = HBW
    OHBW::T = OHBW
    HCO3BW::T = HCO3BW
    CO3BW::T = CO3BW
    CO2BW::T = CO2BW
    H2SBW::T = H2SBW
    HSBW::T = HSBW
    H3BO3BW::T = H3BO3BW
    H4BO4BW::T = H4BO4BW
    HFBW::T = HFBW
    FBW::T = FBW
    TMn_dis0::T = TMn_dis0
    TFe_dis0::T = TFe_dis0
    TNH4_dis0::T = TNH4_dis0
    Mol_dis0::T = Mol_dis0
    Moh_dis0::T = Moh_dis0
    dstopw::Vector{T} = dstopw
    KH3PO4::T = KH3PO4
    KH2PO4::T = KH2PO4
    KHPO4::T = KHPO4
    KHSO4::T = KHSO4
    KH2O::T = KH2O
    KCO2::T = KCO2
    KHCO3::T = KHCO3
    KH2S::T = KH2S
    KH3BO3::T = KH3BO3
    KHF::T = KHF
    KMn_ads::T = KMn_ads
    KFe_ads::T = KFe_ads
    Cl::T = Cl
    KNH4_ads::T = KNH4_ads
    KspFeS::T = KspFeS
    KspCaCO3_dis::T = KspCaCO3_dis
    KspCaCO3_pre::T = KspCaCO3_pre
    KspMnCO3::T = KspMnCO3
    KspFeCO3::T = KspFeCO3
    H4SiO4_dis_sat::T = H4SiO4_dis_sat
    H4SiO4_pre_sat::T = H4SiO4_pre_sat
    KspCFA::T = KspCFA
    rNC::T = rNC
    rPC::T = rPC
    pwtods::Vector{T} = pwtods
    KO2::T = KO2
    nu::T = nu
    a::T = a
    KNO2::T = KNO2
    KNO3::T = KNO3
    KMnO2::T = KMnO2
    KFeOOH::T = KFeOOH
    KTHSO4::T = KTHSO4
    kO2NO2::T = kO2NO2
    kO2NH4::T = kO2NH4
    kO2Mn::T = kO2Mn
    kO2Mn_ads::T = kO2Mn_ads
    kO2Fe::T = kO2Fe
    kO2Fe_ads::T = kO2Fe_ads
    kO2H2S::T = kO2H2S
    kO2FeS::T = kO2FeS
    kO2CH4::T = kO2CH4
    kNO2NH4::T = kNO2NH4
    kNO3Mn::T = kNO3Mn
    kNO3Fe::T = kNO3Fe
    kNO3H2S::T = kNO3H2S
    kAOM::T = kAOM
    KAOM::T = KAOM
    kMnO2Fe::T = kMnO2Fe
    kMnO2H2S::T = kMnO2H2S
    kFeOOHH2S::T = kFeOOHH2S
    kFeSH2S::T = kFeSH2S
    kFeSdis::T = kFeSdis
    kFeSpre::T = kFeSpre
    kCaCO3dis::T = kCaCO3dis
    kCaCO3pre::T = kCaCO3pre
    kMnCO3dis::T = kMnCO3dis
    kMnCO3pre::T = kMnCO3pre
    kFeCO3dis::T = kFeCO3dis
    kFeCO3pre::T = kFeCO3pre
    kBSidis::Vector{T} = kBSidis
    kASipre::T = kASipre
    kCFA_pre::T = kCFA_pre
    kMo_rm2::T = kMo_rm2
end
end
