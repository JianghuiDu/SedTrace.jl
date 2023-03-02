module Cache
using PreallocationTools, ForwardDiff
struct Reactran{T}
    RPOC::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_POC::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
end

function init(u0::Array{T,1}, Ngrid::Int) where {T}
    RPOC = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_POC = PreallocationTools.DiffCache(zeros(T, Ngrid))

    cache = Reactran(RPOC, S_POC)
    return cache
end
end
