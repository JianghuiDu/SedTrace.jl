module SedTrace

using Reexport
using SciMLBase,OrdinaryDiffEq,Sundials
# using DiffEqOperators
using ODEInterfaceDiffEq #,LSODA
using Dierckx
# using Krylov,LinearSolve
using ILUZero,IncompleteLU
# using AlgebraicMultigrid,Preconditioners
# Base.eltype(::IncompleteLU.ILUFactorization{Tv,Ti}) where {Tv,Ti} = Tv
# Base.eltype(::AlgebraicMultigrid.Preconditioner) = Float64

# using BandedMatrices
@reexport using DiffEqCallbacks
@reexport using ForwardDiff
using Preferences
set_preferences!(ForwardDiff, "nansafe_mode" => true)

@reexport using BenchmarkTools
@reexport using SparseDiffTools,FiniteDiff
@reexport using FastBroadcast
@reexport using PreallocationTools
@reexport using SparseArrays
@reexport import LinearAlgebra:Tridiagonal,mul!,ldiv!,I


@reexport using DataFrames
@reexport using DataFramesMeta
@reexport using XLSX
@reexport using DelimitedFiles
@reexport using Chain
import Printf:@sprintf
import JuliaFormatter:format_file
@reexport using SpecialFunctions

@reexport import Plots:plot,contour,plot!,grid,gr,savefig
@reexport import Plots.PlotMeasures:mm
@reexport import StatsPlots:@df

import SymPy

using Parameters, UnPack, OrderedCollections
using JLD2, Interpolations

# heaviside(x::Float64) = ifelse(x>= 0.0, 1.0, 0.0)

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
include("generate_plot.jl")
include("parsing_jacobian.jl")
include("generate_parameter_struct.jl")
include("preprocessing.jl")
include("speciation_code.jl")
include("benchmark.jl")

using .CodeGeneration: generate_code
using .TemplateGeneration: generate_parameter_template

function IncludeFiles(modelconfig::ModelConfig)
    if modelconfig.AssembleParam
        include(modelconfig.ModelDirectory*"parm.struct."*modelconfig.ModelName*".jl");
        include(modelconfig.ModelDirectory*"cache."*modelconfig.ModelName*".jl");
        include(modelconfig.ModelDirectory*"reactran."*modelconfig.ModelName*".jl"); # ode
        include(modelconfig.ModelDirectory*"jactype."*modelconfig.ModelName*".jl"); # ode
    else
        include(modelconfig.ModelDirectory*"parm."*modelconfig.ModelName*".jl");
        include(modelconfig.ModelDirectory*"cache."*modelconfig.ModelName*".jl");
        include(modelconfig.ModelDirectory*"reactran."*modelconfig.ModelName*".jl"); # ode
        include(modelconfig.ModelDirectory*"jactype."*modelconfig.ModelName*".jl"); # ode
    end
    return nothing
end

const ⊕ = +
const ⊗ = *

export ⊕, ⊗

export Param,Cache
export SolverConfig, ModelConfig, SolutionConfig,OutputConfig

export generate_code,generate_parameter_template
export modelrun
# export generate_jacobian,generate_ODESolver,generate_ODEFun

export fvcf_bc,fvcf

# export generate_substance_plot,generate_aux_plot,calc_flux_top
export generate_output
export IncludeFiles
export JacType
export TestOdeFun
export TestJacobian
export BenchmarkJacobian
export BenchmarkPreconditioner
export BenchmarkReactran
end
