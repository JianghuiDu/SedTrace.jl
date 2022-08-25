
using SedTrace
using JLD2

modeldirectory = (@__DIR__)*"\\"
modelfile = "model_config.SBB.xlsx"
modelname = "SBB"

modelconfig = ModelConfig(
    modeldirectory,
    modelfile,
    modelname,
    UpdateParamOnly = false,
    JacType = :sparse_banded,
    Template = true,
    AutoDiff = true,
    CompleteFlux = false,
)

@time generate_code(modelconfig)

IncludeFiles(modelconfig)

JacPrototype = SedTrace.JacType()

# ForwardDiff.pickchunksize(maximum(matrix_colors(JacPrototype)))
# chunk_size = 10;

solverconfig = SolverConfig(chunk_size, :GMRES)

OdeFun = SedTrace.Cache.init(SedTrace.C_uni, SedTrace.Ngrid, Val(chunk_size));
solver = generate_ODESolver(OdeFun, JacPrototype, solverconfig);
OdeFunction = generate_ODEFun(OdeFun, JacPrototype, solverconfig);


# TestJacobian(JacPrototype,OdeFun,chunk_size)
# BenchmarkReactran(OdeFun,SedTrace.C_uni)
# BenchmarkJacobian(JacPrototype,OdeFun,chunk_size)
# BenchmarkPreconditioner(JacPrototype,OdeFun,chunk_size)



solverctrlconfig = SolverCtrlConfig(
    # SedTrace.C_uni,
    solution.sol[end],
    (0.0, 3000.0),
    reltol = 1e-6,
    abstol = 1e-18,
    saveat = 100.0,
    callback = TerminateSteadyState(1e-16, 1e-6, DiffEqCallbacks.allDerivPass),
    maxiters = Int(1e6),
    # dtmax = 0.1
);

outputconfig = OutputConfig(SedTrace.x, SedTrace.L, SedTrace.Ngrid, SedTrace.IDdict);


@time solution = modelrun(OdeFunction, solver, solverctrlconfig, outputconfig);

gr(; size = (400, 1000))

generate_substance_plot(
    modelconfig,
    solution,
    ["SBB"],
    showplt = true,
)


