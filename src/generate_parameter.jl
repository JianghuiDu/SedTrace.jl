function parameter_code(param_model, substances,adsorption, options,cf)
    # error check
    errorcheck(param_model, options)

    for i in eachrow(param_model)
        if i.parameter != "Ngrid"
            if typeof(i.value) <: Int
                i.value = convert(Float64,i.value)
            end
        end
    end

    uniform_grid = getval!(options, :options, "uniform_grid", :value) == "yes"
    constant_porosity_profile =
        getval!(options, :options, "constant_porosity_profile", :value) == "yes"
    default_porosity_constant =
        getval!(options, :options, "default_porosity_constant", :value) == "yes"
    constant_bioturbation_profile =
        getval!(options, :options, "constant_bioturbation_profile", :value) == "yes"
    default_bioturbation_constant =
        getval!(options, :options, "default_bioturbation_constant", :value) == "yes"
    constant_bioirrigation_profile =
        getval!(options, :options, "constant_bioirrigation_profile", :value) == "yes"
    default_bioirrigation_constant =
        getval!(options, :options, "default_bioirrigation_constant", :value) == "yes"
    default_total_sediment_flux =
        getval!(options, :options, "default_total_sediment_flux", :value) == "yes"

    nsolid = sum(substances.type .== "solid")
    ndissolved = sum(substances.type .∈ Ref(["dissolved", "dissolved_adsorbed","dissolved_summed","dissolved_adsorbed_summed"]))
    nsummed = sum(substances.type .== "dissolved_summed_pH")

    NspeciesParam = @chain begin
        newdf()
        push!(["const", "nsolid", nsolid, "", "number of solid substances"],)
        push!(["const", "ndissolved", ndissolved, "", "number of dissolved substances"],)
        push!(["const", "nsummed", nsummed, "", "number of summed substances"],)
        push!([
            "const",
            "nnoneq",
            nsolid + ndissolved,
            "",
            "number of solid + dissolved substances",
        ],)
        push!([
            "const",
            "nspec",
            nsummed + nsolid + ndissolved,
            "",
            "number of total substances",
        ],)
        push!([
            "const",
            "Lwbdwth",
            2nsummed + nsolid + ndissolved - 1,
            "",
            "lower bandwidth of jacobian matrix",
        ],)
        push!([
            "const",
            "Upbdwth",
            cf ? 2(nsummed + nsolid + ndissolved) - 1 :  2nsummed + nsolid + ndissolved - 1,
            "",
            "upper bandwidth of jacobian matrix",
        ],)
    end


    globalParam = @chain begin
        @subset(param_model, :class .== "global")
        select(:type, :parameter, :value, :unit, :comment)
        push!(
            _,
            [
                "const",
                "sw_dens",
                densitySW(
                    _.value[_.parameter.=="depth"],
                    _.value[_.parameter.=="temp"],
                    _.value[_.parameter.=="salinity"],
                ),
                "g cm^-3",
                "seawater density",
            ],
        )
    end



    gridParam = @chain begin
        @subset(param_model, :class .== "grid")
        select(:type, :parameter, :value, :unit, :comment)
        push!(
            _,
            [
                "const",
                "Nmat",
                "Ngrid*nspec",
                "",
                "Jacobian dimention",
            ],
        )
        push!(
            _,
            [
                "const",
                "ξ",
                "range(0, step = L / (Ngrid), length = Ngrid + 1)",
                "cm",
                "uniform grid",
            ],
        )
        @aside gridtran = getval!(_, :parameter, "gridtran", :value)
        push!(
            _,
            [
                "const",
                "xᵥ",
                uniform_grid ? "collect(ξ)" : "broadcast(x->$gridtran,ξ)",
                "cm",
                "no grid transformation",
            ],
        )
        push!(
            _,
            ["const", "x", "(xᵥ[2:(Ngrid+1)] .+ xᵥ[1:Ngrid]) / 2", "cm", "cell center"],
        )
        push!(_, ["const", "dx", "xᵥ[2:(Ngrid+1)] .- xᵥ[1:Ngrid]", "cm", "cell volume"])
        @subset(:parameter .!= "gridtran")
    end




    porosityParam = @chain begin
        @subset(param_model, :class .== "porosity")
        select(:type, :parameter, :value, :unit, :comment)
        if constant_porosity_profile && default_porosity_constant

            push!(
                _,
                [
                    "const",
                    "phi",
                    "65.062*exp(3e-05*depth)",
                    "dimentionless",
                    "constant porosity, default to Martin2015GRL",
                ],
            )
            push!(
                _,
                [
                    "const",
                    "phi_Inf",
                    "phi",
                    "dimentionless",
                    "constant porosity, default to Martin2015GRL",
                ],
            )

        else
            _
        end
        @aside phi_fun = getval!(_, :parameter, "phi", :value)

        push!(
            _,
            [
                "const",
                "phif",
                constant_porosity_profile ? "phi" : "broadcast(x->$phi_fun,x)",
                "dimentionless",
                "fluid volume fraction",
            ],
        )
        push!(
            _,
            [
                "const",
                "phis",
                constant_porosity_profile ? "1-phif" : "1.0 .- phif",
                "dimentionless",
                "solid volume fraction",
            ],
        )
        push!(
            _,
            [
                "const",
                "pwtods",
                constant_porosity_profile ? "phif/phis" : "phif./phis",
                "dimentionless",
                "conversion from pore water to solid sediment volume unit",
            ],
        )
        push!(
            _,
            [
                "const",
                "dstopw",
                constant_porosity_profile ? "phis/phif" : "phis./phif",
                "dimentionless",
                "conversion from solid sediment to pore water volume unit",
            ],
        )
        @subset(:parameter .!= "phi")
    end



    burialParam = @chain begin
        @subset(param_model, :class .== "burial")
        select(:type, :parameter, :value, :unit, :comment)
        if default_total_sediment_flux
            push!(
                _,
                [
                    "const",
                    "Fsed",
                    "10^(-0.87478367-0.00043512*(depth))*ds_rho",
                    "g cm^-2 yr^-1",
                    "total sediment flux, default to Middelburg1997DSR",
                ],
            )
        else
            _
        end

        push!(
            _,
            [
                "const",
                "w_Inf",
                "Fsed / ds_rho / (1 - phi_Inf)",
                "cm yr^-1",
                "solid sediment burial velocity at infinite depth",
            ],
        )
        push!(
            _,
            [
                "const",
                "uf",
                "phi_Inf * w_Inf " * (constant_porosity_profile ? "" : ".") * "/ phif",
                "cm yr^-1",
                "pore water burial velocity",
            ],
        )
        push!(
            _,
            [
                "const",
                "us",
                "Fsed / ds_rho" * (constant_porosity_profile ? "" : ".") * "/ phis",
                "cm yr^-1",
                "solid sediment burial velocity",
            ],
        )

    end



    bioturbationParam = @chain begin
        @subset(param_model, :class .== "bioturbation")
        select(:type, :parameter, :value, :unit, :comment)
        if constant_bioturbation_profile && default_bioturbation_constant
            push!(
                _,
                [
                    "const",
                    "Dbt",
                    "5.2*10^(0.76241122 - 0.00039724 * depth)",
                    "cm^2 yr^-1",
                    "Constant bioturbation coefficient. Default to Middelburg1997DSR",
                ],
            )
        else
            _
        end
        @aside Dbt_fun = getval!(_, :parameter, "Dbt", :value)

        push!(
            _,
            [
                "const",
                "Ds",
                constant_bioturbation_profile ? "Dbt" : "broadcast(x->$Dbt_fun,x)",
                "cm^2 yr^-1",
                "Bioturbation coefficient",
            ],
        )
        @subset(:parameter .!= "Dbt")
    end


    bioirrigationParam = @chain begin
        @subset(param_model, :class .== "bioirrigation")
        select(:type, :parameter, :value, :unit, :comment)
        if constant_bioirrigation_profile && default_bioirrigation_constant
            depth = getval!(globalParam, :parameter, "depth", :value)
            O2BW = -0.0105927 * depth + 216.497 # umol/kg
            Dbir =
                (
                    -73.071 +
                    71.912exp(1.173 * exp(-0.017 * depth) + 0.191 * exp(-0.00047 * depth))
                ) / (O2BW / 1e3)
            push!(_, ["const", "alpha", Dbir, "cm^2 yr^-1", "Bioirrigation coefficient"])
        else
            _
        end
        @aside Dbir_fun = getval!(_, :parameter, "Dbir", :value)

        push!(
            _,
            [
                "const",
                "alpha",
                constant_bioirrigation_profile ? "Dbir" : "broadcast(x->$Dbir_fun,x)",
                "cm^2 yr^-1",
                "Bioirrigation coefficient",
            ],
        )
        @subset(:parameter .!= "Dbir")
    end


    adsParam = @chain begin
        @subset(param_model, :class .== "adsorption")
        select(:type, :parameter, :value, :unit, :comment)
    end

    # if speciation not modelled, then the main species is chosen to calculate molecular diffusivity


    # model_name1 = [
    #     "H3PO4", # if using H3PO4 as the name for total H3PO4 but without speciation
    #     "TH3PO4", # if using TH3PO4 as the name for total H3PO4 but without speciation
    #     "CO2",
    #     "TCO2",
    #     "H2S",
    #     "TH2S",
    #     "THSO4",
    #     "HSO4",
    #     "TNH4",
    #     "TH3BO3",
    #     "THF",
    #     "HF",
    # ]
    # species_name1 =
    #     ["HPO4", "HPO4", "HCO3", "HCO3", "HS", "HS", "SO4", "SO4", "NH4", "H3BO3", "F", "F"]
    model_name1 = ["TH3PO4","TNH4","TH4SiO4","TH2S","THF","TH3BO3","THSO4","TCO2"]
    species_name1 = ["HPO4","NH4","H4SiO4","HS","F","H3BO3","SO4","HCO3"]

    model_name2 = ["Al", "Mo"]
    species_name2 = ["Al(OH)[4]", "MoO4"]

    model_name = [model_name1; model_name2]
    species_name = [species_name1; species_name2]

    dict = Dict(model_name[i] => species_name[i] for i = 1:length(model_name))


    dissolved = @chain begin
        substances
        @subset(:type .∈ Ref(["dissolved", "dissolved_adsorbed","dissolved_summed"]))
        @transform(
            :species =
                ifelse.(
                    in.(:substance, Ref(keys(dict))),
                    get.(Ref(dict), :substance, missing),
                    :substance,
                )
        )
        @transform(:species_name = :substance)
    end


    dissolved_summed = @chain begin
        substances
        @subset(:type .== "dissolved_summed_pH")
        @transform(:species = split.(:species_modelled, ","))
        DataFrames.flatten(:species)
        @transform(:species = mymatch.(r"[\w\[\]\(\)]+", :species))
        @transform(:species_name = :species)
    end

    dissolved_adsorbed = @chain begin
        substances
        @subset(:type .== "dissolved_adsorbed")
        @transform(:species = :substance .* "_ads")
        @transform(:type = "solid")
        @transform(:species_name = :species)
    end

    dissolved_all = @chain begin
        dissolved
        append!(dissolved_summed)
    end

    if any(substances.type.=="dissolved_adsorbed_summed")
        dissolved_adsorbed_summed = @chain begin
            substances
            @subset(:type .== "dissolved_adsorbed_summed")
            @transform(:species = split.(:species_modelled, ","))
            DataFrames.flatten(:species)
            @transform(:species = mymatch.(r"[\w\[\]\(\)]+", :species))
            @transform(:species_name = :species)
            leftjoin(adsorption,on=[:substance,:species,:include])
            @transform(:type = ifelse.(:surface.=="dissolved","dissolved","solid"))
            @transform(:top_bc_type = ifelse.(:surface.=="dissolved","dirichlet","robin"))
            select(names(dissolved))
            unique
        end
        append!(dissolved_all,@subset(dissolved_adsorbed_summed,:type.=="dissolved"))

    end


    

    salinity = getNumber!(globalParam, :parameter, "salinity", :value)
    temperature = getNumber!(globalParam, :parameter, "temp", :value)
    pressure = getNumber!(globalParam, :parameter, "depth", :value) / 10
    sw_dens = getNumber!(globalParam, :parameter, "sw_dens", :value)

    mdif = molecdiff(salinity, temperature, pressure) # cm2 yr-1 in situ diffusivity


    diffusionParam = @chain begin
        @subset(param_model, :class .== "diffusion")
        select(:type, :parameter, :value, :unit, :comment)
    end


    bcParam = @chain begin
        @subset(param_model, :class .== "BoundaryCondition")
        select(:type, :parameter, :value, :unit, :comment)
        @subset(:parameter .!= "delta")
    end


    for i in eachrow(dissolved_all)
        push!(
            diffusionParam,
            [
                "const",
                "D" * i.species_name,
                @sprintf("%.16E", mdif[i.species]) * (
                    constant_porosity_profile ? "/(1-2log(phif))" :
                    "./(1.0 .- 2log.(phif))"
                ),
                "cm^2 yr^-1",
                "Sediment diffusion coefficient",
            ],
        )
    end



    #---------------------------------------------------------------------
    # pH calculation of boundary conditions
    #---------------------------------------------------------------------
    R"""
    library(AquaEnv)
    diss_const <- function(salinity,temp,pres){
      KW <- K_W(S=salinity,t=temp,p=pres)
      KH3BO3 <- K_BOH3(S=salinity,t=temp,p=pres)
      KCO2 <- K_CO2(S=salinity,t=temp,p=pres)
      KHCO3 <- K_HCO3(S=salinity,t=temp,p=pres)
      KHF <- K_HF(S=salinity,t=temp,p=pres)
      KHSO4 <- K_HSO4(S=salinity,t=temp,p=pres)
      KH2S <- K_H2PO4(S=salinity,t=temp,p=pres)
      KH3PO4 <- K_H3PO4(S=salinity,t=temp,p=pres)
      KH2PO4 <- K_H2PO4(S=salinity,t=temp,p=pres)
      KHPO4 <- K_HPO4(S=salinity,t=temp,p=pres)
      KNH4 <- K_NH4(S=salinity,t=temp,p=pres)
      KH4SiO4 <- K_SiOH4(S=salinity,t=temp,p=pres)
      KCaCO3 <- Ksp_calcite(S=salinity,t=temp,p=pres)
      return(data.frame(KW,KH3BO3,KCO2,KHCO3,KHF,KHSO4,KH2S,
               KH3PO4,KH2PO4,KHPO4,KNH4,KH4SiO4,KCaCO3))
    }
    K_diss <- diss_const(salinity=$salinity,temp=$temperature,pres=$pressure)/$sw_dens^2
    # units in (mmol cm^3)^2
    """

    K_diss = @rget K_diss

    KH2O = K_diss.KW[1]
    KCO2 = K_diss.KCO2[1]
    KHCO3 = K_diss.KHCO3[1]
    KH2S = K_diss.KH2S[1]
    KH3BO3 = K_diss.KH3BO3[1]
    KHSO4 = K_diss.KHSO4[1]
    KHF = K_diss.KHF[1]
    KNH4 = K_diss.KNH4[1]
    KH3PO4 = K_diss.KH3PO4[1]
    KH2PO4 = K_diss.KH2PO4[1]
    KHPO4 = K_diss.KHPO4[1]
    KH4SiO4 = K_diss.KH4SiO4[1]

    KpHParam = newdf()

    Ks = Dict("KH2O"=>KH2O,"KCO2"=>KCO2,"KHCO3"=>KHCO3,"KH2S"=>KH2S,"KH3BO3"=>KH3BO3,"KHSO4"=>KHSO4,"KHF"=>KHF,"KNH4"=>KNH4,"KH3PO4"=>KH3PO4,"KH2PO4"=>KH2PO4,"KHPO4"=>KHPO4,"KH4SiO4"=>KH4SiO4)


    function varsubscript(bc_type, top)
        if bc_type == "robin" && top
            return "BW"
        elseif bc_type == "dirichlet" && top
            return "0"
        elseif bc_type == "dirichlet" && !top
            return "L"
        else
            return nothing
        end
    end

    function comment(vscpt, substance)
        if vscpt == "BW"
            return "Bottom water concentration of " * substance
        elseif vscpt == "0"
            return "Concentration of " * substance * " at the TOP of sediment column"
        elseif vscpt == "L"
            return "Concentration of " * substance * " at the BOTTOM of sediment column"
        end
    end

    
