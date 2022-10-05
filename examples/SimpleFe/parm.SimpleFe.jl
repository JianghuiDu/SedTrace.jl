
#----------------------------------------------
# Number of substances
#----------------------------------------------
nsolid = 3 #  # number of solid substances
ndissolved = 2 #  # number of dissolved substances
nsummed = 3 #  # number of summed substances
nspec = 8 #  # number of total substances

#----------------------------------------------
# global parameters
#----------------------------------------------
depth = 500.0 # m # water depth
salinity = 35.0 # psu # bottom water salinity
temp = 5.0 # Celsius # bottom water temperature
ds_rho = 2.6 # g cm^-3 # dry sediment density
sw_dens = 1.0287324258804407 # g cm^-3 # seawater density

#----------------------------------------------
# grid parameters
#----------------------------------------------
L = 50.0 # cm # model sediment section thickness
Ngrid = 200 # integer # number of model grid
Nmat = 1600 # integer # Jacobian dimension
ξ = range(0, step = L / (Ngrid), length = Ngrid + 1) # cm # uniform grid
xᵥ = broadcast(x -> L * (exp(x / 5) - 1) / (exp(L / 5) - 1), ξ) # cm # non-uniform grid transformation
x = (xᵥ[2:(Ngrid+1)] .+ xᵥ[1:Ngrid]) / 2 # cm # cell center
dx = xᵥ[2:(Ngrid+1)] .- xᵥ[1:Ngrid] # cm # cell volume

#----------------------------------------------
# porosity parameters
#----------------------------------------------
phi_Inf = 0.7884 # dimensionless # porosity at burial depth
phif = broadcast(x -> 0.8 + (0.9 - 0.8) * exp(-x / 2), x) # dimensionless # fluid volume fraction
phis = 1.0 .- phif # dimensionless # solid volume fraction
pwtods = phif ./ phis # dimensionless # conversion from pore water to solid sediment volume unit
dstopw = phis ./ phif # dimensionless # conversion from solid sediment to pore water volume unit

#----------------------------------------------
# burial parameters
#----------------------------------------------
Fsed = 0.073 # g cm^-2 yr^-1 # total sediment flux
w_Inf = Fsed / ds_rho / (1 - phi_Inf) # cm yr^-1 # solid sediment burial velocity at infinite depth
uf = phi_Inf * w_Inf ./ phif # cm yr^-1 # pore water burial velocity
us = Fsed / ds_rho ./ phis # cm yr^-1 # solid sediment burial velocity

#----------------------------------------------
# bioturbation parameters
#----------------------------------------------
Ds = broadcast(x -> 10 * exp(-x / 3), x) # cm^2 yr^-1 # Bioturbation coefficient

#----------------------------------------------
# bioirrigation parameters
#----------------------------------------------
alpha = broadcast(x -> 10 * exp(-x / 2), x) # cm^2 yr^-1 # Bioirrigation coefficient

#----------------------------------------------
# adsorption parameters
#----------------------------------------------
KFe_ads = 1.0 # cm^3(porewater) cm^-3(dry sediment) # Adsorption constant

#----------------------------------------------
# solute diffusivity
#----------------------------------------------
DSO4 = 1.8034511184582917E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DTFe_dis = 1.2122535663809046E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DH = 1.8564498889096735E+03 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DOH = 9.3665996003371845E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DHCO3 = 1.9213920442515075E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DCO3 = 1.5899631135414575E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DCO2 = 3.3679572156139625E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DH2S = 3.0488407320129431E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DHS = 3.5128480809042725E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient

#----------------------------------------------
# boundary fluxes and concentrations
#----------------------------------------------
FPOC0 = 0.31 # mmol cm^-2 yr^-1 # Flux of POC at the  TOP of sediment column
FFeOOH0 = 0.023 # mmol cm^-2 yr^-1 # Flux of FeOOH at the  TOP of sediment column
FFeS0 = 2.22044604925031e-16 # mmol cm^-2 yr^-1 # Flux of FeS at the  TOP of sediment column
FTFe_ads_POC0 = 0.0 # mmol cm^-2 yr^-1 # Flux of Fe_ads at the  TOP of sediment column
SO40 = 0.028 # mmol cm^-3 # Concentration of SO4 at the TOP of sediment column
TFe_dis0 = 2.95e-8 # mmol cm^-3 # Concentration of Fe at the TOP of sediment column
pH0 = 7.59 # free pH scale # pH at the TOP of sediment column
TCO20 = 0.002345 # mmol cm^-3 # Concentration of TCO2 at the TOP of sediment column
TH2S0 = 2.22044604925031e-16 # mmol cm^-3 # Concentration of TH2S at the TOP of sediment column
H0 = 2.5703957827688646E-08 # mmol cm^-3 # Concentration of H at the TOP of sediment column
OH0 = 3.0908033358399629E-07 # mmol cm^-3 # Concentration of OH at the TOP of sediment column
HCO30 = 2.2360098054873194E-03 # mmol cm^-3 # Concentration of HCO3 at the TOP of sediment column
CO30 = 4.0322146597767730E-05 # mmol cm^-3 # Concentration of CO3 at the TOP of sediment column
CO20 = 6.8668047914912883E-05 # mmol cm^-3 # Concentration of CO2 at the TOP of sediment column
H2S0 = 3.7022702176678322E-17 # mmol cm^-3 # Concentration of H2S at the TOP of sediment column
HS0 = 1.8502190274835269E-16 # mmol cm^-3 # Concentration of HS at the TOP of sediment column

