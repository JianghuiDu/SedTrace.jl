
using SedTrace
using JLD2

modeldirectory = (@__DIR__) * "\\"
modelfile = "model_config.pHBB1991.xlsx"
modelname = "pHBB1991"

modelconfig = ModelConfig(modeldirectory, modelfile, modelname)

# @time generate_parameter_template(modelconfig)

ParamDict = Dict(
    "kOS" => "78.",
    "a"=>1e4,
    "b" => 3.5,
    # "gridtran"=>"x-0.05",
    "Ngrid" => 100
)

@time generate_code(modelconfig, ParamDict = ParamDict)

IncludeFiles(modelconfig)


chunk_size = 10;


C0 = SedTrace.Param.C0;
parm = SedTrace.Param.ParamStruct();
OdeFun = SedTrace.Cache.init(C0, SedTrace.Param.Ngrid, chunk_size);
JacPrototype =
    SedTrace.JacType(SedTrace.Param.IDdict, SedTrace.Param.Ngrid, SedTrace.Param.nspec);
solverconfig = SolverConfig(chunk_size, :GMRES, :ILU0, 2)
solver = generate_ODESolver(OdeFun, JacPrototype, solverconfig, parm);
OdeFunction = generate_ODEFun(OdeFun, JacPrototype, solverconfig);
outputconfig = OutputConfig(
    SedTrace.Param.x,
    SedTrace.Param.L,
    SedTrace.Param.Ngrid,
    SedTrace.Param.IDdict,
);


# TestOdeFun(OdeFun,C0,parm)
# TestJacobian(JacPrototype,OdeFun,chunk_size,parm)
# BenchmarkReactran(OdeFun,C0,parm)
# BenchmarkJacobian(JacPrototype,OdeFun,chunk_size,parm)
# BenchmarkPreconditioner(JacPrototype,OdeFun,chunk_size,parm)



solverctrlconfig = SolverCtrlConfig(
    C0,
    # solution.sol[end],
    (0.0, 3000.0),
    reltol = 1e-6,
    abstol = 1e-18,
    saveat = 100.0,
    callback = TerminateSteadyState(1e-18, 1e-6, DiffEqCallbacks.allDerivPass),
);


@time solution = modelrun(OdeFunction, parm, solver, solverctrlconfig, outputconfig);

gr(; size = (400, 650))

generate_substance_plot(modelconfig, solution, ["JR"], showplt = true,ylim=(-0.1,0.2))


# compute the analytical solution

using Parameters, UnPack, NonlinearSolve,DataFrames

@with_kw mutable struct PARM
    DO2 = SedTrace.Param.DO2[1]
    DCO2 = SedTrace.Param.DCO2[1]
    DCO3 = SedTrace.Param.DCO3[1]
    DHCO3 = SedTrace.Param.DHCO3[1]
    DH = SedTrace.Param.DH[1]
    DOH = SedTrace.Param.DOH[1]
    DH3BO3 = SedTrace.Param.DH3BO3[1]
    DH4BO4 = SedTrace.Param.DH4BO4[1]
    DH2S = SedTrace.Param.DH2S[1]
    DHS = SedTrace.Param.DHS[1]
    O20 = SedTrace.Param.O20
    CO20 = SedTrace.Param.CO20
    CO30 = SedTrace.Param.CO30
    HCO30 = SedTrace.Param.HCO30
    H0 = SedTrace.Param.H0
    OH0 = SedTrace.Param.OH0
    H3BO30 = SedTrace.Param.H3BO30
    H4BO40 = SedTrace.Param.H4BO40
    H2S0 = SedTrace.Param.H2S0
    HS0 = SedTrace.Param.HS0
    O2L = SedTrace.Param.O2L
    CO2L = SedTrace.Param.CO2L
    CO3L = SedTrace.Param.CO3L
    HCO3L = SedTrace.Param.HCO3L
    HL = SedTrace.Param.HL
    OHL = SedTrace.Param.OHL
    H3BO3L = SedTrace.Param.H3BO3L
    H4BO4L = SedTrace.Param.H4BO4L
    H2SL = SedTrace.Param.H2SL
    HSL = SedTrace.Param.HSL
    L = SedTrace.Param.L
    x = SedTrace.Param.x
    a = parm.a
    x0 = parm.x0
    kOS = parm.kOS
    Ngrid = parm.Ngrid
    Kw = parm.KH2O
    KCO2 = parm.KCO2
    KHCO3 = parm.KHCO3
    KH2S = parm.KH2S
    KH3BO3 = parm.KH3BO3
    O2 = zeros(parm.Ngrid)
end


