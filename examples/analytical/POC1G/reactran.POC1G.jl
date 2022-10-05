function (f::Cache.Reactran)(dC, C, parms::Param.ParamStruct, t)
    #---------------------------------------------------------------------
    #  Parameters
    #---------------------------------------------------------------------
    @unpack POCID, AmPOC, BcAmPOC, BcCmPOC, Ngrid, k_POC = parms
    #---------------------------------------------------------------------
    #  Cache
    #---------------------------------------------------------------------
    RPOC = PreallocationTools.get_tmp(f.RPOC, C)
    S_POC = PreallocationTools.get_tmp(f.S_POC, C)

    #---------------------------------------------------------------------
    #  Model state
    #---------------------------------------------------------------------
    POC = @view C[POCID]
    dPOC = @view dC[POCID]
    #---------------------------------------------------------------------
    #  Transport of solid and dissolved substances
    #---------------------------------------------------------------------
    mul!(dPOC, AmPOC, POC)
    dPOC[1] += BcAmPOC[1] ⊗ POC[1] ⊕ BcCmPOC[1]
    dPOC[Ngrid] += BcAmPOC[2] ⊗ POC[Ngrid] ⊕ BcCmPOC[2]
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
    @.. RPOC = k_POC ⊗ POC

    # Summed rates for model substances
    @.. S_POC = -1 ⊗ RPOC

    @.. dPOC += S_POC

    return nothing
end
