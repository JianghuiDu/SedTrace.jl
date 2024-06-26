function generate_ODESolver(OdeFun,JacFun,JacPrototype::SparseMatrixCSC,solverconfig::SolverConfig,solutionconfig::SolutionConfig,parm)


    # if solverconfig.linsolve in [:Band, :LapackBand]
    #     Lwbdwth,Upbdwth = bandwidths(JacPrototype)
    #     return CVODE_BDF(
    #             linear_solver = solverconfig.linsolve,
    #             jac_upper = Upbdwth,
    #             jac_lower = Lwbdwth,
    #         )
    # end

    if solverconfig.linsolve == :KLU
        return CVODE_BDF(linear_solver = :KLU)
    end

    if solverconfig.linsolve in [:GMRES, :FGMRES, :TFQMR,:BCG]
        # JacFun = generate_jacobian(OdeFun, JacPrototype,parm)
        # JacFun(JacPrototype,solutionconfig.u0,parm,0.0)
        p_prec = generate_preconditioner(solverconfig.Precondition, JacPrototype)
        psetup = default_psetup(p_prec, JacPrototype, JacFun,solverconfig.Precondition)
        prec = default_prec(p_prec)

        return  CVODE_BDF(
                linear_solver = solverconfig.linsolve,
                prec = prec,
                psetup = psetup,
                prec_side = solverconfig.PrecSide,
                # krylov_dim = Int(ceil(0.1*size(JacPrototype,1))),
            )

    end

    if solverconfig.linsolve == :FBDF
        if solverconfig.Precondition == :NO
            return FBDF(
                autodiff = true,
                linsolve=KLUFactorization()
            )
        else     
        # JacFun = generate_jacobian(OdeFun, JacPrototype,parm)
        # JacFun(JacPrototype,solutionconfig.u0,parm,0.0)
        prec = generate_preconditioner2(solverconfig.Precondition,solverconfig.PrecSide, JacPrototype)
        return FBDF(
            autodiff = true,
            linsolve=KrylovJL_GMRES(), 
            precs=prec,
            concrete_jac=true,
        )
        end
    end

    # if solverconfig.linsolve == :ABDF2 
    #     if solverconfig.Precondition == :NO
    #         return ABDF2(
    #             autodiff = true,
    #             linsolve=KLUFactorization()
    #         )
    #     else     
    #     JacFun = generate_jacobian(OdeFun, JacPrototype,parm)
    #     JacFun(JacPrototype,solutionconfig.u0,parm,0.0)
    #     prec = generate_preconditioner2(solverconfig.Precondition,solverconfig.PrecSide, JacPrototype)
    #     return ABDF2(
    #         autodiff = true,
    #         linsolve=KrylovJL_GMRES(),
    #         precs=prec,
    #         concrete_jac=true,
    #     )
    #     end
    # end


    if solverconfig.linsolve == :QNDF
        if solverconfig.Precondition == :NO
            return QNDF(
                autodiff = true,
                linsolve=KLUFactorization()
            )
        else     
        # JacFun = generate_jacobian(OdeFun, JacPrototype,parm)
        # JacFun(JacPrototype,solutionconfig.u0,parm,0.0)
        prec = generate_preconditioner2(solverconfig.Precondition,solverconfig.PrecSide, JacPrototype)
        return QNDF(
            autodiff = true,
            linsolve=KrylovJL_GMRES(),
            precs=prec,
            concrete_jac=true,
        )
        end
    end

    
    if solverconfig.linsolve == :QBDF
        if solverconfig.Precondition == :NO
            return QBDF(
                autodiff = true,
                linsolve=KLUFactorization()
            )
        else     
        # JacFun = generate_jacobian(OdeFun, JacPrototype,parm)
        # JacFun(JacPrototype,solutionconfig.u0,parm,0.0)
        prec = generate_preconditioner2(solverconfig.Precondition,solverconfig.PrecSide, JacPrototype)
        return QBDF(
            autodiff = true,
            linsolve=KrylovJL_GMRES(),
            precs=prec,
            concrete_jac=true,
        )
        end
    end


    if solverconfig.linsolve == :KenCarp4
        if solverconfig.Precondition == :NO
            return KenCarp4(
                autodiff = true,
                linsolve=KLUFactorization()
            )
        else     
        prec = generate_preconditioner2(solverconfig.Precondition,solverconfig.PrecSide, JacPrototype)
        return KenCarp4(
            autodiff = true,
            linsolve=KrylovJL_GMRES(),
            precs=prec,
            concrete_jac=true,
        )
        end
    end

    
    if solverconfig.linsolve == :TRBDF2
        if solverconfig.Precondition == :NO
            return TRBDF2(
                autodiff = true,
                linsolve=KLUFactorization()
            )
        else     
        # JacFun = generate_jacobian(OdeFun, JacPrototype,parm)
        # JacFun(JacPrototype,solutionconfig.u0,parm,0.0)
        prec = generate_preconditioner2(solverconfig.Precondition,solverconfig.PrecSide, JacPrototype)
        return TRBDF2(
            autodiff = true,
            linsolve=KrylovJL_GMRES(),
            precs=prec,
            concrete_jac=true,
        )
        end
    end

    if solverconfig.linsolve == :Rodas5P
        if solverconfig.Precondition == :NO
            return Rodas5P(
                autodiff = true,
                linsolve=KLUFactorization()
            )
        else     
        # JacFun = generate_jacobian(OdeFun, JacPrototype,parm)
        # JacFun(JacPrototype,solutionconfig.u0,parm,0.0)
        prec = generate_preconditioner2(solverconfig.Precondition,solverconfig.PrecSide, JacPrototype)
        return Rodas5(
            autodiff = true,
            linsolve=KrylovJL_GMRES(),
            precs=prec,
            concrete_jac=true,
        )
        end
    end

    if solverconfig.linsolve == :Rodas4P
        if solverconfig.Precondition == :NO
            return Rodas4P(
                autodiff = true,
                linsolve=KLUFactorization()
            )
        else     
        # JacFun = generate_jacobian(OdeFun, JacPrototype,parm)
        # JacFun(JacPrototype,solutionconfig.u0,parm,0.0)
        prec = generate_preconditioner2(solverconfig.Precondition,solverconfig.PrecSide, JacPrototype)
        return Rodas4P(
            autodiff = true,
            linsolve=KrylovJL_GMRES(),
            precs=prec,
            concrete_jac=true,
        )
        end
    end

    
    if solverconfig.linsolve == :radau
        return radau()
    end


    if solverconfig.linsolve == :radau5
        return radau5()
    end

