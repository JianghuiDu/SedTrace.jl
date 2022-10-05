
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
Nmat = 10000 #  # Jacobian dimention
ξ = range(0, step = L / (Ngrid), length = Ngrid + 1) # cm # uniform grid
xᵥ = broadcast(x -> x, ξ) # cm # no grid transformation
x = (xᵥ[2:(Ngrid+1)] .+ xᵥ[1:Ngrid]) / 2 # cm # cell center
dx = xᵥ[2:(Ngrid+1)] .- xᵥ[1:Ngrid] # cm # cell volume

#----------------------------------------------
# porosity parameters
#----------------------------------------------
phi_Inf = 0.8 # dimensionless # porosity at infinite sediment depth (normally where porosity stops changing). Needed to calculate burial velocities. If constant_porosity_profile = no, then phi_Inf should be consistent with the depth dependent porosity function
phif = broadcast(x -> 0.8, x) # dimentionless # fluid volume fraction
phis = 1.0 .- phif # dimentionless # solid volume fraction
pwtods = phif ./ phis # dimentionless # conversion from pore water to solid sediment volume unit
dstopw = phis ./ phif # dimentionless # conversion from solid sediment to pore water volume unit

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
DNH4 = 3.4531311564520092E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient

#----------------------------------------------
# boundary fluxes and concentrations
#----------------------------------------------
NH40 = 1.0e-6 # mmol cm^-3 # Concentration of NH4 at the TOP of sediment column
NH4_ads0 = KNH4_ads * NH40 # mmol cm^-3 # Concentration of NH4_ads at the TOP of sediment column
N_org0 = 0.1 # mmol cm^-3 # Concentration of N_org at the TOP of sediment column
N_orgL = 0.0 # mmol cm^-3 # Concentration of N_org at the BOTTOM of sediment column

#----------------------------------------------
# assemble boundary conditions
#----------------------------------------------
BcN_org = ((1.0, 0.0, N_org0), (1.0, 0.0, N_orgL)) #  # Boundary condition of N_org
BcNH4 = ((1.0, 0.0, NH40), (0.0, 1.0, 0.0)) #  # Boundary condition of TNH4
BcNH4_ads = ((1.0, 0.0, NH4_ads0), (0.0, 1.0, 0.0)) #  # Boundary condition of NH4_ads

#----------------------------------------------
# Boundary transport matrix
#----------------------------------------------
BcAmN_org, BcBmN_org, BcCmN_org = fvcf_bc(phis, Ds, us, dx, BcN_org, Ngrid) #  # Boundary transport matrix of N_org
BcAmNH4, BcBmNH4, BcCmNH4 = fvcf_bc(phif, DNH4, uf, dx, BcNH4, Ngrid) #  # Boundary transport matrix of NH4
BcAmNH4_ads, BcBmNH4_ads, BcCmNH4_ads =
    fvcf_bc(phis, Ds, us, dx, BcNH4_ads, Ngrid) #  # Boundary transport matrix of NH4_ads

#----------------------------------------------
# Interior transport matrix
#----------------------------------------------
AmN_org, BmN_org = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of N_org
AmNH4, BmNH4 = fvcf(phif, DNH4, uf, dx, Ngrid) #  # Interior transport matrix of NH4
AmNH4_ads, BmNH4_ads = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of NH4_ads

#----------------------------------------------
# Reaction parameters
#----------------------------------------------
k = 0.01 # yr^-1 # remineralization rate constant

#----------------------------------------------
# Inital values
#----------------------------------------------
C_ini = [NH40, N_org0] #  # initial conditions
C0 = repeat(C_ini, outer = Ngrid) # initial conditions

#----------------------------------------------
# Indices
#----------------------------------------------
TNH4ID = ((1:Ngrid) .- 1)nspec .+ 1 #  # TNH4 index
N_orgID = ((1:Ngrid) .- 1)nspec .+ 2 #  # N_org index
IDdict = Dict(:TNH4ID => TNH4ID, :N_orgID => N_orgID)
