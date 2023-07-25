
using SedTrace

modeldirectory = @__DIR__
modelfile = "model_config.pHBB1991.xlsx"
modelname = "pHBB1991.uniform"

modelconfig = ModelConfig(modeldirectory, modelfile, modelname)

# compute the analytical solution
include("analytical.solution.pHBB1991.jl")

@time generate_parameter_template(modelconfig)

# uniform grid

ParamDict = Dict(
    "kOS" => "82.",
    "gridtran"=>"x-0.05",
    "Ngrid" => 100
)

@time generate_code(modelconfig, ParamDict = ParamDict)

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
BenchmarkPreconditioner(JacPrototype,OdeFun,C0,parm,:ILU0)

# configure the solver

solutionconfig = SolutionConfig(
    C0,
    (0.0, 3000.0),
    reltol = 1e-6,
    abstol = 1e-18,
    saveat = 100.0,
    callback = TerminateSteadyState(1e-18, 1e-6, DiffEqCallbacks.allDerivPass),
);

solverconfig = SolverConfig(:GMRES, :ILU, 2)

solution = modelrun(OdeFun, parm, JacPrototype, solverconfig, solutionconfig);

gr(; size = (400, 650))

generate_output(modelconfig, solution, site=["JR"], showplt = true,ylim=(-0.1,0.2))

pHError(Param,modelconfig)


# uniform grid 2x
modelname = "pHBB1991.uniform2x"

modelconfig = ModelConfig(modeldirectory, modelfile, modelname)

ParamDict = Dict(
    "kOS" => "82.",
    "gridtran"=>"x-0.05",
    "Ngrid" => 200
)

@time generate_code(modelconfig, ParamDict = ParamDict)

IncludeFiles(modelconfig)


# initial values
C0 = Param.C0;
# initalize parameters
parm = Param.ParamStruct();
# initialize cache and ODE function
OdeFun = Cache.init(C0, parm.Ngrid);
# initialize Jacobian 
JacPrototype = JacType(Param.IDdict);


solutionconfig = SolutionConfig(
    C0,
    # solution.sol[end],
    (0.0, 3000.0),
    reltol = 1e-6,
    abstol = 1e-18,
    saveat = 100.0,
    callback = TerminateSteadyState(1e-18, 1e-6, DiffEqCallbacks.allDerivPass),
);


solution = modelrun(OdeFun, parm, JacPrototype, solverconfig, solutionconfig);

gr(; size = (400, 650))

generate_output(modelconfig, solution, site=["JR"], showplt = true,ylim=(-0.1,0.2))


pHError(Param,modelconfig)


# non-uniform grid
modelname = "pHBB1991.nonuniform"

modelconfig = ModelConfig(modeldirectory, modelfile, modelname)

ParamDict = Dict(
    "kOS" => "82.",
    "a"=>1e4,
    "b" => 3.5,
    "Ngrid" => 100
)

@time generate_code(modelconfig, ParamDict = ParamDict)

IncludeFiles(modelconfig)


# initial values
C0 = Param.C0;
# initalize parameters
parm = Param.ParamStruct();
# initialize cache and ODE function
OdeFun = Cache.init(C0, parm.Ngrid);
# initialize Jacobian 
JacPrototype = JacType(Param.IDdict);


solutionconfig = SolutionConfig(
    C0,
    # solution.sol[end],
    (0.0, 3000.0),
    reltol = 1e-6,
    abstol = 1e-18,
    saveat = 100.0,
    callback = TerminateSteadyState(1e-18, 1e-6, DiffEqCallbacks.allDerivPass),
);


solution = modelrun(OdeFun, parm, JacPrototype, solverconfig, solutionconfig);

gr(; size = (400, 650))

generate_output(modelconfig, solution, site=["JR"], showplt = true,ylim=(-0.1,0.2))


pHError(Param,modelconfig)



# non-uniform 2x grid
modelname = "pHBB1991.nonuniform2x"

modelconfig = ModelConfig(modeldirectory, modelfile, modelname)

ParamDict = Dict(
    "kOS" => "82.",
    "a"=>1e4,
    "b" => 3.5,
    # "gridtran"=>"x-0.05",
    "Ngrid" => 200
)

@time generate_code(modelconfig, ParamDict = ParamDict)

IncludeFiles(modelconfig)


# initial values
C0 = Param.C0;
# initalize parameters
parm = Param.ParamStruct();
# initialize cache and ODE function
OdeFun = Cache.init(C0, parm.Ngrid);
# initialize Jacobian 
JacPrototype = JacType(Param.IDdict);


solutionconfig = SolutionConfig(
    C0,
    # solution.sol[end],
    (0.0, 3000.0),
    reltol = 1e-6,
    abstol = 1e-18,
    saveat = 100.0,
    callback = TerminateSteadyState(1e-18, 1e-6, DiffEqCallbacks.allDerivPass),
);


solution = modelrun(OdeFun, parm, JacPrototype, solverconfig, solutionconfig);

gr(; size = (400, 650))

generate_output(modelconfig, solution, site=["JR"], showplt = true,ylim=(-0.1,0.2))


pHError(Param,modelconfig)
