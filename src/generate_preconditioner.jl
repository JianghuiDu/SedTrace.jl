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
    elseif PrecType == :AMG
        prectmp = AlgebraicMultigrid.aspreconditioner(
            AlgebraicMultigrid.ruge_stuben(
                p_sparse,
                presmoother = AlgebraicMultigrid.Jacobi(rand(size(p_sparse, 1))),
                postsmoother = AlgebraicMultigrid.Jacobi(rand(size(p_sparse, 1))),
            ),
        )
        return Ref(prectmp)
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
    if PrecType == :AMG
        return function psetupamg(p, t, u, du, jok, jcurPtr, gamma)
            if jok
                jcurPtr[] = true
                JacFun(p_sparse, u, p, t)
                J2M!(p_sparse, gamma)
                p_prec[] = AlgebraicMultigrid.aspreconditioner(
                    AlgebraicMultigrid.ruge_stuben(
                        p_sparse,
                        presmoother = AlgebraicMultigrid.Jacobi(rand(size(p_sparse, 1))),
                        postsmoother = AlgebraicMultigrid.Jacobi(rand(size(p_sparse, 1))),
                    ),
                )
            end
        end
    elseif PrecType == :ILU
        return function psetupilu(p, t, u, du, jok, jcurPtr, gamma)
            if jok
                jcurPtr[] = true
                JacFun(p_sparse, u, p, t)
                J2M!(p_sparse, gamma)
                p_prec[] = ilu(p_sparse, τ = 0.5)
            end
        end
    end
end


function default_prec(p_prec::ILUZero.ILU0Precon)
    return (z, r, p, t, y, fy, gamma, delta, lr) -> ldiv!(z, p_prec, r)
end
function default_prec(p_prec::IncompleteLU.ILUFactorization)
    return (z, r, p, t, y, fy, gamma, delta, lr) -> ldiv!(z, p_prec, r)
end
function default_prec(p_prec_cache::Base.RefValue)
    return (z, r, p, t, y, fy, gamma, delta, lr) -> ldiv!(z, p_prec_cache[], r)
end

function generate_preconditioner2(
    PrecType::Symbol,
    PrecSide::Int,
    p_sparse::SparseMatrixCSC,
)
    if PrecType == :ILU
        if PrecSide == 1
            return function incompletelu1(W, du, u, p, t, newW, Plprev, Prprev, solverdata)
                if newW === nothing || newW
                    Pl = ilu(convert(AbstractMatrix, W), τ = 0.5)
                else
                    Pl = Plprev
                end
                Pl, nothing
            end
        elseif PrecSide == 2
            return function incompletelu2(W, du, u, p, t, newW, Plprev, Prprev, solverdata)
                if newW === nothing || newW
                    Pl = ilu(convert(AbstractMatrix, W), τ = 0.5)
                else
                    Pl = Prprev
                end
                nothing, Pl
            end
        else
            throw(
                error("Preconditioner can only be left (1) or right (2) in solverconfig!"),
            )
        end
    elseif PrecType == :AMG
        if PrecSide == 1
            return function algebraicmultigrid1(W, du, u, p, t, newW, Plprev, Prprev, solverdata)
                if newW === nothing || newW
                    A = convert(AbstractMatrix, W)
                    Pl = AlgebraicMultigrid.aspreconditioner(
                        AlgebraicMultigrid.ruge_stuben(
                            A,
                            presmoother = AlgebraicMultigrid.Jacobi(rand(size(A, 1))),
                            postsmoother = AlgebraicMultigrid.Jacobi(rand(size(A, 1))),
                        ),
                    )
                else
                    Pl = Plprev
                end
                Pl,nothing
            end
        elseif PrecSide == 2
            return function algebraicmultigrid2(W, du, u, p, t, newW, Plprev, Prprev, solverdata)
                if newW === nothing || newW
                    A = convert(AbstractMatrix, W)
                    Pl = AlgebraicMultigrid.aspreconditioner(
                        AlgebraicMultigrid.ruge_stuben(
                            A,
                            presmoother = AlgebraicMultigrid.Jacobi(rand(size(A, 1))),
                            postsmoother = AlgebraicMultigrid.Jacobi(rand(size(A, 1))),
                        ),
                    )
                else
                    Pl = Prprev
                end
                nothing, Pl
            end
        else
            throw(
                error("Preconditioner can only be left (1) or right (2) in solverconfig!"),
            )
        end

    elseif PrecType == :ILU0
        if PrecSide == 1
            return function ilu0pre1(W, du, u, p, t, newW, Plprev, Prprev, solverdata)
                if newW === nothing
                    return (ilu0(convert(AbstractMatrix, W)),nothing)
                elseif newW
                    ilu0!(Plprev, convert(AbstractMatrix, W))
                    return (Plprev, nothing)
                else
                    return (Plprev, nothing)
                end
            end
        elseif PrecSide == 2
            return function ilu0pre2(W, du, u, p, t, newW, Plprev, Prprev, solverdata)
                if newW === nothing
                    return (nothing, ilu0(convert(AbstractMatrix, W)))
                elseif newW
                    ilu0!(Prprev, convert(AbstractMatrix, W))
                    return (nothing, Prprev)
                else
                    return (nothing, Prprev)
                end
            end
        else
            throw(
                error("Preconditioner can only be left (1) or right (2) in solverconfig!"),
            )
        end


    end
end
