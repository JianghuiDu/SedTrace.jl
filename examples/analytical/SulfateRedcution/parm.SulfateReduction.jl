
#----------------------------------------------
# Number of substances
#----------------------------------------------
const nsolid = 1 #  # number of solid substances
const ndissolved = 1 #  # number of dissolved substances
const nsummed = 0 #  # number of summed substances
const nspec = 2 #  # number of total substances

#----------------------------------------------
# global parameters
#----------------------------------------------
const depth = 500.0 # m # water depth
const salinity = 35.0 # psu # bottom water salinity
const temp = 5.0 # Celsius # bottom water temperature
const ds_rho = 2.6 # g cm^-3 # dry sediment density
const sw_dens = 1.0287324258804407 # g cm^-3 # seawater density

#----------------------------------------------
# grid parameters
#----------------------------------------------
const L = 1000.0 # cm # model sediment section thickness
const Ngrid = 5000 # integer # number of model grid
const Nmat = 10000 #  # Jacobian dimention
const ξ = range(0, step = L / (Ngrid), length = Ngrid + 1) # cm # uniform grid
const xᵥ = collect(ξ) # cm # no grid transformation
const x = (xᵥ[2:(Ngrid+1)] .+ xᵥ[1:Ngrid]) / 2 # cm # cell center
const dx = xᵥ[2:(Ngrid+1)] .- xᵥ[1:Ngrid] # cm # cell volume

#----------------------------------------------
# porosity parameters
#----------------------------------------------
const phi_Inf = 0.8 # dimentionless # porosity
const phif = broadcast(x -> 0.8, x) # dimentionless # fluid volume fraction
const phis = 1.0 .- phif # dimentionless # solid volume fraction
const pwtods = phif ./ phis # dimentionless # conversion from pore water to solid sediment volume unit
const dstopw = phis ./ phif # dimentionless # conversion from solid sediment to pore water volume unit

#----------------------------------------------
# burial parameters
#----------------------------------------------
const Fsed = 0.073 # g cm^-2 yr^-1 # total sediment flux
const w_Inf = Fsed / ds_rho / (1 - phi_Inf) # cm yr^-1 # solid sediment burial velocity at infinite depth
const uf = phi_Inf * w_Inf ./ phif # cm yr^-1 # pore water burial velocity
const us = Fsed / ds_rho ./ phis # cm yr^-1 # solid sediment burial velocity

#----------------------------------------------
# bioturbation parameters
#----------------------------------------------
const Ds = broadcast(x -> 0.0, x) # cm^2 yr^-1 # Bioturbation coefficient

#----------------------------------------------
# bioirrigation parameters
#----------------------------------------------
const alpha = broadcast(x -> 0.0, x) # cm^2 yr^-1 # Bioirrigation coefficient

#----------------------------------------------
# solute diffusivity
#----------------------------------------------
const DSO4 = 1.8034511184582917E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient

#----------------------------------------------
# boundary fluxes and concentrations
#----------------------------------------------
const POC0 = 3.0 # mmol cm^-3 # Flux of POC at the  TOP of sediment column
const POCL = 0.0 # mmol cm^-3 # Flux of POC at the  TOP of sediment column
const SO40 = 0.028 # mmol cm^-3 # Flux of POC at the  TOP of sediment column
const SO4L = 0.016509602468835302 # mmol cm^-3 # Flux of POC at the  TOP of sediment column

#----------------------------------------------
# assemble boundary conditions
#----------------------------------------------
const BcPOC = ((1.0, 0.0, POC0), (1.0, 0.0, POCL)) #  # Boundary condition of POC
const BcSO4 = ((1.0, 0.0, SO40), (1.0, 0.0, SO4L)) #  # Boundary condition of SO4

#----------------------------------------------
# Boundary transport matrix
#----------------------------------------------
const BcAmPOC, BcBmPOC, BcCmPOC = fvcf_bc(phis, Ds, us, dx, BcPOC, Ngrid) #  # Boundary transport matrix of POC
const BcAmSO4, BcBmSO4, BcCmSO4 = fvcf_bc(phif, DSO4, uf, dx, BcSO4, Ngrid) #  # Boundary transport matrix of SO4

#----------------------------------------------
# Interior transport matrix
#----------------------------------------------
const AmPOC, BmPOC = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of POC
const AmSO4, BmSO4 = fvcf(phif, DSO4, uf, dx, Ngrid) #  # Interior transport matrix of SO4

#----------------------------------------------
# Reaction parameters
#----------------------------------------------
const k_POC = 0.005 # yr^-1 # POC remineralization rate constant

#----------------------------------------------
# Inital values
#----------------------------------------------
const C_ini = [POC0, SO40] #  # initial conditions
const C_uni = repeat(C_ini, outer = Ngrid) # initial conditions

#----------------------------------------------
# Indices
#----------------------------------------------
const POCID = ((1:Ngrid) .- 1)nspec .+ 1 #  # POC index
const SO4ID = ((1:Ngrid) .- 1)nspec .+ 2 #  # SO4 index
const IDdict = Dict("POC" => POCID, "SO4" => SO4ID)
nothing
