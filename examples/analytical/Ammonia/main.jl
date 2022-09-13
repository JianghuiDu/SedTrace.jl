using MKL
using SedTrace
using JLD2

modeldirectory = (@__DIR__)*"\\"
modelfile = "model_config.ammonia.xlsx" 
modelname = "ammonia"

modelconfig = ModelConfig(
    modeldirectory,
    modelfile,
    modelname,
)

@time generate_parameter_template(modelconfig)

@time generate_code(modelconfig)

IncludeFiles(modelconfig)


JacPrototype = SedTrace.JacType()

# ForwardDiff.pickchunksize(maximum(matrix_colors(JacPrototype)))
chunk_size = 10;
dCdtFun = SedTrace.Cache.init(SedTrace.C_uni, SedTrace.Ngrid, chunk_size);

dC = similar(SedTrace.C_uni);
dCdtFun(dC,SedTrace.C_uni,0,0)

solverconfig = SolverConfig(chunk_size, :GMRES,:ILU0,1)

solver = generate_ODESolver(dCdtFun, JacPrototype, solverconfig);
ModelFunction = generate_ODEFun(dCdtFun, JacPrototype, solverconfig);


# TestJacobian(JacPrototype,dCdtFun,chunk_size)
# BenchmarkReactran(dCdtFun,SedTrace.C_uni)
# BenchmarkJacobian(JacPrototype,dCdtFun,chunk_size)
# BenchmarkPreconditioner(JacPrototype,dCdtFun,chunk_size)



solverctrlconfig = SolverCtrlConfig(
    SedTrace.C_uni,
    # solution.sol[end],
    (0.0, 1E5),
    reltol = 1e-6,
    abstol = 1e-12,
    saveat = 100.0,
    callback = TerminateSteadyState(1e-16, 1e-6, DiffEqCallbacks.allDerivPass),
    maxiters = Int(1e6),
    # dtmax = 0.1
);

outputconfig = OutputConfig(SedTrace.x, SedTrace.L, SedTrace.Ngrid, SedTrace.IDdict);


@time solution = modelrun(ModelFunction, solver, solverctrlconfig, outputconfig);

gr(; size = (400, 1000))

generate_substance_plot(
    modelconfig,
    solution,
    ["SBB"],
    showplt = true,
)
