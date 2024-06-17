using MKL
using SedTrace
# set_zero_subnormals(true)

modeldirectory = @__DIR__
modelfile = "model_config.OregonNd.xlsx"
modelname = "OregonNd"

modelconfig = ModelConfig(
    modeldirectory,
    modelfile,
    modelname,
)

EnableList = Dict(
    "substances" => ["Basalt", "Illite"],
    "parameters" => [
        "Basalt0",
        "FBasalt0",
        "KspBasalt",
        "kBasalt",
        "rNdSi_lith",
        "rNdnrSi_lith",
        "rNdrSi_lith",
        "eNd_lith",
        "Illite0",
        "FIllite0",
        "KspIllite",
        "kIllite",
        "rAlSi",
        "MIllite",
        "MBasalt",
        "a_lith0"
    ],
    "reactions" => ["RBasalt_dis", 
    "RBasalt_dis_Nd", 
    "RIllite_pre"
    ],
    "output" => ["Basalt","Illite",    
    "Nd_auth_copre",
    "eNd_auth_copre",
    "Nd_MnO2_copre",
    "Nd_FeOOH_copre",
    "eNd_MnO2_copre",
    "eNd_FeOOH_copre",
    "Nd_leach_basalt",
    "eNd_leach_basalt",
    "Omega_basalt",
    "Omega_illite",
    "Nd_Basalt"
]
)

ParamDict = Dict(
    "Basalt0" => 2,
    "a_lith0" =>  1e1,
    "rNdSi_lith" =>1.9e-5,
    "Ngrid" => 300
)


@time generate_parameter_template(modelconfig,EnableList=EnableList)


@time generate_code(modelconfig,ParamDict=ParamDict, EnableList=EnableList)


IncludeFiles(modelconfig)

# initial values
C0 = Param.C0;
C0 = ifelse.(C0.==0.0,1e-9,C0);
# initalize parameters
parm = Param.ParamStruct();
# initialize cache and ODE function
OdeFun = Cache.init(C0, parm.Ngrid);
# initialize Jacobian 
JacPrototype = JacType(SedTrace.Param.IDdict);

# test the ODE function
TestOdeFun(OdeFun, C0, parm)
# test if the Jacobian is correct
TestJacobian(JacPrototype, OdeFun, C0, parm)
# benchmark the ODE function performance
BenchmarkReactran(OdeFun, C0, parm)
# benchmark the Jacobian performance
BenchmarkJacobian(JacPrototype, OdeFun, C0, parm)
# benchmark the preconditioner performance
BenchmarkPreconditioner(JacPrototype, OdeFun, C0, parm,:ILU0)

# configure the solver

# load previous model output as the initial values
sol = load(joinpath(modeldirectory,"sol.$modelname.jld2"), "sol");
# configure the solution
solutionconfig = SolutionConfig(
    # C0,
    sol,
    # solution.sol[end],
    (0.0, 1E6),
    reltol = 1e-8,
    abstol = 1e-16,
    saveat = 1000.0,
    callback = TerminateSteadyState(1e-16, 1e-6),
);

solverconfig = SolverConfig(:GMRES, :ILU, 2)

# run the model
@time solution = modelrun(OdeFun, parm, JacPrototype, solverconfig, solutionconfig);


gr(; size = (400, 650))

generate_output(
    modelconfig,
    solution,
    parm,
    site = ["HH3000"],
    EnableList = EnableList,
    showplt = true,
)

jldsave(joinpath(modeldirectory,"sol.$modelname.jld2"); sol = solution.sol[end])
