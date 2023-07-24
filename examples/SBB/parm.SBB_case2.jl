
#----------------------------------------------
# Number of substances
#----------------------------------------------
nsolid = 14 #  # number of solid substances
ndissolved = 11 #  # number of dissolved substances
nsummed = 7 #  # number of summed substances
nspec = 32 #  # number of total substances

#----------------------------------------------
# global parameters
#----------------------------------------------
depth = 500.0 # m # water depth
salinity = 35.0 # psu # bottom water salinity
temp = 5.0 # Celsius # bottom water temperature
ds_rho = 2.6 # g cm^-3 # dry sediment density
O2BW = 8.5e-6 # mmol/cm3 # bottom water oxygen
sw_dens = 1.0287324258804407 # g cm^-3 # seawater density

#----------------------------------------------
# grid parameters
#----------------------------------------------
L = 50.0 # cm # model sediment section thickness
Ngrid = 500 # integer # number of model grid
pgrid = L / 5 # cm # constant in gridtran, attenuation scale
Nmat = 16000 # integer # Jacobian dimension
ξ = range(0, step = L / (Ngrid), length = Ngrid + 1) # cm # uniform grid
xᵥ = broadcast(x -> L * (exp(x * pgrid / L) - 1) / (exp(pgrid) - 1), ξ) # cm # non-uniform grid transformation
x = (xᵥ[2:(Ngrid+1)] .+ xᵥ[1:Ngrid]) / 2 # cm # cell center
dx = xᵥ[2:(Ngrid+1)] .- xᵥ[1:Ngrid] # cm # cell volume

#----------------------------------------------
# porosity parameters
#----------------------------------------------
phi0 = 0.9472 # dimentionless # surface porosity
phiL = 0.7884 # dimentionless # bottom porosity
xphi = 107.3 # cm # porosity attenuation scale
phi_Inf = 0.7884 # dimentionless # porosity at infinite sediment depth (normally where porosity stops changing). Needed to calculate burial velocities. If constant_porosity_profile = yes, then phi_Inf should be the same as the porosity constant. If constant_porosity_profile = no, then phi_Inf should be consistent with the depth dependent porosity function
phif = broadcast(x -> phiL + (phi0 - phiL) * exp(-x / xphi), x) # dimensionless # fluid volume fraction
phis = 1.0 .- phif # dimensionless # solid volume fraction
pwtods = phif ./ phis # dimensionless # conversion from pore water to solid sediment volume unit
dstopw = phis ./ phif # dimensionless # conversion from solid sediment to pore water volume unit

#----------------------------------------------
# phase velocity parameters
#----------------------------------------------
Fsed = 0.073 # g cm^-2 yr^-1 # total sediment flux
w_Inf = Fsed / ds_rho / (1 - phi_Inf) # cm yr^-1 # solid sediment burial velocity at infinite depth
uf = phi_Inf * w_Inf ./ phif # cm yr^-1 # pore water burial velocity
us = Fsed / ds_rho ./ phis # cm yr^-1 # solid sediment burial velocity

#----------------------------------------------
# bioturbation parameters
#----------------------------------------------
Dbt0 = 5.2 * 10^(0.76241122 - 0.00039724 * depth) # cm/yr^3 # bioturbation coefficient
aO2bt = 1.0e-5 # mmol/cm3 # constant used in calculating oxygen dependence of bioturbation
bO2bt = 5.0e-7 # mmol/cm3 # constant used in calculating oxygen dependence of bioturbation
fO2bt = 0.5 + 0.5 * erf((O2BW - aO2bt) / bO2bt) # missing # oxygen dependence of bioturbation
xbt = 3.0 # cm # attentuation scale of bioturbation
Ds = broadcast(x -> Dbt0 * fO2bt * exp(-x / xbt) + 1e-8, x) # cm^2 yr^-1 # Bioturbation coefficient

#----------------------------------------------
# bioirrigation parameters
#----------------------------------------------
Dbir0 = 465.0 # yr^-1 # bioirrigation constant
aO2bir = 1.0e-5 # mmol/cm3 # constant used in calculating oxygen dependence of bioirrigation
bO2bir = 5.0e-7 # mmol/cm3 # constant used in calculating oxygen dependence of bioirrigation
fO2bir = 0.5 + 0.5 * erf((O2BW - aO2bir) / bO2bir) # missing # oxygen dependence of irrigation
xbir = 2.0 # cm # attentuation scale of bioirrigation
alpha = broadcast(x -> Dbir0 * fO2bir * exp(-x / xbir), x) # yr^-1 # Bioirrigation coefficient

#----------------------------------------------
# speciation parameters
#----------------------------------------------
KNH4_ads = 1.6 * ds_rho # cm^3(porewater) cm^-3(dry sediment) # Adsorption constant
KMn_ads = 28.0 * ds_rho # cm^3(porewater) cm^-3(dry sediment) # Adsorption constant
KFe_ads = 268.0 * ds_rho # cm^3(porewater) cm^-3(dry sediment) # Adsorption constant
Cl = 0.565772678 # mmol cm-3 # seawater Cl

#----------------------------------------------
# solute diffusivity
#----------------------------------------------
DO2 = 4.3137518591580283E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DNO3 = 3.4158080786693472E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DCH4 = 2.7551413265968421E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DNO2 = 3.5695791591339196E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DCa = 1.3421378770645731E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DH4SiO4 = 1.7771486449162396E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DTMn_dis = 1.1809021810434676E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DTFe_dis = 1.2122535663809046E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DTNH4_dis = 3.4531311564520092E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DMol_dis = 1.6349371584775281E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DMoh_dis = 1.6349371584775281E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DH3PO4 = 1.4353131461911693E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DH2PO4 = 1.5332320353118095E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DHPO4 = 1.2376332592731156E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DPO4 = 9.9577971524145752E+01 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DHSO4 = 2.2468492825163321E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DSO4 = 1.8034511184582917E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DH = 1.8564498889096735E+03 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DOH = 9.3665996003371845E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DHCO3 = 1.9213920442515075E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DCO3 = 1.5899631135414575E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DCO2 = 3.4007363037153704E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DH2S = 3.4645489735648920E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DHS = 3.5128480809042725E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DH3BO3 = 1.9632444183534389E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DH4BO4 = 1.7178388660592589E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DHF = 2.7716391788519138E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DF = 2.3901699012017593E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient

