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
    "Basalt0" => 2,
    "a_lith0" =>  1e5,
    "rNdSi_lith" =>1.9e-5
)


# @time generate_parameter_template(modelconfig)


# @time generate_code(modelconfig,ParamDict=ParamDict, EnableList=EnableList)


IncludeFiles(modelconfig)

# ForwardDiff.pickchunksize(maximum(matrix_colors(JacPrototype)))
chunk_size = 10;

C0 = SedTrace.Param.C0;
parm = SedTrace.Param.ParamStruct();
OdeFun = SedTrace.Cache.init(C0, SedTrace.Param.Ngrid, chunk_size);
JacPrototype = SedTrace.JacType(SedTrace.Param.IDdict,SedTrace.Param.Ngrid,SedTrace.Param.nspec)
solverconfig = SolverConfig(chunk_size, :GMRES,:ILU0,2)
solver = generate_ODESolver(OdeFun, JacPrototype, solverconfig,parm);
OdeFunction = generate_ODEFun(OdeFun, JacPrototype, solverconfig);
outputconfig = OutputConfig(SedTrace.Param.x, SedTrace.Param.L, SedTrace.Param.Ngrid, SedTrace.Param.IDdict);


# TestOdeFun(OdeFun,C0,parm)
# TestJacobian(JacPrototype,OdeFun,chunk_size,parm)
# BenchmarkReactran(OdeFun,C0,parm)
# BenchmarkJacobian(JacPrototype,OdeFun,chunk_size,parm)
# BenchmarkPreconditioner(JacPrototype,OdeFun,chunk_size,parm)

solution = load("sol.$modelname.jld2", "sol");

solverctrlconfig = SolverCtrlConfig(
    C0,
    # solution.sol[end],
    (0.0, 1E6),
    reltol = 1e-6,
    abstol = 1e-18,
    saveat = 1000.0,
    callback = TerminateSteadyState(1e-16, 1e-6, DiffEqCallbacks.allDerivPass),
);

@time solution = modelrun(OdeFunction, parm, solver, solverctrlconfig, outputconfig);

gr(; size = (400, 650))


generate_substance_plot(
    modelconfig,
    solution,
    ["HH3000"],
    EnableList = EnableList,
    showplt = true,
)

jldsave("sol.$modelname.jld2"; sol = solution)

ParamDict = Dict(
    "Basalt0" => 2,
    "a_lith0" =>  1e1,
    "rNdSi_lith" =>1.9e-5
)


@time generate_code(modelconfig,ParamDict=ParamDict, EnableList=EnableList)


IncludeFiles(modelconfig)

# ForwardDiff.pickchunksize(maximum(matrix_colors(JacPrototype)))
chunk_size = 10;

C0 = SedTrace.Param.C0;
parm = SedTrace.Param.ParamStruct();
OdeFun = SedTrace.Cache.init(C0, SedTrace.Param.Ngrid, chunk_size);
JacPrototype = SedTrace.JacType(SedTrace.Param.IDdict,SedTrace.Param.Ngrid,SedTrace.Param.nspec)
solverconfig = SolverConfig(chunk_size, :GMRES,:ILU0,2)
solver = generate_ODESolver(OdeFun, JacPrototype, solverconfig,parm);
OdeFunction = generate_ODEFun(OdeFun, JacPrototype, solverconfig);
outputconfig = OutputConfig(SedTrace.Param.x, SedTrace.Param.L, SedTrace.Param.Ngrid, SedTrace.Param.IDdict);



solverctrlconfig = SolverCtrlConfig(
    solution.sol[end],
    (0.0, 1E6),
    reltol = 1e-6,
    abstol = 1e-18,
    saveat = 1000.0,
    callback = TerminateSteadyState(1e-16, 1e-6, DiffEqCallbacks.allDerivPass),
);

@time solution = modelrun(OdeFunction, parm, solver, solverctrlconfig, outputconfig);

generate_substance_plot(
    modelconfig,
    solution,
    ["HH3000"],
    EnableList = EnableList,
    showplt = true,
)

jldsave("sol.$modelname.jld2"; sol = solution)








using SpecialFunctions,UnPack
include(modelconfig.ModelDirectory*"parm.OregonNd.jl")
include(modelconfig.ModelDirectory*"parm.struct.OregonNd.jl")
include(modelconfig.ModelDirectory*"cache.OregonNd.jl")
include(modelconfig.ModelDirectory*"reactran.OregonNd.jl")
include(modelconfig.ModelDirectory*"jactype.OregonNd.jl")

chunk_size = 10;

C0 = Param.C0;
parm = Param.ParamStruct();
OdeFun = Cache.init(C0, Param.Ngrid, chunk_size);
JacPrototype = JacType(Param.IDdict,Param.Ngrid,Param.nspec)
solverconfig = SolverConfig(chunk_size, :GMRES,:ILU0,2)
solver = generate_ODESolver(OdeFun, JacPrototype, solverconfig,parm);
OdeFunction = generate_ODEFun(OdeFun, JacPrototype, solverconfig);
outputconfig = OutputConfig(Param.x, Param.L, Param.Ngrid, Param.IDdict);



using Random
Random.seed!(1234);
u0 = rand(length(C0));
du0 = similar(u0);
C = u0;
dC = du0;
SO4 = @view C[SO4ID]
dSO4 = @view dC[SO4ID]
mul!(dSO4, AmSO4, SO4)
dSO4[1] += BcAmSO4[1] * SO4[1] + BcCmSO4[1]
dSO4[Ngrid] += BcAmSO4[2] * SO4[Ngrid] + BcCmSO4[2]
@.. dSO4 += alpha * (SO4BW - SO4)



using Random
Random.seed!(1234);
u0 = rand(length(C0));
du0 = similar(u0);
OdeFun(du0,u0,parm,0)
using DelimitedFiles
writedlm("Mn_adso.txt",OdeFun.Mn_ads_Fe.du.+OdeFun.Mn_ads_Mn.du)
writedlm("duo.txt",du0)
