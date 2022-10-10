function (f::Cache.Reactran)(dC, C, parms::Param.ParamStruct, t)
    #---------------------------------------------------------------------
    #  Parameters
    #---------------------------------------------------------------------
    @unpack N_orgID,
    TNH4ID,
    AmN_org,
    AmTNH4_dis,
    AmTNH4_ads_nsf,
    BcAmN_org,
    BcCmN_org,
    Ngrid,
    BcAmTNH4_dis,
    BcCmTNH4_dis,
    BcAmTNH4_ads_nsf,
    BcCmTNH4_ads_nsf,
    alpha,
    TNH4_dis0,
    dstopw,
    KNH4_ads,
    k = parms
    #---------------------------------------------------------------------
    #  Cache
    #---------------------------------------------------------------------
    NH4_ads = PreallocationTools.get_tmp(f.NH4_ads, C)
    TNH4_ads_nsf = PreallocationTools.get_tmp(f.TNH4_ads_nsf, C)
    TNH4_ads = PreallocationTools.get_tmp(f.TNH4_ads, C)
    TNH4_dis = PreallocationTools.get_tmp(f.TNH4_dis, C)
    TNH4_dis_tran = PreallocationTools.get_tmp(f.TNH4_dis_tran, C)
    TNH4_ads_nsf_tran = PreallocationTools.get_tmp(f.TNH4_ads_nsf_tran, C)
    Rremin = PreallocationTools.get_tmp(f.Rremin, C)
    S_N_org = PreallocationTools.get_tmp(f.S_N_org, C)
    S_TNH4 = PreallocationTools.get_tmp(f.S_TNH4, C)

    #---------------------------------------------------------------------
    #  Model state
    #---------------------------------------------------------------------
    N_org = @view C[N_orgID]
    TNH4 = @view C[TNH4ID]
    dN_org = @view dC[N_orgID]
    dTNH4 = @view dC[TNH4ID]
    #---------------------------------------------------------------------
    #  Transport of solid and dissolved substances
    #---------------------------------------------------------------------
    mul!(dN_org, AmN_org, N_org)
    dN_org[1] += BcAmN_org[1] ⊗ N_org[1] ⊕ BcCmN_org[1]
    dN_org[Ngrid] += BcAmN_org[2] ⊗ N_org[Ngrid] ⊕ BcCmN_org[2]
    #---------------------------------------------------------------------
    #  pH code
    #---------------------------------------------------------------------
    #---------------------------------------------------------------------
    #  Speciation code
    #---------------------------------------------------------------------
    #  Concentrations of adsorbed/dissolved species
    @.. TNH4_dis = TNH4 / (KNH4_ads ⊗ dstopw ⊕ 1)
    @.. NH4_ads = KNH4_ads ⊗ TNH4_dis
    @.. TNH4_ads_nsf = NH4_ads
    @.. TNH4_ads = NH4_ads
    #  Transport of adsorbed/dissolved species
    mul!(TNH4_dis_tran, AmTNH4_dis, TNH4_dis)
    TNH4_dis_tran[1] += BcAmTNH4_dis[1] ⊗ TNH4_dis[1] ⊕ BcCmTNH4_dis[1]
    TNH4_dis_tran[Ngrid] += BcAmTNH4_dis[2] ⊗ TNH4_dis[Ngrid] ⊕ BcCmTNH4_dis[2]
    mul!(TNH4_ads_nsf_tran, AmTNH4_ads_nsf, TNH4_ads_nsf)
    TNH4_ads_nsf_tran[1] +=
        BcAmTNH4_ads_nsf[1] ⊗ TNH4_ads_nsf[1] ⊕ BcCmTNH4_ads_nsf[1]
    TNH4_ads_nsf_tran[Ngrid] +=
        BcAmTNH4_ads_nsf[2] ⊗ TNH4_ads_nsf[Ngrid] ⊕ BcCmTNH4_ads_nsf[2]
    @.. dTNH4 = TNH4_dis_tran ⊗ 1 ⊕ TNH4_ads_nsf_tran ⊗ dstopw
    @.. dTNH4 += alpha ⊗ (TNH4_dis0 - TNH4_dis)

    #---------------------------------------------------------------------
    #  Reaction code
    #---------------------------------------------------------------------
    # Individual reaction rates
    @.. Rremin = k ⊗ N_org

    # Summed rates for model substances
    @.. S_N_org = -1 ⊗ Rremin
    @.. S_TNH4 = 1 ⊗ Rremin ⊗ dstopw

    @.. dN_org += S_N_org
    @.. dTNH4 += S_TNH4

    return nothing
end
