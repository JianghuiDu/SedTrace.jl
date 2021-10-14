module SedTrace

using Reexport
using SciMLBase
using Sundials

@reexport using SparseDiffTools
@reexport using FastBroadcast
@reexport using PreallocationTools

@reexport using SparseArrays
@reexport using BandedMatrices
@reexport using LinearAlgebra
using ILUZero


@reexport using Chain
using DataFrames
using DataFramesMeta
@reexport using XLSX
using Printf
using JuliaFormatter
using DataStructures

@reexport using Plots
using Plots.PlotMeasures
@reexport using StatsPlots

using RCall
using Conda
using SymPy

# using CSV

@reexport using DiffEqCallbacks
# using DiffEqOperators
# using Preconditioners
# using FiniteDiff
@reexport using ForwardDiff
@reexport using SpecialFunctions



include("config.jl")
include("generate_code.jl")
include("generate_jacobian.jl")
include("generate_preconditioner.jl")
include("generate_problem.jl")
include("fvcf_discretization.jl")

include("helpers.jl")
include("pH_helpers.jl")
include("moleculardiff.jl")
include("identify_parameters.jl")
include("generate_reaction.jl")
include("generate_transport.jl")
include("generate_parameter.jl")
include("generate_parameter_template.jl")
include("generate_struct.jl")
include("generate_initval.jl")
include("generate_jacprototype.jl")
include("generate_output.jl")

using .CodeGeneration: generate_code

function IncludeFiles(modelconfig::ModelConfig)
        
    include(modelconfig.ModelDirectory*"parm."*modelconfig.ModelName*".jl");
    include(modelconfig.ModelDirectory*"cache."*modelconfig.ModelName*".jl");
    include(modelconfig.ModelDirectory*"reactran."*modelconfig.ModelName*".jl"); # ode
    include(modelconfig.ModelDirectory*"jactype."*modelconfig.ModelName*".jl"); # ode
    return nothing
end

const ⊕ = +
const ⊗ = *

export ⊕, ⊗


export SolverConfig, ModelConfig

export generate_code
export modelrun
export generate_jacobian

export fvcf_bc,fvcf

export generate_output

export IncludeFiles

end
