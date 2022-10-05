
#----------------------------------------------
# Number of substances
#----------------------------------------------
const nsolid = 14 #  # number of solid substances
const ndissolved = 14 #  # number of dissolved substances
const nsummed = 4 #  # number of summed substances
const nspec = 32 #  # number of total substances

#----------------------------------------------
# global parameters
#----------------------------------------------
const depth = 3000.0 # m # water depth
const salinity = 35.0 # psu # bottom water salinity
const temp = 2.0 # Celsius # bottom water temperature
const ds_rho = 2.6 # g cm^-3 # dry sediment density
const Fsed = 0.01014 # g cm^-2 yr^-1 # total sediment flux
const sw_dens = 1.0290834608199197 # g cm^-3 # seawater density

#----------------------------------------------
# grid parameters
#----------------------------------------------
const L = 50.0 # cm # model sediment section thickness
const Ngrid = 200 # integer # number of model grid
const pgrid = L / 10 # cm # constant in gridtran, attenuation scale
const Nmat = 5600 #  # Jacobian dimention
const ξ = range(0, step = L / (Ngrid), length = Ngrid + 1) # cm # uniform grid
const xᵥ = broadcast(x -> L * (exp(x * pgrid / L) - 1) / (exp(pgrid) - 1), ξ) # cm # no grid transformation
const x = (xᵥ[2:(Ngrid+1)] .+ xᵥ[1:Ngrid]) / 2 # cm # cell center
const dx = xᵥ[2:(Ngrid+1)] .- xᵥ[1:Ngrid] # cm # cell volume

#----------------------------------------------
# porosity parameters
#----------------------------------------------
const phi0 = 0.8 # dimentionless # surface porosity
const phiL = 0.7 # dimentionless # bottom porosity
const xphi = 5.0 # cm # porosity attenuation scale
const phi_Inf = 0.7 # dimentionless # porosity at infinite sediment depth (normally where porosity stops changing). Needed to calculate burial velocities. If constant_porosity_profile = yes, then phi_Inf should be the same as the porosity constant. If constant_porosity_profile = no, then phi_Inf should be consistent with the depth dependent porosity function
const phif = broadcast(x -> phiL + (phi0 - phiL) * exp(-x / xphi), x) # dimentionless # fluid volume fraction
const phis = 1.0 .- phif # dimentionless # solid volume fraction
const pwtods = phif ./ phis # dimentionless # conversion from pore water to solid sediment volume unit
const dstopw = phis ./ phif # dimentionless # conversion from solid sediment to pore water volume unit

#----------------------------------------------
# burial parameters
#----------------------------------------------
const w_Inf = Fsed / ds_rho / (1 - phi_Inf) # cm yr^-1 # solid sediment burial velocity at infinite depth
const uf = phi_Inf * w_Inf ./ phif # cm yr^-1 # pore water burial velocity
const us = Fsed / ds_rho ./ phis # cm yr^-1 # solid sediment burial velocity

#----------------------------------------------
# bioturbation parameters
#----------------------------------------------
const Dbt0 = 1.93554531569282 # cm2/yr # bioturbation coefficient
const xbt = 6.0 # cm # attentuation scale of bioturbation
const Ds = broadcast(x -> Dbt0 * erfc((x - xbt) / 1) / 2, x) # cm^2 yr^-1 # Bioturbation coefficient

#----------------------------------------------
# bioirrigation parameters
#----------------------------------------------
const Dbir0 = 28.42212793142007 # yr^-1 # bioirrigation constant
const xbir = 2.0 # cm # attentuation scale of bioirrigation
const alpha = broadcast(x -> Dbir0 * exp(-x / xbir), x) # cm^2 yr^-1 # Bioirrigation coefficient

#----------------------------------------------
# adsorption parameters
#----------------------------------------------
const KNH4_ads = 1.6 * ds_rho # cm^3(porewater) cm^-3(dry sediment) # Adsorption constant
const KMn_ads_Mn = 10000.0 # (mmol cm-3 pw)^-1  # missing
const KMn_ads_Fe = 100.0 # (mmol cm-3 pw)^-1  # missing
const KFe_ads_Mn = 10000.0 # (mmol cm-3 pw)^-1  # missing
const KFe_ads_Fe = 10000.0 # (mmol cm-3 pw)^-1  # missing
const KNd_ads_Mn = 0.0 # (mmol cm-3 pw)^-1  # missing
const KNd_ads_Fe = 0.0 # (mmol cm-3 pw)^-1  # missing
const DNdMn = 0.025 # dimensionless # missing
const DNdFe = 0.005 # dimensionless # missing

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
const DTH4SiO4 = 1.6311076543398931E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DTH3PO4 = 1.1039756102174947E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DCO2 = 3.1525898772554984E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DHCO3 = 1.7136976129828849E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DCO3 = 1.4442713572518861E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DH2S = 2.7982945790805405E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DHS = 3.3436959129609028E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DH3BO3 = 1.8018160505803172E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DH4BO4 = 1.5765890442577776E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DH = 1.7567691572664121E+03 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DOH = 8.5800959988348086E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DMn = 1.0660970890036131E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DFe = 1.1027537224364021E+02 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DNdnr = 9.8117588821765196E+01 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient
const DNdr = 9.8117588821765196E+01 ./ (1.0 .- 2log.(phif)) # cm^2 yr^-1 # Sediment diffusion coefficient

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
const betaTH4SiO4 = 3.2622153086797862E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaTH3PO4 = 2.2079512204349894E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaCO2 = 6.3051797545109966E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaHCO3 = 3.4273952259657699E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaCO3 = 2.8885427145037720E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaH2S = 5.5965891581610804E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaHS = 6.6873918259218053E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaH3BO3 = 3.6036321011606342E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaH4BO4 = 3.1531780885155549E+03 # cm yr^-1 # solute mass transfer velocity across SWI
const betaH = 3.5135383145328240E+04 # cm yr^-1 # solute mass transfer velocity across SWI
const betaOH = 1.7160191997669615E+04 # cm yr^-1 # solute mass transfer velocity across SWI

