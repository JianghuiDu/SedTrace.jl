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
# function generate_ODESolver(OdeFun,JacPrototype::Union{BandedMatrix,SparseMatrixCSC},solverconfig::SolverConfig)


#     if solverconfig.linsolve in [:Band, :LapackBand]
#         Lwbdwth,Upbdwth = bandwidths(JacPrototype)
#         return (
#             # ODEFunction{true,false}(OdeFun),
#             OdeFun,
#             CVODE_BDF(
#                 linear_solver = solverconfig.linsolve,
#                 jac_upper = Upbdwth,
#                 jac_lower = Lwbdwth,
#             ),
#         )
#     end

#     if solverconfig.linsolve == :KLU
#         JacFun = generate_jacobian(OdeFun, JacPrototype, solverconfig.chunk_size)
#         return (
#             ODEFunction{true,false}(OdeFun; jac = JacFun, jac_prototype = JacPrototype),
#             CVODE_BDF(linear_solver = solverconfig.linsolve),
#         )
#     end

#     if solverconfig.linsolve in [:GMRES, :FGMRES, :TFQMR]
#         JacFun = generate_jacobian(OdeFun, JacPrototype, solverconfig.chunk_size)
#         p_prec = generate_preconditioner(solverconfig.Precondition, JacPrototype)
#         psetup = default_psetup(p_prec, JacPrototype, JacFun)
#         prec = default_prec(p_prec)

#         return (
#             # ODEFunction{true,false}(OdeFun),
#             OdeFun,
#             CVODE_BDF(
#                 linear_solver = solverconfig.linsolve,
#                 prec = prec,
#                 psetup = psetup,
#                 prec_side = 2,
#                 krylov_dim = Int(0.1*size(JacPrototype,1)),
#             ),
#         )
#     end

    
#     # if solverconfig.linsolve in [:QNDF,:QBDF,:TRBDF2,:FBDF]
#     #     JacFun = generate_jacobian(OdeFun, JacPrototype, solverconfig.chunk_size)
#     #     return (
#     #         ODEFunction{true,true}(OdeFun;jac=JacFun,jac_prototype=JacPrototype),
#     #         FBDF(
#     #             autodiff = false,
#     #             # chunk_size = solverconfig.chunk_size
#     #         ),
#     #     )
#     # end

# end

# function modelrun(OdeFun,JacPrototype::Union{BandedMatrix,SparseMatrixCSC},solverconfig::SolverConfig)
#     OdeFunction, solver = generate_ODESolver(OdeFun,JacPrototype,solverconfig);
#     prob = ODEProblem{true}(OdeFunction, solverconfig.u0, solverconfig.tspan, nothing)

#     @time sol = SciMLBase.solve(
#         prob,
#         solver,
#         reltol = solverconfig.reltol,
#         abstol = solverconfig.abstol,
#         save_everystep = false,
#         callback = solverconfig.callback,
#         saveat = isnothing(solverconfig.saveat) ? [] : solverconfig.saveat,
#         # dtmax = 1.0,
#         maxiters = solverconfig.maxiters,
#     )

#     println("$(sol.retcode) at t = $(sol.t[end]).")
#     println(sol.destats)
#     return SolutionConfig(sol,x,L,Ngrid,IDdict)
# end
# using LinearSolve
# using IncompleteLU

