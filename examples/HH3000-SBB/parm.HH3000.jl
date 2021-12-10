
#----------------------------------------------
# Number of substances
#----------------------------------------------
const nsolid = 11 #  # number of solid substances
const ndissolved = 13 #  # number of dissolved substances
const nsummed = 5 #  # number of summed substances
const nnoneq = 24 #  # number of solid + dissolved substances
const nspec = 29 #  # number of total substances
const Lwbdwth = 33 #  # lower bandwidth of jacobian matrix
const Upbdwth = 33 #  # upper bandwidth of jacobian matrix

#----------------------------------------------
# global parameters
#----------------------------------------------
const depth = 3000.0 # m # water depth
const salinity = 35.0 # psu # bottom water salinity
const temp = 2.0 # Celsius # bottom water temperature
const ds_rho = 2.6 # g cm^-3 # dry sediment density
const O2BW = 8.0e-5 # mmol/cm3 # bottom water oxygen
const sw_dens = 1.0290834608199197 # g cm^-3 # seawater density

#----------------------------------------------
# grid parameters
#----------------------------------------------
const L = 50.0 # cm # model sediment section thickness
const Ngrid = 100 # integer # number of model grid
const pgrid = L / 10 # cm # constant in gridtran, attenuation scale
const Nmat = Ngrid * nspec #  # Jacobian dimention
const ξ = range(0, step = L / (Ngrid), length = Ngrid + 1) # cm # uniform grid
const xᵥ = broadcast(x -> L * (exp(x * pgrid / L) - 1) / (exp(pgrid) - 1), ξ) # cm # no grid transformation
const x = (xᵥ[2:(Ngrid+1)] .+ xᵥ[1:Ngrid]) / 2 # cm # cell center
const dx = xᵥ[2:(Ngrid+1)] .- xᵥ[1:Ngrid] # cm # cell volume

#----------------------------------------------
# porosity parameters
#----------------------------------------------
const phi0 = 0.8 # dimentionless # surface porosity
const phiL = 0.7 # dimentionless # bottom porosity
const xphi = 100.0 # cm # porosity attenuation scale
const phi_Inf = 0.7 # dimentionless # porosity at infinite sediment depth (normally where porosity stops changing). Needed to calculate burial velocities. If constant_porosity_profile = yes, then phi_Inf should be the same as the porosity constant. If constant_porosity_profile = no, then phi_Inf should be consistent with the depth dependent porosity function
const phif = broadcast(x -> phiL + (phi0 - phiL) * exp(-x / xphi), x) # dimentionless # fluid volume fraction
const phis = 1.0 .- phif # dimentionless # solid volume fraction
const pwtods = phif ./ phis # dimentionless # conversion from pore water to solid sediment volume unit
const dstopw = phis ./ phif # dimentionless # conversion from solid sediment to pore water volume unit

#----------------------------------------------
# burial parameters
#----------------------------------------------
const Fsed = 0.01014 # g cm^-2 yr^-1 # total sediment flux
const w_Inf = Fsed / ds_rho / (1 - phi_Inf) # cm yr^-1 # solid sediment burial velocity at infinite depth
const uf = phi_Inf * w_Inf ./ phif # cm yr^-1 # pore water burial velocity
const us = Fsed / ds_rho ./ phis # cm yr^-1 # solid sediment burial velocity

#----------------------------------------------
# bioturbation parameters
#----------------------------------------------
const Dbt0 = 10^(0.76241122 - 0.00039724 * depth) # cm/yr^3 # bioturbation coefficient
const aO2bt = 1.0e-5 # mmol/cm3 # constant used in calculating oxygen dependence of bioturbation
const bO2bt = 5.0e-7 # mmol/cm3 # constant used in calculating oxygen dependence of bioturbation
const fO2bt = 0.5 + 0.5 * erf((O2BW - aO2bt) / bO2bt) # missing # oxygen dependence of bioturbation
const xbt = 2.0 # cm # attentuation scale of bioturbation
const Ds = broadcast(x -> Dbt0 * fO2bt * exp(-x / xbt), x) # cm^2 yr^-1 # Bioturbation coefficient

#----------------------------------------------
# bioirrigation parameters
#----------------------------------------------
const Dbir0 = 28.0 # yr^-1 # bioirrigation constant
const aO2bir = 1.0e-5 # mmol/cm3 # constant used in calculating oxygen dependence of bioirrigation
const bO2bir = 5.0e-7 # mmol/cm3 # constant used in calculating oxygen dependence of bioirrigation
const fO2bir = 0.5 + 0.5 * erf((O2BW - aO2bir) / bO2bir) # missing # oxygen dependence of irrigation
const xbir = 2.0 # cm # attentuation scale of bioirrigation
const alpha = broadcast(x -> Dbir0 * fO2bir * exp(-x / xbir), x) # cm^2 yr^-1 # Bioirrigation coefficient

#----------------------------------------------
# adsorption parameters
#----------------------------------------------
const KNH4_ads = 1.6 * ds_rho # cm^3(porewater) cm^-3(dry sediment) # Adsorption constant
const KMn_ads = 28.0 * ds_rho # cm^3(porewater) cm^-3(dry sediment) # Adsorption constant
const KFe_ads = 268.0 * ds_rho # cm^3(porewater) cm^-3(dry sediment) # Adsorption constant