#----------------------------------------------
# assemble boundary conditions
#----------------------------------------------
BcPOC = ((phis[1]us[1], -phis[1]Ds[1], FPOC0), (0.0, 1.0, 0.0)) #  # Boundary condition of POC
BcFeOOH = ((phis[1]us[1], -phis[1]Ds[1], FFeOOH0), (0.0, 1.0, 0.0)) #  # Boundary condition of FeOOH
BcFeS = ((phis[1]us[1], -phis[1]Ds[1], FFeS0), (0.0, 1.0, 0.0)) #  # Boundary condition of FeS
BcSO4 = ((1.0, 0.0, SO40), (0.0, 1.0, 0.0)) #  # Boundary condition of SO4
BcTFe_dis = ((1.0, 0.0, TFe_dis0), (0.0, 1.0, 0.0)) #  # Boundary condition of TFe_dis
BcH = ((1.0, 0.0, H0), (0.0, 1.0, 0.0)) #  # Boundary condition of H
BcOH = ((1.0, 0.0, OH0), (0.0, 1.0, 0.0)) #  # Boundary condition of H
BcHCO3 = ((1.0, 0.0, HCO30), (0.0, 1.0, 0.0)) #  # Boundary condition of TCO2
BcCO3 = ((1.0, 0.0, CO30), (0.0, 1.0, 0.0)) #  # Boundary condition of TCO2
BcCO2 = ((1.0, 0.0, CO20), (0.0, 1.0, 0.0)) #  # Boundary condition of TCO2
BcH2S = ((1.0, 0.0, H2S0), (0.0, 1.0, 0.0)) #  # Boundary condition of TH2S
BcHS = ((1.0, 0.0, HS0), (0.0, 1.0, 0.0)) #  # Boundary condition of TH2S
BcTFe_ads_POC = ((phis[1]us[1], -phis[1]Ds[1], FTFe_ads_POC0), (0.0, 1.0, 0.0)) #  # Boundary condition of TFe_ads_POC

#----------------------------------------------
# Boundary transport matrix
#----------------------------------------------
BcAmPOC, BcBmPOC, BcCmPOC = fvcf_bc(phis, Ds, us, dx, BcPOC, Ngrid) #  # Boundary transport matrix of POC
BcAmFeOOH, BcBmFeOOH, BcCmFeOOH = fvcf_bc(phis, Ds, us, dx, BcFeOOH, Ngrid) #  # Boundary transport matrix of FeOOH
BcAmFeS, BcBmFeS, BcCmFeS = fvcf_bc(phis, Ds, us, dx, BcFeS, Ngrid) #  # Boundary transport matrix of FeS
BcAmSO4, BcBmSO4, BcCmSO4 = fvcf_bc(phif, DSO4, uf, dx, BcSO4, Ngrid) #  # Boundary transport matrix of SO4
BcAmTFe_dis, BcBmTFe_dis, BcCmTFe_dis =
    fvcf_bc(phif, DTFe_dis, uf, dx, BcTFe_dis, Ngrid) #  # Boundary transport matrix of TFe_dis
BcAmH, BcBmH, BcCmH = fvcf_bc(phif, DH, uf, dx, BcH, Ngrid) #  # Boundary transport matrix of H
BcAmOH, BcBmOH, BcCmOH = fvcf_bc(phif, DOH, uf, dx, BcOH, Ngrid) #  # Boundary transport matrix of OH
BcAmHCO3, BcBmHCO3, BcCmHCO3 = fvcf_bc(phif, DHCO3, uf, dx, BcHCO3, Ngrid) #  # Boundary transport matrix of HCO3
BcAmCO3, BcBmCO3, BcCmCO3 = fvcf_bc(phif, DCO3, uf, dx, BcCO3, Ngrid) #  # Boundary transport matrix of CO3
BcAmCO2, BcBmCO2, BcCmCO2 = fvcf_bc(phif, DCO2, uf, dx, BcCO2, Ngrid) #  # Boundary transport matrix of CO2
BcAmH2S, BcBmH2S, BcCmH2S = fvcf_bc(phif, DH2S, uf, dx, BcH2S, Ngrid) #  # Boundary transport matrix of H2S
BcAmHS, BcBmHS, BcCmHS = fvcf_bc(phif, DHS, uf, dx, BcHS, Ngrid) #  # Boundary transport matrix of HS
BcAmTFe_ads_POC, BcBmTFe_ads_POC, BcCmTFe_ads_POC =
    fvcf_bc(phis, Ds, us, dx, BcTFe_ads_POC, Ngrid) #  # Boundary transport matrix of TFe_ads_POC

