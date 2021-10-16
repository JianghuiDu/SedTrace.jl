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
# using OrdinaryDiffEq
function generate_ODESolver(OdeFun,JacPrototype::Union{BandedMatrix,SparseMatrixCSC},solverconfig::SolverConfig)


    if solverconfig.linsolve in [:Band, :LapackBand]
        JacFun = generate_jacobian(OdeFun, JacPrototype, solverconfig.chunk_size)
        Upbdwth,Lwbdwth = bandwidths(JacPrototype)
        return (
            ODEFunction{true,true}(OdeFun),
            CVODE_BDF(
                linear_solver = solverconfig.linsolve,
                jac_upper = Upbdwth,
                jac_lower = Lwbdwth,
            ),
        )
    end

    if solverconfig.linsolve == :KLU
        JacFun = generate_jacobian(OdeFun, JacPrototype, solverconfig.chunk_size)
        return (
            ODEFunction{true,true}(OdeFun; jac = JacFun, jac_prototype = JacPrototype),
            CVODE_BDF(linear_solver = solverconfig.linsolve),
        )
    end

    if solverconfig.linsolve in [:GMRES, :FGMRES, :TFQMR]
        JacFun = generate_jacobian(OdeFun, JacPrototype, solverconfig.chunk_size)
        p_prec = generate_preconditioner(solverconfig.Precondition, JacPrototype)
        psetup = default_psetup(p_prec, JacPrototype, JacFun)
        prec = default_prec(p_prec)
        return (
            ODEFunction{true,true}(OdeFun),
            CVODE_BDF(
                linear_solver = solverconfig.linsolve,
                prec = prec,
                psetup = psetup,
                prec_side = 2,
                krylov_dim = Ngrid,
            ),
        )
    end

    
    # if solverconfig.linsolve in [:QNDF,:QBDF,:TRBDF2,:FBDF]
    #     JacFun = generate_jacobian(OdeFun, JacPrototype, solverconfig.chunk_size)
    #     return (
    #         ODEFunction{true,true}(OdeFun;jac=JacFun,jac_prototype=JacPrototype),
    #         FBDF(
    #             autodiff = false,
    #             # chunk_size = solverconfig.chunk_size
    #         ),
    #     )
    # end

end

function modelrun(OdeFun,JacPrototype::Union{BandedMatrix,SparseMatrixCSC},solverconfig::SolverConfig)
    OdeFunction, solver = generate_ODESolver(OdeFun,JacPrototype,solverconfig);
    prob = ODEProblem{true}(OdeFunction, solverconfig.u0, solverconfig.tspan, nothing)

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

    println("$(sol.retcode) at t = $(sol.t[end]).")
    return sol
end

nothing