#----------------------------------------------
# boundary fluxes and concentrations
#----------------------------------------------
const FPOC0 = 3.2 / 100 * Fsed / 12 * 1000 # mmol cm^-2 yr^-1 # Flux of POC at the  TOP of sediment column
const FMnO20 = 0.3 / 100 * Fsed / 86.94 * 1000 # mmol cm^-2 yr^-1 # Flux of MnO2 at the  TOP of sediment column
const FFeOOH0 = 0.1 / 100 * Fsed / 88.85 * 1000 # mmol cm^-2 yr^-1 # Flux of FeOOH at the  TOP of sediment column
const FFeS0 = 0.0 # mmol cm^-2 yr^-1 # Flux of FeS at the  TOP of sediment column
const FFeS20 = 0.0 # mmol cm^-2 yr^-1 # Flux of FeS2 at the  TOP of sediment column
const FCaCO30 = 10 / 100 * Fsed / 100 * 1000 # mmol cm^-2 yr^-1 # Flux of CaCO3 at the  TOP of sediment column
const FMnCO30 = 0.0 # mmol cm^-2 yr^-1 # Flux of MnCO3 at the  TOP of sediment column
const FFeCO30 = 0.0 # mmol cm^-2 yr^-1 # Flux of FeCO3 at the  TOP of sediment column
const FBSi0 = 9 / 100 * Fsed / 28.09 * 1000 # mmol cm^-2 yr^-1 # Flux of BSi at the  TOP of sediment column
const Age0 = 0.0 # year # missing
const CaBW = 0.01033 # mmol cm^-3 # Bottom water concentration of Ca
const SO4BW = 0.028 # mmol cm^-3 # Bottom water concentration of SO4
const TH3BO3BW = 8.7062e-5 # mmol cm^-3 # Bottom water concentration of TH3BO3
const Mn0 = 5.0e-10 # mmol cm^-3 # Concentration of Mn at the TOP of sediment column
const Fe0 = 5.0e-10 # mmol cm^-3 # Concentration of Fe at the TOP of sediment column
const AlBW = 5.0e-10 # mmol cm^-3 # Bottom water concentration of Al
const CH4BW = 0.0 # mmol cm^-3 # Bottom water concentration of CH4
const O2BW = 8.0e-5 # mmol cm^-3 # Bottom water concentration of O2
const NO3BW = 4.0e-5 # mmol cm^-3 # Bottom water concentration of NO3
const NO2BW = 5.0e-8 # mmol cm^-3 # Bottom water concentration of NO2
const NH40 = 0.0 # mmol cm^-3 # Concentration of NH4 at the TOP of sediment column
const TH3PO4BW = 2.8e-6 # mmol cm^-3 # Bottom water concentration of H3PO4
const TH4SiO4BW = 0.00019 # mmol cm^-3 # Bottom water concentration of H4SiO4
const pHBW = 7.7 # free pH scale # Bottom water pH
const TCO2BW = 0.00238 # mmol cm^-3 # Bottom water concentration of TCO2
const TH2SBW = 0.0 # mmol cm^-3 # Bottom water concentration of TH2S
const FMn_ads_Mn0 = KMn_ads_Mn * FMnO20 * Mn0 # mmol cm^-2 yr^-1 # missing
const FMn_ads_Fe0 = KMn_ads_Fe * FFeOOH0 * Mn0 # mmol cm^-2 yr^-1 # missing
const FFe_ads_Mn0 = KFe_ads_Mn * FMnO20 * Fe0 # mmol cm^-2 yr^-1 # missing
const FFe_ads_Fe0 = KFe_ads_Fe * FFeOOH0 * Fe0 # mmol cm^-2 yr^-1 # missing
const eNd_MnO2 = -2.4 # missing # missing
const eNd_FeOOH = -2.4 # missing # missing
const Nd0 = 3.5e-11 # mmol cm^-3 # Bottom water concentration of Nd
const eNd0 = -2.4 # epsilon # Bottom water eNd
const Ndnr0 = 2.3140266884232977e-11 # mmol cm^-3 # Bottom water concentration of Nd144
const Ndr0 = 1.1859733115767025e-11 # mmol cm^-3 # Bottom water concentration of Nd143
const eNdPO4 = -2.4 # epsilon # missing
const FNdnrPO40 = 1.0e-15 # mmol cm^-2 yr^-1 # missing
const FNdrPO40 = 5.125149668800001e-16 # mmol cm^-2 yr^-1 # missing
const FNdnr_ads_Mn0 = KNd_ads_Mn * FMnO20 * Ndnr0 # mmol cm^-2 yr^-1 # missing
const FNdr_ads_Mn0 = KNd_ads_Mn * FMnO20 * Ndr0 # mmol cm^-2 yr^-1 # missing
const FNdnr_ads_Fe0 = KNd_ads_Fe * FFeOOH0 * Ndnr0 # mmol cm^-2 yr^-1 # missing
const FNdr_ads_Fe0 = KNd_ads_Fe * FFeOOH0 * Ndr0 # mmol cm^-2 yr^-1 # missing
const FSurfMn_Ndnr0 = FMnO20 * Ndnr0 / Mn0 * DNdMn # mmol cm^-2 yr^-1 # missing
const FSurfMn_Ndr0 = FMnO20 * Ndr0 / Mn0 * DNdMn # mmol cm^-2 yr^-1 # missing
const FSurfFe_Ndnr0 = FFeOOH0 * Ndnr0 / Fe0 * DNdFe # mmol cm^-2 yr^-1 # missing
const FSurfFe_Ndr0 = FFeOOH0 * Ndr0 / Fe0 * DNdFe # mmol cm^-2 yr^-1 # missing
const H4SiO4BW = 1.8821161451549316E-04 # mmol cm^-3 # Bottom water concentration of H4SiO4
const H3SiO4BW = 1.7883854845068649E-06 # mmol cm^-3 # Bottom water concentration of H3SiO4
const H3PO4BW = 5.2618094499704650E-14 # mmol cm^-3 # Bottom water concentration of H3PO4
const H2PO4BW = 6.8320353691652683E-08 # mmol cm^-3 # Bottom water concentration of H2PO4
const HPO4BW = 2.6579696478238119E-06 # mmol cm^-3 # Bottom water concentration of HPO4
const PO4BW = 7.3709945866440856E-08 # mmol cm^-3 # Bottom water concentration of PO4
const HCO3BW = 2.2792389384405274E-03 # mmol cm^-3 # Bottom water concentration of HCO3
const CO3BW = 5.4445170729534315E-05 # mmol cm^-3 # Bottom water concentration of CO3
const CO2BW = 4.6315890829938739E-05 # mmol cm^-3 # Bottom water concentration of CO2
const H2SBW = 0.0000000000000000E+00 # mmol cm^-3 # Bottom water concentration of H2S
const HSBW = 0.0000000000000000E+00 # mmol cm^-3 # Bottom water concentration of HS
const H3BO3BW = 8.0401874786495146E-05 # mmol cm^-3 # Bottom water concentration of H3BO3
const H4BO4BW = 6.6601252135048620E-06 # mmol cm^-3 # Bottom water concentration of H4BO4
const HBW = 1.9952623149688786E-08 # mmol cm^-3 # Bottom water concentration of H
const OHBW = 3.7078098494959293E-07 # mmol cm^-3 # Bottom water concentration of OH

