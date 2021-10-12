# function generate_ODEFunction(jacconfig::JacConfig, chunk_size::Int)

#     OdeFun = Cache.init(zeros(Ngrid * nspec), Ngrid, Val(chunk_size))

#     if !jacconfig.JacFun && !jacconfig.JacVec
#         JacPrototype = JacType()
#         return ODEFunction(OdeFun, jac_prototype = JacPrototype)
#     end

#     if jacconfig.JacFun && !jacconfig.JacVec
#         JacPrototype = JacType()
#         JacFun = generate_jacobian(OdeFun, JacPrototype, chunk_size)
#         return ODEFunction(OdeFun, jac_prototype = JacPrototype, jac = JacFun)
#     end

#     if !jacconfig.JacFun && jacconfig.JacVec
#         JacVec = JacVecOperator(OdeFun, C_uni, nothing, 0.0, autodiff = true)
#         return ODEFunction(OdeFun, jac_prototype = JacVec)
#     end

#     if jacconfig.JacFun && jacconfig.JacVec
#         JacFun = generate_jacobian(OdeFun, JacPrototype, chunk_size)
#         JacVec = JacVecOperator(OdeFun, C_uni, nothing, 0.0, autodiff = true)
#         return ODEFunction(OdeFun, jac_prototype = JacVec, jac = JacFun)
#     end

# end

# function generate_ODEProblem(jacconfig::JacConfig, chunk_size::Int)

#     OdeFun = generate_ODEFunction(jacconfig, chunk_size)
#     prob = ODEProblem(OdeFun, jacconfig.u0, jacconfig.tspan, nothing)
#     cb = jacconfig.callback

# end

function generate_ODESolver(solverconfig::Config.SolverConfig)

    OdeFun = Cache.init(zeros(Nmat), Ngrid, Val(solverconfig.chunk_size))

    if solverconfig.linsolve in [:Band, :LapackBand]
        JacPrototype = JacType()
        JacFun = generate_jacobian(OdeFun, JacPrototype, solverconfig.chunk_size)
        return (
            ODEFunction{true,false}(OdeFun),
            CVODE_BDF(
                linear_solver = solverconfig.linsolve,
                jac_upper = Upbdwth,
                jac_lower = Lwbdwth,
            ),
        )
    end

    if solverconfig.linsolve == :KLU
        JacPrototype = JacType()
        JacFun = generate_jacobian(OdeFun, JacPrototype, solverconfig.chunk_size)
        return (
            ODEFunction{true,false}(OdeFun; jac = JacFun, jac_prototype = JacPrototype),
            CVODE_BDF(linear_solver = solverconfig.linsolve),
        )
    end

    if solverconfig.linsolve in [:GMRES, :FGMRES]
        JacPrototype = JacType()
        JacFun = generate_jacobian(OdeFun, JacPrototype, solverconfig.chunk_size)
        p_prec = generate_preconditioner(solverconfig.Precondition, JacPrototype)
        psetup = default_psetup(p_prec, JacPrototype, JacFun)
        prec = default_prec(p_prec)
        return (
            ODEFunction{true,false}(OdeFun),
            CVODE_BDF(
                linear_solver = solverconfig.linsolve,
                prec = prec,
                psetup = psetup,
                prec_side = 2,
                krylov_dim = Ngrid,
            ),
        )
    end

end

function modelrun(solverconfig::Config.SolverConfig)
    OdeFun, solver = generate_ODESolver(solverconfig);
    prob = ODEProblem{true}(OdeFun, solverconfig.u0, solverconfig.tspan, nothing)

    @time sol = SciMLBase.solve(
        prob,
        solver,
        reltol = solverconfig.reltol,
        abstol = solverconfig.abstol,
        save_everystep = false,
        callback = solverconfig.callback,
        saveat = isnothing(solverconfig.saveat) ? [] : solverconfig.saveat,
        # dtmax = 1.0,
        maxiters = solverconfig.maxiters,
    )

    return sol
end

nothing