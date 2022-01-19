function generate_substance_plot(modelconfig, solution,site,vars=[];EnableList=Dict(), saveplt=false,dpi=300)
    input_path = modelconfig.ModelDirectory * modelconfig.ModelFile
    model_config = XLSX.readxlsx(input_path)
    
    substances = DataFrame(XLSX.gettable(model_config["substances"])...)
    reactions = DataFrame(XLSX.gettable(model_config["reactions"])...)
    adsorption = DataFrame(XLSX.gettable(model_config["adsorption"])...)
    plotting = DataFrame(XLSX.gettable(model_config["output"])...)
    
    if !isempty(EnableList)
        if haskey(EnableList,"substances")
            for i in EnableList["substances"]
                if !in(i,substances.substance)
                    throw(error("$i is not a substance!"))
                else
                    setval!(substances, :substance, i, :include, 1)
                end
            end
        end
        if haskey(EnableList,"reactions")
            for i in EnableList["reactions"]
                if !in(i,reactions.label)
                    throw(error("$i is not a reaction!"))
                else
                    setval!(reactions, :label, i, :include, 1)
                end
            end
        end
        if haskey(EnableList,"output")
            for i in EnableList["output"]
                if !in(i,plotting.name)
                    throw(error("$i is not in the output!"))
                else
                    setval!(plotting, :name, i, :include, 1)
                end
            end
        end
    end

    # remove empty space or weird minus signs
    SedTrace.df_str_replace!(substances, [r"\s", r"[\u2212\u2014\u2013]"], ["", "\u002D"])
    SedTrace.df_str_replace!(adsorption, [r"\s", r"[\u2212\u2014\u2013]"], ["", "\u002D"])
    SedTrace.df_str_replace!(reactions, [r"\s", r"[\u2212\u2014\u2013]"], ["", "\u002D"])
    SedTrace.df_str_replace!(plotting, [r"\s", r"[\u2212\u2014\u2013]"], ["", "\u002D"])


    subset!(substances,:include => ByRow(!ismissing))
    subset!(reactions,:include => ByRow(!ismissing)) 
    subset!(adsorption,:include => ByRow(!ismissing))
    subset!(plotting,:include => ByRow(!ismissing))

    leftjoin!(plotting,select(substances, :substance, :type), on = [:name => :substance])


    if !isempty(vars)
        plotting = @subset(plotting,:name .∈ Ref(vars))
    end

    data = @chain begin
        DataFrame(XLSX.gettable(model_config["data"])...)
        @subset(:site .∈ Ref(site))
        sort!([:substance, :depth])
    end

    nt = length(solution.sol.t)
    ModelledProfile = SedTrace.get_all_vars(substances, solution)
    ModelledFlux = SedTrace.get_all_flux_top(substances, adsorption, ModelledProfile,nt)

    summedspecies = @subset(substances, :type .== "dissolved_summed_pH").substance

    OutputProfile, OutputFlux = SedTrace.get_required_vars(
        substances,
        plotting,
        ModelledProfile,
        ModelledFlux,
        nt,
        solution.Ngrid,
        summedspecies,
    )

    output = OrderedDict(
        plotting.name .=> [
            (
                profile = OutputProfile[i.name],
                unit_profile = i.unit_profile,
                flux_top = haskey(OutputFlux, i.name) ? OutputFlux[i.name] : nothing,
                flux_top_measured = i.flux_top_measured,
                unit_flux = haskey(OutputFlux, i.name) ? i.unit_flux : nothing,
            ) for i in eachrow(plotting)
        ],
    )

    all_vars = collect(keys(ModelledProfile))

    df_substance = DataFrame(vcat([solution.x],[ModelledProfile[i][end,:] for i in substances.substance]),vcat(:depth,Symbol.(substances.substance)))

    df_reacrate = DataFrame(vcat([solution.x],[ModelledProfile[i][end,:] for i in reactions.label]),vcat(:depth,Symbol.(reactions.label)))

    omega_vars = filter(x->occursin(r"\bOmega_",x)==1,all_vars)

    df_omega = DataFrame(vcat([solution.x],[ModelledProfile[i][end,:] for i in omega_vars]),vcat(:depth,Symbol.(omega_vars)))


    species_vars = filter(x-> !in(x,substances.substance)&& !in(x,reactions.label) && !in(x,omega_vars) && !occursin(r"_tran/b",x) && !occursin(r"\bS_",x),all_vars)

    df_species = DataFrame(vcat([solution.x],[ModelledProfile[i][end,:] for i in species_vars]),vcat(:depth,Symbol.(species_vars)))

    XLSX.writetable(
        modelconfig.ModelDirectory*modelconfig.ModelName*"_output.xlsx",
        overwrite = true,
        substances = (
            collect(DataFrames.eachcol(df_substance)),
            DataFrames.names(df_substance),
        ),
        reacrates = (
            collect(DataFrames.eachcol(df_reacrate)),
            DataFrames.names(df_reacrate),
        ),
        omega = (
            collect(DataFrames.eachcol(df_omega)),
            DataFrames.names(df_omega),
        ),
        species = (
            collect(DataFrames.eachcol(df_species)),
            DataFrames.names(df_species),
        ),

    )


    for (key, value) in output
        data_select = @subset(data, :substance .== key)

        if size(data_select, 1) != 0
            if value.unit_profile != data_select.unit[1]
                throw(
                    error(
                        "Unit of $(value.unit_profile) MUST be the same in plotting and data!",
                    ),
                )
            else
                pwdata = select(data_select, :depth, :value, :error, :site)
                sort!(pwdata, :depth)
            end
        else
            pwdata = nothing
        end

        if !isnothing(value.flux_top)
            flux_top_message = "$(round(value.flux_top[end],sigdigits=2))  vs. $(value.flux_top_measured) \n $(value.unit_flux)"
        else
            flux_top_message = nothing
        end



        p = SedTrace.secplot(
            site,
            solution.sol.t,
            solution.x,
            value.profile',
            value.flux_top,
            :roma,
            "$key $(value.unit_profile)",
            (0.0, solution.L),
            pwdata,
            flux_top_message,
            :identity,
        )

        # display(Main.VSCodeServer.InlineDisplay(), "image/svg+xml", p)
        display(p)
        if saveplt
            savefig(p, modelconfig.ModelDirectory * "$key.pdf")
        end

    end