function generate_ODESolver(OdeFun,JacPrototype::SparseMatrixCSC,solverconfig::SolverConfig,parm)


    if solverconfig.linsolve in [:Band, :LapackBand]
        Lwbdwth,Upbdwth = bandwidths(JacPrototype)
        return CVODE_BDF(
                linear_solver = solverconfig.linsolve,
                jac_upper = Upbdwth,
                jac_lower = Lwbdwth,
            )
    end

    if solverconfig.linsolve == :KLU
        return CVODE_BDF(linear_solver = solverconfig.linsolve)
    end

    if solverconfig.linsolve in [:GMRES, :FGMRES, :TFQMR]
        JacFun = generate_jacobian(OdeFun, JacPrototype, solverconfig.chunk_size,parm)
        p_prec = generate_preconditioner(solverconfig.Precondition, JacPrototype)
        psetup = default_psetup(p_prec, JacPrototype, JacFun)
        prec = default_prec(p_prec)

        return  CVODE_BDF(
                linear_solver = solverconfig.linsolve,
                prec = prec,
                psetup = psetup,
                prec_side = solverconfig.PrecSide,
                krylov_dim = Int(ceil(0.1*size(JacPrototype,1))),
            )

    end

    # if solverconfig.linsolve == :FBDF

    #     prec = SciMLprecSetup(JacPrototype)
    #     return FBDF(
    #         autodiff = true,
    #         linsolve=KrylovJL_GMRES(),
    #         precs=prec,
    #         concrete_jac=true,
    #         chunk_size = solverconfig.chunk_size
    #     )
    # end

    # if solverconfig.linsolve == :QNDF
    #     prec = SciMLprecSetup(JacPrototype)
    #       return QNDF(
    #         autodiff = true,
    #         linsolve=KrylovJL_GMRES(),
    #         precs=prec,
    #         concrete_jac=true,
    #         chunk_size = solverconfig.chunk_size
    #     )
    # end


end

function generate_ODEFun(OdeFun,JacPrototype::SparseMatrixCSC,solverconfig::SolverConfig)
colorvec = matrix_colors(JacPrototype)

    # if solverconfig.linsolve in [:Band, :LapackBand]
    #     return ODEFunction{true,true}(OdeFun,colorvec=colorvec)
    # end

    if solverconfig.linsolve == :KLU
        JacFun = generate_jacobian(OdeFun, JacPrototype, solverconfig.chunk_size,parm)
        return  ODEFunction{true,true}(OdeFun; jac = JacFun, jac_prototype = JacPrototype,colorvec=colorvec)

    end

    if solverconfig.linsolve in [:GMRES, :FGMRES, :TFQMR]
        return  ODEFunction{true,true}(OdeFun,colorvec=colorvec)
    end

    # if solverconfig.linsolve in [:FBDF,:QNDF]
    #     # Lwbdwth,Upbdwth = bandwidths(JacPrototype)
    #     # jac_prototype = BandedMatrix(Zeros(size(JacPrototype)), (Lwbdwth,Upbdwth))
    #     # Jv = JacVecOperator(OdeFun,u0,p,0.0)
    #     return  ODEFunction{true,true}(OdeFun; jac_prototype = JacPrototype,colorvec=colorvec)
    # end

end


function modelrun(OdeFunction,parm, solver,solverctrlconfig::SolverCtrlConfig,outputconfig::OutputConfig)
    prob = ODEProblem{true}(OdeFunction, solverctrlconfig.u0, solverctrlconfig.tspan, parm)

    saveat = isnothing(solverctrlconfig.saveat) ? [] : vcat(1e-12,(solverctrlconfig.tspan[1]+solverctrlconfig.saveat):solverctrlconfig.saveat:solverctrlconfig.tspan[2])

    # tstops = isnothing(solverctrlconfig.tstops) ? solverctrlconfig.tspan[1] : solverctrlconfig.tstops

    # dtmax = isnothing(solverctrlconfig.dtmax) ? 100.0 : solverctrlconfig.dtmax

    @time sol = SciMLBase.solve(
        prob,
        solver,
        reltol = solverctrlconfig.reltol,
        abstol = solverctrlconfig.abstol,
        save_everystep = false,
        callback = solverctrlconfig.callback,
        saveat = saveat,
        # dtmax = dtmax,
        maxiters = solverctrlconfig.maxiters,
        save_start = false,
        # tstops = tstops
        # dtmin = 1e-10
    )
    println("$(sol.retcode) at t = $(sol.t[end]).")

    nt = length(sol.t)
    dC0 = similar(ones(size(sol, 1)))
    VarName = fieldnames(typeof(OdeFunction.f))
    nVar = length(VarName)

    VarVal = Dict(string(i) => Matrix{Float64}(undef, nt,  outputconfig.Ngrid) for i in VarName)

    for i in 1:nt
        Base.@invokelatest OdeFunction.f(dC0, sol[i], parm, 0)
        for j in VarName
            VarVal[string(j)][i, :] .= getfield(OdeFunction.f, j).du
        end
    end


    # println(sol.destats)
    return SolutionConfig(sol,outputconfig.x,outputconfig.L,outputconfig.Ngrid,outputconfig.IDdict,VarVal)
end

nothing