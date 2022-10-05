function JacType(
    IDdict::Dict{Symbol,StepRangeLen{Int,Int,Int,Int}},
    Ngrid::Int,
    nspec::Int,
)
    @unpack N_orgID, TNH4ID = IDdict

    rowID = Vector{Int}()
    colID = Vector{Int}()
    append!(rowID, getindex(N_orgID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(N_orgID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(N_orgID, 1:Ngrid))
    append!(colID, getindex(N_orgID, 1:Ngrid))
    append!(rowID, getindex(TNH4ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(TNH4ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TNH4ID, 1:Ngrid))
    append!(colID, getindex(N_orgID, 1:Ngrid))
    return sparse(
        rowID,
        colID,
        ones(length(rowID)),
        Ngrid * nspec,
        Ngrid * nspec,
    )
end
