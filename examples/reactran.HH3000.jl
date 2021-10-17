function reactran_fvcf_auto(dC, C, parms, t)
    POC = @view C[POCID]
    MnO2 = @view C[MnO2ID]
    FeOOH = @view C[FeOOHID]
    FeS = @view C[FeSID]
    FeS2 = @view C[FeS2ID]
    CaCO3 = @view C[CaCO3ID]
    MnCO3 = @view C[MnCO3ID]
    FeCO3 = @view C[FeCO3ID]
    Age = @view C[AgeID]
    BSi = @view C[BSiID]
    Basalt = @view C[BasaltID]
    NdnrPO4 = @view C[NdnrPO4ID]
    NdrPO4 = @view C[NdrPO4ID]
    Mn = @view C[MnID]
    Fe = @view C[FeID]
    NH4 = @view C[NH4ID]
    O2 = @view C[O2ID]
    NO3 = @view C[NO3ID]
    CH4 = @view C[CH4ID]
    NO2 = @view C[NO2ID]
    Ca = @view C[CaID]
    Al = @view C[AlID]
    SO4 = @view C[SO4ID]
    Ndnr = @view C[NdnrID]
    Ndr = @view C[NdrID]
    H = @view C[HID]
    TH4SiO4 = @view C[TH4SiO4ID]
    TCO2 = @view C[TCO2ID]
    TH2S = @view C[TH2SID]
    TH3BO3 = @view C[TH3BO3ID]
    TH3PO4 = @view C[TH3PO4ID]

    dPOC = @view dC[POCID]
    dMnO2 = @view dC[MnO2ID]
    dFeOOH = @view dC[FeOOHID]
    dFeS = @view dC[FeSID]
    dFeS2 = @view dC[FeS2ID]
    dCaCO3 = @view dC[CaCO3ID]
    dMnCO3 = @view dC[MnCO3ID]
    dFeCO3 = @view dC[FeCO3ID]
    dAge = @view dC[AgeID]
    dBSi = @view dC[BSiID]
    dBasalt = @view dC[BasaltID]
    dNdnrPO4 = @view dC[NdnrPO4ID]
    dNdrPO4 = @view dC[NdrPO4ID]
    dMn = @view dC[MnID]
    dFe = @view dC[FeID]
    dNH4 = @view dC[NH4ID]
    dO2 = @view dC[O2ID]
    dNO3 = @view dC[NO3ID]
    dCH4 = @view dC[CH4ID]
    dNO2 = @view dC[NO2ID]
    dCa = @view dC[CaID]
    dAl = @view dC[AlID]
    dSO4 = @view dC[SO4ID]
    dNdnr = @view dC[NdnrID]
    dNdr = @view dC[NdrID]
    dH = @view dC[HID]
    dTH4SiO4 = @view dC[TH4SiO4ID]
    dTCO2 = @view dC[TCO2ID]
    dTH2S = @view dC[TH2SID]
    dTH3BO3 = @view dC[TH3BO3ID]
    dTH3PO4 = @view dC[TH3PO4ID]

    dPOC .= AmPOC * POC
    dMnO2 .= AmMnO2 * MnO2
    dFeOOH .= AmFeOOH * FeOOH
    dFeS .= AmFeS * FeS
    dFeS2 .= AmFeS2 * FeS2
    dCaCO3 .= AmCaCO3 * CaCO3
    dMnCO3 .= AmMnCO3 * MnCO3
    dFeCO3 .= AmFeCO3 * FeCO3
    dAge .= AmAge * Age
    dBSi .= AmBSi * BSi
    dBasalt .= AmBasalt * Basalt
    dNdnrPO4 .= AmNdnrPO4 * NdnrPO4
    dNdrPO4 .= AmNdrPO4 * NdrPO4
    dO2 .= AmO2 * O2
    dNO3 .= AmNO3 * NO3
    dCH4 .= AmCH4 * CH4
    dNO2 .= AmNO2 * NO2
    dCa .= AmCa * Ca
    dAl .= AmAl * Al
    dSO4 .= AmSO4 * SO4
    dNdnr .= AmNdnr * Ndnr
    dNdr .= AmNdr * Ndr

    dPOC[1] += BcAmPOC[1] * POC[1] + BcCmPOC[1]
    dMnO2[1] += BcAmMnO2[1] * MnO2[1] + BcCmMnO2[1]
    dFeOOH[1] += BcAmFeOOH[1] * FeOOH[1] + BcCmFeOOH[1]
    dFeS[1] += BcAmFeS[1] * FeS[1] + BcCmFeS[1]
    dFeS2[1] += BcAmFeS2[1] * FeS2[1] + BcCmFeS2[1]
    dCaCO3[1] += BcAmCaCO3[1] * CaCO3[1] + BcCmCaCO3[1]
    dMnCO3[1] += BcAmMnCO3[1] * MnCO3[1] + BcCmMnCO3[1]
    dFeCO3[1] += BcAmFeCO3[1] * FeCO3[1] + BcCmFeCO3[1]
    dAge[1] += BcAmAge[1] * Age[1] + BcCmAge[1]
    dBSi[1] += BcAmBSi[1] * BSi[1] + BcCmBSi[1]
    dBasalt[1] += BcAmBasalt[1] * Basalt[1] + BcCmBasalt[1]
    dNdnrPO4[1] += BcAmNdnrPO4[1] * NdnrPO4[1] + BcCmNdnrPO4[1]
    dNdrPO4[1] += BcAmNdrPO4[1] * NdrPO4[1] + BcCmNdrPO4[1]
    dO2[1] += BcAmO2[1] * O2[1] + BcCmO2[1]
    dNO3[1] += BcAmNO3[1] * NO3[1] + BcCmNO3[1]
    dCH4[1] += BcAmCH4[1] * CH4[1] + BcCmCH4[1]
    dNO2[1] += BcAmNO2[1] * NO2[1] + BcCmNO2[1]
    dCa[1] += BcAmCa[1] * Ca[1] + BcCmCa[1]
    dAl[1] += BcAmAl[1] * Al[1] + BcCmAl[1]
    dSO4[1] += BcAmSO4[1] * SO4[1] + BcCmSO4[1]
    dNdnr[1] += BcAmNdnr[1] * Ndnr[1] + BcCmNdnr[1]
    dNdr[1] += BcAmNdr[1] * Ndr[1] + BcCmNdr[1]
    dPOC[Ngrid] += BcAmPOC[2] * POC[Ngrid] + BcCmPOC[2]
    dMnO2[Ngrid] += BcAmMnO2[2] * MnO2[Ngrid] + BcCmMnO2[2]
    dFeOOH[Ngrid] += BcAmFeOOH[2] * FeOOH[Ngrid] + BcCmFeOOH[2]
    dFeS[Ngrid] += BcAmFeS[2] * FeS[Ngrid] + BcCmFeS[2]
    dFeS2[Ngrid] += BcAmFeS2[2] * FeS2[Ngrid] + BcCmFeS2[2]
    dCaCO3[Ngrid] += BcAmCaCO3[2] * CaCO3[Ngrid] + BcCmCaCO3[2]
    dMnCO3[Ngrid] += BcAmMnCO3[2] * MnCO3[Ngrid] + BcCmMnCO3[2]
    dFeCO3[Ngrid] += BcAmFeCO3[2] * FeCO3[Ngrid] + BcCmFeCO3[2]
    dAge[Ngrid] += BcAmAge[2] * Age[Ngrid] + BcCmAge[2]
    dBSi[Ngrid] += BcAmBSi[2] * BSi[Ngrid] + BcCmBSi[2]
    dBasalt[Ngrid] += BcAmBasalt[2] * Basalt[Ngrid] + BcCmBasalt[2]
    dNdnrPO4[Ngrid] += BcAmNdnrPO4[2] * NdnrPO4[Ngrid] + BcCmNdnrPO4[2]
    dNdrPO4[Ngrid] += BcAmNdrPO4[2] * NdrPO4[Ngrid] + BcCmNdrPO4[2]
    dO2[Ngrid] += BcAmO2[2] * O2[Ngrid] + BcCmO2[2]
    dNO3[Ngrid] += BcAmNO3[2] * NO3[Ngrid] + BcCmNO3[2]
    dCH4[Ngrid] += BcAmCH4[2] * CH4[Ngrid] + BcCmCH4[2]
    dNO2[Ngrid] += BcAmNO2[2] * NO2[Ngrid] + BcCmNO2[2]
    dCa[Ngrid] += BcAmCa[2] * Ca[Ngrid] + BcCmCa[2]
    dAl[Ngrid] += BcAmAl[2] * Al[Ngrid] + BcCmAl[2]
    dSO4[Ngrid] += BcAmSO4[2] * SO4[Ngrid] + BcCmSO4[2]
    dNdnr[Ngrid] += BcAmNdnr[2] * Ndnr[Ngrid] + BcCmNdnr[2]
    dNdr[Ngrid] += BcAmNdr[2] * Ndr[Ngrid] + BcCmNdr[2]

    dO2 += alpha .* (O2BW .- O2)
    dNO3 += alpha .* (NO3BW .- NO3)
    dCH4 += alpha .* (CH4BW .- CH4)
    dNO2 += alpha .* (NO2BW .- NO2)
    dCa += alpha .* (CaBW .- Ca)
    dAl += alpha .* (AlBW .- Al)
    dSO4 += alpha .* (SO4BW .- SO4)
    dNdnr += alpha .* (NdnrBW .- Ndnr)
    dNdr += alpha .* (NdrBW .- Ndr)

    Mn_ads = Mn .* KMn_ads
    dMn .= AmMn_ads * Mn_ads
    dMn = dMn .* dstopw
    dMn += AmMn * Mn
    dMn[1] += (BcAmMn_ads[1] * Mn_ads[1] + BcCmMn_ads[1]) * dstopw[1]
    dMn[1] += BcAmMn[1] * Mn[1] + BcCmMn[1]
    dMn[Ngrid] +=
        (BcAmMn_ads[2] * Mn_ads[Ngrid] + BcCmMn_ads[2]) * dstopw[Ngrid]
    dMn[Ngrid] += BcAmMn[2] * Mn[Ngrid] + BcCmMn[2]
    dMn += alpha .* (Mn0 .- Mn)
    dMn = dMn ./ (1.0 .+ dstopw .* KMn_ads)

    Fe_ads = Fe .* KFe_ads
    dFe .= AmFe_ads * Fe_ads
    dFe = dFe .* dstopw
    dFe += AmFe * Fe
    dFe[1] += (BcAmFe_ads[1] * Fe_ads[1] + BcCmFe_ads[1]) * dstopw[1]
    dFe[1] += BcAmFe[1] * Fe[1] + BcCmFe[1]
    dFe[Ngrid] +=
        (BcAmFe_ads[2] * Fe_ads[Ngrid] + BcCmFe_ads[2]) * dstopw[Ngrid]
    dFe[Ngrid] += BcAmFe[2] * Fe[Ngrid] + BcCmFe[2]
    dFe += alpha .* (Fe0 .- Fe)
    dFe = dFe ./ (1.0 .+ dstopw .* KFe_ads)

    NH4_ads = NH4 .* KNH4_ads
    dNH4 .= AmNH4_ads * NH4_ads
    dNH4 = dNH4 .* dstopw
    dNH4 += AmNH4 * NH4
    dNH4[1] += (BcAmNH4_ads[1] * NH4_ads[1] + BcCmNH4_ads[1]) * dstopw[1]
    dNH4[1] += BcAmNH4[1] * NH4[1] + BcCmNH4[1]
    dNH4[Ngrid] +=
        (BcAmNH4_ads[2] * NH4_ads[Ngrid] + BcCmNH4_ads[2]) * dstopw[Ngrid]
    dNH4[Ngrid] += BcAmNH4[2] * NH4[Ngrid] + BcCmNH4[2]
    dNH4 += alpha .* (NH40 .- NH4)
    dNH4 = dNH4 ./ (1.0 .+ dstopw .* KNH4_ads)


    OH = KH2O ./ H
    H4SiO4 = H .* TH4SiO4 ./ (H .+ KH4SiO4)
    H3SiO4 = KH4SiO4 .* TH4SiO4 ./ (H .+ KH4SiO4)
    HCO3 = H .* KCO2 .* TCO2 ./ (H .^ 2 .+ H .* KCO2 .+ KCO2 .* KHCO3)
    CO3 = KCO2 .* KHCO3 .* TCO2 ./ (H .^ 2 .+ H .* KCO2 .+ KCO2 .* KHCO3)
    CO2 = H .^ 2 .* TCO2 ./ (H .^ 2 .+ H .* KCO2 .+ KCO2 .* KHCO3)
    H2S = H .* TH2S ./ (H .+ KH2S)
    HS = KH2S .* TH2S ./ (H .+ KH2S)
    H3BO3 = H .* TH3BO3 ./ (H .+ KH3BO3)
    H4BO4 = KH3BO3 .* TH3BO3 ./ (H .+ KH3BO3)
    H3PO4 =
        H .^ 3 .* TH3PO4 ./ (
            H .^ 3 .+ H .^ 2 .* KH3PO4 .+ H .* KH2PO4 .* KH3PO4 .+
            KH2PO4 .* KH3PO4 .* KHPO4
        )
    H2PO4 =
        H .^ 2 .* KH3PO4 .* TH3PO4 ./ (
            H .^ 3 .+ H .^ 2 .* KH3PO4 .+ H .* KH2PO4 .* KH3PO4 .+
            KH2PO4 .* KH3PO4 .* KHPO4
        )
    HPO4 =
        H .* KH2PO4 .* KH3PO4 .* TH3PO4 ./ (
            H .^ 3 .+ H .^ 2 .* KH3PO4 .+ H .* KH2PO4 .* KH3PO4 .+
            KH2PO4 .* KH3PO4 .* KHPO4
        )
    PO4 =
        KH2PO4 .* KH3PO4 .* KHPO4 .* TH3PO4 ./ (
            H .^ 3 .+ H .^ 2 .* KH3PO4 .+ H .* KH2PO4 .* KH3PO4 .+
            KH2PO4 .* KH3PO4 .* KHPO4
        )

    dTA_dTH4SiO4 = KH4SiO4 ./ (H .+ KH4SiO4)
    dTA_dTCO2 =
        KCO2 .* (H .+ 2.0 .* KHCO3) ./ (H .^ 2 .+ H .* KCO2 .+ KCO2 .* KHCO3)
    dTA_dTH2S = KH2S ./ (H .+ KH2S)
    dTA_dTH3BO3 = KH3BO3 ./ (H .+ KH3BO3)
    dTA_dTH3PO4 =
        H .* KH2PO4 .* KH3PO4 ./ (
            H .^ 3 .+ H .^ 2 .* KH3PO4 .+ H .* KH2PO4 .* KH3PO4 .+
            KH2PO4 .* KH3PO4 .* KHPO4
        ) .+
        2.0 .* KH2PO4 .* KH3PO4 .* KHPO4 ./ (
            H .^ 3 .+ H .^ 2 .* KH3PO4 .+ H .* KH2PO4 .* KH3PO4 .+
            KH2PO4 .* KH3PO4 .* KHPO4
        ) .+
        .-H .^ 3 ./ (
            H .^ 3 .+ H .^ 2 .* KH3PO4 .+ H .* KH2PO4 .* KH3PO4 .+
            KH2PO4 .* KH3PO4 .* KHPO4
        )

    dTA_dH = .-(H .^ 2 .+ KH2O) ./ H .^ 2
    dTA_dH += .-KH4SiO4 .* TH4SiO4 ./ (H .+ KH4SiO4) .^ 2
    dTA_dH +=
        .-KCO2 .* TCO2 .* (H .^ 2 .+ 4 .* H .* KHCO3 .+ KCO2 .* KHCO3) ./
        (H .^ 2 .+ H .* KCO2 .+ KCO2 .* KHCO3) .^ 2
    dTA_dH += .-KH2S .* TH2S ./ (H .+ KH2S) .^ 2
    dTA_dH += .-KH3BO3 .* TH3BO3 ./ (H .+ KH3BO3) .^ 2
    dTA_dH +=
        .-KH2PO4 .* KH3PO4 .* TH3PO4 .*
        (2.0 .* H .^ 3 .+ H .^ 2 .* KH3PO4 .- KH2PO4 .* KH3PO4 .* KHPO4) ./
        (
            H .^ 3 .+ H .^ 2 .* KH3PO4 .+ H .* KH2PO4 .* KH3PO4 .+
            KH2PO4 .* KH3PO4 .* KHPO4
        ) .^ 2 .+
        .-2.0 .* KH2PO4 .* KH3PO4 .* KHPO4 .* TH3PO4 .*
        (3.0 .* H .^ 2 .+ 2.0 .* H .* KH3PO4 .+ KH2PO4 .* KH3PO4) ./
        (
            H .^ 3 .+ H .^ 2 .* KH3PO4 .+ H .* KH2PO4 .* KH3PO4 .+
            KH2PO4 .* KH3PO4 .* KHPO4
        ) .^ 2 .+
        .-H .^ 2 .* KH3PO4 .* TH3PO4 .*
        (H .^ 2 .+ 2.0 .* H .* KH2PO4 .+ 3.0 .* KH2PO4 .* KHPO4) ./
        (
            H .^ 3 .+ H .^ 2 .* KH3PO4 .+ H .* KH2PO4 .* KH3PO4 .+
            KH2PO4 .* KH3PO4 .* KHPO4
        ) .^ 2


    H_tran = AmH * H
    H_tran[1] += BcAmH[1] * H[1] + BcCmH[1]
    H_tran[Ngrid] += BcAmH[2] * H[Ngrid] + BcCmH[2]
    H_tran += alpha .* (HBW .- H)

    OH_tran = AmOH * OH
    OH_tran[1] += BcAmOH[1] * OH[1] + BcCmOH[1]
    OH_tran[Ngrid] += BcAmOH[2] * OH[Ngrid] + BcCmOH[2]
    OH_tran += alpha .* (OHBW .- OH)

    H4SiO4_tran = AmH4SiO4 * H4SiO4
    H4SiO4_tran[1] += BcAmH4SiO4[1] * H4SiO4[1] + BcCmH4SiO4[1]
    H4SiO4_tran[Ngrid] += BcAmH4SiO4[2] * H4SiO4[Ngrid] + BcCmH4SiO4[2]
    H4SiO4_tran += alpha .* (H4SiO4BW .- H4SiO4)

    H3SiO4_tran = AmH3SiO4 * H3SiO4
    H3SiO4_tran[1] += BcAmH3SiO4[1] * H3SiO4[1] + BcCmH3SiO4[1]
    H3SiO4_tran[Ngrid] += BcAmH3SiO4[2] * H3SiO4[Ngrid] + BcCmH3SiO4[2]
    H3SiO4_tran += alpha .* (H3SiO4BW .- H3SiO4)

    HCO3_tran = AmHCO3 * HCO3
    HCO3_tran[1] += BcAmHCO3[1] * HCO3[1] + BcCmHCO3[1]
    HCO3_tran[Ngrid] += BcAmHCO3[2] * HCO3[Ngrid] + BcCmHCO3[2]
    HCO3_tran += alpha .* (HCO3BW .- HCO3)

    CO3_tran = AmCO3 * CO3
    CO3_tran[1] += BcAmCO3[1] * CO3[1] + BcCmCO3[1]
    CO3_tran[Ngrid] += BcAmCO3[2] * CO3[Ngrid] + BcCmCO3[2]
    CO3_tran += alpha .* (CO3BW .- CO3)

    CO2_tran = AmCO2 * CO2
    CO2_tran[1] += BcAmCO2[1] * CO2[1] + BcCmCO2[1]
    CO2_tran[Ngrid] += BcAmCO2[2] * CO2[Ngrid] + BcCmCO2[2]
    CO2_tran += alpha .* (CO2BW .- CO2)

    H2S_tran = AmH2S * H2S
    H2S_tran[1] += BcAmH2S[1] * H2S[1] + BcCmH2S[1]
    H2S_tran[Ngrid] += BcAmH2S[2] * H2S[Ngrid] + BcCmH2S[2]
    H2S_tran += alpha .* (H2SBW .- H2S)

    HS_tran = AmHS * HS
    HS_tran[1] += BcAmHS[1] * HS[1] + BcCmHS[1]
    HS_tran[Ngrid] += BcAmHS[2] * HS[Ngrid] + BcCmHS[2]
    HS_tran += alpha .* (HSBW .- HS)

    H3BO3_tran = AmH3BO3 * H3BO3
    H3BO3_tran[1] += BcAmH3BO3[1] * H3BO3[1] + BcCmH3BO3[1]
    H3BO3_tran[Ngrid] += BcAmH3BO3[2] * H3BO3[Ngrid] + BcCmH3BO3[2]
    H3BO3_tran += alpha .* (H3BO3BW .- H3BO3)

    H4BO4_tran = AmH4BO4 * H4BO4
    H4BO4_tran[1] += BcAmH4BO4[1] * H4BO4[1] + BcCmH4BO4[1]
    H4BO4_tran[Ngrid] += BcAmH4BO4[2] * H4BO4[Ngrid] + BcCmH4BO4[2]
    H4BO4_tran += alpha .* (H4BO4BW .- H4BO4)

    H3PO4_tran = AmH3PO4 * H3PO4
    H3PO4_tran[1] += BcAmH3PO4[1] * H3PO4[1] + BcCmH3PO4[1]
    H3PO4_tran[Ngrid] += BcAmH3PO4[2] * H3PO4[Ngrid] + BcCmH3PO4[2]
    H3PO4_tran += alpha .* (H3PO4BW .- H3PO4)

    H2PO4_tran = AmH2PO4 * H2PO4
    H2PO4_tran[1] += BcAmH2PO4[1] * H2PO4[1] + BcCmH2PO4[1]
    H2PO4_tran[Ngrid] += BcAmH2PO4[2] * H2PO4[Ngrid] + BcCmH2PO4[2]
    H2PO4_tran += alpha .* (H2PO4BW .- H2PO4)

    HPO4_tran = AmHPO4 * HPO4
    HPO4_tran[1] += BcAmHPO4[1] * HPO4[1] + BcCmHPO4[1]
    HPO4_tran[Ngrid] += BcAmHPO4[2] * HPO4[Ngrid] + BcCmHPO4[2]
    HPO4_tran += alpha .* (HPO4BW .- HPO4)

    PO4_tran = AmPO4 * PO4
    PO4_tran[1] += BcAmPO4[1] * PO4[1] + BcCmPO4[1]
    PO4_tran[Ngrid] += BcAmPO4[2] * PO4[Ngrid] + BcCmPO4[2]
    PO4_tran += alpha .* (PO4BW .- PO4)


    dTH4SiO4 .= H4SiO4_tran + H3SiO4_tran
    dTCO2 .= HCO3_tran + CO3_tran + CO2_tran
    dTH2S .= H2S_tran + HS_tran
    dTH3BO3 .= H3BO3_tran + H4BO4_tran
    dTH3PO4 .= H3PO4_tran + H2PO4_tran + HPO4_tran + PO4_tran

    TA_tran = .-1.0 .* H_tran .+ 1.0 .* OH_tran
    TA_tran += 0.0 .* H4SiO4_tran .+ 1.0 .* H3SiO4_tran
    TA_tran += 1.0 .* HCO3_tran .+ 2.0 .* CO3_tran .+ 0.0 .* CO2_tran
    TA_tran += 0.0 .* H2S_tran .+ 1.0 .* HS_tran
    TA_tran += 0.0 .* H3BO3_tran .+ 1.0 .* H4BO4_tran
    TA_tran +=
        .-1.0 .* H3PO4_tran .+ 0.0 .* H2PO4_tran .+ 1.0 .* HPO4_tran .+
        2.0 .* PO4_tran

    dH .= TA_tran
    dH -= dTH4SiO4 .* dTA_dTH4SiO4
    dH -= dTCO2 .* dTA_dTCO2
    dH -= dTH2S .* dTA_dTH2S
    dH -= dTH3BO3 .* dTA_dTH3BO3
    dH -= dTH3PO4 .* dTA_dTH3PO4
    dH = dH ./ dTA_dH
    # speciation
    Fe_free =
        Fe .* H ./ (
            H .* (
                38404.8078076036 .* CO3 .^ 2 .+ 1141.13847737758 .* CO3 .+
                0.541149470776101 .* Cl .+ 3.75214432319968 .* HCO3 .+
                409766.824665317 .* HS .+ 390245.286156751 .* OH .^ 2 .+
                3971.47624308745 .* OH .+ 6.626643393432 .* SO4
            ) .+ H .+ 0.00150222599838656 .* HS
        )
    Al_free =
        Al ./ (
            1889348.44155961 .* CO3 .+ 5.71374695230749e+39 .* OH .^ 4 .+
            1.2556441493638e+31 .* OH .^ 3 .+ 5.63992735079517e+20 .* OH .^ 2 .+
            7872134080.00216 .* OH .+ 1
        )
    Ndnr_free =
        H .* Ndnr ./ (
            H .* (
                3632465961.77468 .* CO3 .^ 2 .+ 290431.690955537 .* CO3 .+
                0.343269152592752 .* Cl .+ 63095734448.0194 .* H3SiO4 .^ 2 .+
                158489.319246111 .* H3SiO4 .+ 7.38572662109916 .* HCO3 .+
                56.0142660345257 .* SO4
            ) .+ H .+ 9.62959782270152e-10
        )
    Ndr_free =
        H .* Ndr ./ (
            H .* (
                3632465961.77468 .* CO3 .^ 2 .+ 290431.690955537 .* CO3 .+
                0.343269152592752 .* Cl .+ 63095734448.0194 .* H3SiO4 .^ 2 .+
                158489.319246111 .* H3SiO4 .+ 7.38572662109917 .* HCO3 .+
                56.0142660345257 .* SO4
            ) .+ H .+ 9.62959782270152e-10
        )

    # reaction rates
    Omega_RFeS_dis = Fe_free .* HS ./ (H .* KspFeS)
    Omega_RFeS_pre = Fe_free .* HS ./ (H .* KspFeS)
    Omega_RCaCO3_dis = Ca .* CO3 ./ KspCaCO3_dis
    Omega_RCaCO3_pre = Ca .* CO3 ./ KspCaCO3_pre
    Omega_RMnCO3_dis = Mn .* CO3 ./ KspMnCO3
    Omega_RMnCO3_pre = Mn .* CO3 ./ KspMnCO3
    Omega_RFeCO3_dis = Fe .* CO3 ./ KspFeCO3
    Omega_RFeCO3_pre = Fe .* CO3 ./ KspFeCO3
    Omega_RBSi_dis = H4SiO4 ./ H4SiO4_dis_sat
    Omega_RNdnrPO4_pre = Ndnr_free .* PO4 ./ (KspNdPO4 .* fNdnr)
    Omega_RNdrPO4_pre = Ndr_free .* PO4 ./ (KspNdPO4 .* Ndr ./ Ndnr .* fNdnr)
    RO2POC = O2 ./ (KO2 .+ O2) .* nu ./ (a .+ Age) .* POC
    RNO2POC =
        NO2 ./ (KNO2 .+ NO2) .* KO2 ./ (KO2 .+ O2) .* nu ./ (a .+ Age) .* POC
    RNO3POC =
        NO3 ./ (KNO3 .+ NO3) .* KNO2 ./ (KNO2 .+ NO2) .* KO2 ./ (KO2 .+ O2) .*
        nu ./ (a .+ Age) .* POC
    RMnO2POC =
        MnO2 ./ (KMnO2 .+ MnO2) .* KNO3 ./ (KNO3 .+ NO3) .* KNO2 ./
        (KNO2 .+ NO2) .* KO2 ./ (KO2 .+ O2) .* nu ./ (a .+ Age) .* POC
    RFeOOHPOC =
        FeOOH ./ (KFeOOH .+ FeOOH) .* KMnO2 ./ (KMnO2 .+ MnO2) .* KNO3 ./
        (KNO3 .+ NO3) .* KNO2 ./ (KNO2 .+ NO2) .* KO2 ./ (KO2 .+ O2) .* nu ./
        (a .+ Age) .* POC
    RSO4POC =
        SO4 ./ (KSO4 .+ SO4) .* KFeOOH ./ (KFeOOH .+ FeOOH) .* KMnO2 ./
        (KMnO2 .+ MnO2) .* KNO3 ./ (KNO3 .+ NO3) .* KNO2 ./ (KNO2 .+ NO2) .*
        KO2 ./ (KO2 .+ O2) .* nu ./ (a .+ Age) .* POC
    RCH4POC =
        KSO4 ./ (KSO4 .+ SO4) .* KFeOOH ./ (KFeOOH .+ FeOOH) .* KMnO2 ./
        (KMnO2 .+ MnO2) .* KNO3 ./ (KNO3 .+ NO3) .* KNO2 ./ (KNO2 .+ NO2) .*
        KO2 ./ (KO2 .+ O2) .* nu ./ (a .+ Age) .* POC
    RO2NO2 = kO2NO2 .* O2 .* NO2
    RO2NH4 = kO2NH4 .* O2 .* NH4
    RO2Mn = kO2Mn .* O2 .* Mn
    RO2Mn_ads = kO2Mn_ads .* O2 .* Mn_ads
    RO2Fe = kO2Fe .* O2 .* Fe
    RO2Fe_ads = kO2Fe_ads .* O2 .* Fe_ads
    RO2H2S = kO2H2S .* O2 .* TH2S
    RO2FeS = kO2FeS .* O2 .* FeS
    RO2CH4 = kO2CH4 .* O2 .* CH4
    RNO2NH4 = kNO2NH4 .* NO2 .* NH4
    RNO3Mn = kNO3Mn .* NO3 .* Mn
    RNO3Fe = kNO3Fe .* NO3 .* Fe
    RNO3H2S = kNO3H2S .* NO3 .* TH2S
    RSO4CH4 = kAOM .* CH4 .* SO4 ./ (SO4 .+ KAOM)
    RMnO2Fe = kMnO2Fe .* MnO2 .* Fe
    RMnO2H2S = kMnO2H2S .* MnO2 .* TH2S
    RFeOOHH2S = kFeOOHH2S .* FeOOH .* TH2S
    RFeSH2S = kFeSH2S .* FeS .* TH2S
    RFeS_dis =
        (.-tanh.(100.0 .* (Omega_RFeS_dis .- 1.0)) ./ 2 .+ 0.5) .*
        (kFeSdis .* FeS .* (1 .- Omega_RFeS_dis))
    RFeS_pre =
        (tanh.(100.0 .* (Omega_RFeS_pre .- 1.0)) ./ 2 .+ 0.5) .*
        (kFeSpre .* Fe .* TH2S .* (Omega_RFeS_pre .- 1))
    RCaCO3_dis =
        (.-tanh.(100.0 .* (Omega_RCaCO3_dis .- 1.0)) ./ 2 .+ 0.5) .* (
            kCaCO3dis0 .* CaCO3 .+
            kCaCO3dis1 .* CaCO3 .* (1 .- Omega_RCaCO3_dis) .^ nCaCO3dis
        )
    RCaCO3_pre =
        (tanh.(100.0 .* (Omega_RCaCO3_pre .- 1.0)) ./ 2 .+ 0.5) .*
        (kCaCO3pre .* CaCO3 .* (Omega_RCaCO3_pre .- 1))
    RMnCO3_dis =
        (.-tanh.(100.0 .* (Omega_RMnCO3_dis .- 1.0)) ./ 2 .+ 0.5) .*
        (kMnCO3dis .* MnCO3 .* (1 .- Omega_RMnCO3_dis))
    RMnCO3_pre =
        (tanh.(100.0 .* (Omega_RMnCO3_pre .- 1.0)) ./ 2 .+ 0.5) .*
        (kMnCO3pre .* (Omega_RMnCO3_pre .- 1))
    RFeCO3_dis =
        (.-tanh.(100.0 .* (Omega_RFeCO3_dis .- 1.0)) ./ 2 .+ 0.5) .*
        (kFeCO3dis .* FeCO3 .* (1 .- Omega_RFeCO3_dis))
    RFeCO3_pre =
        (tanh.(100.0 .* (Omega_RFeCO3_pre .- 1.0)) ./ 2 .+ 0.5) .*
        (kFeCO3pre .* (Omega_RFeCO3_pre .- 1))
    RBSi_dis =
        (.-tanh.(100.0 .* (Omega_RBSi_dis .- 1.0)) ./ 2 .+ 0.5) .*
        ((1 .- Omega_RBSi_dis) .* BSi .* nuBSi ./ (aBSi .+ Age))
    RMnO2POC_Nd = RMnO2POC .* 2
    RMnO2H2S_Nd = RMnO2H2S
    RFeOOHPOC_Nd = RFeOOHPOC
    RFeOOHH2S_Nd = RFeOOHH2S .* 2
    RO2Mn_Ndnr = RO2Mn .* rNdnrMn
    RO2Mn_Ndr = RO2Mn .* rNdnrMn .* Ndr ./ Ndnr
    RO2Fe_Ndnr = RO2Fe .* rNdnrFe
    RO2Fe_Ndr = RO2Fe .* rNdnrFe .* Ndr ./ Ndnr
    RNdnrPO4_pre =
        (tanh.(100.0 .* (Omega_RNdnrPO4_pre .- 1.0)) ./ 2 .+ 0.5) .*
        (kNdPO4_pre .* fNdnr .* (Omega_RNdnrPO4_pre .- 1))
    RNdrPO4_pre =
        (tanh.(100.0 .* (Omega_RNdrPO4_pre .- 1.0)) ./ 2 .+ 0.5) .*
        (kNdPO4_pre .* Ndr ./ Ndnr .* fNdnr .* (Omega_RNdrPO4_pre .- 1))

    # species rates
    S_POC =
        .-1 .* RO2POC .+ .-1 .* RNO2POC .+ .-1 .* RNO3POC .+ .-1 .* RMnO2POC .+
        .-1 .* RFeOOHPOC .+ .-1 .* RSO4POC .+ .-1 .* RCH4POC
    S_O2 =
        .-1 .* RO2POC .* dstopw .+ .-1 ./ 2 .* RO2NO2 .+ .-3 ./ 2 .* RO2NH4 .+
        .-1 ./ 2 .* RO2Mn .+ .-1 ./ 2 .* RO2Mn_ads .* dstopw .+
        .-1 ./ 4 .* RO2Fe .+ .-1 ./ 4 .* RO2Fe_ads .* dstopw .+ .-2 .* RO2H2S .+
        .-9 ./ 4 .* RO2FeS .* dstopw .+ .-2 .* RO2CH4
    S_TCO2 =
        1 .* RO2POC .* dstopw .+ 1 .* RNO2POC .* dstopw .+
        1 .* RNO3POC .* dstopw .+ 1 .* RMnO2POC .* dstopw .+
        1 .* RFeOOHPOC .* dstopw .+ 1 .* RSO4POC .* dstopw .+
        1 ./ 2 .* RCH4POC .* dstopw .+ 1 .* RO2CH4 .+ 1 .* RSO4CH4 .+
        1 .* RCaCO3_dis .* dstopw .+ .-1 .* RCaCO3_pre .* dstopw .+
        1 .* RMnCO3_dis .* dstopw .+ .-1 .* RMnCO3_pre .* dstopw .+
        1 .* RFeCO3_dis .* dstopw .+ .-1 .* RFeCO3_pre .* dstopw
    S_NH4 =
        rNC .* RO2POC ./ (pwtods .+ KNH4_ads) .+
        rNC .* RNO2POC ./ (pwtods .+ KNH4_ads) .+
        rNC .* RNO3POC ./ (pwtods .+ KNH4_ads) .+
        rNC .* RMnO2POC ./ (pwtods .+ KNH4_ads) .+
        rNC .* RFeOOHPOC ./ (pwtods .+ KNH4_ads) .+
        rNC .* RSO4POC ./ (pwtods .+ KNH4_ads) .+
        rNC .* RCH4POC ./ (pwtods .+ KNH4_ads) .+
        .-1 .* RO2NH4 ./ (1 .+ dstopw .* KNH4_ads) .+
        .-1 .* RNO2NH4 ./ (1 .+ dstopw .* KNH4_ads) .+
        1 .* RNO3H2S ./ (1 .+ dstopw .* KNH4_ads)
    S_TH3PO4 =
        rPC .* RO2POC .* dstopw .+ rPC .* RNO2POC .* dstopw .+
        rPC .* RNO3POC .* dstopw .+ rPC .* RMnO2POC .* dstopw .+
        rPC .* RFeOOHPOC .* dstopw .+ rPC .* RSO4POC .* dstopw .+
        rPC .* RCH4POC .* dstopw .+ .-1 .* RNdnrPO4_pre .+ .-1 .* RNdrPO4_pre
    S_NO2 =
        .-4 ./ 3 .* RNO2POC .* dstopw .+ 2 .* RNO3POC .* dstopw .+
        .-1 .* RO2NO2 .+ 1 .* RO2NH4 .+ .-1 .* RNO2NH4
    S_NO3 =
        .-2 .* RNO3POC .* dstopw .+ 1 .* RO2NO2 .+ .-2 ./ 5 .* RNO3Mn .+
        .-1 ./ 5 .* RNO3Fe .+ .-1 .* RNO3H2S
    S_MnO2 =
        .-2 .* RMnO2POC .+ 1 .* RO2Mn .* pwtods .+ 1 .* RO2Mn_ads .+
        1 .* RNO3Mn .* pwtods .+ .-1 ./ 2 .* RMnO2Fe .+ .-1 .* RMnO2H2S
    S_Mn =
        2 .* RMnO2POC ./ (pwtods .+ KMn_ads) .+
        .-1 .* RO2Mn ./ (1 .+ dstopw .* KMn_ads) .+
        .-1 .* RO2Mn_ads ./ (pwtods .+ KMn_ads) .+
        .-1 .* RNO3Mn ./ (1 .+ dstopw .* KMn_ads) .+
        1 ./ 2 .* RMnO2Fe ./ (pwtods .+ KMn_ads) .+
        1 .* RMnO2H2S ./ (pwtods .+ KMn_ads) .+
        1 .* RMnCO3_dis ./ (pwtods .+ KMn_ads) .+
        .-1 .* RMnCO3_pre ./ (pwtods .+ KMn_ads)
    S_FeOOH =
        .-4 .* RFeOOHPOC .+ 1 .* RO2Fe .* pwtods .+ 1 .* RO2Fe_ads .+
        1 .* RO2FeS .+ 1 .* RNO3Fe .* pwtods .+ 1 .* RMnO2Fe .+ .-2 .* RFeOOHH2S
    S_Fe =
        4 .* RFeOOHPOC ./ (pwtods .+ KFe_ads) .+
        .-1 .* RO2Fe ./ (1 .+ dstopw .* KFe_ads) .+
        .-1 .* RO2Fe_ads ./ (pwtods .+ KFe_ads) .+
        .-1 .* RNO3Fe ./ (1 .+ dstopw .* KFe_ads) .+
        .-1 .* RMnO2Fe ./ (pwtods .+ KFe_ads) .+
        2 .* RFeOOHH2S ./ (pwtods .+ KFe_ads) .+
        1 .* RFeS_dis ./ (pwtods .+ KFe_ads) .+
        .-1 .* RFeS_pre ./ (1 .+ dstopw .* KFe_ads) .+
        1 .* RFeCO3_dis ./ (pwtods .+ KFe_ads) .+
        .-1 .* RFeCO3_pre ./ (pwtods .+ KFe_ads)
    S_SO4 =
        .-1 ./ 2 .* RSO4POC .* dstopw .+ 1 .* RO2H2S .+ 1 .* RO2FeS .* dstopw .+
        1 .* RNO3H2S .+ .-1 .* RSO4CH4
    S_TH2S =
        1 ./ 2 .* RSO4POC .* dstopw .+ .-1 .* RO2H2S .+ .-1 .* RNO3H2S .+
        1 .* RSO4CH4 .+ .-1 .* RMnO2H2S .* dstopw .+
        .-1 .* RFeOOHH2S .* dstopw .+ .-1 .* RFeSH2S .* dstopw .+
        1 .* RFeS_dis .* dstopw .+ .-1 .* RFeS_pre
    S_CH4 = 1 ./ 2 .* RCH4POC .* dstopw .+ .-1 .* RO2CH4 .+ .-1 .* RSO4CH4
    S_FeS =
        .-1 .* RO2FeS .+ .-1 .* RFeSH2S .+ .-1 .* RFeS_dis .+
        1 .* RFeS_pre .* pwtods
    S_FeS2 = 1 .* RFeSH2S
    S_CaCO3 = .-1 .* RCaCO3_dis .+ 1 .* RCaCO3_pre
    S_Ca = 1 .* RCaCO3_dis .* dstopw .+ .-1 .* RCaCO3_pre .* dstopw
    S_MnCO3 = .-1 .* RMnCO3_dis .+ 1 .* RMnCO3_pre
    S_FeCO3 = .-1 .* RFeCO3_dis .+ 1 .* RFeCO3_pre
    S_BSi = .-1 .* RBSi_dis
    S_TH4SiO4 = 1 .* RBSi_dis .* dstopw
    S_Ndnr =
        rNdnrMn .* RMnO2POC_Nd .+ rNdnrMn .* RMnO2H2S_Nd .+
        rNdnrFe .* RFeOOHPOC_Nd .+ rNdnrFe .* RFeOOHH2S_Nd .+
        .-1 .* RO2Mn_Ndnr .+ .-1 .* RO2Fe_Ndnr .+ .-1 .* RNdnrPO4_pre
    S_Ndr =
        rNdrMn .* RMnO2POC_Nd .+ rNdrMn .* RMnO2H2S_Nd .+
        rNdrFe .* RFeOOHPOC_Nd .+ rNdrFe .* RFeOOHH2S_Nd .+ .-1 .* RO2Mn_Ndr .+
        .-1 .* RO2Fe_Ndr .+ .-1 .* RNdrPO4_pre
    S_NdnrPO4 = 1 .* RNdnrPO4_pre .* pwtods
    S_NdrPO4 = 1 .* RNdrPO4_pre .* pwtods
    S_TA =
        (1.0 .* rNC .- 1.0 .* rPC) .* RO2POC .* dstopw .+
        (1.0 .* rNC .- 1.0 .* rPC .+ 1.33333333333333) .* RNO2POC .* dstopw .+
        (1.0 .* rNC .- 1.0 .* rPC) .* RNO3POC .* dstopw .+
        (1.0 .* rNC .- 1.0 .* rPC .+ 4.0) .* RMnO2POC .* dstopw .+
        (1.0 .* rNC .- 1.0 .* rPC .+ 8.0) .* RFeOOHPOC .* dstopw .+
        (1.0 .* rNC .- 1.0 .* rPC .+ 1.0) .* RSO4POC .* dstopw .+
        (1.0 .* rNC .- 1.0 .* rPC) .* RCH4POC .* dstopw .+ .-2 .* RO2NH4 .+
        .-2 .* RO2Mn .+ .-1 .* RO2Mn_ads .* dstopw .+ .-2 .* RO2Fe .+
        .-1 .* RO2Fe_ads .* dstopw .+ .-2 .* RO2H2S .+
        .-2 .* RO2FeS .* dstopw .+ .-8 ./ 5 .* RNO3Mn .+ .-9 ./ 5 .* RNO3Fe .+
        2 .* RSO4CH4 .+ .-1 .* RMnO2Fe .* dstopw .+ 2 .* RMnO2H2S .* dstopw .+
        4 .* RFeOOHH2S .* dstopw .+ 1 .* RFeS_dis .* dstopw .+ .-1 .* RFeS_pre
    S_TA +=
        0 .* RO2POC .* dstopw .+ 0 .* RNO2POC .* dstopw .+
        0 .* RNO3POC .* dstopw .+ 0 .* RMnO2POC .* dstopw .+
        0 .* RFeOOHPOC .* dstopw .+ 0 .* RSO4POC .* dstopw .+
        0 .* RCH4POC .* dstopw .+ 0 .* RO2CH4 .+ 0 .* RSO4CH4 .+
        2 .* RCaCO3_dis .* dstopw .+ .-2 .* RCaCO3_pre .* dstopw .+
        2 .* RMnCO3_dis .* dstopw .+ .-2 .* RMnCO3_pre .* dstopw .+
        2 .* RFeCO3_dis .* dstopw .+ .-2 .* RFeCO3_pre .* dstopw
    S_TA +=
        (0) .* RO2POC .* dstopw .+ (0) .* RNO2POC .* dstopw .+
        (0) .* RNO3POC .* dstopw .+ (0) .* RMnO2POC .* dstopw .+
        (0) .* RFeOOHPOC .* dstopw .+ (0) .* RSO4POC .* dstopw .+
        (0) .* RCH4POC .* dstopw .+ .-2 .* RNdnrPO4_pre .+ .-2 .* RNdrPO4_pre
    S_TA +=
        0 .* RSO4POC .* dstopw .+ 0 .* RO2H2S .+ 0 .* RNO3H2S .+ 0 .* RSO4CH4 .+
        0 .* RMnO2H2S .* dstopw .+ 0 .* RFeOOHH2S .* dstopw .+
        0 .* RFeSH2S .* dstopw .+ 1 .* RFeS_dis .* dstopw .+ .-1 .* RFeS_pre
    S_TA += 0 .* RBSi_dis .* dstopw
    S_H = S_TA
    S_H -= S_TCO2 .* dTA_dTCO2
    S_H -= S_TH3PO4 .* dTA_dTH3PO4
    S_H -= S_TH2S .* dTA_dTH2S
    S_H -= S_TH4SiO4 .* dTA_dTH4SiO4
    S_H = S_H ./ dTA_dH
    S_Age = ones(Ngrid)

    dPOC += S_POC
    dMnO2 += S_MnO2
    dFeOOH += S_FeOOH
    dFeS += S_FeS
    dFeS2 += S_FeS2
    dCaCO3 += S_CaCO3
    dMnCO3 += S_MnCO3
    dFeCO3 += S_FeCO3
    dAge += S_Age
    dBSi += S_BSi
    dNdnrPO4 += S_NdnrPO4
    dNdrPO4 += S_NdrPO4
    dMn += S_Mn
    dFe += S_Fe
    dNH4 += S_NH4
    dO2 += S_O2
    dNO3 += S_NO3
    dCH4 += S_CH4
    dNO2 += S_NO2
    dCa += S_Ca
    dSO4 += S_SO4
    dNdnr += S_Ndnr
    dNdr += S_Ndr
    dH += S_H
    dTH4SiO4 += S_TH4SiO4
    dTCO2 += S_TCO2
    dTH2S += S_TH2S
    dTH3PO4 += S_TH3PO4

    return nothing
end
