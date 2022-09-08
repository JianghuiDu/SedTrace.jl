
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
const L = 500.0 # cm # model sediment section thickness
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
const DH3PO4 = 1.4353131461911693E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient

#----------------------------------------------
# boundary fluxes and concentrations
#----------------------------------------------
const Porg0 = 0.1 # mmol cm^-3 # POC concentration at x=0
const PorgL = 0.0 # mmol cm^-3 # POC concentration at x=L
const H3PO40 = 1.0e-6 # mmol cm^-3 # SO4 concentration at x=0
const H3PO4L = 1.0e-5 # mmol cm^-3 # SO4 concentration at x=0
const FP_ads0 = 0.0 # mmol cm^-2 yr^-1 # SO4 concentration at x=L

#----------------------------------------------
# assemble boundary conditions
#----------------------------------------------
const BcPorg = ((1.0, 0.0, Porg0), (1.0, 0.0, PorgL)) #  # Boundary condition of Porg
const BcH3PO4 = ((1.0, 0.0, H3PO40), (0.0, 1.0, 0.0)) #  # Boundary condition of TH3PO4
const BcP_ads = ((phis[1]us[1], -phis[1]Ds[1], FP_ads0), (0.0, 1.0, 0.0)) #  # Boundary condition of TH3PO4

#----------------------------------------------
# Boundary transport matrix
#----------------------------------------------
const BcAmPorg, BcBmPorg, BcCmPorg = fvcf_bc(phis, Ds, us, dx, BcPorg, Ngrid) #  # Boundary transport matrix of Porg
const BcAmH3PO4, BcBmH3PO4, BcCmH3PO4 =
    fvcf_bc(phif, DH3PO4, uf, dx, BcH3PO4, Ngrid) #  # Boundary transport matrix of H3PO4
const BcAmP_ads, BcBmP_ads, BcCmP_ads =
    fvcf_bc(phis, Ds, us, dx, BcP_ads, Ngrid) #  # Boundary transport matrix of P_ads

#----------------------------------------------
# Interior transport matrix
#----------------------------------------------
const AmPorg, BmPorg = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Porg
const AmH3PO4, BmH3PO4 = fvcf(phif, DH3PO4, uf, dx, Ngrid) #  # Interior transport matrix of H3PO4
const AmP_ads, BmP_ads = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of P_ads

#----------------------------------------------
# Reaction parameters
#----------------------------------------------
const k_P = 0.01 # yr^-1 # POC remineralization rate constant
const K_ads = 5.2 # cm^3 ds/cm^3 pw # POC remineralization rate constant
const Csat = 1.0e-5 # missing # missing
const k_pre = 0.1 # missing # missing

#----------------------------------------------
# Inital values
#----------------------------------------------
const C_ini = [H3PO40, Porg0] #  # initial conditions
const C_uni = repeat(C_ini, outer = Ngrid) # initial conditions

#----------------------------------------------
# Indices
#----------------------------------------------
const TH3PO4ID = ((1:Ngrid) .- 1)nspec .+ 1 #  # TH3PO4 index
const PorgID = ((1:Ngrid) .- 1)nspec .+ 2 #  # Porg index
const IDdict = Dict("TH3PO4" => TH3PO4ID, "Porg" => PorgID)
nothing
