using MKL
using SedTrace

modeldirectory = @__DIR__
modelfile = "model_config.SBB.xlsx"
modelname = "SBB_case1"

modelconfig = ModelConfig(
    modeldirectory,
    modelfile,
    modelname,
)

EnableList = Dict("parameters"=>["kMo_rm1"],"reactions"=>["RMol_rm1","RMoh_rm1"])

@time generate_parameter_template(modelconfig,EnableList=EnableList)


ParamList = Dict(
    "rPC" => 0.015,
    "kCFA_pre" =>1.5e-8,
    "THFBW" => 75e-6,
    "TH3PO4BW" => 20e-6,
    "FMnO20" => 0.5e-2,
    "FFeOOH0" => 2.42e-2,
    # "kFeSH2S" => 1e2,
    "KFeOOH" =>	"450.0*ds_rho/1e3",
    # "kMoS4_pre" => 5e1,
    "pHL" => 8.0,
    "TCO2L" => 14e-3,
    "pHBW" => 7.6,
    "kMnO2Fe" =>1e6,
    "Ngrid" => 500
)

@time generate_code(modelconfig,ParamDict=ParamList,EnableList=EnableList)

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

sol = load(joinpath(modeldirectory,"sol.SBB_case1.jld2"),"sol");

solutionconfig = SolutionConfig(
    # C0,
    sol,
    # solution.sol[end],
    (0.0, 1000.0),
    reltol = 1e-6,
    abstol = 1e-18,
    saveat = 100.0,
    callback = TerminateSteadyState(1e-16, 1e-6),
);

solverconfig = SolverConfig(:GMRES, :ILU, 2)

solution = modelrun(OdeFun, parm, JacPrototype, solverconfig, solutionconfig);

gr(; size = (400, 650))

generate_output(
    modelconfig,
    solution,
    site = ["SBB"],
    showplt = true,
    saveplt=true,
    # vars = ["Mo_pw","Mo_sed"],
    EnableList = EnableList
    )

jldsave(joinpath(modeldirectory,"sol.$modelname.jld2"); sol = solution.sol[end])


modelname = "SBB_case2"

modelconfig = ModelConfig(
    modeldirectory,
    modelfile,
    modelname,
)

EnableList = Dict("parameters"=>["kMo_rm2"],"reactions"=>["RMol_rm2","RMoh_rm2"])

# @time generate_parameter_template(modelconfig)

@time generate_code(modelconfig,ParamDict=ParamList,EnableList=EnableList)

IncludeFiles(modelconfig)


# initial values
# C0 = Param.C0;
# initalize parameters
parm = Param.ParamStruct();
# initialize cache and ODE function
OdeFun = Cache.init(C0, parm.Ngrid);
# initialize Jacobian 
JacPrototype = JacType(Param.IDdict);


# TestOdeFun(OdeFun,C0,parm)
# TestJacobian(JacPrototype,OdeFun,parm)
# BenchmarkReactran(OdeFun,C0,parm)
# BenchmarkJacobian(JacPrototype,OdeFun,parm)
# BenchmarkPreconditioner(JacPrototype,OdeFun,parm)

# configure the solver
# solverconfig = SolverConfig(:GMRES, :ILU, 2)

# solution = load(joinpath(modeldirectory,"sol.SBB.jld2"),"sol");
solutionconfig = SolutionConfig(
    # C0,
    solution.sol[end],
    (0.0, 1000.0),
    reltol = 1e-6,
    abstol = 1e-18,
    saveat = 100.0,
    callback = TerminateSteadyState(1e-16, 1e-6),
);

solution = modelrun(OdeFun, parm, JacPrototype, solverconfig, solutionconfig);

gr(; size = (400, 650))

generate_output(
    modelconfig,
    solution,
    site = ["SBB"],
    showplt = true,
    saveplt=true,
    vars = ["Mo_pw","Mo_sed"],
    EnableList = EnableList
    )

jldsave(joinpath(modeldirectory,"sol.$modelname.jld2"); sol = solution.sol[end])


