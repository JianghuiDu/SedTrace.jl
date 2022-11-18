
#----------------------------------------------
# Number of substances
#----------------------------------------------
nsolid = 0 #  # number of solid substances
ndissolved = 1 #  # number of dissolved substances
nsummed = 4 #  # number of summed substances
nspec = 5 #  # number of total substances

#----------------------------------------------
# global parameters
#----------------------------------------------
depth = 0.0 # m # water depth
salinity = 20.0 # psu # bottom water salinity
temp = 20.0 # Celsius # bottom water temperature
ds_rho = 2.6 # g cm^-3 # dry sediment density
sw_dens = 1.0137308581930058 # g cm^-3 # seawater density

#----------------------------------------------
# grid parameters
#----------------------------------------------
L = 0.2 # cm # model sediment section thickness
Ngrid = 200 # integer # number of model grid
b = 3.5 # missing # parameter in gridtran
A =
    1 / 2b *
    log((1 + (exp(b) - 1) * 0.055 / L) / (1 + (exp(-b) - 1) * 0.055 / L)) # missing # parameter in gridtran
Nmat = 1000 # integer # Jacobian dimension
ξ = range(0, step = L / (Ngrid), length = Ngrid + 1) # cm # uniform grid
xᵥ = broadcast(x -> 0.055 * (1 + sinh(b * (x / L - A)) / sinh(b * A)) - 0.05, ξ) # cm # non-uniform grid transformation
x = (xᵥ[2:(Ngrid+1)] .+ xᵥ[1:Ngrid]) / 2 # cm # cell center
dx = xᵥ[2:(Ngrid+1)] .- xᵥ[1:Ngrid] # cm # cell volume

#----------------------------------------------
# porosity parameters
#----------------------------------------------
phi_Inf = 0.9999 # dimensionless # porosity at burial depth
phif = broadcast(x -> 0.9999, x) # dimensionless # fluid volume fraction
phis = 1.0 .- phif # dimensionless # solid volume fraction
pwtods = phif ./ phis # dimensionless # conversion from pore water to solid sediment volume unit
dstopw = phis ./ phif # dimensionless # conversion from solid sediment to pore water volume unit

#----------------------------------------------
# phase velocity parameters
#----------------------------------------------
Fsed = 1.0e-6 # g cm^-2 yr^-1 # total sediment flux
w_Inf = Fsed / ds_rho / (1 - phi_Inf) # cm yr^-1 # solid sediment burial velocity at infinite depth
uf = phi_Inf * w_Inf ./ phif # cm yr^-1 # pore water burial velocity
us = Fsed / ds_rho ./ phis # cm yr^-1 # solid sediment burial velocity

#----------------------------------------------
# bioturbation parameters
#----------------------------------------------
Ds = broadcast(x -> 0.0, x) # cm^2 yr^-1 # Bioturbation coefficient

#----------------------------------------------
# bioirrigation parameters
#----------------------------------------------
alpha = broadcast(x -> 0.0, x) # yr^-1 # Bioirrigation coefficient

#----------------------------------------------
# solute diffusivity
#----------------------------------------------
DO2 = 6.4346967874376969E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DH = 2.5854032184615044E+03 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DOH = 1.4448019389250373E+03 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DHCO3 = 3.1931997645559630E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DCO3 = 2.5128304965397780E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DCO2 = 5.0917105697368714E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DH2S = 5.5684868632515042E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DHS = 4.7958473736607556E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DH3BO3 = 3.1554758891758519E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
DH4BO4 = 2.7610414030288706E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient

