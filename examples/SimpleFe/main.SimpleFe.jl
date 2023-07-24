
using SedTrace

# model configuration
modeldirectory = (@__DIR__) * "\\"
modelfile = "model_config.SimpleFe.xlsx"
modelname = "SimpleFe"
modelconfig = ModelConfig(modeldirectory, modelfile, modelname)

# generate a parameter sheet template
@time generate_parameter_template(modelconfig)
# generate model code
@time generate_code(modelconfig)
# load model code files
IncludeFiles(modelconfig)

# initial values
C0 = Param.C0;
# initialize  parameters
parm = Param.ParamStruct();
# initialize cache and ODE function
OdeFun = Cache.init(C0, parm.Ngrid);
# initialize Jacobian 
JacPrototype = JacType(Param.IDdict);


# test the ODE function
TestOdeFun(OdeFun, C0, parm)
# test if the Jacobian is correct
TestJacobian(JacPrototype, OdeFun, C0,parm)
# benchmark the ODE function performance
BenchmarkReactran(OdeFun, C0, parm)
# benchmark the Jacobian performance
BenchmarkJacobian(JacPrototype, OdeFun, C0,parm)
# benchmark the preconditioner performance
BenchmarkPreconditioner(JacPrototype, OdeFun, C0,parm,:ILU0)

# configure the solver
solverconfig = SolverConfig(:GMRES, :ILU0, 2)

# configure the solution
solutionconfig = SolutionConfig(
    C0, # inital values
    # solution,
    (0.0, 3000.0), # time span
    reltol = 1e-6, # relative tolerance
    abstol = 1e-18, # absolute tolerance
    saveat = 100.0, # save time steps
    callback = TerminateSteadyState(1e-16, 1e-6),
    # terminate when steady state is reached
);

# run the model
solution = modelrun(OdeFun, parm, JacPrototype, solverconfig, solutionconfig);

gr(size = (400, 800))
# generate output and plot
generate_output(modelconfig, solution,site=[], showplt = true,saveplt=true)

