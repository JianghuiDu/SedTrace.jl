function JacType(IDdict::Dict{Symbol,StepRangeLen{Int,Int,Int,Int}})
    Ngrid = length(first(IDdict)[2])
    nspec = length(IDdict)
    @unpack O2ID, HID, TCO2ID, TH2SID, TH3BO3ID = IDdict

    rowID = Vector{Int}()
    colID = Vector{Int}()
    append!(rowID, getindex(O2ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(O2ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(HID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(HID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TCO2ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(TCO2ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TCO2ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(HID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TH2SID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(TH2SID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TH2SID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(HID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TH3BO3ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(TH3BO3ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TH3BO3ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(HID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(HID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(TCO2ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(HID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(TH2SID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(HID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(TH3BO3ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    return sparse(
        rowID,
        colID,
        ones(length(rowID)),
        Ngrid * nspec,
        Ngrid * nspec,
    )
end
