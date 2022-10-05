
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
L = 300.0 # cm # model sediment section thickness
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
# solute diffusivity
#----------------------------------------------
DSO4 = 1.8034511184582917E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient

#----------------------------------------------
# boundary fluxes and concentrations
#----------------------------------------------
POC0 = 3.0 # mmol cm^-3 # Concentration of POC at the TOP of sediment column
POCL = 0.0 # mmol cm^-3 # Concentration of POC at the BOTTOM of sediment column
SO40 = 0.028 # mmol cm^-3 # Concentration of SO4 at the TOP of sediment column
SO4L = 0.016509602468835302 # mmol cm^-3 # Concentration of SO4 at the BOTTOM of sediment column

#----------------------------------------------
# assemble boundary conditions
#----------------------------------------------
BcPOC = ((1.0, 0.0, POC0), (1.0, 0.0, POCL)) #  # Boundary condition of POC
BcSO4 = ((1.0, 0.0, SO40), (1.0, 0.0, SO4L)) #  # Boundary condition of SO4

#----------------------------------------------
# Boundary transport matrix
#----------------------------------------------
BcAmPOC, BcBmPOC, BcCmPOC = fvcf_bc(phis, Ds, us, dx, BcPOC, Ngrid) #  # Boundary transport matrix of POC
BcAmSO4, BcBmSO4, BcCmSO4 = fvcf_bc(phif, DSO4, uf, dx, BcSO4, Ngrid) #  # Boundary transport matrix of SO4

#----------------------------------------------
# Interior transport matrix
#----------------------------------------------
AmPOC, BmPOC = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of POC
AmSO4, BmSO4 = fvcf(phif, DSO4, uf, dx, Ngrid) #  # Interior transport matrix of SO4

#----------------------------------------------
# Reaction parameters
#----------------------------------------------
k_POC = 0.005 # yr^-1 # POC remineralization rate constant

#----------------------------------------------
# Inital values
#----------------------------------------------
C_ini = [POC0, SO40] #  # initial conditions
C0 = repeat(C_ini, outer = Ngrid) # initial conditions

#----------------------------------------------
# Indices
#----------------------------------------------
POCID = ((1:Ngrid) .- 1)nspec .+ 1 #  # POC index
SO4ID = ((1:Ngrid) .- 1)nspec .+ 2 #  # SO4 index
IDdict = Dict(:POCID => POCID, :SO4ID => SO4ID)