#----------------------------------------------
# solute mass transfer velocities
#----------------------------------------------
delta = 0.05 # cm # thickness of the diffusive boundary layer
betaO2 = 8.6275037183160566E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaNO3 = 6.8316161573386944E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaCH4 = 5.5102826531936835E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaNO2 = 7.1391583182678387E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaCa = 2.6842757541291462E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaH4SiO4 = 3.5542972898324788E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaH3PO4 = 2.8706262923823383E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaH2PO4 = 3.0664640706236187E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaHPO4 = 2.4752665185462311E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaPO4 = 1.9915594304829149E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaHSO4 = 4.4936985650326642E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaSO4 = 3.6069022369165832E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaH = 3.7128997778193465E+04 # cm yr^-1 # solute mass transfer velocity across SWI
betaOH = 1.8733199200674368E+04 # cm yr^-1 # solute mass transfer velocity across SWI
betaHCO3 = 3.8427840885030150E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaCO3 = 3.1799262270829149E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaCO2 = 6.8014726074307400E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaH2S = 6.9290979471297833E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaHS = 7.0256961618085443E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaH3BO3 = 3.9264888367068775E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaH4BO4 = 3.4356777321185177E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaHF = 5.5432783577038272E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaF = 4.7803398024035187E+03 # cm yr^-1 # solute mass transfer velocity across SWI

#----------------------------------------------
# boundary fluxes and concentrations
#----------------------------------------------
FPOC0 = 0.31 # mmol cm^-2 yr^-1 # Flux of POC at the  TOP of sediment column
FMnO20 = 0.005 # mmol cm^-2 yr^-1 # Flux of MnO2 at the  TOP of sediment column
FFeOOH0 = 0.0242 # mmol cm^-2 yr^-1 # Flux of FeOOH at the  TOP of sediment column
FFeS0 = 2.22044604925031e-16 # mmol cm^-2 yr^-1 # Flux of FeS at the  TOP of sediment column
FFeS20 = 0.002 # mmol cm^-2 yr^-1 # Flux of FeS2 at the  TOP of sediment column
FCaCO30 = 0.055 # mmol cm^-2 yr^-1 # Flux of CaCO3 at the  TOP of sediment column
FMnCO30 = 2.22044604925031e-16 # mmol cm^-2 yr^-1 # Flux of MnCO3 at the  TOP of sediment column
FFeCO30 = 2.22044604925031e-16 # mmol cm^-2 yr^-1 # Flux of FeCO3 at the  TOP of sediment column
FAge0 = 0.0 # mmol cm^-2 yr^-1 # Flux of Age at the  TOP of sediment column
FBSi0 = 0.2 # mmol cm^-2 yr^-1 # Flux of BSi at the  TOP of sediment column
FSMol0 = 3.9471113493259475e-16 # mmol cm^-2 yr^-1 # Flux of MoS4 at the  TOP of sediment column
FSMoh0 = 6.052888650674053e-16 # mmol cm^-2 yr^-1 # Flux of MoS4 at the  TOP of sediment column
FLMol0 = 6.323169656828719e-7 # mmol cm^-2 yr^-1 # Flux of MoS4 at the  TOP of sediment column
FLMoh0 = 9.67683034317128e-7 # mmol cm^-2 yr^-1 # Flux of MoS4 at the  TOP of sediment column
O2BW = 8.5e-6 # mmol cm^-3 # Bottom water concentration of O2
NO3BW = 2.8e-5 # mmol cm^-3 # Bottom water concentration of NO3
TMn_dis0 = 6.0e-7 # mmol cm^-3 # Concentration of Mn at the TOP of sediment column
TMn_ads0 = TMn_dis0 * KMn_ads # missing # missing
TFe_dis0 = 2.95e-8 # mmol cm^-3 # Concentration of Fe at the TOP of sediment column
TFe_ads0 = TFe_dis0 * KFe_ads # missing # missing
CH4BW = 2.22044604925031e-16 # mmol cm^-3 # Bottom water concentration of CH4
NO2BW = 2.0e-7 # mmol cm^-3 # Bottom water concentration of NO2
CaBW = 0.01033 # mmol cm^-3 # Bottom water concentration of Ca
Mol_dis0 = 4.736533619191137e-8 # mmol cm^-3 # missing
Moh_dis0 = 7.263466380808862e-8 # mmol cm^-3 # missing
TNH4_dis0 = 1.0e-6 # mmol cm^-3 # Concentration of NH4 at the TOP of sediment column
TNH4_ads0 = TNH4_dis0 * KNH4_ads # missing # missing
TH3PO4BW = 2.0e-5 # mmol cm^-3 # Bottom water concentration of H3PO4
THSO4BW = 0.028 # mmol cm^-3 # Bottom water concentration of SO4
H4SiO4BW = 0.00022 # mmol cm^-3 # Bottom water concentration of H4SiO4
pHBW = 7.6 # free pH scale # Bottom water pH
TCO2BW = 0.002345 # mmol cm^-3 # Bottom water concentration of TCO2
TH2SBW = 2.22044604925031e-16 # mmol cm^-3 # Bottom water concentration of TH2S
TH3BO3BW = 8.7062e-5 # mmol cm^-3 # Bottom water concentration of TH3BO3
THFBW = 7.5e-5 # mmol cm^-3 # missing
CH4L = 9.0e-5 # mmol cm^-3 # Concentration of CH4 at the BOTTOM of sediment column
CaL = 0.008 # mmol cm^-3 # Concentration of Ca at the BOTTOM of sediment column
TNH4_disL = 0.0013 # mmol cm^-3 # Concentration of NH4 at the BOTTOM of sediment column
THSO4L = 0.015 # mmol cm^-3 # Concentration of SO4 at the BOTTOM of sediment column
H4SiO4L = 0.0005 # mmol cm^-3 # Concentration of H4SiO4 at the BOTTOM of sediment column
pHL = 8.0 # free pH scale # pH at the BOTTOM of sediment column
TCO2L = 0.014 # mmol cm^-3 # Concentration of TCO2 at the BOTTOM of sediment column
TH2SL = 0.002 # mmol cm^-3 # Concentration of TH2S at the BOTTOM of sediment column
THFL = 4.5e-5 # mmol cm^-3 # missing
H4SiO4L = 0.0005 # mmol cm^-3 # missing
TNH4_adsL = TNH4_disL * KNH4_ads # mmol cm^-3 # missing
H3PO4BW = 7.7125245616994541E-13 # mmol cm^-3 # Bottom water concentration of H3PO4
H2PO4BW = 7.0274724396482137E-07 # mmol cm^-3 # Bottom water concentration of H2PO4
HPO4BW = 1.8912234158734785E-05 # mmol cm^-3 # Bottom water concentration of HPO4
PO4BW = 3.8501782604793766E-07 # mmol cm^-3 # Bottom water concentration of PO4
HSO4BW = 2.9906410628676500E-09 # mmol cm^-3 # Bottom water concentration of HSO4
SO4BW = 2.7999997009358939E-02 # mmol cm^-3 # Bottom water concentration of SO4
HSO4L = 6.3781914011762712E-10 # mmol cm^-3 # Concentration of HSO4 at the BOTTOM of sediment column
SO4L = 1.4999999362180860E-02 # mmol cm^-3 # Concentration of SO4 at the BOTTOM of sediment column
HBW = 2.5118864315095821E-08 # mmol cm^-3 # Bottom water concentration of H
OHBW = 3.1627973940830114E-07 # mmol cm^-3 # Bottom water concentration of OH
HCO3BW = 2.2366048207248497E-03 # mmol cm^-3 # Bottom water concentration of HCO3
CO3BW = 4.1272349938195189E-05 # mmol cm^-3 # Bottom water concentration of CO3
CO2BW = 6.7122829336954890E-05 # mmol cm^-3 # Bottom water concentration of CO2
HCO3L = 1.3228766048001694E-02 # mmol cm^-3 # Concentration of HCO3 at the BOTTOM of sediment column
CO3L = 6.1318182899757824E-04 # mmol cm^-3 # Concentration of CO3 at the BOTTOM of sediment column
CO2L = 1.5805212300072728E-04 # mmol cm^-3 # Concentration of CO2 at the BOTTOM of sediment column
H2SBW = 3.6317801781327759E-17 # mmol cm^-3 # Bottom water concentration of H2S
HSBW = 1.8572680314370327E-16 # mmol cm^-3 # Bottom water concentration of HS
H2SL = 1.4445002647319870E-04 # mmol cm^-3 # Concentration of H2S at the BOTTOM of sediment column
HSL = 1.8555499735268012E-03 # mmol cm^-3 # Concentration of HS at the BOTTOM of sediment column
H3BO3BW = 8.2590466448602583E-05 # mmol cm^-3 # Bottom water concentration of H3BO3
H4BO4BW = 4.4715335513974081E-06 # mmol cm^-3 # Bottom water concentration of H4BO4
HFBW = 5.3139626566369535E-10 # mmol cm^-3 # Bottom water concentration of HF
FBW = 7.4999468603734339E-05 # mmol cm^-3 # Bottom water concentration of F
HFL = 1.2693213957207712E-10 # mmol cm^-3 # Concentration of HF at the BOTTOM of sediment column
FL = 4.4999873067860426E-05 # mmol cm^-3 # Concentration of F at the BOTTOM of sediment column

