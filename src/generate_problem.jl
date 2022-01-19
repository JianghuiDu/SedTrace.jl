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

function generate_ODESolver(OdeFun,JacPrototype::SparseMatrixCSC,solverconfig::SolverConfig)


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
        JacFun = generate_jacobian(OdeFun, JacPrototype, solverconfig.chunk_size)
        p_prec = generate_preconditioner(solverconfig.Precondition, JacPrototype)
        psetup = default_psetup(p_prec, JacPrototype, JacFun)
        prec = default_prec(p_prec)

        return  CVODE_BDF(
                linear_solver = solverconfig.linsolve,
                prec = prec,
                psetup = psetup,
                prec_side = 2,
                krylov_dim = Int(0.1*size(JacPrototype,1)),
            )

    end

    if solverconfig.linsolve == :FBDF
        return FBDF(
                autodiff = false,
                # chunk_size = solverconfig.chunk_size
            )
    end



end

function generate_ODEFun(OdeFun,JacPrototype::SparseMatrixCSC,solverconfig::SolverConfig)
colorvec = matrix_colors(JacPrototype)

    if solverconfig.linsolve in [:Band, :LapackBand]
        return ODEFunction{true,true}(OdeFun,colorvec=colorvec)
    end

    if solverconfig.linsolve == :KLU
        JacFun = generate_jacobian(OdeFun, JacPrototype, solverconfig.chunk_size)
        return  ODEFunction{true,true}(OdeFun; jac = JacFun, jac_prototype = JacPrototype,colorvec=colorvec)

    end

    if solverconfig.linsolve in [:GMRES, :FGMRES, :TFQMR]
        return  ODEFunction{true,true}(OdeFun,colorvec=colorvec)
    end

    if solverconfig.linsolve == :FBDF
        Lwbdwth,Upbdwth = bandwidths(JacPrototype)
        jac_prototype = BandedMatrix(Zeros(size(JacPrototype)), (Lwbdwth,Upbdwth))
        return  ODEFunction{true,true}(OdeFun; jac_prototype = jac_prototype,colorvec=colorvec)
    end

end


function modelrun(OdeFunction, solver,solverctrlconfig::SolverCtrlConfig,outputconfig::OutputConfig)
    prob = ODEProblem{true}(OdeFunction, solverctrlconfig.u0, solverctrlconfig.tspan, nothing)

    saveat = isnothing(solverctrlconfig.saveat) ? [] : vcat(1e-12,(solverctrlconfig.tspan[1]+solverctrlconfig.saveat):solverctrlconfig.saveat:solverctrlconfig.tspan[2])

    @time sol = SciMLBase.solve(
        prob,
        solver,
        reltol = solverctrlconfig.reltol,
        abstol = solverctrlconfig.abstol,
        save_everystep = false,
        callback = solverctrlconfig.callback,
        saveat = saveat,
        # dtmax = 1.0,
        maxiters = solverctrlconfig.maxiters,
        save_start = false
    )
    println("$(sol.retcode) at t = $(sol.t[end]).")

    nt = length(sol.t)
    dC0 = similar(ones(size(sol, 1)))
    VarName = fieldnames(typeof(OdeFunction.f))
    nVar = length(VarName)

    VarVal = Dict(string(i) => Matrix{Float64}(undef, nt,  outputconfig.Ngrid) for i in VarName)

    for i in 1:nt
        Base.@invokelatest OdeFunction.f(dC0, sol[i], nothing, 0)
        for j in VarName
            VarVal[string(j)][i, :] .= getfield(OdeFunction.f, j).du
        end
    end


    # println(sol.destats)
    return SolutionConfig(sol,outputconfig.x,outputconfig.L,outputconfig.Ngrid,outputconfig.IDdict,VarVal)
end

nothing