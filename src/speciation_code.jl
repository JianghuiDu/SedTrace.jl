function speciation_model(substance_spec, speciation, adsorption)
    speciation_df = @subset(speciation, :substance .== substance_spec)
    adsorption_df = @subset(adsorption, :substance .== substance_spec)

    spec_in_code = vcat(speciation_df.dissolved[.!ismissing.(speciation_df.code)],"$(substance_spec)_dis")

    if isempty(speciation_df) && isempty(adsorption_df)
        speciation_Str = String[]
        cache = String[]
        speciation_parse = DataFrame(
            name = String[],
            formula = String[],
            formula_ = String[],
            type = String[],
            comment = String[],
        )

    elseif !isempty(speciation_df)
        substance_model = substance_spec
        TDissolved = substance_model * "_dis"

        speciation_logK = select(speciation_df, :dissolved, :K)

        rename!(speciation_df, :dissolved => :label)

        speciation_Eq, = species_from_equation(speciation_df)
        speciation_Eq =
            leftjoin(speciation_Eq, select(speciation_df, :label, :formula,:formula_), on = :label)
        rename!(speciation_Eq, :label => :dissolved)
        @subset!(speciation_Eq, :species_eq .!= "H2O")


        spec_reac = @subset(speciation_Eq, :role .== "reactant")
        spec_reac = groupby(spec_reac, [:dissolved, :formula,:formula_, :role])
        @transform!(spec_reac, :nspec = length(:species_eq))
        @subset!(spec_reac, :nspec .== 1)
        base_species = spec_reac[1].species_eq[1]
        base_species_name = spec_reac[1].dissolved[1]


        # @transform!(
        #     speciation_Eq,
        #     :isspec = match.(Regex("$base_species"), :species_eq) .!= nothing
        # )

        @transform!(speciation_Eq, :isspec = :species_eq .== :formula_)


        speciation_parse = copy(speciation_Eq)
        @subset!(speciation_parse, :isspec)
        # @select!(speciation_parse, :dissolved, :species_eq)
        # rename!(speciation_parse, :species_eq => :formula, :dissolved => :name)
        @select!(speciation_parse, :dissolved, :formula,:formula_)
        rename!(speciation_parse,:dissolved => :name)

        unique!(speciation_parse, :formula)
        @transform!(speciation_parse, :type = "dissolved", :comment = "Dissolved")
        append!(
            speciation_parse,
            DataFrame(
                name = TDissolved,
                formula = "",
                formula_ = "",
                type = "dissolved",
                comment = "Total dissolved",
                # code = "1"
            ),
        )
        speciation_Str = String[]
        cache = [TDissolved]
        speciation_expr =
            DataFrame(var = SymPy.Sym[], expr = SymPy.Sym[])


        @subset!(speciation_Eq, :dissolved .!= base_species_name)

        if isempty(speciation_Eq)
            speciation_Str = ["$base_species_name = $TDissolved"]
            cache = [TDissolved,base_species_name]
            speciation_expr =
                DataFrame(var = SymPy.Sym[base_species_name], expr = SymPy.Sym[TDissolved])    
        else
        @transform!(
            speciation_Eq,
            :species_eq =
                ifelse.(
                    :species_eq .== base_species,
                    base_species_name,
                    ifelse.(:isspec, :dissolved, :species_eq),
                )
        )

        speciation_Eq_ = groupby(speciation_Eq, [:dissolved, :role])
        speciation_Eq__ = combine(
            speciation_Eq_,
            [:species_eq, :stoichiometry] =>
                ((a, b) -> join(a .* ifelse.(b .== "1", "", "^(" .* b .* ")"), "*")) =>
                    :oneside,
        )
        speciation_Eq___ = groupby(speciation_Eq__, [:dissolved])
        speciation_Eq____ =
            combine(speciation_Eq___, :oneside => (x -> join(x, "*")) => :Eq)
        speciation_Eq_sys = leftjoin(speciation_Eq____, speciation_logK, on = [:dissolved])
        dropmissing!(speciation_Eq_sys)

        transform!(
            speciation_Eq_sys,
            [:Eq, :K] => ((a, b) -> a .* "-" .* string.(b)) => :Eq,
        )
        transform!(speciation_Eq_sys, :Eq => (x -> SymPy.sympify.(x)), renamecols = false)
        @transform!(
            speciation_Eq_sys,
            :sol = SymPy.solveset.(:Eq, SymPy.symbols.(:dissolved))
        )

        sumvar = SymPy.sum(SymPy.elements.(speciation_Eq_sys.sol))[1]

        base_expr = SymPy.solveset(
            sumvar + SymPy.symbols(base_species_name) - SymPy.symbols(TDissolved),
            SymPy.symbols(base_species_name),
        )
        base_expr = SymPy.elements(base_expr)[1]

        if in(base_species_name,spec_in_code)
            append!(cache,[base_species_name])
        append!(speciation_Str , [base_species_name * "=" * string(base_expr)])

        append!(speciation_expr,
            DataFrame(var = SymPy.sympify(base_species_name), expr = base_expr))
        end

        for i in eachrow(speciation_Eq_sys)
            res = SymPy.solveset(
                i.Eq[1](SymPy.symbols(base_species_name) => base_expr),
                SymPy.symbols(i.dissolved),
            )
            res = SymPy.elements(res)[1]
            if in(i.dissolved,spec_in_code)
            push!(speciation_Str, i.dissolved * "=" * string(res))
            push!(cache, i.dissolved)
            push!(
                speciation_expr,
                [
                    SymPy.sympify(i.dissolved),
                    res(SymPy.sympify(base_species_name) => base_expr),
                ],
            )
            end
        end
    end

        if isempty(adsorption_df)
            speciation_Str = vcat(
                TDissolved *"="*substance_spec,
                speciation_Str,
            )

        else
            TAdsorbed = substance_model * "_ads"
            ads_Eq = @select(adsorption_df, :dissolved, :adsorbed, :surface, :expression)
            transform!(ads_Eq, :expression => (x -> SymPy.sympify.(x)) => :Eq)
            @transform!(ads_Eq, :var = SymPy.sympify.(:dissolved))
            ads_Eq_ = leftjoin(ads_Eq, speciation_expr, on = :var)

            @transform!(
                ads_Eq_,
                :expr =
                    ifelse.(:dissolved .== TDissolved, SymPy.sympify(TDissolved), :expr)
            )
            transform!(ads_Eq_, [:Eq, :var, :expr] => ByRow((x, y, z) -> x(y => z)) => :Eq)


            TDissolved_expr = SymPy.solveset(
                SymPy.sum(ads_Eq_.Eq) * SymPy.symbols("dstopw") +
                SymPy.symbols(TDissolved) - SymPy.symbols(substance_model),
                SymPy.symbols(TDissolved),
            )

            TDissolved_expr = SymPy.elements(SymPy.simplify(TDissolved_expr))[1]


            speciation_Str = vcat(
                TDissolved * "=" * string(TDissolved_expr),
                speciation_Str,
                [i.adsorbed * "=" * i.expression for i in eachrow(ads_Eq_)],
            )

            @transform!(
                ads_Eq,
                :ads_surf =
                    substance_model .*
                    ifelse.(ismissing.(:surface), "_ads_nsf", "_ads_" .* :surface)
            )
            @select!(ads_Eq, :adsorbed, :ads_surf)
            ads_Eq__ = groupby(ads_Eq, :ads_surf)
            ads_Eq___ = combine(ads_Eq__, :adsorbed => (x -> join(x, "+")) => :ads_expr)

            speciation_Str = vcat(
                speciation_Str,
                [i.ads_surf * "=" * i.ads_expr for i in eachrow(ads_Eq___)],
                TAdsorbed * "=" * join(ads_Eq.adsorbed, "+"),
            )

            cache = vcat(
                cache,
                [i.adsorbed for i in eachrow(ads_Eq_)],
                ads_Eq___.ads_surf,
                TAdsorbed,
            )

            append!(
                speciation_parse,
                DataFrame(
                    name = adsorption_df.adsorbed,
                    formula = "",
                    formula_ = "",
                    type = "adsorbed",
                    comment = "Adsorbed",
                ),
            )
            append!(
                speciation_parse,
                DataFrame(
                    name = TAdsorbed,
                    formula = "",
                    formula_ = "",
                    type = "adsorbed",
                    comment = "Total adsorbed",
                ),
            )
            append!(
                speciation_parse,
                DataFrame(
                    name = ads_Eq___.ads_surf,
                    formula = "",
                    formula_ = "",
                    type = "adsorbed",
                    comment = "Surface adsorbed",
                ),
            )

        end

    elseif !isempty(adsorption_df)
        substance_model = substance_spec
        TDissolved = substance_model * "_dis"
        TAdsorbed = substance_model * "_ads"

        ads_Eq = @select(adsorption_df, :dissolved, :adsorbed, :surface, :expression)
        transform!(ads_Eq, :expression => (x -> SymPy.sympify.(x)) => :Eq)
        @transform!(ads_Eq, :var = SymPy.sympify.(:dissolved))
        @transform!(
            ads_Eq,
            :ads_surf =
                substance_model .*
                ifelse.(ismissing.(:surface), "_ads_nsf", "_ads_" .* :surface)
        )

        TDissolved_expr = SymPy.solveset(
            SymPy.sum(ads_Eq.Eq) * SymPy.symbols("dstopw") + SymPy.symbols(TDissolved) -
            SymPy.symbols(substance_model),
            SymPy.symbols(TDissolved),
        )

        TDissolved_expr = SymPy.elements(SymPy.simplify(TDissolved_expr))[1]


        speciation_Str = vcat(
            TDissolved * "=" * string(TDissolved_expr),
            [i.adsorbed * "=" * i.expression for i in eachrow(ads_Eq)],
        )

        @select!(ads_Eq, :adsorbed, :ads_surf)
        ads_Eq__ = groupby(ads_Eq, :ads_surf)
        ads_Eq___ = combine(ads_Eq__, :adsorbed => (x -> join(x, "+")) => :ads_expr)

        speciation_Str = vcat(
            speciation_Str,
            [i.ads_surf * "=" * i.ads_expr for i in eachrow(ads_Eq___)],
            TAdsorbed * "=" * join(ads_Eq.adsorbed, "+"),
        )

        cache = vcat([i.adsorbed for i in eachrow(ads_Eq)], ads_Eq___.ads_surf, TAdsorbed)
        speciation_parse = DataFrame(
            name = adsorption_df.adsorbed,
            formula = "",
            formula_ = "",
            type = "adsorbed",
            comment = "Adsorbed",
        )
        append!(
            speciation_parse,
            DataFrame(
                name = TAdsorbed,
                formula = "",
                formula_ = "",
                type = "dissolved",
                comment = "Total adsorbed",
            ),
        )
        append!(
            speciation_parse,
            DataFrame(
                name = ads_Eq___.ads_surf,
                formula = "",
                formula_ = "",
                type = "adsorbed",
                comment = "Surface adsorbed",
            ),
        )
        append!(
            speciation_parse,
            DataFrame(
                name = TDissolved,
                formula = "",
                formula_ = "",
                type = "dissolved",
                comment = "Total dissolved",
            ),
        )


    end

    return unique!(speciation_Str), unique!(cache), unique!(speciation_parse)
