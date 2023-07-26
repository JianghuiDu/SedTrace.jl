module Param
using SedTrace: fvcf, fvcf_bc
using Parameters, LinearAlgebra, SpecialFunctions, DelimitedFiles
include(
    "C:\\Users\\Jianghui\\.julia\\dev\\SedTrace\\test\\POC1G\\parm.POC1G.jl",
)

#---------------------------------------------------------------
# assemble parameter struct
#---------------------------------------------------------------
@with_kw struct ParamStruct{T}
    POCID::StepRange{Int64,Int64} = POCID
    AmPOC::Tridiagonal{T,Vector{T}} = AmPOC
    BcAmPOC::Vector{T} = BcAmPOC
    BcCmPOC::Vector{T} = BcCmPOC
    Ngrid::Int64 = Ngrid
    k_POC::T = k_POC
end
end
