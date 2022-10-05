
#----------------------------------------------
# Number of substances
#----------------------------------------------
nsolid = 1 #  # number of solid substances
ndissolved = 0 #  # number of dissolved substances
nsummed = 0 #  # number of summed substances
nspec = 1 #  # number of total substances

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
Ngrid = 500 # integer # number of model grid
Nmat = 500 #  # Jacobian dimention
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
Ds = broadcast(x -> 10.0, x) # cm^2 yr^-1 # Bioturbation coefficient

#----------------------------------------------
# bioirrigation parameters
#----------------------------------------------
alpha = broadcast(x -> 0.0, x) # cm^2 yr^-1 # Bioirrigation coefficient

#----------------------------------------------
# boundary fluxes and concentrations
#----------------------------------------------
POC0 = 3.0 # mmol cm^-3 # Concentration of POC at the TOP of sediment column

#----------------------------------------------
# assemble boundary conditions
#----------------------------------------------
BcPOC = ((1.0, 0.0, POC0), (0.0, 1.0, 0.0)) #  # Boundary condition of POC

#----------------------------------------------
# Boundary transport matrix
#----------------------------------------------
BcAmPOC, BcBmPOC, BcCmPOC = fvcf_bc(phis, Ds, us, dx, BcPOC, Ngrid) #  # Boundary transport matrix of POC

#----------------------------------------------
# Interior transport matrix
#----------------------------------------------
AmPOC, BmPOC = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of POC

#----------------------------------------------
# Reaction parameters
#----------------------------------------------
k_POC = 0.005 # yr^-1 # kinetic rate of POC oxidation

#----------------------------------------------
# Inital values
#----------------------------------------------
C_ini = [POC0] #  # initial conditions
C0 = repeat(C_ini, outer = Ngrid) # initial conditions

#----------------------------------------------
# Indices
#----------------------------------------------
POCID = ((1:Ngrid) .- 1)nspec .+ 1 #  # POC index
IDdict = Dict(:POCID => POCID)
