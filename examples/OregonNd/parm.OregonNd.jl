
#----------------------------------------------
# Number of substances
#----------------------------------------------
nsolid = 16 #  # number of solid substances
ndissolved = 12 #  # number of dissolved substances
nsummed = 6 #  # number of summed substances
nspec = 34 #  # number of total substances

#----------------------------------------------
# global parameters
#----------------------------------------------
depth = 3000.0 # m # water depth
salinity = 35.0 # psu # bottom water salinity
temp = 2.0 # Celsius # bottom water temperature
ds_rho = 2.6 # g cm^-3 # dry sediment density
sw_dens = 1.0290834608199197 # g cm^-3 # seawater density

#----------------------------------------------
# grid parameters
#----------------------------------------------
L = 50.0 # cm # model sediment section thickness
Ngrid = 300 # integer # number of model grid
pgrid = L / 10 # cm # constant in gridtran, attenuation scale
Nmat = 10200 # integer # Jacobian dimension
ξ = range(0, step = L / (Ngrid), length = Ngrid + 1) # cm # uniform grid
xᵥ = broadcast(x -> L * (exp(x * pgrid / L) - 1) / (exp(pgrid) - 1), ξ) # cm # non-uniform grid transformation
x = (xᵥ[2:(Ngrid+1)] .+ xᵥ[1:Ngrid]) / 2 # cm # cell center
dx = xᵥ[2:(Ngrid+1)] .- xᵥ[1:Ngrid] # cm # cell volume

#----------------------------------------------
# porosity parameters
#----------------------------------------------
phi0 = 0.8 # dimensionless # surface porosity
phiL = 0.7 # dimensionless # bottom porosity
xphi = 5.0 # cm # porosity attenuation scale
phi_Inf = 0.7 # dimensionless # porosity at burial depth
phif = broadcast(x -> phiL + (phi0 - phiL) * exp(-x / xphi), x) # dimensionless # fluid volume fraction
phis = 1.0 .- phif # dimensionless # solid volume fraction
pwtods = phif ./ phis # dimensionless # conversion from pore water to solid sediment volume unit
dstopw = phis ./ phif # dimensionless # conversion from solid sediment to pore water volume unit

#----------------------------------------------
# phase velocity parameters
#----------------------------------------------
Fsed = 0.01014 # g cm^-2 yr^-1 # total sediment flux
w_Inf = Fsed / ds_rho / (1 - phi_Inf) # cm yr^-1 # solid sediment burial velocity at infinite depth
uf = phi_Inf * w_Inf ./ phif # cm yr^-1 # pore water burial velocity
us = Fsed / ds_rho ./ phis # cm yr^-1 # solid sediment burial velocity

#----------------------------------------------
# bioturbation parameters
#----------------------------------------------
Dbt0 = 1.93554531569282 # cm^2/yr # bioturbation coefficient
xbt = 6.0 # cm # attentuation scale of bioturbation
Ds = broadcast(x -> Dbt0 * erfc((x - xbt) / 1) / 2, x) # cm^2 yr^-1 # Bioturbation coefficient

#----------------------------------------------
# bioirrigation parameters
#----------------------------------------------
Dbir0 = 28.42212793142007 # yr^-1 # bioirrigation constant
xbir = 2.0 # cm # attentuation scale of bioirrigation
alpha = broadcast(x -> Dbir0 * exp(-x / xbir), x) # yr^-1 # Bioirrigation coefficient

#----------------------------------------------
# speciation parameters
#----------------------------------------------
KNH4_ads = 1.6 * ds_rho # cm^3(porewater) cm^-3(dry sediment) # speciation constant
KMn_ads_Mn = 10000.0 # (mmol cm-3 pw)^-1  # speciation constant
KMn_ads_Fe = 100.0 # (mmol cm-3 pw)^-1  # speciation constant
KFe_ads_Mn = 10000.0 # (mmol cm-3 pw)^-1  # speciation constant
KFe_ads_Fe = 10000.0 # (mmol cm-3 pw)^-1  # speciation constant
KNd_ads_Mn = 0.0 # (mmol cm-3 pw)^-1  # speciation constant
KNd_ads_Fe = 0.0 # (mmol cm-3 pw)^-1  # speciation constant
Cl = 0.565772678 # mmol cm^-3 # speciation constant

#----------------------------------------------
# solute diffusivity
#----------------------------------------------
DO2 = 4.0267424183436583E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DNO3 = 3.1390297096278300E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DCH4 = 2.5287306607605316E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DNO2 = 3.3485834640852744E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DCa = 1.2090579593914902E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DSO4 = 1.6324420755402028E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DTMn_dis = 1.0660970890036131E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DTFe_dis = 1.1027537224364021E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DAl_dis = 1.5108642413214525E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DTNH4_dis = 3.1543033068914923E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DTNdnr_dis = 8.9792651606646430E+01 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DTNdr_dis = 8.9792651606646430E+01 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DH4SiO4 = 1.6311069866893683E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DH3SiO4 = 1.6311069866893683E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DHCO3 = 1.7136976129828849E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DCO3 = 1.4442713572518861E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DCO2 = 3.1719111361915839E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DH2S = 3.1798409506569561E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DHS = 3.3436959129609028E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DH3BO3 = 1.8019098720389422E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DH4BO4 = 1.5766711380340743E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DH3PO4 = 1.3173626795578818E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DH2PO4 = 1.3642377075902965E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DHPO4 = 1.1039756102174947E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DPO4 = 8.8770147296404019E+01 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DH = 1.7567691572664121E+03 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DOH = 8.5800959988348086E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient

