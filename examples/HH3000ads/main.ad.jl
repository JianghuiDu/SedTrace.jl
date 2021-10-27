
using SedTrace
using JLD2

modeldirectory = "C:\\Users\\Jianghui\\.julia\\dev\\SedTrace\\examples\\HH3000ads\\"
modelfile = "model_config.HH3000Nd.xlsx"
modelname = "HH3000Nd"

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

@time generate_code(modelconfig)

IncludeFiles(modelconfig)

JacPrototype = SedTrace.JacType()

ForwardDiff.pickchunksize(maximum(matrix_colors(JacPrototype)))
chunk_size = 12;

OdeFun = SedTrace.Cache.init(SedTrace.C_uni, SedTrace.Ngrid, Val(chunk_size));


# TestJacobian(JacPrototype,OdeFun,chunk_size)
# BenchmarkReactran(OdeFun,SedTrace.C_uni)
# BenchmarkJacobian(JacPrototype,OdeFun,chunk_size)
# BenchmarkPreconditioner(JacPrototype,OdeFun,chunk_size)


solverconfig = SolverConfig(
    chunk_size,
    SedTrace.C_uni,
    (0.0, 30000.0),
    :FGMRES,
    reltol = 1e-6,
    abstol = 1e-16,
    saveat = 1000.0,
    callback = TerminateSteadyState(1e-12, 1e-6, DiffEqCallbacks.allDerivPass)
)


sol = modelrun(OdeFun,JacPrototype,solverconfig);


gr(; size = (400, 1000))
generate_substance_plot(modelconfig, OdeFun, sol, ["HH3000"],["Nd_pw","eNd_pw"])
generate_aux_plot(modelconfig,OdeFun, sol,["HH3000"],["POC"])
