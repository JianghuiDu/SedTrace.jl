
using SedTrace
using JLD2

modeldirectory = (@__DIR__)*"\\examples\\"
modelfile = "model_config.HH3000.workingversionnew.xlsx"
modelname = "HH3000"

modelconfig = ModelConfig(
    modeldirectory,
    modelfile,
    modelname,
    UpdateParamOnly = true,
    JacType = :sparse_banded,
    Template = true,
    AutoDiff = true,
    CompleteFlux = false,
    AssembleParam = false
)

@time generate_code(modelconfig)

IncludeFiles(modelconfig)

JacPrototype = SedTrace.JacType();

ForwardDiff.pickchunksize(maximum(matrix_colors(JacPrototype)))
chunk_size = 12;

OdeFun = SedTrace.Cache.init(SedTrace.C_uni, SedTrace.Ngrid, Val(chunk_size));


TestJacobian(JacPrototype,OdeFun,chunk_size)
BenchmarkReactran(OdeFun,SedTrace.C_uni)
BenchmarkJacobian(JacPrototype,OdeFun,chunk_size)
BenchmarkPreconditioner(JacPrototype,OdeFun,chunk_size)


solverconfig = SolverConfig(
    chunk_size,
    SedTrace.C_uni,
    (0.0, 30000.0),
    :LapackBand,
    reltol = 1e-6,
    abstol = 1e-16,
    saveat = 1000.0,
    callback = TerminateSteadyState(1e-12, 1e-6, DiffEqCallbacks.allDerivPass),
)


sol = modelrun(OdeFun,JacPrototype,solverconfig);

gr(; size = (400, 1000))
generate_output(modelconfig,sol,["HH3000"],SedTrace.L, false)




