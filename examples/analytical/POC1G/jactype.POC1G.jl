function JacType(IDdict::Dict{Symbol,StepRangeLen{Int,Int,Int,Int}})
    Ngrid = length(first(IDdict)[2])
    nspec = length(IDdict)
    @unpack POCID = IDdict

    rowID = Vector{Int}()
    colID = Vector{Int}()
    append!(rowID, getindex(POCID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(POCID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(POCID, 1:Ngrid))
    append!(colID, getindex(POCID, 1:Ngrid))
    return sparse(
        rowID,
        colID,
        ones(length(rowID)),
        Ngrid * nspec,
        Ngrid * nspec,
    )
end