end

function generate_ODEFun(OdeFun,JacFun,parm,JacPrototype::SparseMatrixCSC,solverconfig::SolverConfig)
colorvec = matrix_colors(JacPrototype)

    # if solverconfig.linsolve in [:Band, :LapackBand]
    #     return ODEFunction{true,true}(OdeFun,colorvec=colorvec)
    # end

    if solverconfig.linsolve in [:KLU]
        # JacFun = generate_jacobian(OdeFun, JacPrototype, parm)
        return  ODEFunction{true,SciMLBase.AutoSpecialize}(OdeFun; jac = JacFun, jac_prototype = JacPrototype)

    end
    

    if solverconfig.linsolve in [:radau,:radau5]
        return  ODEFunction{true,SciMLBase.AutoSpecialize}(OdeFun; jac = JacFun)
    end

    if solverconfig.linsolve in [:GMRES, :FGMRES, :TFQMR,:BCG]
        # return  ODEFunction{true,true}(OdeFun,colorvec=colorvec,jac_prototype = JacVec(OdeFun, ones(size(JacPrototype,1))))
        # JVP = JacVecOperator(OdeFun,ones(size(JacPrototype,1)),parm,0.0,autodiff =true)
        # JacFun = generate_jacobian(OdeFun, JacPrototype, parm)
        # JVP = JacVec((du, u) -> OdeFun(du,u,parm,zero(eltype(JacPrototype))),ones(size(JacPrototype,1)),parm)
        JVP = JacVec((du, u, p) -> OdeFun(du,u,p,zero(eltype(JacPrototype))),ones(size(JacPrototype,1)),parm,nothing)
        # return  ODEFunction{true,SciMLBase.FullSpecialize}(OdeFun,colorvec=colorvec,sparsity =JacPrototype,jac_prototype=JVP,jac = JacFun)
        # return  ODEFunction{true,SciMLBase.FullSpecialize}(OdeFun,colorvec=colorvec,sparsity =JacPrototype,jac_prototype=JacPrototype,jac = JacFun)
        return  ODEFunction{true,SciMLBase.AutoSpecialize}(OdeFun,jac_prototype=JacPrototype,jvp=JVP)
        # return  ODEFunction{true,SciMLBase.AutoSpecialize}(OdeFun)
        # return  ODEFunction{true,SciMLBase.AutoSpecialize}(OdeFun,jac_prototype=JVP)

    end

    if solverconfig.linsolve in [:FBDF,:QNDF,:QBDF,:Rodas5P,:TRBDF2,:Rodas4P,:KenCarp4]
        # JacFun = generate_jacobian(OdeFun, JacPrototype, parm)
        # jv = JacVecOperator(OdeFun,ones(size(JacPrototype,1)),parm,0.0)
        # jvp = (Jv,v,u,p,t)-> mul!(Jv,jv(OdeFun,u,p,t),v)
        # JVP = JacVec((du, u) -> OdeFun(du,u,parm,zero(eltype(JacPrototype))),ones(size(JacPrototype,1)),parm)
        JVP = JacVec((du, u, p) -> OdeFun(du,u,p,zero(eltype(JacPrototype))),ones(size(JacPrototype,1)),parm,nothing)
        return  ODEFunction{true,SciMLBase.AutoSpecialize}(OdeFun,jac_prototype=JacPrototype,jvp=JVP,jac = JacFun)
    end

