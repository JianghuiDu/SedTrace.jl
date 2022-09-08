
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
const L = 200.0 # cm # model sediment section thickness
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
const DNH4 = 3.4531311564520092E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient

#----------------------------------------------
# boundary fluxes and concentrations
#----------------------------------------------
const NH30 = 0.1 # mmol cm^-3 # POC concentration at x=0
const NH3L = 0.0 # mmol cm^-3 # POC concentration at x=L
const NH40 = 1.0e-6 # mmol cm^-3 # SO4 concentration at x=0
const FNH4_ads0 = 0.0 # mmol cm^-2 yr^-1 # SO4 concentration at x=L

#----------------------------------------------
# assemble boundary conditions
#----------------------------------------------
const BcNH3 = ((1.0, 0.0, NH30), (1.0, 0.0, NH3L)) #  # Boundary condition of NH3
const BcNH4 = ((1.0, 0.0, NH40), (0.0, 1.0, 0.0)) #  # Boundary condition of TNH4
const BcNH4_ads = ((phis[1]us[1], -phis[1]Ds[1], FNH4_ads0), (0.0, 1.0, 0.0)) #  # Boundary condition of TNH4

#----------------------------------------------
# Boundary transport matrix
#----------------------------------------------
const BcAmNH3, BcBmNH3, BcCmNH3 = fvcf_bc(phis, Ds, us, dx, BcNH3, Ngrid) #  # Boundary transport matrix of NH3
const BcAmNH4, BcBmNH4, BcCmNH4 = fvcf_bc(phif, DNH4, uf, dx, BcNH4, Ngrid) #  # Boundary transport matrix of NH4
const BcAmNH4_ads, BcBmNH4_ads, BcCmNH4_ads =
    fvcf_bc(phis, Ds, us, dx, BcNH4_ads, Ngrid) #  # Boundary transport matrix of NH4_ads

#----------------------------------------------
# Interior transport matrix
#----------------------------------------------
const AmNH3, BmNH3 = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of NH3
const AmNH4, BmNH4 = fvcf(phif, DNH4, uf, dx, Ngrid) #  # Interior transport matrix of NH4
const AmNH4_ads, BmNH4_ads = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of NH4_ads

#----------------------------------------------
# Reaction parameters
#----------------------------------------------
const k_N = 0.01 # yr^-1 # POC remineralization rate constant
const KNH4_ads = 5.2 # cm^3 ds/cm^3 pw # POC remineralization rate constant

#----------------------------------------------
# Inital values
#----------------------------------------------
const C_ini = [NH40, NH30] #  # initial conditions
const C_uni = repeat(C_ini, outer = Ngrid) # initial conditions

#----------------------------------------------
# Indices
#----------------------------------------------
const TNH4ID = ((1:Ngrid) .- 1)nspec .+ 1 #  # TNH4 index
const NH3ID = ((1:Ngrid) .- 1)nspec .+ 2 #  # NH3 index
const IDdict = Dict("TNH4" => TNH4ID, "NH3" => NH3ID)
nothing
