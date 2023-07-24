function generate_output(modelconfig, solution;site=nothing,vars=[],EnableList=Dict(),showplt=true, saveplt=false,pltsize=nothing,ylim=nothing)
    

    if modelconfig.AssembleParam
        include("$(modelconfig.ModelDirectory)parm.$(modelconfig.ModelName).jl")
    end
    
    ylim === nothing ? ylim=(minimum(x),maximum(x)) : ylim


    input_path = modelconfig.ModelDirectory * modelconfig.ModelFile
    model_config = XLSX.readxlsx(input_path)

    
    substances = DataFrame(XLSX.gettable(model_config["substances"]))
    reactions = DataFrame(XLSX.gettable(model_config["reactions"]))
    adsorption = DataFrame(XLSX.gettable(model_config["adsorption"]))
    speciation = DataFrame(XLSX.gettable(model_config["speciation"]))
    plotting = DataFrame(XLSX.gettable(model_config["output"]))

    preprocessSubstances!(substances,EnableList)
    preprocessReactions!(reactions,EnableList)
    preprocessSpeciation!(speciation,substances,EnableList)
    preprocessAdsorption!(adsorption,substances,speciation,EnableList)
    preprocessOutput!(plotting,EnableList)


    leftjoin!(plotting,select(substances, :substance, :type), on = [:name => :substance])

    _,_,_,speciation_df = speciation_code(substances,speciation,adsorption)
    @transform!(speciation_df,:code = true)

    for i in eachrow(speciation_df)
        if i.type == "dissolved" && in(i.name,speciation.dissolved[ismissing.(speciation.code)])
            i.code = false
        end
    end
    @subset!(speciation_df,:code)

    # if !isempty(vars)
    #     plotting = @subset(plotting,:name .∈ Ref(vars))
    # end

    data = @chain begin
        DataFrame(XLSX.gettable(model_config["data"]))
        @subset(:site .∈ Ref(site))
        sort!([:substance, :depth])
        @subset(:depth .<= L)
    end

    nt = length(solution.sol.t)
    ModelledProfile = get_all_vars(substances, solution)
    ModelledFlux,pH_species,EI_names = get_all_flux_top(substances, speciation_df, ModelledProfile,nt)

    summedspecies = @subset(substances, :type .== "dissolved_pH").substance

    OutputProfile, OutputFlux = get_required_vars(
        substances,
        plotting,
        ModelledProfile,
        ModelledFlux,
        nt,
        Ngrid,
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

    df_substance = DataFrame(vcat([x],[ModelledProfile[i][end,:] for i in substances.substance]),vcat(:depth,Symbol.(substances.substance)))

    df_reacrate = DataFrame(vcat([x],[ModelledProfile[i][end,:] for i in reactions.label]),vcat(:depth,Symbol.(reactions.label)))

    omega_vars = filter(x->occursin(r"\bOmega_",x)==1,all_vars)

    df_omega = DataFrame(vcat([x],[ModelledProfile[i][end,:] for i in omega_vars]),vcat(:depth,Symbol.(omega_vars)))

    species_vars = speciation_df.name
    df_species = DataFrame(vcat([x],[ModelledProfile[i][end,:] for i in species_vars]),vcat(:depth,Symbol.(species_vars)))

    pH_vars = vcat(filter(x -> in(x,pH_species),all_vars),"dTA_d".*EI_names)
    df_pH_species = DataFrame(vcat([x],[ModelledProfile[i][end,:] for i in pH_vars]),vcat(:depth,Symbol.(pH_vars)))

    int_vars = filter(x-> !in(x,vcat(substances.substance,reactions.label,omega_vars,species_vars,pH_vars)) ,all_vars)
    df_int_vars = DataFrame(vcat([x],[ModelledProfile[i][end,:] for i in int_vars]),vcat(:depth,Symbol.(int_vars)))


    df_output_profile = DataFrame(vcat([x],[OutputProfile[i][end,:] for i in plotting.name]),vcat(:depth,Symbol.(plotting.name)))
    
    
    df_output_flux = DataFrame(name=collect(keys(OutputFlux)),flux=[OutputFlux[i][end] for i in keys(OutputFlux)])
    

    XLSX.writetable(
        modelconfig.ModelDirectory*"model_output."*modelconfig.ModelName*".xlsx",
        overwrite = true,
        Substances = (
            collect(DataFrames.eachcol(df_substance)),
            DataFrames.names(df_substance),
        ),
        ReacRates = (
            collect(DataFrames.eachcol(df_reacrate)),
            DataFrames.names(df_reacrate),
        ),
        Omega = (
            collect(DataFrames.eachcol(df_omega)),
            DataFrames.names(df_omega),
        ),
        pHspecies = (
            collect(DataFrames.eachcol(df_pH_species)),
            DataFrames.names(df_pH_species),
        ),
        Speciation = (
            collect(DataFrames.eachcol(df_species)),
            DataFrames.names(df_species),
        ),
        IntermediateVar = (
            collect(DataFrames.eachcol(df_int_vars)),
            DataFrames.names(df_int_vars),
        ),
        OutputProfile = (
            collect(DataFrames.eachcol(df_output_profile)),
            DataFrames.names(df_output_profile),
        ),
        OutputFlux = (
            collect(DataFrames.eachcol(df_output_flux)),
            DataFrames.names(df_output_flux),
        ),
    )

    select_var = isempty(vars) ? plotting.name : vars
    for (key, value) in output
        if in(key,select_var)
        data_select = @subset(data, :substance .== key)
        @subset!(data_select,(:depth.>=ylim[1]) .& (:depth.<=ylim[2]))

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
                # @subset!(pwdata,:depth .<= solution.L)
            end
        else
            pwdata = nothing
        end

        if !isnothing(value.flux_top)
            flux_top_message = "$(round(value.flux_top[end],sigdigits=2))  vs. $(value.flux_top_measured) \n $(value.unit_flux)"
        else
            flux_top_message = nothing
        end



        p = secplot(
            site,
            solution.sol.t,
            x,
            value.profile',
            value.flux_top,
            :roma,
            "$key $(value.unit_profile)",
            ylim,
            pwdata,
            flux_top_message,
            :identity,
        )

        # display(Main.VSCodeServer.InlineDisplay(), "image/svg+xml", p)
        if showplt
            display(p)
        end
        if saveplt
            # gr()
            # p = plot(p,size=pltsize)
            mkpath("$(modelconfig.ModelDirectory)/plots/")
            savefig(p, "$(modelconfig.ModelDirectory)/plots/$key.pdf")
        end

    end
end
# return output
end


# get the profiles of all modelled substances and species
function get_all_vars(substances, solution::OutputConfig)

    nt = length(solution.sol.t)

    OutputDict = Dict(
        i.substance => [solution.sol.u[j][m] for j = 1:nt, m in IDdict[Symbol(i.substance*"ID")]] for
        i in eachrow(substances)
    )

    return merge!(OutputDict, solution.IntVal)
end


# get the benthic fluxes of all modelled substances and species
function get_all_flux_top(substances, speciation_df, OutputDict,nt)

    flux_top_raw_expr = [] # species to calculate flux at top
    flux_top_raw_name = [] # species to calculate flux at top
    pH_species = String[]
    EI_names = String[]

    for i in eachrow(substances)
        if i.type == "solid"
            push!(
                flux_top_raw_expr,
                "($(i.substance)) ->
                calc_flux_top(phis[1],dx[1],$(i.substance),BcAm$(i.substance)[1],BcCm$(i.substance)[1])",
            )
            push!(flux_top_raw_name, i.substance)
        elseif i.type in ["dissolved"]
            push!(
                flux_top_raw_expr,
                "($(i.substance)) ->
                calc_flux_top(phif[1],dx[1],$(i.substance),BcAm$(i.substance)[1],BcCm$(i.substance)[1])",
            )
            push!(flux_top_raw_name, i.substance)
        elseif i.type == "dissolved_pH"
            EqInv = EquilibriumInvariant(i.substance)
            append!(pH_species, EqInv.species)
            push!(EI_names, EqInv.name)
            append!(flux_top_raw_name, EqInv.species)
            append!(
                flux_top_raw_expr,
                "(" .* EqInv.species .* ")->
                calc_flux_top(phif[1],dx[1]," .*
                EqInv.species .* ",BcAm" .* EqInv.species .* "[1],BcCm" .* EqInv.species .* "[1])",
            )
        elseif i.type == "dissolved_speciation"
            spec_df = @subset(speciation_df,:substance .== i.substance)
            dis_sp = @subset(spec_df,:comment .=="Total dissolved")
            ads_sp = @subset(spec_df,:comment .=="Total adsorbed")

            if !isempty(dis_sp)
            push!(flux_top_raw_name, dis_sp.name[1])
            push!(
                flux_top_raw_expr,
                "($(dis_sp.name[1])) ->
                calc_flux_top(phif[1],dx[1],$(dis_sp.name[1]),BcAm$(dis_sp.name[1])[1],BcCm$(dis_sp.name[1])[1])",
            )
            end

            if !isempty(ads_sp)
            for i in ads_sp.name
                push!(flux_top_raw_name, i)
                push!(
                        flux_top_raw_expr,
                        "($(i)) ->
                        calc_flux_top(phis[1],dx[1],$(i),BcAm$(i)[1],BcCm$(i)[1])",

                )
            end
        end

        end
    end

    function_flux_top_raw = eval.(Meta.parse.(flux_top_raw_expr))

    SpecFluxTop = Dict(i => Vector{Float64}(undef, nt) for i in flux_top_raw_name)

    for i = 1 : length(flux_top_raw_name)
        for j = 1:nt
            SpecFluxTop[flux_top_raw_name[i]][j] = Base.invokelatest(
                function_flux_top_raw[i],
                OutputDict[flux_top_raw_name[i]][j, :],
            )
        end
    end

    for i in eachrow(substances)
        if i.type == "dissolved_pH"
            EqInv = EquilibriumInvariant(i.substance)
            nsub = length(EqInv.species)
            fun_expr = eval(Meta.parse("("*join("x".*string.(collect(1:nsub)),",")*")->"*join("x".*string.(collect(1:nsub)),"+")))
            input = Tuple(SpecFluxTop[j] for j in EqInv.species)
            SpecFluxTop[i.substance] = Base.invokelatest(fun_expr,input...)
        elseif i.type == "dissolved_speciation"
            # ads_df = @subset(adsorption, :substance .== i.substance)
            # nsub = length(ads_df.species)
            # fun_expr = eval(Meta.parse("("*join("x".*string.(collect(1:nsub)),",")*")->"*join("x".*string.(collect(1:nsub)),"+")))
            # input = Tuple(SpecFluxTop[j] for j in ads_df.species)
            # SpecFluxTop[i.substance] = Base.invokelatest(fun_expr,input...)
            # spec = vcat(ads_df.adsorbed,ads_df.dissolved[1])
            spec_df = @subset(speciation_df,:substance .== i.substance)
            @subset!(spec_df,in.(:comment,Ref(["Total dissolved","Total adsorbed"])))
            spec = spec_df.name
            nsub = length(spec) 
            fun_expr = eval(Meta.parse("("*join("x".*string.(collect(1:nsub)),",")*")->"*join("x".*string.(collect(1:nsub)),"+")))
            input = Tuple(SpecFluxTop[j] for j in spec)
            SpecFluxTop[i.substance] = Base.invokelatest(fun_expr,input...)
       end
    end

    return (SpecFluxTop,pH_species,EI_names)
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
        args_name = myeachmatch(r"\b[a-zA-Z]\w*\b(?!\()", var_df.expression)
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
            compute_output_vars(OutputDict, i, summed_species) .*
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
# function calc_flux_top(φ, D, u, x, C, BC)
#     α⁰, β⁰, γ⁰ = BC
#     x1, x2, x3 = x
#     c1, c2, c3 = C[1:3]
#     c0 = c3 * (x1^3 * x2^2 * β⁰ - x1^2 * x2^3 * β⁰)
#     c0 += c2 * (-x1^3 * x3^2 * β⁰ + x1^2 * x3^3 * β⁰)
#     c0 += c1 * (x2^3 * x3^2 * β⁰ - x2^2 * x3^3 * β⁰)
#     c0 +=
#         (
#             -x1^3 * x2^2 * x3 + x1^2 * x2^3 * x3 + x1^3 * x2 * x3^2 - x1 * x2^3 * x3^2 -
#             x1^2 * x2 * x3^3 + x1 * x2^2 * x3^3
#         ) * γ⁰
#     c0 /=
#         (x1 - x2) *
#         (x2 - x3) *
#         (-x1 + x3) *
#         (x1 * x2 * x3 * α⁰ - x1 * x2 * β⁰ - x1 * x3 * β⁰ - x2 * x3 * β⁰)

#     dCdz0 = c3 * (x1^3 * x2^2 * α⁰ - x1^2 * x2^3 * α⁰)
#     dCdz0 += c2 * (-x1^3 * x3^2 * α⁰ + x1^2 * x3^3 * α⁰)
#     dCdz0 += c1 * (x2^3 * x3^2 * α⁰ - x2^2 * x3^3 * α⁰)
#     dCdz0 +=
#         (
#             -x1^3 * x2^2 + x1^2 * x2^3 + x1^3 * x3^2 - x2^3 * x3^2 - x1^2 * x3^3 +
#             x2^2 * x3^3
#         ) * γ⁰
#     dCdz0 /=
#         (x1 - x2) *
#         (x2 - x3) *
#         (x1 - x3) *
#         (x1 * x2 * x3 * α⁰ - x1 * x2 * β⁰ - x1 * x3 * β⁰ - x2 * x3 * β⁰)

#     return φ * D * dCdz0 - φ * u * c0
# end


# function calc_flux_top_adsorbed(φ, D, u, x, C, BC)
#     spl = Spline1D(x, C,k=3,bc="extrapolate")
#     dCdz0 = derivative(spl, 0; nu=1)
#     c0 = spl(0.0)
#     return φ * D * dCdz0 - φ * u * c0
# end

# function calc_flux_top(φ, D, u, x, C, BC)
#     spl = Spline1D(x, C,k=3,bc="extrapolate")
#     dCdz0 = derivative(spl, 0; nu=1)
#     c0 = spl(0.0)
#     return φ * D * dCdz0 - φ * u * c0
# end

function calc_flux_top(φ, dx, C, BCAm,BcCm)
    # spl = Spline1D(x, C,k=3,bc="extrapolate")
    # dCdz0 = derivative(spl, 0; nu=1)
    # c0 = spl(0.0)
    return (BCAm * C[1]+ BcCm)*dx*φ
   
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
            t/1e3,
            var_flux_top,
            linecolor = "red",
            xlabel = "Time (kyr)",
            ylabel = "Benthic flux",
            title = flux_top_message,
            formatter=:auto,
            legend = :none,
            top_margin = 1mm,
            bottom_margin = 2mm,
            # left_margin = 2mm,
            # right_margin = 2mm
        )
    end
    p1 = contour(
        t/1e3,
        seddepth,
        var,
        levels = 10,
        fill = true,
        yflip = true,
        linecolor = "black",
        fillcolor = cmap,
        ylims = y_lim,
        xlabel = "Time (kyr)",
        ylabel = "Depth (cm)",
        title = label,
        yscale = yscale,
        formatter=:auto,
        legend_position = :best,
        top_margin = 2mm,
        bottom_margin = 1mm,
        # left_margin = 2mm,
        # right_margin = 2mm
)
    p2 = plot(
        var[:, 1],
        seddepth,
        linecolor = "black",
        linestyle = :dash,
        yflip = true,
        ylims = y_lim,
        label = "initial",
        ylabel = "Depth (cm)",
        # title = "",
        yscale = yscale,
        legend_position = :outerright,
        formatter=:auto,
        top_margin = 1mm,
        bottom_margin = 1mm,
        # left_margin = 2mm,
        # right_margin = 2mm
)
    plot!(
        p2,
        var[:, end],
        seddepth,
        linecolor = "red",
        linestyle = :solid,
        yflip = true,
        ylims = y_lim,
        label = "model",
        ylabel = "Depth (cm)",
        # title = "",
        yscale = yscale,
        formatter=:plain,
        # legend_position = :best,
    )
    if !isnothing(pwdata)
        if any(ismissing.(pwdata.error))
            @df pwdata plot!(
                p2,
                :value,
                :depth,
                seriestype = :scatter,
                group = :site,
                markershape = :circle,
                markersize = 2,
                markerstrokewidth = 0.5,
                # markercolor = "blue",
                # markerstrokecolor = "blue",
                yflip = true,
                ylims = y_lim,
                yscale = yscale,
                orientation = :vertical,
                formatter=:plain,
                color_palette=[:brown,:blue]
                # legend_position = :none,
            )
        else
            @df pwdata plot!(
                p2,
                :value,
                :depth,
                xerror = (:error, :error),
                seriestype = :scatter,
                group = :site,
                markershape = :circle,
                markersize = 2,
                markerstrokewidth = 0.5,
                # markerstrokecolor = "blue",
                yflip = true,
                ylims = y_lim,
                yscale = yscale,
                orientation = :vertical,
                formatter=:plain,
                color_palette=[:brown,:blue]
                # legend_position = :best,
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
        layout = grid(3, 1, heights = [0.4, 0.4, 0.2]),
        # guidefontsize = 16,
        # colorbar_tickfontsize = 16,
        # colorbar_titlefontsize = 16,
        # legendfontsize = 16,
        # legendtitlefontsize = 16,
        # titlefontsize = 16,
        # tickfontsize = 16,
        # left_margin  = 15mm,
        # right_margin = 15mm,
        margin  = 8mm,
        background_color_legend = nothing,
        foreground_color_legend = nothing,
    )
end
