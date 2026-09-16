function J2M!(spmat::SparseMatrixCSC, gamma) #M=I-gamma*J
    rows = rowvals(spmat)
    vals = nonzeros(spmat)
    Nmat = size(spmat, 1)
    @inbounds for j = 1:Nmat
        @inbounds for i in nzrange(spmat, j)
            id = rows[i] == j ? 1 : 0
            vals[i] = id - gamma * vals[i]
        end
    end
end

function generate_preconditioner(PrecType::Symbol, p_sparse::SparseMatrixCSC)
    if PrecType == :NO
        return nothing
    elseif PrecType == :ILU0
        return ilu0(p_sparse)
    elseif PrecType == :ILU
        prectmp = ilu(p_sparse, τ = 0.5)
        return Ref(prectmp)
    # elseif PrecType == :AMG
    #     prectmp = AlgebraicMultigrid.aspreconditioner(
    #         AlgebraicMultigrid.ruge_stuben(
    #             p_sparse,
    #             presmoother = AlgebraicMultigrid.Jacobi(rand(size(p_sparse, 1))),
    #             postsmoother = AlgebraicMultigrid.Jacobi(rand(size(p_sparse, 1))),
    #         ),
    #     )
    #     return Ref(prectmp)
    else
        throw(
            error(
                "Preconditioner of type $PrecType is not allowed! Choose among nothing, ILU, ILU0 or AMD!",
            ),
        )
    end
end



function default_psetup(
    p_prec::ILUZero.ILU0Precon,
    p_sparse::SparseMatrixCSC,
    JacFun::Function,
    PrecType::Symbol,
)
    return function psetuilu0(p, t, u, du, jok, jcurPtr, gamma)
        if jok
            jcurPtr[] = true
            JacFun(p_sparse, u, p, t)
            J2M!(p_sparse, gamma)
            ILUZero.ilu0!(p_prec, p_sparse)
        end
    end
end

# function default_psetup(
#     p_prec::Preconditioners.CholeskyPreconditioner,
#     p_sparse::SparseMatrixCSC,
#     JacFun::Function,
#     PrecType::Symbol,
# )
#         return function psetupilu(p, t, u, du, jok, jcurPtr, gamma)
#             if jok
#                 jcurPtr[] = true
#                 JacFun(p_sparse, u, p, t)
#                 J2M!(p_sparse, gamma)
#                 # p_prec[] = ilu(p_sparse, τ = 0.5)
#                 Preconditioners.UpdatePreconditioner!(p_prec,p_sparse)
#             end
#         end
# end

function default_psetup(
    p_prec::Base.RefValue,
    p_sparse::SparseMatrixCSC,
    JacFun::Function,
    PrecType::Symbol,
)
    # if PrecType == :AMG
    #     return function psetupamg(p, t, u, du, jok, jcurPtr, gamma)
    #         if jok
    #             jcurPtr[] = true
    #             JacFun(p_sparse, u, p, t)
    #             J2M!(p_sparse, gamma)
    #             p_prec[] = AlgebraicMultigrid.aspreconditioner(
    #                 AlgebraicMultigrid.ruge_stuben(
    #                     p_sparse,
    #                     presmoother = AlgebraicMultigrid.Jacobi(rand(size(p_sparse, 1))),
    #                     postsmoother = AlgebraicMultigrid.Jacobi(rand(size(p_sparse, 1))),
    #                 ),
    #             )
    #         end
    #     end
    # elseif PrecType == :ILU
        return function psetupilu(p, t, u, du, jok, jcurPtr, gamma)
            if jok
                jcurPtr[] = true
                JacFun(p_sparse, u, p, t)
                J2M!(p_sparse, gamma)
                p_prec[] = ilu(p_sparse, τ = 0.5)
            end
        end
    # end
end


function default_prec(p_prec::ILUZero.ILU0Precon)
    return (z, r, p, t, y, fy, gamma, delta, lr) -> ldiv!(z, p_prec, r)
end
# function default_prec(p_prec::IncompleteLU.ILUFactorization)
#     return (z, r, p, t, y, fy, gamma, delta, lr) -> ldiv!(z, p_prec, r)
# end
function default_prec(p_prec_cache::Base.RefValue)
    return (z, r, p, t, y, fy, gamma, delta, lr) -> ldiv!(z, p_prec_cache[], r)
end

# ILUZero's index maps depend on the exact stored sparsity of W, which may differ
# from the Jacobian prototype (e.g. when the solver adds the identity matrix).
mutable struct ILU0Builder{P, M}
    cache::P
    pattern::M
    side::Int
end

function (builder::ILU0Builder)(W, p)
    A = convert(AbstractMatrix, W)
    if A.colptr == builder.pattern.colptr && rowvals(A) == rowvals(builder.pattern)
        ilu0!(builder.cache, A)
    else
        builder.cache = ilu0(A)
        builder.pattern = copy(A)
    end
    return builder.side == 1 ? (builder.cache, I) : (I, builder.cache)
end

# LinearSolve calls this builder when its system matrix changes and reuses the
# returned preconditioners between updates. The builder belongs to one solve.
function generate_preconditioner2(
    PrecType::Symbol,
    PrecSide::Int,
    p_sparse::SparseMatrixCSC,
)
    PrecSide in (1, 2) || throw(ArgumentError("Preconditioner side must be 1 (left) or 2 (right)"))
    sided(P) = PrecSide == 1 ? (P, I) : (I, P)
    if PrecType == :ILU0
        return ILU0Builder(ILUZero.ILU0Precon(p_sparse), copy(p_sparse), PrecSide)
    elseif PrecType == :ILU
        return (W, p) -> sided(ilu(convert(AbstractMatrix, W), τ = 0.5))
    elseif PrecType == :AMG
        return (W, p) -> sided(AlgebraicMultigrid.aspreconditioner(
            AlgebraicMultigrid.ruge_stuben(convert(AbstractMatrix, W))))
    end
    throw(ArgumentError("Unsupported preconditioner: $PrecType"))
end
Base.eltype(::IncompleteLU.ILUFactorization{Tv, Ti}) where {Tv, Ti} = Tv
