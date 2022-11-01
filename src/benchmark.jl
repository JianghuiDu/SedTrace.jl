function TestOdeFun(OdeFun,u0,parm)
	du0 = similar(u0)
	OdeFun(du0,u0,parm,0)
end

function TestJacobian(JacPrototype,OdeFun,parm)
    jacp1 = similar(JacPrototype)
    jacp2 = Matrix(similar(JacPrototype))

    jac1 = SedTrace.generate_jacobian(OdeFun,jacp1,parm);
    jac2 = SedTrace.generate_jacobian(OdeFun,jacp2,parm);
    
    for i in 1:6
        u0 = rand(size(JacPrototype,1)).*10^(i-1)

        jac1(jacp1,u0,parm,0)
        jac2(jacp2,u0,parm,0)

        @assert Matrix(jacp1) == jacp2 "Auto-generated jacobian pattern is incorrect!"
        println("test $i sucessful.")
    end
end

function BenchmarkReactran(OdeFun,u0,parm)
    du0 = similar(u0)
    BenchmarkTools.@benchmark $OdeFun($du0,$u0,$parm,0)
end


function BenchmarkJacobian(JacPrototype,OdeFun,parm)
    jac = similar(JacPrototype)
    jacfun = SedTrace.generate_jacobian(OdeFun,jac,parm)
    u0 = rand(size(JacPrototype,1))
    BenchmarkTools.@benchmark $jacfun($jac,$u0,$parm,0)
end

function BenchmarkPreconditioner(JacPrototype,OdeFun,parm,PrecType=:ILU0)
    jac = similar(JacPrototype)
    jacfun = SedTrace.generate_jacobian(OdeFun,jac,parm)

    p_prec = SedTrace.generate_preconditioner(PrecType, JacPrototype)
    psetup = SedTrace.default_psetup(p_prec, JacPrototype, jacfun)
    prec = SedTrace.default_prec(p_prec)

    z = rand(size(JacPrototype,1))
    r = similar(z)

    u = rand(size(JacPrototype,1))
    du = similar(u)
    
    bmk1 = BenchmarkTools.@benchmarkable $psetup($parm, 0, $u, $du, true, Ref(1), 0.1)
    bmk2 = BenchmarkTools.@benchmarkable $prec($z,$r,$parm,0,$u,$du,0.1,0,1)

    print("Benchmark preconditioner setup\n")
    display(run(bmk1))
    print("Benchmark preconditioner\n")
    display(run(bmk2))

end