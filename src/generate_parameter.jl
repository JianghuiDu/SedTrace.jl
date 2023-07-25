function parameter_code(param_model, substances, adsorption, diffusion,assemble)
    # error check
    # errorcheck(param_model, options)

    for i in eachrow(param_model)
        if i.parameter != "Ngrid"
            if typeof(i.value) <: Int
                i.value = convert(Float64, i.value)
            end
        end
    end

    nsolid = sum(substances.type .== "solid")
    ndissolved = sum(
        substances.type .∈ Ref([
            "dissolved",
            # "dissolved_adsorbed",
            "dissolved_speciation",
        ]),
    )
    nsummed = sum(substances.type .== "dissolved_pH")

    NspeciesParam = newdf()
    push!(NspeciesParam, ["const", "nsolid", nsolid, "", "number of solid substances"])
    push!(
        NspeciesParam,
        ["const", "ndissolved", ndissolved, "", "number of dissolved substances"],
    )
    push!(NspeciesParam, ["const", "nsummed", nsummed, "", "number of summed substances"])
    push!(
        NspeciesParam,
        ["const", "nspec", nsummed + nsolid + ndissolved, "", "number of total substances"],
    )

    function RmCol!(df::DataFrame, col::Symbol = :class)
        select!(df, Not(col))
    end

    globalParam = subset(param_model, :class => x -> x .== "global")
    RmCol!(globalParam)
    density = densitySW(
        getval!(globalParam, :parameter, "depth", :value),
        getval!(globalParam, :parameter, "temp", :value),
        getval!(globalParam, :parameter, "salinity", :value),
    )

    push!(globalParam, ["const", "sw_dens", density, "g cm^-3", "seawater density"])


    gridParam = subset(param_model, :class => x -> x .== "grid")
    RmCol!(gridParam)
    Ngrid = getval!(gridParam, :parameter, "Ngrid", :value)
    # setval!(gridParam,:parameter,"Ngrid",:parameter,"const Ngrid")
    push!(
        gridParam,
        ["const", "Nmat", Ngrid * (nsolid + ndissolved+nsummed), "integer", "Jacobian dimension"],
    )
    push!(
        gridParam,
        [
            "const",
            "ξ",
            "range(0, step = L / (Ngrid), length = Ngrid + 1)",
            "cm",
            "uniform grid",
        ],
        promote = true,
    )
    gridtran = getval!(gridParam, :parameter, "gridtran", :value)
    push!(
        gridParam,
        ["const", "xᵥ", "broadcast(x->$gridtran,ξ)", "cm", "non-uniform grid transformation"],
    )
    push!(
        gridParam,
        ["const", "x", "(xᵥ[2:(Ngrid+1)] .+ xᵥ[1:Ngrid]) / 2", "cm", "cell center"],
    )
    push!(gridParam, ["const", "dx", "xᵥ[2:(Ngrid+1)] .- xᵥ[1:Ngrid]", "cm", "cell volume"])
    subset!(gridParam, :parameter => x -> x .!= "gridtran")



    porosityParam = subset(param_model, :class => x -> x .== "porosity")
    RmCol!(porosityParam)
    phi_fun = getval!(porosityParam, :parameter, "phi", :value)

    push!(
        porosityParam,
        [
            "const",
            "phif",
            "broadcast(x->$phi_fun,x)",
            "dimensionless",
            "fluid volume fraction",
        ],
        promote = true,
    )
    push!(
        porosityParam,
        ["const", "phis", "1.0 .- phif", "dimensionless", "solid volume fraction"],
    )
    push!(
        porosityParam,
        [
            "const",
            "pwtods",
            "phif./phis",
            "dimensionless",
            "conversion from pore water to solid sediment volume unit",
        ],
    )
    push!(
        porosityParam,
        [
            "const",
            "dstopw",
            "phis./phif",
            "dimensionless",
            "conversion from solid sediment to pore water volume unit",
        ],
    )    
    # push!(
    #     porosityParam,
    #     [
    #         "const",
    #         "phif0",
    #         "(x->$phi_fun)(0)",
    #         "dimensionless",
    #         "fluid volume fraction at x = 0",
    #     ],
    #     promote = true,
    # )
    # push!(
    #     porosityParam,
    #     [
    #         "const",
    #         "phis0",
    #         "1 - phif0",
    #         "dimensionless",
    #         "solid volume fraction at x = 0",
    #     ],
    #     promote = true,
    # )
    subset!(porosityParam, :parameter => x -> x .!= "phi")



    burialParam = subset(param_model, :class => x -> x .== "burial")
    RmCol!(burialParam)

    push!(
        burialParam,
        [
            "const",
            "w_Inf",
            "Fsed / ds_rho / (1 - phi_Inf)",
            "cm yr^-1",
            "solid sediment burial velocity at infinite depth",
        ],
        promote = true,
    )
    push!(
        burialParam,
        [
            "const",
            "uf",
            "phi_Inf * w_Inf ./ phif",
            "cm yr^-1",
            "pore water burial velocity",
        ],
    )
    push!(
        burialParam,
        [
            "const",
            "us",
            "Fsed / ds_rho./ phis",
            "cm yr^-1",
            "solid sediment burial velocity",
        ],
    )
    # push!(
    #     burialParam,
    #     [
    #         "const",
    #         "uf0",
    #         "phi_Inf * w_Inf / phif0",
    #         "cm yr^-1",
    #         "pore water burial velocity",
    #     ],
    # )
    # push!(
    #     burialParam,
    #     [
    #         "const",
    #         "us0",
    #         "Fsed / ds_rho/ phis0",
    #         "cm yr^-1",
    #         "solid sediment burial velocity",
    #     ],
    # )



    bioturbationParam = subset(param_model, :class => x -> x .== "bioturbation")
    RmCol!(bioturbationParam)
    Dbt_fun = getval!(bioturbationParam, :parameter, "Dbt", :value)

    push!(
        bioturbationParam,
        [
            "const",
            "Ds",
            "broadcast(x->$Dbt_fun,x)",
            "cm^2 yr^-1",
            "Bioturbation coefficient",
        ],
        promote = true,
    )
    # push!(
    #     bioturbationParam,
    #     [
    #         "const",
    #         "Ds0",
    #         "(x->$Dbt_fun)(0)",
    #         "cm^2 yr^-1",
    #         "Bioturbation coefficient at x = 0",
    #     ],
    #     promote = true,
    # )