#----------------------------------------------
# Interior transport matrix
#----------------------------------------------
AmPOC, BmPOC = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of POC
AmFeOOH, BmFeOOH = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of FeOOH
AmFeS, BmFeS = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of FeS
AmSO4, BmSO4 = fvcf(phif, DSO4, uf, dx, Ngrid) #  # Interior transport matrix of SO4
AmTFe_dis, BmTFe_dis = fvcf(phif, DTFe_dis, uf, dx, Ngrid) #  # Interior transport matrix of TFe_dis
AmH, BmH = fvcf(phif, DH, uf, dx, Ngrid) #  # Interior transport matrix of H
AmOH, BmOH = fvcf(phif, DOH, uf, dx, Ngrid) #  # Interior transport matrix of OH
AmHCO3, BmHCO3 = fvcf(phif, DHCO3, uf, dx, Ngrid) #  # Interior transport matrix of HCO3
AmCO3, BmCO3 = fvcf(phif, DCO3, uf, dx, Ngrid) #  # Interior transport matrix of CO3
AmCO2, BmCO2 = fvcf(phif, DCO2, uf, dx, Ngrid) #  # Interior transport matrix of CO2
AmH2S, BmH2S = fvcf(phif, DH2S, uf, dx, Ngrid) #  # Interior transport matrix of H2S
AmHS, BmHS = fvcf(phif, DHS, uf, dx, Ngrid) #  # Interior transport matrix of HS
AmTFe_ads_POC, BmTFe_ads_POC = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of TFe_ads_POC

#----------------------------------------------
# Acid dissociation constants
#----------------------------------------------
KH2O = 7.9445878598109790E-15 #  # H 1th dissociation constant
KCO2 = 8.3698755808176183E-07 #  # TCO2 1th dissociation constant
KHCO3 = 4.6352156109843975E-10 #  # TCO2 2th dissociation constant
KH2S = 1.2845618784784923E-07 #  # TH2S 1th dissociation constant

#----------------------------------------------
# Reaction parameters
#----------------------------------------------
Cl = 0.565772678 # mmol cm^-3 # Seawater Cl concentration
KspFeS = 10^(-3.2) # (mmol cm^-3 pw)^-1  # apparent solubility of FeS  
KFeOOH = 3.0 # mmol cm^-3 # Monod constant FeOOH
k_POC = 0.01 # yr^-1 # POC remineralization rate constant
KSO4 = 0.001 # mmol cm^-3 # Monod constant of SO4
kFeOOHH2S = 4000.0 # (mmol cm-3 pw)^-0.5 yr^-1  # rate constant for oxidiation of H2S by FeOOH
kFeSpre = 200e-3 * ds_rho # mmol cm^-3 ds yr^-1  # FeS precipitation rate constant

#----------------------------------------------
# Inital values
#----------------------------------------------
C_ini = [
    FPOC0 / (phis[1] * us[1]),
    FFeOOH0 / (phis[1] * us[1]),
    FFeS0 / (phis[1] * us[1]),
    SO40,
    TFe_dis0,
    H0,
    TCO20,
    TH2S0,
] #  # initial conditions
C0 = repeat(C_ini, outer = Ngrid) # initial conditions

#----------------------------------------------
# Indices
#----------------------------------------------
POCID = ((1:Ngrid) .- 1)nspec .+ 1 #  # POC index
FeOOHID = ((1:Ngrid) .- 1)nspec .+ 2 #  # FeOOH index
FeSID = ((1:Ngrid) .- 1)nspec .+ 3 #  # FeS index
SO4ID = ((1:Ngrid) .- 1)nspec .+ 4 #  # SO4 index
TFeID = ((1:Ngrid) .- 1)nspec .+ 5 #  # TFe index
HID = ((1:Ngrid) .- 1)nspec .+ 6 #  # H index
TCO2ID = ((1:Ngrid) .- 1)nspec .+ 7 #  # TCO2 index
TH2SID = ((1:Ngrid) .- 1)nspec .+ 8 #  # TH2S index
IDdict = Dict(
    :POCID => POCID,
    :FeOOHID => FeOOHID,
    :FeSID => FeSID,
    :SO4ID => SO4ID,
    :TFeID => TFeID,
    :HID => HID,
    :TCO2ID => TCO2ID,
    :TH2SID => TH2SID,
)
