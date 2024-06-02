
using SedTrace

modeldirectory = @__DIR__
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

# initial values
C0 = Param.C0;
# initalize parameters
parm = Param.ParamStruct();
# initialize cache and ODE function
OdeFun = Cache.init(C0, parm.Ngrid);
# initialize Jacobian 
JacPrototype = JacType(Param.IDdict);


TestOdeFun(OdeFun,C0,parm)
TestJacobian(JacPrototype,OdeFun,C0,parm)
BenchmarkReactran(OdeFun,C0,parm)
BenchmarkJacobian(JacPrototype,OdeFun,C0,parm)
BenchmarkPreconditioner(JacPrototype,OdeFun,C0,parm,:ILU)

# configure the solver
solverconfig = SolverConfig(:GMRES, :ILU0, 2)



solutionconfig = SolutionConfig(
    C0,
    (0.0, 1E6),
    reltol = 1e-6,
    abstol = 1e-12,
    saveat = 100.0,
    callback = TerminateSteadyState(1e-16, 1e-6),
);



solution = modelrun(OdeFun, parm, JacPrototype, solverconfig, solutionconfig);

gr(; size = (400, 800))

generate_output(
    modelconfig,
    solution,
    parm,
    site = ["analytical"],
    showplt = true,
)


