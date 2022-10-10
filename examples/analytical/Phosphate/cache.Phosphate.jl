module Cache
using PreallocationTools, ForwardDiff
mutable struct Reactran{T}
    P_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TH3PO4_ads_nsf::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TH3PO4_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TH3PO4_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TH3PO4_dis_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TH3PO4_ads_nsf_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Rremin::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Rpre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_Porg::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_TH3PO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
end

function init(u0::Array{T,1}, Ngrid::Int, chunk_size::Int) where {T}
    P_ads = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TH3PO4_ads_nsf = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TH3PO4_ads = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TH3PO4_dis = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TH3PO4_dis_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TH3PO4_ads_nsf_tran =
        PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Rremin = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Rpre = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_Porg = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_TH3PO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)

    cache = Reactran(
        P_ads,
        TH3PO4_ads_nsf,
        TH3PO4_ads,
        TH3PO4_dis,
        TH3PO4_dis_tran,
        TH3PO4_ads_nsf_tran,
        Rremin,
        Rpre,
        S_Porg,
        S_TH3PO4,
    )
    return cache
end
end
