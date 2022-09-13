module Param
using SedTrace: fvcf, fvcf_bc
using Parameters, LinearAlgebra, SpecialFunctions
include(
    "c:\\Users\\Jianghui\\.julia\\dev\\SedTrace\\examples\\analytical\\SulfateRedcution\\parm.SulfateReduction.jl",
)

#---------------------------------------------------------------
# assemble parameter struct
#---------------------------------------------------------------
@with_kw mutable struct ParamStruct{T}
    POCID::StepRange{Int64,Int64} = POCID
    SO4ID::StepRange{Int64,Int64} = SO4ID
    AmPOC::Tridiagonal{T,Vector{T}} = AmPOC
    AmSO4::Tridiagonal{T,Vector{T}} = AmSO4
    BcAmPOC::Vector{T} = BcAmPOC
    BcCmPOC::Vector{T} = BcCmPOC
    BcAmSO4::Vector{T} = BcAmSO4
    BcCmSO4::Vector{T} = BcCmSO4
    Ngrid::Int64 = Ngrid
    alpha::Vector{T} = alpha
    SO40::T = SO40
    dstopw::Vector{T} = dstopw
    k_POC::T = k_POC
end
end
