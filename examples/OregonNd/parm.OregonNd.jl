
#----------------------------------------------
# Number of substances
#----------------------------------------------
nsolid = 14 #  # number of solid substances
ndissolved = 13 #  # number of dissolved substances
nsummed = 5 #  # number of summed substances
nspec = 32 #  # number of total substances

#----------------------------------------------
# global parameters
#----------------------------------------------
depth = 3000.0 # m # water depth
salinity = 35.0 # psu # bottom water salinity
temp = 2.0 # Celsius # bottom water temperature
ds_rho = 2.6 # g cm^-3 # dry sediment density
Fsed = 0.01014 # g cm^-2 yr^-1 # total sediment flux
sw_dens = 1.0290834608199197 # g cm^-3 # seawater density

#----------------------------------------------
# grid parameters
#----------------------------------------------
L = 50.0 # cm # model sediment section thickness
Ngrid = 200 # integer # number of model grid
pgrid = L / 10 # cm # constant in gridtran, attenuation scale
Nmat = 5400 #  # Jacobian dimention
ξ = range(0, step = L / (Ngrid), length = Ngrid + 1) # cm # uniform grid
xᵥ = broadcast(x -> L * (exp(x * pgrid / L) - 1) / (exp(pgrid) - 1), ξ) # cm # no grid transformation
x = (xᵥ[2:(Ngrid+1)] .+ xᵥ[1:Ngrid]) / 2 # cm # cell center
dx = xᵥ[2:(Ngrid+1)] .- xᵥ[1:Ngrid] # cm # cell volume

#----------------------------------------------
# porosity parameters
#----------------------------------------------
phi0 = 0.8 # dimentionless # surface porosity
phiL = 0.7 # dimentionless # bottom porosity
xphi = 5.0 # cm # porosity attenuation scale
phi_Inf = 0.7 # dimentionless # porosity at infinite sediment depth (normally where porosity stops changing). Needed to calculate burial velocities. If constant_porosity_profile = yes, then phi_Inf should be the same as the porosity constant. If constant_porosity_profile = no, then phi_Inf should be consistent with the depth dependent porosity function
phif = broadcast(x -> phiL + (phi0 - phiL) * exp(-x / xphi), x) # dimentionless # fluid volume fraction
phis = 1.0 .- phif # dimentionless # solid volume fraction
pwtods = phif ./ phis # dimentionless # conversion from pore water to solid sediment volume unit
dstopw = phis ./ phif # dimentionless # conversion from solid sediment to pore water volume unit

#----------------------------------------------
# burial parameters
#----------------------------------------------
w_Inf = Fsed / ds_rho / (1 - phi_Inf) # cm yr^-1 # solid sediment burial velocity at infinite depth
uf = phi_Inf * w_Inf ./ phif # cm yr^-1 # pore water burial velocity
us = Fsed / ds_rho ./ phis # cm yr^-1 # solid sediment burial velocity

#----------------------------------------------
# bioturbation parameters
#----------------------------------------------
Dbt0 = 1.93554531569282 # cm2/yr # bioturbation coefficient
xbt = 6.0 # cm # attentuation scale of bioturbation
Ds = broadcast(x -> Dbt0 * erfc((x - xbt) / 1) / 2, x) # cm^2 yr^-1 # Bioturbation coefficient

#----------------------------------------------
# bioirrigation parameters
#----------------------------------------------
Dbir0 = 28.42212793142007 # yr^-1 # bioirrigation constant
xbir = 2.0 # cm # attentuation scale of bioirrigation
alpha = broadcast(x -> Dbir0 * exp(-x / xbir), x) # cm^2 yr^-1 # Bioirrigation coefficient

#----------------------------------------------
# adsorption parameters
#----------------------------------------------
KNH4_ads = 1.6 * ds_rho # cm^3(porewater) cm^-3(dry sediment) # Adsorption constant
KMn_ads_Mn = 10000.0 # (mmol cm-3 pw)^-1  # missing
KMn_ads_Fe = 100.0 # (mmol cm-3 pw)^-1  # missing
KFe_ads_Mn = 10000.0 # (mmol cm-3 pw)^-1  # missing
KFe_ads_Fe = 10000.0 # (mmol cm-3 pw)^-1  # missing
KNd_ads_Mn = 0.0 # (mmol cm-3 pw)^-1  # missing
KNd_ads_Fe = 0.0 # (mmol cm-3 pw)^-1  # missing
DNdMn = 0.025 # dimensionless # missing
DNdFe = 0.005 # dimensionless # missing

