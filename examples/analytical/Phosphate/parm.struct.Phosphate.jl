module Param
using SedTrace: fvcf, fvcf_bc
using Parameters, LinearAlgebra, SpecialFunctions
include(
    "c:\\Users\\Jianghui\\.julia\\dev\\SedTrace\\examples\\analytical\\Phosphate\\parm.Phosphate.jl",
)

#---------------------------------------------------------------
# assemble parameter struct
#---------------------------------------------------------------
@with_kw mutable struct ParamStruct{T}
    PorgID::StepRange{Int64,Int64} = PorgID
    TH3PO4ID::StepRange{Int64,Int64} = TH3PO4ID
    AmPorg::Tridiagonal{T,Vector{T}} = AmPorg
    AmTH3PO4_dis::Tridiagonal{T,Vector{T}} = AmTH3PO4_dis
    AmTH3PO4_ads_nsf::Tridiagonal{T,Vector{T}} = AmTH3PO4_ads_nsf
    BcAmPorg::Vector{T} = BcAmPorg
    BcCmPorg::Vector{T} = BcCmPorg
    Ngrid::Int64 = Ngrid
    BcAmTH3PO4_dis::Vector{T} = BcAmTH3PO4_dis
    BcCmTH3PO4_dis::Vector{T} = BcCmTH3PO4_dis
    BcAmTH3PO4_ads_nsf::Vector{T} = BcAmTH3PO4_ads_nsf
    BcCmTH3PO4_ads_nsf::Vector{T} = BcCmTH3PO4_ads_nsf
    alpha::Vector{T} = alpha
    TH3PO4_dis0::T = TH3PO4_dis0
    dstopw::Vector{T} = dstopw
    K_ads::T = K_ads
    k_P::T = k_P
    k_pre::T = k_pre
    Csat::T = Csat
end
end
