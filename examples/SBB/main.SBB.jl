using MKL
using SedTrace
using JLD2

modeldirectory = (@__DIR__)*"\\"
modelfile = "model_config.SBB.xlsx"
modelname = "SBB"

modelconfig = ModelConfig(
    modeldirectory,
    modelfile,
    modelname,
)

ParamList = Dict(
    "rPC" => 0.015,
    "kCFA_pre" =>1.5e-8,
    "THFBW" => 75e-6,
    "TH3PO4BW" => 20e-6
)

@time generate_parameter_template(modelconfig)

@time generate_code(modelconfig,ParamDict=ParamList)

IncludeFiles(modelconfig)


chunk_size = 10;

C0 = SedTrace.Param.C0;
parm = SedTrace.Param.ParamStruct();
OdeFun = SedTrace.Cache.init(C0, SedTrace.Param.Ngrid, chunk_size);
JacPrototype = SedTrace.JacType(SedTrace.Param.IDdict,SedTrace.Param.Ngrid,SedTrace.Param.nspec)
solverconfig = SolverConfig(chunk_size, :GMRES)
solver = generate_ODESolver(OdeFun, JacPrototype, solverconfig,parm);
OdeFunction = generate_ODEFun(OdeFun, JacPrototype, solverconfig);
outputconfig = OutputConfig(SedTrace.Param.x, SedTrace.Param.L, SedTrace.Param.Ngrid, SedTrace.Param.IDdict);




TestOdeFun(OdeFun,C0,parm)
TestJacobian(JacPrototype,OdeFun,chunk_size,parm)
BenchmarkReactran(OdeFun,C0,parm)
BenchmarkJacobian(JacPrototype,OdeFun,chunk_size,parm)
BenchmarkPreconditioner(JacPrototype,OdeFun,chunk_size,parm)



solverctrlconfig = SolverCtrlConfig(
    C0,
    # solution.sol[end],
    (0.0, 50000.0),
    reltol = 1e-6,
    abstol = 1e-22,
    saveat = 100.0,
    callback = TerminateSteadyState(1e-16, 1e-6, DiffEqCallbacks.allDerivPass),
);



@time solution = modelrun(OdeFunction, parm, solver, solverctrlconfig, outputconfig);

gr(; size = (400, 650))

generate_substance_plot(
    modelconfig,
    solution,
    ["SBB"],
    showplt = true,
)


output = DataFrame(XLSX.readtable("SBB_output.xlsx","outputProfile"))

var = ["POC","FeS","FeS2","O2","NO3","Mn","Fe","Ca","NH4","SO4","TCO2","TH2S","PIC","TA"]

