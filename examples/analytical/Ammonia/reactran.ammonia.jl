function (f::Cache.Reactran)(dC, C, parms::Param.ParamStruct, t)
    @unpack TNH4ID,
    N_orgID,
    AmN_org,
    AmNH4,
    AmNH4_ads,
    BcAmN_org,
    BcCmN_org,
    Ngrid,
    BcAmNH4,
    BcCmNH4,
    BcAmNH4_ads,
    BcCmNH4_ads,
    alpha,
    NH40,
    KNH4_ads,
    dstopw,
    k = parms

    NH4 = PreallocationTools.get_tmp(f.NH4, C)
    NH4_tran = PreallocationTools.get_tmp(f.NH4_tran, C)
    NH4_ads = PreallocationTools.get_tmp(f.NH4_ads, C)
    NH4_ads_tran = PreallocationTools.get_tmp(f.NH4_ads_tran, C)
    Rremin = PreallocationTools.get_tmp(f.Rremin, C)
    S_TNH4 = PreallocationTools.get_tmp(f.S_TNH4, C)
    S_N_org = PreallocationTools.get_tmp(f.S_N_org, C)

    TNH4 = @view C[TNH4ID]
    N_org = @view C[N_orgID]

    dTNH4 = @view dC[TNH4ID]
    dN_org = @view dC[N_orgID]

    mul!(dN_org, AmN_org, N_org)

    dN_org[1] += BcAmN_org[1] ⊗ N_org[1] ⊕ BcCmN_org[1]
    dN_org[Ngrid] += BcAmN_org[2] ⊗ N_org[Ngrid] ⊕ BcCmN_org[2]


    @.. NH4 = TNH4 / (KNH4_ads ⊗ dstopw ⊕ 1)
    mul!(NH4_tran, AmNH4, NH4)
    NH4_tran[1] += BcAmNH4[1] ⊗ NH4[1] ⊕ BcCmNH4[1]
    NH4_tran[Ngrid] += BcAmNH4[2] ⊗ NH4[Ngrid] ⊕ BcCmNH4[2]
    @.. NH4_ads = KNH4_ads ⊗ NH4
    mul!(NH4_ads_tran, AmNH4_ads, NH4_ads)
    NH4_ads_tran[1] += BcAmNH4_ads[1] ⊗ NH4_ads[1] ⊕ BcCmNH4_ads[1]
    NH4_ads_tran[Ngrid] += BcAmNH4_ads[2] ⊗ NH4_ads[Ngrid] ⊕ BcCmNH4_ads[2]
    @.. dTNH4 = NH4_ads_tran ⊗ dstopw ⊕ NH4_tran ⊗ 1
    @.. dTNH4 += alpha ⊗ (NH40 - NH4)



    # reaction rates
    @.. Rremin = k ⊗ N_org

    # species rates
    @.. S_TNH4 = 1 ⊗ Rremin ⊗ dstopw
    @.. S_N_org = -1 ⊗ Rremin

    @.. dTNH4 += S_TNH4
    @.. dN_org += S_N_org

    return nothing
end
