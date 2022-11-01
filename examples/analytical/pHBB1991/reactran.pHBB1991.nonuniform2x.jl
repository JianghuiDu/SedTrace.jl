function (f::Cache.Reactran)(dC, C, parms::Param.ParamStruct, t)
    #---------------------------------------------------------------------
    #  Parameters
    #---------------------------------------------------------------------
    @unpack O2ID,
    HID,
    TCO2ID,
    TH2SID,
    TH3BO3ID,
    AmO2,
    AmH,
    AmOH,
    AmHCO3,
    AmCO3,
    AmCO2,
    AmH2S,
    AmHS,
    AmH3BO3,
    AmH4BO4,
    BcAmO2,
    BcCmO2,
    Ngrid,
    BcAmH,
    BcCmH,
    BcAmOH,
    BcCmOH,
    BcAmHCO3,
    BcCmHCO3,
    BcAmCO3,
    BcCmCO3,
    BcAmCO2,
    BcCmCO2,
    BcAmH2S,
    BcCmH2S,
    BcAmHS,
    BcCmHS,
    BcAmH3BO3,
    BcCmH3BO3,
    BcAmH4BO4,
    BcCmH4BO4,
    alpha,
    O20,
    H0,
    OH0,
    HCO30,
    CO30,
    CO20,
    H2S0,
    HS0,
    H3BO30,
    H4BO40,
    KH2O,
    KCO2,
    KHCO3,
    KH2S,
    KH3BO3,
    kOS,
    a,
    x,
    x0 = parms
    #---------------------------------------------------------------------
    #  Cache
    #---------------------------------------------------------------------
    OH = PreallocationTools.get_tmp(f.OH, C)
    HCO3 = PreallocationTools.get_tmp(f.HCO3, C)
    CO3 = PreallocationTools.get_tmp(f.CO3, C)
    CO2 = PreallocationTools.get_tmp(f.CO2, C)
    H2S = PreallocationTools.get_tmp(f.H2S, C)
    HS = PreallocationTools.get_tmp(f.HS, C)
    H3BO3 = PreallocationTools.get_tmp(f.H3BO3, C)
    H4BO4 = PreallocationTools.get_tmp(f.H4BO4, C)
    H_tran = PreallocationTools.get_tmp(f.H_tran, C)
    OH_tran = PreallocationTools.get_tmp(f.OH_tran, C)
    HCO3_tran = PreallocationTools.get_tmp(f.HCO3_tran, C)
    CO3_tran = PreallocationTools.get_tmp(f.CO3_tran, C)
    CO2_tran = PreallocationTools.get_tmp(f.CO2_tran, C)
    H2S_tran = PreallocationTools.get_tmp(f.H2S_tran, C)
    HS_tran = PreallocationTools.get_tmp(f.HS_tran, C)
    H3BO3_tran = PreallocationTools.get_tmp(f.H3BO3_tran, C)
    H4BO4_tran = PreallocationTools.get_tmp(f.H4BO4_tran, C)
    TA_tran = PreallocationTools.get_tmp(f.TA_tran, C)
    dTA_dH = PreallocationTools.get_tmp(f.dTA_dH, C)
    dTA_dTCO2 = PreallocationTools.get_tmp(f.dTA_dTCO2, C)
    dTA_dTH2S = PreallocationTools.get_tmp(f.dTA_dTH2S, C)
    dTA_dTH3BO3 = PreallocationTools.get_tmp(f.dTA_dTH3BO3, C)
    ROS = PreallocationTools.get_tmp(f.ROS, C)
    S_O2 = PreallocationTools.get_tmp(f.S_O2, C)
    S_TH2S = PreallocationTools.get_tmp(f.S_TH2S, C)
    S_TA = PreallocationTools.get_tmp(f.S_TA, C)
    S_H = PreallocationTools.get_tmp(f.S_H, C)

    #---------------------------------------------------------------------
    #  Model state
    #---------------------------------------------------------------------
    O2 = @view C[O2ID]
    H = @view C[HID]
    TCO2 = @view C[TCO2ID]
    TH2S = @view C[TH2SID]
    TH3BO3 = @view C[TH3BO3ID]
    dO2 = @view dC[O2ID]
    dH = @view dC[HID]
    dTCO2 = @view dC[TCO2ID]
    dTH2S = @view dC[TH2SID]
    dTH3BO3 = @view dC[TH3BO3ID]
    #---------------------------------------------------------------------
    #  Transport of solid and dissolved substances
    #---------------------------------------------------------------------
    mul!(dO2, AmO2, O2)
    dO2[1] += BcAmO2[1] ⊗ O2[1] ⊕ BcCmO2[1]
    dO2[Ngrid] += BcAmO2[2] ⊗ O2[Ngrid] ⊕ BcCmO2[2]
    @.. dO2 += alpha ⊗ (O20 - O2)
    #---------------------------------------------------------------------
    #  pH code
    #---------------------------------------------------------------------
    #  Concentrations of pH related species
    @.. OH = KH2O / H
    @.. HCO3 = H ⊗ KCO2 ⊗ TCO2 / (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)
    @.. CO3 = KCO2 ⊗ KHCO3 ⊗ TCO2 / (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)
    @.. CO2 = H^2 ⊗ TCO2 / (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)
    @.. H2S = H ⊗ TH2S / (H ⊕ KH2S)
    @.. HS = KH2S ⊗ TH2S / (H ⊕ KH2S)
    @.. H3BO3 = H ⊗ TH3BO3 / (H ⊕ KH3BO3)
    @.. H4BO4 = KH3BO3 ⊗ TH3BO3 / (H ⊕ KH3BO3)
    #  dTA/dEIs
    @.. dTA_dTCO2 = KCO2 ⊗ (H ⊕ 2 ⊗ KHCO3) / (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)
    @.. dTA_dTH2S = KH2S / (H ⊕ KH2S)
    @.. dTA_dTH3BO3 = KH3BO3 / (H ⊕ KH3BO3)
    #  dTA/dH
    @.. dTA_dH = -(H^2 ⊕ KH2O) / H^2
    @.. dTA_dH +=
        -KCO2 ⊗ TCO2 ⊗ (H^2 ⊕ 4 ⊗ H ⊗ KHCO3 ⊕ KCO2 ⊗ KHCO3) /
        (H^2 ⊕ H ⊗ KCO2 ⊕ KCO2 ⊗ KHCO3)^2
    @.. dTA_dH += -KH2S ⊗ TH2S / (H ⊕ KH2S)^2
    @.. dTA_dH += -KH3BO3 ⊗ TH3BO3 / (H ⊕ KH3BO3)^2
    #  Transport of individual species
    mul!(H_tran, AmH, H)
    H_tran[1] += BcAmH[1] ⊗ H[1] ⊕ BcCmH[1]
    H_tran[Ngrid] += BcAmH[2] ⊗ H[Ngrid] ⊕ BcCmH[2]
    @.. H_tran += alpha ⊗ (H0 - H)
    mul!(OH_tran, AmOH, OH)
    OH_tran[1] += BcAmOH[1] ⊗ OH[1] ⊕ BcCmOH[1]
    OH_tran[Ngrid] += BcAmOH[2] ⊗ OH[Ngrid] ⊕ BcCmOH[2]
    @.. OH_tran += alpha ⊗ (OH0 - OH)
    mul!(HCO3_tran, AmHCO3, HCO3)
    HCO3_tran[1] += BcAmHCO3[1] ⊗ HCO3[1] ⊕ BcCmHCO3[1]
    HCO3_tran[Ngrid] += BcAmHCO3[2] ⊗ HCO3[Ngrid] ⊕ BcCmHCO3[2]
    @.. HCO3_tran += alpha ⊗ (HCO30 - HCO3)
    mul!(CO3_tran, AmCO3, CO3)
    CO3_tran[1] += BcAmCO3[1] ⊗ CO3[1] ⊕ BcCmCO3[1]
    CO3_tran[Ngrid] += BcAmCO3[2] ⊗ CO3[Ngrid] ⊕ BcCmCO3[2]
    @.. CO3_tran += alpha ⊗ (CO30 - CO3)
    mul!(CO2_tran, AmCO2, CO2)
    CO2_tran[1] += BcAmCO2[1] ⊗ CO2[1] ⊕ BcCmCO2[1]
    CO2_tran[Ngrid] += BcAmCO2[2] ⊗ CO2[Ngrid] ⊕ BcCmCO2[2]
    @.. CO2_tran += alpha ⊗ (CO20 - CO2)
    mul!(H2S_tran, AmH2S, H2S)
    H2S_tran[1] += BcAmH2S[1] ⊗ H2S[1] ⊕ BcCmH2S[1]
    H2S_tran[Ngrid] += BcAmH2S[2] ⊗ H2S[Ngrid] ⊕ BcCmH2S[2]
    @.. H2S_tran += alpha ⊗ (H2S0 - H2S)
    mul!(HS_tran, AmHS, HS)
    HS_tran[1] += BcAmHS[1] ⊗ HS[1] ⊕ BcCmHS[1]
    HS_tran[Ngrid] += BcAmHS[2] ⊗ HS[Ngrid] ⊕ BcCmHS[2]
    @.. HS_tran += alpha ⊗ (HS0 - HS)
    mul!(H3BO3_tran, AmH3BO3, H3BO3)
    H3BO3_tran[1] += BcAmH3BO3[1] ⊗ H3BO3[1] ⊕ BcCmH3BO3[1]
    H3BO3_tran[Ngrid] += BcAmH3BO3[2] ⊗ H3BO3[Ngrid] ⊕ BcCmH3BO3[2]
    @.. H3BO3_tran += alpha ⊗ (H3BO30 - H3BO3)
    mul!(H4BO4_tran, AmH4BO4, H4BO4)
    H4BO4_tran[1] += BcAmH4BO4[1] ⊗ H4BO4[1] ⊕ BcCmH4BO4[1]
    H4BO4_tran[Ngrid] += BcAmH4BO4[2] ⊗ H4BO4[Ngrid] ⊕ BcCmH4BO4[2]
    @.. H4BO4_tran += alpha ⊗ (H4BO40 - H4BO4)
    #  Transport of EIs
    @.. dTCO2 = HCO3_tran ⊕ CO3_tran ⊕ CO2_tran
    @.. dTH2S = H2S_tran ⊕ HS_tran
    @.. dTH3BO3 = H3BO3_tran ⊕ H4BO4_tran
    # Transport of TA
    @.. TA_tran = -1 ⊗ H_tran ⊕ 1 ⊗ OH_tran
    @.. TA_tran += 1 ⊗ HCO3_tran ⊕ 2 ⊗ CO3_tran ⊕ 0 ⊗ CO2_tran
    @.. TA_tran += 0 ⊗ H2S_tran ⊕ 1 ⊗ HS_tran
    @.. TA_tran += 0 ⊗ H3BO3_tran ⊕ 1 ⊗ H4BO4_tran
    # Transport of proton
    @.. dH = TA_tran
    @.. dH -= dTCO2 ⊗ dTA_dTCO2
    @.. dH -= dTH2S ⊗ dTA_dTH2S
    @.. dH -= dTH3BO3 ⊗ dTA_dTH3BO3
    @.. dH = dH / dTA_dH
    #---------------------------------------------------------------------
    #  Speciation code
    #---------------------------------------------------------------------
    #  Concentrations of adsorbed/dissolved species
    #  Transport of adsorbed/dissolved species
    #---------------------------------------------------------------------
    #  Reaction code
    #---------------------------------------------------------------------
    # Individual reaction rates
    @.. ROS = kOS ⊗ exp(-a ⊗ (x - x0)^2)

    # Summed rates for model substances
    @.. S_O2 = -2 ⊗ ROS
    @.. S_TH2S = -1 ⊗ ROS
    @.. S_TA = -1 ⊗ ROS
    @.. S_TA += -1 ⊗ ROS
    @.. S_H = S_TA
    @.. S_H -= S_TH2S ⊗ dTA_dTH2S
    @.. S_H = S_H / dTA_dH

    @.. dO2 += S_O2
    @.. dH += S_H
    @.. dTH2S += S_TH2S

    return nothing
end
