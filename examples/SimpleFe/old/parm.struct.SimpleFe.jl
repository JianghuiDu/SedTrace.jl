module Param
using SedTrace: fvcf, fvcf_bc
using Parameters, LinearAlgebra, SpecialFunctions
include(
    "c:\\Users\\Jianghui\\.julia\\dev\\SedTrace\\examples\\SimpleFe\\parm.SimpleFe.jl",
)

#---------------------------------------------------------------
# assemble parameter struct
#---------------------------------------------------------------
@with_kw mutable struct ParamStruct{T}
    POCID::StepRange{Int64,Int64} = POCID
    FeOOHID::StepRange{Int64,Int64} = FeOOHID
    FeSID::StepRange{Int64,Int64} = FeSID
    SO4ID::StepRange{Int64,Int64} = SO4ID
    TFeID::StepRange{Int64,Int64} = TFeID
    HID::StepRange{Int64,Int64} = HID
    TCO2ID::StepRange{Int64,Int64} = TCO2ID
    TH2SID::StepRange{Int64,Int64} = TH2SID
    AmPOC::Tridiagonal{T,Vector{T}} = AmPOC
    AmFeOOH::Tridiagonal{T,Vector{T}} = AmFeOOH
    AmFeS::Tridiagonal{T,Vector{T}} = AmFeS
    AmSO4::Tridiagonal{T,Vector{T}} = AmSO4
    AmH::Tridiagonal{T,Vector{T}} = AmH
    AmOH::Tridiagonal{T,Vector{T}} = AmOH
    AmHCO3::Tridiagonal{T,Vector{T}} = AmHCO3
    AmCO3::Tridiagonal{T,Vector{T}} = AmCO3
    AmCO2::Tridiagonal{T,Vector{T}} = AmCO2
    AmH2S::Tridiagonal{T,Vector{T}} = AmH2S
    AmHS::Tridiagonal{T,Vector{T}} = AmHS
    AmFe::Tridiagonal{T,Vector{T}} = AmFe
    AmFe_ads::Tridiagonal{T,Vector{T}} = AmFe_ads
    BcAmPOC::Vector{T} = BcAmPOC
    BcCmPOC::Vector{T} = BcCmPOC
    BcAmFeOOH::Vector{T} = BcAmFeOOH
    BcCmFeOOH::Vector{T} = BcCmFeOOH
    BcAmFeS::Vector{T} = BcAmFeS
    BcCmFeS::Vector{T} = BcCmFeS
    BcAmSO4::Vector{T} = BcAmSO4
    BcCmSO4::Vector{T} = BcCmSO4
    Ngrid::Int64 = Ngrid
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
    BcAmFe::Vector{T} = BcAmFe
    BcCmFe::Vector{T} = BcCmFe
    BcAmFe_ads::Vector{T} = BcAmFe_ads
    BcCmFe_ads::Vector{T} = BcCmFe_ads
    alpha::Vector{T} = alpha
    SO40::T = SO40
    H0::T = H0
    OH0::T = OH0
    HCO30::T = HCO30
    CO30::T = CO30
    CO20::T = CO20
    H2S0::T = H2S0
    HS0::T = HS0
    Fe0::T = Fe0
    KFe_ads::T = KFe_ads
    dstopw::Vector{T} = dstopw
    KH2O::T = KH2O
    KCO2::T = KCO2
    KHCO3::T = KHCO3
    KH2S::T = KH2S
    Cl::T = Cl
    KspFeS::T = KspFeS
    pwtods::Vector{T} = pwtods
    KFeOOH::T = KFeOOH
    k_POC::T = k_POC
    KSO4::T = KSO4
    kFeOOHH2S::T = kFeOOHH2S
    kFeSpre::T = kFeSpre
end
end
