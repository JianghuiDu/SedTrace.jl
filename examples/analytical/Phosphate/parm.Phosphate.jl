
#----------------------------------------------
# Number of substances
#----------------------------------------------
nsolid = 1 #  # number of solid substances
ndissolved = 1 #  # number of dissolved substances
nsummed = 0 #  # number of summed substances
nspec = 2 #  # number of total substances

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
L = 500.0 # cm # model sediment section thickness
Ngrid = 5000 # integer # number of model grid
Nmat = 10000 # integer # Jacobian dimension
ξ = range(0, step = L / (Ngrid), length = Ngrid + 1) # cm # uniform grid
xᵥ = broadcast(x -> x, ξ) # cm # non-uniform grid transformation
x = (xᵥ[2:(Ngrid+1)] .+ xᵥ[1:Ngrid]) / 2 # cm # cell center
dx = xᵥ[2:(Ngrid+1)] .- xᵥ[1:Ngrid] # cm # cell volume

#----------------------------------------------
# porosity parameters
#----------------------------------------------
phi_Inf = 0.8 # dimensionless # porosity at burial depth
phif = broadcast(x -> 0.8, x) # dimensionless # fluid volume fraction
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
Ds = broadcast(x -> 0.0, x) # cm^2 yr^-1 # Bioturbation coefficient

#----------------------------------------------
# bioirrigation parameters
#----------------------------------------------
alpha = broadcast(x -> 0.0, x) # yr^-1 # Bioirrigation coefficient

#----------------------------------------------
# speciation parameters
#----------------------------------------------
K_ads = 5.2 # cm^3 ds/cm^3 pw # adsorption constant

#----------------------------------------------
# solute diffusivity
#----------------------------------------------
DTH3PO4_dis = 1.2376332592731156E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient

#----------------------------------------------
# boundary fluxes and concentrations
#----------------------------------------------
Porg0 = 0.1 # mmol cm^-3 # Concentration of Porg at the TOP of sediment column
PorgL = 0.0 # mmol cm^-3 # Concentration of Porg at the BOTTOM of sediment column
TH3PO4_dis0 = 1.0e-6 # mmol cm^-3 # Concentration of TH3PO4_dis at the TOP of sediment column
TH3PO4_ads0 = TH3PO4_dis0 * K_ads # mmol cm^-3 # Concentration of TH3PO4_ads at the TOP of sediment column

#----------------------------------------------
# assemble boundary conditions
#----------------------------------------------
BcPorg = ((1.0, 0.0, Porg0), (1.0, 0.0, PorgL)) #  # Boundary condition of Porg
BcTH3PO4_dis = ((1.0, 0.0, TH3PO4_dis0), (0.0, 1.0, 0.0)) #  # Boundary condition of TH3PO4_dis
BcTH3PO4_ads = ((1.0, 0.0, TH3PO4_ads0), (0.0, 1.0, 0.0)) #  # Boundary condition of TH3PO4_ads

#----------------------------------------------
# Boundary transport matrix
#----------------------------------------------
BcAmPorg, BcCmPorg = fvcf_bc(phis, Ds, us, dx, BcPorg, Ngrid) #  # Boundary transport matrix of Porg
BcAmTH3PO4_dis, BcCmTH3PO4_dis =
    fvcf_bc(phif, DTH3PO4_dis, uf, dx, BcTH3PO4_dis, Ngrid) #  # Boundary transport matrix of TH3PO4_dis
BcAmTH3PO4_ads, BcCmTH3PO4_ads = fvcf_bc(phis, Ds, us, dx, BcTH3PO4_ads, Ngrid) #  # Boundary transport matrix of TH3PO4_ads

#----------------------------------------------
# Interior transport matrix
#----------------------------------------------
AmPorg = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Porg
AmTH3PO4_dis = fvcf(phif, DTH3PO4_dis, uf, dx, Ngrid) #  # Interior transport matrix of TH3PO4_dis
AmTH3PO4_ads = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of TH3PO4_ads

#----------------------------------------------
# Reaction parameters
#----------------------------------------------
k_P = 0.01 # yr^-1 # Organic P remineralization rate
k_pre = 0.1 # yr^-1 # authigenic phosphate precipitation rate
Csat = 1.0e-5 # mmol cm^-3 # H3PO4 saturation concentration

#----------------------------------------------
# Inital values
#----------------------------------------------
C_ini = [Porg0, TH3PO4_dis0] #  # initial conditions
C0 = repeat(C_ini, outer = Ngrid) # initial conditions

#----------------------------------------------
# Indices
#----------------------------------------------
PorgID = ((1:Ngrid) .- 1)nspec .+ 1 #  # Porg index
TH3PO4ID = ((1:Ngrid) .- 1)nspec .+ 2 #  # TH3PO4 index
IDdict = Dict(:PorgID => PorgID, :TH3PO4ID => TH3PO4ID)
