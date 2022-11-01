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
        JacFun = generate_jacobian(OdeFun, JacPrototype,parm)
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
        JacFun = generate_jacobian(OdeFun, JacPrototype, parm)
        return  ODEFunction{true,true}(OdeFun; jac = JacFun, jac_prototype = JacPrototype,colorvec=colorvec)

    end

    if solverconfig.linsolve in [:GMRES, :FGMRES, :TFQMR]
        # return  ODEFunction{true,true}(OdeFun,colorvec=colorvec,jac_prototype = JacVec(OdeFun, ones(size(JacPrototype,1))))
        return  ODEFunction{true,true}(OdeFun,colorvec=colorvec)

    end

    # if solverconfig.linsolve in [:FBDF,:QNDF]
    #     # Lwbdwth,Upbdwth = bandwidths(JacPrototype)
    #     # jac_prototype = BandedMatrix(Zeros(size(JacPrototype)), (Lwbdwth,Upbdwth))
    #     # Jv = JacVecOperator(OdeFun,u0,p,0.0)
    #     return  ODEFunction{true,true}(OdeFun; jac_prototype = JacPrototype,colorvec=colorvec)
    # end

end


function modelrun(OdeFun,parm, JacPrototype::SparseMatrixCSC,solverconfig::SolverConfig,solutionconfig::SolutionConfig)

    solver = generate_ODESolver(OdeFun, JacPrototype, solverconfig,parm);
    OdeFunction = generate_ODEFun(OdeFun, JacPrototype, solverconfig)
    prob = ODEProblem{true}(OdeFunction, solutionconfig.u0, solutionconfig.tspan, parm)

    saveat = isnothing(solutionconfig.saveat) ? [] : vcat(1e-12,(solutionconfig.tspan[1]+solutionconfig.saveat):solutionconfig.saveat:solutionconfig.tspan[2])

    # tstops = isnothing(solverctrlconfig.tstops) ? solverctrlconfig.tspan[1] : solverctrlconfig.tstops

    # dtmax = isnothing(solverctrlconfig.dtmax) ? 100.0 : solverctrlconfig.dtmax

    @time sol = SciMLBase.solve(
        prob,
        solver,
        reltol = solutionconfig.reltol,
        abstol = solutionconfig.abstol,
        save_everystep = false,
        callback = solutionconfig.callback,
        saveat = saveat,
        # dtmax = dtmax,
        maxiters = solutionconfig.maxiters,
        save_start = false,
        # tstops = tstops
        # dtmin = 1e-10
    )
    println("$(sol.retcode) at t = $(sol.t[end]).")

    nt = length(sol.t)
    dC0 = similar(ones(size(sol, 1)))
    IntValVarName = fieldnames(typeof(OdeFun))

    IntVal = Dict(string(i) => Matrix{Float64}(undef, nt,  parm.Ngrid) for i in IntValVarName)

    for i in 1:nt
        Base.@invokelatest OdeFun(dC0, sol[i], parm, 0)
        for j in IntValVarName
            IntVal[string(j)][i, :] .= getfield(OdeFun, j).du
        end
    end


    # println(sol.destats)
    return OutputConfig(sol,IntVal)
end

nothing