function JacType()
    rowID = Vector{Int}()
    colID = Vector{Int}()
    append!(rowID, getindex(TNH4ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(TNH4ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TNH4ID, 1:Ngrid))
    append!(colID, getindex(NH3ID, 1:Ngrid))
    append!(rowID, getindex(NH3ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(NH3ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(NH3ID, 1:Ngrid))
    append!(colID, getindex(NH3ID, 1:Ngrid))
    return sparse(
        rowID,
        colID,
        ones(length(rowID)),
        Ngrid * nspec,
        Ngrid * nspec,
    )
end