function pH_param(substances,bcParam,KpHParam,summed_species,Ks)
    df = @subset(substances, :substance .== summed_species)
    vscptTOP = varsubscript(df.top_bc_type[1], true)
    vscptBOT = varsubscript(df.bot_bc_type[1], false)
    vscpt = [vscptTOP, vscptBOT]
    vscpt = filter!(x -> !isnothing(x), vscpt)
    eqinv = EquilibriumInvariant(summed_species)

    p = 0
    for k in eqinv.diss_const
        p+=1
    push!(
        KpHParam,
        [
            "const",
            k,
            @sprintf("%.16E", Ks[k]),
            "",
            "$(summed_species) $(p)th dissociation constant",
        ],
    )
    end

    for i in vscpt
        H_tmp = 10^(-1 * getNumber!(bcParam, :parameter, "pH" * i, :value))
        if summed_species != "H"
        Summed_tmp = getNumber!(bcParam, :parameter, summed_species * i, :value)
        end

        for j in 1:length(eqinv.species)
    
            expr = replace(eqinv.expr[j],r"\bH\b"=>"$H_tmp")
            if summed_species != "H"
            expr = replace(expr,Regex("\\b$(summed_species)\\b")=>"$Summed_tmp")
            end
            for (key,value) in Ks
                expr = replace(expr,Regex("\\b$key\\b") => "$value")
            end
            res = eval(Meta.parse(expr))
        push!(
            bcParam,
            [
                "const",
                eqinv.species[j] * i,
                @sprintf(
                    "%.16E",
                    res,
                ),
                "mmol cm^-3",
                comment(i, eqinv.species[j]),
            ],
        )
        end
    end