#----------------------------------------------
# solute mass transfer velocities
#----------------------------------------------
delta = 0.05 # cm # thickness of the diffusive boundary layer
betaO2 = 8.0534848366873166E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaNO3 = 6.2780594192556600E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaCH4 = 5.0574613215210629E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaNO2 = 6.6971669281705481E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaCa = 2.4181159187829803E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaSO4 = 3.2648841510804054E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaAl_dis = 3.0217284826429050E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaH4SiO4 = 3.2622139733787367E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaH3SiO4 = 3.2622139733787367E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaHCO3 = 3.4273952259657699E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaCO3 = 2.8885427145037720E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaCO2 = 6.3438222723831677E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaH2S = 6.3596819013139120E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaHS = 6.6873918259218053E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaH3BO3 = 3.6038197440778845E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaH4BO4 = 3.1533422760681483E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaH3PO4 = 2.6347253591157632E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaH2PO4 = 2.7284754151805928E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaHPO4 = 2.2079512204349894E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaPO4 = 1.7754029459280803E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaH = 3.5135383145328240E+04 # cm yr^-1 # solute mass transfer velocity across SWI
betaOH = 1.7160191997669615E+04 # cm yr^-1 # solute mass transfer velocity across SWI

#----------------------------------------------
# boundary fluxes and concentrations
#----------------------------------------------
FPOC0 = 3.2 / 100 * Fsed / 12 * 1000 # mmol cm^-2 yr^-1 # Flux of POC at the  TOP of sediment column
FMnO20 = 0.3 / 100 * Fsed / 86.94 * 1000 # mmol cm^-2 yr^-1 # Flux of MnO2 at the  TOP of sediment column
FFeOOH0 = 0.1 / 100 * Fsed / 88.85 * 1000 # mmol cm^-2 yr^-1 # Flux of FeOOH at the  TOP of sediment column
FFeS0 = 0.0 # mmol cm^-2 yr^-1 # Flux of FeS at the  TOP of sediment column
FFeS20 = 0.0 # mmol cm^-2 yr^-1 # Flux of FeS2 at the  TOP of sediment column
FCaCO30 = 10 / 100 * Fsed / 100 * 1000 # mmol cm^-2 yr^-1 # Flux of CaCO3 at the  TOP of sediment column
FBSi0 = 9 / 100 * Fsed / 28.09 * 1000 # mmol cm^-2 yr^-1 # Flux of BSi at the  TOP of sediment column
Age0 = 0.0 # year # Age at the TOP of sediment column
CaBW = 0.01033 # mmol cm^-3 # Bottom water concentration of Ca
SO4BW = 0.028 # mmol cm^-3 # Bottom water concentration of SO4
TH3BO3BW = 8.7062e-5 # mmol cm^-3 # Bottom water concentration of TH3BO3
TMn_dis0 = 5.0e-10 # mmol cm^-3 # Concentration of TMn_dis at the TOP of sediment column
TFe_dis0 = 5.0e-10 # mmol cm^-3 # Concentration of TFe_dis at the TOP of sediment column
Al_disBW = 5.0e-10 # mmol cm^-3 # Bottom water concentration of Al_dis
CH4BW = 0.0 # mmol cm^-3 # Bottom water concentration of CH4
O2BW = 8.0e-5 # mmol cm^-3 # Bottom water concentration of O2
NO3BW = 4.0e-5 # mmol cm^-3 # Bottom water concentration of NO3
NO2BW = 5.0e-8 # mmol cm^-3 # Bottom water concentration of NO2
TNH4_dis0 = 0.0 # mmol cm^-3 # Concentration of TNH4_dis at the TOP of sediment column
TNH4_ads0 = TNH4_dis0 * KNH4_ads # mmol cm^-3 # Concentration of TNH4_ads at the TOP of sediment column
TH3PO4BW = 2.8e-6 # mmol cm^-3 # Bottom water concentration of TH3PO4
TH4SiO4BW = 0.00019 # mmol cm^-3 # Bottom water concentration of TH4SiO4
pHBW = 7.7 # free pH scale # Bottom water pH
TCO2BW = 0.00238 # mmol cm^-3 # Bottom water concentration of TCO2
TH2SBW = 0.0 # mmol cm^-3 # Bottom water concentration of TH2S
FTMn_ads0 = KMn_ads_Mn * FMnO20 * TMn_dis0 + KMn_ads_Fe * FFeOOH0 * TMn_dis0 # mmol cm^-2 yr^-1 # Flux of TMn_ads at the  TOP of sediment column
FTFe_ads0 = KFe_ads_Mn * FMnO20 * TFe_dis0 + KFe_ads_Fe * FFeOOH0 * TFe_dis0 # mmol cm^-2 yr^-1 # Flux of TFe_ads at the  TOP of sediment column
TNdnr_dis0 = 2.3140266884232977e-11 # mmol cm^-3 # Concentration of TNdnr_dis at the TOP of sediment column
TNdr_dis0 = 1.1859733115767025e-11 # mmol cm^-3 # Concentration of TNdr_dis at the TOP of sediment column
FNdnrPO40 = 1.0e-14 # mmol cm^-2 yr^-1 # Flux of NdnrPO4 at the  TOP of sediment column
FNdrPO40 = 5.1251496688e-15 # mmol cm^-2 yr^-1 # Flux of NdrPO4 at the  TOP of sediment column
FTNdnr_ads0 =
    KNd_ads_Mn * FMnO20 * TNdnr_dis0 + KNd_ads_Fe * FFeOOH0 * TNdnr_dis0 # mmol cm^-2 yr^-1 # Flux of TNdnr_ads at the  TOP of sediment column
