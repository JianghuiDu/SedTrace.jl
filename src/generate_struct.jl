function struct_code(cache)
    struct_str = String[]
    push!(struct_str, "mutable struct Reactran{T,chunk_size}")
    for i in cache
        push!(struct_str, i * "::PreallocationTools.DiffCache{
           Array{T,1},
           Array{ForwardDiff.Dual{nothing,T,chunk_size},1},
       }")
    end
    push!(struct_str, "end")


    push!(struct_str, "")
    push!(
        struct_str,
        "function init(u0::Array{T,1},Ngrid::Int, ::Val{chunk_size}) where {T,chunk_size}",
    )
    for i in cache
        push!(struct_str, i * "= PreallocationTools.dualcache(zeros(T,Ngrid), Val{chunk_size})")
    end
    push!(struct_str, "")

    push!(struct_str, "    cache = Reactran(")
    for i in cache
        push!(struct_str, i * ",")
    end
    push!(struct_str, ")")

    push!(struct_str, "return cache")
    push!(struct_str, "end")

    return struct_str
end
