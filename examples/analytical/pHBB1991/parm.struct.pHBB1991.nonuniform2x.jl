module Param
using SedTrace: fvcf, fvcf_bc
using Parameters, LinearAlgebra, SpecialFunctions, DelimitedFiles
include(
    "c:\\Users\\Jianghui\\.julia\\dev\\SedTrace\\examples\\analytical\\pHBB1991\\parm.pHBB1991.nonuniform2x.jl",
)

#---------------------------------------------------------------
# assemble parameter struct
#---------------------------------------------------------------
@with_kw struct ParamStruct{T}
    O2ID::StepRange{Int64,Int64} = O2ID
    HID::StepRange{Int64,Int64} = HID
    TCO2ID::StepRange{Int64,Int64} = TCO2ID
    TH2SID::StepRange{Int64,Int64} = TH2SID
    TH3BO3ID::StepRange{Int64,Int64} = TH3BO3ID
    AmO2::Tridiagonal{T,Vector{T}} = AmO2
    AmH::Tridiagonal{T,Vector{T}} = AmH
    AmOH::Tridiagonal{T,Vector{T}} = AmOH
    AmHCO3::Tridiagonal{T,Vector{T}} = AmHCO3
    AmCO3::Tridiagonal{T,Vector{T}} = AmCO3
    AmCO2::Tridiagonal{T,Vector{T}} = AmCO2
    AmH2S::Tridiagonal{T,Vector{T}} = AmH2S
    AmHS::Tridiagonal{T,Vector{T}} = AmHS
    AmH3BO3::Tridiagonal{T,Vector{T}} = AmH3BO3
    AmH4BO4::Tridiagonal{T,Vector{T}} = AmH4BO4
    BcAmO2::Vector{T} = BcAmO2
    BcCmO2::Vector{T} = BcCmO2
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
    BcAmH3BO3::Vector{T} = BcAmH3BO3
    BcCmH3BO3::Vector{T} = BcCmH3BO3
    BcAmH4BO4::Vector{T} = BcAmH4BO4
    BcCmH4BO4::Vector{T} = BcCmH4BO4
    alpha::Vector{T} = alpha
    O20::T = O20
    H0::T = H0
    OH0::T = OH0
    HCO30::T = HCO30
    CO30::T = CO30
    CO20::T = CO20
    H2S0::T = H2S0
    HS0::T = HS0
    H3BO30::T = H3BO30
    H4BO40::T = H4BO40
    KH2O::T = KH2O
    KCO2::T = KCO2
    KHCO3::T = KHCO3
    KH2S::T = KH2S
    KH3BO3::T = KH3BO3
    kOS::T = kOS
    a::T = a
    x::Vector{T} = x
    x0::T = x0
end
end
