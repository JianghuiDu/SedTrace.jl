
set_zero_subnormals(true)
cd(@__DIR__)
pwd()
# using SpecialFunctions
# using FastBroadcast
# using SparseArrays
# using ForwardDiff,SparseDiffTools
# using BandedMatrices
# using DiffEqCallbacks
# using PreallocationTools
# using Plots, StatsPlots
# using LinearAlgebra
# using Chain
BLAS.set_num_threads(8)
gr(; size = (400, 1000))

# include("config.jl")
# include("generate_code.jl")
# include("generate_jacobian.jl")
# include("generate_preconditioner.jl")
# include("generate_problem.jl")


input_path = (@__DIR__)*"\\examples\\model_config.HH3000.workingversionnew.xlsx"
modelname = "HH3000"
modelconfig = ModelConfig(
    input_path,
    modelname,
    UpdateParamOnly = false,
    JacType = :sparse_banded,
    Template = false,
    AutoDiff = true,
    CompleteFlux = false,
)

generate_code(modelconfig)


include("parm.$modelname.jl");
include("cache.$modelname.jl");
include("reactran.$modelname.jl"); # ode
include("jactype.$modelname.jl"); # ode

JacPrototype = JacType();

ForwardDiff.pickchunksize(maximum(matrix_colors(JacPrototype)))

chunk_size = 12;

OdeFun = Cache.init(zeros(Nmat), Ngrid, Val(chunk_size));

solverconfig = SolverConfig(
    chunk_size,
    C_uni,
    (0.0, 30.0),
    :LapackBand,
    reltol = 1e-6,
    abstol = 1e-16,
    saveat = 1000.0,
    callback = TerminateSteadyState(1e-8, 1e-6, DiffEqCallbacks.allDerivPass),
)


sol = modelrun(OdeFun,JacPrototype,solverconfig);



generate_output(input_path,sol,["HH3000"],L, true)

IDdict,["POC","Mn"],