end

function speciation_code(substances, speciation, adsorption)
    substances_speciation = @subset(substances, :type .== "dissolved_speciation")
    spec_expr = String[]
    spec_cache = String[]
    speciation_parse = DataFrame(
        substance = String[],
        name = String[],
        formula = String[],
        formula_ = String[],
        type = String[],
        comment = String[],
        # code = Bool[]
    )
    for i in substances_speciation.substance
        expr, cache, parse_df = speciation_model(i, speciation, adsorption)
        # df = @subset(speciation,:substance.==i,.!ismissing.(:code))
        # spec_in_code = vcat(df.dissolved,"$(i)_dis")
        # @transform!(parse_df,:code = ifelse.(((in.(:name,Ref(spec_in_code))) .&& (:type .=="dissolved")),true,false))
        # filter!(x -> in(x,spec_in_code),cache)
        # ss = split.(expr,"=")
        # idx = zeros(length(expr))
        # for ii in 1:length(expr)
        #     if in(ss[ii][1],spec_in_code)
        #         idx[ii]=1
        #     end
        # end

        # expr = expr[idx.==1]
        append!(spec_expr, expr)
        append!(spec_cache, cache)
        append!(speciation_parse, @transform!(parse_df, :substance = i))
    end
    spec_code = "@. " .* spec_expr
    return (spec_code, spec_expr, spec_cache, speciation_parse)
end
