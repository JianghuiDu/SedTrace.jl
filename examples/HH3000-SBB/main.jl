
using SedTrace
using JLD2
using Sundials, SciMLBase,MKL
using Plots
gr(size = (400, 1000))
set_zero_subnormals(true)

modeldirectory = (@__DIR__) * "\\"
modelfile = "model_config.Nd.xlsx"
modelname = "HH3000"

modelconfig = ModelConfig(
    modeldirectory,
    modelfile,
    modelname,
    UpdateParamOnly = false,
    JacType = :sparse_banded,
    Template = true,
    AutoDiff = true,
    CompleteFlux = false,
)

chunk_size = 10;

solverconfig = SolverConfig(chunk_size, :LapackBand)


ParamDict = Dict(
    "KNd_ads_Mn" => 0,
    "KNd_ads_Fe" => 0,#1e5,
    "a" => 50,
    "Dbt0" => 2.0,
    #"Dbir0"=>20.0,
    "xbt" => 2.0,
    "xbir" => 1.0,
    "FBasalt0" => "Fsed*0/100/87.383*1000",
    "aBasalt" => 1e6,
    "KMn_ads_Mn" => 1e4,#4.34,7e6,
    "KMn_ads_Fe" => 1e4,#1738.8,
    "KFe_ads_Mn" => 1e7,
    "KFe_ads_Fe" => 1e5,
    "DNdMn" => 0.01,
    "DNdFe" => 0.00,#0.0015,
    "DNdMn_sed" => 0.01,
    "DNdFe_sed" => 0.00,#0.00015,
    # "kMnO2Fe" => 1e7,
    #"kFeOOHH2S" => 1.0,
    # "kFeSpre" => 1e7,
    "kMnCO3pre" => 0.0,
    "kFeCO3pre" => 0.0,
    "KspNdPO4" => 5E-19,
    "kNdPO4_pre" => 1e-8
)

@time generate_code(modelconfig)

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

# solution = load("sol.$modelname.jld2", "solution");

solverctrlconfig = SolverCtrlConfig(
    # SedTrace.C_uni,
    solution.sol[end],
    (0.0, 50000.0),
    reltol = 1e-6,
    abstol = 1e-18,
    saveat = 1000.0,
    callback = TerminateSteadyState(1e-12, 1e-6, DiffEqCallbacks.allDerivPass),
    maxiters = Int(1e6),
);

outputconfig = OutputConfig(
    SedTrace.x,
    SedTrace.L,
    SedTrace.Ngrid,
    SedTrace.IDdict
);

@time solution = modelrun(OdeFunction, solver, solverctrlconfig,outputconfig);


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
    "eNd_auth",
    "Nd_leach",
    "eNd_leach",
    "Nd_MnO2",
    "Nd_FeOOH",
    "TH2S",
    "Basalt"
];

generate_substance_plot(modelconfig, solution, ["HH3000"])


generate_aux_plot(modelconfig, solution, ["HH3000"], ["MnO2","Mn_ads_Mn","Mn_ads_Fe"])



jldsave("sol.$modelname.jld2"; solution)

plot(SedTrace.Ds,SedTrace.x)