function JacType(IDdict::Dict{Symbol,StepRangeLen{Int,Int,Int,Int}})
    Ngrid = length(first(IDdict)[2])
    nspec = length(IDdict)
    @unpack POCID,
    MnO2ID,
    FeOOHID,
    FeSID,
    FeS2ID,
    CaCO3ID,
    MnCO3ID,
    FeCO3ID,
    BSiID,
    SMolID,
    SMohID,
    O2ID,
    NO3ID,
    CH4ID,
    NO2ID,
    CaID,
    H4SiO4ID,
    TMnID,
    TFeID,
    TNH4ID,
    MolID,
    MohID,
    TH3PO4ID,
    THSO4ID,
    HID,
    TCO2ID,
    TH2SID,
    THFID,
    AgeID,
    LMolID,
    LMohID,
    TH3BO3ID = IDdict

    rowID = Vector{Int}()
    colID = Vector{Int}()
    append!(rowID, getindex(POCID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(POCID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(POCID, 1:Ngrid))
    append!(colID, getindex(O2ID, 1:Ngrid))
    append!(rowID, getindex(POCID, 1:Ngrid))
    append!(colID, getindex(AgeID, 1:Ngrid))
    append!(rowID, getindex(POCID, 1:Ngrid))
    append!(colID, getindex(POCID, 1:Ngrid))
    append!(rowID, getindex(POCID, 1:Ngrid))
    append!(colID, getindex(NO2ID, 1:Ngrid))
    append!(rowID, getindex(POCID, 1:Ngrid))
    append!(colID, getindex(NO3ID, 1:Ngrid))
    append!(rowID, getindex(POCID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(POCID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(POCID, 1:Ngrid))
    append!(colID, getindex(THSO4ID, 1:Ngrid))
    append!(rowID, getindex(MnO2ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(MnO2ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(MnO2ID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(MnO2ID, 1:Ngrid))
    append!(colID, getindex(NO3ID, 1:Ngrid))
    append!(rowID, getindex(MnO2ID, 1:Ngrid))
    append!(colID, getindex(NO2ID, 1:Ngrid))
    append!(rowID, getindex(MnO2ID, 1:Ngrid))
    append!(colID, getindex(O2ID, 1:Ngrid))
    append!(rowID, getindex(MnO2ID, 1:Ngrid))
    append!(colID, getindex(AgeID, 1:Ngrid))
    append!(rowID, getindex(MnO2ID, 1:Ngrid))
    append!(colID, getindex(POCID, 1:Ngrid))
    append!(rowID, getindex(MnO2ID, 1:Ngrid))
    append!(colID, getindex(TMnID, 1:Ngrid))
    append!(rowID, getindex(MnO2ID, 1:Ngrid))
    append!(colID, getindex(TFeID, 1:Ngrid))
    append!(rowID, getindex(MnO2ID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(FeOOHID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(FeOOHID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(FeOOHID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(FeOOHID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(FeOOHID, 1:Ngrid))
    append!(colID, getindex(NO3ID, 1:Ngrid))
    append!(rowID, getindex(FeOOHID, 1:Ngrid))
    append!(colID, getindex(NO2ID, 1:Ngrid))
    append!(rowID, getindex(FeOOHID, 1:Ngrid))
    append!(colID, getindex(O2ID, 1:Ngrid))
    append!(rowID, getindex(FeOOHID, 1:Ngrid))
    append!(colID, getindex(AgeID, 1:Ngrid))
    append!(rowID, getindex(FeOOHID, 1:Ngrid))
    append!(colID, getindex(POCID, 1:Ngrid))
    append!(rowID, getindex(FeOOHID, 1:Ngrid))
    append!(colID, getindex(TFeID, 1:Ngrid))
    append!(rowID, getindex(FeOOHID, 1:Ngrid))
    append!(colID, getindex(FeSID, 1:Ngrid))
    append!(rowID, getindex(FeOOHID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(FeSID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(FeSID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(FeSID, 1:Ngrid))
    append!(colID, getindex(O2ID, 1:Ngrid))
    append!(rowID, getindex(FeSID, 1:Ngrid))
    append!(colID, getindex(FeSID, 1:Ngrid))
    append!(rowID, getindex(FeSID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(FeSID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(FeSID, 1:Ngrid))
    append!(colID, getindex(TFeID, 1:Ngrid))
    append!(rowID, getindex(FeS2ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(FeS2ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(FeS2ID, 1:Ngrid))
    append!(colID, getindex(FeSID, 1:Ngrid))
    append!(rowID, getindex(FeS2ID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(CaCO3ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(CaCO3ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(CaCO3ID, 1:Ngrid))
    append!(colID, getindex(TCO2ID, 1:Ngrid))
    append!(rowID, getindex(CaCO3ID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(CaCO3ID, 1:Ngrid))
    append!(colID, getindex(CaID, 1:Ngrid))
    append!(rowID, getindex(MnCO3ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(MnCO3ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(MnCO3ID, 1:Ngrid))
    append!(colID, getindex(TCO2ID, 1:Ngrid))
    append!(rowID, getindex(MnCO3ID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(MnCO3ID, 1:Ngrid))
    append!(colID, getindex(TMnID, 1:Ngrid))
    append!(rowID, getindex(FeCO3ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(FeCO3ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(FeCO3ID, 1:Ngrid))
    append!(colID, getindex(TCO2ID, 1:Ngrid))
    append!(rowID, getindex(FeCO3ID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(FeCO3ID, 1:Ngrid))
    append!(colID, getindex(TFeID, 1:Ngrid))
    append!(rowID, getindex(BSiID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(BSiID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(BSiID, 1:Ngrid))
    append!(colID, getindex(H4SiO4ID, 1:Ngrid))
    append!(rowID, getindex(SMolID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(SMolID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(SMolID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(SMolID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(SMolID, 1:Ngrid))
    append!(colID, getindex(MolID, 1:Ngrid))
    append!(rowID, getindex(SMohID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(SMohID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(SMohID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(SMohID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(SMohID, 1:Ngrid))
    append!(colID, getindex(MohID, 1:Ngrid))
    append!(rowID, getindex(O2ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(O2ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(O2ID, 1:Ngrid))
    append!(colID, getindex(O2ID, 1:Ngrid))
    append!(rowID, getindex(O2ID, 1:Ngrid))
    append!(colID, getindex(AgeID, 1:Ngrid))
    append!(rowID, getindex(O2ID, 1:Ngrid))
    append!(colID, getindex(POCID, 1:Ngrid))
    append!(rowID, getindex(O2ID, 1:Ngrid))
    append!(colID, getindex(NO2ID, 1:Ngrid))
    append!(rowID, getindex(O2ID, 1:Ngrid))
    append!(colID, getindex(TNH4ID, 1:Ngrid))
    append!(rowID, getindex(O2ID, 1:Ngrid))
    append!(colID, getindex(TMnID, 1:Ngrid))
    append!(rowID, getindex(O2ID, 1:Ngrid))
    append!(colID, getindex(TFeID, 1:Ngrid))
    append!(rowID, getindex(O2ID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(O2ID, 1:Ngrid))
    append!(colID, getindex(FeSID, 1:Ngrid))
    append!(rowID, getindex(O2ID, 1:Ngrid))
    append!(colID, getindex(CH4ID, 1:Ngrid))
    append!(rowID, getindex(NO3ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(NO3ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(NO3ID, 1:Ngrid))
    append!(colID, getindex(NO3ID, 1:Ngrid))
    append!(rowID, getindex(NO3ID, 1:Ngrid))
    append!(colID, getindex(NO2ID, 1:Ngrid))
    append!(rowID, getindex(NO3ID, 1:Ngrid))
    append!(colID, getindex(O2ID, 1:Ngrid))
    append!(rowID, getindex(NO3ID, 1:Ngrid))
    append!(colID, getindex(AgeID, 1:Ngrid))
    append!(rowID, getindex(NO3ID, 1:Ngrid))
    append!(colID, getindex(POCID, 1:Ngrid))
    append!(rowID, getindex(NO3ID, 1:Ngrid))
    append!(colID, getindex(TMnID, 1:Ngrid))
    append!(rowID, getindex(NO3ID, 1:Ngrid))
    append!(colID, getindex(TFeID, 1:Ngrid))
    append!(rowID, getindex(NO3ID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(CH4ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(CH4ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(CH4ID, 1:Ngrid))
    append!(colID, getindex(THSO4ID, 1:Ngrid))
    append!(rowID, getindex(CH4ID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(CH4ID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(CH4ID, 1:Ngrid))
    append!(colID, getindex(NO3ID, 1:Ngrid))
    append!(rowID, getindex(CH4ID, 1:Ngrid))
    append!(colID, getindex(NO2ID, 1:Ngrid))
    append!(rowID, getindex(CH4ID, 1:Ngrid))
    append!(colID, getindex(O2ID, 1:Ngrid))
    append!(rowID, getindex(CH4ID, 1:Ngrid))
    append!(colID, getindex(AgeID, 1:Ngrid))
    append!(rowID, getindex(CH4ID, 1:Ngrid))
    append!(colID, getindex(POCID, 1:Ngrid))
    append!(rowID, getindex(CH4ID, 1:Ngrid))
    append!(colID, getindex(CH4ID, 1:Ngrid))
    append!(rowID, getindex(NO2ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(NO2ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(NO2ID, 1:Ngrid))
    append!(colID, getindex(NO2ID, 1:Ngrid))
    append!(rowID, getindex(NO2ID, 1:Ngrid))
    append!(colID, getindex(O2ID, 1:Ngrid))
    append!(rowID, getindex(NO2ID, 1:Ngrid))
    append!(colID, getindex(AgeID, 1:Ngrid))
    append!(rowID, getindex(NO2ID, 1:Ngrid))
    append!(colID, getindex(POCID, 1:Ngrid))
    append!(rowID, getindex(NO2ID, 1:Ngrid))
    append!(colID, getindex(NO3ID, 1:Ngrid))
    append!(rowID, getindex(NO2ID, 1:Ngrid))
    append!(colID, getindex(TNH4ID, 1:Ngrid))
    append!(rowID, getindex(CaID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(CaID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(CaID, 1:Ngrid))
    append!(colID, getindex(TCO2ID, 1:Ngrid))
    append!(rowID, getindex(CaID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(CaID, 1:Ngrid))
    append!(colID, getindex(CaID, 1:Ngrid))
    append!(rowID, getindex(CaID, 1:Ngrid))
    append!(colID, getindex(TH3PO4ID, 1:Ngrid))
    append!(rowID, getindex(CaID, 1:Ngrid))
    append!(colID, getindex(THFID, 1:Ngrid))
    append!(rowID, getindex(H4SiO4ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(H4SiO4ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(H4SiO4ID, 1:Ngrid))
    append!(colID, getindex(H4SiO4ID, 1:Ngrid))
    append!(rowID, getindex(TMnID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(TMnID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TMnID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(TMnID, 1:Ngrid))
    append!(colID, getindex(NO3ID, 1:Ngrid))
    append!(rowID, getindex(TMnID, 1:Ngrid))
    append!(colID, getindex(NO2ID, 1:Ngrid))
    append!(rowID, getindex(TMnID, 1:Ngrid))
    append!(colID, getindex(O2ID, 1:Ngrid))
    append!(rowID, getindex(TMnID, 1:Ngrid))
    append!(colID, getindex(AgeID, 1:Ngrid))
    append!(rowID, getindex(TMnID, 1:Ngrid))
    append!(colID, getindex(POCID, 1:Ngrid))
    append!(rowID, getindex(TMnID, 1:Ngrid))
    append!(colID, getindex(TMnID, 1:Ngrid))
    append!(rowID, getindex(TMnID, 1:Ngrid))
    append!(colID, getindex(TFeID, 1:Ngrid))
    append!(rowID, getindex(TMnID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(TMnID, 1:Ngrid))
    append!(colID, getindex(TCO2ID, 1:Ngrid))
    append!(rowID, getindex(TMnID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(TFeID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(TFeID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TFeID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(TFeID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(TFeID, 1:Ngrid))
    append!(colID, getindex(NO3ID, 1:Ngrid))
    append!(rowID, getindex(TFeID, 1:Ngrid))
    append!(colID, getindex(NO2ID, 1:Ngrid))
    append!(rowID, getindex(TFeID, 1:Ngrid))
    append!(colID, getindex(O2ID, 1:Ngrid))
    append!(rowID, getindex(TFeID, 1:Ngrid))
    append!(colID, getindex(AgeID, 1:Ngrid))
    append!(rowID, getindex(TFeID, 1:Ngrid))
    append!(colID, getindex(POCID, 1:Ngrid))
    append!(rowID, getindex(TFeID, 1:Ngrid))
    append!(colID, getindex(TFeID, 1:Ngrid))
    append!(rowID, getindex(TFeID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(TFeID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(TFeID, 1:Ngrid))
    append!(colID, getindex(TCO2ID, 1:Ngrid))
    append!(rowID, getindex(TNH4ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(TNH4ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TNH4ID, 1:Ngrid))
    append!(colID, getindex(O2ID, 1:Ngrid))
    append!(rowID, getindex(TNH4ID, 1:Ngrid))
    append!(colID, getindex(AgeID, 1:Ngrid))
    append!(rowID, getindex(TNH4ID, 1:Ngrid))
    append!(colID, getindex(POCID, 1:Ngrid))
    append!(rowID, getindex(TNH4ID, 1:Ngrid))
    append!(colID, getindex(NO2ID, 1:Ngrid))
    append!(rowID, getindex(TNH4ID, 1:Ngrid))
    append!(colID, getindex(NO3ID, 1:Ngrid))
    append!(rowID, getindex(TNH4ID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(TNH4ID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(TNH4ID, 1:Ngrid))
    append!(colID, getindex(THSO4ID, 1:Ngrid))
    append!(rowID, getindex(TNH4ID, 1:Ngrid))
    append!(colID, getindex(TNH4ID, 1:Ngrid))
    append!(rowID, getindex(TNH4ID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(MolID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(MolID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(MolID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(MolID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(MolID, 1:Ngrid))
    append!(colID, getindex(MolID, 1:Ngrid))
    append!(rowID, getindex(MohID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(MohID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(MohID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(MohID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(MohID, 1:Ngrid))
    append!(colID, getindex(MohID, 1:Ngrid))
    append!(rowID, getindex(TH3PO4ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(TH3PO4ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TH3PO4ID, 1:Ngrid))
    append!(colID, getindex(O2ID, 1:Ngrid))
    append!(rowID, getindex(TH3PO4ID, 1:Ngrid))
    append!(colID, getindex(AgeID, 1:Ngrid))
    append!(rowID, getindex(TH3PO4ID, 1:Ngrid))
    append!(colID, getindex(POCID, 1:Ngrid))
    append!(rowID, getindex(TH3PO4ID, 1:Ngrid))
    append!(colID, getindex(NO2ID, 1:Ngrid))
    append!(rowID, getindex(TH3PO4ID, 1:Ngrid))
    append!(colID, getindex(NO3ID, 1:Ngrid))
    append!(rowID, getindex(TH3PO4ID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(TH3PO4ID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(TH3PO4ID, 1:Ngrid))
    append!(colID, getindex(THSO4ID, 1:Ngrid))
    append!(rowID, getindex(TH3PO4ID, 1:Ngrid))
    append!(colID, getindex(TH3PO4ID, 1:Ngrid))
    append!(rowID, getindex(TH3PO4ID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(TH3PO4ID, 1:Ngrid))
    append!(colID, getindex(THFID, 1:Ngrid))
    append!(rowID, getindex(TH3PO4ID, 1:Ngrid))
    append!(colID, getindex(TCO2ID, 1:Ngrid))
    append!(rowID, getindex(TH3PO4ID, 1:Ngrid))
    append!(colID, getindex(CaID, 1:Ngrid))
    append!(rowID, getindex(TH3PO4ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(HID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(THSO4ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(THSO4ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(THSO4ID, 1:Ngrid))
    append!(colID, getindex(THSO4ID, 1:Ngrid))
    append!(rowID, getindex(THSO4ID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(THSO4ID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(THSO4ID, 1:Ngrid))
    append!(colID, getindex(NO3ID, 1:Ngrid))
    append!(rowID, getindex(THSO4ID, 1:Ngrid))
    append!(colID, getindex(NO2ID, 1:Ngrid))
    append!(rowID, getindex(THSO4ID, 1:Ngrid))
    append!(colID, getindex(O2ID, 1:Ngrid))
    append!(rowID, getindex(THSO4ID, 1:Ngrid))
    append!(colID, getindex(AgeID, 1:Ngrid))
    append!(rowID, getindex(THSO4ID, 1:Ngrid))
    append!(colID, getindex(POCID, 1:Ngrid))
    append!(rowID, getindex(THSO4ID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(THSO4ID, 1:Ngrid))
    append!(colID, getindex(FeSID, 1:Ngrid))
    append!(rowID, getindex(THSO4ID, 1:Ngrid))
    append!(colID, getindex(CH4ID, 1:Ngrid))
    append!(rowID, getindex(THSO4ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(HID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(HID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(HID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(O2ID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(AgeID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(POCID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(NO2ID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(NO3ID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(THSO4ID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(TNH4ID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(TMnID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(TFeID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(FeSID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(CH4ID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(TH3PO4ID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(THFID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(TCO2ID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(CaID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(TCO2ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TCO2ID, 1:Ngrid))
    append!(colID, getindex(O2ID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, 1:Ngrid))
    append!(colID, getindex(AgeID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, 1:Ngrid))
    append!(colID, getindex(POCID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, 1:Ngrid))
    append!(colID, getindex(NO2ID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, 1:Ngrid))
    append!(colID, getindex(NO3ID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, 1:Ngrid))
    append!(colID, getindex(THSO4ID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, 1:Ngrid))
    append!(colID, getindex(CH4ID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, 1:Ngrid))
    append!(colID, getindex(TCO2ID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, 1:Ngrid))
    append!(colID, getindex(CaID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, 1:Ngrid))
    append!(colID, getindex(TMnID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, 1:Ngrid))
    append!(colID, getindex(TFeID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, 1:Ngrid))
    append!(colID, getindex(TH3PO4ID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, 1:Ngrid))
    append!(colID, getindex(THFID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(HID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TH2SID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(TH2SID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TH2SID, 1:Ngrid))
    append!(colID, getindex(THSO4ID, 1:Ngrid))
    append!(rowID, getindex(TH2SID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(TH2SID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(TH2SID, 1:Ngrid))
    append!(colID, getindex(NO3ID, 1:Ngrid))
    append!(rowID, getindex(TH2SID, 1:Ngrid))
    append!(colID, getindex(NO2ID, 1:Ngrid))
    append!(rowID, getindex(TH2SID, 1:Ngrid))
    append!(colID, getindex(O2ID, 1:Ngrid))
    append!(rowID, getindex(TH2SID, 1:Ngrid))
    append!(colID, getindex(AgeID, 1:Ngrid))
    append!(rowID, getindex(TH2SID, 1:Ngrid))
    append!(colID, getindex(POCID, 1:Ngrid))
    append!(rowID, getindex(TH2SID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(TH2SID, 1:Ngrid))
    append!(colID, getindex(CH4ID, 1:Ngrid))
    append!(rowID, getindex(TH2SID, 1:Ngrid))
    append!(colID, getindex(FeSID, 1:Ngrid))
    append!(rowID, getindex(TH2SID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(TH2SID, 1:Ngrid))
    append!(colID, getindex(TFeID, 1:Ngrid))
    append!(rowID, getindex(TH2SID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(HID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(THFID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(THFID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(THFID, 1:Ngrid))
    append!(colID, getindex(TH3PO4ID, 1:Ngrid))
    append!(rowID, getindex(THFID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(THFID, 1:Ngrid))
    append!(colID, getindex(THFID, 1:Ngrid))
    append!(rowID, getindex(THFID, 1:Ngrid))
    append!(colID, getindex(TCO2ID, 1:Ngrid))
    append!(rowID, getindex(THFID, 1:Ngrid))
    append!(colID, getindex(CaID, 1:Ngrid))
    append!(rowID, getindex(THFID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(HID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(AgeID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(AgeID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(LMolID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(LMolID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(LMohID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(LMohID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TH3BO3ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(TH3BO3ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TH3BO3ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(HID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(HID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(TH3PO4ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(HID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(THSO4ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(HID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(TCO2ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(HID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(TH2SID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(HID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(THFID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
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