function pH_analytical(C, par)
    @unpack DO2,
    DCO2,
    DCO3,
    DHCO3,
    DH,
    DOH,
    DH3BO3,
    DH4BO4,
    DH2S,
    DHS,
    O20,
    CO20,
    CO30,
    HCO30,
    H0,
    OH0,
    H3BO30,
    H4BO40,
    H2S0,
    HS0,
    O2L,
    CO2L,
    CO3L,
    HCO3L,
    HL,
    OHL,
    H3BO3L,
    H4BO4L,
    H2SL,
    HSL,
    L,
    x,
    a,
    x0,
    kOS,
    Ngrid,
    Kw,
    KCO2,
    KHCO3,
    KH2S,
    KH3BO3,
    O2 = par
    L1 = -0.05
    L2 = 0.15
    L = L2-L1

    @.. O2 =
        1 / (a * DO2 * (L1-L2)) * (
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
                (L1 - L2 )* (x - x0) * erf(sqrt(a) * (x - x0)) +
                (L2 - x) * (L1 - x0) * erf(sqrt(a) * (L1 - x0))
            )
        )

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

    @pack! pm = O2#, OH, CO2, CO3, H2S, H4BO4

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

pm = PARM();
C0 = repeat([pm.H0, pm.HCO30, pm.HS0, pm.H3BO30], inner = pm.Ngrid);

# C0 = vcat(solution.sol[end][parm.HID],OdeFun.HCO3.du,OdeFun.HS.du,OdeFun.H3BO3.du)

# C0 = ones(pm.Ngrid*4)*1e-12;

pH_analytical(C0, pm)

probN = NonlinearProblem{false}(pH_analytical, C0, pm);
solver = solve(probN, NewtonRaphson(), reltol = 1e-12, abstol = 1e-24)

res = pH_analytical(solver, pm)
maximum(abs.(res))


Ngrid = parm.Ngrid;
H = solver[(1):Ngrid];
HCO3 = solver[(Ngrid+1):2Ngrid];
HS = solver[(2Ngrid+1):3Ngrid];
H3BO3 = solver[(3Ngrid+1):4Ngrid];

OH = pm.Kw / H;
CO2 = H .* HCO3 ./ pm.KCO2;
CO3 = pm.KHCO3 .* HCO3 ./ H;
H2S = H .* HS ./ pm.KH2S;
H4BO4 = pm.KH3BO3 .* H3BO3 ./ H;

pH = -log10.(H);
TCO2 = CO2 .+ CO3 .+ HCO3;
TH2S = H2S .+ HS;
TH3BO3 = H3BO3 .+ H4BO4;
O2 = pm.O2;
x = pm.x;

pO2 = plot(O2*1e6, -x .+ 0.05, labels = "analytical");
plot!(pO2, solution.sol[end][parm.O2ID]*1e6, -x .+ 0.05, labels = "SedTrace")
plot((O2 .- solution.sol[end][parm.O2ID])*1e6, -x .+ 0.05,labels = "error")

ppH = plot(pH, -x .+ 0.05, labels = "analytical");
plot!(ppH, -log10.(solution.sol[end][parm.HID]), -x .+ 0.05, labels = "SedTrace")
plot(pH.+log10.(solution.sol[end][parm.HID]), -x .+ 0.05,labels = "error")


pTH2S = plot(TH2S * 1e6, -x .+ 0.05, labels = "analytical");
plot!(pTH2S, solution.sol[end][parm.TH2SID] * 1e6, -x .+ 0.05, labels = "SedTrace")
plot((TH2S -  solution.sol[end][parm.TH2SID]) * 1e6, -x .+ 0.05)

pTCO2 = plot(TCO2 * 1e3, -x .+ 0.05, labels = "analytical");
plot!(pTCO2, solution.sol[end][parm.TCO2ID] * 1e3, -x .+ 0.05, labels = "SedTrace")

pTH3BO3 = plot(TH3BO3 * 1e6, -x .+ 0.05, labels = "analytical");
plot!(pTH3BO3, solution.sol[end][parm.TH3BO3ID] * 1e6, -x .+ 0.05, labels = "SedTrace")

analytical = DataFrame(
    depth = x, 
    pH = pH, 
    O2 = O2, 
    TH2S=TH2S, 
    TCO2=TCO2, 
    TH3BO3 = TH3BO3,
    pH_model = -log10.(solution.sol[end][parm.HID]),
    O2_model =solution.sol[end][parm.O2ID],
    TH2S_model = solution.sol[end][parm.TH2SID],
    TCO2_model = solution.sol[end][parm.TCO2ID],
    TH3BO3_model = solution.sol[end][parm.TH3BO3ID]
);

XLSX.writetable(
    modelconfig.ModelDirectory * "analytical.solution.nonuniform."* modelconfig.ModelName * ".xlsx",
    overwrite = true,
    analytical = (
        collect(DataFrames.eachcol(analytical)),
        DataFrames.names(analytical),
    )
)