#----------------------------------------------
# solute diffusivity
#----------------------------------------------
const DO2 = 4.0009939238351797E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DNO3 = 3.1390297096278300E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DCH4 = 3.0439844398127235E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DNO2 = 3.3485834640852744E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DCa = 1.2090579593914902E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DAl = 1.5108642413214525E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DSO4 = 1.6324420755402028E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DH4SiO4 = 1.6311076543398931E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DNdnr = 9.8117588821765196E+01 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DNdr = 9.8117588821765196E+01 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DMn = 1.0660970890036131E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DFe = 1.1027537224364021E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DNH4 = 3.1543033068914923E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DH = 1.7567691572664121E+03 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DOH = 8.5800959988348086E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DCO2 = 3.1525898772554984E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DHCO3 = 1.7136976129828849E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DCO3 = 1.4442713572518861E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DH2S = 2.7982945790805405E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DHS = 3.3436959129609028E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DH3BO3 = 1.8018160505803172E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DH4BO4 = 1.5765890442577776E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DH2PO4 = 1.3642377075902965E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DHPO4 = 1.1039756102174947E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DPO4 = 8.8770147296404019E+01 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DH3PO4 = 1.3173626795578821E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient

#----------------------------------------------
# solute mass transfer velocities
#----------------------------------------------
const delta = 0.05 # cm # thickness of the diffusive boundary layer
const betaO2 = 8.0019878476703589E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaNO3 = 6.2780594192556600E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaCH4 = 6.0879688796254468E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaNO2 = 6.6971669281705481E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaCa = 2.4181159187829803E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaAl = 3.0217284826429050E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaSO4 = 3.2648841510804054E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaH4SiO4 = 3.2622153086797862E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaNdnr = 1.9623517764353039E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaNdr = 1.9623517764353039E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaH = 3.5135383145328240E+04 # cm yr^-1 # solute mass transfer velocity across SWI
const betaOH = 1.7160191997669615E+04 # cm yr^-1 # solute mass transfer velocity across SWI
const betaCO2 = 6.3051797545109966E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaHCO3 = 3.4273952259657699E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaCO3 = 2.8885427145037720E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaH2S = 5.5965891581610804E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaHS = 6.6873918259218053E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaH3BO3 = 3.6036321011606342E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaH4BO4 = 3.1531780885155549E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaH2PO4 = 2.7284754151805928E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaHPO4 = 2.2079512204349894E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaPO4 = 1.7754029459280803E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaH3PO4 = 2.6347253591157641E+03 # cm yr^-1 # solute mass transfer velocity across SWI

#----------------------------------------------
# boundary fluxes and concentrations
#----------------------------------------------
const FPOC0 = 0.05833333333333333 # mmol cm^-2 yr^-1 # Flux of POC at the  TOP of sediment column
const FMnO20 = 0.00046141244994539504 # mmol cm^-2 yr^-1 # Flux of MnO2 at the  TOP of sediment column
const FFeOOH0 = 0.0013629032258064516 # mmol cm^-2 yr^-1 # Flux of FeOOH at the  TOP of sediment column
const FFeS0 = 0.0 # mmol cm^-2 yr^-1 # Flux of FeS at the  TOP of sediment column
const FFeS20 = 0.0 # mmol cm^-2 yr^-1 # Flux of FeS2 at the  TOP of sediment column
const FCaCO30 = 0.0005 # mmol cm^-2 yr^-1 # Flux of CaCO3 at the  TOP of sediment column
const FMnCO30 = 0.0 # mmol cm^-2 yr^-1 # Flux of MnCO3 at the  TOP of sediment column
const FFeCO30 = 0.0 # mmol cm^-2 yr^-1 # Flux of FeCO3 at the  TOP of sediment column
const Age0 = 0.0 # year # missing
const FBSi0 = 0.0355998576005696 # mmol cm^-2 yr^-1 # Flux of BSi at the  TOP of sediment column
const FAnnite0 = Fsed * 0.1 / 511.88 * 1000 # mmol cm^-2 yr^-1 # Flux of Annite at the  TOP of sediment column
const FMoS40 = 0.0 # mmol cm^-2 yr^-1 # Flux of MoS4 at the  TOP of sediment column
const FBasalt0 = Fsed * 0.02 / 87.383 * 1000 # mmol cm^-2 yr^-2 # Flux of Basalt at the  TOP of sediment column
const O2BW = 8.0e-5 # mmol cm^-3 # Bottom water concentration of O2
const NO3BW = 2.0e-5 # mmol cm^-3 # Bottom water concentration of NO3
const Mn0 = 5.0e-10 # mmol cm^-3 # Concentration of Mn at the TOP of sediment column
const Fe0 = 1.0e-9 # mmol cm^-3 # Concentration of Fe at the TOP of sediment column
const CH4BW = 0.0 # mmol cm^-3 # Bottom water concentration of CH4
const NO2BW = 2.0e-5 # mmol cm^-3 # Bottom water concentration of NO2
const CaBW = 0.01033 # mmol cm^-3 # Bottom water concentration of Ca
const AlBW = 1.0e-9 # mmol cm^-3 # Bottom water concentration of Al
const MoBW = 1.2e-7 # mmol cm^-3 # Bottom water concentration of Mo
const NH40 = 1.0e-6 # mmol cm^-3 # Concentration of NH4 at the TOP of sediment column
const TH3PO4BW = 2.8e-6 # mmol cm^-3 # Bottom water concentration of H3PO4
const SO4BW = 0.028 # mmol cm^-3 # Bottom water concentration of SO4
const H4SiO4BW = 0.00017 # mmol cm^-3 # Bottom water concentration of H4SiO4
const NdBW = 3.5e-11 # mmol cm^-3 # Bottom water concentration of Nd
const eNdBW = -2.3 # missing # Bottom water eNd
const NdnrBW = 8.3293e-12 # mmol cm^-3 # Bottom water concentration of Nd144
const NdrBW = 4.268933612790519e-12 # mmol cm^-3 # Bottom water concentration of Nd143
const pHBW = 7.62 # free pH scale # Bottom water pH
const TCO2BW = 0.00236 # mmol cm^-3 # Bottom water concentration of TCO2
const TH2SBW = 0.0 # mmol cm^-3 # Bottom water concentration of TH2S
const TH3BO3BW = 8.7062e-5 # mmol cm^-3 # Bottom water concentration of TH3BO3
const HBW = 2.3988329190194897E-08 # mmol cm^-3 # Bottom water concentration of H
const OHBW = 3.0840219029483606E-07 # mmol cm^-3 # Bottom water concentration of OH
const HCO3BW = 2.2598877805390218E-03 # mmol cm^-3 # Bottom water concentration of HCO3
const CO3BW = 4.4901038123846659E-05 # mmol cm^-3 # Bottom water concentration of CO3
const CO2BW = 5.5211181337131804E-05 # mmol cm^-3 # Bottom water concentration of CO2
const H2SBW = 0.0000000000000000E+00 # mmol cm^-3 # Bottom water concentration of H2S
const HSBW = 0.0000000000000000E+00 # mmol cm^-3 # Bottom water concentration of HS
const H3BO3BW = 8.1450125183506398E-05 # mmol cm^-3 # Bottom water concentration of H3BO3
const H4BO4BW = 5.6118748164935938E-06 # mmol cm^-3 # Bottom water concentration of H4BO4
const H3PO4BW = 7.6017785673264449E-14 # mmol cm^-3 # Bottom water concentration of H3PO4
const H2PO4BW = 8.2097551403566648E-08 # mmol cm^-3 # Bottom water concentration of H2PO4
const HPO4BW = 2.6566241456605454E-06 # mmol cm^-3 # Bottom water concentration of HPO4
const PO4BW = 6.1278226918101791E-08 # mmol cm^-3 # Bottom water concentration of PO4
const Mn_ads0 = KMn_ads * Mn0 # mmol cm^-3 # Concentration of adsorbed Mn at the TOP of sediment column
const Fe_ads0 = KFe_ads * Fe0 # mmol cm^-3 # Concentration of adsorbed Fe at the TOP of sediment column
const NH4_ads0 = KNH4_ads * NH40 # mmol cm^-3 # Concentration of adsorbed NH4 at the TOP of sediment column

