function JacType()
    rowID = Vector{Int}()
    colID = Vector{Int}()
    append!(rowID, getindex(TMnID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(TMnID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TMnID, 1:Ngrid))
    append!(colID, getindex(TCO2ID, 1:Ngrid))
    append!(rowID, getindex(TMnID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(TMnID, 1:Ngrid))
    append!(colID, getindex(TMnID, 1:Ngrid))
    append!(rowID, getindex(TMnID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(TMnID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(TMnID, 1:Ngrid))
    append!(colID, getindex(TFeID, 1:Ngrid))
    append!(rowID, getindex(TMnID, 1:Ngrid))
    append!(colID, getindex(SO4ID, 1:Ngrid))
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
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(TMnID, 1:Ngrid))
    append!(colID, getindex(MnCO3ID, 1:Ngrid))
    append!(rowID, getindex(TMnID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(MnO2ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TMnID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(FeOOHID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TFeID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(TFeID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TFeID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(TFeID, 1:Ngrid))
    append!(colID, getindex(TCO2ID, 1:Ngrid))
    append!(rowID, getindex(TFeID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(TFeID, 1:Ngrid))
    append!(colID, getindex(TFeID, 1:Ngrid))
    append!(rowID, getindex(TFeID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(TFeID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(TFeID, 1:Ngrid))
    append!(colID, getindex(SO4ID, 1:Ngrid))
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
    append!(colID, getindex(FeSID, 1:Ngrid))
    append!(rowID, getindex(TFeID, 1:Ngrid))
    append!(colID, getindex(FeCO3ID, 1:Ngrid))
    append!(rowID, getindex(TFeID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(MnO2ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TFeID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(FeOOHID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TNdnrID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(TNdnrID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TNdnrID, 1:Ngrid))
    append!(colID, getindex(TCO2ID, 1:Ngrid))
    append!(rowID, getindex(TNdnrID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(TNdnrID, 1:Ngrid))
    append!(colID, getindex(TH4SiO4ID, 1:Ngrid))
    append!(rowID, getindex(TNdnrID, 1:Ngrid))
    append!(colID, getindex(TH3PO4ID, 1:Ngrid))
    append!(rowID, getindex(TNdnrID, 1:Ngrid))
    append!(colID, getindex(TNdnrID, 1:Ngrid))
    append!(rowID, getindex(TNdnrID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(TNdnrID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(TNdnrID, 1:Ngrid))
    append!(colID, getindex(TMnID, 1:Ngrid))
    append!(rowID, getindex(TNdnrID, 1:Ngrid))
    append!(colID, getindex(TFeID, 1:Ngrid))
    append!(rowID, getindex(TNdnrID, 1:Ngrid))
    append!(colID, getindex(AlID, 1:Ngrid))
    append!(rowID, getindex(TNdnrID, 1:Ngrid))
    append!(colID, getindex(SO4ID, 1:Ngrid))
    append!(rowID, getindex(TNdnrID, 1:Ngrid))
    append!(colID, getindex(NdnrPO4ID, 1:Ngrid))
    append!(rowID, getindex(TNdnrID, 1:Ngrid))
    append!(colID, getindex(NdrPO4ID, 1:Ngrid))
    append!(rowID, getindex(TNdnrID, 1:Ngrid))
    append!(colID, getindex(NO3ID, 1:Ngrid))
    append!(rowID, getindex(TNdnrID, 1:Ngrid))
    append!(colID, getindex(NO2ID, 1:Ngrid))
    append!(rowID, getindex(TNdnrID, 1:Ngrid))
    append!(colID, getindex(O2ID, 1:Ngrid))
    append!(rowID, getindex(TNdnrID, 1:Ngrid))
    append!(colID, getindex(AgeID, 1:Ngrid))
    append!(rowID, getindex(TNdnrID, 1:Ngrid))
    append!(colID, getindex(POCID, 1:Ngrid))
    append!(rowID, getindex(TNdnrID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(TNdnrID, 1:Ngrid))
    append!(colID, getindex(BasaltID, 1:Ngrid))
    append!(rowID, getindex(TNdnrID, 1:Ngrid))
    append!(colID, getindex(SurfMn_NdnrID, 1:Ngrid))
    append!(rowID, getindex(TNdnrID, 1:Ngrid))
    append!(colID, getindex(SurfFe_NdnrID, 1:Ngrid))
    append!(rowID, getindex(TNdnrID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(MnO2ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TNdnrID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(FeOOHID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TNdrID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(TNdrID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TNdrID, 1:Ngrid))
    append!(colID, getindex(TCO2ID, 1:Ngrid))
    append!(rowID, getindex(TNdrID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(TNdrID, 1:Ngrid))
    append!(colID, getindex(TH4SiO4ID, 1:Ngrid))
    append!(rowID, getindex(TNdrID, 1:Ngrid))
    append!(colID, getindex(TH3PO4ID, 1:Ngrid))
    append!(rowID, getindex(TNdrID, 1:Ngrid))
    append!(colID, getindex(TNdrID, 1:Ngrid))
    append!(rowID, getindex(TNdrID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(TNdrID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(TNdrID, 1:Ngrid))
    append!(colID, getindex(TMnID, 1:Ngrid))
    append!(rowID, getindex(TNdrID, 1:Ngrid))
    append!(colID, getindex(TFeID, 1:Ngrid))
    append!(rowID, getindex(TNdrID, 1:Ngrid))
    append!(colID, getindex(AlID, 1:Ngrid))
    append!(rowID, getindex(TNdrID, 1:Ngrid))
    append!(colID, getindex(SO4ID, 1:Ngrid))
    append!(rowID, getindex(TNdrID, 1:Ngrid))
    append!(colID, getindex(NdrPO4ID, 1:Ngrid))
    append!(rowID, getindex(TNdrID, 1:Ngrid))
    append!(colID, getindex(NdnrPO4ID, 1:Ngrid))
    append!(rowID, getindex(TNdrID, 1:Ngrid))
    append!(colID, getindex(NO3ID, 1:Ngrid))
    append!(rowID, getindex(TNdrID, 1:Ngrid))
    append!(colID, getindex(NO2ID, 1:Ngrid))
    append!(rowID, getindex(TNdrID, 1:Ngrid))
    append!(colID, getindex(O2ID, 1:Ngrid))
    append!(rowID, getindex(TNdrID, 1:Ngrid))
    append!(colID, getindex(AgeID, 1:Ngrid))
    append!(rowID, getindex(TNdrID, 1:Ngrid))
    append!(colID, getindex(POCID, 1:Ngrid))
    append!(rowID, getindex(TNdrID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(TNdrID, 1:Ngrid))
    append!(colID, getindex(BasaltID, 1:Ngrid))
    append!(rowID, getindex(TNdrID, 1:Ngrid))
    append!(colID, getindex(SurfMn_NdrID, 1:Ngrid))
    append!(rowID, getindex(TNdrID, 1:Ngrid))
    append!(colID, getindex(SurfFe_NdrID, 1:Ngrid))
    append!(rowID, getindex(TNdrID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(MnO2ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TNdrID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(FeOOHID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(MnO2ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(MnO2ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(MnO2ID, 1:Ngrid))
    append!(colID, getindex(TMnID, 1:Ngrid))
    append!(rowID, getindex(MnO2ID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(MnO2ID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(MnO2ID, 1:Ngrid))
    append!(colID, getindex(TFeID, 1:Ngrid))
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
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(FeOOHID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(FeOOHID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(FeOOHID, 1:Ngrid))
    append!(colID, getindex(TFeID, 1:Ngrid))
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
    append!(colID, getindex(FeSID, 1:Ngrid))
    append!(rowID, getindex(FeOOHID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
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
    append!(colID, getindex(SO4ID, 1:Ngrid))
    append!(rowID, getindex(FeSID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(FeSID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(FeSID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(FeSID, 1:Ngrid))
    append!(colID, getindex(TCO2ID, 1:Ngrid))
    append!(rowID, getindex(FeSID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(FeSID, 1:Ngrid))
    append!(colID, getindex(TFeID, 1:Ngrid))
    append!(rowID, getindex(FeSID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(FeSID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(FeSID, 1:Ngrid))
    append!(colID, getindex(SO4ID, 1:Ngrid))
    append!(rowID, getindex(FeSID, 1:Ngrid))
    append!(colID, getindex(O2ID, 1:Ngrid))
    append!(rowID, getindex(FeSID, 1:Ngrid))
    append!(colID, getindex(FeSID, 1:Ngrid))
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
    append!(rowID, getindex(CaCO3ID, 1:Ngrid))
    append!(colID, getindex(CaCO3ID, 1:Ngrid))
    append!(rowID, getindex(MnCO3ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(MnCO3ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(MnCO3ID, 1:Ngrid))
    append!(colID, getindex(TCO2ID, 1:Ngrid))
    append!(rowID, getindex(MnCO3ID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(MnCO3ID, 1:Ngrid))
    append!(colID, getindex(TMnID, 1:Ngrid))
    append!(rowID, getindex(MnCO3ID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(MnCO3ID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(MnCO3ID, 1:Ngrid))
    append!(colID, getindex(SO4ID, 1:Ngrid))
    append!(rowID, getindex(MnCO3ID, 1:Ngrid))
    append!(colID, getindex(MnCO3ID, 1:Ngrid))
    append!(rowID, getindex(FeCO3ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(FeCO3ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(FeCO3ID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(FeCO3ID, 1:Ngrid))
    append!(colID, getindex(TCO2ID, 1:Ngrid))
    append!(rowID, getindex(FeCO3ID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(FeCO3ID, 1:Ngrid))
    append!(colID, getindex(TFeID, 1:Ngrid))
    append!(rowID, getindex(FeCO3ID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(FeCO3ID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(FeCO3ID, 1:Ngrid))
    append!(colID, getindex(SO4ID, 1:Ngrid))
    append!(rowID, getindex(FeCO3ID, 1:Ngrid))
    append!(colID, getindex(FeCO3ID, 1:Ngrid))
    append!(rowID, getindex(BSiID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(BSiID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(BSiID, 1:Ngrid))
    append!(colID, getindex(TH4SiO4ID, 1:Ngrid))
    append!(rowID, getindex(BSiID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(BSiID, 1:Ngrid))
    append!(colID, getindex(BSiID, 1:Ngrid))
    append!(rowID, getindex(BasaltID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(BasaltID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(BasaltID, 1:Ngrid))
    append!(colID, getindex(TCO2ID, 1:Ngrid))
    append!(rowID, getindex(BasaltID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(BasaltID, 1:Ngrid))
    append!(colID, getindex(TH4SiO4ID, 1:Ngrid))
    append!(rowID, getindex(BasaltID, 1:Ngrid))
    append!(colID, getindex(AlID, 1:Ngrid))
    append!(rowID, getindex(BasaltID, 1:Ngrid))
    append!(colID, getindex(BasaltID, 1:Ngrid))
    append!(rowID, getindex(BasaltID, 1:Ngrid))
    append!(colID, getindex(AgeID, 1:Ngrid))
    append!(rowID, getindex(NdnrPO4ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(NdnrPO4ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(NdnrPO4ID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(NdnrPO4ID, 1:Ngrid))
    append!(colID, getindex(TCO2ID, 1:Ngrid))
    append!(rowID, getindex(NdnrPO4ID, 1:Ngrid))
    append!(colID, getindex(TH4SiO4ID, 1:Ngrid))
    append!(rowID, getindex(NdnrPO4ID, 1:Ngrid))
    append!(colID, getindex(TH3PO4ID, 1:Ngrid))
    append!(rowID, getindex(NdnrPO4ID, 1:Ngrid))
    append!(colID, getindex(TNdnrID, 1:Ngrid))
    append!(rowID, getindex(NdnrPO4ID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(NdnrPO4ID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(NdnrPO4ID, 1:Ngrid))
    append!(colID, getindex(SO4ID, 1:Ngrid))
    append!(rowID, getindex(NdnrPO4ID, 1:Ngrid))
    append!(colID, getindex(NdnrPO4ID, 1:Ngrid))
    append!(rowID, getindex(NdnrPO4ID, 1:Ngrid))
    append!(colID, getindex(NdrPO4ID, 1:Ngrid))
    append!(rowID, getindex(NdrPO4ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(NdrPO4ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(NdrPO4ID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(NdrPO4ID, 1:Ngrid))
    append!(colID, getindex(TCO2ID, 1:Ngrid))
    append!(rowID, getindex(NdrPO4ID, 1:Ngrid))
    append!(colID, getindex(TH4SiO4ID, 1:Ngrid))
    append!(rowID, getindex(NdrPO4ID, 1:Ngrid))
    append!(colID, getindex(TH3PO4ID, 1:Ngrid))
    append!(rowID, getindex(NdrPO4ID, 1:Ngrid))
    append!(colID, getindex(TNdrID, 1:Ngrid))
    append!(rowID, getindex(NdrPO4ID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(NdrPO4ID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(NdrPO4ID, 1:Ngrid))
    append!(colID, getindex(SO4ID, 1:Ngrid))
    append!(rowID, getindex(NdrPO4ID, 1:Ngrid))
    append!(colID, getindex(NdrPO4ID, 1:Ngrid))
    append!(rowID, getindex(NdrPO4ID, 1:Ngrid))
    append!(colID, getindex(NdnrPO4ID, 1:Ngrid))
    append!(rowID, getindex(SurfMn_NdnrID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(SurfMn_NdnrID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(SurfMn_NdnrID, 1:Ngrid))
    append!(colID, getindex(TMnID, 1:Ngrid))
    append!(rowID, getindex(SurfMn_NdnrID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(SurfMn_NdnrID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(SurfMn_NdnrID, 1:Ngrid))
    append!(colID, getindex(TFeID, 1:Ngrid))
    append!(rowID, getindex(SurfMn_NdnrID, 1:Ngrid))
    append!(colID, getindex(TNdnrID, 1:Ngrid))
    append!(rowID, getindex(SurfMn_NdnrID, 1:Ngrid))
    append!(colID, getindex(NO3ID, 1:Ngrid))
    append!(rowID, getindex(SurfMn_NdnrID, 1:Ngrid))
    append!(colID, getindex(NO2ID, 1:Ngrid))
    append!(rowID, getindex(SurfMn_NdnrID, 1:Ngrid))
    append!(colID, getindex(O2ID, 1:Ngrid))
    append!(rowID, getindex(SurfMn_NdnrID, 1:Ngrid))
    append!(colID, getindex(AgeID, 1:Ngrid))
    append!(rowID, getindex(SurfMn_NdnrID, 1:Ngrid))
    append!(colID, getindex(POCID, 1:Ngrid))
    append!(rowID, getindex(SurfMn_NdnrID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(SurfMn_NdnrID, 1:Ngrid))
    append!(colID, getindex(SurfMn_NdnrID, 1:Ngrid))
    append!(rowID, getindex(SurfMn_NdrID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(SurfMn_NdrID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(SurfMn_NdrID, 1:Ngrid))
    append!(colID, getindex(TMnID, 1:Ngrid))
    append!(rowID, getindex(SurfMn_NdrID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(SurfMn_NdrID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(SurfMn_NdrID, 1:Ngrid))
    append!(colID, getindex(TFeID, 1:Ngrid))
    append!(rowID, getindex(SurfMn_NdrID, 1:Ngrid))
    append!(colID, getindex(TNdrID, 1:Ngrid))
    append!(rowID, getindex(SurfMn_NdrID, 1:Ngrid))
    append!(colID, getindex(NO3ID, 1:Ngrid))
    append!(rowID, getindex(SurfMn_NdrID, 1:Ngrid))
    append!(colID, getindex(NO2ID, 1:Ngrid))
    append!(rowID, getindex(SurfMn_NdrID, 1:Ngrid))
    append!(colID, getindex(O2ID, 1:Ngrid))
    append!(rowID, getindex(SurfMn_NdrID, 1:Ngrid))
    append!(colID, getindex(AgeID, 1:Ngrid))
    append!(rowID, getindex(SurfMn_NdrID, 1:Ngrid))
    append!(colID, getindex(POCID, 1:Ngrid))
    append!(rowID, getindex(SurfMn_NdrID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(SurfMn_NdrID, 1:Ngrid))
    append!(colID, getindex(SurfMn_NdrID, 1:Ngrid))
    append!(rowID, getindex(SurfFe_NdnrID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(SurfFe_NdnrID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(SurfFe_NdnrID, 1:Ngrid))
    append!(colID, getindex(TFeID, 1:Ngrid))
    append!(rowID, getindex(SurfFe_NdnrID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(SurfFe_NdnrID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(SurfFe_NdnrID, 1:Ngrid))
    append!(colID, getindex(TNdnrID, 1:Ngrid))
    append!(rowID, getindex(SurfFe_NdnrID, 1:Ngrid))
    append!(colID, getindex(NO3ID, 1:Ngrid))
    append!(rowID, getindex(SurfFe_NdnrID, 1:Ngrid))
    append!(colID, getindex(NO2ID, 1:Ngrid))
    append!(rowID, getindex(SurfFe_NdnrID, 1:Ngrid))
    append!(colID, getindex(O2ID, 1:Ngrid))
    append!(rowID, getindex(SurfFe_NdnrID, 1:Ngrid))
    append!(colID, getindex(AgeID, 1:Ngrid))
    append!(rowID, getindex(SurfFe_NdnrID, 1:Ngrid))
    append!(colID, getindex(POCID, 1:Ngrid))
    append!(rowID, getindex(SurfFe_NdnrID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(SurfFe_NdnrID, 1:Ngrid))
    append!(colID, getindex(SurfFe_NdnrID, 1:Ngrid))
    append!(rowID, getindex(SurfFe_NdrID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(SurfFe_NdrID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(SurfFe_NdrID, 1:Ngrid))
    append!(colID, getindex(TFeID, 1:Ngrid))
    append!(rowID, getindex(SurfFe_NdrID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(SurfFe_NdrID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(SurfFe_NdrID, 1:Ngrid))
    append!(colID, getindex(TNdrID, 1:Ngrid))
    append!(rowID, getindex(SurfFe_NdrID, 1:Ngrid))
    append!(colID, getindex(NO3ID, 1:Ngrid))
    append!(rowID, getindex(SurfFe_NdrID, 1:Ngrid))
    append!(colID, getindex(NO2ID, 1:Ngrid))
    append!(rowID, getindex(SurfFe_NdrID, 1:Ngrid))
    append!(colID, getindex(O2ID, 1:Ngrid))
    append!(rowID, getindex(SurfFe_NdrID, 1:Ngrid))
    append!(colID, getindex(AgeID, 1:Ngrid))
    append!(rowID, getindex(SurfFe_NdrID, 1:Ngrid))
    append!(colID, getindex(POCID, 1:Ngrid))
    append!(rowID, getindex(SurfFe_NdrID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(SurfFe_NdrID, 1:Ngrid))
    append!(colID, getindex(SurfFe_NdrID, 1:Ngrid))
    append!(rowID, getindex(O2ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(O2ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(O2ID, 1:Ngrid))
    append!(colID, getindex(TMnID, 1:Ngrid))
    append!(rowID, getindex(O2ID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(O2ID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(O2ID, 1:Ngrid))
    append!(colID, getindex(TFeID, 1:Ngrid))
    append!(rowID, getindex(O2ID, 1:Ngrid))
    append!(colID, getindex(O2ID, 1:Ngrid))
    append!(rowID, getindex(O2ID, 1:Ngrid))
    append!(colID, getindex(AgeID, 1:Ngrid))
    append!(rowID, getindex(O2ID, 1:Ngrid))
    append!(colID, getindex(POCID, 1:Ngrid))
    append!(rowID, getindex(O2ID, 1:Ngrid))
    append!(colID, getindex(NO2ID, 1:Ngrid))
    append!(rowID, getindex(O2ID, 1:Ngrid))
    append!(colID, getindex(NH4ID, 1:Ngrid))
    append!(rowID, getindex(O2ID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(O2ID, 1:Ngrid))
    append!(colID, getindex(FeSID, 1:Ngrid))
    append!(rowID, getindex(O2ID, 1:Ngrid))
    append!(colID, getindex(CH4ID, 1:Ngrid))
    append!(rowID, getindex(NO3ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(NO3ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(NO3ID, 1:Ngrid))
    append!(colID, getindex(TMnID, 1:Ngrid))
    append!(rowID, getindex(NO3ID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(NO3ID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(NO3ID, 1:Ngrid))
    append!(colID, getindex(TFeID, 1:Ngrid))
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
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(CH4ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(CH4ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(CH4ID, 1:Ngrid))
    append!(colID, getindex(SO4ID, 1:Ngrid))
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
    append!(colID, getindex(NH4ID, 1:Ngrid))
    append!(rowID, getindex(CaID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(CaID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(CaID, 1:Ngrid))
    append!(colID, getindex(TCO2ID, 1:Ngrid))
    append!(rowID, getindex(CaID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(CaID, 1:Ngrid))
    append!(colID, getindex(CaID, 1:Ngrid))
    append!(rowID, getindex(CaID, 1:Ngrid))
    append!(colID, getindex(CaCO3ID, 1:Ngrid))
    append!(rowID, getindex(AlID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(AlID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(AlID, 1:Ngrid))
    append!(colID, getindex(TCO2ID, 1:Ngrid))
    append!(rowID, getindex(AlID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(AlID, 1:Ngrid))
    append!(colID, getindex(TH4SiO4ID, 1:Ngrid))
    append!(rowID, getindex(AlID, 1:Ngrid))
    append!(colID, getindex(AlID, 1:Ngrid))
    append!(rowID, getindex(AlID, 1:Ngrid))
    append!(colID, getindex(BasaltID, 1:Ngrid))
    append!(rowID, getindex(AlID, 1:Ngrid))
    append!(colID, getindex(AgeID, 1:Ngrid))
    append!(rowID, getindex(SO4ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(SO4ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(SO4ID, 1:Ngrid))
    append!(colID, getindex(SO4ID, 1:Ngrid))
    append!(rowID, getindex(SO4ID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(SO4ID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(SO4ID, 1:Ngrid))
    append!(colID, getindex(NO3ID, 1:Ngrid))
    append!(rowID, getindex(SO4ID, 1:Ngrid))
    append!(colID, getindex(NO2ID, 1:Ngrid))
    append!(rowID, getindex(SO4ID, 1:Ngrid))
    append!(colID, getindex(O2ID, 1:Ngrid))
    append!(rowID, getindex(SO4ID, 1:Ngrid))
    append!(colID, getindex(AgeID, 1:Ngrid))
    append!(rowID, getindex(SO4ID, 1:Ngrid))
    append!(colID, getindex(POCID, 1:Ngrid))
    append!(rowID, getindex(SO4ID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(SO4ID, 1:Ngrid))
    append!(colID, getindex(FeSID, 1:Ngrid))
    append!(rowID, getindex(SO4ID, 1:Ngrid))
    append!(colID, getindex(CH4ID, 1:Ngrid))
    append!(rowID, getindex(NH4ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(NH4ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(NH4ID, 1:Ngrid))
    append!(colID, getindex(O2ID, 1:Ngrid))
    append!(rowID, getindex(NH4ID, 1:Ngrid))
    append!(colID, getindex(AgeID, 1:Ngrid))
    append!(rowID, getindex(NH4ID, 1:Ngrid))
    append!(colID, getindex(POCID, 1:Ngrid))
    append!(rowID, getindex(NH4ID, 1:Ngrid))
    append!(colID, getindex(NO2ID, 1:Ngrid))
    append!(rowID, getindex(NH4ID, 1:Ngrid))
    append!(colID, getindex(NO3ID, 1:Ngrid))
    append!(rowID, getindex(NH4ID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(NH4ID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(NH4ID, 1:Ngrid))
    append!(colID, getindex(SO4ID, 1:Ngrid))
    append!(rowID, getindex(NH4ID, 1:Ngrid))
    append!(colID, getindex(NH4ID, 1:Ngrid))
    append!(rowID, getindex(NH4ID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(TH4SiO4ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(TH4SiO4ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TH4SiO4ID, 1:Ngrid))
    append!(colID, getindex(TCO2ID, 1:Ngrid))
    append!(rowID, getindex(TH4SiO4ID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(TH4SiO4ID, 1:Ngrid))
    append!(colID, getindex(TH4SiO4ID, 1:Ngrid))
    append!(rowID, getindex(TH4SiO4ID, 1:Ngrid))
    append!(colID, getindex(AlID, 1:Ngrid))
    append!(rowID, getindex(TH4SiO4ID, 1:Ngrid))
    append!(colID, getindex(BSiID, 1:Ngrid))
    append!(rowID, getindex(TH4SiO4ID, 1:Ngrid))
    append!(colID, getindex(BasaltID, 1:Ngrid))
    append!(rowID, getindex(TH4SiO4ID, 1:Ngrid))
    append!(colID, getindex(AgeID, 1:Ngrid))
    append!(rowID, getindex(TH3PO4ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(TH3PO4ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TH3PO4ID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(TH3PO4ID, 1:Ngrid))
    append!(colID, getindex(TCO2ID, 1:Ngrid))
    append!(rowID, getindex(TH3PO4ID, 1:Ngrid))
    append!(colID, getindex(TH4SiO4ID, 1:Ngrid))
    append!(rowID, getindex(TH3PO4ID, 1:Ngrid))
    append!(colID, getindex(TH3PO4ID, 1:Ngrid))
    append!(rowID, getindex(TH3PO4ID, 1:Ngrid))
    append!(colID, getindex(TNdnrID, 1:Ngrid))
    append!(rowID, getindex(TH3PO4ID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(TH3PO4ID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(TH3PO4ID, 1:Ngrid))
    append!(colID, getindex(TNdrID, 1:Ngrid))
    append!(rowID, getindex(TH3PO4ID, 1:Ngrid))
    append!(colID, getindex(SO4ID, 1:Ngrid))
    append!(rowID, getindex(TH3PO4ID, 1:Ngrid))
    append!(colID, getindex(NdnrPO4ID, 1:Ngrid))
    append!(rowID, getindex(TH3PO4ID, 1:Ngrid))
    append!(colID, getindex(NdrPO4ID, 1:Ngrid))
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
    append!(rowID, getindex(TCO2ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(TCO2ID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TCO2ID, 1:Ngrid))
    append!(colID, getindex(TCO2ID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, 1:Ngrid))
    append!(colID, getindex(TMnID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, 1:Ngrid))
    append!(colID, getindex(TFeID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, 1:Ngrid))
    append!(colID, getindex(SO4ID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, 1:Ngrid))
    append!(colID, getindex(CaID, 1:Ngrid))
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
    append!(colID, getindex(CH4ID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, 1:Ngrid))
    append!(colID, getindex(CaCO3ID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, 1:Ngrid))
    append!(colID, getindex(MnCO3ID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, 1:Ngrid))
    append!(colID, getindex(FeCO3ID, 1:Ngrid))
    append!(rowID, getindex(TCO2ID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(HID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TH2SID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(TH2SID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(TH2SID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(TH2SID, 1:Ngrid))
    append!(colID, getindex(TCO2ID, 1:Ngrid))
    append!(rowID, getindex(TH2SID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(TH2SID, 1:Ngrid))
    append!(colID, getindex(TFeID, 1:Ngrid))
    append!(rowID, getindex(TH2SID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(TH2SID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(TH2SID, 1:Ngrid))
    append!(colID, getindex(SO4ID, 1:Ngrid))
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
    append!(colID, getindex(CH4ID, 1:Ngrid))
    append!(rowID, getindex(TH2SID, 1:Ngrid))
    append!(colID, getindex(FeSID, 1:Ngrid))
    append!(rowID, getindex(TH2SID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(HID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(HID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(HID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(HID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(TCO2ID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(TH2SID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(TH4SiO4ID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(TFeID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(FeOOHID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(MnO2ID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(TMnID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(SO4ID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(AlID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(CaID, 1:Ngrid))
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
    append!(colID, getindex(NH4ID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(FeSID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(CH4ID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(CaCO3ID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(MnCO3ID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(FeCO3ID, 1:Ngrid))
    append!(rowID, getindex(HID, 1:Ngrid))
    append!(colID, getindex(BasaltID, 1:Ngrid))
    append!(rowID, getindex(AgeID, vcat(1:Ngrid, 1:(Ngrid-1), 2:Ngrid)))
    append!(colID, getindex(AgeID, vcat(1:Ngrid, 2:Ngrid, 1:(Ngrid-1))))
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