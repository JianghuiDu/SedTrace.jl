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
    TH3PO4ID::StepRange{Int64,Int64} = TH3PO4ID
    PorgID::StepRange{Int64,Int64} = PorgID
    AmPorg::Tridiagonal{T,Vector{T}} = AmPorg
    AmH3PO4::Tridiagonal{T,Vector{T}} = AmH3PO4
    AmP_ads::Tridiagonal{T,Vector{T}} = AmP_ads
    BcAmPorg::Vector{T} = BcAmPorg
    BcCmPorg::Vector{T} = BcCmPorg
    Ngrid::Int64 = Ngrid
    BcAmH3PO4::Vector{T} = BcAmH3PO4
    BcCmH3PO4::Vector{T} = BcCmH3PO4
    BcAmP_ads::Vector{T} = BcAmP_ads
    BcCmP_ads::Vector{T} = BcCmP_ads
    alpha::Vector{T} = alpha
    H3PO40::T = H3PO40
    K_ads::T = K_ads
    dstopw::Vector{T} = dstopw
    k_P::T = k_P
    k_pre::T = k_pre
    Csat::T = Csat
end
end
