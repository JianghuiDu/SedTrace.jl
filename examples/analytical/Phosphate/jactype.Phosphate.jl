function JacType(IDdict::Dict{Symbol,StepRangeLen{Int,Int,Int,Int}})
    Ngrid = length(first(IDdict)[2])
    nspec = length(IDdict)
    @unpack PorgID, TH3PO4ID = IDdict

    rowID = Vector{Int}()
    colID = Vector{Int}()
    append!(rowID, getindex(PorgID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(PorgID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(PorgID, 1:Ngrid))
    append!(colID, getindex(PorgID, 1:Ngrid))
    append!(rowID, getindex(TH3PO4ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(TH3PO4ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TH3PO4ID, 1:Ngrid))
    append!(colID, getindex(PorgID, 1:Ngrid))
    append!(rowID, getindex(TH3PO4ID, 1:Ngrid))
    append!(colID, getindex(TH3PO4ID, 1:Ngrid))
    return sparse(
        rowID,
        colID,
        ones(length(rowID)),
        Ngrid * nspec,
        Ngrid * nspec,
    )
end
