
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
generate_plot(modelconfig, OdeFun, sol, ["HH3000"], false)



include((@__DIR__)*"\\examples\\HH3000ads\\pH_helpers.jl")
include((@__DIR__)*"\\examples\\HH3000ads\\generate_output_old.jl")
generate_output_old(modelconfig,sol,["HH3000"],SedTrace.L, false)




p=plot((OdeFun.Ndnr.du+OdeFun.Ndr.du)*1e12,-SedTrace.x)


p=plot((OdeFun.Ndnr_ads_Mn.du+OdeFun.Ndr_ads_Mn.du)*144.24/SedTrace.ds_rho*1000,-SedTrace.x)


plot!(p,(OdeFun.Ndnr_ads_Fe.du+OdeFun.Ndr_ads_Fe.du)*144.24/SedTrace.ds_rho*1000,-SedTrace.x)

# using SpecialFunctions,LinearAlgebra,FastBroadcast,
# using SparseArrays
# using SedTrace

dir = "C:\\Users\\Jianghui\\.julia\\dev\\SedTrace\\examples\\HH3000ads\\"
include(dir*"fvcf_discretization.jl")
include(dir*"parm.HH3000Nd.jl")
include(dir*"cache.HH3000Nd.jl")
include(dir*"reactran.HH3000Nd.jl")
include(dir*"jactype.HH3000Nd.jl")

# JacPrototype = JacType()

# f = Cache.init(C_uni, Ngrid, Val(10));
# dC = similar(C_uni);
# f(dC,C_uni,nothing,0)
# jacp = zeros(Nmat,Nmat);

# jac = SedTrace.generate_jacobian(f,jacp,10);

# jac(jacp,C_uni,nothing,0);
# using DelimitedFiles
# jacps = sparse(jacp)
# jacps.nzval .= 1.0;

# JacPrototype.nzval .=1.0;
# writedlm("jacp2.txt",jacp)
# writedlm("jacpdif.txt",jacps-JacPrototype)
# writedlm("jacp1.txt",JacPrototype)


# jacp1 = similar(JacPrototype)
# jacp2 = zeros(SedTrace.Nmat,SedTrace.Nmat)

# jac1 = SedTrace.generate_jacobian(OdeFun,jacp1,chunk_size);
# jac2 = SedTrace.generate_jacobian(OdeFun,jacp2,chunk_size);

# u0 = rand(size(JacPrototype,1));

# jac1(jacp1,u0,nothing,0);
# jac2(jacp2,u0,nothing,0);
# jacp1==jacp2

# jacp1.nzval .= 1.0;
# jacp2s = sparse(jacp2)
# jacp2s.nzval .= 1.0;
# using DelimitedFiles
# writedlm("jacp1.txt",jacp1)
# writedlm("jacp2.txt",jacp2)
# writedlm("jacpdif.txt",jacp2-jacp1)

# dC = similar(SedTrace.C_uni)
# OdeFun(dC,u0,nothing,0)

# plot(OdeFun.RNdnrPO4_pre.du,-SedTrace.x)
