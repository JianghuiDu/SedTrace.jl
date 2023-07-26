
using NonlinearSolve, DataFrames


function O2_analytical(Param)
    DO2 = Param.DO2[1]
    L1 = -0.05
    L2 = 0.15
    L = L2 - L1
    a = Param.a
    O20 = Param.O20
    x = Param.x
    x0 = Param.x0
    kOS = Param.kOS

    O2 = fill(NaN, Param.Ngrid)

    @.. O2 =
        1 / (a * DO2 * (L1 - L2)) * (
            a * O20 * DO2 * (-L2 + x) +
            kOS * (
                exp(-a * (x - x0)^2) * (L1 - L2) +
                exp(-a * (L2 - x0)^2) * (-L1 + x) +
                exp(-a * (L1 - x0)^2) * (L2 - x)
            ) +
            sqrt(a) *
            kOS *
            sqrt(pi) *
            (
                -(L1 - x) * (L2 - x0) * erf(sqrt(a) * (L2 - x0)) +
                (L1 - L2) * (x - x0) * erf(sqrt(a) * (x - x0)) +
                (L2 - x) * (L1 - x0) * erf(sqrt(a) * (L1 - x0))
            )
        )


end


function pH_analytical(C, parm)
    Param, O2 = parm

    DO2 = Param.DO2[1]
    DCO2 = Param.DCO2[1]
    DCO3 = Param.DCO3[1]
    DHCO3 = Param.DHCO3[1]
    DH = Param.DH[1]
    DOH = Param.DOH[1]
    DH3BO3 = Param.DH3BO3[1]
    DH4BO4 = Param.DH4BO4[1]
    DH2S = Param.DH2S[1]
    DHS = Param.DHS[1]
    O20 = Param.O20
    CO20 = Param.CO20
    CO30 = Param.CO30
    HCO30 = Param.HCO30
    H0 = Param.H0
    OH0 = Param.OH0
    H3BO30 = Param.H3BO30
    H4BO40 = Param.H4BO40
    H2S0 = Param.H2S0
    HS0 = Param.HS0
    O2L = Param.O2L
    CO2L = Param.CO2L
    CO3L = Param.CO3L
    HCO3L = Param.HCO3L
    HL = Param.HL
    OHL = Param.OHL
    H3BO3L = Param.H3BO3L
    H4BO4L = Param.H4BO4L
    H2SL = Param.H2SL
    HSL = Param.HSL
    L = Param.L
    x = Param.x
    # a = Param.a
    # x0 = Param.x0
    # kOS = Param.kOS
    Ngrid = Param.Ngrid
    Kw = Param.KH2O
    KCO2 = Param.KCO2
    KHCO3 = Param.KHCO3
    KH2S = Param.KH2S
    KH3BO3 = Param.KH3BO3

    L1 = -0.05
    L2 = 0.15
    L = L2 - L1

    H = @view C[1:Ngrid]
    HCO3 = @view C[(Ngrid+1):2Ngrid]
    HS = @view C[(2Ngrid+1):3Ngrid]
    H3BO3 = @view C[(3Ngrid+1):4Ngrid]

    OH = zeros(eltype(C), Ngrid)
    CO2 = similar(OH)
    CO3 = similar(OH)
    H2S = similar(OH)
    H4BO4 = similar(OH)
    @.. OH = Kw / H
    @.. CO2 = H * HCO3 / KCO2
    @.. CO3 = KHCO3 * HCO3 / H
    @.. H2S = H * HS / KH2S
    @.. H4BO4 = KH3BO3 * H3BO3 / H


    res = similar(C)

    @.. res[1:Ngrid] =
        DCO2 * CO2 + DCO3 * CO3 + DHCO3 * HCO3 - DCO2 * CO20 - DCO3 * CO30 - DHCO3 * HCO30 +
        (L1 - x) / L *
        (DCO2 * (CO2L - CO20) + DCO3 * (CO3L - CO30) + DHCO3 * (HCO3L - HCO30))


    @.. res[(Ngrid+1):2Ngrid] =
        DH3BO3 * H3BO3 + DH4BO4 * H4BO4 - DH3BO3 * H3BO30 - DH4BO4 * H4BO40 +
        (L1 - x) / L * (DH3BO3 * (H3BO3L - H3BO30) + DH4BO4 * (H4BO4L - H4BO40))

    @.. res[(2Ngrid+1):3Ngrid] =
        2 * DH2S * H2S + 2 * DHS * HS - DO2 * O2 +
        DO2 * O20 +
        (L1 - x) / L * (2 * DH2S * H2SL + 2 * DHS * HSL + DO2 * O20)

    @.. res[(3Ngrid+1):4Ngrid] =
        (
            DH * H - DOH * OH - DHCO3 * HCO3 - 2 * DCO3 * CO3 - DH4BO4 * H4BO4 - DHS * HS +
            DO2 * O2
        ) - (
            DH * H0 - DOH * OH0 - DHCO3 * HCO30 - 2 * DCO3 * CO30 - DH4BO4 * H4BO40 -
            DHS * HS0 + DO2 * O20
        ) +
        (L1 - x) / L * (
            DH * (HL - H0) - DOH * (OHL - OH0) - DHCO3 * (HCO3L - HCO30) -
            2 * DCO3 * (CO3L - CO30) - DH4BO4 * (H4BO4L - H4BO40) - DHS * (HSL - HS0) +
            DO2 * (O2L - O20)
        )

    return res
