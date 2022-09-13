function (f::Cache.Reactran)(dC, C, parms::Param.ParamStruct, t)
    @unpack POCID, AmPOC, BcAmPOC, BcCmPOC, Ngrid, k_POC = parms

    RPOC = PreallocationTools.get_tmp(f.RPOC, C)
    S_POC = PreallocationTools.get_tmp(f.S_POC, C)

    POC = @view C[POCID]

    dPOC = @view dC[POCID]

    mul!(dPOC, AmPOC, POC)

    dPOC[1] += BcAmPOC[1] ⊗ POC[1] ⊕ BcCmPOC[1]
    dPOC[Ngrid] += BcAmPOC[2] ⊗ POC[Ngrid] ⊕ BcCmPOC[2]




    # reaction rates
    @.. RPOC = k_POC ⊗ POC

    # species rates
    @.. S_POC = -1 ⊗ RPOC

    @.. dPOC += S_POC

    return nothing
end
