
#----------------------------------------------
# Number of substances
#----------------------------------------------
const nsolid = 3 #  # number of solid substances
const ndissolved = 3 #  # number of dissolved substances
const nsummed = 3 #  # number of summed substances
const nnoneq = 6 #  # number of solid + dissolved substances
const nspec = 9 #  # number of total substances
const Lwbdwth = 11 #  # lower bandwidth of jacobian matrix
const Upbdwth = 11 #  # upper bandwidth of jacobian matrix

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
const L = 50.0 # cm # model sediment section thickness
const Ngrid = 500 # integer # number of model grid
const Nmat = Ngrid * nspec #  # Jacobian dimention
const ξ = range(0, step = L / (Ngrid), length = Ngrid + 1) # cm # uniform grid
const xᵥ = broadcast(x -> L * (exp(x / 5) - 1) / (exp(L / 5) - 1), ξ) # cm # no grid transformation
const x = (xᵥ[2:(Ngrid+1)] .+ xᵥ[1:Ngrid]) / 2 # cm # cell center
const dx = xᵥ[2:(Ngrid+1)] .- xᵥ[1:Ngrid] # cm # cell volume

#----------------------------------------------
# porosity parameters
#----------------------------------------------
const phi0 = 0.9472 # dimentionless # surface porosity
const phiL = 0.7884 # dimentionless # bottom porosity
const phi_Inf = 0.7884 # dimentionless # bottom porosity
const xphi = 107.3 # cm # porosity attenuation scale
const phif = broadcast(x -> phiL + (phi0 - phiL) * exp(-x / xphi), x) # dimentionless # fluid volume fraction
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
const Ds = broadcast(x -> 10 * exp(-x / 3), x) # cm^2 yr^-1 # Bioturbation coefficient

#----------------------------------------------
# bioirrigation parameters
#----------------------------------------------
const alpha = broadcast(x -> 10 * exp(-x / 2), x) # cm^2 yr^-1 # Bioirrigation coefficient

#----------------------------------------------
# adsorption parameters
#----------------------------------------------
const KFe_ads = 1.0 # cm^3(porewater) cm^-3(dry sediment) # Adsorption constant

#----------------------------------------------
# solute diffusivity
#----------------------------------------------
const DO2 = 4.2700687755264715E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DSO4 = 1.8034511184582917E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DH = 1.8564498889096735E+03 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DOH = 9.3665996003371845E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DCO2 = 3.3679572156139625E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DHCO3 = 1.9213920442515075E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DCO3 = 1.5899631135414575E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DH2S = 3.0488407320129431E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DHS = 3.5128480809042725E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DFe = 1.2122535663809046E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient

#----------------------------------------------
# boundary fluxes and concentrations
#----------------------------------------------
const FPOC0 = 0.31 # mmol cm^-2 yr^-1 # Flux of POC at the  TOP of sediment column
const FFeOOH0 = 0.023 # mmol cm^-2 yr^-1 # Flux of FeOOH at the  TOP of sediment column
const FFeS0 = 2.22044604925031e-16 # mmol cm^-2 yr^-1 # Flux of FeS at the  TOP of sediment column
const O20 = 8.5e-6 # mmol cm^-3 # Bottom water concentration of O2
const Fe0 = 2.95e-8 # mmol cm^-3 # Concentration of Fe at the TOP of sediment column
const FFe_ads0 = 0.0 # mmol cm^-2 yr^-1 # Flux of adsorbed Fe at the TOP of sediment column
const SO40 = 0.028 # mmol cm^-3 # Bottom water concentration of SO4
const pH0 = 7.59 # free pH scale # Bottom water pH
const TCO20 = 0.002345 # mmol cm^-3 # Bottom water concentration of TCO2
const TH2S0 = 2.22044604925031e-16 # mmol cm^-3 # Bottom water concentration of TH2S
const H0 = 2.5703957827688646E-08 # mmol cm^-3 # Concentration of H at the TOP of sediment column
const OH0 = 2.9591486602166374E-07 # mmol cm^-3 # Concentration of OH at the TOP of sediment column
const HCO30 = 2.2343015802033985E-03 # mmol cm^-3 # Concentration of HCO3 at the TOP of sediment column
const CO30 = 3.8068382897268649E-05 # mmol cm^-3 # Concentration of CO3 at the TOP of sediment column
const CO20 = 7.2630036899332684E-05 # mmol cm^-3 # Concentration of CO2 at the TOP of sediment column
const H2S0 = 8.5713310596138506E-18 # mmol cm^-3 # Concentration of H2S at the TOP of sediment column
const HS0 = 2.1347327386541718E-16 # mmol cm^-3 # Concentration of HS at the TOP of sediment column

