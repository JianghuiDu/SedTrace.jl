
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
    FastBroadcast = false,
    UnflattenOp = false,
    MTK = true
)

@time generate_code(modelconfig)

IncludeFiles(modelconfig)

JacPrototype = SedTrace.JacType()


ForwardDiff.pickchunksize(maximum(matrix_colors(JacPrototype)))
chunk_size = 12;
jacp1 = similar(JacPrototype)

jac1 = SedTrace.generate_jacobian(OdeFun,jacp1,chunk_size);
jac1(jacp1,SedTrace.C_uni,nothing,0)
writedlm("j2.txt",jacp1)

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
using SpecialFunctions, LinearAlgebra
include((@__DIR__)*"//src//fvcf_discretization.jl")
include((@__DIR__)*"//examples//parm.HH3000.jl")
include((@__DIR__)*"//examples//reactran.HH3000.jl")
include((@__DIR__)*"//examples//cache.HH3000.jl")

@variables t,dC[1:Nmat](t),C[1:Nmat](t);

D = Differential(t);
@time reactran_fvcf_auto(dC,C,nothing,0)

fol = ODESystem(D.(C) .~ dC,t,C,[])
sys = structural_simplify(fol)

@time prob = ODEProblem(sys,C_uni,(0.0,10.0),sparse=true,jac=true);

C0 = C_uni;
dC0 = similar(C0);

prob.f(dC0,C0,nothing,0)


jac=ModelingToolkit.generate_jacobian(sys,sparse=true,expression = Val{false});


# write("sparsity.jl", string(jac[1]))
# write("jacobian.jl", string(jac[2]))

# include("jacobian.jl")


# using RuntimeGeneratedFunctions
# RuntimeGeneratedFunctions.init(@__MODULE__)

# jacsp = eval(jac[2])

C0 = C_uni;
dC0 = similar(C0);

jp = prob.f.jac_prototype
jp.nzval.=1.0;
jp2=JacType()
jp2.nzval.=1.0

jp.!=jp2


prob.f.jac(jp,C0,nothing,0);

using DelimitedFiles
writedlm("j.txt",jp-jp2)

maximum(abs.(jp-jacp1))
@variables t,aa[1:10],bb[1:10];
cc = @view aa[1:5]
dd = @view bb[1:5]
@. dd = cc*dd
bb
mul!(aa,ones(10,10),bb)