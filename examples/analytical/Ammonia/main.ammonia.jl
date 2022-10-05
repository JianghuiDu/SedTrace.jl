
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

# @time generate_parameter_template(modelconfig)

@time generate_code(modelconfig)

IncludeFiles(modelconfig)

chunk_size = 10;

C0 = SedTrace.Param.C0;
parm = SedTrace.Param.ParamStruct();
RHSFun = SedTrace.Cache.init(C0, SedTrace.Param.Ngrid, chunk_size);
JacPrototype = SedTrace.JacType(SedTrace.Param.IDdict,SedTrace.Param.Ngrid,SedTrace.Param.nspec)
solverconfig = SolverConfig(chunk_size, :GMRES,:ILU0,1);
solver = generate_ODESolver(RHSFun, JacPrototype, solverconfig,parm);
OdeFunction = generate_ODEFun(RHSFun, JacPrototype, solverconfig);
outputconfig = OutputConfig(SedTrace.Param.x, SedTrace.Param.L, SedTrace.Param.Ngrid, SedTrace.Param.IDdict);




# TestOdeFun(RHSFun,C0,parm)
# TestJacobian(JacPrototype,RHSFun,chunk_size,parm)
# BenchmarkReactran(RHSFun,C0,parm)
# BenchmarkJacobian(JacPrototype,RHSFun,chunk_size,parm)
# BenchmarkPreconditioner(JacPrototype,RHSFun,chunk_size,parm)



solverctrlconfig = SolverCtrlConfig(
    C0,
    # solution.sol[end],
    (0.0, 1E5),
    reltol = 1e-6,
    abstol = 1e-12,
    saveat = 100.0,
    callback = TerminateSteadyState(1e-16, 1e-6, DiffEqCallbacks.allDerivPass),
);



@time solution = modelrun(OdeFunction, parm, solver, solverctrlconfig, outputconfig);

gr(; size = (400, 800))

generate_substance_plot(
    modelconfig,
    solution,
    ["analytical"],
    showplt = true,
)
