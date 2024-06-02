using SedTrace
using Test

@testset "SedTrace.jl" begin
    modeldirectory = joinpath(@__DIR__,"POC1G")
    modelfile = "model_config.POC1G.xlsx" 
    modelname = "POC1G"
    
    modelconfig = ModelConfig(
        modeldirectory,
        modelfile,
        modelname,
    )
    if isfile(joinpath(modeldirectory,"model_parameter_template.POC1G.xlsx"))
        rm(joinpath(modeldirectory,"model_parameter_template.POC1G.xlsx"),force=true)
    end
    if isfile(joinpath(modeldirectory,"model_parsing_diagnostics.POC1G.xlsx"))
        rm(joinpath(modeldirectory,"model_parsing_diagnostics.POC1G.xlsx"),force=true)
    end
    if isfile(joinpath(modeldirectory,"model_output.POC1G.xlsx"))
        rm(joinpath(modeldirectory,"model_output.POC1G.xlsx"),force=true)
    end
    if isfile(joinpath(modeldirectory,"parm.POC1G.jl"))
        rm(joinpath(modeldirectory,"parm.POC1G.jl"),force=true)
    end
    if isfile(joinpath(modeldirectory,"parm.struct.POC1G.jl"))
        rm(joinpath(modeldirectory,"parm.struct.POC1G.jl"),force=true)
    end
    if isfile(joinpath(modeldirectory,"cache.POC1G.jl"))
        rm(joinpath(modeldirectory,"cache.POC1G.jl"),force=true)
    end
    if isfile(joinpath(modeldirectory,"jactype.POC1G.jl"))
        rm(joinpath(modeldirectory,"jactype.POC1G.jl"),force=true)
    end
    if isfile(joinpath(modeldirectory,"reactran.POC1G.jl"))
        rm(joinpath(modeldirectory,"reactran.POC1G.jl"),force=true)
    end

    generate_parameter_template(modelconfig)
    
    generate_code(modelconfig)
    
    IncludeFiles(modelconfig)
    
    # initial values
    C0 = Param.C0;
    # initalize parameters
    parm = Param.ParamStruct();
    # initialize cache and ODE function
    OdeFun = Cache.init(C0, parm.Ngrid);
    # initialize Jacobian 
    JacPrototype = JacType(Param.IDdict);
    
    
    TestOdeFun(OdeFun,C0,parm)
    TestJacobian(JacPrototype,OdeFun,C0,parm)
    BenchmarkReactran(OdeFun,C0,parm)
    BenchmarkJacobian(JacPrototype,OdeFun,C0,parm)
    BenchmarkPreconditioner(JacPrototype,OdeFun,C0,parm,:ILU0)
    
    # configure the solver
    solverconfig = SolverConfig(:GMRES, :ILU0, 2)
    
    
    
    solutionconfig = SolutionConfig(
        C0,
        (0.0, 1.0),
        reltol = 1e-6,
        abstol = 1e-12,
        saveat = 100.0,
        callback = TerminateSteadyState(1e-16, 1e-6),
    );
    
    
    
    solution = modelrun(OdeFun, parm, JacPrototype, solverconfig, solutionconfig);
    
    # gr(; size = (400, 800))
    
    generate_output(
        modelconfig,
        solution,
        parm,
        site = ["analytical"],
        showplt = false,
    )
    
end
