# struct TridiagonalLUCache{T}
#     LU::Tridiagonal{T,Vector{T}}# L: LU.dl & 1, U: lu.d & lu.du
#     cache::Array{T,1}
# end


# function factorize!(lu::TridiagonalLUCache, trimat::Tridiagonal)
#     lu.LU.d[1] = trimat.d[1]
#     for i = 2:Nmat
#         dll = trimat.dl[i-1] / lu.LU.d[i-1]
#         lu.LU.d[i] = trimat.d[i] - dll * trimat.du[i-1]
#         lu.LU.dl[i-1] = dll
#     end
#     lu.LU.du .= trimat.du
# end



# function LinearAlgebra.ldiv!(x, A::TridiagonalLUCache, y)
#     A.cache[1] = y[1]
#     for i = 2:Nmat
#         A.cache[i] = y[i] - A.LU.dl[i-1] * A.cache[i-1]
#     end
#     x[Nmat] = A.cache[Nmat] / A.LU.d[Nmat]
#     for i = Nmat-1:-1:1
#         x[i] = (A.cache[i] - A.LU.du[i] * x[i+1]) / A.LU.d[i]
#     end
# end


# function sp2tridiag!(trimat, spmat, gamma)
#     for j = 1:Nmat
#         if (j + 1 <= Nmat)
#             trimat.dl[j] = -gamma * spmat[j+1, j]
#         end
#         trimat.d[j] = 1 - gamma * spmat[j, j]
#         if (j >= 2)
#             trimat.du[j-1] = -gamma * spmat[j-1, j]
#         end
#     end
# end

function J2M!(spmat::SparseMatrixCSC, gamma) #M=I-gamma*J
    rows = rowvals(spmat)
    vals = nonzeros(spmat)
    Nmat = size(spmat,1)
    @inbounds for j = 1:Nmat
        @inbounds for i in nzrange(spmat, j)
            id = rows[i] == j ? 1 : 0
            vals[i] = id - gamma * vals[i]
        end
    end
end


function default_prec(p_prec)
    return (z, r, p, t, y, fy, gamma, delta, lr) -> ldiv!(z, p_prec, r)
end

# function default_psetup(p_prec::TridiagonalLUCache)
#     return function (p, t, u, du, jok, jcurPtr, gamma)
#         JacFun(p_sparse, u, p, t)
#         sp2tridiag!(p_trimat, p_sparse, gamma)
#         factorize!(p_prec, p_trimat)
#         jcurPtr[] = false
#     end
# end

function default_psetup(p_prec::ILUZero.ILU0Precon,p_sparse::SparseMatrixCSC,JacFun::Function)
    return function (p, t, u, du, jok, jcurPtr, gamma)
        if jok
            jcurPtr[] = true
            JacFun(p_sparse, u, p, t)
            J2M!(p_sparse, gamma)
            ILUZero.ilu0!(p_prec, p_sparse)
        end
    end
end

# function default_psetup(p_prec::Preconditioners.AMGPreconditioner)
#     return function (p, t, u, du, jok, jcurPtr, gamma)
#         JacFun(p_sparse, u, p, t)
#         J2M!(p_sparse, gamma)
#         UpdatePreconditioner!(p_prec, p_sparse)
#         jcurPtr[] = false
#     end
# end

function generate_preconditioner(PrecType::Symbol, p_sparse::SparseMatrixCSC)
    if PrecType == :NO
        return nothing
    elseif PrecType == :TRD
        return TridiagonalLUCache(
            Tridiagonal(ones(Nmat - 1), ones(Nmat), ones(Nmat - 1)),
            zeros(Nmat),
        )
    elseif PrecType == :ILU0
        return ilu0(p_sparse)
    elseif PrecType == :AMD
        return AMGPreconditioner{RugeStuben}(p_sparse)
    else
        throw(
            error(
                "Preconditioner of type $PrecType is not allowed! Choose among nothing, TRD, ILU0 or AMD!",
            ),
        )
    end
end


                  

# p_prec_ILU0 = ilu0(p_sparse);
# prec = default_prec(p_prec_ILU0)
# psetup = default_psetup(p_prec_ILU0)

# p_sparse = jacptype();
# p_trimat = Tridiagonal(ones(Nmat - 1), ones(Nmat), ones(Nmat - 1));


 function SciMLprecSetup(p_sparse::SparseMatrixCSC)
    return function SciMLPrec(W,du,u,p,t,newW,Plprev,Prprev,solverdata)
        if newW === nothing 
        Plprev = ilu0(p_sparse)
        elseif newW
        ilu0!(Plprev,convert(AbstractMatrix,W))
        end
        Plprev,nothing
    end
end
            

nothing


# @benchmark JacFun($p_sparse, $C0, nothing, 0)
# @benchmark J2M!($p_sparse, 0.1)
# @benchmark UpdatePreconditioner!(p_prec_AMG, p_sparse)


# C0 = C_uni;
# dC0 = similar(C0);
# z = ones(Nmat);
# r = rand(Nmat);

# @benchmark psetup(nothing, 0, $C0, $dC0, false, false, 0.1)
# @benchmark default_prec($z,$r,nothing,0,$C0,$dC0,0.1,0,1)

# # psp = jacptype()
# # JacFun(psp,C0,nothing,0)
# # J2M!(psp,gamma)
# # p_prec = IncompleteLU.ilu(psp;τ=1e-5)
# # C0 = C_uni;
# # dC0 = similar(C0);
# # z = ones(Nmat);
# # r = rand(Nmat);

# # @benchmark default_presetup(nothing,0,$C0,$dC0,false,false,0.1)
# # @benchmark default_prec($z,$r,nothing,0,$C0,$dC0,0.1,0,1)

# pconc = AMGPreconditioner{RugeStuben}(p_sparse)
# # UpdatePreconditioner!(pconc, p_sparse)

# using ILUZero
# LU = ilu0(p_sparse)
# ilu0!(LU, p_sparse)


# @benchmark J2M!($p_sparse, 0.1)
# @benchmark ilu0!($p_prec, $p_sparse)
# @benchmark UpdatePreconditioner!($p_prec, $p_sparse)
