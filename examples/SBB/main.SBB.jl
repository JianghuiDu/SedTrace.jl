using MKL
using SedTrace
using JLD2

modeldirectory = (@__DIR__)*"\\"
modelfile = "model_config.SBB.xlsx"
modelname = "SBB"

modelconfig = ModelConfig(
    modeldirectory,
    modelfile,
    modelname,
)

ParamList = Dict(
    "rPC" => 0.015,
    "kCFA_pre" =>1.5e-8,
    "THFBW" => 75e-6,
    "TH3PO4BW" => 20e-6,
    "FMnO20" => 0.5e-2,
    "FFeOOH0" => 2.35e-2,
    # "kFeSH2S" => 1e2,
    "KFeOOH" =>	"450.0*ds_rho/1e3",
    # "kMoS4_pre" => 5e1,
    "pHL" => 8.0,
    "TCO2L" => 14e-3,
    "pHBW" => 7.6,
    "kMnO2Fe" =>1e6,
)

# @time generate_parameter_template(modelconfig)

@time generate_code(modelconfig,ParamDict=ParamList)

IncludeFiles(modelconfig)


chunk_size = 10;

C0 = SedTrace.Param.C0;
parm = SedTrace.Param.ParamStruct();
OdeFun = SedTrace.Cache.init(C0, SedTrace.Param.Ngrid, chunk_size);
JacPrototype = SedTrace.JacType(SedTrace.Param.IDdict,SedTrace.Param.Ngrid,SedTrace.Param.nspec)
solverconfig = SolverConfig(chunk_size, :GMRES)
solver = generate_ODESolver(OdeFun, JacPrototype, solverconfig,parm);
OdeFunction = generate_ODEFun(OdeFun, JacPrototype, solverconfig);
outputconfig = OutputConfig(SedTrace.Param.x, SedTrace.Param.L, SedTrace.Param.Ngrid, SedTrace.Param.IDdict);




# TestOdeFun(OdeFun,C0,parm)
# TestJacobian(JacPrototype,OdeFun,chunk_size,parm)
# BenchmarkReactran(OdeFun,C0,parm)
# BenchmarkJacobian(JacPrototype,OdeFun,chunk_size,parm)
# BenchmarkPreconditioner(JacPrototype,OdeFun,chunk_size,parm)



solverctrlconfig = SolverCtrlConfig(
    # C0,
    solution.sol[end],
    (0.0, 50000.0),
    reltol = 1e-6,
    abstol = 1e-18,
    saveat = 100.0,
    callback = TerminateSteadyState(1e-16, 1e-6, DiffEqCallbacks.allDerivPass),
);



@time solution = modelrun(OdeFunction, parm, solver, solverctrlconfig, outputconfig);

gr(; size = (400, 650))

generate_substance_plot(
    modelconfig,
    solution,
    ["SBB"],
    showplt = true,
)

jldsave(modeldirectory*"sol.$modelname.jld2"; sol = solution)




TCO2 = SedTrace.EquilibriumInvariant("TCO2")
THSO4 = SedTrace.EquilibriumInvariant("THSO4")
THF = SedTrace.EquilibriumInvariant("THF")
TH3PO4 = SedTrace.EquilibriumInvariant("TH3PO4")
TH2S = SedTrace.EquilibriumInvariant("TH2S")
TH3BO3 = SedTrace.EquilibriumInvariant("TH3BO3")
H = SedTrace.EquilibriumInvariant("H")

EIs = [TCO2,THSO4,THF,TH3PO4,TH2S,TH3BO3,H]
using DataFrames,Chain,DataFramesMeta,SymPy
parsing = @chain begin
    XLSX.readxlsx(modeldirectory*"model_parsing_diagnostics.SBB.xlsx")
    XLSX.gettable(_["species_in_model"])
    DataFrame
end

stoic = DataFrame(label = String[],species_eq=String[],stoichiometry=String[],reaction_type=String[],type=String[])
for i in EIs
    for j in eachindex(i.species)
        df = @subset(parsing,:species_eq.==i.species[j])
        @select!(df,:label,:species_eq,:stoichiometry,:reaction_type)
        df_TA = @transform(df,:stoichiometry = i.coef[j] .*"*(".* :stoichiometry .* ")" )
        append!(stoic,@transform(df_TA,:type="TA"))
        if i.name != "H"
            df_EI = @transform(df,:stoichiometry = "-(".* :stoichiometry .* ")" .* "*dTA_d$(i.name)" )
            append!(stoic,@transform(df_EI,:type=i.name))
        end
    end
end

@transform!(stoic,:stoichiometry = :stoichiometry .* ifelse.(:reaction_type .== "solid","*dstopw",""))
pH_rate = @chain begin
    groupby(stoic,:label)
    combine(:stoichiometry => x->join(x,"+"),renamecols=false)
    transform!(:stoichiometry => (x -> string.(SymPy.simplify.(SymPy.sympify.(x)))),renamecols=false)
end


XLSX.writetable(
    modeldirectory*"pH_rate.xlsx",
    overwrite = true,
    pH_rate = (
        collect(DataFrames.eachcol(pH_rate)),
        DataFrames.names(pH_rate),
    ),
)

