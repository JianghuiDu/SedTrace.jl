function (f::Cache.Reactran)(dC, C, parms, t)
    NH4 = PreallocationTools.get_tmp(f.NH4, C)
    NH4_tran = PreallocationTools.get_tmp(f.NH4_tran, C)
    NH4_ads = PreallocationTools.get_tmp(f.NH4_ads, C)
    NH4_ads_tran = PreallocationTools.get_tmp(f.NH4_ads_tran, C)
    Rdenitr = PreallocationTools.get_tmp(f.Rdenitr, C)
    S_TNH4 = PreallocationTools.get_tmp(f.S_TNH4, C)
    S_NH3 = PreallocationTools.get_tmp(f.S_NH3, C)

    TNH4 = @view C[TNH4ID]
    NH3 = @view C[NH3ID]

    dTNH4 = @view dC[TNH4ID]
    dNH3 = @view dC[NH3ID]

    mul!(dNH3, AmNH3, NH3)

    dNH3[1] += BcAmNH3[1] ⊗ NH3[1] ⊕ BcCmNH3[1]
    dNH3[Ngrid] += BcAmNH3[2] ⊗ NH3[Ngrid] ⊕ BcCmNH3[2]


    @.. NH4 = TNH4 / (KNH4_ads ⊗ dstopw ⊕ 1)
    mul!(NH4_tran, AmNH4, NH4)
    NH4_tran[1] += BcAmNH4[1] ⊗ NH4[1] ⊕ BcCmNH4[1]
    NH4_tran[Ngrid] += BcAmNH4[2] ⊗ NH4[Ngrid] ⊕ BcCmNH4[2]
    @.. NH4_ads = KNH4_ads ⊗ NH4
    mul!(NH4_ads_tran, AmNH4_ads, NH4_ads)
    NH4_ads_tran[1] += BcAmNH4_ads[1] ⊗ NH4_ads[1] ⊕ BcCmNH4_ads[1]
    NH4_ads_tran[Ngrid] += BcAmNH4_ads[2] ⊗ NH4_ads[Ngrid] ⊕ BcCmNH4_ads[2]
    @.. dTNH4 = NH4_tran ⊗ 1 ⊕ NH4_ads_tran ⊗ dstopw
    @.. dTNH4 += alpha ⊗ (NH40 - NH4)


    # speciation

    # reaction rates
    @.. Rdenitr = k_N ⊗ NH3

    # species rates
    @.. S_TNH4 = 1 ⊗ Rdenitr ⊗ dstopw
    @.. S_NH3 = -1 ⊗ Rdenitr

    @.. dTNH4 += S_TNH4
    @.. dNH3 += S_NH3

    return nothing
end
