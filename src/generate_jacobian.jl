using LinearAlgebra

# DifferentiationInterface AD with sparsity pattern
struct OdeResidualWrapper{F, P, T}
    f::F
    p_ref::Ref{P}
    t_ref::Ref{T}
end

function (w::OdeResidualWrapper)(y, x)
    w.f(y, x, w.p_ref[], w.t_ref[])
end

function generate_jacobian(
    f,
    jp::SparseMatrixCSC{T,Int},
    C0,
) where {T}
    backend = AutoSparse(
        AutoForwardDiff();
        sparsity_detector = ADTypes.KnownJacobianSparsityDetector(jp),
        coloring_algorithm = GreedyColoringAlgorithm()
    )
    
    prep_ref = Ref{Any}(nothing)
    w_ref = Ref{Any}(nothing)
    y = similar(C0)
    
    return (J, u, p, t) -> begin
        if isnothing(prep_ref[])
            p_ref = Ref(p)
            t_ref = Ref(t)
            w = OdeResidualWrapper(f, p_ref, t_ref)
            w_ref[] = w
            prep_ref[] = prepare_jacobian(w, y, backend, u)
        else
            w_ref[].p_ref[] = p
            w_ref[].t_ref[] = t
        end
        jacobian!(w_ref[], y, J, prep_ref[], backend, u)
        return J
    end
end

# FiniteDiff FD with sparsity pattern
function generate_jacobian_fd(
    f,
    jp::SparseMatrixCSC{T,Int},
    parm
) where {T}
    backend = AutoSparse(
        AutoFiniteDiff();
        sparsity_detector = ADTypes.KnownJacobianSparsityDetector(jp),
        coloring_algorithm = GreedyColoringAlgorithm()
    )
    f_ = (y, x) -> f(y, x, parm, 0.0)
    Nmat = size(jp, 1)
    y = zeros(T, Nmat)
    u_proto = zeros(T, Nmat)
    prep = prepare_jacobian(f_, y, backend, u_proto)
    
    return (J, u, p, t) -> begin
        jacobian!(f_, y, J, prep, backend, u)
        return J
    end
end

# ForwardDiff AD without sparsity pattern
function generate_jacobian(
    f,
    jp::Matrix{T},
    C0::Vector{T},
) where {T}
    backend = AutoForwardDiff()
    prep_ref = Ref{Any}(nothing)
    w_ref = Ref{Any}(nothing)
    y = similar(C0)
    
    return (J, u, p, t) -> begin
        if isnothing(prep_ref[])
            p_ref = Ref(p)
            t_ref = Ref(t)
            w = OdeResidualWrapper(f, p_ref, t_ref)
            w_ref[] = w
            prep_ref[] = prepare_jacobian(w, y, backend, u)
        else
            w_ref[].p_ref[] = p
            w_ref[].t_ref[] = t
        end
        jacobian!(w_ref[], y, J, prep_ref[], backend, u)
        return J
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