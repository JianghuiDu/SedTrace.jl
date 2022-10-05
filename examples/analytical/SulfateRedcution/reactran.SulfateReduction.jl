function (f::Cache.Reactran)(dC, C, parms::Param.ParamStruct, t)
    #---------------------------------------------------------------------
    #  Parameters
    #---------------------------------------------------------------------
    @unpack POCID,
    SO4ID,
    AmPOC,
    AmSO4,
    BcAmPOC,
    BcCmPOC,
    BcAmSO4,
    BcCmSO4,
    Ngrid,
    alpha,
    SO40,
    dstopw,
    k_POC = parms
    #---------------------------------------------------------------------
    #  Cache
    #---------------------------------------------------------------------
    RPOCSO4 = PreallocationTools.get_tmp(f.RPOCSO4, C)
    S_POC = PreallocationTools.get_tmp(f.S_POC, C)
    S_SO4 = PreallocationTools.get_tmp(f.S_SO4, C)

    #---------------------------------------------------------------------
    #  Model state
    #---------------------------------------------------------------------
    POC = @view C[POCID]
    SO4 = @view C[SO4ID]
    dPOC = @view dC[POCID]
    dSO4 = @view dC[SO4ID]
    #---------------------------------------------------------------------
    #  Transport of solid and dissolved substances
    #---------------------------------------------------------------------
    mul!(dPOC, AmPOC, POC)
    mul!(dSO4, AmSO4, SO4)
    dPOC[1] += BcAmPOC[1] ⊗ POC[1] ⊕ BcCmPOC[1]
    dSO4[1] += BcAmSO4[1] ⊗ SO4[1] ⊕ BcCmSO4[1]
    dPOC[Ngrid] += BcAmPOC[2] ⊗ POC[Ngrid] ⊕ BcCmPOC[2]
    dSO4[Ngrid] += BcAmSO4[2] ⊗ SO4[Ngrid] ⊕ BcCmSO4[2]
    @.. dSO4 += alpha ⊗ (SO40 - SO4)
    #---------------------------------------------------------------------
    #  pH code
    #---------------------------------------------------------------------
    #---------------------------------------------------------------------
    #  Speciation code
    #---------------------------------------------------------------------
    #  Concentrations of adsorbed/dissolved species
    #  Transport of adsorbed/dissolved species
    #---------------------------------------------------------------------
    #  Reaction code
    #---------------------------------------------------------------------
    # Individual reaction rates
    @.. RPOCSO4 = k_POC ⊗ POC

    # Summed rates for model substances
    @.. S_POC = -1 ⊗ RPOCSO4
    @.. S_SO4 = -0.5 ⊗ RPOCSO4 ⊗ dstopw

    @.. dPOC += S_POC
    @.. dSO4 += S_SO4

    return nothing
end
