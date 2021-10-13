module SedTrace

using SciMLBase
using Sundials

using SparseDiffTools
# using FastBroadcast
using PreallocationTools

using SparseArrays
using BandedMatrices
using LinearAlgebra
using ILUZero


using Chain
using DataFrames
using DataFramesMeta
using XLSX
using Printf
using JuliaFormatter

using Plots
using StatsPlots

using RCall
using Conda
using SymPy


# using DiffEqCallbacks
# using DiffEqOperators
# using Preconditioners
# using FiniteDiff
# using ForwardDiff
# using SpecialFunctions

# using DataFramesMeta
# using DataFrames
# using XLSX

export SolverConfig, ModelConfig

export generate_code
export modelrun
export generate_jacobian

export fvcf_bc,fvcf

export generate_output

include("config.jl")
include("generate_code.jl")
include("generate_jacobian.jl")
include("generate_preconditioner.jl")
include("generate_problem.jl")
include("fvcf_discretization.jl")

include("helpers.jl")
include("pH_helpers.jl")
include("moleculardiff.jl")

include("generate_reaction.jl")
include("generate_transport.jl")
include("generate_parameter.jl")
include("generate_parameter_template.jl")
include("generate_struct.jl")
include("generate_initval.jl")
include("generate_jacprototype.jl")
include("generate_output.jl")

const ⊕ = +
const ⊗ = *

export ⊕, ⊗

end
