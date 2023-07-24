# SparseDiffTools AD with sparsity pattern
function generate_jacobian(
    f,
    # jp::Union{BandedMatrix{T},SparseMatrixCSC{T,Int}},
    jp::SparseMatrixCSC{T,Int},
    C0::Vector{T},
    # chunk_size::Int,
    # parm
) where {T}
    # f_ = (du, u) -> f(du, u, parm, t)
    colors = SparseDiffTools.matrix_colors(jp)
    # Nmat = size(jp,1)
    # utmp = zeros(T,Nmat)
    # dutmp = zeros(T,Nmat)
    # chunk_size = ForwardDiff.pickchunksize(Nmat)
    jac_cache = SparseDiffTools.ForwardColorJacCache(nothing, C0, colorvec = colors, sparsity = jp)
    
    return (J, u, p, t) -> SparseDiffTools.forwarddiff_color_jacobian!(J, (y,x)->f(y,x,p,t), u, jac_cache)
end

# FiniteDiff FD with sparsity pattern
function generate_jacobian_fd(
    f,
    jp::SparseMatrixCSC{T,Int},
    parm
) where {T}
    f_ = (y, x) -> f(y, x, parm, 0.0)
    colors = SparseDiffTools.matrix_colors(jp)
    Nmat = size(jp,1)
    utmp = zeros(T,Nmat)
    dutmp = zeros(T,Nmat)
    dutmp1 = zeros(T,Nmat)
    jac_cache = FiniteDiff.JacobianCache(utmp,dutmp,dutmp1,Val{:complex}; colorvec = colors, sparsity = jp)
    jacfun = let f_ = f_, jac_cache = jac_cache
        (J, u, p, t) -> FiniteDiff.finite_difference_jacobian!(J, f_, u, jac_cache)
    end
    return jacfun
end

# ForwardDiff AD without sparsity pattern
# function generate_jacobian(
#     f,
#     jp::Matrix{T},
#     # chunk_size::Int,
#     # parm,
#     C0
# ) where {T}
#     # f_ = (y, x) -> f(y, x, parm, 0.0)
#     Nmat = size(jp,1)
#     # utmp = zeros(T,Nmat)
#     dutmp = zeros(T,Nmat)
#     # chunk_size = ForwardDiff.pickchunksize(Nmat)
#     conf = ForwardDiff.JacobianConfig(nothing, dutmp, C0)
#     return (J, u, p, t) -> ForwardDiff.jacobian!(J, (y, x) -> f(y, x, p, t), dutmp, C0,conf, Val(true))
# end

function generate_jacobian(
    f,
    jp::Matrix{T},
    C0::Vector{T},
) where {T}
    jac_cache = SparseDiffTools.ForwardColorJacCache(nothing, C0,  sparsity = nothing)
    
    return (J, u, p, t) -> SparseDiffTools.forwarddiff_color_jacobian!(J, (y,x)->f(y,x,p,t), u, jac_cache)
end

nothing