#----------------------------------------------
# boundary fluxes and concentrations
#----------------------------------------------
O20 = 0.00025 # mmol cm^-3 # Concentration of O2 at the TOP of sediment column
O2L = 0.0 # mmol cm^-3 # Concentration of O2 at the BOTTOM of sediment column
pH0 = 8.15 # free pH scale # pH at the TOP of sediment column
pHL = 7.39 # free pH scale # pH at the BOTTOM of sediment column
TCO20 = 0.002 # mmol cm^-3 # Concentration of TCO2 at the TOP of sediment column
TCO2L = 0.002 # mmol cm^-3 # Concentration of TCO2 at the BOTTOM of sediment column
TH2S0 = 0.0 # mmol cm^-3 # Concentration of TH2S at the TOP of sediment column
TH2SL = 0.000383 # mmol cm^-3 # Concentration of TH2S at the BOTTOM of sediment column
TH3BO30 = 4.8984470290102364e-5 # mmol cm^-3 # Concentration of TH3BO3 at the TOP of sediment column
TH3BO3L = 4.8984470290102364e-5 # mmol cm^-3 # Concentration of TH3BO3 at the BOTTOM of sediment column
H0 = 7.0794578438413736E-09 # mmol cm^-3 # Concentration of H at the TOP of sediment column
OH0 = 3.3453398524832405E-06 # mmol cm^-3 # Concentration of OH at the TOP of sediment column
HL = 4.0738027780411300E-08 # mmol cm^-3 # Concentration of H at the BOTTOM of sediment column
OHL = 5.8135343680936806E-07 # mmol cm^-3 # Concentration of OH at the BOTTOM of sediment column
HCO30 = 1.8515518417495179E-03 # mmol cm^-3 # Concentration of HCO3 at the TOP of sediment column
CO30 = 1.3412360976015851E-04 # mmol cm^-3 # Concentration of CO3 at the TOP of sediment column
CO20 = 1.4324548490323713E-05 # mmol cm^-3 # Concentration of CO2 at the TOP of sediment column
HCO3L = 1.8919554716367625E-03 # mmol cm^-3 # Concentration of HCO3 at the BOTTOM of sediment column
CO3L = 2.3816627695285896E-05 # mmol cm^-3 # Concentration of CO3 at the BOTTOM of sediment column
CO2L = 8.4227900667951697E-05 # mmol cm^-3 # Concentration of CO2 at the BOTTOM of sediment column
H2S0 = 0.0000000000000000E+00 # mmol cm^-3 # Concentration of H2S at the TOP of sediment column
HS0 = 0.0000000000000000E+00 # mmol cm^-3 # Concentration of HS at the TOP of sediment column
H2SL = 6.4011117242014865E-05 # mmol cm^-3 # Concentration of H2S at the BOTTOM of sediment column
HSL = 3.1898888275798512E-04 # mmol cm^-3 # Concentration of HS at the BOTTOM of sediment column
H3BO30 = 4.0543608755753571E-05 # mmol cm^-3 # Concentration of H3BO3 at the TOP of sediment column
H4BO40 = 8.4408615343487908E-06 # mmol cm^-3 # Concentration of H4BO4 at the TOP of sediment column
H3BO3L = 4.7274109504659418E-05 # mmol cm^-3 # Concentration of H3BO3 at the BOTTOM of sediment column
H4BO4L = 1.7103607854429429E-06 # mmol cm^-3 # Concentration of H4BO4 at the BOTTOM of sediment column

#----------------------------------------------
# assemble boundary conditions
#----------------------------------------------
BcO2 = ((1.0, 0.0, O20), (1.0, 0.0, O2L)) #  # Boundary condition of O2
BcH = ((1.0, 0.0, H0), (1.0, 0.0, HL)) #  # Boundary condition of H
BcOH = ((1.0, 0.0, OH0), (1.0, 0.0, OHL)) #  # Boundary condition of H
BcHCO3 = ((1.0, 0.0, HCO30), (1.0, 0.0, HCO3L)) #  # Boundary condition of TCO2
BcCO3 = ((1.0, 0.0, CO30), (1.0, 0.0, CO3L)) #  # Boundary condition of TCO2
BcCO2 = ((1.0, 0.0, CO20), (1.0, 0.0, CO2L)) #  # Boundary condition of TCO2
BcH2S = ((1.0, 0.0, H2S0), (1.0, 0.0, H2SL)) #  # Boundary condition of TH2S
BcHS = ((1.0, 0.0, HS0), (1.0, 0.0, HSL)) #  # Boundary condition of TH2S
BcH3BO3 = ((1.0, 0.0, H3BO30), (1.0, 0.0, H3BO3L)) #  # Boundary condition of TH3BO3
BcH4BO4 = ((1.0, 0.0, H4BO40), (1.0, 0.0, H4BO4L)) #  # Boundary condition of TH3BO3

