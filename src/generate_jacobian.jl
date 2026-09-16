using LinearAlgebra

# DifferentiationInterface AD with sparsity pattern
struct OdeResidualWrapper{F, P, T}
    f::F
    p::P
    t::T
end

function (w::OdeResidualWrapper)(y, x)
    w.f(y, x, w.p, w.t)
end

"""
    generate_jacobian(f, jp, u0, p0, t0)

Prepare a Jacobian callback with scratch storage owned by one solve. Runtime
parameters and time are held in a call-local immutable wrapper on each evaluation
(mutable parameter contents are not copied).
Reuse requires compatible input types/sizes and an unchanged sparsity pattern.
The callback is not reentrant: concurrent solves must construct separate
callbacks, JVP objects, mutable model workspaces, and output matrices.
"""
function generate_jacobian(
    f,
    jp::SparseMatrixCSC{T,Int},
    C0,
    p0,
    t0,
) where {T}
    backend = AutoSparse(
        AutoForwardDiff();
        sparsity_detector = ADTypes.KnownJacobianSparsityDetector(jp),
        coloring_algorithm = GreedyColoringAlgorithm()
    )
    
    return prepare_ode_jacobian(f, backend, C0, p0, t0)
end

# FiniteDiff FD with sparsity pattern
function generate_jacobian_fd(
    f,
    jp::SparseMatrixCSC{T,Int},
    C0,
    p0,
    t0,
) where {T}
    backend = AutoSparse(
        AutoFiniteDiff();
        sparsity_detector = ADTypes.KnownJacobianSparsityDetector(jp),
        coloring_algorithm = GreedyColoringAlgorithm()
    )
    return prepare_ode_jacobian(f, backend, C0, p0, t0)
end

# Preserve the existing finite-difference constructor for callers without u0.
generate_jacobian_fd(f, jp::SparseMatrixCSC{T,Int}, p0) where {T} =
    generate_jacobian_fd(f, jp, zeros(T, size(jp, 2)), p0, zero(T))

# ForwardDiff AD without sparsity pattern
function generate_jacobian(
    f,
    jp::Matrix{T},
    C0::Vector{T},
    p0,
    t0,
) where {T}
    backend = AutoForwardDiff()
    return prepare_ode_jacobian(f, backend, C0, p0, t0)
end

function prepare_ode_jacobian(f, backend, C0, p0, t0)
    y = similar(C0)
    prep = prepare_jacobian(OdeResidualWrapper(f, p0, t0), y, backend, C0)
    
    return (J, u, p, t) -> begin
        jacobian!(OdeResidualWrapper(f, p, t), y, J, prep, backend, u)
        return J
    end
end

# Like the Jacobian callback, a JVP owns its buffers but keeps runtime p and t
# local. In particular, a time-dependent residual must not be frozen at t = 0.
function generate_jvp(f, u0, p0, t0)
    backend = AutoForwardDiff()
    y = similar(u0)
    direction = zero(u0)
    prep = prepare_pushforward(OdeResidualWrapper(f, p0, t0), y, backend, u0, (direction,))
    return (Jv, v, u, p, t) -> begin
        pushforward!(OdeResidualWrapper(f, p, t), y, (Jv,), prep, backend, u, (v,))
        return Jv
    end
end

# Compatibility wrapper for matrix_colors
function matrix_colors(A::SparseMatrixCSC)
    coloring_prob = ColoringProblem(; structure = :nonsymmetric, partition = :column)
    coloring_alg = GreedyColoringAlgorithm()
    coloring_result = coloring(A, coloring_prob, coloring_alg)
    return column_colors(coloring_result)
end

# Compatibility wrapper for JacVec
struct JacVecFunctionWrapper{F, P}
    f::F
    p::P
end
(w::JacVecFunctionWrapper)(y, x) = w.f(y, x, w.p)

# One JacVec per solve; its state and AD work buffers must not be shared by
# concurrent evaluations. The wrapped model must own its mutable buffers too.
mutable struct JacVec{F, U, P, Prep, B}
    f::F
    u::U
    p::P
    prep::Prep
    backend::B
    y::U
end

function JacVec(f, u::AbstractVector{T}, p, autodiff=nothing) where {T}
    backend = AutoForwardDiff()
    w = JacVecFunctionWrapper(f, p)
    y = similar(u)
    dx = similar(u)
    fill!(dx, zero(T))
    prep = prepare_pushforward(w, y, backend, u, (dx,))
    return JacVec(f, copy(u), p, prep, backend, y)
end

function LinearAlgebra.mul!(res::AbstractVector, L::JacVec, v::AbstractVector)
    w = JacVecFunctionWrapper(L.f, L.p)
    pushforward!(w, L.y, (res,), L.prep, L.backend, L.u, (v,))
    return res
end

function (L::JacVec)(Jv, v, u, p, t=0.0)
    L.u .= u
    L.p = p
    mul!(Jv, L, v)
    return Jv
end

nothing
