# SparseDiffTools AD with sparsity pattern
function generate_jacobian(
    f,
    jp::Union{BandedMatrix{T},SparseMatrixCSC{T,Int}},
    # C0::Vector{T},
    chunk_size::Int,
) where {T}
    f_ = (du, u) -> f(du, u, nothing, 0.0)
    colors = SparseDiffTools.matrix_colors(jp)
    Nmat = size(jp,1)
    utmp = zeros(T,Nmat)
    dutmp = zeros(T,Nmat)
    jac_cache =
        ForwardColorJacCache(f_, utmp, chunk_size, dx = dutmp, colorvec = colors, sparsity = jp)
    return (J, u, p, t) -> SparseDiffTools.forwarddiff_color_jacobian!(J, f_, u, jac_cache)
end

# FiniteDiff FD with sparsity pattern
function generate_jacobian(
    f,
    jp::Union{BandedMatrix{T},SparseMatrixCSC{T,Int}},
) where {T}
    f_ = (y, x) -> f(y, x, nothing, 0.0)
    colors = SparseDiffTools.matrix_colors(jp)
    Nmat = size(jp,1)
    utmp = zeros(T,Nmat)
    dutmp = zeros(T,Nmat)
    dutmp1 = zeros(T,Nmat)
    jac_cache = FiniteDiff.JacobianCache(utmp,dutmp,dutmp1,Val{:complex}; colorvec = colors, sparsity = jp)
    return (J, u, p, t) -> FiniteDiff.finite_difference_jacobian!(J, f_, u, jac_cache,absstep=1e-8)
end

# ForwardDiff AD without sparsity pattern
function generate_jacobian(
    f,
    jp::Matrix{T},
    chunk_size::Int
) where {T}
    f_ = (y, x) -> f(y, x, nothing, 0.0)
    Nmat = size(jp,1)
    utmp = zeros(T,Nmat)
    dutmp = zeros(T,Nmat)
    conf = ForwardDiff.JacobianConfig(f_, dutmp, utmp, ForwardDiff.Chunk{chunk_size}())
    return (J, u, p, t) -> ForwardDiff.jacobian!(J, f_, dutmp, u, conf, Val(true))
end

nothing