end


function pHError(Param, modelconfig)

    # pm = PARM()
    C0 = repeat([Param.H0, Param.HCO30, Param.HS0, Param.H3BO30], inner = Param.Ngrid)

    O2 = O2_analytical(Param)

    # pH_analytical(C0, pm)


    probN = NonlinearProblem{false}(pH_analytical, C0, (Param, O2))
    solver = solve(probN, NewtonRaphson(), reltol = 1e-12, abstol = 1e-24)

    # res = pH_analytical(solver, pm)
    # maximum(abs.(res))


    Ngrid = Param.Ngrid
    H = solver[(1):Ngrid]
    HCO3 = solver[(Ngrid+1):2Ngrid]
    HS = solver[(2Ngrid+1):3Ngrid]
    H3BO3 = solver[(3Ngrid+1):4Ngrid]

    OH = Param.KH2O ./ H
    CO2 = H .* HCO3 ./ Param.KCO2
    CO3 = Param.KHCO3 .* HCO3 ./ H
    H2S = H .* HS ./ Param.KH2S
    H4BO4 = Param.KH3BO3 .* H3BO3 ./ H

    pH = -log10.(H)
    TCO2 = CO2 .+ CO3 .+ HCO3
    TH2S = H2S .+ HS
    TH3BO3 = H3BO3 .+ H4BO4
    x = Param.x


    analytical = DataFrame(
        depth = x,
        pH = pH,
        O2 = O2,
        TH2S = TH2S,
        TCO2 = TCO2,
        TH3BO3 = TH3BO3,
        pH_model = -log10.(solution.sol[end][Param.HID]),
        O2_model = solution.sol[end][Param.O2ID],
        TH2S_model = solution.sol[end][Param.TH2SID],
        TCO2_model = solution.sol[end][Param.TCO2ID],
        TH3BO3_model = solution.sol[end][Param.TH3BO3ID],
    )

    XLSX.writetable(
        joinpath(modelconfig.ModelDirectory ,
        modelconfig.ModelName*"_analytical.solution.xlsx"),
        overwrite = true,
        analytical = (
            collect(DataFrames.eachcol(analytical)),
            DataFrames.names(analytical),
        ),
    )

    return nothing
end





# pO2 = plot(O2 * 1e6, -x .+ 0.05, labels = "analytical");
# plot!(pO2, solution.sol[end][parm.O2ID] * 1e6, -x .+ 0.05, labels = "SedTrace")
# plot((O2 .- solution.sol[end][parm.O2ID]) * 1e6, -x .+ 0.05, labels = "error")

# ppH = plot(pH, -x .+ 0.05, labels = "analytical");
# plot!(ppH, -log10.(solution.sol[end][parm.HID]), -x .+ 0.05, labels = "SedTrace")
# plot(pH .+ log10.(solution.sol[end][parm.HID]), -x .+ 0.05, labels = "error")


# pTH2S = plot(TH2S * 1e6, -x .+ 0.05, labels = "analytical");
# plot!(pTH2S, solution.sol[end][parm.TH2SID] * 1e6, -x .+ 0.05, labels = "SedTrace")
# plot((TH2S - solution.sol[end][parm.TH2SID]) * 1e6, -x .+ 0.05)

# pTCO2 = plot(TCO2 * 1e3, -x .+ 0.05, labels = "analytical");
# plot!(pTCO2, solution.sol[end][parm.TCO2ID] * 1e3, -x .+ 0.05, labels = "SedTrace")

# pTH3BO3 = plot(TH3BO3 * 1e6, -x .+ 0.05, labels = "analytical");
# plot!(pTH3BO3, solution.sol[end][parm.TH3BO3ID] * 1e6, -x .+ 0.05, labels = "SedTrace")


