
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
    UpdateParamOnly = false,
    JacType = :sparse_banded,
    Template = true,
    AutoDiff = true,
    CompleteFlux = false,
)

chunk_size = 10;

solverconfig = SolverConfig(chunk_size, :LapackBand)


ParamDict = Dict(
    "a" => 50.0,
    "Dbt0" => 2.0,
    "xbt" => 8.0,
    "xbir" => 2,
    "FPOC0"	=> "3.4/100*Fsed/12*1000",
    "FMnO20" => "0.4/100*Fsed/86.94*1000",
    "FFeOOH0" => "0.1/100*Fsed/88.85*1000",
    "FBSi0" => "9/100*Fsed/28.09*1000",
    "FBasalt0" => "Fsed*1/100/87.383*1000",
    "KMnO2" => "0.2/(86.93685/ds_rho/10)",
    "KFeOOH" => "20/(88.85174/ds_rho/10)",
    "kO2Mn_ads" => 5e6,
    "KNd_ads_Mn" => 0,
    "KNd_ads_Fe" => 0,#1e5,
    "aBasalt" => 1e4,
    "KMn_ads_Mn" => 5e3,#4.34,7e6,
    "KMn_ads_Fe" => 1e2,#1738.8,
    "KFe_ads_Mn" => 1e3,
    "KFe_ads_Fe" => 1e3,
    "DNdMn" => 0.02,
    "DNdFe" => 0.005,#0.0015,
    "DNdMn_sed" => 0.02,
    "DNdFe_sed" => 0.005,#0.00015,
    "kMnO2Fe" => 1e6,
    "kMnO2H2S" => 1e4,
    "kFeOOHH2S" => 100,
    "kFeSpre" => 1e4,
    "kMnCO3pre" => 0.1,
    "kFeCO3pre" => 0.1,
    "KspNdPO4" => 1.175E-19,
    "kNdPO4_pre" => 0.35e-8,
    "rPC" => 1/170,
    "kBSi_dis" => 0.01,
    "H4SiO4_dis_sat" => 630e-6

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
    "Basalt",
    "TH4SiO4"
];

generate_substance_plot(modelconfig, solution, ["HH3000"],vars)


generate_aux_plot(modelconfig, solution, ["HH3000"], ["MnO2","Mn_ads_Mn","Mn_ads_Fe"])

generate_aux_plot(modelconfig, solution, ["HH3000"], ["Omega_RMnCO3_pre"])


jldsave("sol.$modelname.jld2"; solution)