#----------------------------------------------
# assemble boundary conditions
#----------------------------------------------
const BcPOC = ((phis[1]us[1], -phis[1]Ds[1], FPOC0), (0.0, 1.0, 0.0)) #  # Boundary condition of POC
const BcMnO2 = ((phis[1]us[1], -phis[1]Ds[1], FMnO20), (0.0, 1.0, 0.0)) #  # Boundary condition of MnO2
const BcFeOOH = ((phis[1]us[1], -phis[1]Ds[1], FFeOOH0), (0.0, 1.0, 0.0)) #  # Boundary condition of FeOOH
const BcFeS = ((phis[1]us[1], -phis[1]Ds[1], FFeS0), (0.0, 1.0, 0.0)) #  # Boundary condition of FeS
const BcFeS2 = ((phis[1]us[1], -phis[1]Ds[1], FFeS20), (0.0, 1.0, 0.0)) #  # Boundary condition of FeS2
const BcCaCO3 = ((phis[1]us[1], -phis[1]Ds[1], FCaCO30), (0.0, 1.0, 0.0)) #  # Boundary condition of CaCO3
const BcMnCO3 = ((phis[1]us[1], -phis[1]Ds[1], FMnCO30), (0.0, 1.0, 0.0)) #  # Boundary condition of MnCO3
const BcFeCO3 = ((phis[1]us[1], -phis[1]Ds[1], FFeCO30), (0.0, 1.0, 0.0)) #  # Boundary condition of FeCO3
const BcAge = ((1.0, 0.0, Age0), (0.0, 1.0, 1.0 / us[Ngrid])) #  # Boundary condition of Age
const BcBSi = ((phis[1]us[1], -phis[1]Ds[1], FBSi0), (0.0, 1.0, 0.0)) #  # Boundary condition of BSi
const BcBasalt = ((phis[1]us[1], -phis[1]Ds[1], FBasalt0), (0.0, 1.0, 0.0)) #  # Boundary condition of Basalt
const BcO2 =
    ((betaO2 + phif[1]uf[1], -phif[1]DO2[1], betaO2 * O2BW), (0.0, 1.0, 0.0)) #  # Boundary condition of O2
