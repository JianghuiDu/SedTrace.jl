
function viscosity(salinity, temp, pres)
    # dynamic viscosity unit in 1e-2 g cm-1 s-1
    1.7910 - temp * (6.144e-02 - temp * (1.4510e-03 - temp * 1.6826e-05)) -
    1.5290e-04 * pres +
    8.3885e-08 * pres * pres +
    2.4727e-03 * salinity +
    (6.0574e-06 * pres - 2.6760e-09 * pres * pres) * temp +
    (temp * (4.8429e-05 - temp * (4.7172e-06 - temp * 7.5986e-08))) * salinity
end



# return molecular diffusion in cm2/yr
function molecdiff(salinity, temp, pres, species_list)
    Patm = 1.013253 # atmospheric pressure in 1e5 Pa or 1 bar
    pres = pres + Patm # total pressure

    mu_T = viscosity(0.0, temp, Patm) # water viscosity in situ temperature but 0 salinity and 1 Patm
    mu = viscosity(salinity, temp, pres) # water viscosity in situ
    mu_0 = viscosity(0.0, 25, Patm) # water viscosity in situ temperature but 0 salinity and 1 Patm

    nspec = length(species_list)
    diffcoef = fill(NaN, nspec)#Array{Float64}(undef, nspec)
    mdif = Dict(species_list[i] => diffcoef[i] for i = 1:nspec)

    path = (@__DIR__)*"\"

    D0 =  XLSX.readxlsx(path*"diffusion.xlsx")
    D0_type1 =  DataFrame(XLSX.gettable(D0["type1"]))
    D0_type2 =  DataFrame(XLSX.gettable(D0["type2"]))
    D0_type3 =  DataFrame(XLSX.gettable(D0["type3"]))
    @subset!(D0_type1,:include.==1)
    @subset!(D0_type2,:include.==1)
    @subset!(D0_type3,:include.==1)


    for i in species_list
        if i in D0_type1.SedTrace_name
            id = findfirst(x -> x == i, D0_type1.SedTrace_name)
            mdif[i] =
                (D0_type1.m0[id] + D0_type1.m1[id] * temp) * 1e-6 * mu_T / mu *
                365 *
                24 *
                3600
        elseif i in D0_type2.SedTrace_name
            id = findfirst(x -> x == i, D0_type2.SedTrace_name)
            mdif[i] =
                D0_type2.D0[id] * mu_0 / 298.15 * (temp + 273.15) / mu * 1e-6 * 365 * 24 * 3600
        elseif i in D0_type3.SedTrace_name
            id = findfirst(x -> x == i, D0_type3.SedTrace_name)
            mdif[i] =
                (D0_type3.a0[id] + D0_type3.a1[id]*(temp+273.15)/mu) * 1e-6 * 365 * 24 * 3600
        end
    end

    return filter!(p->!isnan(p.second),mdif)
end


