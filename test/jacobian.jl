using SparseArrays

# A nonlinear, parameter- and time-dependent residual with a non-full pattern.
function cache_test_residual!(du, u, p, t)
    du[1] = p[1] * u[1]^2 + t * u[2]
    yield() # Encourage overlapping use of derivative workspaces across tasks.
    du[2] = p[2] * u[2]^2
    return nothing
end

cache_test_exact(u, p, t) = [2p[1]*u[1] t; 0.0 2p[2]*u[2]]

@testset "Jacobian cache ownership" begin
    u0 = [1.0, 2.0]
    p0 = [2.0, 3.0]
    pattern = sparse([1, 1, 2], [1, 2, 2], ones(3), 2, 2)
    for mode in (:sparse, :dense, :finite_difference)
        @testset "$mode" begin
            make_callback() = mode == :finite_difference ?
                SedTrace.generate_jacobian_fd(cache_test_residual!, copy(pattern), u0, p0, 0.0) :
                SedTrace.generate_jacobian(cache_test_residual!,
                    mode == :dense ? Matrix(pattern) : copy(pattern), u0, p0, 0.0)
            make_output() = mode == :dense ? zeros(2, 2) : copy(pattern)
            jac! = make_callback()
            J = make_output()
            for k in 1:8
                u, p, t = u0 .+ k, p0 .- k / 3, Float64(k)
                @test jac!(J, u, p, t) === J
                @test Matrix(J) ≈ cache_test_exact(u, p, t) rtol=1e-5 atol=1e-7
            end

            # Each task owns its callback and output. Run with JULIA_NUM_THREADS=4
            # to exercise simultaneous evaluations, including different p and t.
            tasks = map(1:8) do task_id
                Threads.@spawn begin
                    local_jac! = make_callback()
                    local_J = make_output()
                    all(1:20) do k
                        task_u = u0 .+ (task_id + k / 10)
                        task_p = p0 .+ task_id / 2
                        task_t = Float64(task_id + k)
                        yield()
                        local_jac!(local_J, task_u, task_p, task_t)
                        isapprox(Matrix(local_J), cache_test_exact(task_u, task_p, task_t);
                            rtol=1e-5, atol=1e-7)
                    end
                end
            end
            @test all(fetch.(tasks))
        end
    end

    legacy_fd = SedTrace.generate_jacobian_fd(cache_test_residual!, pattern, p0)
    J = copy(pattern)
    legacy_fd(J, u0, p0 .+ 1, 3.0)
    @test Matrix(J) ≈ cache_test_exact(u0, p0 .+ 1, 3.0) rtol=1e-5

    @testset "Time-dependent JVP" begin
        v = [0.3, -0.7]
        tasks = map(1:8) do task_id
            Threads.@spawn begin
                jvp! = SedTrace.generate_jvp(cache_test_residual!, u0, p0, 0.0)
                Jv = similar(u0)
                all(1:20) do k
                    u, p, t = u0 .+ k, p0 .+ task_id, Float64(task_id + k)
                    jvp!(Jv, v, u, p, t)
                    isapprox(Jv, cache_test_exact(u, p, t) * v)
                end
            end
        end
        @test all(fetch.(tasks))
        # Exercise the callbacks actually wired into both solver families.
        for alg in (:GMRES, :FBDF)
            config = SolverConfig(alg, :ILU0, 2)
            jac! = SedTrace.generate_jacobian(cache_test_residual!, pattern, u0, p0, 0.0)
            f = SedTrace.generate_ODEFun(cache_test_residual!, jac!, p0, pattern, config)
            Jv = similar(u0)
            f.jvp(Jv, v, u0, p0 .+ 1, 3.0)
            @test Jv ≈ cache_test_exact(u0, p0 .+ 1, 3.0) * v
        end
    end
end
