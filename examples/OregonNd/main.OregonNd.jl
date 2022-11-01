using MKL
using SedTrace
using JLD2
# set_zero_subnormals(true)

modeldirectory = (@__DIR__)*"\\"
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
    "Basalt0" => 1,
    "a_lith0" =>  1e5,
    "rNdSi_lith" =>1.9e-5
)


# @time generate_parameter_template(modelconfig,EnableList=EnableList)


@time generate_code(modelconfig,ParamDict=ParamDict, EnableList=EnableList)


IncludeFiles(modelconfig)

# initial values
C0 = Param.C0;
# initalize parameters
parm = Param.ParamStruct();
# initialize cache and ODE function
OdeFun = Cache.init(C0, parm.Ngrid);
# initialize Jacobian 
JacPrototype = JacType(SedTrace.Param.IDdict);

# # test the ODE function
# TestOdeFun(OdeFun, C0, parm)
# # test if the Jacobian is correct
# TestJacobian(JacPrototype, OdeFun, parm)
# # benchmark the ODE function performance
# BenchmarkReactran(OdeFun, C0, parm)
# # benchmark the Jacobian performance
# BenchmarkJacobian(JacPrototype, OdeFun, parm)
# # benchmark the preconditioner performance
# BenchmarkPreconditioner(JacPrototype, OdeFun, parm)

# configure the solver
solverconfig = SolverConfig(:FGMRES, :ILU0, 2)

# solution = load("sol.$modelname.jld2", "sol");
# configure the solution
solutionconfig = SolutionConfig(
    C0,
    # solution,
    (0.0, 1E6),
    reltol = 1e-6,
    abstol = 1e-18,
    saveat = 1000.0,
    callback = TerminateSteadyState(1e-16, 1e-6),
);

# run the model
@time solution = modelrun(OdeFun, parm, JacPrototype, solverconfig, solutionconfig);


gr(; size = (400, 650))

generate_output(
    modelconfig,
    solution,
    site = "HH3000",
    EnableList = EnableList,
    showplt = true,
)

jldsave("sol.$modelname.jld2"; sol = solution.sol[end])


ParamDict = Dict(
    "Basalt0" => 2,
    "a_lith0" =>  1e1,
    "rNdSi_lith" =>1.9e-5
)


@time generate_code(modelconfig,ParamDict=ParamDict, EnableList=EnableList)

IncludeFiles(modelconfig)

parm = Param.ParamStruct();
OdeFun = Cache.init(C0, parm.Ngrid);

solutionconfig = SolutionConfig(
    solution.sol[end],
    (0.0, 1E6),
    reltol = 1e-6,
    abstol = 1e-18,
    saveat = 1000.0,
    callback = TerminateSteadyState(1e-16, 1e-6),
);

# run the model
@time solution = modelrun(OdeFun, parm, JacPrototype, solverconfig, solutionconfig);


generate_output(
    modelconfig,
    solution,
    site = "HH3000",
    EnableList = EnableList,
    showplt = true,
)

jldsave("sol.$modelname.jld2"; sol = solution.sol[end])

