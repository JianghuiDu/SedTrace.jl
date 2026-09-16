using LinearAlgebra
using SparseArrays

function dependency_test_rhs!(du, u, A, t)
    mul!(du, A, u)
    return nothing
end

@testset "ILU0 sparsity changes" begin
    # The initial pattern lacks off-diagonals; later matrices introduce them.
    prototype = spdiagm(0 => ones(3))
    A = sparse([4.0 1.0 0.0; 1.0 4.0 1.0; 0.0 1.0 4.0])
    rhs = [1.0, 2.0, 3.0]
    for side in (1, 2)
        builder = SedTrace.generate_preconditioner2(:ILU0, side, prototype)
        for matrix in (A, 2A, prototype)
            Pl, Pr = builder(matrix, nothing)
            preconditioner = side == 1 ? Pl : Pr
            result = similar(rhs)
            ldiv!(result, preconditioner, rhs)
            @test matrix * result ≈ rhs
            @test builder.pattern.colptr == matrix.colptr
            @test rowvals(builder.pattern) == rowvals(matrix)
        end
    end
end

@testset "Solver dependency compatibility" begin
    A = sparse([-2.0 1.0 0.0; 1.0 -3.0 1.0; 0.0 1.0 -2.0])
    u0 = [1.0, 2.0, 3.0]
    tspan = (0.0, 0.1)
    expected = exp(Matrix(A) * last(tspan)) * u0
    configs = [(alg, prec, side)
        for alg in (:FBDF, :QNDF, :QBDF, :KenCarp4, :TRBDF2, :Rodas5P, :Rodas4P)
        for (prec, side) in ((:NO, 1), (:ILU0, 1), (:ILU0, 2))]
    append!(configs, [(:FBDF, prec, side) for prec in (:ILU, :AMG) for side in (1, 2)])
    append!(configs, [(:KLU, :NO, 1), (:GMRES, :ILU0, 2)])
    for (alg, prec, side) in configs
        @testset "$alg / $prec / side $side" begin
            prototype = copy(A)
            config = SedTrace.SolverConfig(alg, prec, side)
            solution = SedTrace.SolutionConfig(copy(u0), tspan)
            jac! = SedTrace.generate_jacobian(dependency_test_rhs!, prototype, u0, A, first(tspan))
            solver = SedTrace.generate_ODESolver(dependency_test_rhs!, jac!, prototype, config, solution, A)
            f = SedTrace.generate_ODEFun(dependency_test_rhs!, jac!, A, prototype, config)
            problem = SedTrace.ODEProblem(f, copy(u0), tspan, A)
            # Local error tolerances must be tighter than the global endpoint
            # check, especially for the second-order TRBDF2 method.
            result = SedTrace.SciMLBase.solve(problem, solver; reltol=1e-10, abstol=1e-12)
            @test SedTrace.SciMLBase.successful_retcode(result)
            @test result.u[end] ≈ expected rtol=1e-6 atol=1e-8
        end
    end
end