FTNdr_ads0 = KNd_ads_Mn * FMnO20 * TNdr_dis0 + KNd_ads_Fe * FFeOOH0 * TNdr_dis0 # mmol cm^-2 yr^-1 # Flux of TNdr_ads at the  TOP of sediment column
DNdMn = 0.025 # dimensionless # missing
DNdFe = 0.005 # dimensionless # missing
FSurfMn_Ndnr0 = FMnO20 * TNdnr_dis0 / TMn_dis0 * DNdMn # mmol cm^-2 yr^-1 # Flux of SurfMn_Ndnr at the  TOP of sediment column
FSurfMn_Ndr0 = FMnO20 * TNdr_dis0 / TMn_dis0 * DNdMn # mmol cm^-2 yr^-1 # Flux of SurfMn_Ndr at the  TOP of sediment column
FSurfFe_Ndnr0 = FFeOOH0 * TNdnr_dis0 / TFe_dis0 * DNdFe # mmol cm^-2 yr^-1 # Flux of SurfFe_Ndnr at the  TOP of sediment column
FSurfFe_Ndr0 = FFeOOH0 * TNdr_dis0 / TFe_dis0 * DNdFe # mmol cm^-2 yr^-1 # Flux of SurfFe_Ndr at the  TOP of sediment column
Basalt0 = 2.0 # wt% # missing
FBasalt0 = Basalt0 / 100 * Fsed / 88.16 * 1000 # mmol cm^-2 yr^-1 # Flux of Basalt at the  TOP of sediment column
Illite0 = 2.0 # wt% # missing
FIllite0 = Illite0 / 100 * Fsed / 392.609 * 1000 # mmol cm^-2 yr^-1 # missing
H4SiO4BW = 1.8810951339764959E-04 # mmol cm^-3 # Bottom water concentration of H4SiO4
H3SiO4BW = 1.8904866023504388E-06 # mmol cm^-3 # Bottom water concentration of H3SiO4
HCO3BW = 2.2786338081836341E-03 # mmol cm^-3 # Bottom water concentration of HCO3
CO3BW = 5.7642869082059730E-05 # mmol cm^-3 # Bottom water concentration of CO3
CO2BW = 4.3723322734306207E-05 # mmol cm^-3 # Bottom water concentration of CO2
H2SBW = 0.0000000000000000E+00 # mmol cm^-3 # Bottom water concentration of H2S
HSBW = 0.0000000000000000E+00 # mmol cm^-3 # Bottom water concentration of HS
H3BO3BW = 8.0038768513133267E-05 # mmol cm^-3 # Bottom water concentration of H3BO3
H4BO4BW = 7.0232314868667494E-06 # mmol cm^-3 # Bottom water concentration of H4BO4
H3PO4BW = 4.7053892886333245E-14 # mmol cm^-3 # Bottom water concentration of H3PO4
H2PO4BW = 6.4601091251846767E-08 # mmol cm^-3 # Bottom water concentration of H2PO4
HPO4BW = 2.6574742851297771E-06 # mmol cm^-3 # Bottom water concentration of HPO4
PO4BW = 7.7924576564483073E-08 # mmol cm^-3 # Bottom water concentration of PO4
HBW = 1.9952623149688786E-08 # mmol cm^-3 # Bottom water concentration of H
OHBW = 3.6550232722692140E-07 # mmol cm^-3 # Bottom water concentration of OH

