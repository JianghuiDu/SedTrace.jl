module SedTrace

using Reexport
using SciMLBase,OrdinaryDiffEq
using Sundials
using Dierckx
@reexport using BenchmarkTools

@reexport using SparseDiffTools
@reexport using FastBroadcast
@reexport using PreallocationTools

@reexport using SparseArrays
@reexport using BandedMatrices
@reexport import LinearAlgebra:Tridiagonal,mul!,ldiv!
using ILUZero


@reexport using Chain
using DataFrames
using DataFramesMeta
@reexport using XLSX
import Printf:@sprintf
import JuliaFormatter:format_file
import DataStructures:OrderedDict

@reexport import Plots:plot,contour,plot!,grid,gr,savefig
@reexport import Plots.PlotMeasures:mm
@reexport import StatsPlots:@df

using RCall
# import SymPy:simplify,solve,nsimplify,sympify,symbols
import SymPy
# using CSV

@reexport using DiffEqCallbacks
# using DiffEqOperators
# using Preconditioners
# using FiniteDiff
@reexport using ForwardDiff
@reexport using SpecialFunctions

using Parameters, UnPack
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


export SolverConfig, ModelConfig, SolutionConfig,SolverCtrlConfig,OutputConfig

export generate_code,generate_ODESolver,generate_ODEFun,generate_parameter_template
export modelrun
export generate_jacobian

export fvcf_bc,fvcf

export generate_substance_plot,generate_aux_plot,calc_flux_top

export IncludeFiles

export TestOdeFun
export TestJacobian
export BenchmarkJacobian
export BenchmarkPreconditioner
export BenchmarkReactran
end
