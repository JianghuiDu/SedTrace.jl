
using SedTrace
using JLD2

modeldirectory = (@__DIR__)*"\\"
modelfile = "model_config.SimpleFe.xlsx"
modelname = "SimpleFe"

modelconfig = ModelConfig(
    modeldirectory,
    modelfile,
    modelname,
)

# @time generate_parameter_template(modelconfig)

@time generate_code(modelconfig)

IncludeFiles(modelconfig)


chunk_size = 10;


C0 = SedTrace.Param.C0;
parm = SedTrace.Param.ParamStruct();
OdeFun = SedTrace.Cache.init(C0, SedTrace.Param.Ngrid, chunk_size);
JacPrototype = SedTrace.JacType(SedTrace.Param.IDdict,SedTrace.Param.Ngrid,SedTrace.Param.nspec);
solverconfig = SolverConfig(chunk_size, :GMRES,:ILU0,2)
solver = generate_ODESolver(OdeFun, JacPrototype, solverconfig,parm);
OdeFunction = generate_ODEFun(OdeFun, JacPrototype, solverconfig);
outputconfig = OutputConfig(SedTrace.Param.x, SedTrace.Param.L, SedTrace.Param.Ngrid, SedTrace.Param.IDdict);


TestOdeFun(OdeFun,C0,parm)
TestJacobian(JacPrototype,OdeFun,chunk_size,parm)
BenchmarkReactran(OdeFun,C0,parm)
BenchmarkJacobian(JacPrototype,OdeFun,chunk_size,parm)
BenchmarkPreconditioner(JacPrototype,OdeFun,chunk_size,parm)


solverctrlconfig = SolverCtrlConfig(
    C0,
    # solution.sol[end],
    (0.0, 3000.0),
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
    [""],
    showplt = true,
)



eq = "(CH2O)(NH3)[rNC](H3PO4)[rPC]+4*FeOOH+(8+rNC-rPC)*H{+}=CO2+rNC*NH4{+}+rPC*H2PO4{-}+4*Fe{2+}+7*H2O"
eq = "1/2*O2+NO2{-}=NO3{-}"


equation_ind = parse_equation(eq)

element_ind = check_react_balance("RFeOOHPOC", equation_ind)

julia> equation_ind = parse_equation(eq)
8×4 DataFrame
 Row │ species                       stoichiometry  charge  role     
     │ String                        String         String  String   
─────┼───────────────────────────────────────────────────────────────
   1 │ (CH2O)(NH3)[rNC](H3PO4)[rPC]  -1             0       reactant
   2 │ FeOOH                         -4             0       reactant
   3 │ H                             -(8+rNC-rPC)   +1      reactant
   4 │ CO2                           1              0       product
   5 │ NH4                           rNC            +1      product
   6 │ H2PO4                         rPC            -1      product
   7 │ Fe                            4              +2      product
   8 │ H2O                           7              0       product

julia> 

julia> element_ind = check_react_balance("RFeOOHPOC", equation_ind)
23×2 DataFrame
 Row │ element  coef             
     │ String   String           
─────┼───────────────────────────
   1 │ C        -1
   2 │ H        -2
   3 │ O        -1
   4 │ N        (-rNC)
   5 │ H        (-3*rNC)
   6 │ H        (-3*rPC)
   7 │ P        (-rPC)
   8 │ O        (-4*rPC)
   9 │ Fe       -4
  10 │ O        -4
  11 │ O        -4
  12 │ H        -4
  13 │ H        (-rNC + rPC - 8)
  14 │ C        1
  15 │ O        2
  16 │ N        (rNC)
  17 │ H        (4*rNC)
  18 │ H        (2*rPC)
  19 │ P        (rPC)
  20 │ O        (4*rPC)
  21 │ Fe       4
  22 │ H        14
  23 │ O        7


4×3 DataFrame
 Row │ substance  label   Eq                                       
     │ String     String  SymPy.Sym                                
─────┼─────────────────────────────────────────────────────────────
   1 │ Fe         FeCl     -0.7585775750291838 + FeCl/(Cl*Fe_free)
   2 │ Fe         FeSO4    FeSO4/(Fe_free*SO4) - 9.120108393559097
   3 │ Fe         FeCO3   -4466.835921509631 + FeCO3/(CO3*Fe_free)
   4 │ Fe         FeHS       FeHS/(Fe_free*HS) - 251188.6431509582

   Fe/(4466.83592150963*CO3 + 0.758577575029184*Cl + 251188.643150958*HS + 9.1201083935591*SO4 + 1)

julia> JacPrototype = SedTrace.JacType()
27×27 SparseMatrixCSC{Float64, Int64} with 215 stored entries:
⣽⢏⠗⡁⡍⠣⡀⠀⠀⠀⠀⠀⠀⠀
⢽⡦⣷⣤⠇⠀⠈⢢⡤⠀⠀⠀⠀⠀
⠻⡉⠉⠁⢑⣶⢲⠜⢘⠲⡀⠀⠀⠀
⠀⠈⠢⣀⣘⣧⣱⣌⣸⠀⠈⠢⣀⡀
⠀⠀⠀⠋⠲⡟⠚⠛⠑⢤⡤⣄⠏⠆
⠀⠀⠀⠀⠀⠈⠢⡀⠀⢿⡑⣅⠂⡇
⠀⠀⠀⠀⠀⠀⠀⠸⠫⠽⠯⠿⠟⠅

9×2 DataFrame
 Row │ substance  dependence                      
     │ String     String                          
─────┼────────────────────────────────────────────
   1 │ H          FeOOH,O2,POC,SO4,TFe,TH2S,H,FeS
   2 │ POC        O2,POC,FeOOH,SO4
   3 │ O2         O2,POC,TFe,TH2S
   4 │ TCO2       O2,POC,FeOOH,SO4
   5 │ FeOOH      FeOOH,O2,POC,TFe,TH2S
   6 │ TFe        FeOOH,O2,POC,TFe,TH2S,H,FeS
   7 │ SO4        SO4,FeOOH,O2,POC,TH2S
   8 │ TH2S       SO4,FeOOH,O2,POC,TH2S,H,TFe,FeS
   9 │ FeS        TH2S,H,TFe,POC,FeS



mutable struct rt2{T}
    Fe::PreallocationTools.DiffCache{
        Array{T,1},
        Array{T,1},
    }
end

function init2(
    u0::Array{T,1},
    Ngrid::Int,
    chunk_size::Int,
) where {T}
    Fe = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    cache = rt2(
        Fe,
        )
        return cache
end
    
init2(zeros(5),9,10)

x = PreallocationTools.adapt(ArrayInterfaceCore.parameterless_type(zeros(10)),
zeros(Float64, prod(10 .+ 1) * prod(9)))



a = ["# ooo","aa"]

filter!(x-> !occursin(r"^#",x),a)