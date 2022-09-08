
function viscosity(salinity::Float64, temp::Float64, pres::Float64)
  # dynamic viscosity unit in 1e-2 g cm-1 s-1
    1.7910 - temp*(6.144e-02 - temp*(1.4510e-03 - temp*1.6826e-05)) -
    1.5290e-04*pres + 8.3885e-08*pres*pres + 2.4727e-03*salinity +
    (6.0574e-06*pres - 2.6760e-09*pres*pres)*temp + (temp*(4.8429e-05-
     temp*(4.7172e-06 - temp*7.5986e-08)))*salinity
end

species_default = [
    "O2",
    "NO3",
    "NO2",
    "Mn",
    "Fe",
    "SO4",
    "HSO4",
    "NH4",
    "NH3",
    "PO4",
    "HPO4",
    "H2PO4",
    "H3PO4",
    "CO2",
    "HCO3",
    "CO3",
    "H2S",
    "HS",
    "CH4",
    "H",
    "Ca",
    "H4SiO4",
    "H3SiO4",
    "HF",
    "F",
    "OH",
    "H3BO3",
    "H4BO4",
    "Al(OH)[4]",
    "MoO4",
    "Nd",
    "Nd144",
    "Nd143",
    "Ndnr",
    "Ndr"
]

# return molecular diffusion in cm2/yr
function molecdiff(salinity::Float64, temp::Float64, pres::Float64, species_all::Vector{String})

    species_not_in_list = [ i for i in species_all if !(i in species_default)]
    species = [ i for i in species_all if (i in species_default)]

    nspec = length(species)
    diffcoef = fill(NaN,nspec)#Array{Float64}(undef, nspec)
    mdif = Dict(species[i] => diffcoef[i] for i = 1:nspec)

    # first calculate diffusivity at in situ temperature but 0 salinity and 1 Patm
    # unit in cm2/s

    TK = 273.15 + temp # in situ temperature in K
    Patm = 1.013253 # atmospheric pressure in 1e5 Pa or 1 bar
    pres = pres + Patm # total pressure
    mu_0 = viscosity(0.0, temp,  Patm) # water viscosity in situ temperature but 0 salinity and 1 Patm
    mu = viscosity(salinity, temp, pres) # water viscosity in situ
    
    # from candif_fortran code
    if haskey(mdif, "H2O")
      A         = 12.5e-09 * exp(-5.22e-04 * Patm)
      B         = 925.0 * exp(-2.6e-04 * Patm)
      T0        = 95.0 + 2.61e-02 * Patm
      mdif["H2O"] = A * sqrt(TK) * exp(-B / (TK - T0)) * 1e4
    end
    if haskey(mdif, "O2")
      A = 0.2604
      B = 0.006383
      mdif["O2"] = (A + B * (TK / mu_0)) * 1E-05
    end
    if haskey(mdif, "CO2")
      A = 0.1954
      B = 0.005089
      mdif["CO2"] = (A + B * (TK / mu_0)) * 1E-05 
    end
    ## H3PO4 : Least (1984) determined D(H3PO4) at 25 deg C and 0 S.
    ##         Assume that this value can be scaled by the Stokes-Einstein
    ##         relationship to any other temperature.
    if haskey(mdif, "H3PO4")
      D_H3PO4 = 0.87e-05
      tS      = 25.0
      SS      = 0.0
      mu_S    = viscosity(SS, tS, Patm)
      mdif["H3PO4"] = D_H3PO4 * (mu_S / mu_0) * (TK / (tS + 273.15)) 
    end
    #  B(OH)3 : Mackin (1986) determined D(B(OH)3) at 25 deg C and
    #           about 29.2 S.
    #           Assume that this value can be scaled by the Stokes-Einstein
    #           relationship to any other temperature.
    if haskey(mdif, "H3BO3")
      D_BOH3 = 1.12e-05
      tS     = 25.0
      SS     = 29.2
      mu_S   = viscosity(SS, tS, Patm)
      mdif["H3BO3"] = D_BOH3 * (mu_S / mu_0) * (TK / (tS + 273.15)) 
    end
    ##  B(OH)4 : No information on this species ! Boudreau and
    ##           Canfield (1988) assume it is 12.5% smaller than B(OH)3.
    if haskey(mdif, "H4BO4")
      if haskey(mdif, "H3BO3")
        D_BOH3 = 1.12e-05
        tS     = 25.0
        SS     = 29.2
        mu_S   = viscosity(SS, tS, Patm)
        D_BOH3 = D_BOH3 * (mu_S / mu_0) * (TK / (tS + 273.15)) 
      else D_BOH3 = mdif["H3BO3"]
      end
      mdif["H4BO4"] = 0.875 * D_BOH3
    end
    ##  H4SiO4 : Wollast and Garrels (1971) found D(H4SiO4) at 25 deg C
    ##           and 36.1 ppt S.
    ##           Assume that this value can be scaled by the Stokes-Einstein
    ##           relationship to any other temperature.
    if haskey(mdif, "H4SiO4")
      D_H4SiO4 = 1.0E-05
      tS    = 25.0
      SS    = 36.1
      mu_S  = viscosity(SS, tS, Patm)
      mdif["H4SiO4"] = D_H4SiO4 * (mu_S / mu_0) * (TK / (tS + 273.15)) 
    end
    if haskey(mdif, "H3SiO4")
      D_H4SiO4 = 1.0E-05
      tS    = 25.0
      SS    = 36.1
      mu_S  = viscosity(SS, tS, Patm)
      mdif["H3SiO4"] = D_H4SiO4 * (mu_S / mu_0) * (TK / (tS + 273.15)) 
    end


    # from Noulty and Leaist 1985
    if haskey(mdif, "HF")
      D_HF = 1.68E-05
      tS    = 25.0
      SS    = 0.0
      mu_S  = viscosity(SS, tS, Patm)
      mdif["HF"] = D_HF * (mu_S / mu_0) * (TK / (tS + 273.15)) 
    end

    # from Li and Gregory
    if haskey(mdif, "MoO4")
      D_MoO4 = 9.91e-6
      tS    = 25.0
      SS    = 0.0
      mu_S  = viscosity(SS, tS, Patm)
      mdif["MoO4"] = D_MoO4 * (mu_S / mu_0) * (TK / (tS + 273.15)) 
    end



    # Boudreau 1997 p115 table4.7
    m0 = [25.9,10.0,9.60,6.29,9.81,5.06,4.33,4.02,3.26,2.62,10.4,6.35,
          4.82,5.99,4.88,4.66,10.3,9.50,54.4,4.43,6.06,6.06,10.3,7.82,
          9.50,3.60,3.43,3.31,3.18,4.06,2.57,3.31,3.31,3.39,3.63,3.36,
          3.69,4.46,3.91,3.31,2.79,2.95,2.78,2.71,4.46]
    m1 = [1.094,0.441,0.438,0.343,0.432,0.275,0.199,0.223,
           0.177,0.143,0.273,0.280,0.266,0.307,0.232,0.252,
           0.331,0.388,1.555,0.241,0.297,0.297,0.416,0.359,
           0.413,0.179,0.144,0.150,0.155,0.176,0.140,0.152,
           0.152,0.158,0.208,0.130,0.169,0.198,0.199,0.151,
           0.172,0.131,0.136,0.120,0.243]
    ion = ["OH","Br","Cl","F","I","HCO3","CO3","H2PO4",
      "HPO4","PO4","HS","HSO3","SO3","HSO4","SO4","IO3","NO2","NO3",
      "H","Li","Na","K","Cs","Ag","NH4","Ca","Mg","Fe","Mn","Ba","Be",
      "Cd","Co","Cu","Hg","Ni","Sr","Pb","Ra","Zn","Al","Ce","La","Pu","Al(OH)[4]"]

    for i in eachindex(ion)
        if haskey(mdif,ion[i])
            mdif[ion[i]] = (m0[i]+m1[i]*temp)*1e-6
        end
    end

  #   if haskey(mdif, "TH3PO4")
  #     i = findfirst(x->x=="HPO4",ion)
  #    mdif["TH3PO4"] = (m0[i]+m1[i]*temp)*1e-6
  #  end


    if haskey(mdif, "Nd")
      i = findfirst(x->x=="Ce",ion)
      mdif["Nd"] = (m0[i]+m1[i]*temp)*1e-6
    end
    if haskey(mdif, "Ndnr")
      i = findfirst(x->x=="Ce",ion)
      mdif["Ndnr"] = (m0[i]+m1[i]*temp)*1e-6
    end
    if haskey(mdif, "Ndr")
      i = findfirst(x->x=="Ce",ion)
      mdif["Ndr"] = (m0[i]+m1[i]*temp)*1e-6
    end
    if haskey(mdif, "TNdnr")
      i = findfirst(x->x=="Ce",ion)
      mdif["TNdnr"] = (m0[i]+m1[i]*temp)*1e-6
    end
    if haskey(mdif, "TNdr")
      i = findfirst(x->x=="Ce",ion)
      mdif["TNdr"] = (m0[i]+m1[i]*temp)*1e-6
    end

    if haskey(mdif, "Nd144")
      i = findfirst(x->x=="Ce",ion)
      mdif["Nd144"] = (m0[i]+m1[i]*temp)*1e-6
    end
    if haskey(mdif, "Nd143")
      i = findfirst(x->x=="Ce",ion)
      mdif["Nd143"] = (m0[i]+m1[i]*temp)*1e-6
    end

    # Boundreau 1997 p112 table4.4
    A  = [3338, 3047, 2000, 818, 1608, 7238, 6393, 9007, 15877]
    Ea = [16.06,18.36,18.10,11.70,14.84,19.81,20.20,21.61,23.26]
    gas1 = ["H2","CH4","DMS","He","Ne","Ar","Kr","Xe","Rn"]
    for i in eachindex(gas1)
        if haskey(mdif,gas1[i])
            mdif[gas1[i]] = A[i]*exp(-Ea[i]*1000/(8.314472*TK))*1e-5
        end
    end

    # Boundreau 1997 p111 table4.3
    Vb = [34.7,35.2,24.5,23.6,36.0,34.5,43.8]
    gas2 = ["N2","H2S","NH3","NO","N2O","CO","SO2"]
    for i in eachindex(gas2)
        if haskey(mdif,gas2[i])
          # a typo in equation 4.57, unit in m2/s not cm2/s, see original ref Hayduk and Laudie 1976
            mdif[gas2[i]] = 4.72e-07 * TK / (mu_0 * Vb[i]^0.6) 
        end
    end

    # convert to in situ salinity and pressure, 
    # convert to cm2/yr
    for i = 1:nspec
        mdif[species[i]] = mdif[species[i]]*mu_0/mu*365*24*3600
    end
    return (mdif,species_not_in_list)
end


