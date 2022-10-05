module Cache
using PreallocationTools, ForwardDiff
mutable struct Reactran{T}
    NH4_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNH4_ads_nsf::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNH4_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNH4_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNH4_dis_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TNH4_ads_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Rremin::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_N_org::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_TNH4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
end

function init(u0::Array{T,1}, Ngrid::Int, chunk_size::Int) where {T}
    NH4_ads = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TNH4_ads_nsf = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TNH4_ads = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TNH4_dis = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TNH4_dis_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TNH4_ads_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Rremin = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_N_org = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_TNH4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)

    cache = Reactran(
        NH4_ads,
        TNH4_ads_nsf,
        TNH4_ads,
        TNH4_dis,
        TNH4_dis_tran,
        TNH4_ads_tran,
        Rremin,
        S_N_org,
        S_TNH4,
    )
    return cache
end
end