subset!(bioturbationParam, :parameter => x -> x .!= "Dbt")



    bioirrigationParam = subset(param_model, :class => x -> x .== "bioirrigation")
    RmCol!(bioirrigationParam)
    Dbir_fun = getval!(bioirrigationParam, :parameter, "Dbir", :value)

    push!(
        bioirrigationParam,
        [
            "const",
            "alpha",
            "broadcast(x->$Dbir_fun,x)",
            "yr^-1",
            "Bioirrigation coefficient",
        ],
        promote = true,
    )
    subset!(bioirrigationParam, :parameter => x -> x .!= "Dbir")


    adsParam = subset(param_model, :class => x -> x .== "speciation")
    RmCol!(adsParam)


    # if speciation not modelled, then the main species is chosen to calculate molecular diffusivity


    # model_name1 = ["TH3PO4", "TNH4", "TH4SiO4", "TH2S", "THF", "TH3BO3", "THSO4", "TCO2"]
    # species_name1 = ["HPO4", "NH4", "H4SiO4", "HS", "F", "H3BO3", "SO4", "HCO3"]

    # model_name2 = ["Al", "Mo","TFe_dis","TNH4_dis","TH3PO4_dis","TMn_dis","Al_dis","TNdnr_dis","TNdr_dis"]
    # species_name2 = ["Al(OH)[4]", "MoO4","Fe","NH4","HPO4","Mn","Al(OH)[4]","Ndnr","Ndr"]

    # model_name = [model_name1; model_name2]
    # species_name = [species_name1; species_name2]

    # dict = Dict(model_name[i] => species_name[i] for i in eachindex(model_name))

    dict = Dict(diffusion.model_name[i] => diffusion.SedTrace_name[i] for i in eachindex(diffusion.model_name))

    dissolved = subset(
        substances,
        :type => x -> x .∈ Ref(
            [
            "dissolved", 
            # "dissolved_adsorbed", 
            "dissolved_speciation"
            ]),
    )
    @transform!(dissolved,:substance = ifelse.(:type .== "dissolved_speciation",:substance.*"_dis",:substance))
    @transform!(
        dissolved,
        :species =
            ifelse.(
                in.(:substance, Ref(keys(dict))),
                get.(Ref(dict), :substance, missing),
                :substance,
            )
    )
    @transform!(dissolved, :species_name = :substance)

    if any(substances.type .== "dissolved_pH")
        dissolved_summed = @subset(substances, :type .== "dissolved_pH")
        @transform!(dissolved_summed, :species = split.(:formula, ","))
        dissolved_summed = DataFrames.flatten(dissolved_summed, :species)
        # @transform!(dissolved_summed, :species = mymatch.(r"[\w\[\]\(\)]+", :species))
        # @transform!(dissolved_summed, :species_name = :species)
        @transform!(dissolved_summed, :species_name = mymatch.(r"[\w\[\]\(\)]+", :species))
    else
        dissolved_summed = newdf()
    end

    if any(substances.type .== "dissolved_pH")
        dissolved_all = append!(dissolved, dissolved_summed)
    else
        dissolved_all = dissolved
    end

    # dissolved_adsorbed = @subset(substances, :type .== "dissolved_adsorbed")
    # @transform!(dissolved_adsorbed, :species = :substance .* "_ads")
    # @transform!(dissolved_adsorbed, :type = "solid")
    # @transform!(dissolved_adsorbed, :species_name = :species)



    salinity = getNumber!(globalParam, :parameter, "salinity", :value)
    temperature = getNumber!(globalParam, :parameter, "temp", :value)
    pressure = getNumber!(globalParam, :parameter, "depth", :value) / 10
    sw_dens = getNumber!(globalParam, :parameter, "sw_dens", :value)


    mdif = molecdiff(salinity, temperature, pressure,dissolved_all.species) # cm2 yr-1 in situ diffusivity


    diffusionParam = @subset(param_model, :class .== "diffusion")
    RmCol!(diffusionParam)



    betaParam = @subset(param_model, :class .== "BoundaryCondition")
    RmCol!(betaParam)
    @subset!(betaParam, :parameter .== "delta")


    for i in eachrow(dissolved_all)
        if i.species in keys(mdif)
            push!(
                diffusionParam,
                [
                    "const",
                    "D" * i.species_name,
                    @sprintf("%.16E", mdif[i.species]) * ("./(1.0 .- 2log.(phif))"),
                    "cm^2 yr^-1",
                    "Sediment diffusion coefficient",
                ],
                promote = true,
            )
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
        else
            Dmole = getval!(diffusionParam,:parameter,"D"*i.species_name,:value)
            if isnothing(Dmole)
                throw(error("The molecular diffusivity of dissolved species $(i.species_name) cannot be calculated by default. You need to supply a value for  D$(i.species_name) in the parameter sheet."))
            else
                @subset!(diffusionParam,:parameter .!= "D"*i.species_name)
                push!(
                    diffusionParam,
                    [
                        "const",
                        "D" * i.species_name,
                        @sprintf("%.16E", Dmole) * ("./(1.0 .- 2log.(phif))"),
                        "cm^2 yr^-1",
                        "Sediment diffusion coefficient",
                    ],
                    promote = true,
                ) 
                if i.top_bc_type == "robin"
                    push!(
                        betaParam,
                        [
                            "const",
                            "beta" * i.species_name,
                            @sprintf(
                                "%.16E",
                                Dmole / getval!(betaParam, :parameter, "delta", :value),
                            ),
                            "cm yr^-1",
                            "solute mass transfer velocity across SWI",
                        ],
                    )            
                end   
            end
        end
    end

    myInterp(ranges::NTuple{N,AbstractRange}, vs::AbstractArray{T,N};
    bc = Line(OnGrid()), extrapolation_bc = Throw()) where {N,T} = scale(interpolate(vs, BSpline(Cubic(bc))), ranges...)


    if nsummed !=0
        #---------------------------------------------------------------------
        # pH calculation of boundary conditions
        #---------------------------------------------------------------------
        path = (@__DIR__)*"\"
        KH2O,KH3BO3,KCO2,KHCO3,KHF,KHSO4,KH2S,KH3PO4,KH2PO4,KHPO4,KNH4,KH4SiO4 = JLD2.load(path*"dissociation_constants.jld2","K_diss");

        SAL = 0:0.5:37
        TEM = 0:0.5:40
        PRE = 0:75:6000
                
        itp_KH2O = myInterp((SAL,TEM,PRE),KH2O);
        itp_KH3BO3 = myInterp((SAL,TEM,PRE), KH3BO3);
        itp_KCO2 = myInterp((SAL,TEM,PRE), KCO2);
        itp_KHCO3 = myInterp((SAL,TEM,PRE), KHCO3);
        itp_KHF = myInterp((SAL,TEM,PRE), KHF);
        itp_KHSO4 = myInterp((SAL,TEM,PRE), KHSO4);
        itp_KH2S = myInterp((SAL,TEM,PRE), KH2S);
        itp_KH3PO4 = myInterp((SAL,TEM,PRE), KH3PO4);
        itp_KH2PO4 = myInterp((SAL,TEM,PRE), KH2PO4);
        itp_KHPO4 = myInterp((SAL,TEM,PRE), KHPO4);
        itp_KNH4 = myInterp((SAL,TEM,PRE), KNH4);
        itp_KH4SiO4 = myInterp((SAL,TEM,PRE), KH4SiO4);
        
        
        Ks = Dict(
            "KH2O" => itp_KH2O(salinity,temperature,pressure),
            "KCO2" => itp_KCO2(salinity,temperature,pressure),
            "KHCO3" => itp_KHCO3(salinity,temperature,pressure),
            "KH2S" => itp_KH2S(salinity,temperature,pressure),
            "KH3BO3" => itp_KH3BO3(salinity,temperature,pressure),
            "KHSO4" => itp_KHSO4(salinity,temperature,pressure),
            "KHF" => itp_KHF(salinity,temperature,pressure),
            "KNH4" => itp_KNH4(salinity,temperature,pressure),
            "KH3PO4" => itp_KH3PO4(salinity,temperature,pressure),
            "KH2PO4" => itp_KH2PO4(salinity,temperature,pressure),
            "KHPO4" => itp_KHPO4(salinity,temperature,pressure),
            "KH4SiO4" => itp_KH4SiO4(salinity,temperature,pressure),
        )
        KpHParam = newdf()
    end


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


    function pH_param(substances, bcParam, KpHParam, summed_species, Ks)
        df = @subset(substances, :substance .== summed_species)
        vscptTOP = varsubscript(df.top_bc_type[1], true)
        vscptBOT = varsubscript(df.bot_bc_type[1], false)
        vscpt = [vscptTOP, vscptBOT]
        vscpt = filter!(x -> !isnothing(x), vscpt)
        eqinv = EquilibriumInvariant(summed_species)

        p = 0
        for k in eqinv.diss_const
            p += 1
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

            for j = 1:length(eqinv.species)

                expr = replace(eqinv.expr[j], r"\bH\b" => "$H_tmp")
                if summed_species != "H"
                    expr = replace(expr, Regex("\\b$(summed_species)\\b") => "$Summed_tmp")
                end
                for (key, value) in Ks
                    expr = replace(expr, Regex("\\b$key\\b") => "$value")
                end
                res = eval(Meta.parse(expr))
                push!(
                    bcParam,
                    [
                        "const",
                        eqinv.species[j] * i,
                        @sprintf("%.16E", res,),
                        "mmol cm^-3",
                        comment(i, eqinv.species[j]),
                    ],
                )
            end
        end
    end

    bcParam = @subset(param_model, :class .== "BoundaryCondition")
    RmCol!(bcParam)
    @subset!(bcParam, :parameter .!= "delta")

    dissolved_summed_all =
        @subset(substances, :type .∈ Ref(["dissolved_pH"]))

    for m in dissolved_summed_all.substance
        pH_param(substances, bcParam, KpHParam, m, Ks)
    end


    # for i in eachrow(dissolved_adsorbed)
    #     vscptTOP = varsubscript(i.top_bc_type, true)
    #     vscptBOT = varsubscript(i.bot_bc_type, false)
    #     vscpt = [vscptTOP, vscptBOT]
    #     vscpt = filter!(x -> !isnothing(x), vscpt)
    #     for j in vscpt
    #         push!(
    #             bcParam,
    #             [
    #                 "const",
    #                 i.species_name * j,
    #                 "K$(i.species_name) * $(i.substance)$j",
    #                 "mmol cm^-3",
    #                 comment(j, "adsorbed $(i.substance)"),
    #             ],
    #             promote = true,
    #         )
    #     end
    # end



    function setTopBC(substance, type, bc_type)
        vecid = "[1]"
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
        vecid = "[Ngrid]"
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

    
    adsorbed_species = select(adsorption,:substance,:surface,:top_bc_type,:bot_bc_type)
    # @transform!(adsorbed_species,:substance=ifelse.(ismissing.(:surface),:substance.*"_ads_nsf",:substance.*"_ads_".*:surface))
    @transform!(adsorbed_species,:substance=:substance.*"_ads")
    @transform!(adsorbed_species,
                :type ="solid",
                :formula="",
                :species_name=:substance)
    unique!(adsorbed_species)

    

    substances_bc = @subset(substances, :type .== "solid")
    @transform!(substances_bc,:species_name=:substance)
    select!(substances_bc,:substance,:species_name,:type,:top_bc_type,:bot_bc_type)
    append!(substances_bc, select!(dissolved_all,names(substances_bc)))
    # append!(substances_bc, select!(dissolved_adsorbed,names(substances_bc)))
    append!(substances_bc, select!(adsorbed_species,names(substances_bc)))
    unique!(substances_bc)


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
                    # "BcAm$(i.species_name), BcBm$(i.species_name), BcCm$(i.species_name)",
                    "BcAm$(i.species_name), BcCm$(i.species_name)",
                    "fvcf_bc(phis,Ds,us,dx,Bc$(i.species_name),Ngrid)",
                    "",
                    "Boundary transport matrix of $(i.species_name)",
                ],
            )
            push!(
                tranIntParam,
                [
                    "const",
                    # "Am$(i.species_name), Bm$(i.species_name)",
                    "Am$(i.species_name)",
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
                    # "BcAm$(i.species_name), BcBm$(i.species_name), BcCm$(i.species_name)",
                    "BcAm$(i.species_name), BcCm$(i.species_name)",
                    "fvcf_bc(phif,D$(i.species_name),uf,dx,Bc$(i.species_name),Ngrid)",
                    "",
                    "Boundary transport matrix of $(i.species_name)",
                ],
            )
            push!(
                tranIntParam,
                [
                    "const",
                    # "Am$(i.species_name), Bm$(i.species_name)",
                    "Am$(i.species_name)",
                    "fvcf(phif,D$(i.species_name),uf,dx,Ngrid)",
                    "",
                    "Interior transport matrix of $(i.species_name)",
                ],
            )
        end
    end


    # if any(substances.type .== "dissolved_speciation")
    #     for i in eachrow(adsorption)
    #         BC_str_Top = setTopBC(i.adsorbed, "solid", i.top_bc_type)
    #         BC_str_Bot = setBotBC(i.adsorbed, "solid", i.bot_bc_type)
    #         push!(
    #             bdParam,
    #             [
    #                 "const",
    #                 "Bc" * i.adsorbed,
    #                 "($BC_str_Top, $BC_str_Bot)",
    #                 "",
    #                 "Boundary condition of $(i.adsorbed)",
    #             ],
    #         )
    #         push!(
    #             tranBCParam,
    #             [
    #                 "const",
    #                 "BcAm$(i.adsorbed), BcBm$(i.adsorbed), BcCm$(i.adsorbed)",
    #                 "fvcf_bc(phis,Ds,us,dx,Bc$(i.adsorbed),Ngrid)",
    #                 "",
    #                 "Boundary transport matrix of $(i.adsorbed)",
    #             ],
    #         )
    #         push!(
    #             tranIntParam,
    #             [
    #                 "const",
    #                 "Am$(i.adsorbed), Bm$(i.adsorbed)",
    #                 "fvcf(phis,Ds,us,dx,Ngrid)",
    #                 "",
    #                 "Interior transport matrix of $(i.adsorbed)",
    #             ],
    #         )

    #     end
    # end

    reactionParam = @subset(param_model, :class .== "Reaction")
    RmCol!(reactionParam)

    codeParam = @subset(param_model, :class .== "Code")

    param_str = String[]

    appendtostr!(param_str, NspeciesParam, "Number of substances", assemble)
    appendtostr!(param_str, globalParam, "global parameters", assemble)
    appendtostr!(param_str, gridParam, "grid parameters", assemble)
    appendtostr!(param_str, porosityParam, "porosity parameters", assemble)
    appendtostr!(param_str, burialParam, "phase velocity parameters", assemble)
    appendtostr!(param_str, bioturbationParam, "bioturbation parameters", assemble)
    appendtostr!(param_str, bioirrigationParam, "bioirrigation parameters", assemble)
    appendtostr!(param_str, adsParam, "speciation parameters", assemble)
    appendtostr!(param_str, diffusionParam, "solute diffusivity", assemble)
    appendtostr!(param_str, betaParam, "solute mass transfer velocities", assemble)
    appendtostr!(param_str, bcParam, "boundary fluxes and concentrations", assemble)
    appendtostr!(param_str, bdParam, "assemble boundary conditions", assemble)
    appendtostr!(param_str, tranBCParam, "Boundary transport matrix", assemble)
    appendtostr!(param_str, tranIntParam, "Interior transport matrix", assemble)
    if nsummed != 0
        appendtostr!(param_str, KpHParam, "Acid dissociation constants", assemble)
    end
    appendtostr!(param_str, reactionParam, "Reaction parameters", assemble)
    # if isempty(codeParam)
        appendtostr!(param_str, codeParam, "User code parameters", assemble,false)
    # end


    initialvec = String[]
    vecid = "[1]"

    sort!(substances,:order)
    for i in eachrow(substances)
        if i.type == "solid"
            if i.top_bc_type == "robin"
                ini = "F$(i.substance)0/(phis$vecid*us$vecid)"
            elseif i.top_bc_type == "dirichlet"
                ini = "$(i.substance)0"
            end
        elseif i.type ∈ [
            "dissolved",
            # "dissolved_adsorbed",
            "dissolved_pH",
        ]
            if i.top_bc_type == "robin"
                ini = "$(i.substance)BW"
            elseif i.top_bc_type == "dirichlet"
                ini = "$(i.substance)0"
            end
        elseif i.type == "dissolved_speciation"
            # dissolved_sp =
            #     getval!(dissolved_speciation, :substance, i.substance, :species)
            # ini = "$(i.substance)_dis0"
            if i.top_bc_type == "robin"
                ini = "$(i.substance)_disBW"
            elseif i.top_bc_type == "dirichlet"
                ini = "$(i.substance)_dis0"
            end

        end

        push!(initialvec, ini)
    end


    initialParam = newdf()
    push!(
        initialParam,
        ["const", "C_ini", "[$(join(initialvec,","))]", "", "initial conditions"],
    )

    appendtostr!(param_str, initialParam, "Inital values", assemble)

    initval_code!(substances, param_str,assemble)

    return param_str
end
