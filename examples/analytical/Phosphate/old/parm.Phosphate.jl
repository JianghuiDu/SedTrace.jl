
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
K_ads = 5.2 # cm^3 ds/cm^3 pw # Adsorption constant

#----------------------------------------------
# solute diffusivity
#----------------------------------------------
DH3PO4 = 1.4353131461911693E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient

#----------------------------------------------
# boundary fluxes and concentrations
#----------------------------------------------
H3PO40 = 1.0e-6 # mmol cm^-3 # Concentration of H3PO4 at the TOP of sediment column
P_ads0 = H3PO40 * K_ads # mmol cm^-3 # Concentration of P_ads at the TOP of sediment column
Porg0 = 0.1 # mmol cm^-3 # Concentration of Porg at the TOP of sediment column
PorgL = 0.0 # mmol cm^-3 # Concentration of Porg at the BOTTOM of sediment column

#----------------------------------------------
# assemble boundary conditions
#----------------------------------------------
BcPorg = ((1.0, 0.0, Porg0), (1.0, 0.0, PorgL)) #  # Boundary condition of Porg
BcH3PO4 = ((1.0, 0.0, H3PO40), (0.0, 1.0, 0.0)) #  # Boundary condition of TH3PO4
BcP_ads = ((1.0, 0.0, P_ads0), (0.0, 1.0, 0.0)) #  # Boundary condition of P_ads

#----------------------------------------------
# Boundary transport matrix
#----------------------------------------------
BcAmPorg, BcBmPorg, BcCmPorg = fvcf_bc(phis, Ds, us, dx, BcPorg, Ngrid) #  # Boundary transport matrix of Porg
BcAmH3PO4, BcBmH3PO4, BcCmH3PO4 = fvcf_bc(phif, DH3PO4, uf, dx, BcH3PO4, Ngrid) #  # Boundary transport matrix of H3PO4
BcAmP_ads, BcBmP_ads, BcCmP_ads = fvcf_bc(phis, Ds, us, dx, BcP_ads, Ngrid) #  # Boundary transport matrix of P_ads

#----------------------------------------------
# Interior transport matrix
#----------------------------------------------
AmPorg, BmPorg = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Porg
AmH3PO4, BmH3PO4 = fvcf(phif, DH3PO4, uf, dx, Ngrid) #  # Interior transport matrix of H3PO4
AmP_ads, BmP_ads = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of P_ads

#----------------------------------------------
# Reaction parameters
#----------------------------------------------
k_P = 0.01 # yr^-1 # Organic P remineralization rate
k_pre = 0.1 # yr^-1 # authigenic phosphate precipitation rate
Csat = 1.0e-5 # mmol cm^-3 # H3PO4 saturation concentration

#----------------------------------------------
# Inital values
#----------------------------------------------
C_ini = [H3PO40, Porg0] #  # initial conditions
C0 = repeat(C_ini, outer = Ngrid) # initial conditions

#----------------------------------------------
# Indices
#----------------------------------------------
TH3PO4ID = ((1:Ngrid) .- 1)nspec .+ 1 #  # TH3PO4 index
PorgID = ((1:Ngrid) .- 1)nspec .+ 2 #  # Porg index
IDdict = Dict(:TH3PO4ID => TH3PO4ID, :PorgID => PorgID)
