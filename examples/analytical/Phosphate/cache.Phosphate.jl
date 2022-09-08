module Cache
using PreallocationTools, ForwardDiff
mutable struct Reactran{T}
    H3PO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H3PO4_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    P_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    P_ads_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Rremin::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Rpre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_Porg::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_TH3PO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
end

function init(u0::Array{T,1}, Ngrid::Int, chunk_size::Int) where {T}
    H3PO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H3PO4_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    P_ads = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    P_ads_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Rremin = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Rpre = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_Porg = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_TH3PO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)

    cache = Reactran(
        H3PO4,
        H3PO4_tran,
        P_ads,
        P_ads_tran,
        Rremin,
        Rpre,
        S_Porg,
        S_TH3PO4,
    )
    return cache
end
end
nothing
