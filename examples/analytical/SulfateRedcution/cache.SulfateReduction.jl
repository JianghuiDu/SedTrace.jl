module Cache
using PreallocationTools, ForwardDiff
mutable struct Reactran{T}
    RPOCSO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_POC::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_SO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
end

function init(u0::Array{T,1}, Ngrid::Int, chunk_size::Int) where {T}
    RPOCSO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_POC = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_SO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)

    cache = Reactran(RPOCSO4, S_POC, S_SO4)
    return cache
end
end
nothing
