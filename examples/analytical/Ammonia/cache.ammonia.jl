module Cache
using PreallocationTools, ForwardDiff
mutable struct Reactran{T}
    NH4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    NH4_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    NH4_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    NH4_ads_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Rremin::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_TNH4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_N_org::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
end

function init(u0::Array{T,1}, Ngrid::Int, chunk_size::Int) where {T}
    NH4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    NH4_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    NH4_ads = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    NH4_ads_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Rremin = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_TNH4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_N_org = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)

    cache =
        Reactran(NH4, NH4_tran, NH4_ads, NH4_ads_tran, Rremin, S_TNH4, S_N_org)
    return cache
end
end
