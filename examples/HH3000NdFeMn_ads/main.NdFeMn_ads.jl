
using SedTrace
using JLD2
using Sundials, SciMLBase,MKL
using Plots
gr(size = (400, 1000))
set_zero_subnormals(true)

modeldirectory = (@__DIR__) * "\\"
modelfile = "model_config.HH3000NdFeMn_ads.xlsx"
modelname = "HH3000NdMnFe_ads"

modelconfig = ModelConfig(
    modeldirectory,
    modelfile,
    modelname,
    UpdateParamOnly = true,
    JacType = :sparse_banded,
    Template = true,
    AutoDiff = true,
    CompleteFlux = false,
)

chunk_size = 12;

solverconfig = SolverConfig(chunk_size, :FGMRES)


ParamDict = Dict(
    "KNd_ads_Mn" => 0.0,
    "KNd_ads_Fe" => 0.0,
    "a" => 80.0,
    "nu" => 0.125,
    "Dbt0" => 2.0,
    "xbt" => 5.0,
    "xbir" => 2.5,
    "KMn_ads_Mn" => 0.0,
    "KMn_ads_Fe" => 0.0,
    "KFe_ads_Mn" => 0.0,
    "KFe_ads_Fe" => 0.0,
    "DNdMn" => 0.05,
    "DNdFe" => 0.01,
    # "kMnO2Fe" => 1e7,
    "kFeOOHH2S" => 1.0,
    # "kFeSpre" => 1e7,
    "kMnCO3pre" => 0.0,
    "kFeCO3pre" => 0.0
)

@time generate_code(modelconfig, ParamDict)

IncludeFiles(modelconfig)

JacPrototype = SedTrace.JacType();

ForwardDiff.pickchunksize(maximum(matrix_colors(JacPrototype)))

OdeFun = SedTrace.Cache.init(SedTrace.C_uni, SedTrace.Ngrid, Val(chunk_size));
solver = generate_ODESolver(OdeFun, JacPrototype, solverconfig);
OdeFunction = generate_ODEFun(OdeFun, JacPrototype, solverconfig);

# TestJacobian(JacPrototype,OdeFun,chunk_size)
# BenchmarkReactran(OdeFun,SedTrace.C_uni)
# BenchmarkJacobian(JacPrototype,OdeFun,chunk_size)
# BenchmarkPreconditioner(JacPrototype,OdeFun,chunk_size)

solution = load("sol.$modelname.jld2", "solution");

solverctrlconfig = SolverCtrlConfig(
    SedTrace.C_uni,
    # solution.sol[end],
    (0.0, 30000.0),
    reltol = 1e-6,
    abstol = 1e-18,
    saveat = 1000.0,
    callback = TerminateSteadyState(1e-12, 1e-6, DiffEqCallbacks.allDerivPass),
    maxiters = Int(1e6)
);


@time solution = modelrun(OdeFunction, solver, solverctrlconfig);


vars = [
    "POC",
    "Age",
    "MnO2",
    "Mn",
    # "Mn_ads",
    "FeOOH",
    "Fe",
    # "Fe_ads",
    "Nd_pw",
    "eNd_pw",
    "TH3PO4",
    "SO4",
    # "MnCO3",
    # "FeCO3",
    "PIC",
    "Nd_auth",
    "Nd_MnO2",
    "Nd_FeOOH",
    "TH2S"
];

generate_substance_plot(modelconfig, solution, ["HH3000"], vars)


generate_aux_plot(modelconfig, solution, ["HH3000"], ["RFeOOHPOC","RO2Fe","RO2Fe_ads","RO2FeS","RNO3Fe","RMnO2Fe","RFeOOHH2S"])

generate_aux_plot(modelconfig, solution, ["HH3000"],["Fe"])


jldsave("sol.$modelname.jld2"; solution)