#----------------------------------------------
# assemble boundary conditions
#----------------------------------------------
const BcMnO2 = ((phis[1]us[1], -phis[1]Ds[1], FMnO20), (0.0, 1.0, 0.0)) #  # Boundary condition of MnO2
const BcFeOOH = ((phis[1]us[1], -phis[1]Ds[1], FFeOOH0), (0.0, 1.0, 0.0)) #  # Boundary condition of FeOOH
const BcPOC = ((phis[1]us[1], -phis[1]Ds[1], FPOC0), (0.0, 1.0, 0.0)) #  # Boundary condition of POC
const BcFeS = ((phis[1]us[1], -phis[1]Ds[1], FFeS0), (0.0, 1.0, 0.0)) #  # Boundary condition of FeS
const BcFeS2 = ((phis[1]us[1], -phis[1]Ds[1], FFeS20), (0.0, 1.0, 0.0)) #  # Boundary condition of FeS2
const BcCaCO3 = ((phis[1]us[1], -phis[1]Ds[1], FCaCO30), (0.0, 1.0, 0.0)) #  # Boundary condition of CaCO3
const BcAge = ((1.0, 0.0, Age0), (0.0, 1.0, 1.0 / us[Ngrid])) #  # Boundary condition of Age
const BcBSi = ((phis[1]us[1], -phis[1]Ds[1], FBSi0), (0.0, 1.0, 0.0)) #  # Boundary condition of BSi
const BcNdnrPO4 = ((phis[1]us[1], -phis[1]Ds[1], FNdnrPO40), (0.0, 1.0, 0.0)) #  # Boundary condition of NdnrPO4
const BcNdrPO4 = ((phis[1]us[1], -phis[1]Ds[1], FNdrPO40), (0.0, 1.0, 0.0)) #  # Boundary condition of NdrPO4
const BcSurfMn_Ndnr =
    ((phis[1]us[1], -phis[1]Ds[1], FSurfMn_Ndnr0), (0.0, 1.0, 0.0)) #  # Boundary condition of SurfMn_Ndnr
const BcSurfMn_Ndr =
    ((phis[1]us[1], -phis[1]Ds[1], FSurfMn_Ndr0), (0.0, 1.0, 0.0)) #  # Boundary condition of SurfMn_Ndr
const BcSurfFe_Ndnr =
    ((phis[1]us[1], -phis[1]Ds[1], FSurfFe_Ndnr0), (0.0, 1.0, 0.0)) #  # Boundary condition of SurfFe_Ndnr
