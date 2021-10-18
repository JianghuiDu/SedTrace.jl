
using SedTrace
using JLD2

modeldirectory = (@__DIR__)*"\\examples\\SBB\\"
modelfile = "model_config.SBB.xlsx"
modelname = "SBB"

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


TestJacobian(JacPrototype,OdeFun,chunk_size)
BenchmarkReactran(OdeFun,SedTrace.C_uni)
BenchmarkJacobian(JacPrototype,OdeFun,chunk_size)
BenchmarkPreconditioner(JacPrototype,OdeFun,chunk_size)


solverconfig = SolverConfig(
    chunk_size,
    SedTrace.C_uni,
    (0.0, 3000.0),
    :FGMRES,
    reltol = 1e-6,
    abstol = 1e-16,
    saveat = 100.0,
    callback = TerminateSteadyState(1e-16, 1e-6, DiffEqCallbacks.allDerivPass),
)


sol = modelrun(OdeFun,JacPrototype,solverconfig);

gr(; size = (400, 1000))

generate_output(modelconfig,sol,["SBB"],SedTrace.L, false)

generate_output(modelconfig,sol,["SBB"],IDdict,["POC","O2"],SedTrace.L, false)