#----------------------------------------------
# assemble boundary conditions
#----------------------------------------------
BcPOC = ((phis[1]us[1], -phis[1]Ds[1], FPOC0), (0.0, 1.0, 0.0)) #  # Boundary condition of POC
BcMnO2 = ((phis[1]us[1], -phis[1]Ds[1], FMnO20), (0.0, 1.0, 0.0)) #  # Boundary condition of MnO2
BcFeOOH = ((phis[1]us[1], -phis[1]Ds[1], FFeOOH0), (0.0, 1.0, 0.0)) #  # Boundary condition of FeOOH
BcFeS = ((phis[1]us[1], -phis[1]Ds[1], FFeS0), (0.0, 1.0, 0.0)) #  # Boundary condition of FeS
BcFeS2 = ((phis[1]us[1], -phis[1]Ds[1], FFeS20), (0.0, 1.0, 0.0)) #  # Boundary condition of FeS2
BcCaCO3 = ((phis[1]us[1], -phis[1]Ds[1], FCaCO30), (0.0, 1.0, 0.0)) #  # Boundary condition of CaCO3
BcMnCO3 = ((phis[1]us[1], -phis[1]Ds[1], FMnCO30), (0.0, 1.0, 0.0)) #  # Boundary condition of MnCO3
BcFeCO3 = ((phis[1]us[1], -phis[1]Ds[1], FFeCO30), (0.0, 1.0, 0.0)) #  # Boundary condition of FeCO3
BcAge = ((phis[1]us[1], -phis[1]Ds[1], FAge0), (0.0, 1.0, 1.0 / us[Ngrid])) #  # Boundary condition of Age
BcBSi = ((phis[1]us[1], -phis[1]Ds[1], FBSi0), (0.0, 1.0, 0.0)) #  # Boundary condition of BSi
BcSMol = ((phis[1]us[1], -phis[1]Ds[1], FSMol0), (0.0, 1.0, 0.0)) #  # Boundary condition of SMol
BcSMoh = ((phis[1]us[1], -phis[1]Ds[1], FSMoh0), (0.0, 1.0, 0.0)) #  # Boundary condition of SMoh
BcLMol = ((phis[1]us[1], -phis[1]Ds[1], FLMol0), (0.0, 1.0, 0.0)) #  # Boundary condition of LMol
BcLMoh = ((phis[1]us[1], -phis[1]Ds[1], FLMoh0), (0.0, 1.0, 0.0)) #  # Boundary condition of LMoh
BcO2 = ((betaO2 + phif[1]uf[1], -phif[1]DO2[1], betaO2 * O2BW), (0.0, 1.0, 0.0)) #  # Boundary condition of O2
BcNO3 = (
    (betaNO3 + phif[1]uf[1], -phif[1]DNO3[1], betaNO3 * NO3BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of NO3
BcCH4 = (
    (betaCH4 + phif[1]uf[1], -phif[1]DCH4[1], betaCH4 * CH4BW),
    (1.0, 0.0, CH4L),
) #  # Boundary condition of CH4
BcNO2 = (
    (betaNO2 + phif[1]uf[1], -phif[1]DNO2[1], betaNO2 * NO2BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of NO2
BcCa = ((betaCa + phif[1]uf[1], -phif[1]DCa[1], betaCa * CaBW), (1.0, 0.0, CaL)) #  # Boundary condition of Ca
BcH4SiO4 = (
    (betaH4SiO4 + phif[1]uf[1], -phif[1]DH4SiO4[1], betaH4SiO4 * H4SiO4BW),
    (1.0, 0.0, H4SiO4L),
) #  # Boundary condition of H4SiO4
BcTMn_dis = ((1.0, 0.0, TMn_dis0), (0.0, 1.0, 0.0)) #  # Boundary condition of TMn_dis
BcTFe_dis = ((1.0, 0.0, TFe_dis0), (0.0, 1.0, 0.0)) #  # Boundary condition of TFe_dis
BcTNH4_dis = ((1.0, 0.0, TNH4_dis0), (1.0, 0.0, TNH4_disL)) #  # Boundary condition of TNH4_dis
BcMol_dis = ((1.0, 0.0, Mol_dis0), (0.0, 1.0, 0.0)) #  # Boundary condition of Mol_dis
BcMoh_dis = ((1.0, 0.0, Moh_dis0), (0.0, 1.0, 0.0)) #  # Boundary condition of Moh_dis
BcH3PO4 = (
    (betaH3PO4 + phif[1]uf[1], -phif[1]DH3PO4[1], betaH3PO4 * H3PO4BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of TH3PO4
BcH2PO4 = (
    (betaH2PO4 + phif[1]uf[1], -phif[1]DH2PO4[1], betaH2PO4 * H2PO4BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of TH3PO4
BcHPO4 = (
    (betaHPO4 + phif[1]uf[1], -phif[1]DHPO4[1], betaHPO4 * HPO4BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of TH3PO4
BcPO4 = (
    (betaPO4 + phif[1]uf[1], -phif[1]DPO4[1], betaPO4 * PO4BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of TH3PO4
BcHSO4 = (
    (betaHSO4 + phif[1]uf[1], -phif[1]DHSO4[1], betaHSO4 * HSO4BW),
    (1.0, 0.0, HSO4L),
) #  # Boundary condition of THSO4
BcSO4 = (
    (betaSO4 + phif[1]uf[1], -phif[1]DSO4[1], betaSO4 * SO4BW),
    (1.0, 0.0, SO4L),
) #  # Boundary condition of THSO4
BcH = ((betaH + phif[1]uf[1], -phif[1]DH[1], betaH * HBW), (0.0, 1.0, 0.0)) #  # Boundary condition of H
BcOH = ((betaOH + phif[1]uf[1], -phif[1]DOH[1], betaOH * OHBW), (0.0, 1.0, 0.0)) #  # Boundary condition of H
BcHCO3 = (
    (betaHCO3 + phif[1]uf[1], -phif[1]DHCO3[1], betaHCO3 * HCO3BW),
    (1.0, 0.0, HCO3L),
) #  # Boundary condition of TCO2
BcCO3 = (
    (betaCO3 + phif[1]uf[1], -phif[1]DCO3[1], betaCO3 * CO3BW),
    (1.0, 0.0, CO3L),
) #  # Boundary condition of TCO2
BcCO2 = (
    (betaCO2 + phif[1]uf[1], -phif[1]DCO2[1], betaCO2 * CO2BW),
    (1.0, 0.0, CO2L),
) #  # Boundary condition of TCO2
BcH2S = (
    (betaH2S + phif[1]uf[1], -phif[1]DH2S[1], betaH2S * H2SBW),
    (1.0, 0.0, H2SL),
) #  # Boundary condition of TH2S
BcHS = ((betaHS + phif[1]uf[1], -phif[1]DHS[1], betaHS * HSBW), (1.0, 0.0, HSL)) #  # Boundary condition of TH2S
BcH3BO3 = (
    (betaH3BO3 + phif[1]uf[1], -phif[1]DH3BO3[1], betaH3BO3 * H3BO3BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of TH3BO3
BcH4BO4 = (
    (betaH4BO4 + phif[1]uf[1], -phif[1]DH4BO4[1], betaH4BO4 * H4BO4BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of TH3BO3
BcHF = ((betaHF + phif[1]uf[1], -phif[1]DHF[1], betaHF * HFBW), (1.0, 0.0, HFL)) #  # Boundary condition of THF
BcF = ((betaF + phif[1]uf[1], -phif[1]DF[1], betaF * FBW), (1.0, 0.0, FL)) #  # Boundary condition of THF
BcTFe_ads = ((1.0, 0.0, TFe_ads0), (0.0, 1.0, 0.0)) #  # Boundary condition of TFe_ads
BcTMn_ads = ((1.0, 0.0, TMn_ads0), (0.0, 1.0, 0.0)) #  # Boundary condition of TMn_ads
BcTNH4_ads = ((1.0, 0.0, TNH4_ads0), (1.0, 0.0, TNH4_adsL)) #  # Boundary condition of TNH4_ads

#----------------------------------------------
# Boundary transport matrix
#----------------------------------------------
BcAmPOC, BcCmPOC = fvcf_bc(phis, Ds, us, dx, BcPOC, Ngrid) #  # Boundary transport matrix of POC
BcAmMnO2, BcCmMnO2 = fvcf_bc(phis, Ds, us, dx, BcMnO2, Ngrid) #  # Boundary transport matrix of MnO2
BcAmFeOOH, BcCmFeOOH = fvcf_bc(phis, Ds, us, dx, BcFeOOH, Ngrid) #  # Boundary transport matrix of FeOOH
BcAmFeS, BcCmFeS = fvcf_bc(phis, Ds, us, dx, BcFeS, Ngrid) #  # Boundary transport matrix of FeS
BcAmFeS2, BcCmFeS2 = fvcf_bc(phis, Ds, us, dx, BcFeS2, Ngrid) #  # Boundary transport matrix of FeS2
BcAmCaCO3, BcCmCaCO3 = fvcf_bc(phis, Ds, us, dx, BcCaCO3, Ngrid) #  # Boundary transport matrix of CaCO3
BcAmMnCO3, BcCmMnCO3 = fvcf_bc(phis, Ds, us, dx, BcMnCO3, Ngrid) #  # Boundary transport matrix of MnCO3
BcAmFeCO3, BcCmFeCO3 = fvcf_bc(phis, Ds, us, dx, BcFeCO3, Ngrid) #  # Boundary transport matrix of FeCO3
BcAmAge, BcCmAge = fvcf_bc(phis, Ds, us, dx, BcAge, Ngrid) #  # Boundary transport matrix of Age
BcAmBSi, BcCmBSi = fvcf_bc(phis, Ds, us, dx, BcBSi, Ngrid) #  # Boundary transport matrix of BSi
BcAmSMol, BcCmSMol = fvcf_bc(phis, Ds, us, dx, BcSMol, Ngrid) #  # Boundary transport matrix of SMol
BcAmSMoh, BcCmSMoh = fvcf_bc(phis, Ds, us, dx, BcSMoh, Ngrid) #  # Boundary transport matrix of SMoh
BcAmLMol, BcCmLMol = fvcf_bc(phis, Ds, us, dx, BcLMol, Ngrid) #  # Boundary transport matrix of LMol
BcAmLMoh, BcCmLMoh = fvcf_bc(phis, Ds, us, dx, BcLMoh, Ngrid) #  # Boundary transport matrix of LMoh
BcAmO2, BcCmO2 = fvcf_bc(phif, DO2, uf, dx, BcO2, Ngrid) #  # Boundary transport matrix of O2
BcAmNO3, BcCmNO3 = fvcf_bc(phif, DNO3, uf, dx, BcNO3, Ngrid) #  # Boundary transport matrix of NO3
BcAmCH4, BcCmCH4 = fvcf_bc(phif, DCH4, uf, dx, BcCH4, Ngrid) #  # Boundary transport matrix of CH4
BcAmNO2, BcCmNO2 = fvcf_bc(phif, DNO2, uf, dx, BcNO2, Ngrid) #  # Boundary transport matrix of NO2
BcAmCa, BcCmCa = fvcf_bc(phif, DCa, uf, dx, BcCa, Ngrid) #  # Boundary transport matrix of Ca
BcAmH4SiO4, BcCmH4SiO4 = fvcf_bc(phif, DH4SiO4, uf, dx, BcH4SiO4, Ngrid) #  # Boundary transport matrix of H4SiO4
BcAmTMn_dis, BcCmTMn_dis = fvcf_bc(phif, DTMn_dis, uf, dx, BcTMn_dis, Ngrid) #  # Boundary transport matrix of TMn_dis
BcAmTFe_dis, BcCmTFe_dis = fvcf_bc(phif, DTFe_dis, uf, dx, BcTFe_dis, Ngrid) #  # Boundary transport matrix of TFe_dis
BcAmTNH4_dis, BcCmTNH4_dis = fvcf_bc(phif, DTNH4_dis, uf, dx, BcTNH4_dis, Ngrid) #  # Boundary transport matrix of TNH4_dis
BcAmMol_dis, BcCmMol_dis = fvcf_bc(phif, DMol_dis, uf, dx, BcMol_dis, Ngrid) #  # Boundary transport matrix of Mol_dis
BcAmMoh_dis, BcCmMoh_dis = fvcf_bc(phif, DMoh_dis, uf, dx, BcMoh_dis, Ngrid) #  # Boundary transport matrix of Moh_dis
BcAmH3PO4, BcCmH3PO4 = fvcf_bc(phif, DH3PO4, uf, dx, BcH3PO4, Ngrid) #  # Boundary transport matrix of H3PO4
BcAmH2PO4, BcCmH2PO4 = fvcf_bc(phif, DH2PO4, uf, dx, BcH2PO4, Ngrid) #  # Boundary transport matrix of H2PO4
BcAmHPO4, BcCmHPO4 = fvcf_bc(phif, DHPO4, uf, dx, BcHPO4, Ngrid) #  # Boundary transport matrix of HPO4
BcAmPO4, BcCmPO4 = fvcf_bc(phif, DPO4, uf, dx, BcPO4, Ngrid) #  # Boundary transport matrix of PO4
BcAmHSO4, BcCmHSO4 = fvcf_bc(phif, DHSO4, uf, dx, BcHSO4, Ngrid) #  # Boundary transport matrix of HSO4
BcAmSO4, BcCmSO4 = fvcf_bc(phif, DSO4, uf, dx, BcSO4, Ngrid) #  # Boundary transport matrix of SO4
BcAmH, BcCmH = fvcf_bc(phif, DH, uf, dx, BcH, Ngrid) #  # Boundary transport matrix of H
BcAmOH, BcCmOH = fvcf_bc(phif, DOH, uf, dx, BcOH, Ngrid) #  # Boundary transport matrix of OH
BcAmHCO3, BcCmHCO3 = fvcf_bc(phif, DHCO3, uf, dx, BcHCO3, Ngrid) #  # Boundary transport matrix of HCO3
BcAmCO3, BcCmCO3 = fvcf_bc(phif, DCO3, uf, dx, BcCO3, Ngrid) #  # Boundary transport matrix of CO3
BcAmCO2, BcCmCO2 = fvcf_bc(phif, DCO2, uf, dx, BcCO2, Ngrid) #  # Boundary transport matrix of CO2
BcAmH2S, BcCmH2S = fvcf_bc(phif, DH2S, uf, dx, BcH2S, Ngrid) #  # Boundary transport matrix of H2S
BcAmHS, BcCmHS = fvcf_bc(phif, DHS, uf, dx, BcHS, Ngrid) #  # Boundary transport matrix of HS
BcAmH3BO3, BcCmH3BO3 = fvcf_bc(phif, DH3BO3, uf, dx, BcH3BO3, Ngrid) #  # Boundary transport matrix of H3BO3
BcAmH4BO4, BcCmH4BO4 = fvcf_bc(phif, DH4BO4, uf, dx, BcH4BO4, Ngrid) #  # Boundary transport matrix of H4BO4
BcAmHF, BcCmHF = fvcf_bc(phif, DHF, uf, dx, BcHF, Ngrid) #  # Boundary transport matrix of HF
BcAmF, BcCmF = fvcf_bc(phif, DF, uf, dx, BcF, Ngrid) #  # Boundary transport matrix of F
BcAmTFe_ads, BcCmTFe_ads = fvcf_bc(phis, Ds, us, dx, BcTFe_ads, Ngrid) #  # Boundary transport matrix of TFe_ads
BcAmTMn_ads, BcCmTMn_ads = fvcf_bc(phis, Ds, us, dx, BcTMn_ads, Ngrid) #  # Boundary transport matrix of TMn_ads
BcAmTNH4_ads, BcCmTNH4_ads = fvcf_bc(phis, Ds, us, dx, BcTNH4_ads, Ngrid) #  # Boundary transport matrix of TNH4_ads

#----------------------------------------------
# Interior transport matrix
#----------------------------------------------
AmPOC = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of POC
AmMnO2 = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of MnO2
AmFeOOH = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of FeOOH
AmFeS = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of FeS
AmFeS2 = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of FeS2
AmCaCO3 = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of CaCO3
AmMnCO3 = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of MnCO3
AmFeCO3 = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of FeCO3
AmAge = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Age
AmBSi = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of BSi
AmSMol = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of SMol
AmSMoh = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of SMoh
AmLMol = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of LMol
AmLMoh = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of LMoh
AmO2 = fvcf(phif, DO2, uf, dx, Ngrid) #  # Interior transport matrix of O2
AmNO3 = fvcf(phif, DNO3, uf, dx, Ngrid) #  # Interior transport matrix of NO3
AmCH4 = fvcf(phif, DCH4, uf, dx, Ngrid) #  # Interior transport matrix of CH4
AmNO2 = fvcf(phif, DNO2, uf, dx, Ngrid) #  # Interior transport matrix of NO2
AmCa = fvcf(phif, DCa, uf, dx, Ngrid) #  # Interior transport matrix of Ca
AmH4SiO4 = fvcf(phif, DH4SiO4, uf, dx, Ngrid) #  # Interior transport matrix of H4SiO4
AmTMn_dis = fvcf(phif, DTMn_dis, uf, dx, Ngrid) #  # Interior transport matrix of TMn_dis
AmTFe_dis = fvcf(phif, DTFe_dis, uf, dx, Ngrid) #  # Interior transport matrix of TFe_dis
AmTNH4_dis = fvcf(phif, DTNH4_dis, uf, dx, Ngrid) #  # Interior transport matrix of TNH4_dis
AmMol_dis = fvcf(phif, DMol_dis, uf, dx, Ngrid) #  # Interior transport matrix of Mol_dis
AmMoh_dis = fvcf(phif, DMoh_dis, uf, dx, Ngrid) #  # Interior transport matrix of Moh_dis
AmH3PO4 = fvcf(phif, DH3PO4, uf, dx, Ngrid) #  # Interior transport matrix of H3PO4
AmH2PO4 = fvcf(phif, DH2PO4, uf, dx, Ngrid) #  # Interior transport matrix of H2PO4
AmHPO4 = fvcf(phif, DHPO4, uf, dx, Ngrid) #  # Interior transport matrix of HPO4
AmPO4 = fvcf(phif, DPO4, uf, dx, Ngrid) #  # Interior transport matrix of PO4
AmHSO4 = fvcf(phif, DHSO4, uf, dx, Ngrid) #  # Interior transport matrix of HSO4
AmSO4 = fvcf(phif, DSO4, uf, dx, Ngrid) #  # Interior transport matrix of SO4
AmH = fvcf(phif, DH, uf, dx, Ngrid) #  # Interior transport matrix of H
AmOH = fvcf(phif, DOH, uf, dx, Ngrid) #  # Interior transport matrix of OH
AmHCO3 = fvcf(phif, DHCO3, uf, dx, Ngrid) #  # Interior transport matrix of HCO3
AmCO3 = fvcf(phif, DCO3, uf, dx, Ngrid) #  # Interior transport matrix of CO3
AmCO2 = fvcf(phif, DCO2, uf, dx, Ngrid) #  # Interior transport matrix of CO2
AmH2S = fvcf(phif, DH2S, uf, dx, Ngrid) #  # Interior transport matrix of H2S
AmHS = fvcf(phif, DHS, uf, dx, Ngrid) #  # Interior transport matrix of HS
AmH3BO3 = fvcf(phif, DH3BO3, uf, dx, Ngrid) #  # Interior transport matrix of H3BO3
AmH4BO4 = fvcf(phif, DH4BO4, uf, dx, Ngrid) #  # Interior transport matrix of H4BO4
AmHF = fvcf(phif, DHF, uf, dx, Ngrid) #  # Interior transport matrix of HF
AmF = fvcf(phif, DF, uf, dx, Ngrid) #  # Interior transport matrix of F
AmTFe_ads = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of TFe_ads
AmTMn_ads = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of TMn_ads
AmTNH4_ads = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of TNH4_ads

#----------------------------------------------
# Acid dissociation constants
#----------------------------------------------
KH3PO4 = 2.2887723115490765E-02 #  # TH3PO4 1th dissociation constant
KH2PO4 = 6.7599531383200987E-07 #  # TH3PO4 2th dissociation constant
KHPO4 = 5.1137324391283377E-10 #  # TH3PO4 3th dissociation constant
KHSO4 = 2.3517637553828422E-01 #  # THSO4 1th dissociation constant
KH2O = 7.9445878598109806E-15 #  # H 1th dissociation constant
KCO2 = 8.3698755808176172E-07 #  # TCO2 1th dissociation constant
KHCO3 = 4.6352156109843970E-10 #  # TCO2 2th dissociation constant
KH2S = 1.2845618784784929E-07 #  # TH2S 1th dissociation constant
KH3BO3 = 1.3599613779618076E-09 #  # TH3BO3 1th dissociation constant
KHF = 3.5451914085406016E-03 #  # THF 1th dissociation constant

#----------------------------------------------
# Reaction parameters
#----------------------------------------------
KO2 = 1.0e-6 #  mmol cm-3 pw yr-1 # Monod constant
nu = 0.12 # dimentionless # POC reactivity
a = 3.2 # yr # initial POC age
rNC = 0.15 # mol mol^-1 # N/C ratio Sediment trap 
rPC = 0.015 # mol mol^-2 # P/C ratio Sediment trap
KNO2 = 1.0e-5 # mmol cm-3 pw yr-1 # Monod constant
KNO3 = 1.0e-5 # mmol cm-3 pw yr-1 # Monod constant
KMnO2 = 16.0 * ds_rho / 1e3 # mmol cm-3 ds # Monod constant
KFeOOH = 450.0 * ds_rho / 1e3 # mmol cm-3 ds # Monod constant
KTHSO4 = 0.0001 # mmol cm-3 pw yr-1 # Monod constant
kO2NO2 = 1.0e7 # (mmol cm-3 pw)-1 yr-1 #  
kO2NH4 = 1.0e7 # (mmol cm-3 pw)-1 yr-1 #  
kO2Mn = 5.0e6 # (mmol cm-3 pw)-1 yr-1  #  
kO2Mn_ads = 1.0e7 # (mmol cm-3 pw)-1 yr-1  #  
kO2Fe = 5.0e8 # (mmol cm-3 pw)-1 yr-1 #  
kO2Fe_ads = 5.0e6 # (mmol cm-3 pw)-1 yr-1  #  
kO2H2S = 100000.0 # (mmol cm-3 pw)-1 yr-1  #  
kO2FeS = 100000.0 # (mmol cm-3 pw)-1 yr-1  #  
kO2CH4 = 1.0e10 # (mmol cm-3 pw)-1 yr-1  #  
kNO2NH4 = 1.0e8 # (mmol cm-3 pw)-1 yr-1  #  
kNO3Mn = 100000.0 # (mmol cm-3 pw)-1 yr-1  #  
kNO3Fe = 150000.0 # (mmol cm-3 pw)-1 yr-1  #  
kNO3H2S = 0.0 # (mmol cm-3 pw)-1 yr-1 #  
kAOM = 0.04 # yr-1  #  
KAOM = 0.001 # mmol cm-3 pw yr-1  #  
kMnO2Fe = 1.0e6 # (mmol cm-3 pw)-1 yr-1  #  
kMnO2H2S = 100000.0 # (mmol cm-3 pw)-1 yr-1  #  
kFeOOHH2S = 4000.0 # (mmol cm-3 pw)-0.5 yr-1  #  
kFeSH2S = 300.0 # (mmol cm-3 pw)-1 yr-1  #  
kFeSdis = 0.001 # yr-1  #  
KspFeS = 10^(-2.2) # (mmol cm-3 pw)^-1  # apparent solubility of FeS  
kFeSpre = 200e-3 * ds_rho # mmol cm-3 ds yr-1  #  
kCaCO3dis = 0.02 # yr^-1  # missing
KspCaCO3_dis = 4.49609622396569E-07 * sw_dens^2 # (mmol cm^-3 pw)^2 # missing
kCaCO3pre = 0.0001 # mmol cm^-3 ds yr^-1  # missing
KspCaCO3_pre = 4.49609622396569E-07 * sw_dens^2 # (mmol cm^-3 pw)^2 # missing
kMnCO3dis = 0.8 # yr-1  # missing
KspMnCO3 = 10^(-9.5) * sw_dens^2 # (mmol cm-3 pw)^-2  # missing
kMnCO3pre = 0.1 * ds_rho # mmol cm-3 ds yr-1  # missing
kFeCO3dis = 0.5 # yr-1  # missing
KspFeCO3 = 10^(-10.9 + 2.518 * 0.7^0.5 - 0.657 * 0.7) * sw_dens^2 # (mmol cm-3 pw)^-2   # missing
kFeCO3pre = 0.0001 # mmol cm-3 ds yr-1  # missing
kBSidis0 = 5e-6 * 365 * 24 # yr-1 # opal dissolution rate
xBSi = 1.7 # cm # dissolution attenuation scale
kBSidis = broadcast(x -> kBSidis0 * exp(-x / xBSi), x) # missing # depth dependent dissolution rate
H4SiO4_dis_sat =
    2.754e6 * exp(
        1 / (temp + 273.15) * (
            -2229 - 3.688e-3 * (1500 - 22 * 60) + 0.20 * (depth / 10) -
            2.7e-4 * (depth / 10)^2 + 1.46e-7 * (depth / 10)^3
        ),
    ) # mmol cm-3 pw # solubility of opal
kASipre = 5e-6 * 365 * 24 # yr-1  # authigenic silicate precipitation rate
H4SiO4_pre_sat = 0.0002 # mmol cm-3 pw # authigenic silicate precipitation threshold
KspCFA = 1.1541928959756795e-55 # missing # missing
kCFA_pre = 1.5e-8 # mmol cm-3 yr-1 # missing
alpha0_1 = 1.0014 # missing # missing
alpha0_2 = 1.0028 # missing # missing
alpha0_3 = 1.00455 # missing # missing
alpha0_4 = 1.0063 # missing # missing
kMo_rm2 = 50.0 # (mmol cm-3)-1 yr-1 pw  # missing

#----------------------------------------------
# Inital values
#----------------------------------------------
C_ini = [
    FPOC0 / (phis[1] * us[1]),
    FMnO20 / (phis[1] * us[1]),
    FFeOOH0 / (phis[1] * us[1]),
    FFeS0 / (phis[1] * us[1]),
    FFeS20 / (phis[1] * us[1]),
    FCaCO30 / (phis[1] * us[1]),
    FMnCO30 / (phis[1] * us[1]),
    FFeCO30 / (phis[1] * us[1]),
    FAge0 / (phis[1] * us[1]),
    FBSi0 / (phis[1] * us[1]),
    FSMol0 / (phis[1] * us[1]),
    FSMoh0 / (phis[1] * us[1]),
    FLMol0 / (phis[1] * us[1]),
    FLMoh0 / (phis[1] * us[1]),
    O2BW,
    NO3BW,
    CH4BW,
    NO2BW,
    CaBW,
    H4SiO4BW,
    TMn_dis0,
    TFe_dis0,
    TNH4_dis0,
    Mol_dis0,
    Moh_dis0,
    TH3PO4BW,
    THSO4BW,
    HBW,
    TCO2BW,
    TH2SBW,
    TH3BO3BW,
    THFBW,
] #  # initial conditions
C0 = repeat(C_ini, outer = Ngrid) # initial conditions

#----------------------------------------------
# Indices
#----------------------------------------------
POCID = ((1:Ngrid) .- 1)nspec .+ 1 #  # POC index
MnO2ID = ((1:Ngrid) .- 1)nspec .+ 2 #  # MnO2 index
FeOOHID = ((1:Ngrid) .- 1)nspec .+ 3 #  # FeOOH index
FeSID = ((1:Ngrid) .- 1)nspec .+ 4 #  # FeS index
FeS2ID = ((1:Ngrid) .- 1)nspec .+ 5 #  # FeS2 index
CaCO3ID = ((1:Ngrid) .- 1)nspec .+ 6 #  # CaCO3 index
MnCO3ID = ((1:Ngrid) .- 1)nspec .+ 7 #  # MnCO3 index
FeCO3ID = ((1:Ngrid) .- 1)nspec .+ 8 #  # FeCO3 index
AgeID = ((1:Ngrid) .- 1)nspec .+ 9 #  # Age index
BSiID = ((1:Ngrid) .- 1)nspec .+ 10 #  # BSi index
SMolID = ((1:Ngrid) .- 1)nspec .+ 11 #  # SMol index
SMohID = ((1:Ngrid) .- 1)nspec .+ 12 #  # SMoh index
LMolID = ((1:Ngrid) .- 1)nspec .+ 13 #  # LMol index
LMohID = ((1:Ngrid) .- 1)nspec .+ 14 #  # LMoh index
O2ID = ((1:Ngrid) .- 1)nspec .+ 15 #  # O2 index
NO3ID = ((1:Ngrid) .- 1)nspec .+ 16 #  # NO3 index
CH4ID = ((1:Ngrid) .- 1)nspec .+ 17 #  # CH4 index
NO2ID = ((1:Ngrid) .- 1)nspec .+ 18 #  # NO2 index
CaID = ((1:Ngrid) .- 1)nspec .+ 19 #  # Ca index
H4SiO4ID = ((1:Ngrid) .- 1)nspec .+ 20 #  # H4SiO4 index
TMnID = ((1:Ngrid) .- 1)nspec .+ 21 #  # TMn index
TFeID = ((1:Ngrid) .- 1)nspec .+ 22 #  # TFe index
TNH4ID = ((1:Ngrid) .- 1)nspec .+ 23 #  # TNH4 index
MolID = ((1:Ngrid) .- 1)nspec .+ 24 #  # Mol index
MohID = ((1:Ngrid) .- 1)nspec .+ 25 #  # Moh index
TH3PO4ID = ((1:Ngrid) .- 1)nspec .+ 26 #  # TH3PO4 index
THSO4ID = ((1:Ngrid) .- 1)nspec .+ 27 #  # THSO4 index
HID = ((1:Ngrid) .- 1)nspec .+ 28 #  # H index
TCO2ID = ((1:Ngrid) .- 1)nspec .+ 29 #  # TCO2 index
TH2SID = ((1:Ngrid) .- 1)nspec .+ 30 #  # TH2S index
TH3BO3ID = ((1:Ngrid) .- 1)nspec .+ 31 #  # TH3BO3 index
THFID = ((1:Ngrid) .- 1)nspec .+ 32 #  # THF index
IDdict = Dict(
    :POCID => POCID,
    :MnO2ID => MnO2ID,
    :FeOOHID => FeOOHID,
    :FeSID => FeSID,
    :FeS2ID => FeS2ID,
    :CaCO3ID => CaCO3ID,
    :MnCO3ID => MnCO3ID,
    :FeCO3ID => FeCO3ID,
    :AgeID => AgeID,
    :BSiID => BSiID,
    :SMolID => SMolID,
    :SMohID => SMohID,
    :LMolID => LMolID,
    :LMohID => LMohID,
    :O2ID => O2ID,
    :NO3ID => NO3ID,
    :CH4ID => CH4ID,
    :NO2ID => NO2ID,
    :CaID => CaID,
    :H4SiO4ID => H4SiO4ID,
    :TMnID => TMnID,
    :TFeID => TFeID,
    :TNH4ID => TNH4ID,
    :MolID => MolID,
    :MohID => MohID,
    :TH3PO4ID => TH3PO4ID,
    :THSO4ID => THSO4ID,
    :HID => HID,
    :TCO2ID => TCO2ID,
    :TH2SID => TH2SID,
    :TH3BO3ID => TH3BO3ID,
    :THFID => THFID,
)
