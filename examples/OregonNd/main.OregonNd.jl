using MKL
using SedTrace
using JLD2
# set_zero_subnormals(true)

modeldirectory = (@__DIR__)*"\\"
modelfile = "model_config.OregonNd.xlsx"
modelname = "OregonNd"

modelconfig = ModelConfig(
    modeldirectory,
    modelfile,
    modelname,
    AssembleParam = true,
)


@time generate_parameter_template(modelconfig)


@time generate_code(modelconfig)


IncludeFiles(modelconfig)

# ForwardDiff.pickchunksize(maximum(matrix_colors(JacPrototype)))
chunk_size = 10;

C0 = SedTrace.Param.C0;
parm = SedTrace.Param.ParamStruct();
OdeFun = SedTrace.Cache.init(C0, SedTrace.Param.Ngrid, chunk_size);
JacPrototype = SedTrace.JacType(SedTrace.Param.IDdict,SedTrace.Param.Ngrid,SedTrace.Param.nspec)
solverconfig = SolverConfig(chunk_size, :GMRES,:ILU0,1)
solver = generate_ODESolver(OdeFun, JacPrototype, solverconfig,parm);
OdeFunction = generate_ODEFun(OdeFun, JacPrototype, solverconfig);


C0 = SedTrace.C0;
parm = nothing;
OdeFun = SedTrace.Cache.init(C0, SedTrace.Ngrid, chunk_size);
JacPrototype = SedTrace.JacType(SedTrace.IDdict,SedTrace.Ngrid,SedTrace.nspec)
solverconfig = SolverConfig(chunk_size, :GMRES,:ILU0,1)
solver = generate_ODESolver(OdeFun, JacPrototype, solverconfig,parm);
OdeFunction = generate_ODEFun(OdeFun, JacPrototype, solverconfig);


TestOdeFun(OdeFun,C0,parm)
TestJacobian(JacPrototype,OdeFun,chunk_size,parm)
BenchmarkReactran(OdeFun,C0,parm)
BenchmarkJacobian(JacPrototype,OdeFun,chunk_size,parm)
BenchmarkPreconditioner(JacPrototype,OdeFun,chunk_size,parm)


solution = load("sol.$modelname.jld2", "sol");

solverctrlconfig = SolverCtrlConfig(
    C0,
    # solution.sol[end],
    (0.0, 1E6),
    reltol = 1e-6,
    abstol = 1e-18,
    saveat = 1000.0,
    callback = TerminateSteadyState(1e-16, 1e-6, DiffEqCallbacks.allDerivPass),
);

# outputconfig = OutputConfig(SedTrace.Param.x, SedTrace.Param.L, SedTrace.Param.Ngrid, SedTrace.Param.IDdict);

outputconfig = OutputConfig(SedTrace.x, SedTrace.L, SedTrace.Ngrid, SedTrace.IDdict);


@time solution = modelrun(OdeFunction, parm, solver, solverctrlconfig, outputconfig);

gr(; size = (400, 1000))

EnableList = Dict(
    "output" => [
        # "Illite",
        "Nd_auth_copre",
        "eNd_auth_copre",
        "Nd_MnO2_copre",
        "Nd_FeOOH_copre",
        "eNd_MnO2_copre",
        "eNd_FeOOH_copre",
    ],
)

generate_substance_plot(
    modelconfig,
    solution,
    ["HH3000"],
    EnableList = EnableList,
    showplt = true,
)

jldsave("sol.$modelname.jld2"; sol = solution)