end

function generate_aux_plot(modelconfig, solution,site,vars=[], saveplt=false)
    input_path = modelconfig.ModelDirectory * modelconfig.ModelFile
    model_config = XLSX.readxlsx(input_path)
    substances = @chain begin
        DataFrame(XLSX.gettable(model_config["substances"])...)
        @subset(:include .== 1)
    end

    adsorption = @chain begin
        DataFrame(XLSX.gettable(model_config["adsorption"])...)
        @subset(:include .== 1)
    end

    # remove empty space or weird minus signs
    SedTrace.df_str_replace!(substances, [r"\s", r"[\u2212\u2014\u2013]"], ["", "\u002D"])
    SedTrace.df_str_replace!(adsorption, [r"\s", r"[\u2212\u2014\u2013]"], ["", "\u002D"])

    plotting = @chain begin
        DataFrame(XLSX.gettable(model_config["output"])...)
        @subset(:include .== 1)
        leftjoin(select(substances, :substance, :type), on = [:name => :substance])
    end

    SedTrace.df_str_replace!(plotting, [r"\s", r"[\u2212\u2014\u2013]"], ["", "\u002D"])

    if !isempty(vars)
        plotting = @subset(plotting,:name .∈ Ref(vars))
    end

    data = @chain begin
        DataFrame(XLSX.gettable(model_config["data"])...)
        @subset(:site .∈ Ref(site))
        sort!([:substance, :depth])
    end

    nt = length(solution.sol.t)
    ModelledProfile = get_all_vars(substances, solution)

    if !isempty(vars)
        Selectvar = filter(k->k.first in vars,ModelledProfile)
    end

    for (key,value) in Selectvar
        p = secplot(
            nothing,
            solution.sol.t,
            solution.x,
            value',
            nothing,
            :roma,
            key,
            solution.L,
            nothing,
            nothing,
            :identity,
        )
        # display(Main.VSCodeServer.InlineDisplay(), "image/svg+xml", p)
        display(p)               
        if saveplt
            savefig(p, modelconfig.ModelDirectory * "$key.pdf")
        end
    end

