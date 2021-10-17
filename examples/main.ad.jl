
using SedTrace
using JLD2

modeldirectory = (@__DIR__)*"\\examples\\"
modelfile = "model_config.HH3000.workingversionnew.xlsx"
modelname = "HH3000"

modelconfig = ModelConfig(
    modeldirectory,
    modelfile,
    modelname,
    UpdateParamOnly = false,
    JacType = :sparse_banded,
    Template = false,
    AutoDiff = false,
    CompleteFlux = false,
    AssembleParam = false,
    FastBroadcast = false,
    UnflattenOp = false,
    MTK = true
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


using ModelingToolkit

@variables t,dC[1:SedTrace.Nmat](t),C[1:SedTrace.Nmat](t);

D = Differential(t);
@time SedTrace.reactran_fvcf_auto(dC,C,nothing,0)
# dC[SedTrace.HID]


fol = ODESystem(D.(C) .~ dC,t,C,[])
sys = structural_simplify(fol)

@time prob = ODEProblem(sys,SedTrace.C_uni,(0.0,10.0),sparse=true,jac=true);

jac=ModelingToolkit.generate_jacobian(sys,sparse=true,expression = Val{false});


write("sparsity.jl", string(jac[1]))
write("jacobian.jl", string(jac[2]))

include("jacobian.jl")


using RuntimeGeneratedFunctions
RuntimeGeneratedFunctions.init(@__MODULE__)

jacsp = eval(jac[2])

C0 = SedTrace.C_uni;
dC0 = similar(C0);

jp = prob.f.jac_prototype

prob.f.jac(jp,C0,nothing,0);

using DelimitedFiles
writedlm("j.txt",jp)