#----------------------------------------------
# solute diffusivity
#----------------------------------------------
DO2 = 4.0009939238351797E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DNO3 = 3.1390297096278300E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DCH4 = 3.0439844398127235E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DNO2 = 3.3485834640852744E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DCa = 1.2090579593914902E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DAl = 1.5108642413214525E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DSO4 = 1.6324420755402028E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DTH4SiO4 = 1.6311076543398931E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DHCO3 = 1.7136976129828849E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DCO3 = 1.4442713572518861E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DCO2 = 3.1525898772554984E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DH2S = 2.7982945790805405E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DHS = 3.3436959129609028E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DH3BO3 = 1.8018160505803172E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DH4BO4 = 1.5765890442577776E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DH3PO4 = 1.3173626795578821E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DH2PO4 = 1.3642377075902965E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DHPO4 = 1.1039756102174947E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DPO4 = 8.8770147296404019E+01 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DH = 1.7567691572664121E+03 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DOH = 8.5800959988348086E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DMn = 1.0660970890036131E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DFe = 1.1027537224364021E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DNH4 = 3.1543033068914923E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DNdnr = 9.8117588821765196E+01 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DNdr = 9.8117588821765196E+01 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient

#----------------------------------------------
# solute mass transfer velocities
#----------------------------------------------
delta = 0.05 # cm # thickness of the diffusive boundary layer
betaO2 = 8.0019878476703589E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaNO3 = 6.2780594192556600E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaCH4 = 6.0879688796254468E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaNO2 = 6.6971669281705481E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaCa = 2.4181159187829803E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaAl = 3.0217284826429050E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaSO4 = 3.2648841510804054E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaTH4SiO4 = 3.2622153086797862E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaHCO3 = 3.4273952259657699E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaCO3 = 2.8885427145037720E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaCO2 = 6.3051797545109966E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaH2S = 5.5965891581610804E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaHS = 6.6873918259218053E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaH3BO3 = 3.6036321011606342E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaH4BO4 = 3.1531780885155549E+03 # cm yr^-1 # solute mass transfer velocity across SWI
betaH3PO4 = 2.6347253591157641E+03 # cm yr^-1 # solute mass transfer velocity across SWI
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
Age0 = 0.0 # year # missing
CaBW = 0.01033 # mmol cm^-3 # Bottom water concentration of Ca
SO4BW = 0.028 # mmol cm^-3 # Bottom water concentration of SO4
TH3BO3BW = 8.7062e-5 # mmol cm^-3 # Bottom water concentration of TH3BO3
Mn0 = 5.0e-10 # mmol cm^-3 # Concentration of Mn at the TOP of sediment column
Fe0 = 5.0e-10 # mmol cm^-3 # Concentration of Fe at the TOP of sediment column
AlBW = 5.0e-10 # mmol cm^-3 # Bottom water concentration of Al
CH4BW = 0.0 # mmol cm^-3 # Bottom water concentration of CH4
O2BW = 8.0e-5 # mmol cm^-3 # Bottom water concentration of O2
NO3BW = 4.0e-5 # mmol cm^-3 # Bottom water concentration of NO3
NO2BW = 5.0e-8 # mmol cm^-3 # Bottom water concentration of NO2
NH40 = 0.0 # mmol cm^-3 # Concentration of NH4 at the TOP of sediment column
NH4_ads0 = NH40 * KNH4_ads # missing # missing
TH3PO4BW = 2.8e-6 # mmol cm^-3 # Bottom water concentration of H3PO4
TH4SiO4BW = 0.00019 # mmol cm^-3 # Bottom water concentration of H4SiO4
pHBW = 7.7 # free pH scale # Bottom water pH
TCO2BW = 0.00238 # mmol cm^-3 # Bottom water concentration of TCO2
TH2SBW = 0.0 # mmol cm^-3 # Bottom water concentration of TH2S
FMn_ads_Mn0 = KMn_ads_Mn * FMnO20 * Mn0 # mmol cm^-2 yr^-1 # missing
FMn_ads_Fe0 = KMn_ads_Fe * FFeOOH0 * Mn0 # mmol cm^-2 yr^-1 # missing
FFe_ads_Mn0 = KFe_ads_Mn * FMnO20 * Fe0 # mmol cm^-2 yr^-1 # missing
FFe_ads_Fe0 = KFe_ads_Fe * FFeOOH0 * Fe0 # mmol cm^-2 yr^-1 # missing
eNd_MnO2 = -2.4 # missing # missing
eNd_FeOOH = -2.4 # missing # missing
Nd0 = 3.5e-11 # mmol cm^-3 # Bottom water concentration of Nd
eNd0 = -2.4 # epsilon # Bottom water eNd
Ndnr0 = 2.3140266884232977e-11 # mmol cm^-3 # Bottom water concentration of Nd144
Ndr0 = 1.1859733115767025e-11 # mmol cm^-3 # Bottom water concentration of Nd143
eNdPO4 = -2.4 # epsilon # missing
FNdnrPO40 = 1.0e-14 # mmol cm^-2 yr^-1 # missing
FNdrPO40 = 5.1251496688e-15 # mmol cm^-2 yr^-1 # missing
FNdnr_ads_Mn0 = KNd_ads_Mn * FMnO20 * Ndnr0 # mmol cm^-2 yr^-1 # missing
FNdr_ads_Mn0 = KNd_ads_Mn * FMnO20 * Ndr0 # mmol cm^-2 yr^-1 # missing
FNdnr_ads_Fe0 = KNd_ads_Fe * FFeOOH0 * Ndnr0 # mmol cm^-2 yr^-1 # missing
FNdr_ads_Fe0 = KNd_ads_Fe * FFeOOH0 * Ndr0 # mmol cm^-2 yr^-1 # missing
FSurfMn_Ndnr0 = FMnO20 * Ndnr0 / Mn0 * DNdMn # mmol cm^-2 yr^-1 # missing
FSurfMn_Ndr0 = FMnO20 * Ndr0 / Mn0 * DNdMn # mmol cm^-2 yr^-1 # missing
FSurfFe_Ndnr0 = FFeOOH0 * Ndnr0 / Fe0 * DNdFe # mmol cm^-2 yr^-1 # missing
FSurfFe_Ndr0 = FFeOOH0 * Ndr0 / Fe0 * DNdFe # mmol cm^-2 yr^-1 # missing
H4SiO4BW = 1.8821161451549316E-04 # mmol cm^-3 # Bottom water concentration of H4SiO4
H3SiO4BW = 1.7883854845068651E-06 # mmol cm^-3 # Bottom water concentration of H3SiO4
HCO3BW = 2.2792389384405274E-03 # mmol cm^-3 # Bottom water concentration of HCO3
CO3BW = 5.4445170729534302E-05 # mmol cm^-3 # Bottom water concentration of CO3
CO2BW = 4.6315890829938746E-05 # mmol cm^-3 # Bottom water concentration of CO2
H2SBW = 0.0000000000000000E+00 # mmol cm^-3 # Bottom water concentration of H2S
HSBW = 0.0000000000000000E+00 # mmol cm^-3 # Bottom water concentration of HS
H3BO3BW = 8.0401874786495146E-05 # mmol cm^-3 # Bottom water concentration of H3BO3
H4BO4BW = 6.6601252135048620E-06 # mmol cm^-3 # Bottom water concentration of H4BO4
H3PO4BW = 5.2618094499704676E-14 # mmol cm^-3 # Bottom water concentration of H3PO4
H2PO4BW = 6.8320353691652710E-08 # mmol cm^-3 # Bottom water concentration of H2PO4
HPO4BW = 2.6579696478238114E-06 # mmol cm^-3 # Bottom water concentration of HPO4
PO4BW = 7.3709945866440870E-08 # mmol cm^-3 # Bottom water concentration of PO4
HBW = 1.9952623149688786E-08 # mmol cm^-3 # Bottom water concentration of H
OHBW = 3.7078098494959277E-07 # mmol cm^-3 # Bottom water concentration of OH

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
BcAl = ((betaAl + phif[1]uf[1], -phif[1]DAl[1], betaAl * AlBW), (0.0, 1.0, 0.0)) #  # Boundary condition of Al
BcSO4 = (
    (betaSO4 + phif[1]uf[1], -phif[1]DSO4[1], betaSO4 * SO4BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of SO4
BcTH4SiO4 = (
    (betaTH4SiO4 + phif[1]uf[1], -phif[1]DTH4SiO4[1], betaTH4SiO4 * TH4SiO4BW),
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
BcMn = ((1.0, 0.0, Mn0), (0.0, 1.0, 0.0)) #  # Boundary condition of TMn
BcFe = ((1.0, 0.0, Fe0), (0.0, 1.0, 0.0)) #  # Boundary condition of TFe
BcNH4 = ((1.0, 0.0, NH40), (0.0, 1.0, 0.0)) #  # Boundary condition of TNH4
BcNdnr = ((1.0, 0.0, Ndnr0), (0.0, 1.0, 0.0)) #  # Boundary condition of TNdnr
BcNdr = ((1.0, 0.0, Ndr0), (0.0, 1.0, 0.0)) #  # Boundary condition of TNdr
BcNdnr_ads_Mn = ((phis[1]us[1], -phis[1]Ds[1], FNdnr_ads_Mn0), (0.0, 1.0, 0.0)) #  # Boundary condition of Ndnr_ads_Mn
BcNdnr_ads_Fe = ((phis[1]us[1], -phis[1]Ds[1], FNdnr_ads_Fe0), (0.0, 1.0, 0.0)) #  # Boundary condition of Ndnr_ads_Fe
BcNdr_ads_Mn = ((phis[1]us[1], -phis[1]Ds[1], FNdr_ads_Mn0), (0.0, 1.0, 0.0)) #  # Boundary condition of Ndr_ads_Mn
BcNdr_ads_Fe = ((phis[1]us[1], -phis[1]Ds[1], FNdr_ads_Fe0), (0.0, 1.0, 0.0)) #  # Boundary condition of Ndr_ads_Fe
BcFe_ads_Mn = ((phis[1]us[1], -phis[1]Ds[1], FFe_ads_Mn0), (0.0, 1.0, 0.0)) #  # Boundary condition of Fe_ads_Mn
BcFe_ads_Fe = ((phis[1]us[1], -phis[1]Ds[1], FFe_ads_Fe0), (0.0, 1.0, 0.0)) #  # Boundary condition of Fe_ads_Fe
BcMn_ads_Mn = ((phis[1]us[1], -phis[1]Ds[1], FMn_ads_Mn0), (0.0, 1.0, 0.0)) #  # Boundary condition of Mn_ads_Mn
BcMn_ads_Fe = ((phis[1]us[1], -phis[1]Ds[1], FMn_ads_Fe0), (0.0, 1.0, 0.0)) #  # Boundary condition of Mn_ads_Fe
BcNH4_ads = ((1.0, 0.0, NH4_ads0), (0.0, 1.0, 0.0)) #  # Boundary condition of NH4_ads

#----------------------------------------------
# Boundary transport matrix
#----------------------------------------------
BcAmMnO2, BcBmMnO2, BcCmMnO2 = fvcf_bc(phis, Ds, us, dx, BcMnO2, Ngrid) #  # Boundary transport matrix of MnO2
BcAmFeOOH, BcBmFeOOH, BcCmFeOOH = fvcf_bc(phis, Ds, us, dx, BcFeOOH, Ngrid) #  # Boundary transport matrix of FeOOH
BcAmPOC, BcBmPOC, BcCmPOC = fvcf_bc(phis, Ds, us, dx, BcPOC, Ngrid) #  # Boundary transport matrix of POC
BcAmFeS, BcBmFeS, BcCmFeS = fvcf_bc(phis, Ds, us, dx, BcFeS, Ngrid) #  # Boundary transport matrix of FeS
BcAmFeS2, BcBmFeS2, BcCmFeS2 = fvcf_bc(phis, Ds, us, dx, BcFeS2, Ngrid) #  # Boundary transport matrix of FeS2
BcAmCaCO3, BcBmCaCO3, BcCmCaCO3 = fvcf_bc(phis, Ds, us, dx, BcCaCO3, Ngrid) #  # Boundary transport matrix of CaCO3
BcAmAge, BcBmAge, BcCmAge = fvcf_bc(phis, Ds, us, dx, BcAge, Ngrid) #  # Boundary transport matrix of Age
BcAmBSi, BcBmBSi, BcCmBSi = fvcf_bc(phis, Ds, us, dx, BcBSi, Ngrid) #  # Boundary transport matrix of BSi
BcAmNdnrPO4, BcBmNdnrPO4, BcCmNdnrPO4 =
    fvcf_bc(phis, Ds, us, dx, BcNdnrPO4, Ngrid) #  # Boundary transport matrix of NdnrPO4
BcAmNdrPO4, BcBmNdrPO4, BcCmNdrPO4 = fvcf_bc(phis, Ds, us, dx, BcNdrPO4, Ngrid) #  # Boundary transport matrix of NdrPO4
BcAmSurfMn_Ndnr, BcBmSurfMn_Ndnr, BcCmSurfMn_Ndnr =
    fvcf_bc(phis, Ds, us, dx, BcSurfMn_Ndnr, Ngrid) #  # Boundary transport matrix of SurfMn_Ndnr
BcAmSurfMn_Ndr, BcBmSurfMn_Ndr, BcCmSurfMn_Ndr =
    fvcf_bc(phis, Ds, us, dx, BcSurfMn_Ndr, Ngrid) #  # Boundary transport matrix of SurfMn_Ndr
BcAmSurfFe_Ndnr, BcBmSurfFe_Ndnr, BcCmSurfFe_Ndnr =
    fvcf_bc(phis, Ds, us, dx, BcSurfFe_Ndnr, Ngrid) #  # Boundary transport matrix of SurfFe_Ndnr
BcAmSurfFe_Ndr, BcBmSurfFe_Ndr, BcCmSurfFe_Ndr =
    fvcf_bc(phis, Ds, us, dx, BcSurfFe_Ndr, Ngrid) #  # Boundary transport matrix of SurfFe_Ndr
BcAmO2, BcBmO2, BcCmO2 = fvcf_bc(phif, DO2, uf, dx, BcO2, Ngrid) #  # Boundary transport matrix of O2
BcAmNO3, BcBmNO3, BcCmNO3 = fvcf_bc(phif, DNO3, uf, dx, BcNO3, Ngrid) #  # Boundary transport matrix of NO3
BcAmCH4, BcBmCH4, BcCmCH4 = fvcf_bc(phif, DCH4, uf, dx, BcCH4, Ngrid) #  # Boundary transport matrix of CH4
BcAmNO2, BcBmNO2, BcCmNO2 = fvcf_bc(phif, DNO2, uf, dx, BcNO2, Ngrid) #  # Boundary transport matrix of NO2
BcAmCa, BcBmCa, BcCmCa = fvcf_bc(phif, DCa, uf, dx, BcCa, Ngrid) #  # Boundary transport matrix of Ca
BcAmAl, BcBmAl, BcCmAl = fvcf_bc(phif, DAl, uf, dx, BcAl, Ngrid) #  # Boundary transport matrix of Al
BcAmSO4, BcBmSO4, BcCmSO4 = fvcf_bc(phif, DSO4, uf, dx, BcSO4, Ngrid) #  # Boundary transport matrix of SO4
BcAmTH4SiO4, BcBmTH4SiO4, BcCmTH4SiO4 =
    fvcf_bc(phif, DTH4SiO4, uf, dx, BcTH4SiO4, Ngrid) #  # Boundary transport matrix of TH4SiO4
BcAmHCO3, BcBmHCO3, BcCmHCO3 = fvcf_bc(phif, DHCO3, uf, dx, BcHCO3, Ngrid) #  # Boundary transport matrix of HCO3
BcAmCO3, BcBmCO3, BcCmCO3 = fvcf_bc(phif, DCO3, uf, dx, BcCO3, Ngrid) #  # Boundary transport matrix of CO3
BcAmCO2, BcBmCO2, BcCmCO2 = fvcf_bc(phif, DCO2, uf, dx, BcCO2, Ngrid) #  # Boundary transport matrix of CO2
BcAmH2S, BcBmH2S, BcCmH2S = fvcf_bc(phif, DH2S, uf, dx, BcH2S, Ngrid) #  # Boundary transport matrix of H2S
BcAmHS, BcBmHS, BcCmHS = fvcf_bc(phif, DHS, uf, dx, BcHS, Ngrid) #  # Boundary transport matrix of HS
BcAmH3BO3, BcBmH3BO3, BcCmH3BO3 = fvcf_bc(phif, DH3BO3, uf, dx, BcH3BO3, Ngrid) #  # Boundary transport matrix of H3BO3
BcAmH4BO4, BcBmH4BO4, BcCmH4BO4 = fvcf_bc(phif, DH4BO4, uf, dx, BcH4BO4, Ngrid) #  # Boundary transport matrix of H4BO4
BcAmH3PO4, BcBmH3PO4, BcCmH3PO4 = fvcf_bc(phif, DH3PO4, uf, dx, BcH3PO4, Ngrid) #  # Boundary transport matrix of H3PO4
BcAmH2PO4, BcBmH2PO4, BcCmH2PO4 = fvcf_bc(phif, DH2PO4, uf, dx, BcH2PO4, Ngrid) #  # Boundary transport matrix of H2PO4
BcAmHPO4, BcBmHPO4, BcCmHPO4 = fvcf_bc(phif, DHPO4, uf, dx, BcHPO4, Ngrid) #  # Boundary transport matrix of HPO4
BcAmPO4, BcBmPO4, BcCmPO4 = fvcf_bc(phif, DPO4, uf, dx, BcPO4, Ngrid) #  # Boundary transport matrix of PO4
BcAmH, BcBmH, BcCmH = fvcf_bc(phif, DH, uf, dx, BcH, Ngrid) #  # Boundary transport matrix of H
BcAmOH, BcBmOH, BcCmOH = fvcf_bc(phif, DOH, uf, dx, BcOH, Ngrid) #  # Boundary transport matrix of OH
BcAmMn, BcBmMn, BcCmMn = fvcf_bc(phif, DMn, uf, dx, BcMn, Ngrid) #  # Boundary transport matrix of Mn
BcAmFe, BcBmFe, BcCmFe = fvcf_bc(phif, DFe, uf, dx, BcFe, Ngrid) #  # Boundary transport matrix of Fe
BcAmNH4, BcBmNH4, BcCmNH4 = fvcf_bc(phif, DNH4, uf, dx, BcNH4, Ngrid) #  # Boundary transport matrix of NH4
BcAmNdnr, BcBmNdnr, BcCmNdnr = fvcf_bc(phif, DNdnr, uf, dx, BcNdnr, Ngrid) #  # Boundary transport matrix of Ndnr
BcAmNdr, BcBmNdr, BcCmNdr = fvcf_bc(phif, DNdr, uf, dx, BcNdr, Ngrid) #  # Boundary transport matrix of Ndr
BcAmNdnr_ads_Mn, BcBmNdnr_ads_Mn, BcCmNdnr_ads_Mn =
    fvcf_bc(phis, Ds, us, dx, BcNdnr_ads_Mn, Ngrid) #  # Boundary transport matrix of Ndnr_ads_Mn
BcAmNdnr_ads_Fe, BcBmNdnr_ads_Fe, BcCmNdnr_ads_Fe =
    fvcf_bc(phis, Ds, us, dx, BcNdnr_ads_Fe, Ngrid) #  # Boundary transport matrix of Ndnr_ads_Fe
BcAmNdr_ads_Mn, BcBmNdr_ads_Mn, BcCmNdr_ads_Mn =
    fvcf_bc(phis, Ds, us, dx, BcNdr_ads_Mn, Ngrid) #  # Boundary transport matrix of Ndr_ads_Mn
BcAmNdr_ads_Fe, BcBmNdr_ads_Fe, BcCmNdr_ads_Fe =
    fvcf_bc(phis, Ds, us, dx, BcNdr_ads_Fe, Ngrid) #  # Boundary transport matrix of Ndr_ads_Fe
BcAmFe_ads_Mn, BcBmFe_ads_Mn, BcCmFe_ads_Mn =
    fvcf_bc(phis, Ds, us, dx, BcFe_ads_Mn, Ngrid) #  # Boundary transport matrix of Fe_ads_Mn
BcAmFe_ads_Fe, BcBmFe_ads_Fe, BcCmFe_ads_Fe =
    fvcf_bc(phis, Ds, us, dx, BcFe_ads_Fe, Ngrid) #  # Boundary transport matrix of Fe_ads_Fe
BcAmMn_ads_Mn, BcBmMn_ads_Mn, BcCmMn_ads_Mn =
    fvcf_bc(phis, Ds, us, dx, BcMn_ads_Mn, Ngrid) #  # Boundary transport matrix of Mn_ads_Mn
BcAmMn_ads_Fe, BcBmMn_ads_Fe, BcCmMn_ads_Fe =
    fvcf_bc(phis, Ds, us, dx, BcMn_ads_Fe, Ngrid) #  # Boundary transport matrix of Mn_ads_Fe
BcAmNH4_ads, BcBmNH4_ads, BcCmNH4_ads =
    fvcf_bc(phis, Ds, us, dx, BcNH4_ads, Ngrid) #  # Boundary transport matrix of NH4_ads

#----------------------------------------------
# Interior transport matrix
#----------------------------------------------
AmMnO2, BmMnO2 = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of MnO2
AmFeOOH, BmFeOOH = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of FeOOH
AmPOC, BmPOC = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of POC
AmFeS, BmFeS = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of FeS
AmFeS2, BmFeS2 = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of FeS2
AmCaCO3, BmCaCO3 = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of CaCO3
AmAge, BmAge = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Age
AmBSi, BmBSi = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of BSi
AmNdnrPO4, BmNdnrPO4 = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of NdnrPO4
AmNdrPO4, BmNdrPO4 = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of NdrPO4
AmSurfMn_Ndnr, BmSurfMn_Ndnr = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of SurfMn_Ndnr
AmSurfMn_Ndr, BmSurfMn_Ndr = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of SurfMn_Ndr
AmSurfFe_Ndnr, BmSurfFe_Ndnr = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of SurfFe_Ndnr
AmSurfFe_Ndr, BmSurfFe_Ndr = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of SurfFe_Ndr
AmO2, BmO2 = fvcf(phif, DO2, uf, dx, Ngrid) #  # Interior transport matrix of O2
AmNO3, BmNO3 = fvcf(phif, DNO3, uf, dx, Ngrid) #  # Interior transport matrix of NO3
AmCH4, BmCH4 = fvcf(phif, DCH4, uf, dx, Ngrid) #  # Interior transport matrix of CH4
AmNO2, BmNO2 = fvcf(phif, DNO2, uf, dx, Ngrid) #  # Interior transport matrix of NO2
AmCa, BmCa = fvcf(phif, DCa, uf, dx, Ngrid) #  # Interior transport matrix of Ca
AmAl, BmAl = fvcf(phif, DAl, uf, dx, Ngrid) #  # Interior transport matrix of Al
AmSO4, BmSO4 = fvcf(phif, DSO4, uf, dx, Ngrid) #  # Interior transport matrix of SO4
AmTH4SiO4, BmTH4SiO4 = fvcf(phif, DTH4SiO4, uf, dx, Ngrid) #  # Interior transport matrix of TH4SiO4
AmHCO3, BmHCO3 = fvcf(phif, DHCO3, uf, dx, Ngrid) #  # Interior transport matrix of HCO3
AmCO3, BmCO3 = fvcf(phif, DCO3, uf, dx, Ngrid) #  # Interior transport matrix of CO3
AmCO2, BmCO2 = fvcf(phif, DCO2, uf, dx, Ngrid) #  # Interior transport matrix of CO2
AmH2S, BmH2S = fvcf(phif, DH2S, uf, dx, Ngrid) #  # Interior transport matrix of H2S
AmHS, BmHS = fvcf(phif, DHS, uf, dx, Ngrid) #  # Interior transport matrix of HS
AmH3BO3, BmH3BO3 = fvcf(phif, DH3BO3, uf, dx, Ngrid) #  # Interior transport matrix of H3BO3
AmH4BO4, BmH4BO4 = fvcf(phif, DH4BO4, uf, dx, Ngrid) #  # Interior transport matrix of H4BO4
AmH3PO4, BmH3PO4 = fvcf(phif, DH3PO4, uf, dx, Ngrid) #  # Interior transport matrix of H3PO4
AmH2PO4, BmH2PO4 = fvcf(phif, DH2PO4, uf, dx, Ngrid) #  # Interior transport matrix of H2PO4
AmHPO4, BmHPO4 = fvcf(phif, DHPO4, uf, dx, Ngrid) #  # Interior transport matrix of HPO4
AmPO4, BmPO4 = fvcf(phif, DPO4, uf, dx, Ngrid) #  # Interior transport matrix of PO4
AmH, BmH = fvcf(phif, DH, uf, dx, Ngrid) #  # Interior transport matrix of H
AmOH, BmOH = fvcf(phif, DOH, uf, dx, Ngrid) #  # Interior transport matrix of OH
AmMn, BmMn = fvcf(phif, DMn, uf, dx, Ngrid) #  # Interior transport matrix of Mn
AmFe, BmFe = fvcf(phif, DFe, uf, dx, Ngrid) #  # Interior transport matrix of Fe
AmNH4, BmNH4 = fvcf(phif, DNH4, uf, dx, Ngrid) #  # Interior transport matrix of NH4
AmNdnr, BmNdnr = fvcf(phif, DNdnr, uf, dx, Ngrid) #  # Interior transport matrix of Ndnr
AmNdr, BmNdr = fvcf(phif, DNdr, uf, dx, Ngrid) #  # Interior transport matrix of Ndr
AmNdnr_ads_Mn, BmNdnr_ads_Mn = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Ndnr_ads_Mn
AmNdnr_ads_Fe, BmNdnr_ads_Fe = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Ndnr_ads_Fe
AmNdr_ads_Mn, BmNdr_ads_Mn = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Ndr_ads_Mn
AmNdr_ads_Fe, BmNdr_ads_Fe = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Ndr_ads_Fe
AmFe_ads_Mn, BmFe_ads_Mn = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Fe_ads_Mn
AmFe_ads_Fe, BmFe_ads_Fe = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Fe_ads_Fe
AmMn_ads_Mn, BmMn_ads_Mn = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Mn_ads_Mn
AmMn_ads_Fe, BmMn_ads_Fe = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Mn_ads_Fe
AmNH4_ads, BmNH4_ads = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of NH4_ads

#----------------------------------------------
# Acid dissociation constants
#----------------------------------------------
KH4SiO4 = 1.8958968983182348E-10 #  # TH4SiO4 1th dissociation constant
KCO2 = 9.8188321096491129E-07 #  # TCO2 1th dissociation constant
KHCO3 = 4.7661697752063493E-10 #  # TCO2 2th dissociation constant
KH2S = 7.7624695805430366E-07 #  # TH2S 1th dissociation constant
KH3BO3 = 1.6527844514531606E-09 #  # TH3BO3 1th dissociation constant
KH3PO4 = 2.5906872600083352E-02 #  # TH3PO4 1th dissociation constant
KH2PO4 = 7.7624695805430366E-07 #  # TH3PO4 2th dissociation constant
KHPO4 = 5.5331962630242337E-10 #  # TH3PO4 3th dissociation constant
KH2O = 7.3980532637696545E-15 #  # H 1th dissociation constant

#----------------------------------------------
# Reaction parameters
#----------------------------------------------
Cl = 0.565772678 # mmol cm-3 # bottom water Cl concentration
nu = 0.125 # dimentionless # POC reactivity
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
kBSi_dis = broadcast(x -> 0.025, x) # yr-1  # depth dependent dissolution rate
H4SiO4_dis_sat = 0.00062 # mmol cm-3 pw # solubility of opal
KspNdPO4 = 1.167542472671615e-18 # (mmol cm^-3)^2 # missing
kNdPO4_pre = 1.0e-7 # mmol cm^-3  ds yr^-1 # missing
rAlSi = 0.0025 # missing # missing

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
    O2BW,
    NO3BW,
    Mn0,
    Fe0,
    CH4BW,
    NO2BW,
    CaBW,
    AlBW,
    NH40,
    SO4BW,
    Ndnr0,
    Ndr0,
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
O2ID = ((1:Ngrid) .- 1)nspec .+ 15 #  # O2 index
NO3ID = ((1:Ngrid) .- 1)nspec .+ 16 #  # NO3 index
TMnID = ((1:Ngrid) .- 1)nspec .+ 17 #  # TMn index
TFeID = ((1:Ngrid) .- 1)nspec .+ 18 #  # TFe index
CH4ID = ((1:Ngrid) .- 1)nspec .+ 19 #  # CH4 index
NO2ID = ((1:Ngrid) .- 1)nspec .+ 20 #  # NO2 index
CaID = ((1:Ngrid) .- 1)nspec .+ 21 #  # Ca index
AlID = ((1:Ngrid) .- 1)nspec .+ 22 #  # Al index
TNH4ID = ((1:Ngrid) .- 1)nspec .+ 23 #  # TNH4 index
SO4ID = ((1:Ngrid) .- 1)nspec .+ 24 #  # SO4 index
TNdnrID = ((1:Ngrid) .- 1)nspec .+ 25 #  # TNdnr index
TNdrID = ((1:Ngrid) .- 1)nspec .+ 26 #  # TNdr index
TH4SiO4ID = ((1:Ngrid) .- 1)nspec .+ 27 #  # TH4SiO4 index
TCO2ID = ((1:Ngrid) .- 1)nspec .+ 28 #  # TCO2 index
TH2SID = ((1:Ngrid) .- 1)nspec .+ 29 #  # TH2S index
TH3BO3ID = ((1:Ngrid) .- 1)nspec .+ 30 #  # TH3BO3 index
TH3PO4ID = ((1:Ngrid) .- 1)nspec .+ 31 #  # TH3PO4 index
HID = ((1:Ngrid) .- 1)nspec .+ 32 #  # H index
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
    :O2ID => O2ID,
    :NO3ID => NO3ID,
    :TMnID => TMnID,
    :TFeID => TFeID,
    :CH4ID => CH4ID,
    :NO2ID => NO2ID,
    :CaID => CaID,
    :AlID => AlID,
    :TNH4ID => TNH4ID,
    :SO4ID => SO4ID,
    :TNdnrID => TNdnrID,
    :TNdrID => TNdrID,
    :TH4SiO4ID => TH4SiO4ID,
    :TCO2ID => TCO2ID,
    :TH2SID => TH2SID,
    :TH3BO3ID => TH3BO3ID,
    :TH3PO4ID => TH3PO4ID,
    :HID => HID,
)
