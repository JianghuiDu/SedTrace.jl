

function generate_output(
    input_path::String,
    sol::SciMLBase.ODESolution,
    site::Vector{String},
    IndexDict::Dict,
    vars::Vector{String},
    ylim = L,
    saveplt = false,
)

    nt = length(sol.t)
    model_config = XLSX.readxlsx(input_path)
    substances = @chain begin
        DataFrame(XLSX.gettable(model_config["substances"])...)
        @subset(:include .== 1)
        @transform(:order = 1:length(:substance))
        @subset(:substance .∈ Ref(vars))
    end
    plotting = @chain begin
        DataFrame(XLSX.gettable(model_config["output"])...)
        @subset(:include .== 1)
        # @transform(conversion = string(:conversion))
        leftjoin(select(substances, :substance, :type), on = [:name => :substance])
    end
    data = DataFrame(XLSX.gettable(model_config["data"])...)
    data = @subset(data, :site .∈ Ref(site))

    df_str_replace!(plotting, [r"\s", r"[\u2212\u2014\u2013]"], ["", "\u002D"])

    # create a tuple of raw model profile results
    input_profile = Tuple(
        [sol.u[j][m] for j = 1:nt,
        # m = ((1:Ngrid) .- 1)nspec .+ i.order]
        # m = eval(Meta.parse("$(i.substance)ID"))]
         m in IndexDict[i.substance]] for i in eachrow(substances)
    )

    # compute the output variables using the input profile data
    header = join(substances.substance, ",")
    profile_expr = [] # holding function expressions
    profile_name = [] # holding variable names

    for i in eachrow(plotting)
        if i.name != "TA"
            push!(
                profile_expr,
                "($header) ->
                $(ismissing(i.expression) ?
                i.name : i.expression)",
            ) # if expression given
            push!(profile_name, i.name)

            if (!ismissing(i.type) && i.type == "dissolved_summed_pH")
                # compute both the profile of summed and individual species
                EqInv = EquilibriumInvariant(i.name)
                append!(profile_expr, ["($header) -> $i" for i in EqInv.expr])
                append!(profile_name, [i for i in EqInv.species])
            end
        elseif i.name == "TA" # total alkalinity
            TA_summed = @subset(substances, :type .== "dissolved_summed_pH")
            TA_str = []
            for j in TA_summed.substance
                EqInv = EquilibriumInvariant(j)
                append!(TA_str, EqInv.coef .* "*(" .* EqInv.expr .* ")")
            end
            push!(profile_name, i.name)
            push!(
                profile_expr,
                "($header) ->
                $(join(TA_str,"+"))",
            )
        end
    end

    # profile_function = eval.(Meta.parse.(profile_expr))
    # profile_raw = OrderedDict(
    #     profile_name .=>
    #         [Base.invokelatest.(f, input_profile...) for f in profile_function],
    # )


    # # calculate the flux_top of the raw profiles
    # flux_top_raw_expr = []
    # flux_top_raw_name = []

    # for i in eachrow(substances)
        # if i.type == "solid"
        #     push!(
        #         flux_top_raw_expr,
        #         "($header) ->
        #         calc_flux_top(phis[1],Ds[1],us[1],x[1:3],$(i.substance),Bc$(i.substance)[1])",
        #     )
        #     push!(flux_top_raw_name, i.substance)
            # elseif i.type != "dissolved_summed_pH"
            #     push!(flux_top_raw_expr,
            #     "($header) ->
            #     calc_flux_top(phif[1],D$(i.substance)[1],uf[1],x[1:3],$(i.substance),Bc$(i.substance)[1])")
            #     push!(flux_top_raw_name,i.substance)
            # else
            #     EqInv = EquilibriumInvariant(i.substance)
            #     if i.substance == "H"
            #         append!(flux_top_raw_expr,
            #         "($header) ->
            #         calc_flux_top(phif[1],D".*EqInv.species.*"[1],uf[1],x[1:3],".* "map((H) ->" .*(EqInv.expr).*",H)".*",Bc".*EqInv.species.*"[1])")
            #     else
            #         append!(flux_top_raw_expr,
            #         "($header) ->
            #         calc_flux_top(phif[1],D".*EqInv.species.*"[1],uf[1],x[1:3],".* "map((H,$(i.substance)) ->".*EqInv.expr.*",H,$(i.substance))".*",Bc".*EqInv.species.*"[1])")
            #     end
            #     append!(flux_top_raw_name,EqInv.species)
        # end
    # end

    #     function_flux_top_raw  = eval.(Meta.parse.(flux_top_raw_expr))

    #     function flux_top_at_t(time_id,func_id)
    #         input_profile_tmp = Tuple(input_profile[j][time_id,1:3] for j in 1:nspec)
    #         Base.@invokelatest function_flux_top_raw[func_id](input_profile_tmp...)
    #     end

    #     # compute the flux_top of output variables

    #     input_flux_top = Tuple([flux_top_at_t(i,j) for i in 1:nt] for j in 1:length(flux_top_raw_name))
    #     header_flux = join(flux_top_raw_name,",")

    #     flux_top_expr = []
    #     flux_top_name = []

    #     for i in eachrow(@subset(plotting,.!ismissing.(:flux_top)))
    #         if (ismissing(i.type) || i.type != "dissolved_summed_pH") && (i.name != "TA")
    #             push!(flux_top_expr,
    #             "($header_flux) ->
    #             $(ismissing(i.expression) ?
    #             i.name : i.expression)" )
    #             push!(flux_top_name, i.name)
    #         elseif (!ismissing(i.type) && i.type == "dissolved_summed_pH") && (i.name != "TA")
    #             EqInv = EquilibriumInvariant(i.name)
    #             push!(flux_top_expr,"($header_flux) -> $(join( EqInv.species,"+"))")
    #             push!(flux_top_name, i.name)
    #         elseif i.name == "TA"
    #             TA_summed = @subset(substances,:type.=="dissolved_summed_pH")
    #             TA_str = []
    #             for j in TA_summed.substance
    #                 EqInv = EquilibriumInvariant(j)
    #                 append!(TA_str,EqInv.coef.*"*(".*EqInv.species.*")")
    #             end
    #             push!(flux_top_name, i.name)
    #             push!(flux_top_expr,
    #             "($header_flux) ->
    #             $(join(TA_str,"+"))" )
    #         end
    #     end


    #     function_flux_top  = eval.(Meta.parse.(flux_top_expr))
    #     flux_top = OrderedDict(flux_top_name .=> [Base.invokelatest.(f,input_flux_top...) for f in function_flux_top])


    #     output = OrderedDict(plotting.name .=> [(profile=profile_raw[i.name].*eval(Meta.parse(i.conversion_profile)),unit_profile=i.unit_profile,flux_top = (haskey(flux_top,i.name) ? (flux_top[i.name].*eval(Meta.parse(i.conversion_flux))) : nothing),flux_top_measured = i.flux_top_measured,unit_flux = (haskey(flux_top,i.name) ? i.unit_flux : nothing)) for i in eachrow(plotting)])

    #     for (key,value) in output
    #         data_select = @subset(data, :substance .== key)

    #         if size(data_select, 1) != 0
    #             if value.unit_profile != data_select.unit[1]
    #                 throw(error("Unit of $(value.unit_profile) MUST be the same in plotting and data!"))
    #             else
    #                 pwdata = select(data_select, :depth, :value,:error,:site)
    #                 sort!(pwdata,:depth)
    #             end
    #         else
    #             pwdata = nothing
    #         end

    #         if !isnothing(value.flux_top)
    #             flux_top_message = "$(round(value.flux_top[end],sigdigits=2))  vs. $(value.flux_top_measured) \n $(value.unit_flux)"
    #         else
    #             flux_top_message = nothing
    #         end


    #         p = secplot(
    #             site,
    #             sol.t,
    #             x,
    #             value.profile',
    #             value.flux_top,
    #             :roma,
    #             "$key $(value.unit_profile)",
    #             (0.0, ylim),
    #             pwdata,
    #             flux_top_message,
    #             :identity,
    #         )
    #         display(p)
    #         if saveplt
    #             savefig(p,"$key.pdf")
    #         end

    #     end


    # end





    # function secplot(site,t, seddepth, var,var_flux_top, cmap, label, y_lim, pwdata ,flux_top_message , yscale)
    #     clims = range(minimum(var), stop = maximum(var), length = 100)

    #     if isnothing(var_flux_top)
    #         p0 = plot(legend=false,grid=false,foreground_color_subplot=:white)
    #     else
    #     p0 = plot(t,
    #         var_flux_top,
    #         linecolor="red",
    #         xlabel = "Time (yr)",
    #         ylabel = "Benthic flux",
    #         title = flux_top_message)
    #     end
    #     p1 = contour(
    #         t,
    #         seddepth,
    #         var,
    #         levels = 10,
    #         fill = true,
    #         yflip = true,
    #         linecolor = "black",
    #         fillcolor = cmap,
    #         ylims = y_lim,
    #         xlabel = "Time (yr)",
    #         ylabel = "Depth (cm)",
    #         title = label,
    #         yscale = yscale,
    #     )
    #     p2 = plot(
    #         var[:, 1],
    #         seddepth,
    #         linecolor = "black",
    #         yflip = true,
    #         ylims = y_lim,
    #         label = "initial",
    #         ylabel = "Depth (cm)",
    #         title = label,
    #         yscale = yscale,
    #         legend = :outerright,
    #     )
    #     plot!(
    #         p2,
    #         var[:, end],
    #         seddepth,
    #         linecolor = "red",
    #         yflip = true,
    #         ylims = y_lim,
    #         label = "model",
    #         ylabel = "Depth (cm)",
    #         title = label,
    #         yscale = yscale,
    #         legend = :right,
    #         dpi = 200,
    #     )
    #     if !isnothing(pwdata)
    #         if any(ismissing.(pwdata.error))
    #             @df pwdata plot!(
    #             p2,
    #             :value,
    #             :depth,
    #             seriestype = :path,
    #             group = :site,
    #             linestyle = :solid,
    #             markershape = :utriangle,
    #             yflip = true,
    #             ylims = y_lim,
    #             yscale = yscale,
    #             markersize = 2,
    #             orientation = :vertical
    #         )
    #         else
    #             @df pwdata plot!(
    #             p2,
    #             :value,
    #             :depth,
    #             xerror = (:error,:error),
    #             seriestype = :path,
    #             group = :site,
    #             linestyle = :solid,
    #             markershape = :utriangle,
    #             yflip = true,
    #             ylims = y_lim,
    #             yscale = yscale,
    #             markersize = 2,
    #             markerstrokewidth = 0.5,
    #             markerstrokecolor = "blue",
    #             orientation = :vertical
    #         )
    #         end
    #     end

    #     # if !isnothing(flux_top_message)
    #     #     annotate!(p0,(0.0,-y_lim[2]*0.002),text(flux_top_message,:red,:left,8))
    #     # end
    #     p = plot(
    #         p1,
    #         p2,
    #         p0,
    #         layout=grid(3, 1, heights=[0.45, 0.45,0.1]),
    #         guidefontsize = 12,
    #         colorbar_tickfontsize = 6,
    #         colorbar_titlefontsize = 6,
    #         legendfontsize = 6,
    #         legendtitlefontsize = 6,
    #         titlefontsize = 12,
    #         tickfontsize = 6,
    #         margin = 2.0mm,
    #         background_color_legend = nothing,
    #         foreground_color_legend = nothing,
    #     )
end




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

nothing
