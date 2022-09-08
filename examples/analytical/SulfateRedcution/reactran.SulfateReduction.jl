function (f::Cache.Reactran)(dC, C, parms, t)
    RPOCSO4 = PreallocationTools.get_tmp(f.RPOCSO4, C)
    S_POC = PreallocationTools.get_tmp(f.S_POC, C)
    S_SO4 = PreallocationTools.get_tmp(f.S_SO4, C)

    POC = @view C[POCID]
    SO4 = @view C[SO4ID]

    dPOC = @view dC[POCID]
    dSO4 = @view dC[SO4ID]

    mul!(dPOC, AmPOC, POC)
    mul!(dSO4, AmSO4, SO4)

    dPOC[1] += BcAmPOC[1] ⊗ POC[1] ⊕ BcCmPOC[1]
    dSO4[1] += BcAmSO4[1] ⊗ SO4[1] ⊕ BcCmSO4[1]
    dPOC[Ngrid] += BcAmPOC[2] ⊗ POC[Ngrid] ⊕ BcCmPOC[2]
    dSO4[Ngrid] += BcAmSO4[2] ⊗ SO4[Ngrid] ⊕ BcCmSO4[2]

    @.. dSO4 += alpha ⊗ (SO40 - SO4)


    # speciation

    # reaction rates
    @.. RPOCSO4 = k_POC ⊗ POC

    # species rates
    @.. S_POC = -1 ⊗ RPOCSO4
    @.. S_SO4 = -0.5 ⊗ RPOCSO4 ⊗ dstopw

    @.. dPOC += S_POC
    @.. dSO4 += S_SO4

    return nothing
end