#----------------------------------------------
# assemble boundary conditions
#----------------------------------------------
BcMnO2 = ((phis[1]us[1], -phis[1]Ds[1], FMnO20), (0.0, 1.0, 0.0)) #  # Boundary condition of MnO2
BcFeOOH = ((phis[1]us[1], -phis[1]Ds[1], FFeOOH0), (0.0, 1.0, 0.0)) #  # Boundary condition of FeOOH
BcPOC = ((phis[1]us[1], -phis[1]Ds[1], FPOC0), (0.0, 1.0, 0.0)) #  # Boundary condition of POC
BcFeS = ((phis[1]us[1], -phis[1]Ds[1], FFeS0), (0.0, 1.0, 0.0)) #  # Boundary condition of FeS
BcFeS2 = ((phis[1]us[1], -phis[1]Ds[1], FFeS20), (0.0, 1.0, 0.0)) #  # Boundary condition of FeS2
BcCaCO3 = ((phis[1]us[1], -phis[1]Ds[1], FCaCO30), (0.0, 1.0, 0.0)) #  # Boundary condition of CaCO3
BcAge = ((1.0, 0.0, Age0), (0.0, 1.0, 1.0 / us[Ngrid])) #  # Boundary condition of Age
BcBSi = ((phis[1]us[1], -phis[1]Ds[1], FBSi0), (0.0, 1.0, 0.0)) #  # Boundary condition of BSi
BcNdnrPO4 = ((phis[1]us[1], -phis[1]Ds[1], FNdnrPO40), (0.0, 1.0, 0.0)) #  # Boundary condition of NdnrPO4
BcNdrPO4 = ((phis[1]us[1], -phis[1]Ds[1], FNdrPO40), (0.0, 1.0, 0.0)) #  # Boundary condition of NdrPO4
BcSurfMn_Ndnr = ((phis[1]us[1], -phis[1]Ds[1], FSurfMn_Ndnr0), (0.0, 1.0, 0.0)) #  # Boundary condition of SurfMn_Ndnr
BcSurfMn_Ndr = ((phis[1]us[1], -phis[1]Ds[1], FSurfMn_Ndr0), (0.0, 1.0, 0.0)) #  # Boundary condition of SurfMn_Ndr
BcSurfFe_Ndnr = ((phis[1]us[1], -phis[1]Ds[1], FSurfFe_Ndnr0), (0.0, 1.0, 0.0)) #  # Boundary condition of SurfFe_Ndnr
BcSurfFe_Ndr = ((phis[1]us[1], -phis[1]Ds[1], FSurfFe_Ndr0), (0.0, 1.0, 0.0)) #  # Boundary condition of SurfFe_Ndr
BcIllite = ((phis[1]us[1], -phis[1]Ds[1], FIllite0), (0.0, 1.0, 0.0)) #  # Boundary condition of Illite
BcBasalt = ((phis[1]us[1], -phis[1]Ds[1], FBasalt0), (0.0, 1.0, 0.0)) #  # Boundary condition of Basalt
BcO2 = ((betaO2 + phif[1]uf[1], -phif[1]DO2[1], betaO2 * O2BW), (0.0, 1.0, 0.0)) #  # Boundary condition of O2
BcNO3 = (
    (betaNO3 + phif[1]uf[1], -phif[1]DNO3[1], betaNO3 * NO3BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of NO3
BcCH4 = (
    (betaCH4 + phif[1]uf[1], -phif[1]DCH4[1], betaCH4 * CH4BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of CH4
BcNO2 = (
    (betaNO2 + phif[1]uf[1], -phif[1]DNO2[1], betaNO2 * NO2BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of NO2
BcCa = ((betaCa + phif[1]uf[1], -phif[1]DCa[1], betaCa * CaBW), (0.0, 1.0, 0.0)) #  # Boundary condition of Ca
BcSO4 = (
    (betaSO4 + phif[1]uf[1], -phif[1]DSO4[1], betaSO4 * SO4BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of SO4
BcTMn_dis = ((1.0, 0.0, TMn_dis0), (0.0, 1.0, 0.0)) #  # Boundary condition of TMn_dis
BcTFe_dis = ((1.0, 0.0, TFe_dis0), (0.0, 1.0, 0.0)) #  # Boundary condition of TFe_dis
BcAl_dis = (
    (betaAl_dis + phif[1]uf[1], -phif[1]DAl_dis[1], betaAl_dis * Al_disBW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of Al_dis
BcTNH4_dis = ((1.0, 0.0, TNH4_dis0), (0.0, 1.0, 0.0)) #  # Boundary condition of TNH4_dis
BcTNdnr_dis = ((1.0, 0.0, TNdnr_dis0), (0.0, 1.0, 0.0)) #  # Boundary condition of TNdnr_dis
BcTNdr_dis = ((1.0, 0.0, TNdr_dis0), (0.0, 1.0, 0.0)) #  # Boundary condition of TNdr_dis
BcH4SiO4 = (
    (betaH4SiO4 + phif[1]uf[1], -phif[1]DH4SiO4[1], betaH4SiO4 * H4SiO4BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of TH4SiO4
BcH3SiO4 = (
    (betaH3SiO4 + phif[1]uf[1], -phif[1]DH3SiO4[1], betaH3SiO4 * H3SiO4BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of TH4SiO4
BcHCO3 = (
    (betaHCO3 + phif[1]uf[1], -phif[1]DHCO3[1], betaHCO3 * HCO3BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of TCO2
BcCO3 = (
    (betaCO3 + phif[1]uf[1], -phif[1]DCO3[1], betaCO3 * CO3BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of TCO2
BcCO2 = (
    (betaCO2 + phif[1]uf[1], -phif[1]DCO2[1], betaCO2 * CO2BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of TCO2
BcH2S = (
    (betaH2S + phif[1]uf[1], -phif[1]DH2S[1], betaH2S * H2SBW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of TH2S
BcHS = ((betaHS + phif[1]uf[1], -phif[1]DHS[1], betaHS * HSBW), (0.0, 1.0, 0.0)) #  # Boundary condition of TH2S
BcH3BO3 = (
    (betaH3BO3 + phif[1]uf[1], -phif[1]DH3BO3[1], betaH3BO3 * H3BO3BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of TH3BO3
BcH4BO4 = (
    (betaH4BO4 + phif[1]uf[1], -phif[1]DH4BO4[1], betaH4BO4 * H4BO4BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of TH3BO3
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
BcH = ((betaH + phif[1]uf[1], -phif[1]DH[1], betaH * HBW), (0.0, 1.0, 0.0)) #  # Boundary condition of H
BcOH = ((betaOH + phif[1]uf[1], -phif[1]DOH[1], betaOH * OHBW), (0.0, 1.0, 0.0)) #  # Boundary condition of H
BcTNdnr_ads = ((phis[1]us[1], -phis[1]Ds[1], FTNdnr_ads0), (0.0, 1.0, 0.0)) #  # Boundary condition of TNdnr_ads
BcTNdr_ads = ((phis[1]us[1], -phis[1]Ds[1], FTNdr_ads0), (0.0, 1.0, 0.0)) #  # Boundary condition of TNdr_ads
BcTFe_ads = ((phis[1]us[1], -phis[1]Ds[1], FTFe_ads0), (0.0, 1.0, 0.0)) #  # Boundary condition of TFe_ads
BcTMn_ads = ((phis[1]us[1], -phis[1]Ds[1], FTMn_ads0), (0.0, 1.0, 0.0)) #  # Boundary condition of TMn_ads
BcTNH4_ads = ((1.0, 0.0, TNH4_ads0), (0.0, 1.0, 0.0)) #  # Boundary condition of TNH4_ads

#----------------------------------------------
# Boundary transport matrix
#----------------------------------------------
BcAmMnO2, BcCmMnO2 = fvcf_bc(phis, Ds, us, dx, BcMnO2, Ngrid) #  # Boundary transport matrix of MnO2
BcAmFeOOH, BcCmFeOOH = fvcf_bc(phis, Ds, us, dx, BcFeOOH, Ngrid) #  # Boundary transport matrix of FeOOH
BcAmPOC, BcCmPOC = fvcf_bc(phis, Ds, us, dx, BcPOC, Ngrid) #  # Boundary transport matrix of POC
BcAmFeS, BcCmFeS = fvcf_bc(phis, Ds, us, dx, BcFeS, Ngrid) #  # Boundary transport matrix of FeS
BcAmFeS2, BcCmFeS2 = fvcf_bc(phis, Ds, us, dx, BcFeS2, Ngrid) #  # Boundary transport matrix of FeS2
BcAmCaCO3, BcCmCaCO3 = fvcf_bc(phis, Ds, us, dx, BcCaCO3, Ngrid) #  # Boundary transport matrix of CaCO3
BcAmAge, BcCmAge = fvcf_bc(phis, Ds, us, dx, BcAge, Ngrid) #  # Boundary transport matrix of Age
BcAmBSi, BcCmBSi = fvcf_bc(phis, Ds, us, dx, BcBSi, Ngrid) #  # Boundary transport matrix of BSi
BcAmNdnrPO4, BcCmNdnrPO4 = fvcf_bc(phis, Ds, us, dx, BcNdnrPO4, Ngrid) #  # Boundary transport matrix of NdnrPO4
BcAmNdrPO4, BcCmNdrPO4 = fvcf_bc(phis, Ds, us, dx, BcNdrPO4, Ngrid) #  # Boundary transport matrix of NdrPO4
BcAmSurfMn_Ndnr, BcCmSurfMn_Ndnr =
    fvcf_bc(phis, Ds, us, dx, BcSurfMn_Ndnr, Ngrid) #  # Boundary transport matrix of SurfMn_Ndnr
BcAmSurfMn_Ndr, BcCmSurfMn_Ndr = fvcf_bc(phis, Ds, us, dx, BcSurfMn_Ndr, Ngrid) #  # Boundary transport matrix of SurfMn_Ndr
BcAmSurfFe_Ndnr, BcCmSurfFe_Ndnr =
    fvcf_bc(phis, Ds, us, dx, BcSurfFe_Ndnr, Ngrid) #  # Boundary transport matrix of SurfFe_Ndnr
BcAmSurfFe_Ndr, BcCmSurfFe_Ndr = fvcf_bc(phis, Ds, us, dx, BcSurfFe_Ndr, Ngrid) #  # Boundary transport matrix of SurfFe_Ndr
BcAmIllite, BcCmIllite = fvcf_bc(phis, Ds, us, dx, BcIllite, Ngrid) #  # Boundary transport matrix of Illite
BcAmBasalt, BcCmBasalt = fvcf_bc(phis, Ds, us, dx, BcBasalt, Ngrid) #  # Boundary transport matrix of Basalt
BcAmO2, BcCmO2 = fvcf_bc(phif, DO2, uf, dx, BcO2, Ngrid) #  # Boundary transport matrix of O2
BcAmNO3, BcCmNO3 = fvcf_bc(phif, DNO3, uf, dx, BcNO3, Ngrid) #  # Boundary transport matrix of NO3
BcAmCH4, BcCmCH4 = fvcf_bc(phif, DCH4, uf, dx, BcCH4, Ngrid) #  # Boundary transport matrix of CH4
BcAmNO2, BcCmNO2 = fvcf_bc(phif, DNO2, uf, dx, BcNO2, Ngrid) #  # Boundary transport matrix of NO2
BcAmCa, BcCmCa = fvcf_bc(phif, DCa, uf, dx, BcCa, Ngrid) #  # Boundary transport matrix of Ca
BcAmSO4, BcCmSO4 = fvcf_bc(phif, DSO4, uf, dx, BcSO4, Ngrid) #  # Boundary transport matrix of SO4
BcAmTMn_dis, BcCmTMn_dis = fvcf_bc(phif, DTMn_dis, uf, dx, BcTMn_dis, Ngrid) #  # Boundary transport matrix of TMn_dis
BcAmTFe_dis, BcCmTFe_dis = fvcf_bc(phif, DTFe_dis, uf, dx, BcTFe_dis, Ngrid) #  # Boundary transport matrix of TFe_dis
BcAmAl_dis, BcCmAl_dis = fvcf_bc(phif, DAl_dis, uf, dx, BcAl_dis, Ngrid) #  # Boundary transport matrix of Al_dis
BcAmTNH4_dis, BcCmTNH4_dis = fvcf_bc(phif, DTNH4_dis, uf, dx, BcTNH4_dis, Ngrid) #  # Boundary transport matrix of TNH4_dis
BcAmTNdnr_dis, BcCmTNdnr_dis =
    fvcf_bc(phif, DTNdnr_dis, uf, dx, BcTNdnr_dis, Ngrid) #  # Boundary transport matrix of TNdnr_dis
BcAmTNdr_dis, BcCmTNdr_dis = fvcf_bc(phif, DTNdr_dis, uf, dx, BcTNdr_dis, Ngrid) #  # Boundary transport matrix of TNdr_dis
BcAmH4SiO4, BcCmH4SiO4 = fvcf_bc(phif, DH4SiO4, uf, dx, BcH4SiO4, Ngrid) #  # Boundary transport matrix of H4SiO4
BcAmH3SiO4, BcCmH3SiO4 = fvcf_bc(phif, DH3SiO4, uf, dx, BcH3SiO4, Ngrid) #  # Boundary transport matrix of H3SiO4
BcAmHCO3, BcCmHCO3 = fvcf_bc(phif, DHCO3, uf, dx, BcHCO3, Ngrid) #  # Boundary transport matrix of HCO3
BcAmCO3, BcCmCO3 = fvcf_bc(phif, DCO3, uf, dx, BcCO3, Ngrid) #  # Boundary transport matrix of CO3
BcAmCO2, BcCmCO2 = fvcf_bc(phif, DCO2, uf, dx, BcCO2, Ngrid) #  # Boundary transport matrix of CO2
BcAmH2S, BcCmH2S = fvcf_bc(phif, DH2S, uf, dx, BcH2S, Ngrid) #  # Boundary transport matrix of H2S
BcAmHS, BcCmHS = fvcf_bc(phif, DHS, uf, dx, BcHS, Ngrid) #  # Boundary transport matrix of HS
BcAmH3BO3, BcCmH3BO3 = fvcf_bc(phif, DH3BO3, uf, dx, BcH3BO3, Ngrid) #  # Boundary transport matrix of H3BO3
BcAmH4BO4, BcCmH4BO4 = fvcf_bc(phif, DH4BO4, uf, dx, BcH4BO4, Ngrid) #  # Boundary transport matrix of H4BO4
BcAmH3PO4, BcCmH3PO4 = fvcf_bc(phif, DH3PO4, uf, dx, BcH3PO4, Ngrid) #  # Boundary transport matrix of H3PO4
BcAmH2PO4, BcCmH2PO4 = fvcf_bc(phif, DH2PO4, uf, dx, BcH2PO4, Ngrid) #  # Boundary transport matrix of H2PO4
BcAmHPO4, BcCmHPO4 = fvcf_bc(phif, DHPO4, uf, dx, BcHPO4, Ngrid) #  # Boundary transport matrix of HPO4
BcAmPO4, BcCmPO4 = fvcf_bc(phif, DPO4, uf, dx, BcPO4, Ngrid) #  # Boundary transport matrix of PO4
BcAmH, BcCmH = fvcf_bc(phif, DH, uf, dx, BcH, Ngrid) #  # Boundary transport matrix of H
BcAmOH, BcCmOH = fvcf_bc(phif, DOH, uf, dx, BcOH, Ngrid) #  # Boundary transport matrix of OH
BcAmTNdnr_ads, BcCmTNdnr_ads = fvcf_bc(phis, Ds, us, dx, BcTNdnr_ads, Ngrid) #  # Boundary transport matrix of TNdnr_ads
BcAmTNdr_ads, BcCmTNdr_ads = fvcf_bc(phis, Ds, us, dx, BcTNdr_ads, Ngrid) #  # Boundary transport matrix of TNdr_ads
BcAmTFe_ads, BcCmTFe_ads = fvcf_bc(phis, Ds, us, dx, BcTFe_ads, Ngrid) #  # Boundary transport matrix of TFe_ads
BcAmTMn_ads, BcCmTMn_ads = fvcf_bc(phis, Ds, us, dx, BcTMn_ads, Ngrid) #  # Boundary transport matrix of TMn_ads
BcAmTNH4_ads, BcCmTNH4_ads = fvcf_bc(phis, Ds, us, dx, BcTNH4_ads, Ngrid) #  # Boundary transport matrix of TNH4_ads

#----------------------------------------------
# Interior transport matrix
#----------------------------------------------
AmMnO2 = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of MnO2
AmFeOOH = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of FeOOH
AmPOC = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of POC
AmFeS = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of FeS
AmFeS2 = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of FeS2
AmCaCO3 = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of CaCO3
AmAge = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Age
AmBSi = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of BSi
AmNdnrPO4 = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of NdnrPO4
AmNdrPO4 = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of NdrPO4
AmSurfMn_Ndnr = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of SurfMn_Ndnr
AmSurfMn_Ndr = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of SurfMn_Ndr
AmSurfFe_Ndnr = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of SurfFe_Ndnr
AmSurfFe_Ndr = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of SurfFe_Ndr
AmIllite = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Illite
AmBasalt = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Basalt
AmO2 = fvcf(phif, DO2, uf, dx, Ngrid) #  # Interior transport matrix of O2
AmNO3 = fvcf(phif, DNO3, uf, dx, Ngrid) #  # Interior transport matrix of NO3
AmCH4 = fvcf(phif, DCH4, uf, dx, Ngrid) #  # Interior transport matrix of CH4
AmNO2 = fvcf(phif, DNO2, uf, dx, Ngrid) #  # Interior transport matrix of NO2
AmCa = fvcf(phif, DCa, uf, dx, Ngrid) #  # Interior transport matrix of Ca
AmSO4 = fvcf(phif, DSO4, uf, dx, Ngrid) #  # Interior transport matrix of SO4
AmTMn_dis = fvcf(phif, DTMn_dis, uf, dx, Ngrid) #  # Interior transport matrix of TMn_dis
AmTFe_dis = fvcf(phif, DTFe_dis, uf, dx, Ngrid) #  # Interior transport matrix of TFe_dis
AmAl_dis = fvcf(phif, DAl_dis, uf, dx, Ngrid) #  # Interior transport matrix of Al_dis
AmTNH4_dis = fvcf(phif, DTNH4_dis, uf, dx, Ngrid) #  # Interior transport matrix of TNH4_dis
AmTNdnr_dis = fvcf(phif, DTNdnr_dis, uf, dx, Ngrid) #  # Interior transport matrix of TNdnr_dis
AmTNdr_dis = fvcf(phif, DTNdr_dis, uf, dx, Ngrid) #  # Interior transport matrix of TNdr_dis
AmH4SiO4 = fvcf(phif, DH4SiO4, uf, dx, Ngrid) #  # Interior transport matrix of H4SiO4
AmH3SiO4 = fvcf(phif, DH3SiO4, uf, dx, Ngrid) #  # Interior transport matrix of H3SiO4
AmHCO3 = fvcf(phif, DHCO3, uf, dx, Ngrid) #  # Interior transport matrix of HCO3
AmCO3 = fvcf(phif, DCO3, uf, dx, Ngrid) #  # Interior transport matrix of CO3
AmCO2 = fvcf(phif, DCO2, uf, dx, Ngrid) #  # Interior transport matrix of CO2
AmH2S = fvcf(phif, DH2S, uf, dx, Ngrid) #  # Interior transport matrix of H2S
AmHS = fvcf(phif, DHS, uf, dx, Ngrid) #  # Interior transport matrix of HS
AmH3BO3 = fvcf(phif, DH3BO3, uf, dx, Ngrid) #  # Interior transport matrix of H3BO3
AmH4BO4 = fvcf(phif, DH4BO4, uf, dx, Ngrid) #  # Interior transport matrix of H4BO4
AmH3PO4 = fvcf(phif, DH3PO4, uf, dx, Ngrid) #  # Interior transport matrix of H3PO4
AmH2PO4 = fvcf(phif, DH2PO4, uf, dx, Ngrid) #  # Interior transport matrix of H2PO4
AmHPO4 = fvcf(phif, DHPO4, uf, dx, Ngrid) #  # Interior transport matrix of HPO4
AmPO4 = fvcf(phif, DPO4, uf, dx, Ngrid) #  # Interior transport matrix of PO4
AmH = fvcf(phif, DH, uf, dx, Ngrid) #  # Interior transport matrix of H
AmOH = fvcf(phif, DOH, uf, dx, Ngrid) #  # Interior transport matrix of OH
AmTNdnr_ads = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of TNdnr_ads
AmTNdr_ads = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of TNdr_ads
AmTFe_ads = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of TFe_ads
AmTMn_ads = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of TMn_ads
AmTNH4_ads = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of TNH4_ads

#----------------------------------------------
# Acid dissociation constants
#----------------------------------------------
KH4SiO4 = 2.0052237691188018E-10 #  # TH4SiO4 1th dissociation constant
KCO2 = 1.0398276898373909E-06 #  # TCO2 1th dissociation constant
KHCO3 = 5.0474386886148435E-10 #  # TCO2 2th dissociation constant
KH2S = 1.3569010482570850E-07 #  # TH2S 1th dissociation constant
KH3BO3 = 1.7508001903788285E-09 #  # TH3BO3 1th dissociation constant
KH3PO4 = 2.7393296276685596E-02 #  # TH3PO4 1th dissociation constant
KH2PO4 = 8.2078463248354579E-07 #  # TH3PO4 2th dissociation constant
KHPO4 = 5.8506669998286476E-10 #  # TH3PO4 3th dissociation constant
KH2O = 7.2927301954929983E-15 #  # H 1th dissociation constant

#----------------------------------------------
# Reaction parameters
#----------------------------------------------
nu = 0.125 # dimensionless # POC reactivity
a = 60.0 # yr # initial POC age
rNC = 16 / 170 # mol mol^-1 # N/C ratio Sediment trap 
rPC = 1 / 170 # mol mol^-2 # P/C ratio Sediment trap
KO2 = 1.0e-6 # mmol cm-3 pw # Monod constant
KNO2 = 1.0e-5 # mmol cm-3 pw # Monod constant
KNO3 = 1.0e-5 # mmol cm-3 pw # Monod constant
KMnO2 = 0.1 / (86.93685 / ds_rho / 10) # mmol cm-3 ds # Monod constant
KFeOOH = 30 / (88.85174 / ds_rho / 10) # mmol cm-3 ds # Monod constant
KSO4 = 2.6e-6 # mmol cm-3 pw # Monod constant
kO2NO2 = 1.0e7 # (mmol cm-3 pw)-1 yr-1 #  
kO2NH4 = 1.0e7 # (mmol cm-3 pw)-1 yr-1 #  
kO2Mn = 0.0 # (mmol cm-3 pw)-1 yr-1  #  
kO2Mn_ads = 1.0e6 # (mmol cm-3 pw)-1 yr-1  #  
kO2Fe = 1.0e7 # (mmol cm-3 pw)-1 yr-1 #  
kO2Fe_ads = 1.0e6 # (mmol cm-3 pw)-1 yr-1  #  
kO2H2S = 100000.0 # (mmol cm-3 pw)-1 yr-1  #  
kO2FeS = 100000.0 # (mmol cm-3 pw)-1 yr-1  #  
kO2CH4 = 1.0e10 # (mmol cm-3 pw)-1 yr-1  #  
kNO2NH4 = 1.0e8 # (mmol cm-3 pw)-1 yr-1  #  
kAOM = 0.04 # yr-1  #  
KAOM = 0.001 # mmol cm-3 pw #  
kMnO2Fe = 1.0e6 # (mmol cm-3 pw)-1 yr-1  #  
kMnO2H2S = 10000.0 # (mmol cm-3 pw)-1 yr-1  #  
kFeOOHH2S = 10.0 # (mmol cm-3 pw)-0.5 yr-1  #  
kFeSH2S = 1.0e7 # (mmol cm-3 pw)-1 yr-1  #  
kFeSdis = 0.001 # yr-1  #  
KspFeS = 0.0013465481745351092 # mmol cm-3 pw # apparent solubility of FeS  
kFeSpre = 2000.0 # (mmol cm-3 pw)-1 yr-1  #  
MCaCO3 = 100.09 # g/mol # Calcite molecular weight
SACaCO3 = 0.35 # m2/g # Calcite specific surface area
kCaCO3dis0 = 0.055368829236732454 # yr^-1  # close to equilibrium rate
kCaCO3dis1 = 175.09161176499725 # yr^-1  # far from equilibrum rate
nCaCO3dis = 5.0 # missing # far from equilibrium reaction order
KspCaCO3_dis = 7.863574397229617e-7 # (mmol cm^-3 pw)^2 # missing
kBSi_dis = 0.025 # yr-1  # depth dependent dissolution rate
H4SiO4_dis_sat = 0.00062 # mmol cm-3 pw # solubility of opal
KspNdPO4 = 1.167542472671615e-18 # (mmol cm^-3)^2 # missing
kNdPO4_pre = 1.0e-7 # mmol cm^-3  ds yr^-1 # missing
rAlSi = 0.0025 # missing # missing
rNdSi_lith = 1.9e-5 # dimensionless (mol/mol) # Nd:Si ratio in oceanic arc basalt
eNd_lith = 6.2 # missing # missing
rNdnrSi_lith = rNdSi_lith / ((eNd_lith / 1e4 + 1) * 0.512638 + 1) # missing # missing
rNdrSi_lith = rNdSi_lith - rNdnrSi_lith # missing # missing
a_lith0 = 10.0 # yr # missing
KspIllite = 4.334745915300865e18 # missing # missing
MIllite = 392.609 # g/mol # missing
kIllite = 6.8097245832e-8 # yr^-1 # missing
KspBasalt = 4.323907704303024 # mmol cm^-2 yr^-2 # missing
MBasalt = 88.16 # g/mol # missing
kBasalt = 174.13246746987554 # yr^-1 # missing

#----------------------------------------------
# Inital values
#----------------------------------------------
C_ini = [
    FMnO20 / (phis[1] * us[1]),
    FFeOOH0 / (phis[1] * us[1]),
    FPOC0 / (phis[1] * us[1]),
    FFeS0 / (phis[1] * us[1]),
    FFeS20 / (phis[1] * us[1]),
    FCaCO30 / (phis[1] * us[1]),
    Age0,
    FBSi0 / (phis[1] * us[1]),
    FNdnrPO40 / (phis[1] * us[1]),
    FNdrPO40 / (phis[1] * us[1]),
    FSurfMn_Ndnr0 / (phis[1] * us[1]),
    FSurfMn_Ndr0 / (phis[1] * us[1]),
    FSurfFe_Ndnr0 / (phis[1] * us[1]),
    FSurfFe_Ndr0 / (phis[1] * us[1]),
    FIllite0 / (phis[1] * us[1]),
    FBasalt0 / (phis[1] * us[1]),
    O2BW,
    NO3BW,
    CH4BW,
    NO2BW,
    CaBW,
    SO4BW,
    TMn_dis0,
    TFe_dis0,
    Al_disBW,
    TNH4_dis0,
    TNdnr_dis0,
    TNdr_dis0,
    TH4SiO4BW,
    TCO2BW,
    TH2SBW,
    TH3BO3BW,
    TH3PO4BW,
    HBW,
] #  # initial conditions
C0 = repeat(C_ini, outer = Ngrid) # initial conditions

#----------------------------------------------
# Indices
#----------------------------------------------
MnO2ID = ((1:Ngrid) .- 1)nspec .+ 1 #  # MnO2 index
FeOOHID = ((1:Ngrid) .- 1)nspec .+ 2 #  # FeOOH index
POCID = ((1:Ngrid) .- 1)nspec .+ 3 #  # POC index
FeSID = ((1:Ngrid) .- 1)nspec .+ 4 #  # FeS index
FeS2ID = ((1:Ngrid) .- 1)nspec .+ 5 #  # FeS2 index
CaCO3ID = ((1:Ngrid) .- 1)nspec .+ 6 #  # CaCO3 index
AgeID = ((1:Ngrid) .- 1)nspec .+ 7 #  # Age index
BSiID = ((1:Ngrid) .- 1)nspec .+ 8 #  # BSi index
NdnrPO4ID = ((1:Ngrid) .- 1)nspec .+ 9 #  # NdnrPO4 index
NdrPO4ID = ((1:Ngrid) .- 1)nspec .+ 10 #  # NdrPO4 index
SurfMn_NdnrID = ((1:Ngrid) .- 1)nspec .+ 11 #  # SurfMn_Ndnr index
SurfMn_NdrID = ((1:Ngrid) .- 1)nspec .+ 12 #  # SurfMn_Ndr index
SurfFe_NdnrID = ((1:Ngrid) .- 1)nspec .+ 13 #  # SurfFe_Ndnr index
SurfFe_NdrID = ((1:Ngrid) .- 1)nspec .+ 14 #  # SurfFe_Ndr index
IlliteID = ((1:Ngrid) .- 1)nspec .+ 15 #  # Illite index
BasaltID = ((1:Ngrid) .- 1)nspec .+ 16 #  # Basalt index
O2ID = ((1:Ngrid) .- 1)nspec .+ 17 #  # O2 index
NO3ID = ((1:Ngrid) .- 1)nspec .+ 18 #  # NO3 index
CH4ID = ((1:Ngrid) .- 1)nspec .+ 19 #  # CH4 index
NO2ID = ((1:Ngrid) .- 1)nspec .+ 20 #  # NO2 index
CaID = ((1:Ngrid) .- 1)nspec .+ 21 #  # Ca index
SO4ID = ((1:Ngrid) .- 1)nspec .+ 22 #  # SO4 index
TMnID = ((1:Ngrid) .- 1)nspec .+ 23 #  # TMn index
TFeID = ((1:Ngrid) .- 1)nspec .+ 24 #  # TFe index
AlID = ((1:Ngrid) .- 1)nspec .+ 25 #  # Al index
TNH4ID = ((1:Ngrid) .- 1)nspec .+ 26 #  # TNH4 index
TNdnrID = ((1:Ngrid) .- 1)nspec .+ 27 #  # TNdnr index
TNdrID = ((1:Ngrid) .- 1)nspec .+ 28 #  # TNdr index
TH4SiO4ID = ((1:Ngrid) .- 1)nspec .+ 29 #  # TH4SiO4 index
TCO2ID = ((1:Ngrid) .- 1)nspec .+ 30 #  # TCO2 index
TH2SID = ((1:Ngrid) .- 1)nspec .+ 31 #  # TH2S index
TH3BO3ID = ((1:Ngrid) .- 1)nspec .+ 32 #  # TH3BO3 index
TH3PO4ID = ((1:Ngrid) .- 1)nspec .+ 33 #  # TH3PO4 index
HID = ((1:Ngrid) .- 1)nspec .+ 34 #  # H index
IDdict = Dict(
    :MnO2ID => MnO2ID,
    :FeOOHID => FeOOHID,
    :POCID => POCID,
    :FeSID => FeSID,
    :FeS2ID => FeS2ID,
    :CaCO3ID => CaCO3ID,
    :AgeID => AgeID,
    :BSiID => BSiID,
    :NdnrPO4ID => NdnrPO4ID,
    :NdrPO4ID => NdrPO4ID,
    :SurfMn_NdnrID => SurfMn_NdnrID,
    :SurfMn_NdrID => SurfMn_NdrID,
    :SurfFe_NdnrID => SurfFe_NdnrID,
    :SurfFe_NdrID => SurfFe_NdrID,
    :IlliteID => IlliteID,
    :BasaltID => BasaltID,
    :O2ID => O2ID,
    :NO3ID => NO3ID,
    :CH4ID => CH4ID,
    :NO2ID => NO2ID,
    :CaID => CaID,
    :SO4ID => SO4ID,
    :TMnID => TMnID,
    :TFeID => TFeID,
    :AlID => AlID,
    :TNH4ID => TNH4ID,
    :TNdnrID => TNdnrID,
    :TNdrID => TNdrID,
    :TH4SiO4ID => TH4SiO4ID,
    :TCO2ID => TCO2ID,
    :TH2SID => TH2SID,
    :TH3BO3ID => TH3BO3ID,
    :TH3PO4ID => TH3PO4ID,
    :HID => HID,
)