const BcNO3 = (
    (betaNO3 + phif[1]uf[1], -phif[1]DNO3[1], betaNO3 * NO3BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of NO3
const BcCH4 = (
    (betaCH4 + phif[1]uf[1], -phif[1]DCH4[1], betaCH4 * CH4BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of CH4
const BcNO2 = (
    (betaNO2 + phif[1]uf[1], -phif[1]DNO2[1], betaNO2 * NO2BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of NO2
const BcCa =
    ((betaCa + phif[1]uf[1], -phif[1]DCa[1], betaCa * CaBW), (0.0, 1.0, 0.0)) #  # Boundary condition of Ca
const BcAl =
    ((betaAl + phif[1]uf[1], -phif[1]DAl[1], betaAl * AlBW), (0.0, 1.0, 0.0)) #  # Boundary condition of Al
const BcSO4 = (
    (betaSO4 + phif[1]uf[1], -phif[1]DSO4[1], betaSO4 * SO4BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of SO4
const BcH4SiO4 = (
    (betaH4SiO4 + phif[1]uf[1], -phif[1]DH4SiO4[1], betaH4SiO4 * H4SiO4BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of H4SiO4
const BcNdnr = (
    (betaNdnr + phif[1]uf[1], -phif[1]DNdnr[1], betaNdnr * NdnrBW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of Ndnr
const BcNdr = (
    (betaNdr + phif[1]uf[1], -phif[1]DNdr[1], betaNdr * NdrBW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of Ndr
const BcMn = ((1.0, 0.0, Mn0), (0.0, 1.0, 0.0)) #  # Boundary condition of Mn
const BcFe = ((1.0, 0.0, Fe0), (0.0, 1.0, 0.0)) #  # Boundary condition of Fe
const BcNH4 = ((1.0, 0.0, NH40), (0.0, 1.0, 0.0)) #  # Boundary condition of NH4
const BcH =
    ((betaH + phif[1]uf[1], -phif[1]DH[1], betaH * HBW), (0.0, 1.0, 0.0)) #  # Boundary condition of H
const BcOH =
    ((betaOH + phif[1]uf[1], -phif[1]DOH[1], betaOH * OHBW), (0.0, 1.0, 0.0)) #  # Boundary condition of H
const BcCO2 = (
    (betaCO2 + phif[1]uf[1], -phif[1]DCO2[1], betaCO2 * CO2BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of TCO2
const BcHCO3 = (
    (betaHCO3 + phif[1]uf[1], -phif[1]DHCO3[1], betaHCO3 * HCO3BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of TCO2
const BcCO3 = (
    (betaCO3 + phif[1]uf[1], -phif[1]DCO3[1], betaCO3 * CO3BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of TCO2
const BcH2S = (
    (betaH2S + phif[1]uf[1], -phif[1]DH2S[1], betaH2S * H2SBW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of TH2S
const BcHS =
    ((betaHS + phif[1]uf[1], -phif[1]DHS[1], betaHS * HSBW), (0.0, 1.0, 0.0)) #  # Boundary condition of TH2S
const BcH3BO3 = (
    (betaH3BO3 + phif[1]uf[1], -phif[1]DH3BO3[1], betaH3BO3 * H3BO3BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of TH3BO3
const BcH4BO4 = (
    (betaH4BO4 + phif[1]uf[1], -phif[1]DH4BO4[1], betaH4BO4 * H4BO4BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of TH3BO3
const BcH2PO4 = (
    (betaH2PO4 + phif[1]uf[1], -phif[1]DH2PO4[1], betaH2PO4 * H2PO4BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of TH3PO4
const BcHPO4 = (
    (betaHPO4 + phif[1]uf[1], -phif[1]DHPO4[1], betaHPO4 * HPO4BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of TH3PO4
const BcPO4 = (
    (betaPO4 + phif[1]uf[1], -phif[1]DPO4[1], betaPO4 * PO4BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of TH3PO4
const BcH3PO4 = (
    (betaH3PO4 + phif[1]uf[1], -phif[1]DH3PO4[1], betaH3PO4 * H3PO4BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of TH3PO4
const BcMn_ads = ((1.0, 0.0, Mn_ads0), (0.0, 1.0, 0.0)) #  # Boundary condition of Mn
const BcFe_ads = ((1.0, 0.0, Fe_ads0), (0.0, 1.0, 0.0)) #  # Boundary condition of Fe
const BcNH4_ads = ((1.0, 0.0, NH4_ads0), (0.0, 1.0, 0.0)) #  # Boundary condition of NH4

#----------------------------------------------
# Boundary transport matrix
#----------------------------------------------
const BcAmPOC, BcBmPOC, BcCmPOC = fvcf_bc(phis, Ds, us, dx, BcPOC, Ngrid) #  # Boundary transport matrix of POC
const BcAmMnO2, BcBmMnO2, BcCmMnO2 = fvcf_bc(phis, Ds, us, dx, BcMnO2, Ngrid) #  # Boundary transport matrix of MnO2
const BcAmFeOOH, BcBmFeOOH, BcCmFeOOH =
    fvcf_bc(phis, Ds, us, dx, BcFeOOH, Ngrid) #  # Boundary transport matrix of FeOOH
const BcAmFeS, BcBmFeS, BcCmFeS = fvcf_bc(phis, Ds, us, dx, BcFeS, Ngrid) #  # Boundary transport matrix of FeS
const BcAmFeS2, BcBmFeS2, BcCmFeS2 = fvcf_bc(phis, Ds, us, dx, BcFeS2, Ngrid) #  # Boundary transport matrix of FeS2
const BcAmCaCO3, BcBmCaCO3, BcCmCaCO3 =
    fvcf_bc(phis, Ds, us, dx, BcCaCO3, Ngrid) #  # Boundary transport matrix of CaCO3
const BcAmMnCO3, BcBmMnCO3, BcCmMnCO3 =
    fvcf_bc(phis, Ds, us, dx, BcMnCO3, Ngrid) #  # Boundary transport matrix of MnCO3
const BcAmFeCO3, BcBmFeCO3, BcCmFeCO3 =
    fvcf_bc(phis, Ds, us, dx, BcFeCO3, Ngrid) #  # Boundary transport matrix of FeCO3
const BcAmAge, BcBmAge, BcCmAge = fvcf_bc(phis, Ds, us, dx, BcAge, Ngrid) #  # Boundary transport matrix of Age
const BcAmBSi, BcBmBSi, BcCmBSi = fvcf_bc(phis, Ds, us, dx, BcBSi, Ngrid) #  # Boundary transport matrix of BSi
const BcAmBasalt, BcBmBasalt, BcCmBasalt =
    fvcf_bc(phis, Ds, us, dx, BcBasalt, Ngrid) #  # Boundary transport matrix of Basalt
const BcAmO2, BcBmO2, BcCmO2 = fvcf_bc(phif, DO2, uf, dx, BcO2, Ngrid) #  # Boundary transport matrix of O2
const BcAmNO3, BcBmNO3, BcCmNO3 = fvcf_bc(phif, DNO3, uf, dx, BcNO3, Ngrid) #  # Boundary transport matrix of NO3
const BcAmCH4, BcBmCH4, BcCmCH4 = fvcf_bc(phif, DCH4, uf, dx, BcCH4, Ngrid) #  # Boundary transport matrix of CH4
const BcAmNO2, BcBmNO2, BcCmNO2 = fvcf_bc(phif, DNO2, uf, dx, BcNO2, Ngrid) #  # Boundary transport matrix of NO2
const BcAmCa, BcBmCa, BcCmCa = fvcf_bc(phif, DCa, uf, dx, BcCa, Ngrid) #  # Boundary transport matrix of Ca
const BcAmAl, BcBmAl, BcCmAl = fvcf_bc(phif, DAl, uf, dx, BcAl, Ngrid) #  # Boundary transport matrix of Al
const BcAmSO4, BcBmSO4, BcCmSO4 = fvcf_bc(phif, DSO4, uf, dx, BcSO4, Ngrid) #  # Boundary transport matrix of SO4
const BcAmH4SiO4, BcBmH4SiO4, BcCmH4SiO4 =
    fvcf_bc(phif, DH4SiO4, uf, dx, BcH4SiO4, Ngrid) #  # Boundary transport matrix of H4SiO4
const BcAmNdnr, BcBmNdnr, BcCmNdnr = fvcf_bc(phif, DNdnr, uf, dx, BcNdnr, Ngrid) #  # Boundary transport matrix of Ndnr
const BcAmNdr, BcBmNdr, BcCmNdr = fvcf_bc(phif, DNdr, uf, dx, BcNdr, Ngrid) #  # Boundary transport matrix of Ndr
const BcAmMn, BcBmMn, BcCmMn = fvcf_bc(phif, DMn, uf, dx, BcMn, Ngrid) #  # Boundary transport matrix of Mn
const BcAmFe, BcBmFe, BcCmFe = fvcf_bc(phif, DFe, uf, dx, BcFe, Ngrid) #  # Boundary transport matrix of Fe
const BcAmNH4, BcBmNH4, BcCmNH4 = fvcf_bc(phif, DNH4, uf, dx, BcNH4, Ngrid) #  # Boundary transport matrix of NH4
const BcAmH, BcBmH, BcCmH = fvcf_bc(phif, DH, uf, dx, BcH, Ngrid) #  # Boundary transport matrix of H
const BcAmOH, BcBmOH, BcCmOH = fvcf_bc(phif, DOH, uf, dx, BcOH, Ngrid) #  # Boundary transport matrix of OH
const BcAmCO2, BcBmCO2, BcCmCO2 = fvcf_bc(phif, DCO2, uf, dx, BcCO2, Ngrid) #  # Boundary transport matrix of CO2
const BcAmHCO3, BcBmHCO3, BcCmHCO3 = fvcf_bc(phif, DHCO3, uf, dx, BcHCO3, Ngrid) #  # Boundary transport matrix of HCO3
const BcAmCO3, BcBmCO3, BcCmCO3 = fvcf_bc(phif, DCO3, uf, dx, BcCO3, Ngrid) #  # Boundary transport matrix of CO3
const BcAmH2S, BcBmH2S, BcCmH2S = fvcf_bc(phif, DH2S, uf, dx, BcH2S, Ngrid) #  # Boundary transport matrix of H2S
const BcAmHS, BcBmHS, BcCmHS = fvcf_bc(phif, DHS, uf, dx, BcHS, Ngrid) #  # Boundary transport matrix of HS
const BcAmH3BO3, BcBmH3BO3, BcCmH3BO3 =
    fvcf_bc(phif, DH3BO3, uf, dx, BcH3BO3, Ngrid) #  # Boundary transport matrix of H3BO3
const BcAmH4BO4, BcBmH4BO4, BcCmH4BO4 =
    fvcf_bc(phif, DH4BO4, uf, dx, BcH4BO4, Ngrid) #  # Boundary transport matrix of H4BO4
const BcAmH2PO4, BcBmH2PO4, BcCmH2PO4 =
    fvcf_bc(phif, DH2PO4, uf, dx, BcH2PO4, Ngrid) #  # Boundary transport matrix of H2PO4
const BcAmHPO4, BcBmHPO4, BcCmHPO4 = fvcf_bc(phif, DHPO4, uf, dx, BcHPO4, Ngrid) #  # Boundary transport matrix of HPO4
const BcAmPO4, BcBmPO4, BcCmPO4 = fvcf_bc(phif, DPO4, uf, dx, BcPO4, Ngrid) #  # Boundary transport matrix of PO4
const BcAmH3PO4, BcBmH3PO4, BcCmH3PO4 =
    fvcf_bc(phif, DH3PO4, uf, dx, BcH3PO4, Ngrid) #  # Boundary transport matrix of H3PO4
const BcAmMn_ads, BcBmMn_ads, BcCmMn_ads =
    fvcf_bc(phis, Ds, us, dx, BcMn_ads, Ngrid) #  # Boundary transport matrix of Mn_ads
const BcAmFe_ads, BcBmFe_ads, BcCmFe_ads =
    fvcf_bc(phis, Ds, us, dx, BcFe_ads, Ngrid) #  # Boundary transport matrix of Fe_ads
const BcAmNH4_ads, BcBmNH4_ads, BcCmNH4_ads =
    fvcf_bc(phis, Ds, us, dx, BcNH4_ads, Ngrid) #  # Boundary transport matrix of NH4_ads

#----------------------------------------------
# Interior transport matrix
#----------------------------------------------
const AmPOC, BmPOC = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of POC
const AmMnO2, BmMnO2 = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of MnO2
const AmFeOOH, BmFeOOH = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of FeOOH
const AmFeS, BmFeS = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of FeS
const AmFeS2, BmFeS2 = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of FeS2
const AmCaCO3, BmCaCO3 = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of CaCO3
const AmMnCO3, BmMnCO3 = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of MnCO3
const AmFeCO3, BmFeCO3 = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of FeCO3
const AmAge, BmAge = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Age
const AmBSi, BmBSi = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of BSi
const AmBasalt, BmBasalt = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Basalt
const AmO2, BmO2 = fvcf(phif, DO2, uf, dx, Ngrid) #  # Interior transport matrix of O2
const AmNO3, BmNO3 = fvcf(phif, DNO3, uf, dx, Ngrid) #  # Interior transport matrix of NO3
const AmCH4, BmCH4 = fvcf(phif, DCH4, uf, dx, Ngrid) #  # Interior transport matrix of CH4
const AmNO2, BmNO2 = fvcf(phif, DNO2, uf, dx, Ngrid) #  # Interior transport matrix of NO2
const AmCa, BmCa = fvcf(phif, DCa, uf, dx, Ngrid) #  # Interior transport matrix of Ca
const AmAl, BmAl = fvcf(phif, DAl, uf, dx, Ngrid) #  # Interior transport matrix of Al
const AmSO4, BmSO4 = fvcf(phif, DSO4, uf, dx, Ngrid) #  # Interior transport matrix of SO4
const AmH4SiO4, BmH4SiO4 = fvcf(phif, DH4SiO4, uf, dx, Ngrid) #  # Interior transport matrix of H4SiO4
const AmNdnr, BmNdnr = fvcf(phif, DNdnr, uf, dx, Ngrid) #  # Interior transport matrix of Ndnr
const AmNdr, BmNdr = fvcf(phif, DNdr, uf, dx, Ngrid) #  # Interior transport matrix of Ndr
const AmMn, BmMn = fvcf(phif, DMn, uf, dx, Ngrid) #  # Interior transport matrix of Mn
const AmFe, BmFe = fvcf(phif, DFe, uf, dx, Ngrid) #  # Interior transport matrix of Fe
const AmNH4, BmNH4 = fvcf(phif, DNH4, uf, dx, Ngrid) #  # Interior transport matrix of NH4
const AmH, BmH = fvcf(phif, DH, uf, dx, Ngrid) #  # Interior transport matrix of H
const AmOH, BmOH = fvcf(phif, DOH, uf, dx, Ngrid) #  # Interior transport matrix of OH
const AmCO2, BmCO2 = fvcf(phif, DCO2, uf, dx, Ngrid) #  # Interior transport matrix of CO2
const AmHCO3, BmHCO3 = fvcf(phif, DHCO3, uf, dx, Ngrid) #  # Interior transport matrix of HCO3
const AmCO3, BmCO3 = fvcf(phif, DCO3, uf, dx, Ngrid) #  # Interior transport matrix of CO3
const AmH2S, BmH2S = fvcf(phif, DH2S, uf, dx, Ngrid) #  # Interior transport matrix of H2S
const AmHS, BmHS = fvcf(phif, DHS, uf, dx, Ngrid) #  # Interior transport matrix of HS
const AmH3BO3, BmH3BO3 = fvcf(phif, DH3BO3, uf, dx, Ngrid) #  # Interior transport matrix of H3BO3
const AmH4BO4, BmH4BO4 = fvcf(phif, DH4BO4, uf, dx, Ngrid) #  # Interior transport matrix of H4BO4
const AmH2PO4, BmH2PO4 = fvcf(phif, DH2PO4, uf, dx, Ngrid) #  # Interior transport matrix of H2PO4
const AmHPO4, BmHPO4 = fvcf(phif, DHPO4, uf, dx, Ngrid) #  # Interior transport matrix of HPO4
const AmPO4, BmPO4 = fvcf(phif, DPO4, uf, dx, Ngrid) #  # Interior transport matrix of PO4
const AmH3PO4, BmH3PO4 = fvcf(phif, DH3PO4, uf, dx, Ngrid) #  # Interior transport matrix of H3PO4
const AmMn_ads, BmMn_ads = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Mn_ads
const AmFe_ads, BmFe_ads = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Fe_ads
const AmNH4_ads, BmNH4_ads = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of NH4_ads

#----------------------------------------------
# Acid dissociation constants
#----------------------------------------------
const KH2O = 7.3980532637696576E-15 #  # H 1th dissociation constant
const KCO2 = 9.8188321096491150E-07 #  # TCO2 1th dissociation constant
const KHCO3 = 4.7661697752063504E-10 #  # TCO2 2th dissociation constant
const KH2S = 7.7624695805430387E-07 #  # TH2S 1th dissociation constant
const KH3BO3 = 1.6527844514531606E-09 #  # TH3BO3 1th dissociation constant
const KH3PO4 = 2.5906872600083355E-02 #  # TH3PO4 1th dissociation constant
const KH2PO4 = 7.7624695805430387E-07 #  # TH3PO4 2th dissociation constant
const KHPO4 = 5.5331962630242337E-10 #  # TH3PO4 3th dissociation constant

#----------------------------------------------
# Reaction parameters
#----------------------------------------------
const KO2 = 1.0e-6 #  mmol cm-3 pw yr-1 # Monod constant
const nu = 0.125 # dimentionless # POC reactivity
const a = 0.2 # yr # initial POC age
const rNC = 0.125 # mol mol^-1 # N/C ratio Sediment trap 
const rPC = 0.005 # mol mol^-2 # P/C ratio Sediment trap
const KNO2 = 1.0e-5 # mmol cm-3 pw yr-1 # Monod constant
const KNO3 = 1.0e-5 # mmol cm-3 pw yr-1 # Monod constant
const KMnO2 = 5 / (86.93685 / ds_rho / 10) # mmol cm-3 ds # Monod constant
const KFeOOH = 20 / (88.85174 / ds_rho / 10) # mmol cm-3 ds # Monod constant
const KSO4 = 0.0005 # mmol cm-3 pw yr-1 # Monod constant
const kO2NO2 = 1.0e7 # (mmol cm-3 pw)-1 yr-1 #  
const kO2NH4 = 1.0e7 # (mmol cm-3 pw)-1 yr-1 #  
const kO2Mn = 5.0e6 # (mmol cm-3 pw)-1 yr-1  #  
const kO2Mn_ads = 1.0e7 # (mmol cm-3 pw)-1 yr-1  #  
const kO2Fe = 5.0e8 # (mmol cm-3 pw)-1 yr-1 #  
const kO2Fe_ads = 5.0e6 # (mmol cm-3 pw)-1 yr-1  #  
const kO2H2S = 100000.0 # (mmol cm-3 pw)-1 yr-1  #  
const kO2FeS = 100000.0 # (mmol cm-3 pw)-1 yr-1  #  
const kO2CH4 = 1.0e10 # (mmol cm-3 pw)-1 yr-1  #  
const kNO2NH4 = 1.0e8 # (mmol cm-3 pw)-1 yr-1  #  
const kNO3Mn = 100000.0 # (mmol cm-3 pw)-1 yr-1  #  
const kNO3Fe = 150000.0 # (mmol cm-3 pw)-1 yr-1  #  
const kNO3H2S = 0.0 # (mmol cm-3 pw)-1 yr-1 #  
const kAOM = 0.04 # yr-1  #  
const KAOM = 0.001 # mmol cm-3 pw yr-1  #  
const kMnO2Fe = 1.0e7 # (mmol cm-3 pw)-1 yr-1  #  
const kMnO2H2S = 100000.0 # (mmol cm-3 pw)-1 yr-1  #  
const kFeOOHH2S = 4.0 # (mmol cm-3 pw)-0.5 yr-1  #  
const kFeSH2S = 300.0 # (mmol cm-3 pw)-1 yr-1  #  
const kFeSdis = 0.001 # yr-1  #  
const KspFeS = 10^(-2.2) # (mmol cm-3 pw)^-1  # apparent solubility of FeS  
const kFeSpre = 200e-3 * ds_rho # mmol cm-3 ds yr-1  #  
const kCaCO3dis = 0.02 # yr^-1  # missing
const KspCaCO3_dis = 4.49609622396569E-07 * sw_dens^2 # (mmol cm^-3 pw)^2 # missing
const kCaCO3pre = 9.0e-5 # mmol cm^-3 ds yr^-1  # missing
const KspCaCO3_pre = 4.49609622396569E-07 * sw_dens^2 # (mmol cm^-3 pw)^2 # missing
const kMnCO3dis = 0.001 # yr-1  # missing
const KspMnCO3 = 10^(-8.5) * sw_dens^2 # (mmol cm-3 pw)^-2  # missing
const kMnCO3pre = 0.000005 * ds_rho # mmol cm-3 ds yr-1  # missing
const kFeCO3dis = 0.3 # yr-1  # missing
const KspFeCO3 = 10^(-8.4) * sw_dens^2 # (mmol cm-3 pw)^-2   # missing
const kFeCO3pre = 0.0001 # mmol cm-3 ds yr-1  # missing
const kBSidis0 = 5e-6 * 365 * 24 # yr-1 # opal dissolution rate
const xBSi = 10.0 # cm # dissolution attenuation scale
const kBSidis = broadcast(x -> kBSidis0 * exp(-x / xBSi), x) # missing # depth dependent dissolution rate
const H4SiO4_dis_sat =
    2.754 * exp(
        1 / (temp + 273.15) * (
            -2229 - 3.688e-3 * (1500 - 22 * 60) + 0.20 * (depth / 10) -
            2.7e-4 * (depth / 10)^2 + 1.46e-7 * (depth / 10)^3
        ),
    ) # mmol cm-3 pw # solubility of opal
const nuBSi = 50e-6 * 365 * 24 # missing # missing
const aBSi = 1.0 # missing # missing
const kASipre = 20e-6 * 365 * 24 # yr-1  # authigenic silicate precipitation rate
const H4SiO4_pre_sat = 0.0002 # mmol cm-3 pw # authigenic silicate precipitation threshold
const SAnnite = 1.7 #  m2/g  # surface area
const MAnnite = 511.88 #  g/mol # missing
const EaAnnite = 49000.0 #  J/mol  # activation energy
const kAnnite_0 =
    1.9e-12 *
    365 *
    24 *
    3600 *
    exp(-EaAnnite / 8.314 * (1.0 / (273.15 + temp) - 1.0 / 298.15)) # mol m^-2 yr^-1 # Annite dissolution rate
const kAnnite = kAnnite_0 * SAnnite * MAnnite # yr^-1 # missing
const a_s0 = 1e6 # yr  # initial age of Annite
const pl = 0.6 #  exponent of age dependent silicate weathering rate R=R_0*t^p  # missing
const KBW = 0.010578038 # mmol cm-3 # missing
const KAnnite = 10^(39.35134272) #  apparen solubility # missing
const kMoS4_pre = 0.5e5 # (mmol cm-3)-1 yr-1 pw  # missing
const TH2S_Mo_pre = 0.1e-6 # mmol cm-3  # hreshold for MoS4 precipitation 
const Cl = 0.565772678 # mmol cm-3 # bottom water Cl concentration
const rNdSi = 8.37018234241649e-6 # dimentionless (mol/mol) # Nd:Si ratio in oceanic arc basalt
const rNdnrSi = 0.23798 * rNdSi # missing # missing
const eNd_Basalt = 10.0 # missing # missing
const rNdrSi = rNdnrSi * (eNd_Basalt / 1e4 + 1) * 0.512638 # missing # missing
const KspBasalt = 41.63251909642741 # missing # missing
const SABasalt = 9999.999999999998 # cm2 g^-1 # missing
const Mbasalt = 87.383 # g/mol # missing
const EaBasalt = 25500.0 # J mol^-1 # missing
const kBasalt_0 =
    10^(-5.6) *
    365 *
    24 *
    3600 *
    exp(-EaBasalt / 8.314 / (273.15 + temp)) *
    0.75 / 0.076^0.33 # mol cm^-2 yr^-1 # missing
const kBasalt = kBasalt_0 * SABasalt * Mbasalt # yr^-1 # missing
const aBasalt = 30.0 # yr  # initial age of Annite
const pBasalt = 0.65 #  exponent of age dependent silicate weathering rate R=R_0*t^p  # missing
const rNdMn = 0.0001 # missing # missing
const rNdnrMn = 0.23798 * rNdMn # missing # missing
const eNd_MnO2 = -2.3 # missing # missing
const rNdrMn = rNdnrMn * (eNd_MnO2 / 1e4 + 1) * 0.512638 # missing # missing
const rNdFe = 0.0001 # missing # missing
const rNdnrFe = 0.23798 * rNdFe # missing # missing
const eNd_FeOOH = -2.3 # missing # missing
const rNdrFe = rNdnrFe * (eNd_FeOOH / 1e4 + 1) * 0.512638 # missing # missing
const fNdnr = 0.23798 # missing # missing
const KspNdPO4 = 10^(-25.42 + 2.76 + 2.91) # missing # missing
const kNdPO4 = 2.0e-9 # missing # missing

#----------------------------------------------
# Inital values
#----------------------------------------------
const C_ini = [
    FPOC0 / (phis[1] * us[1]),
    FMnO20 / (phis[1] * us[1]),
    FFeOOH0 / (phis[1] * us[1]),
    FFeS0 / (phis[1] * us[1]),
    FFeS20 / (phis[1] * us[1]),
    FCaCO30 / (phis[1] * us[1]),
    FMnCO30 / (phis[1] * us[1]),
    FFeCO30 / (phis[1] * us[1]),
    Age0,
    FBSi0 / (phis[1] * us[1]),
    FBasalt0 / (phis[1] * us[1]),
    O2BW,
    NO3BW,
    CH4BW,
    NO2BW,
    CaBW,
    AlBW,
    SO4BW,
    H4SiO4BW,
    NdnrBW,
    NdrBW,
    Mn0,
    Fe0,
    NH40,
    HBW,
    TCO2BW,
    TH2SBW,
    TH3BO3BW,
    TH3PO4BW,
] #  # initial conditions
const C_uni = repeat(C_ini, outer = Ngrid) # initial conditions

#----------------------------------------------
# Indices
#----------------------------------------------
const POCID = ((1:Ngrid) .- 1)nspec .+ 1 #  # POC index
const MnO2ID = ((1:Ngrid) .- 1)nspec .+ 2 #  # MnO2 index
const FeOOHID = ((1:Ngrid) .- 1)nspec .+ 3 #  # FeOOH index
const FeSID = ((1:Ngrid) .- 1)nspec .+ 4 #  # FeS index
const FeS2ID = ((1:Ngrid) .- 1)nspec .+ 5 #  # FeS2 index
const CaCO3ID = ((1:Ngrid) .- 1)nspec .+ 6 #  # CaCO3 index
const MnCO3ID = ((1:Ngrid) .- 1)nspec .+ 7 #  # MnCO3 index
const FeCO3ID = ((1:Ngrid) .- 1)nspec .+ 8 #  # FeCO3 index
const AgeID = ((1:Ngrid) .- 1)nspec .+ 9 #  # Age index
const BSiID = ((1:Ngrid) .- 1)nspec .+ 10 #  # BSi index
const BasaltID = ((1:Ngrid) .- 1)nspec .+ 11 #  # Basalt index
const O2ID = ((1:Ngrid) .- 1)nspec .+ 12 #  # O2 index
const NO3ID = ((1:Ngrid) .- 1)nspec .+ 13 #  # NO3 index
const CH4ID = ((1:Ngrid) .- 1)nspec .+ 14 #  # CH4 index
const NO2ID = ((1:Ngrid) .- 1)nspec .+ 15 #  # NO2 index
const CaID = ((1:Ngrid) .- 1)nspec .+ 16 #  # Ca index
const AlID = ((1:Ngrid) .- 1)nspec .+ 17 #  # Al index
const SO4ID = ((1:Ngrid) .- 1)nspec .+ 18 #  # SO4 index
const H4SiO4ID = ((1:Ngrid) .- 1)nspec .+ 19 #  # H4SiO4 index
const NdnrID = ((1:Ngrid) .- 1)nspec .+ 20 #  # Ndnr index
const NdrID = ((1:Ngrid) .- 1)nspec .+ 21 #  # Ndr index
const MnID = ((1:Ngrid) .- 1)nspec .+ 22 #  # Mn index
const FeID = ((1:Ngrid) .- 1)nspec .+ 23 #  # Fe index
const NH4ID = ((1:Ngrid) .- 1)nspec .+ 24 #  # NH4 index
const HID = ((1:Ngrid) .- 1)nspec .+ 25 #  # H index
const TCO2ID = ((1:Ngrid) .- 1)nspec .+ 26 #  # TCO2 index
const TH2SID = ((1:Ngrid) .- 1)nspec .+ 27 #  # TH2S index
const TH3BO3ID = ((1:Ngrid) .- 1)nspec .+ 28 #  # TH3BO3 index
const TH3PO4ID = ((1:Ngrid) .- 1)nspec .+ 29 #  # TH3PO4 index
const IDdict = Dict(
    "POC" => POCID,
    "MnO2" => MnO2ID,
    "FeOOH" => FeOOHID,
    "FeS" => FeSID,
    "FeS2" => FeS2ID,
    "CaCO3" => CaCO3ID,
    "MnCO3" => MnCO3ID,
    "FeCO3" => FeCO3ID,
    "Age" => AgeID,
    "BSi" => BSiID,
    "Basalt" => BasaltID,
    "O2" => O2ID,
    "NO3" => NO3ID,
    "CH4" => CH4ID,
    "NO2" => NO2ID,
    "Ca" => CaID,
    "Al" => AlID,
    "SO4" => SO4ID,
    "H4SiO4" => H4SiO4ID,
    "Ndnr" => NdnrID,
    "Ndr" => NdrID,
    "Mn" => MnID,
    "Fe" => FeID,
    "NH4" => NH4ID,
    "H" => HID,
    "TCO2" => TCO2ID,
    "TH2S" => TH2SID,
    "TH3BO3" => TH3BO3ID,
    "TH3PO4" => TH3PO4ID,
)
nothing