end

    dissolved_summed_all = @chain begin
        substances
        @subset(:type .∈ Ref(["dissolved_summed","dissolved_summed_pH"]))
    end
    
    for m in dissolved_summed_all.substance
        pH_param(substances,bcParam,KpHParam,m,Ks)
    end


    for i in eachrow(dissolved_adsorbed)
        vscptTOP = varsubscript(i.top_bc_type, true)
        vscptBOT = varsubscript(i.bot_bc_type, false)
        vscpt = [vscptTOP, vscptBOT]
        vscpt = filter!(x -> !isnothing(x), vscpt)
        for j in vscpt
            push!(
                bcParam,
                [
                    "const",
                    i.species_name * j,
                    "K$(i.species_name) * $(i.substance)$j",
                    "mmol cm^-3",
                    comment(j, "adsorbed $(i.substance)"),
                ],
            )
        end
    end

    betaParam = @chain begin        
    @subset(param_model, :class .== "BoundaryCondition")
    select(:type, :parameter, :value, :unit, :comment)
    @subset(:parameter .== "delta")
    end

    for i in eachrow(dissolved_all)
        if i.top_bc_type == "robin"
            push!(
                betaParam,
                [
                    "const",
                    "beta" * i.species_name,
                    @sprintf(
                        "%.16E",
                        mdif[i.species] / getval!(betaParam, :parameter, "delta", :value),
                    ),
                    "cm yr^-1",
                    "solute mass transfer velocity across SWI",
                ],
            )
        end

    end


    function setTopBC(substance, type, bc_type)
        vecid = constant_porosity_profile ? "" : "[1]"
        if bc_type == "robin"
            if type == "solid"
                BC_str = "(phis$(vecid)us$vecid, -phis$(vecid)Ds$vecid, F$(substance)0)"
            else
                BC_str = "(beta$substance + phif$(vecid)uf$(vecid), -phif$(vecid)D$substance$(vecid), beta$substance * $(substance)BW)"
            end
        elseif bc_type == "dirichlet"
            BC_str = "(1.0, 0.0, $(substance)0)"
        end
        return BC_str
    end
    function setBotBC(substance, type, bc_type)
        vecid = constant_porosity_profile ? "" : "[Ngrid]"
        if bc_type == "neumann"
            if substance == "Age"
                BC_str = "(0.0,1.0,1.0/us$vecid)"
            else
                BC_str = "(0.0, 1.0, 0.0)"
            end
        elseif bc_type == "dirichlet"
            BC_str = "(1.0, 0.0, $(substance)L)"
        end
        return BC_str
    end

    substances_bc = @chain begin
        substances
        @subset(:type .== "solid")
        @transform(:species = :substance)
        @transform(:species_name = :substance)
        append!(dissolved_all)
        append!(dissolved_adsorbed)
        unique
    end
    if any(substances.type.=="dissolved_adsorbed_summed")
        append!(substances_bc,
        @subset(dissolved_adsorbed_summed,:type .!="dissolved"))
    end

    bdParam = newdf()

    for i in eachrow(substances_bc)
        BC_str_Top = setTopBC(i.species_name, i.type, i.top_bc_type)
        BC_str_Bot = setBotBC(i.species_name, i.type, i.bot_bc_type)
        push!(
            bdParam,
            [
                "const",
                "Bc" * i.species_name,
                "($BC_str_Top, $BC_str_Bot)",
                "",
                "Boundary condition of $(i.substance)",
            ],
        )
    end

    tranIntParam = newdf()
    tranBCParam = newdf()
    for i in eachrow(substances_bc)
        if i.type == "solid"
            push!(
                tranBCParam,
                [
                    "const",
                    "BcAm$(i.species_name), BcBm$(i.species_name), BcCm$(i.species_name)",
                    "fvcf_bc(phis,Ds,us,dx,Bc$(i.species_name),Ngrid)",
                    "",
                    "Boundary transport matrix of $(i.species_name)",
                ],
            )
            push!(
                tranIntParam,
                [
                    "const",
                    "Am$(i.species_name), Bm$(i.species_name)",
                    "fvcf(phis,Ds,us,dx,Ngrid)",
                    "",
                    "Interior transport matrix of $(i.species_name)",
                ],
            )
        else
            push!(
                tranBCParam,
                [
                    "const",
                    "BcAm$(i.species_name), BcBm$(i.species_name), BcCm$(i.species_name)",
                    "fvcf_bc(phif,D$(i.species_name),uf,dx,Bc$(i.species_name),Ngrid)",
                    "",
                    "Boundary transport matrix of $(i.species_name)",
                ],
            )
            push!(
                tranIntParam,
                [
                    "const",
                    "Am$(i.species_name), Bm$(i.species_name)",
                    "fvcf(phif,D$(i.species_name),uf,dx,Ngrid)",
                    "",
                    "Interior transport matrix of $(i.species_name)",
                ],
            )
        end


    end


    reactionParam = @chain begin
        @subset(param_model, :class .== "Reaction")
        select(:type, :parameter, :value, :unit, :comment)
    end


    initialvec = String[]
    vecid = constant_porosity_profile ? "" : "[1]"

    for i in eachrow(substances)
        if i.type == "solid"
            if i.top_bc_type == "robin"
                ini = "F$(i.substance)0/(phis$vecid*us$vecid)"
            elseif i.top_bc_type == "dirichlet"
                ini = "$(i.substance)0"
            end
        elseif i.type ∈ ["dissolved", "dissolved_adsorbed", "dissolved_summed","dissolved_summed_pH"]
            if i.top_bc_type == "robin"
                ini = "$(i.substance)BW"
            elseif i.top_bc_type == "dirichlet"
                ini = "$(i.substance)0"
            end
        elseif i.type == "dissolved_adsorbed_summed"
            ini = replace("$(i.substance)0",r"\bT"=>"")
        end

        push!(initialvec, ini)
    end


    initialParam = @chain begin
        newdf()
        push!(["const", "C_ini", "[$(join(initialvec,","))]", "", "initial conditions"],)
    end

    abtolParam = @chain begin
        newdf()
    end

    if "abtol" ∈ names(substances)
        push!(abtolParam,["const", "abtol0", "[$(join(substances.abtol,","))]", "", "absolute tolerance"],)
    end



    param_str = String[]
    # param_df = @chain begin
    #     NspeciesParam
    #     outerjoin(globalParam,on=[:type,:parameter,:value,:unit,:comment])
    #     outerjoin(gridParam,on=[:type,:parameter,:value,:unit,:comment])
    #     outerjoin(porosityParam,on=[:type,:parameter,:value,:unit,:comment])
    #     outerjoin(burialParam,on=[:type,:parameter,:value,:unit,:comment])
    #     outerjoin(bioturbationParam,on=[:type,:parameter,:value,:unit,:comment])
    #     outerjoin(bioirrigationParam,on=[:type,:parameter,:value,:unit,:comment])
    #     outerjoin(adsParam,on=[:type,:parameter,:value,:unit,:comment])
    #     outerjoin(diffusionParam,on=[:type,:parameter,:value,:unit,:comment])
    #     outerjoin(betaParam,on=[:type,:parameter,:value,:unit,:comment])
    #     outerjoin(bcParam,on=[:type,:parameter,:value,:unit,:comment])
    #     outerjoin(bdParam,on=[:type,:parameter,:value,:unit,:comment])
    #     outerjoin(tranBCParam,on=[:type,:parameter,:value,:unit,:comment])
    #     outerjoin(tranIntParam,on=[:type,:parameter,:value,:unit,:comment])
    #     outerjoin(KpHParam,on=[:type,:parameter,:value,:unit,:comment])
    #     outerjoin(reactionParam,on=[:type,:parameter,:value,:unit,:comment])
    #     outerjoin(initialParam,on=[:type,:parameter,:value,:unit,:comment])
    #     outerjoin(abtolParam,on=[:type,:parameter,:value,:unit,:comment])

    # end

    appendtostr!(param_str, NspeciesParam, "Number of substances")
    appendtostr!(param_str, globalParam, "global parameters")
    appendtostr!(param_str, gridParam, "grid parameters")
    appendtostr!(param_str, porosityParam, "porosity parameters")
    appendtostr!(param_str, burialParam, "burial parameters")
    appendtostr!(param_str, bioturbationParam, "bioturbation parameters")
    appendtostr!(param_str, bioirrigationParam, "bioirrigation parameters")
    appendtostr!(param_str, adsParam, "adsorption parameters")
    appendtostr!(param_str, diffusionParam, "solute diffusivity")
    appendtostr!(param_str, betaParam, "solute mass transfer velocities")
    appendtostr!(param_str, bcParam, "boundary fluxes and concentrations")
    appendtostr!(param_str, bdParam, "assemble boundary conditions")
    appendtostr!(param_str, tranBCParam, "Boundary transport matrix")
    appendtostr!(param_str, tranIntParam, "Interior transport matrix")
    appendtostr!(param_str, KpHParam, "Acid dissociation constants")
    appendtostr!(param_str, reactionParam, "Reaction parameters")
    appendtostr!(param_str, initialParam, "Inital values")
    appendtostr!(param_str, abtolParam, "Tolerance parameters")
    # appendtostr!(param_str, indexParam, "Indices")

    return param_str
end