const BcSurfFe_Ndr =
    ((phis[1]us[1], -phis[1]Ds[1], FSurfFe_Ndr0), (0.0, 1.0, 0.0)) #  # Boundary condition of SurfFe_Ndr
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
const BcTH4SiO4 = (
    (betaTH4SiO4 + phif[1]uf[1], -phif[1]DTH4SiO4[1], betaTH4SiO4 * TH4SiO4BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of TH4SiO4
const BcTH3PO4 = (
    (betaTH3PO4 + phif[1]uf[1], -phif[1]DTH3PO4[1], betaTH3PO4 * TH3PO4BW),
    (0.0, 1.0, 0.0),
) #  # Boundary condition of TH3PO4
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
const BcH =
    ((betaH + phif[1]uf[1], -phif[1]DH[1], betaH * HBW), (0.0, 1.0, 0.0)) #  # Boundary condition of H
const BcOH =
    ((betaOH + phif[1]uf[1], -phif[1]DOH[1], betaOH * OHBW), (0.0, 1.0, 0.0)) #  # Boundary condition of H
const BcMn = ((1.0, 0.0, Mn0), (0.0, 1.0, 0.0)) #  # Boundary condition of TMn
const BcFe = ((1.0, 0.0, Fe0), (0.0, 1.0, 0.0)) #  # Boundary condition of TFe
const BcNdnr = ((1.0, 0.0, Ndnr0), (0.0, 1.0, 0.0)) #  # Boundary condition of TNdnr
const BcNdr = ((1.0, 0.0, Ndr0), (0.0, 1.0, 0.0)) #  # Boundary condition of TNdr
const BcMn_ads_Mn =
    ((phis[1]us[1], -phis[1]Ds[1], FMn_ads_Mn0), (0.0, 1.0, 0.0)) #  # Boundary condition of TMn
const BcMn_ads_Fe =
    ((phis[1]us[1], -phis[1]Ds[1], FMn_ads_Fe0), (0.0, 1.0, 0.0)) #  # Boundary condition of TMn
const BcFe_ads_Mn =
    ((phis[1]us[1], -phis[1]Ds[1], FFe_ads_Mn0), (0.0, 1.0, 0.0)) #  # Boundary condition of TFe
const BcFe_ads_Fe =
    ((phis[1]us[1], -phis[1]Ds[1], FFe_ads_Fe0), (0.0, 1.0, 0.0)) #  # Boundary condition of TFe
const BcNH4_ads = ((phis[1]us[1], -phis[1]Ds[1], FNH4_ads0), (0.0, 1.0, 0.0)) #  # Boundary condition of TNH4
const BcNdnr_ads_Mn =
    ((phis[1]us[1], -phis[1]Ds[1], FNdnr_ads_Mn0), (0.0, 1.0, 0.0)) #  # Boundary condition of TNdnr
const BcNdnr_ads_Fe =
    ((phis[1]us[1], -phis[1]Ds[1], FNdnr_ads_Fe0), (0.0, 1.0, 0.0)) #  # Boundary condition of TNdnr
const BcNdr_ads_Mn =
    ((phis[1]us[1], -phis[1]Ds[1], FNdr_ads_Mn0), (0.0, 1.0, 0.0)) #  # Boundary condition of TNdr
const BcNdr_ads_Fe =
    ((phis[1]us[1], -phis[1]Ds[1], FNdr_ads_Fe0), (0.0, 1.0, 0.0)) #  # Boundary condition of TNdr

#----------------------------------------------
# Boundary transport matrix
#----------------------------------------------
const BcAmMnO2, BcBmMnO2, BcCmMnO2 = fvcf_bc(phis, Ds, us, dx, BcMnO2, Ngrid) #  # Boundary transport matrix of MnO2
const BcAmFeOOH, BcBmFeOOH, BcCmFeOOH =
    fvcf_bc(phis, Ds, us, dx, BcFeOOH, Ngrid) #  # Boundary transport matrix of FeOOH
const BcAmPOC, BcBmPOC, BcCmPOC = fvcf_bc(phis, Ds, us, dx, BcPOC, Ngrid) #  # Boundary transport matrix of POC
const BcAmFeS, BcBmFeS, BcCmFeS = fvcf_bc(phis, Ds, us, dx, BcFeS, Ngrid) #  # Boundary transport matrix of FeS
const BcAmFeS2, BcBmFeS2, BcCmFeS2 = fvcf_bc(phis, Ds, us, dx, BcFeS2, Ngrid) #  # Boundary transport matrix of FeS2
const BcAmCaCO3, BcBmCaCO3, BcCmCaCO3 =
    fvcf_bc(phis, Ds, us, dx, BcCaCO3, Ngrid) #  # Boundary transport matrix of CaCO3
const BcAmAge, BcBmAge, BcCmAge = fvcf_bc(phis, Ds, us, dx, BcAge, Ngrid) #  # Boundary transport matrix of Age
const BcAmBSi, BcBmBSi, BcCmBSi = fvcf_bc(phis, Ds, us, dx, BcBSi, Ngrid) #  # Boundary transport matrix of BSi
const BcAmNdnrPO4, BcBmNdnrPO4, BcCmNdnrPO4 =
    fvcf_bc(phis, Ds, us, dx, BcNdnrPO4, Ngrid) #  # Boundary transport matrix of NdnrPO4
const BcAmNdrPO4, BcBmNdrPO4, BcCmNdrPO4 =
    fvcf_bc(phis, Ds, us, dx, BcNdrPO4, Ngrid) #  # Boundary transport matrix of NdrPO4
const BcAmSurfMn_Ndnr, BcBmSurfMn_Ndnr, BcCmSurfMn_Ndnr =
    fvcf_bc(phis, Ds, us, dx, BcSurfMn_Ndnr, Ngrid) #  # Boundary transport matrix of SurfMn_Ndnr
const BcAmSurfMn_Ndr, BcBmSurfMn_Ndr, BcCmSurfMn_Ndr =
    fvcf_bc(phis, Ds, us, dx, BcSurfMn_Ndr, Ngrid) #  # Boundary transport matrix of SurfMn_Ndr
const BcAmSurfFe_Ndnr, BcBmSurfFe_Ndnr, BcCmSurfFe_Ndnr =
    fvcf_bc(phis, Ds, us, dx, BcSurfFe_Ndnr, Ngrid) #  # Boundary transport matrix of SurfFe_Ndnr
const BcAmSurfFe_Ndr, BcBmSurfFe_Ndr, BcCmSurfFe_Ndr =
    fvcf_bc(phis, Ds, us, dx, BcSurfFe_Ndr, Ngrid) #  # Boundary transport matrix of SurfFe_Ndr
const BcAmO2, BcBmO2, BcCmO2 = fvcf_bc(phif, DO2, uf, dx, BcO2, Ngrid) #  # Boundary transport matrix of O2
const BcAmNO3, BcBmNO3, BcCmNO3 = fvcf_bc(phif, DNO3, uf, dx, BcNO3, Ngrid) #  # Boundary transport matrix of NO3
const BcAmCH4, BcBmCH4, BcCmCH4 = fvcf_bc(phif, DCH4, uf, dx, BcCH4, Ngrid) #  # Boundary transport matrix of CH4
const BcAmNO2, BcBmNO2, BcCmNO2 = fvcf_bc(phif, DNO2, uf, dx, BcNO2, Ngrid) #  # Boundary transport matrix of NO2
const BcAmCa, BcBmCa, BcCmCa = fvcf_bc(phif, DCa, uf, dx, BcCa, Ngrid) #  # Boundary transport matrix of Ca
const BcAmAl, BcBmAl, BcCmAl = fvcf_bc(phif, DAl, uf, dx, BcAl, Ngrid) #  # Boundary transport matrix of Al
const BcAmSO4, BcBmSO4, BcCmSO4 = fvcf_bc(phif, DSO4, uf, dx, BcSO4, Ngrid) #  # Boundary transport matrix of SO4
const BcAmTH4SiO4, BcBmTH4SiO4, BcCmTH4SiO4 =
    fvcf_bc(phif, DTH4SiO4, uf, dx, BcTH4SiO4, Ngrid) #  # Boundary transport matrix of TH4SiO4
const BcAmTH3PO4, BcBmTH3PO4, BcCmTH3PO4 =
    fvcf_bc(phif, DTH3PO4, uf, dx, BcTH3PO4, Ngrid) #  # Boundary transport matrix of TH3PO4
const BcAmCO2, BcBmCO2, BcCmCO2 = fvcf_bc(phif, DCO2, uf, dx, BcCO2, Ngrid) #  # Boundary transport matrix of CO2
const BcAmHCO3, BcBmHCO3, BcCmHCO3 = fvcf_bc(phif, DHCO3, uf, dx, BcHCO3, Ngrid) #  # Boundary transport matrix of HCO3
const BcAmCO3, BcBmCO3, BcCmCO3 = fvcf_bc(phif, DCO3, uf, dx, BcCO3, Ngrid) #  # Boundary transport matrix of CO3
const BcAmH2S, BcBmH2S, BcCmH2S = fvcf_bc(phif, DH2S, uf, dx, BcH2S, Ngrid) #  # Boundary transport matrix of H2S
const BcAmHS, BcBmHS, BcCmHS = fvcf_bc(phif, DHS, uf, dx, BcHS, Ngrid) #  # Boundary transport matrix of HS
const BcAmH3BO3, BcBmH3BO3, BcCmH3BO3 =
    fvcf_bc(phif, DH3BO3, uf, dx, BcH3BO3, Ngrid) #  # Boundary transport matrix of H3BO3
const BcAmH4BO4, BcBmH4BO4, BcCmH4BO4 =
    fvcf_bc(phif, DH4BO4, uf, dx, BcH4BO4, Ngrid) #  # Boundary transport matrix of H4BO4
const BcAmH, BcBmH, BcCmH = fvcf_bc(phif, DH, uf, dx, BcH, Ngrid) #  # Boundary transport matrix of H
const BcAmOH, BcBmOH, BcCmOH = fvcf_bc(phif, DOH, uf, dx, BcOH, Ngrid) #  # Boundary transport matrix of OH
const BcAmMn, BcBmMn, BcCmMn = fvcf_bc(phif, DMn, uf, dx, BcMn, Ngrid) #  # Boundary transport matrix of Mn
const BcAmFe, BcBmFe, BcCmFe = fvcf_bc(phif, DFe, uf, dx, BcFe, Ngrid) #  # Boundary transport matrix of Fe
const BcAmNdnr, BcBmNdnr, BcCmNdnr = fvcf_bc(phif, DNdnr, uf, dx, BcNdnr, Ngrid) #  # Boundary transport matrix of Ndnr
const BcAmNdr, BcBmNdr, BcCmNdr = fvcf_bc(phif, DNdr, uf, dx, BcNdr, Ngrid) #  # Boundary transport matrix of Ndr
const BcAmMn_ads_Mn, BcBmMn_ads_Mn, BcCmMn_ads_Mn =
    fvcf_bc(phis, Ds, us, dx, BcMn_ads_Mn, Ngrid) #  # Boundary transport matrix of Mn_ads_Mn
const BcAmMn_ads_Fe, BcBmMn_ads_Fe, BcCmMn_ads_Fe =
    fvcf_bc(phis, Ds, us, dx, BcMn_ads_Fe, Ngrid) #  # Boundary transport matrix of Mn_ads_Fe
const BcAmFe_ads_Mn, BcBmFe_ads_Mn, BcCmFe_ads_Mn =
    fvcf_bc(phis, Ds, us, dx, BcFe_ads_Mn, Ngrid) #  # Boundary transport matrix of Fe_ads_Mn
const BcAmFe_ads_Fe, BcBmFe_ads_Fe, BcCmFe_ads_Fe =
    fvcf_bc(phis, Ds, us, dx, BcFe_ads_Fe, Ngrid) #  # Boundary transport matrix of Fe_ads_Fe
const BcAmNH4_ads, BcBmNH4_ads, BcCmNH4_ads =
    fvcf_bc(phis, Ds, us, dx, BcNH4_ads, Ngrid) #  # Boundary transport matrix of NH4_ads
const BcAmNdnr_ads_Mn, BcBmNdnr_ads_Mn, BcCmNdnr_ads_Mn =
    fvcf_bc(phis, Ds, us, dx, BcNdnr_ads_Mn, Ngrid) #  # Boundary transport matrix of Ndnr_ads_Mn
const BcAmNdnr_ads_Fe, BcBmNdnr_ads_Fe, BcCmNdnr_ads_Fe =
    fvcf_bc(phis, Ds, us, dx, BcNdnr_ads_Fe, Ngrid) #  # Boundary transport matrix of Ndnr_ads_Fe
const BcAmNdr_ads_Mn, BcBmNdr_ads_Mn, BcCmNdr_ads_Mn =
    fvcf_bc(phis, Ds, us, dx, BcNdr_ads_Mn, Ngrid) #  # Boundary transport matrix of Ndr_ads_Mn
const BcAmNdr_ads_Fe, BcBmNdr_ads_Fe, BcCmNdr_ads_Fe =
    fvcf_bc(phis, Ds, us, dx, BcNdr_ads_Fe, Ngrid) #  # Boundary transport matrix of Ndr_ads_Fe

#----------------------------------------------
# Interior transport matrix
#----------------------------------------------
const AmMnO2, BmMnO2 = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of MnO2
const AmFeOOH, BmFeOOH = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of FeOOH
const AmPOC, BmPOC = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of POC
const AmFeS, BmFeS = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of FeS
const AmFeS2, BmFeS2 = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of FeS2
const AmCaCO3, BmCaCO3 = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of CaCO3
const AmAge, BmAge = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Age
const AmBSi, BmBSi = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of BSi
const AmNdnrPO4, BmNdnrPO4 = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of NdnrPO4
const AmNdrPO4, BmNdrPO4 = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of NdrPO4
const AmSurfMn_Ndnr, BmSurfMn_Ndnr = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of SurfMn_Ndnr
const AmSurfMn_Ndr, BmSurfMn_Ndr = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of SurfMn_Ndr
const AmSurfFe_Ndnr, BmSurfFe_Ndnr = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of SurfFe_Ndnr
const AmSurfFe_Ndr, BmSurfFe_Ndr = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of SurfFe_Ndr
const AmO2, BmO2 = fvcf(phif, DO2, uf, dx, Ngrid) #  # Interior transport matrix of O2
const AmNO3, BmNO3 = fvcf(phif, DNO3, uf, dx, Ngrid) #  # Interior transport matrix of NO3
const AmCH4, BmCH4 = fvcf(phif, DCH4, uf, dx, Ngrid) #  # Interior transport matrix of CH4
const AmNO2, BmNO2 = fvcf(phif, DNO2, uf, dx, Ngrid) #  # Interior transport matrix of NO2
const AmCa, BmCa = fvcf(phif, DCa, uf, dx, Ngrid) #  # Interior transport matrix of Ca
const AmAl, BmAl = fvcf(phif, DAl, uf, dx, Ngrid) #  # Interior transport matrix of Al
const AmSO4, BmSO4 = fvcf(phif, DSO4, uf, dx, Ngrid) #  # Interior transport matrix of SO4
const AmTH4SiO4, BmTH4SiO4 = fvcf(phif, DTH4SiO4, uf, dx, Ngrid) #  # Interior transport matrix of TH4SiO4
const AmTH3PO4, BmTH3PO4 = fvcf(phif, DTH3PO4, uf, dx, Ngrid) #  # Interior transport matrix of TH3PO4
const AmCO2, BmCO2 = fvcf(phif, DCO2, uf, dx, Ngrid) #  # Interior transport matrix of CO2
const AmHCO3, BmHCO3 = fvcf(phif, DHCO3, uf, dx, Ngrid) #  # Interior transport matrix of HCO3
const AmCO3, BmCO3 = fvcf(phif, DCO3, uf, dx, Ngrid) #  # Interior transport matrix of CO3
const AmH2S, BmH2S = fvcf(phif, DH2S, uf, dx, Ngrid) #  # Interior transport matrix of H2S
const AmHS, BmHS = fvcf(phif, DHS, uf, dx, Ngrid) #  # Interior transport matrix of HS
const AmH3BO3, BmH3BO3 = fvcf(phif, DH3BO3, uf, dx, Ngrid) #  # Interior transport matrix of H3BO3
const AmH4BO4, BmH4BO4 = fvcf(phif, DH4BO4, uf, dx, Ngrid) #  # Interior transport matrix of H4BO4
const AmH, BmH = fvcf(phif, DH, uf, dx, Ngrid) #  # Interior transport matrix of H
const AmOH, BmOH = fvcf(phif, DOH, uf, dx, Ngrid) #  # Interior transport matrix of OH
const AmMn, BmMn = fvcf(phif, DMn, uf, dx, Ngrid) #  # Interior transport matrix of Mn
const AmFe, BmFe = fvcf(phif, DFe, uf, dx, Ngrid) #  # Interior transport matrix of Fe
const AmNdnr, BmNdnr = fvcf(phif, DNdnr, uf, dx, Ngrid) #  # Interior transport matrix of Ndnr
const AmNdr, BmNdr = fvcf(phif, DNdr, uf, dx, Ngrid) #  # Interior transport matrix of Ndr
const AmMn_ads_Mn, BmMn_ads_Mn = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Mn_ads_Mn
const AmMn_ads_Fe, BmMn_ads_Fe = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Mn_ads_Fe
const AmFe_ads_Mn, BmFe_ads_Mn = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Fe_ads_Mn
const AmFe_ads_Fe, BmFe_ads_Fe = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Fe_ads_Fe
const AmNH4_ads, BmNH4_ads = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of NH4_ads
const AmNdnr_ads_Mn, BmNdnr_ads_Mn = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Ndnr_ads_Mn
const AmNdnr_ads_Fe, BmNdnr_ads_Fe = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Ndnr_ads_Fe
const AmNdr_ads_Mn, BmNdr_ads_Mn = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Ndr_ads_Mn
const AmNdr_ads_Fe, BmNdr_ads_Fe = fvcf(phis, Ds, us, dx, Ngrid) #  # Interior transport matrix of Ndr_ads_Fe

#----------------------------------------------
# Acid dissociation constants
#----------------------------------------------
const KH4SiO4 = 1.8958968983182346E-10 #  # TH4SiO4 1th dissociation constant
const KH3PO4 = 2.5906872600083355E-02 #  # TH3PO4 1th dissociation constant
const KH2PO4 = 7.7624695805430387E-07 #  # TH3PO4 2th dissociation constant
const KHPO4 = 5.5331962630242337E-10 #  # TH3PO4 3th dissociation constant
const KCO2 = 9.8188321096491150E-07 #  # TCO2 1th dissociation constant
const KHCO3 = 4.7661697752063504E-10 #  # TCO2 2th dissociation constant
const KH2S = 7.7624695805430387E-07 #  # TH2S 1th dissociation constant
const KH3BO3 = 1.6527844514531606E-09 #  # TH3BO3 1th dissociation constant
const KH2O = 7.3980532637696576E-15 #  # H 1th dissociation constant

#----------------------------------------------
# Reaction parameters
#----------------------------------------------
const Cl = 0.565772678 # mmol cm-3 # bottom water Cl concentration
const nu = 0.125 # dimentionless # POC reactivity
const a = 60.0 # yr # initial POC age
const rNC = 16 / 170 # mol mol^-1 # N/C ratio Sediment trap 
const rPC = 1 / 170 # mol mol^-2 # P/C ratio Sediment trap
const KO2 = 1.0e-6 # mmol cm-3 pw # Monod constant
const KNO2 = 1.0e-5 # mmol cm-3 pw # Monod constant
const KNO3 = 1.0e-5 # mmol cm-3 pw # Monod constant
const KMnO2 = 0.1 / (86.93685 / ds_rho / 10) # mmol cm-3 ds # Monod constant
const KFeOOH = 30 / (88.85174 / ds_rho / 10) # mmol cm-3 ds # Monod constant
const KSO4 = 2.6e-6 # mmol cm-3 pw # Monod constant
const kO2NO2 = 1.0e7 # (mmol cm-3 pw)-1 yr-1 #  
const kO2NH4 = 1.0e7 # (mmol cm-3 pw)-1 yr-1 #  
const kO2Mn = 0.0 # (mmol cm-3 pw)-1 yr-1  #  
const kO2Mn_ads = 1.0e6 # (mmol cm-3 pw)-1 yr-1  #  
const kO2Fe = 1.0e7 # (mmol cm-3 pw)-1 yr-1 #  
const kO2Fe_ads = 1.0e6 # (mmol cm-3 pw)-1 yr-1  #  
const kO2H2S = 100000.0 # (mmol cm-3 pw)-1 yr-1  #  
const kO2FeS = 100000.0 # (mmol cm-3 pw)-1 yr-1  #  
const kO2CH4 = 1.0e10 # (mmol cm-3 pw)-1 yr-1  #  
const kNO2NH4 = 1.0e8 # (mmol cm-3 pw)-1 yr-1  #  
const kNO3Mn = 0.0 # (mmol cm-3 pw)-1 yr-1  #  
const kNO3Fe = 0.0 # (mmol cm-3 pw)-1 yr-1  #  
const kNO3H2S = 0.0 # (mmol cm-3 pw)-1 yr-1 #  
const kAOM = 0.04 # yr-1  #  
const KAOM = 0.001 # mmol cm-3 pw #  
const kMnO2Fe = 1.0e6 # (mmol cm-3 pw)-1 yr-1  #  
const kMnO2H2S = 10000.0 # (mmol cm-3 pw)-1 yr-1  #  
const kFeOOHH2S = 10.0 # (mmol cm-3 pw)-0.5 yr-1  #  
const kFeSH2S = 1.0e7 # (mmol cm-3 pw)-1 yr-1  #  
const kFeSdis = 0.001 # yr-1  #  
const KspFeS = 0.0013465481745351092 # mmol cm-3 pw # apparent solubility of FeS  
const kFeSpre = 2000.0 # (mmol cm-3 pw)-1 yr-1  #  
const MCaCO3 = 100.09 # g/mol # Calcite molecular weight
const SACaCO3 = 0.35 # m2/g # Calcite specific surface area
const kCaCO3dis0 = 0.055368829236732454 # yr^-1  # close to equilibrium rate
const kCaCO3dis1 = 175.09161176499725 # yr^-1  # far from equilibrum rate
const nCaCO3dis = 5.0 # missing # far from equilibrium reaction order
const KspCaCO3_dis = 7.863574397229617e-7 # (mmol cm^-3 pw)^2 # missing
const kBSi_dis = broadcast(x -> 0.025, x) # yr-1  # depth dependent dissolution rate
const H4SiO4_dis_sat = 0.00062 # mmol cm-3 pw # solubility of opal
const KspNdPO4 = 1.167542472671615e-18 # (mmol cm^-3)^2 # missing
const kNdPO4_pre = 1.0e-7 # mmol cm^-3  ds yr^-1 # missing
const rAlSi = 0.0025 # missing # missing

#----------------------------------------------
# Inital values
#----------------------------------------------
const C_ini = [
    Mn0,
    Fe0,
    NH40,
    Ndnr0,
    Ndr0,
    FMnO20 / (phis[1] * us[1]),
    FFeOOH0 / (phis[1] * us[1]),
    FPOC0 / (phis[1] * us[1]),
    FFeS0 / (phis[1] * us[1]),
    FFeS20 / (phis[1] * us[1]),
    FCaCO30 / (phis[1] * us[1]),
    Age0,
    FBSi0 / (phis[1] * us[1]),
    FNdnrPO40 / (phis[1] * us[1]),
    FNdrPO40 / (phis[1] * us[1]),
    FSurfMn_Ndnr0 / (phis[1] * us[1]),
    FSurfMn_Ndr0 / (phis[1] * us[1]),
    FSurfFe_Ndnr0 / (phis[1] * us[1]),
    FSurfFe_Ndr0 / (phis[1] * us[1]),
    O2BW,
    NO3BW,
    CH4BW,
    NO2BW,
    CaBW,
    AlBW,
    SO4BW,
    TH4SiO4BW,
    TH3PO4BW,
    TCO2BW,
    TH2SBW,
    TH3BO3BW,
    HBW,
] #  # initial conditions
const C_uni = repeat(C_ini, outer = Ngrid) # initial conditions

#----------------------------------------------
# Indices
#----------------------------------------------
const TMnID = ((1:Ngrid) .- 1)nspec .+ 1 #  # TMn index
const TFeID = ((1:Ngrid) .- 1)nspec .+ 2 #  # TFe index
const TNH4ID = ((1:Ngrid) .- 1)nspec .+ 3 #  # TNH4 index
const TNdnrID = ((1:Ngrid) .- 1)nspec .+ 4 #  # TNdnr index
const TNdrID = ((1:Ngrid) .- 1)nspec .+ 5 #  # TNdr index
const MnO2ID = ((1:Ngrid) .- 1)nspec .+ 6 #  # MnO2 index
const FeOOHID = ((1:Ngrid) .- 1)nspec .+ 7 #  # FeOOH index
const POCID = ((1:Ngrid) .- 1)nspec .+ 8 #  # POC index
const FeSID = ((1:Ngrid) .- 1)nspec .+ 9 #  # FeS index
const FeS2ID = ((1:Ngrid) .- 1)nspec .+ 10 #  # FeS2 index
const CaCO3ID = ((1:Ngrid) .- 1)nspec .+ 11 #  # CaCO3 index
const AgeID = ((1:Ngrid) .- 1)nspec .+ 12 #  # Age index
const BSiID = ((1:Ngrid) .- 1)nspec .+ 13 #  # BSi index
const NdnrPO4ID = ((1:Ngrid) .- 1)nspec .+ 14 #  # NdnrPO4 index
const NdrPO4ID = ((1:Ngrid) .- 1)nspec .+ 15 #  # NdrPO4 index
const SurfMn_NdnrID = ((1:Ngrid) .- 1)nspec .+ 16 #  # SurfMn_Ndnr index
const SurfMn_NdrID = ((1:Ngrid) .- 1)nspec .+ 17 #  # SurfMn_Ndr index
const SurfFe_NdnrID = ((1:Ngrid) .- 1)nspec .+ 18 #  # SurfFe_Ndnr index
const SurfFe_NdrID = ((1:Ngrid) .- 1)nspec .+ 19 #  # SurfFe_Ndr index
const O2ID = ((1:Ngrid) .- 1)nspec .+ 20 #  # O2 index
const NO3ID = ((1:Ngrid) .- 1)nspec .+ 21 #  # NO3 index
const CH4ID = ((1:Ngrid) .- 1)nspec .+ 22 #  # CH4 index
const NO2ID = ((1:Ngrid) .- 1)nspec .+ 23 #  # NO2 index
const CaID = ((1:Ngrid) .- 1)nspec .+ 24 #  # Ca index
const AlID = ((1:Ngrid) .- 1)nspec .+ 25 #  # Al index
const SO4ID = ((1:Ngrid) .- 1)nspec .+ 26 #  # SO4 index
const TH4SiO4ID = ((1:Ngrid) .- 1)nspec .+ 27 #  # TH4SiO4 index
const TH3PO4ID = ((1:Ngrid) .- 1)nspec .+ 28 #  # TH3PO4 index
const TCO2ID = ((1:Ngrid) .- 1)nspec .+ 29 #  # TCO2 index
const TH2SID = ((1:Ngrid) .- 1)nspec .+ 30 #  # TH2S index
const TH3BO3ID = ((1:Ngrid) .- 1)nspec .+ 31 #  # TH3BO3 index
const HID = ((1:Ngrid) .- 1)nspec .+ 32 #  # H index
const IDdict = Dict(
    "TMn" => TMnID,
    "TFe" => TFeID,
    "TNH4" => TNH4ID,
    "TNdnr" => TNdnrID,
    "TNdr" => TNdrID,
    "MnO2" => MnO2ID,
    "FeOOH" => FeOOHID,
    "POC" => POCID,
    "FeS" => FeSID,
    "FeS2" => FeS2ID,
    "CaCO3" => CaCO3ID,
    "Age" => AgeID,
    "BSi" => BSiID,
    "NdnrPO4" => NdnrPO4ID,
    "NdrPO4" => NdrPO4ID,
    "SurfMn_Ndnr" => SurfMn_NdnrID,
    "SurfMn_Ndr" => SurfMn_NdrID,
    "SurfFe_Ndnr" => SurfFe_NdnrID,
    "SurfFe_Ndr" => SurfFe_NdrID,
    "O2" => O2ID,
    "NO3" => NO3ID,
    "CH4" => CH4ID,
    "NO2" => NO2ID,
    "Ca" => CaID,
    "Al" => AlID,
    "SO4" => SO4ID,
    "TH4SiO4" => TH4SiO4ID,
    "TH3PO4" => TH3PO4ID,
    "TCO2" => TCO2ID,
    "TH2S" => TH2SID,
    "TH3BO3" => TH3BO3ID,
    "H" => HID,
)
nothing
