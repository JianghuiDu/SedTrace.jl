module Param
using SedTrace: fvcf, fvcf_bc
using Parameters, LinearAlgebra, SpecialFunctions, DelimitedFiles
include(
    "/Users/pkudujianghui/Documents/SedTrace/examples/analytical/Ammonia/parm.ammonia.jl",
)

#---------------------------------------------------------------
# assemble parameter struct
#---------------------------------------------------------------
@with_kw struct ParamStruct{T}
    N_orgID::StepRange{Int64,Int64} = N_orgID
    TNH4ID::StepRange{Int64,Int64} = TNH4ID
    AmN_org::Tridiagonal{T,Vector{T}} = AmN_org
    AmTNH4_dis::Tridiagonal{T,Vector{T}} = AmTNH4_dis
    AmTNH4_ads::Tridiagonal{T,Vector{T}} = AmTNH4_ads
    BcAmN_org::Vector{T} = BcAmN_org
    BcCmN_org::Vector{T} = BcCmN_org
    Ngrid::Int64 = Ngrid
    BcAmTNH4_dis::Vector{T} = BcAmTNH4_dis
    BcCmTNH4_dis::Vector{T} = BcCmTNH4_dis
    BcAmTNH4_ads::Vector{T} = BcAmTNH4_ads
    BcCmTNH4_ads::Vector{T} = BcCmTNH4_ads
    alpha::Vector{T} = alpha
    TNH4_dis0::T = TNH4_dis0
    dstopw::Vector{T} = dstopw
    KNH4_ads::T = KNH4_ads
    k::T = k
end
end
