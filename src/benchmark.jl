function TestOdeFun(OdeFun,u0,parm)
	du0 = similar(u0)
	OdeFun(du0,u0,parm,0)
end

function TestJacobian(JacPrototype,OdeFun,C0,parm)
    jacp1 = similar(JacPrototype)
    jacp2 = Matrix(similar(JacPrototype))

    jac1 = SedTrace.generate_jacobian(OdeFun,jacp1,C0);
    jac2 = SedTrace.generate_jacobian(OdeFun,jacp2,C0);
    
    for i in 1:6
        u0 = rand(size(JacPrototype,1)).*10^(i-1)

        jac1(jacp1,u0,parm,0.0)
        jac2(jacp2,u0,parm,0.0)

        @assert Matrix(jacp1) == jacp2 "Auto-generated jacobian pattern is incorrect!"
        println("test $i sucessful.")
    end
end

function BenchmarkReactran(OdeFun,u0,parm)
    du0 = similar(u0)
    BenchmarkTools.@benchmark $OdeFun($du0,$u0,$parm,0.0)
end


function BenchmarkJacobian(JacPrototype,OdeFun,C0,parm)
    jac = similar(JacPrototype)
    jacfun = SedTrace.generate_jacobian(OdeFun,jac,C0)
    # u0 = rand(size(JacPrototype,1))
    BenchmarkTools.@benchmark $jacfun($jac,$C0,$parm,0.0)
end

function BenchmarkPreconditioner(JacPrototype,OdeFun,C0,parm,PrecType)
    jac = similar(JacPrototype)
    jacfun = SedTrace.generate_jacobian(OdeFun,jac,C0)

    p_prec = SedTrace.generate_preconditioner(PrecType, JacPrototype)
    psetup = SedTrace.default_psetup(p_prec, JacPrototype, jacfun,PrecType)
    prec = SedTrace.default_prec(p_prec)

    z = rand(size(JacPrototype,1))
    r = similar(z)

    u = rand(size(JacPrototype,1))
    du = similar(u)
    
    bmk1 = BenchmarkTools.@benchmarkable $psetup($parm, 0.0, $u, $du, true, Ref(1), 0.1)
    bmk2 = BenchmarkTools.@benchmarkable $prec($z,$r,$parm,0.0,$u,$du,0.1,0,1)

    print("Benchmark preconditioner setup\n")
    display(run(bmk1))
    print("Benchmark preconditioner\n")
    display(run(bmk2))

end