#----------------------------------------------
# assemble boundary conditions
#----------------------------------------------
const BcPOC = ((phis[1]us[1], -phis[1]Ds[1], FPOC0), (0.0, 1.0, 0.0)) #  # Boundary condition of POC
const BcFeOOH = ((phis[1]us[1], -phis[1]Ds[1], FFeOOH0), (0.0, 1.0, 0.0)) #  # Boundary condition of FeOOH
const BcFeS = ((phis[1]us[1], -phis[1]Ds[1], FFeS0), (0.0, 1.0, 0.0)) #  # Boundary condition of FeS
const BcO2 = ((1.0, 0.0, O20), (0.0, 1.0, 0.0)) #  # Boundary condition of O2
const BcSO4 = ((1.0, 0.0, SO40), (0.0, 1.0, 0.0)) #  # Boundary condition of SO4
const BcH = ((1.0, 0.0, H0), (0.0, 1.0, 0.0)) #  # Boundary condition of H
const BcOH = ((1.0, 0.0, OH0), (0.0, 1.0, 0.0)) #  # Boundary condition of H
const BcCO2 = ((1.0, 0.0, CO20), (0.0, 1.0, 0.0)) #  # Boundary condition of TCO2
const BcHCO3 = ((1.0, 0.0, HCO30), (0.0, 1.0, 0.0)) #  # Boundary condition of TCO2
const BcCO3 = ((1.0, 0.0, CO30), (0.0, 1.0, 0.0)) #  # Boundary condition of TCO2
const BcH2S = ((1.0, 0.0, H2S0), (0.0, 1.0, 0.0)) #  # Boundary condition of TH2S
const BcHS = ((1.0, 0.0, HS0), (0.0, 1.0, 0.0)) #  # Boundary condition of TH2S
const BcFe = ((1.0, 0.0, Fe0), (0.0, 1.0, 0.0)) #  # Boundary condition of TFe
const BcFe_ads = ((phis[1]us[1], -phis[1]Ds[1], FFe_ads0), (0.0, 1.0, 0.0)) #  # Boundary condition of TFe

#----------------------------------------------
# Boundary transport matrix
#----------------------------------------------
const BcAmPOC, BcBmPOC, BcCmPOC = fvcf_bc(phis, Ds, us, dx, BcPOC, Ngrid) #  # Boundary transport matrix of POC
const BcAmFeOOH, BcBmFeOOH, BcCmFeOOH =
    fvcf_bc(phis, Ds, us, dx, BcFeOOH, Ngrid) #  # Boundary transport matrix of FeOOH
const BcAmFeS, BcBmFeS, BcCmFeS = fvcf_bc(phis, Ds, us, dx, BcFeS, Ngrid) #  # Boundary transport matrix of FeS
const BcAmO2, BcBmO2, BcCmO2 = fvcf_bc(phif, DO2, uf, dx, BcO2, Ngrid) #  # Boundary transport matrix of O2
const BcAmSO4, BcBmSO4, BcCmSO4 = fvcf_bc(phif, DSO4, uf, dx, BcSO4, Ngrid) #  # Boundary transport matrix of SO4
const BcAmH, BcBmH, BcCmH = fvcf_bc(phif, DH, uf, dx, BcH, Ngrid) #  # Boundary transport matrix of H
const BcAmOH, BcBmOH, BcCmOH = fvcf_bc(phif, DOH, uf, dx, BcOH, Ngrid) #  # Boundary transport matrix of OH
const BcAmCO2, BcBmCO2, BcCmCO2 = fvcf_bc(phif, DCO2, uf, dx, BcCO2, Ngrid) #  # Boundary transport matrix of CO2
const BcAmHCO3, BcBmHCO3, BcCmHCO3 = fvcf_bc(phif, DHCO3, uf, dx, BcHCO3, Ngrid) #  # Boundary transport matrix of HCO3
const BcAmCO3, BcBmCO3, BcCmCO3 = fvcf_bc(phif, DCO3, uf, dx, BcCO3, Ngrid) #  # Boundary transport matrix of CO3
const BcAmH2S, BcBmH2S, BcCmH2S = fvcf_bc(phif, DH2S, uf, dx, BcH2S, Ngrid) #  # Boundary transport matrix of H2S
const BcAmHS, BcBmHS, BcCmHS = fvcf_bc(phif, DHS, uf, dx, BcHS, Ngrid) #  # Boundary transport matrix of HS
const BcAmFe, BcBmFe, BcCmFe = fvcf_bc(phif, DFe, uf, dx, BcFe, Ngrid) #  # Boundary transport matrix of Fe
const BcAmFe_ads, BcBmFe_ads, BcCmFe_ads =
    fvcf_bc(phis, Ds, us, dx, BcFe_ads, Ngrid) #  # Boundary transport matrix of Fe_ads

