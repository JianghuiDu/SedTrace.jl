
using SedTrace
using JLD2
using Sundials, SciMLBase
gr(size = (400, 1000))
set_zero_subnormals(true)

modeldirectory = (@__DIR__) * "\\"
modelfile = "model_config.HH3000NdMnFe_ads.xlsx"
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

chunk_size = 12;

solverconfig = SolverConfig(chunk_size, :GMRES)


ParamDict =
    Dict("KNd_ads_Mn" => 5e6, "KNd_ads_Fe" => 5e5, "a" => 55.0, "xbt" => 3.0, "nu" => 0.1)

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
    SedTrace.C_uni,
    # solution.sol[end],
    (0.0, 30000.0),
    reltol = 1e-6,
    abstol = 1e-17,
    saveat = 1000.0,
    callback = TerminateSteadyState(1e-12, 1e-6, DiffEqCallbacks.allDerivPass),
);


@time solution = modelrun(OdeFunction, solver, solverctrlconfig);

vars = [
    "POC",
    "Age",
    "MnO2",
    "Mn",
    "Mn_ads",
    "FeOOH",
    "Fe",
    "Fe_ads",
    "Nd_pw",
    "eNd_pw",
    "TH3PO4",
    "SO4",
];
generate_substance_plot(modelconfig, OdeFun, solution, ["HH3000"], vars)


generate_aux_plot(modelconfig, OdeFun, solution, ["HH3000"], ["Mn_ads_Fe"])

jldsave("sol.$modelname.jld2"; solution)

minimum(solution.sol[end][SedTrace.TH2SID])

# Odef = SedTrace.generate_ODEFun(OdeFun,JacPrototype,solverconfig);
using SnoopCompile
tinf = @snoopi_deep solution = modelrun(OdeFun, solver, solverconfig);
fg = flamegraph(tinf)
using ProfileView
ProfileView.view(fg)

plot(erfc.((SedTrace.x .- 5) / 1) / 2, -SedTrace.x)