end

# get the profiles of all modelled substances and species
function get_all_vars(substances, solution::SolutionConfig)

    nt = length(solution.sol.t)


    OutputDict = Dict(
        i.substance => [solution.sol.u[j][m] for j = 1:nt, m in solution.IDdict[i.substance]] for
        i in eachrow(substances)
    )


    # VarName = fieldnames(typeof(OdeFun))
    # nVar = length(VarName)

    # VarVal = Dict(string(i) => Matrix{Float64}(undef, nt, solution.Ngrid) for i in VarName)

    # dC0 = similar(ones(size(solution.sol, 1)))

    # solution_tmp = deepcopy(solution.sol)
    # for i = 1:nt
    #     Base.invokelatest(OdeFun,dC0, solution_tmp[i], nothing, 0)
    #     for j in VarName
    #         VarVal[string(j)][i, :] = getfield(OdeFun, j).du
    #     end
    # end

    return merge!(OutputDict, solution.VarVal)
end

# get the benthic fluxes of all modelled substances and species
function get_all_flux_top(substances, adsorption, OutputDict,nt)

    flux_top_raw_expr = [] # species to calculate flux at top
    flux_top_raw_name = [] # species to calculate flux at top

    for i in eachrow(substances)
        if i.type == "solid"
            push!(
                flux_top_raw_expr,
                "($(i.substance)) ->
                calc_flux_top(phis[1],Ds[1],us[1],x[1:3],$(i.substance),Bc$(i.substance)[1])",
            )
            push!(flux_top_raw_name, i.substance)
        elseif i.type in ["dissolved", "dissolved_summed", "dissolved_adsorbed"]
            push!(
                flux_top_raw_expr,
                "($(i.substance)) ->
                calc_flux_top(phif[1],D$(i.substance)[1],uf[1],x[1:3],$(i.substance),Bc$(i.substance)[1])",
            )
            push!(flux_top_raw_name, i.substance)
        elseif i.type == "dissolved_summed_pH"
            EqInv = SedTrace.EquilibriumInvariant(i.substance)
            append!(flux_top_raw_name, EqInv.species)
            append!(
                flux_top_raw_expr,
                "(" .* EqInv.species .* ")->
                  calc_flux_top(phif[1],D" .* EqInv.species .* "[1],uf[1],x[1:3]," .*
                EqInv.species .* ",Bc" .* EqInv.species .* "[1])",
            )
        elseif i.type == "dissolved_adsorbed_summed"
            ads_df = @subset(adsorption, :substance .== i.substance)
            for j in eachrow(ads_df)
                push!(flux_top_raw_name, j.species)
                if j.surface == "dissolved"
                    push!(
                        flux_top_raw_expr,
                        "($(j.species)) ->
                        calc_flux_top(phif[1],D$(j.species)[1],uf[1],x[1:3],$(j.species),Bc$(j.species)[1])",
                    )
                else
                    push!(
                        flux_top_raw_expr,
                        "($(j.species)) ->
                        calc_flux_top(phis[1],Ds[1],us[1],x[1:3],$(j.species),Bc$(j.species)[1])",
                    )
                end
            end
        end
    end

    function_flux_top_raw = eval.(Meta.parse.(flux_top_raw_expr))

    SpecFluxTop = Dict(i => Vector{Float64}(undef, nt) for i in flux_top_raw_name)

    for i = 1:length(flux_top_raw_name)
        for j = 1:nt
            SpecFluxTop[flux_top_raw_name[i]][j] = Base.invokelatest(
                function_flux_top_raw[i],
                OutputDict[flux_top_raw_name[i]][j, :],
            )
        end
    end

    for i in eachrow(substances)
        if i.type == "dissolved_summed_pH"
            EqInv = SedTrace.EquilibriumInvariant(i.substance)
            nsub = length(EqInv.species)
            fun_expr = eval(Meta.parse("("*join("x".*string.(collect(1:nsub)),",")*")->"*join("x".*string.(collect(1:nsub)),"+")))
            input = Tuple(SpecFluxTop[j] for j in EqInv.species)
            SpecFluxTop[i.substance] = Base.invokelatest(fun_expr,input...)
        elseif i.type == "dissolved_adsorbed_summed"
            ads_df = @subset(adsorption, :substance .== i.substance)
            nsub = length(ads_df.species)
            fun_expr = eval(Meta.parse("("*join("x".*string.(collect(1:nsub)),",")*")->"*join("x".*string.(collect(1:nsub)),"+")))
            input = Tuple(SpecFluxTop[j] for j in ads_df.species)
            SpecFluxTop[i.substance] = Base.invokelatest(fun_expr,input...)
        end
    end

    return SpecFluxTop
end

# compute the output profiles and fluxes using modelled profiles and fluxes
function compute_output_vars(OutputDict, var_df, summed_species)
    if var_df.name == "TA"
        args_name = String[]
        TA_expr = String[]
        for i in summed_species
            tmp = EquilibriumInvariant(i)
            append!(args_name, tmp.species)
            append!(TA_expr, tmp.coef .* "*" .* tmp.species)
        end
        fun_expr = eval(Meta.parse("(" * join(args_name, ",") * ")->" * join(TA_expr, "+")))
        args = Tuple(OutputDict[k] for k in args_name)
        return Base.invokelatest.(fun_expr, args...)
    elseif !ismissing(var_df.expression)
        args_name = SedTrace.myeachmatch(r"\b[a-zA-Z]\w*\b(?!\()", var_df.expression)
        args_name = intersect(args_name, keys(OutputDict))
        fun_expr = eval(Meta.parse("(" * join(args_name, ",") * ")->" * var_df.expression))
        args = Tuple(OutputDict[k] for k in args_name)
        return Base.invokelatest.(fun_expr, args...)
    else
        return OutputDict[var_df.name]
    end
end

# compute the output profiles and fluxes using modelled profiles and fluxes
function get_required_vars(
    substances,
    plotting,
    OutputDict::Dict,
    SpecFluxTop::Dict,
    nt,
    Ngrid,
    summed_species,
)
    plotvarval =
        Dict(i.name => Matrix{Float64}(undef, nt, Ngrid) for i in eachrow(plotting))

    for i in eachrow(plotting)
        plotvarval[i.name] .=
            SedTrace.compute_output_vars(OutputDict, i, summed_species) .*
            eval(Meta.parse(i.conversion_profile))
    end

    plottingFlux = @subset(plotting, .!ismissing.(:flux_top))
    plotvarflux = Dict(i.name => Vector{Float64}(undef, nt) for i in eachrow(plottingFlux))

    for i in eachrow(plottingFlux)
        plotvarflux[i.name] .=
            compute_output_vars(SpecFluxTop, i, summed_species) .*
            eval(Meta.parse(i.conversion_flux))
    end

    return plotvarval, plotvarflux
end

# computing benthic flux
function calc_flux_top(φ, D, u, x, C, BC)
    α⁰, β⁰, γ⁰ = BC
    x1, x2, x3 = x
    c1, c2, c3 = C[1:3]
    c0 = c3 * (x1^3 * x2^2 * β⁰ - x1^2 * x2^3 * β⁰)
    c0 += c2 * (-x1^3 * x3^2 * β⁰ + x1^2 * x3^3 * β⁰)
    c0 += c1 * (x2^3 * x3^2 * β⁰ - x2^2 * x3^3 * β⁰)
    c0 +=
        (
            -x1^3 * x2^2 * x3 + x1^2 * x2^3 * x3 + x1^3 * x2 * x3^2 - x1 * x2^3 * x3^2 -
            x1^2 * x2 * x3^3 + x1 * x2^2 * x3^3
        ) * γ⁰
    c0 /=
        (x1 - x2) *
        (x2 - x3) *
        (-x1 + x3) *
        (x1 * x2 * x3 * α⁰ - x1 * x2 * β⁰ - x1 * x3 * β⁰ - x2 * x3 * β⁰)

    dCdz0 = c3 * (x1^3 * x2^2 * α⁰ - x1^2 * x2^3 * α⁰)
    dCdz0 += c2 * (-x1^3 * x3^2 * α⁰ + x1^2 * x3^3 * α⁰)
    dCdz0 += c1 * (x2^3 * x3^2 * α⁰ - x2^2 * x3^3 * α⁰)
    dCdz0 +=
        (
            -x1^3 * x2^2 + x1^2 * x2^3 + x1^3 * x3^2 - x2^3 * x3^2 - x1^2 * x3^3 +
            x2^2 * x3^3
        ) * γ⁰
    dCdz0 /=
        (x1 - x2) *
        (x2 - x3) *
        (x1 - x3) *
        (x1 * x2 * x3 * α⁰ - x1 * x2 * β⁰ - x1 * x3 * β⁰ - x2 * x3 * β⁰)

    return φ * D * dCdz0 - φ * u * c0
end



# plot
function secplot(
    site,
    t,
    seddepth,
    var,
    var_flux_top,
    cmap,
    label,
    y_lim,
    pwdata,
    flux_top_message,
    yscale,
)
    clims = range(minimum(var), stop = maximum(var), length = 100)

    if isnothing(var_flux_top)
        p0 = plot(legend = false, grid = false, foreground_color_subplot = :white)
    else
        p0 = plot(
            t,
            var_flux_top,
            linecolor = "red",
            xlabel = "Time (yr)",
            ylabel = "Benthic flux",
            title = flux_top_message,
            formatter=:plain,
            legend = :none
        )
    end
    p1 = contour(
        t/1e3,
        seddepth,
        var,
        levels = 10,
        fill = true,
        yflip = true,
        # linecolor = "black",
        fillcolor = cmap,
        ylims = y_lim,
        xlabel = "Time (kyr)",
        ylabel = "Depth (cm)",
        title = label,
        yscale = yscale,
        formatter=:plain,
        legend = :none
    )
    p2 = plot(
        var[:, 1],
        seddepth,
        linecolor = "black",
        yflip = true,
        ylims = y_lim,
        label = "initial",
        ylabel = "Depth (cm)",
        title = label,
        yscale = yscale,
        legend = :none,
        formatter=:plain
    )
    plot!(
        p2,
        var[:, end],
        seddepth,
        linecolor = "red",
        yflip = true,
        ylims = y_lim,
        label = "model",
        ylabel = "Depth (cm)",
        title = label,
        yscale = yscale,
        formatter=:plain,
        legend = :none,
    )
    if !isnothing(pwdata)
        if any(ismissing.(pwdata.error))
            @df pwdata plot!(
                p2,
                :value,
                :depth,
                seriestype = :path,
                group = :site,
                linestyle = :solid,
                markershape = :utriangle,
                yflip = true,
                ylims = y_lim,
                yscale = yscale,
                markersize = 2,
                orientation = :vertical,
                formatter=:plain,
                legend = :none,
            )
        else
            @df pwdata plot!(
                p2,
                :value,
                :depth,
                xerror = (:error, :error),
                seriestype = :path,
                group = :site,
                linestyle = :solid,
                markershape = :utriangle,
                yflip = true,
                ylims = y_lim,
                yscale = yscale,
                markersize = 2,
                markerstrokewidth = 0.5,
                markerstrokecolor = "blue",
                orientation = :vertical,
                formatter=:plain,
                legend = :none,
            )
        end
    end

    # if !isnothing(flux_top_message)
    #     annotate!(p0,(0.0,-y_lim[2]*0.002),text(flux_top_message,:red,:left,8))
    # end
    p = plot(
        p1,
        p2,
        p0,
        layout = grid(3, 1, heights = [0.45, 0.45, 0.1]),
        # guidefontsize = 16,
        # colorbar_tickfontsize = 16,
        # colorbar_titlefontsize = 16,
        # legendfontsize = 16,
        # legendtitlefontsize = 16,
        # titlefontsize = 16,
        # tickfontsize = 16,
        # left_margin  = 15mm,
        # right_margin = 15mm,
        margin  = 15mm,
        background_color_legend = nothing,
        foreground_color_legend = nothing,
    )
end