end


function modelrun(OdeFun,parm, JacPrototype::SparseMatrixCSC,solverconfig::SolverConfig,solutionconfig::SolutionConfig)

   println("Generate Jacobian function:")
   @time JacFun = generate_jacobian(OdeFun, JacPrototype,solutionconfig.u0)
   println("Generate ODE solver:")
   @time solver = generate_ODESolver(OdeFun,JacFun, JacPrototype, solverconfig,solutionconfig,parm);
   println("Generate ODE function:")
   @time OdeFunction = generate_ODEFun(OdeFun,JacFun,parm, JacPrototype, solverconfig)
   println("Generate ODE problem:")
   @time prob = ODEProblem{true,SciMLBase.AutoSpecialize}(OdeFunction, solutionconfig.u0, solutionconfig.tspan, parm)

    saveat = isnothing(solutionconfig.saveat) ? [] : vcat(convert(eltype(JacPrototype),1e-12),(solutionconfig.tspan[1]+solutionconfig.saveat):solutionconfig.saveat:solutionconfig.tspan[2])
    println("Solving ODE:")

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
        save_start = true,
        # tstops = tstops
        # dtmin = 1e-10
        # isoutofdomain = (u,p,t)->any(x->x<0,u)
    )
    println("$(sol.retcode) at t = $(sol.t[end]).")

    nt = length(sol.t)
    dC0 = similar(ones(eltype(JacPrototype),size(sol, 1)))
    IntValVarName = fieldnames(typeof(OdeFun))

    IntVal = Dict(string(i) => Matrix{Float64}(undef, nt,  parm.Ngrid) for i in IntValVarName)

    for i in 1:nt
        Base.@invokelatest OdeFun(dC0, sol.u[i], parm, zero(eltype(JacPrototype)))
        for j in IntValVarName
            IntVal[string(j)][i, :] .= getfield(OdeFun, j).du
        end
    end

    # println(sol.destats)
    return OutputConfig(sol,IntVal)
end

nothing