#----------------------------------------------
# Interior transport matrix
#----------------------------------------------
const AmPOC, BmPOC = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of POC
const AmFeOOH, BmFeOOH = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of FeOOH
const AmFeS, BmFeS = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of FeS
const AmO2, BmO2 = fvcf(phif, DO2, uf, dx, Ngrid) #  # Interior transport matrix of O2
const AmSO4, BmSO4 = fvcf(phif, DSO4, uf, dx, Ngrid) #  # Interior transport matrix of SO4
const AmH, BmH = fvcf(phif, DH, uf, dx, Ngrid) #  # Interior transport matrix of H
const AmOH, BmOH = fvcf(phif, DOH, uf, dx, Ngrid) #  # Interior transport matrix of OH
const AmCO2, BmCO2 = fvcf(phif, DCO2, uf, dx, Ngrid) #  # Interior transport matrix of CO2
const AmHCO3, BmHCO3 = fvcf(phif, DHCO3, uf, dx, Ngrid) #  # Interior transport matrix of HCO3
const AmCO3, BmCO3 = fvcf(phif, DCO3, uf, dx, Ngrid) #  # Interior transport matrix of CO3
const AmH2S, BmH2S = fvcf(phif, DH2S, uf, dx, Ngrid) #  # Interior transport matrix of H2S
const AmHS, BmHS = fvcf(phif, DHS, uf, dx, Ngrid) #  # Interior transport matrix of HS
const AmFe, BmFe = fvcf(phif, DFe, uf, dx, Ngrid) #  # Interior transport matrix of Fe
const AmFe_ads, BmFe_ads = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Fe_ads

#----------------------------------------------
# Acid dissociation constants
#----------------------------------------------
const KH2O = 7.6061832368069808E-15 #  # H 1th dissociation constant
const KCO2 = 7.9072510553018769E-07 #  # TCO2 1th dissociation constant
const KHCO3 = 4.3794808956390707E-10 #  # TCO2 2th dissociation constant
const KH2S = 6.4016988617197496E-07 #  # TH2S 1th dissociation constant

#----------------------------------------------
# Reaction parameters
#----------------------------------------------
const k_POC = 0.005 # yr^-1 # POC remineralization rate constant
const KO2 = 1.0e-6 # mmol cm-3 pw yr-1 # Monod constant
const KFeOOH = 500.0 * ds_rho / 1e3 # mmol cm-3 ds # Monod constant
const KSO4 = 0.001 # mmol cm-3 pw yr-1 # Monod constant
const kO2Fe = 5.0e8 # (mmol cm-3 pw)-1 yr-1 #  
const kO2Fe_ads = 5.0e6 # (mmol cm-3 pw)-1 yr-1  #  
const kO2H2S = 100000.0 # (mmol cm-3 pw)-1 yr-1  #  
const kFeOOHH2S = 4000.0 # (mmol cm-3 pw)-0.5 yr-1  #  
const kFeSdis = 0.001 # yr-1  #  
const KspFeS = 10^(-2.2) # (mmol cm-3 pw)^-1  # apparent solubility of FeS  
const kFeSpre = 200e-3 * ds_rho # mmol cm-3 ds yr-1  #  
const Cl = 0.565772678 # mmol cm-3 # normal seawater

#----------------------------------------------
# Inital values
#----------------------------------------------
const C_ini = [
    Fe0,
    FPOC0 / (phis[1] * us[1]),
    FFeOOH0 / (phis[1] * us[1]),
    FFeS0 / (phis[1] * us[1]),
    O20,
    SO40,
    H0,
    TCO20,
    TH2S0,
] #  # initial conditions
const C_uni = repeat(C_ini, outer = Ngrid) # initial conditions

#----------------------------------------------
# Indices
#----------------------------------------------
const TFeID = ((1:Ngrid) .- 1)nspec .+ 1 #  # TFe index
const POCID = ((1:Ngrid) .- 1)nspec .+ 2 #  # POC index
const FeOOHID = ((1:Ngrid) .- 1)nspec .+ 3 #  # FeOOH index
const FeSID = ((1:Ngrid) .- 1)nspec .+ 4 #  # FeS index
const O2ID = ((1:Ngrid) .- 1)nspec .+ 5 #  # O2 index
const SO4ID = ((1:Ngrid) .- 1)nspec .+ 6 #  # SO4 index
const HID = ((1:Ngrid) .- 1)nspec .+ 7 #  # H index
const TCO2ID = ((1:Ngrid) .- 1)nspec .+ 8 #  # TCO2 index
const TH2SID = ((1:Ngrid) .- 1)nspec .+ 9 #  # TH2S index
const IDdict = Dict(
    "TFe" => TFeID,
    "POC" => POCID,
    "FeOOH" => FeOOHID,
    "FeS" => FeSID,
    "O2" => O2ID,
    "SO4" => SO4ID,
    "H" => HID,
    "TCO2" => TCO2ID,
    "TH2S" => TH2SID,
)
nothing
