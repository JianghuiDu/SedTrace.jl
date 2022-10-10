
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
L = 200.0 # cm # model sediment section thickness
Ngrid = 5000 # integer # number of model grid
Nmat = 10000 # integer # Jacobian dimension
ξ = range(0, step = L / (Ngrid), length = Ngrid + 1) # cm # uniform grid
xᵥ = broadcast(x -> x, ξ) # cm # non-uniform grid transformation
x = (xᵥ[2:(Ngrid+1)] .+ xᵥ[1:Ngrid]) / 2 # cm # cell center
dx = xᵥ[2:(Ngrid+1)] .- xᵥ[1:Ngrid] # cm # cell volume

#----------------------------------------------
# porosity parameters
#----------------------------------------------
phi_Inf = 0.8 # dimensionless # porosity at infinite sediment depth (normally where porosity stops changing). Needed to calculate burial velocities. If constant_porosity_profile = no, then phi_Inf should be consistent with the depth dependent porosity function
phif = broadcast(x -> 0.8, x) # dimensionless # fluid volume fraction
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
Ds = broadcast(x -> 0.0, x) # cm^2 yr^-1 # Bioturbation coefficient

#----------------------------------------------
# bioirrigation parameters
#----------------------------------------------
alpha = broadcast(x -> 0.0, x) # cm^2 yr^-1 # Bioirrigation coefficient

#----------------------------------------------
# adsorption parameters
#----------------------------------------------
KNH4_ads = 5.2 # cm^3 ds/cm^3 pw # Adsorption constant

#----------------------------------------------
# solute diffusivity
#----------------------------------------------
DTNH4_dis = 3.4531311564520092E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient

#----------------------------------------------
# boundary fluxes and concentrations
#----------------------------------------------
TNH4_dis0 = 1.0e-6 # mmol cm^-3 # Concentration of NH4 at the TOP of sediment column
TNH4_ads_nsf0 = KNH4_ads * TNH4_dis0 # mmol cm^-3 # Concentration of NH4_ads at the TOP of sediment column
N_org0 = 0.1 # mmol cm^-3 # Concentration of N_org at the TOP of sediment column
N_orgL = 0.0 # mmol cm^-3 # Concentration of N_org at the BOTTOM of sediment column

#----------------------------------------------
# assemble boundary conditions
#----------------------------------------------
BcN_org = ((1.0, 0.0, N_org0), (1.0, 0.0, N_orgL)) #  # Boundary condition of N_org
BcTNH4_dis = ((1.0, 0.0, TNH4_dis0), (0.0, 1.0, 0.0)) #  # Boundary condition of TNH4_dis
BcTNH4_ads_nsf = ((1.0, 0.0, TNH4_ads_nsf0), (0.0, 1.0, 0.0)) #  # Boundary condition of TNH4_ads_nsf

#----------------------------------------------
# Boundary transport matrix
#----------------------------------------------
BcAmN_org, BcBmN_org, BcCmN_org = fvcf_bc(phis, Ds, us, dx, BcN_org, Ngrid) #  # Boundary transport matrix of N_org
BcAmTNH4_dis, BcBmTNH4_dis, BcCmTNH4_dis =
    fvcf_bc(phif, DTNH4_dis, uf, dx, BcTNH4_dis, Ngrid) #  # Boundary transport matrix of TNH4_dis
BcAmTNH4_ads_nsf, BcBmTNH4_ads_nsf, BcCmTNH4_ads_nsf =
    fvcf_bc(phis, Ds, us, dx, BcTNH4_ads_nsf, Ngrid) #  # Boundary transport matrix of TNH4_ads_nsf

#----------------------------------------------
# Interior transport matrix
#----------------------------------------------
AmN_org, BmN_org = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of N_org
AmTNH4_dis, BmTNH4_dis = fvcf(phif, DTNH4_dis, uf, dx, Ngrid) #  # Interior transport matrix of TNH4_dis
AmTNH4_ads_nsf, BmTNH4_ads_nsf = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of TNH4_ads_nsf

#----------------------------------------------
# Reaction parameters
#----------------------------------------------
k = 0.01 # yr^-1 # remineralization rate constant

#----------------------------------------------
# Inital values
#----------------------------------------------
C_ini = [N_org0, TNH4_dis0] #  # initial conditions
C0 = repeat(C_ini, outer = Ngrid) # initial conditions

#----------------------------------------------
# Indices
#----------------------------------------------
N_orgID = ((1:Ngrid) .- 1)nspec .+ 1 #  # N_org index
TNH4ID = ((1:Ngrid) .- 1)nspec .+ 2 #  # TNH4 index
IDdict = Dict(:N_orgID => N_orgID, :TNH4ID => TNH4ID)
