module SedTrace

using SciMLBase
using Sundials
using DiffEqCallbacks
using PreallocationTools
using DiffEqOperators
# using Preconditioners
using ILUZero
using FiniteDiff
using ForwardDiff
using SpecialFunctions
using LinearAlgebra
using SparseArrays
using SparseDiffTools
using BandedMatrices
using FastBroadcast
using DataFramesMeta
using DataFrames
using XLSX
using Plots
using StatsPlots
using JuliaFormatter

export generate_code
export modelrun
include("config.jl")
include("generate_code.jl")
include("generate_jacobian.jl")
include("generate_preconditioner.jl")
include("generate_problem.jl")

end
