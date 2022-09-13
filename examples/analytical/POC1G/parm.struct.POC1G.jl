module Param
using SedTrace: fvcf, fvcf_bc
using Parameters, LinearAlgebra, SpecialFunctions
include(
    "c:\\Users\\Jianghui\\.julia\\dev\\SedTrace\\examples\\analytical\\POC1G\\parm.POC1G.jl",
)

#---------------------------------------------------------------
# assemble parameter struct
#---------------------------------------------------------------
@with_kw mutable struct ParamStruct{T}
    POCID::StepRange{Int64,Int64} = POCID
    AmPOC::Tridiagonal{T,Vector{T}} = AmPOC
    BcAmPOC::Vector{T} = BcAmPOC
    BcCmPOC::Vector{T} = BcCmPOC
    Ngrid::Int64 = Ngrid
    k_POC::T = k_POC
end
end