#----------------------------------------------
# Boundary transport matrix
#----------------------------------------------
BcAmO2, BcCmO2 = fvcf_bc(phif, DO2, uf, dx, BcO2, Ngrid) #  # Boundary transport matrix of O2
BcAmH, BcCmH = fvcf_bc(phif, DH, uf, dx, BcH, Ngrid) #  # Boundary transport matrix of H
BcAmOH, BcCmOH = fvcf_bc(phif, DOH, uf, dx, BcOH, Ngrid) #  # Boundary transport matrix of OH
BcAmHCO3, BcCmHCO3 = fvcf_bc(phif, DHCO3, uf, dx, BcHCO3, Ngrid) #  # Boundary transport matrix of HCO3
BcAmCO3, BcCmCO3 = fvcf_bc(phif, DCO3, uf, dx, BcCO3, Ngrid) #  # Boundary transport matrix of CO3
BcAmCO2, BcCmCO2 = fvcf_bc(phif, DCO2, uf, dx, BcCO2, Ngrid) #  # Boundary transport matrix of CO2
BcAmH2S, BcCmH2S = fvcf_bc(phif, DH2S, uf, dx, BcH2S, Ngrid) #  # Boundary transport matrix of H2S
BcAmHS, BcCmHS = fvcf_bc(phif, DHS, uf, dx, BcHS, Ngrid) #  # Boundary transport matrix of HS
BcAmH3BO3, BcCmH3BO3 = fvcf_bc(phif, DH3BO3, uf, dx, BcH3BO3, Ngrid) #  # Boundary transport matrix of H3BO3
BcAmH4BO4, BcCmH4BO4 = fvcf_bc(phif, DH4BO4, uf, dx, BcH4BO4, Ngrid) #  # Boundary transport matrix of H4BO4

#----------------------------------------------
# Interior transport matrix
#----------------------------------------------
AmO2 = fvcf(phif, DO2, uf, dx, Ngrid) #  # Interior transport matrix of O2
AmH = fvcf(phif, DH, uf, dx, Ngrid) #  # Interior transport matrix of H
AmOH = fvcf(phif, DOH, uf, dx, Ngrid) #  # Interior transport matrix of OH
AmHCO3 = fvcf(phif, DHCO3, uf, dx, Ngrid) #  # Interior transport matrix of HCO3
AmCO3 = fvcf(phif, DCO3, uf, dx, Ngrid) #  # Interior transport matrix of CO3
AmCO2 = fvcf(phif, DCO2, uf, dx, Ngrid) #  # Interior transport matrix of CO2
AmH2S = fvcf(phif, DH2S, uf, dx, Ngrid) #  # Interior transport matrix of H2S
AmHS = fvcf(phif, DHS, uf, dx, Ngrid) #  # Interior transport matrix of HS
AmH3BO3 = fvcf(phif, DH3BO3, uf, dx, Ngrid) #  # Interior transport matrix of H3BO3
AmH4BO4 = fvcf(phif, DH4BO4, uf, dx, Ngrid) #  # Interior transport matrix of H4BO4

#----------------------------------------------
# Acid dissociation constants
#----------------------------------------------
KH2O = 2.3683192458977620E-14 #  # H 1th dissociation constant
KCO2 = 9.1507130002785479E-07 #  # TCO2 1th dissociation constant
KHCO3 = 5.1282519870665730E-10 #  # TCO2 2th dissociation constant
KH2S = 2.0301126628215872E-07 #  # TH2S 1th dissociation constant
KH3BO3 = 1.4738876294440457E-09 #  # TH3BO3 1th dissociation constant

#----------------------------------------------
# Reaction parameters
#----------------------------------------------
a = 10000.0 # cm # parameter controlling the narrowness of the interface
x0 = 0.005 # cm # location of the bacterial mat
kOS = 82.0 # mmol cm^-3yr^-1 # rate constant of H2S oxidation by O2

#----------------------------------------------
# Inital values
#----------------------------------------------
C_ini = [O20, H0, TCO20, TH2S0, TH3BO30] #  # initial conditions
C0 = repeat(C_ini, outer = Ngrid) # initial conditions

#----------------------------------------------
# Indices
#----------------------------------------------
O2ID = ((1:Ngrid) .- 1)nspec .+ 1 #  # O2 index
HID = ((1:Ngrid) .- 1)nspec .+ 2 #  # H index
TCO2ID = ((1:Ngrid) .- 1)nspec .+ 3 #  # TCO2 index
TH2SID = ((1:Ngrid) .- 1)nspec .+ 4 #  # TH2S index
TH3BO3ID = ((1:Ngrid) .- 1)nspec .+ 5 #  # TH3BO3 index
IDdict = Dict(
    :O2ID => O2ID,
    :HID => HID,
    :TCO2ID => TCO2ID,
    :TH2SID => TH2SID,
    :TH3BO3ID => TH3BO3ID,
)
