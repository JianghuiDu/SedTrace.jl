module Param
using SedTrace: fvcf, fvcf_bc
using Parameters, LinearAlgebra, SpecialFunctions
include(
    "c:\\Users\\Jianghui\\.julia\\dev\\SedTrace\\examples\\analytical\\Ammonia\\parm.ammonia.jl",
)

#---------------------------------------------------------------
# assemble parameter struct
#---------------------------------------------------------------
@with_kw mutable struct ParamStruct{T}
    TNH4ID::StepRange{Int64,Int64} = TNH4ID
    N_orgID::StepRange{Int64,Int64} = N_orgID
    AmN_org::Tridiagonal{T,Vector{T}} = AmN_org
    AmNH4::Tridiagonal{T,Vector{T}} = AmNH4
    AmNH4_ads::Tridiagonal{T,Vector{T}} = AmNH4_ads
    BcAmN_org::Vector{T} = BcAmN_org
    BcCmN_org::Vector{T} = BcCmN_org
    Ngrid::Int64 = Ngrid
    BcAmNH4::Vector{T} = BcAmNH4
    BcCmNH4::Vector{T} = BcCmNH4
    BcAmNH4_ads::Vector{T} = BcAmNH4_ads
    BcCmNH4_ads::Vector{T} = BcCmNH4_ads
    alpha::Vector{T} = alpha
    NH40::T = NH40
    KNH4_ads::T = KNH4_ads
    dstopw::Vector{T} = dstopw
    k::T = k
end
end
