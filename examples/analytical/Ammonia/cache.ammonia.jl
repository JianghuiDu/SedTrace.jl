module Cache
using PreallocationTools, ForwardDiff
mutable struct Reactran{T}
    NH4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    NH4_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    NH4_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    NH4_ads_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Rdenitr::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_TNH4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_NH3::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
end

function init(u0::Array{T,1}, Ngrid::Int, chunk_size::Int) where {T}
    NH4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    NH4_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    NH4_ads = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    NH4_ads_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Rdenitr = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_TNH4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_NH3 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)

    cache =
        Reactran(NH4, NH4_tran, NH4_ads, NH4_ads_tran, Rdenitr, S_TNH4, S_NH3)
    return cache
end
end
nothing
