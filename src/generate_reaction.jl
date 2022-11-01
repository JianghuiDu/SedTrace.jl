#-------------------------------------------------------------------------------------------
## Requirement on the user supplied Excel file of model_config
# 1. It should constain two spreadsheets, on called "substances",
#    and the other "reactions".
# 2. The "substances" spreadsheet contains information of modelled
#    substances, including their names, their species in the model
#    and the types, corresponding to three columns: "substance",
#    "formula", and "type".
# 3. The "reactions" spreadsheet contains information of modelled
#    reactions, including their names, chemical equations,
#    kinetic rate expression and definition of saturation index (if
#    a dissolution/precipitation reaction), corresponding to four columns:
#    "label", "equation", "rate" and "Omega".
# 4. Only the substances/species that are modelled, i.e., appearing
#    in column "rate" and "Omega" should be listed in the spreadsheet "substance".
#    Not modelled substances/species that appear only in the chemical
#    equations should not be listed in the spreadsheet "substance".

## Naming convention
#    A substance is a chemical entity that may have multiple species.
#    The model directly models the substances, the species are indiretly modelled
#    by linking to the substances through speciation submodels.

#    A substance may be associated with 3 types of names in the spreadsheet:
# 1. The substance name in the column "substance". This name will appear
#    in the final code. It can only contain alphanumericals (readable by computers).
# 2. On the species level, the individual species of a substance may have
#    a chemical name and a code name:
#    The chemical name appears in columns "formula" and is used "equation",
#    which must match exactly. The reason to have a code name is becuase
#    chemical names are often not readable by computers, such as Fe{2+}.
#    Yet the chemical name is needed in the chemical equation.
#    The code name will appear in the final code, and it can only constain
#    alphanumericals, written in the format of "chemical name/code name" in the
#    column "formula", multiple species need to be separated by ",".
#    When the chemical name is alphanumericals, then code name is not needed.
#    The general format of column "formula" thus should be like
#    chemical name 1, chemical name2/code name 2, chemical name 3/code name 3.
#    If the substance only has one species, such as O2, then the "formula"
#    column should be left empty, and by default the substance name will be used
#    as the code name for this substance/species.

#    The column "formula" enables the computer to automatically
#    generate computer codes of the species by replacing the chemical names in the
#    chemical equations by the code names.

#    In the columns "rate" and "Omega", only the substance/code names cam be used.
## Example:
#    Fe_II is a substance and has multiple species,such as Fe{2+} for free Fe_II,
#    (Surf_Fe){+} for Fe_II adsorbed onto surfaces. Neither these two names are
#    readable by computer, and we need to use code name Fe_II_free for Fe{2+} and
#    "Fe_ads" for (Surf_Fe){+}. Fe_II is the substance that will be modelled,
#    and these species will also enter the model though speciation.
#-------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------
# Functions for parsing chemical equations of reactions
# This happens on three levels
# 1. Equations are parsed into species (reactants/products) and their stoichiometries
# 2. Species are parses into components and their charges
# 3. Components are parsed into elements and their coefficients
#-------------------------------------------------------------------------------------------

function parse_equation(reaction)
    # Parse a chemical equation, returns the species, stoichiometry and roles
    # Equations must be in the form of A + b*B = c*C + D, space is allowed
    # Stoichiometry (b, c) must be before species formula (B, C)
    # Use +, * and =, other addition, multiplication and equal signs not allowed

    # Example: "1/2*O2 + NO2{-} = NO3{-}" is parsed to

    #     Row │ species  stoichiometry  charge  role
    #         │ String   String         String  String
    #    ─────┼──────────────────────────────────────────
    #       1 │ O2       -1/2           0*1     reactant
    #       2 │ NO2      -1             -1      reactant
    #       3 │ NO3      1              -1      product

    # Split the equation to left/reactants and right/products sides
    # remove space, convert to the same "-" (offen hard to identify visually)
    strs = reaction |> x ->
        split(x, "=") |> # split reactants and products
        x -> split.(x, r"\+(?!(([^(]*\))|([^{]*})))") # splits each reactants/products

    species = String[]
    stoichiometry = String[]
    charge = String[]
    role = String[]
    # no need to consider empty space in the following regexes

    # capture species formula after multiplication * (like O2 in  1/2*O2)
    # allow words (\w) and ( ) [ ] in species formula, like (CH2O)(NH3)[rNC](H3PO4)[rPC]
    reg_species_1 = r"((?<=\*)[\w\(\)\[\]]+(?=\{))|((?<=\*)[\w\(\)\[\]]+(?!\{)$)"
    # capture species formula without precceding * (like NO3 in NO3{-})
    reg_species_2 = r"([\w\(\)\[\]]+(?=\{))|([\w\(\)\[\]\.]+$)"

    # capture the stoichiometry before * (like 1/2 in 1/2*O2)
    # allow words (\w) and + - * / ( ) in the stoichiometry like (a+b)
    reg_stoic = r"[\w\(\)\+\-\*\/\.]+(?=\*)"

    # capture species charge and sign in side {}
    # charge must be a number, the order of sign and nuber is flexible (like {-},{2+},{2-})
    reg_charge = r"(?<=\{)\d+(?=[\+\-]\})|(?<=\{[\+\-])\d+(?=\})"
    reg_charge_sign =
        r"(?<=\{\d|\d\d)[\+\-](?=\})|(?<=\{)[\+\-](?=\d|\d\d\})|(?<=\{)[\+\-](?=\})"

    for j in strs[1] # loop over reactants
        # check if there is a coefficient before the species formula, indicated by "*"
        push!(species, mymatch(reg_species_1, j, mymatch(reg_species_2, j))) # get species formula
        push!(stoichiometry, "-" * mymatch(reg_stoic, j, "1")) # stoichiometry
        push!(charge, mymatch(reg_charge_sign, j, "0*") * mymatch(reg_charge, j, "1"))
        push!(role, "reactant")
    end
    for j in strs[2] # loop over products
        push!(species, mymatch(reg_species_1, j, mymatch(reg_species_2, j))) # get species formula
        push!(stoichiometry, mymatch(reg_stoic, j, "1")) # stoichiometry
        push!(charge, mymatch(reg_charge_sign, j, "0*") * mymatch(reg_charge, j, "1"))
        push!(role, "product")
    end

    equation = DataFrame(
        species = species,
        stoichiometry = stoichiometry,
        charge = ifelse.(occursin.(r"^0\*", charge), "0", charge),
        role = role,
    )

    for i in equation.species
        if !isnothing(mymatch(r"^[a-z\d]", i))
            throw(error(reaction * " has illegal species formula " * i))
        end
    end
    return equation
end

function species_decomp(species)
    # Decompose a species formula into components and elements
    # Return the components in the species, their charges
    # Return the elements in the species, their coefficients

    # Rules of writing species formula:
    # 1. components must be inside () if multiple ones are written together
    # 2. elements within components can be linked by "-"
    # 3. coefficients of components must be written inside []
    # 4. charge must be inside in {}, numbers preceding signs, like Fe{2+}
    # 5. 0 charge doesn't need to be written down
    # 6. single charge can be written without "1", like {+}, {-}
    # 7. elements must only contain letters and must start with upper case letters

    # For example, "(CH2O)(NH3)[rNC](H3PO4)[rPC]" is a species,
    # CH2O, NH3 etc are the components, C, N, H ,O are the elements
    # the species H2PO4{-}" has component H2PO4, and charge -1
    # adsorbed Fe is written like (Surf_Fe){+} where Surf_Fe is a component
    # Surf and Fe are two elements

    # first decompose species into components
    # second decompose components into elements

    # regex to find components in species (see the Rule above)
    reg_comp = r"\w+(?![^[]*])"

    # list of components
    comp = myeachmatch(reg_comp, species)
    # coefficients of the components
    # either inside [] or 1
    reg_comp_coef = Regex.("(?<=" .* "\\Q" .* comp .* "\\E" .* "\\)\\[)[\\w\\.]+(?=\\])")
    comp_coef = mymatch.(reg_comp_coef, species, "1")

    # # sign of the component charge
    # regs_comp_sign = Regex("[\\+-](?=\\})")
    # comp_sign = mymatch(regs_comp_sign, species, "0")
    # # charge of the components
    # regs_comp_charge = Regex("(?<=\\{)(\\d+)(?=" * "\\Q" * comp_sign * "\\E" * "\\})")
    # if comp_sign == "0" # no charge
    #     charge = "0"
    # else
    #     charge = comp_sign * mymatch(regs_comp_charge, species, "1")
    # end
    # # charge of components written to a dataframe
    # comp_charge = DataFrame(component = comp, charge = charge)

    # now break components down into elements
    element_coef = DataFrame(element = String[], coef = String[])

    for i in eachindex(comp)
        # breaks components into elemental parts,
        #  in the format of element name followed by stoichiometry
        # like C-H2-O
        # element must start with upper case letter, followed by lower cases
        elem_part = myeachmatch(r"([A-Z]([a-z]*))(\d*)?", comp[i])
        # break elemental parts into elements and their stoichiometries/coefficients
        append!(element_coef.element, mymatch.(r"[A-Z]([a-z]*)", elem_part))
        append!(element_coef.coef, mymatch.(r"\d+", elem_part, "1") .* "*" .* comp_coef[i])
    end

    return (element_coef)
end

function check_react_balance(label, equation_ind)
    # check if a reaction is mass and charge balanced
    # first decompose the species to components and elements

    element_df = DataFrame(element = String[], coef = String[])
    component_df = DataFrame(component = String[], charge = String[])

    for i in eachindex(equation_ind.species)
        # decompose species into elements and components
        # get the "total" stoichiometries of elements and charges
        elements_i = species_decomp(equation_ind.species[i])
        elements_i.coef .= equation_ind.stoichiometry[i] .* "*" .* elements_i.coef
        append!(element_df.element, elements_i.element)
        append!(element_df.coef, elements_i.coef)
    end

    # # adsorbed species replace "Surf" (difficult to use in julia)
    # element_df.element .= replace.(element_df.element,"(Surf)" => "Surf_ads")

    # convert elements (Strings) to symbolic variables
    # by parsing into an expression and then evaluating
    element_sym = Meta.parse("SymPy.@vars " * join(unique(element_df.element), " "))
    eval(element_sym)
    # convert coefficients of element (Strings) to symbolic variables
    coef_vars = filter(!isnothing, myeachmatch.(r"[a-zA-Z]\w+", element_df.coef))
    if !isempty(coef_vars)
        coef_sym = Meta.parse("SymPy.@vars " * join(unique(vcat(coef_vars...)), " "))
        eval(coef_sym)
    end
    # check if the sum of element*coefficient of the reaction is zero
    mass_sum_expr = Meta.parse(join(element_df.coef .* "*" .* element_df.element, "+"))
    mass_sum = SymPy.simplify(
        SymPy.nsimplify(eval(mass_sum_expr), tolerance = eps(), rational = true),
    )

    # if mass_sum != 0 # if not mass balanced
    report_error = false
    if typeof(SymPy.N(mass_sum)) <: Real
        if abs(SymPy.N(mass_sum)) > 10eps()
            report_error = true
        end
    else
        if any(SymPy.sympy.Poly(mass_sum).coeffs() .> 10eps())
            report_error = true
        end
    end

    if report_error
        throw(
            error(
                "Reaction " *
                label *
                " is not mass balanced. Net mass is " *
                string(mass_sum),
            ),
        )
    end
    charge_eq = equation_ind.charge .* " * " .* equation_ind.stoichiometry
    # convert charges (Strings) to symbolic variables
    charge_vars = filter(!isnothing, myeachmatch.(r"[A-Za-z]+", charge_eq))

    # check if the sum of charges of the reaction is zero
    charge_sum_expr = Meta.parse(join(charge_eq, " + "))
    if isempty(charge_vars)
        charge_sum = eval(charge_sum_expr)
    else
        charge_sym = Meta.parse("SymPy.@vars " * join(unique(vcat(charge_vars...)), " "))
        eval(charge_sym)
        charge_sum = SymPy.simplify(
            SymPy.nsimplify(eval(charge_sum_expr), tolerance = eps(), rational = true),
        )
    end

    report_error = false
    if typeof(SymPy.N(charge_sum)) <: Real
        if abs(SymPy.N(charge_sum)) > 10eps()
            report_error = true
        end
    else
        if any(SymPy.sympy.Poly(charge_sum).coeffs() .> 10eps())
            report_error = true
        end
    end

    if report_error# if not charge balanced
        throw(
            error(
                "Reaction " *
                label *
                " is not charge balanced. Net charge is " *
                string(charge_sum),
            ),
        )
    end

    # # adsorbed species go back to "Surf"
    # element_df.element .= replace.(element_df.element, "Surf_ads" => "(Surf)")

    # simplify coefficients and charges into rational format
    element_df.coef .= to_rational.(element_df.coef)

    return element_df
end

function species_from_equation(reactions_list)
    # Extract species information from the reaction equations
    # 1. use parse_equation to extract species information
    # 2. use check_react_balance to check if reactions are mass and charge balanced

    species_eq = DataFrame(
        label = String[],
        species_eq = String[],
        stoichiometry = String[],
        charge = String[],
        role = String[],
    )
    # elements extracted from the chemical equations, their coefficients
    element_eq = DataFrame(label = String[], element = String[], coef = String[])
    # # charges extracted from the chemical equations, their coefficients
    # component_eq = DataFrame(label = String[], component = String[], charge = String[])

    for i in eachrow(reactions_list)
        # name = replace(i.label, r"\s" => "") # remove space in reaction name
        name = i.label
        # parse the chemical reaction into species, their stoichiometries and the roles (reactant/product)
        equation_ind = parse_equation(i.equation)

        append!(species_eq.label, fill(name, size(equation_ind, 1)))
        append!(species_eq.species_eq, equation_ind.species)
        append!(species_eq.stoichiometry, equation_ind.stoichiometry)
        append!(species_eq.charge, equation_ind.charge)
        append!(species_eq.role, equation_ind.role)

        if !ismissing(i.check)
            # check if the chemical equations are balanced
            element_ind = check_react_balance(name, equation_ind)

            append!(element_eq.label, fill(name, size(element_ind, 1)))
            append!(element_eq.element, element_ind.element)
            append!(element_eq.coef, element_ind.coef)
        end
    end

    return (species_eq, element_eq)
end

#-------------------------------------------------------------------------------------------
# Functions to match the species information extracted from
# the reaction equations from column "equation" with the modelled
# substance/species in the columns "substance" and "formula".
#-------------------------------------------------------------------------------------------
function join_eq_to_model(species_eq, species_modelled, speciation_df)

    transform!(
        species_modelled,
        [:formula, :substance] =>
            ((a, b) -> ifelse.(a.=="", b, b .* "," .* a)) => :formula,
    )

    function joinspec(subs)
        df = @subset(speciation_df,:substance.==subs)
        @transform!(df,:spec = ifelse.(:formula.=="",:name,:formula.*"/".*:name))
        return(join(df.spec,","))
    end
    @transform!(
        species_modelled,
        :formula = ifelse.(:type.=="dissolved_speciation",:formula.* ",".*joinspec.(:substance),:formula)
    )
    # get the unique species read from the chemical equations
    # to join to the species_modelled list
    species_eq_unique = DataFrame()
    species_eq_unique[!, :species_eq] = unique(species_eq[!, :species_eq])
    species_eq_unique[!, :formula] = missings(String, size(species_eq_unique, 1))
    species_eq_unique[!, :codename] = missings(String, size(species_eq_unique, 1))

    # loop though the species from equations and in the modelled list
    # get the code names of the species from equations
    for i in eachrow(species_eq_unique)
        # reg1: if a species is in species_modelled
        # reg2: if yes get the code name from species_modelled
        # reg1 = Regex("(?<!\\w)" * "\\Q" * i[:species_eq] * "\\E" * "(?!\\w)")
        reg1 = Regex("(?<=,|\\/|^|;)" * "\\Q" * i[:species_eq] * "\\E" * "(?=,|\\/|\$|;|{)")
        reg2 = Regex(
            "(?<=\\," *
            "\\Q" *
            i[:species_eq] *
            "\\E" *
            ")(\\{[\\+\\-\\d*]?\\})?\\/\\K\\w+",
        ) # codename is after chemical name/
        for j in eachrow(species_modelled)
            if occursin(reg1, j[:formula])
                i[:formula] = j[:formula]
                i[:codename] = mymatch(reg2, j[:formula], missing)
            end
        end
    end
    # species that are in the equation but not modelled
    species_eq_not_modelled = @subset(species_eq_unique, ismissing.(:formula))
    rename!(species_eq_not_modelled, :species_eq => :species)
    select!(species_eq_not_modelled, :species)
    insertcols!(
        species_eq_not_modelled,
        :comment => "in chemical equation but not modelled",
    )


    # join the species in equations to modelled
    @subset!(species_eq_unique, .!ismissing.(:formula))
    species_join = leftjoin(species_eq, species_eq_unique; on = :species_eq)
    @subset!(species_join, .!ismissing.(:formula))
    species_join = outerjoin(species_join, species_modelled; on = :formula)

    # species not modelled but in the equations
    species_modelled_not_eq = @subset(species_join, ismissing.(:species_eq))
    rename!(species_modelled_not_eq, :formula => :species)
    select!(species_modelled_not_eq, :species)
    insertcols!(
        species_modelled_not_eq,
        :comment => "modelled but not in chemical equation",
    )

    # collect those extra species and report them to the user
    species_extra = outerjoin(
        species_modelled_not_eq,
        species_eq_not_modelled,
        on = [:species, :comment],
    )

    # remove Union Missing type in the column
    colnames = Symbol.(names(species_join))
    colnames_no_missing = deleteat!(colnames, findall(x -> x == :codename, colnames))
    species_join = dropmissing(species_join, colnames_no_missing, disallowmissing = true)


    # make type changes to the adsorbed species
    # species_join_ads = @subset(species_join, .!ismissing.(:codename))

    # ads_df = @subset(speciation_df,in.(:comment,Ref(["adsorbed","Total adsorbed","Surface adsorbed"])))
    ads_df = @subset(speciation_df,:type .== "adsorbed")
    # ads_spec = skipmissing(vcat(ads_df.adsorbed, ads_df.species_eq))

    ads_spec = ads_df.name

    dis_df = @subset(speciation_df,:type .== "dissolved")
    dis_spec = skipmissing(vcat(dis_df.name,dis_df.formula_))
    transform!(
        species_join,
        [:species_eq, :type] =>
            ((a, b) -> ifelse.(in.(a, Ref(ads_spec)), "adsorbed", b)) => :species_type,
    )
    @transform!(species_join,:species_type = ifelse.(in.(:species_eq,Ref(dis_spec)),"dissolved",:species_type))
    @transform!(species_join,:species_type = ifelse.(in.(:species_type, Ref(["dissolved_pH"])),"dissolved",:species_type))

    rename!(species_join, :type => :substance_type)
    species_join = groupby(species_join, :label)
    species_join = transform!(
        species_join,
        [:species_type, :role] =>
            (
                (a, b) -> ifelse(
                    any(occursin.(r"solid|\badsorbed\b", a[b.=="reactant"])),
                    "solid",
                    "dissolved",
                )
            ) => :reaction_type,
        ungroup = true,
    )
    select!(species_join, Not([:top_bc_type, :bot_bc_type, :bioirrigation_scale]))

    return (species_join, species_extra)
end



#-------------------------------------------------------------------------------------------
# Formate user supplied reaction rate expressions
# generate rate expressions of each reaction
# dissolution/precipitation requires special treatment
# Final results are expressions like R_reaction = rate expr
#-------------------------------------------------------------------------------------------
# heaviside(x::Vector{Float64}) = ifelse.(x.>= 0.0, 1.0, 0.0)
# heaviside(x::Float64) = ifelse(x>= 0.0, 1.0, 0.0)

function format_rate_expr(react_df, discontinuity)
    n_react = size(react_df, 1)
    rate_expr = String[]
    omega_expr = String[]
    for i in eachrow(react_df)
        if ismissing(i.Omega) # if not dissolution/precipitation
            push!(rate_expr, i.label * " = " * i.rate)
        else
            # if with dissolution/precipitation,
            # need to multiply the term (Omega<1) or (Omega>1) as conditionals for
            # disslution and precipitation respectively
            push!(omega_expr, "Omega" * "_" * i.label * " = " * i.Omega)
            if !isnothing(match(r"_dis$", i.label)) # dissolution
                push!(
                    rate_expr,
                    discontinuity ?
                    "$(i.label) = ifelse(Omega_$(i.label)<=1.0,1.0,0.0)*($(i.rate))" :
                    "$(i.label)  = (-tanh(1e3*(Omega_$(i.label)- 1.0))/2+0.5) * ($(i.rate))",
                )
            elseif !isnothing(match(r"_pre$", i.label)) # precipitation
                push!(
                    rate_expr,
                    discontinuity ?
                    "$(i.label)  = ifelse(Omega_$(i.label)>=1.0,1.0,0.0)*($(i.rate))" :
                    "$(i.label) = (tanh(1e3*(Omega_$(i.label)- 1.0))/2+0.5) * ($(i.rate))",
                )
            end
        end
    end
    return (rate_expr, omega_expr)
end


#-------------------------------------------------------------------------------------------
# Functions to generate reaction rates for pH
#-------------------------------------------------------------------------------------------
# struct summed_species
#     # container of summed species like TCO2
#     name::String
#     species::Vector{String} # subspecies
#     coef::Vector{String} # subspecies coefficient in TA definition
# end

# first equation use "=", followed equations using "+="
# @inline t(j) = ifelse(j == 1, " = ", " += ")

function dTA_dH_rate(T_species, species_summed_df, dTAdt_str, dHdt_str)
    # Contribution of a summed species to the reaction rate of Total alkalinity and proton
    name_df = @chain begin
        DataFrame(species = T_species.species, coef = T_species.coef)
        @subset(:coef .!= "0")
    end
    summed_df = @subset(species_summed_df, str_in(:species_eq, name_df.species))
    if !isempty(summed_df)
        summed_df = leftjoin(summed_df, name_df, on = (:species_eq => :species))
        summed_df = @transform(
            summed_df,
            :stoichiometry = str_simplify(:stoichiometry .* "*" .* :coef)
        )
        conversion_fac = convfac(summed_df)
        push!(
            dTAdt_str,
            "S_TA += " * rstrip(
                join(
                    summed_df.stoichiometry .* " * " .* summed_df.label .* conversion_fac,
                    " + ",
                ),
            ),
        )
    end
    if T_species.name != "H"
        push!(dHdt_str, "S_H -= S_" * T_species.name * " * dTA_d" * T_species.name)
    end
end


function pH_rate(species_join)
    # Total reaction rates of  proton and total alkalinity
    # Rates of the summed sustance are calculated like other species
    # TA = HCO3{-} + 2*CO3{2-} + B(OH)4{-} + OH{-} + HPO4{2-} +
    #      2*PO4{3-} + H3SiO4{-} + NH3 + HS{-}
    #      - H{+} - HSO4{-} + HF - H3PO4

    # Total reaction rate of TA (dTAdt):
    # Sum of all the species contributing to TA (= HCO3 + 2CO3 + etc.)
    # 1. Gather all the contributing species and the reaction rates that affect them
    # 2. Sum up these rates according to coefficients of these species in TA
    #    (dTAdt = R_HCO3 + 2*R_CO3 + etc.)

    # Total reaction rate of proton (S_H):
    # @. S_H = S_TA
    # @. S_H -= S_TCO2 * dTA_dTCO2
    # @. S_H -= S_TNH4 * dTA_dTNH4
    # @. S_H -= S_TH3PO4 * dTA_dTH3PO4
    # @. S_H -= S_TH2S * dTA_dTH2S
    # @. S_H -= S_THSO4 * dTA_dTHSO4
    # @. S_H -= S_TH4SiO4 * dTA_dTH4SiO4
    # @. S_H /= dTA_dH


    species_summed_df = @subset(species_join, :substance_type .== "dissolved_pH")
    species_summed = unique(species_summed_df.substance)



    dTAdt_str = String[] # contains the dTAdt (rate change of TA) expressions
    dHdt_str = String[]  # contains the dHdt (rate change of H) expression
    push!(dHdt_str, "S_H = S_TA")

    # loop over summed sustance
    # 1. Find which summed sustances are included in the model
    # 2. Find the species of this substance that contributes to TA
    # 3. Get the coefficients of the species in each reaction
    # 4. Multiply these coefficients by the coefficients of the species in TA
    # 5. Sum up the reaction rates for TA and H
    # Species can be written with or without charges, CO3/CO3{2-}
    # pHspecies = DataFrame(sumspecies = String[], subspecies = String[])
    # for i in list
    #     if i.name in species_summed
    #         dTA_dH_rate(i, species_summed_df, dTAdt_str, dHdt_str)
    #         append!(pHspecies.sumspecies,fill(i.name,length(i.species)))
    #         append!(pHspecies.subspecies,i.species)
    #     end
    # end

    for i in species_summed
        if !(i in list_summed_species)
            throw(
                error(
                    "dissolved_pH species must be from this list: $list_summed_species. $i is not in the list.",
                ),
            )
        else
            tmp = EquilibriumInvariant(i)
            # if i.substance_type == "dissolved_pH"
            dTA_dH_rate(tmp, species_summed_df, dTAdt_str, dHdt_str)
            # end
            # append!(pHspecies.sumspecies, fill(tmp.name, length(tmp.species)))
            # append!(pHspecies.subspecies, tmp.species)
        end
    end

    dTAdt_str[1] = replace(dTAdt_str[1], "+=" => "=")

    # push!(dHdt_str, "S_H /= dTA_dH")

    push!(dHdt_str, "S_H = S_H/dTA_dH")

    return vcat(dTAdt_str, dHdt_str)#, pHspecies
end


function pH_rate_species(species_join)
    # Total reaction rates of  proton and total alkalinity
    # Rates of the summed sustance are calculated like other species
    # TA = HCO3{-} + 2*CO3{2-} + B(OH)4{-} + OH{-} + HPO4{2-} +
    #      2*PO4{3-} + H3SiO4{-} + NH3 + HS{-}
    #      - H{+} - HSO4{-} + HF - H3PO4

    # Total reaction rate of TA (dTAdt):
    # Sum of all the species contributing to TA (= HCO3 + 2CO3 + etc.)
    # 1. Gather all the contributing species and the reaction rates that affect them
    # 2. Sum up these rates according to coefficients of these species in TA
    #    (dTAdt = R_HCO3 + 2*R_CO3 + etc.)

    # Total reaction rate of proton (S_H):
    # @. S_H = S_TA
    # @. S_H -= S_TCO2 * dTA_dTCO2
    # @. S_H -= S_TNH4 * dTA_dTNH4
    # @. S_H -= S_TH3PO4 * dTA_dTH3PO4
    # @. S_H -= S_TH2S * dTA_dTH2S
    # @. S_H -= S_THSO4 * dTA_dTHSO4
    # @. S_H -= S_TH4SiO4 * dTA_dTH4SiO4
    # @. S_H /= dTA_dH

    # only select "dissolved_pH" sustance
    species_summed_df = @chain begin
        @subset(species_join, occursin.("dissolved_pH", :substance_type))
        select(:substance, :substance_type)
        unique
    end

    pHspecies = DataFrame(sumspecies = String[], subspecies = String[])


    for i in eachrow(species_summed_df)
        if !(i.substance in list_summed_species)
            throw(
                error(
                    "dissolved_pH species must be from this list: $list_summed_species. $(i.substance) is not in the list.",
                ),
            )
        else
            tmp = EquilibriumInvariant(i.substance)
            append!(pHspecies.sumspecies, fill(tmp.name, length(tmp.species)))
            append!(pHspecies.subspecies, tmp.species)
        end
    end

    return pHspecies
end


function convfac(df)
    # conversion factor, between dissolved and solid rates
    # RULES: if model species is dissolved and reaction is solid, multiply reaction rate by "dstopw"
    # RULES: if model species is solid and reaction is dissolved, multiply reaction rate by "pwtods"
    conversion_fac = Array{String}(undef, size(df, 1))
    for j = 1:size(df, 1)
        if df.substance_type[j] == df.reaction_type[j]
            conversion_fac[j] = ""
        elseif df.substance_type[j] in
               ["dissolved_pH", "dissolved_speciation"] &&
               df.reaction_type[j] == "dissolved"
            conversion_fac[j] = ""
        elseif df.substance_type[j] in
               ["dissolved_pH", "dissolved_speciation"] &&
               df.reaction_type[j] == "solid"
            conversion_fac[j] = "*dstopw"
        elseif df.substance_type[j] == "solid" && df.reaction_type[j] == "dissolved"
            conversion_fac[j] = "* pwtods"
        elseif df.substance_type[j] == "dissolved" && df.reaction_type[j] == "solid"
            conversion_fac[j] = "* dstopw"
        # elseif df.substance_type[j] == "dissolved_adsorbed" &&
        #        df.reaction_type[j] == "dissolved"
        #     conversion_fac[j] = "/(1+dstopw*K" * df.substance[j] * "_ads)"
        # elseif df.substance_type[j] == "dissolved_adsorbed" &&
        #        df.reaction_type[j] == "solid"
        #     conversion_fac[j] = "/(pwtods+K" * df.substance[j] * "_ads)"
        end
    end

    return conversion_fac
end


#-------------------------------------------------------------------------------------------
# assmeble all species rate expressions
#-------------------------------------------------------------------------------------------

function species_rate_expr(species_join, species_extra)
    # Assemble rate expressions for each model substance
    # input constains reaction labe, species name (both supplied and inferred from chemical equations),
    # stoichiometries, role speciation and type (solid, dissolved)
    # NOTE: some species may appear in the chemical equations, but are NOT modelled

    uni_species = unique(species_join.substance) # unique species

    dCdt = String[] # contains rate expressions for each species

    for i in uni_species[findall(x -> x != "H", uni_species)] # loop over species (except proton)
        if i == "Age" # age tracer
            push!(dCdt, "S_Age = 1")
        elseif i in species_join.substance
            df = @subset(species_join, :substance .== i)
            conversion_fac = convfac(df)
            # final summed rate expression
            push!(
                dCdt,
                "S_" *
                i *
                " = " *
                rstrip(join(df.stoichiometry .* " * " .* df.label .* conversion_fac, " + ")),
            )
        end
    end

    if "H" in uni_species # for proton
        dH_code = pH_rate(species_join)
        append!(dCdt, dH_code)
    end

    reacspec = uni_species # list of modelled substance
    if "Age" in species_extra.species
        push!(dCdt, "S_Age = 1")
        push!(reacspec, "Age")
    end
    return dCdt, reacspec
end


#-------------------------------------------------------------------------------------------
# Append species reaction rate to total rate of change like "dPOC += S_POC"
# for solid substances the FVCF scheme: dPOC += (1+B_POC)*S_POC
# for dissolved substances the FVCF scheme: dO2 += S_O2,
#-------------------------------------------------------------------------------------------
function dCdt_expr(substances, reacspec, cf)
    substances = @subset(substances, :substance .∈ Ref(reacspec))

    dCdt_expr = String[]

    for i in substances.substance
        push!(dCdt_expr, "d" * i * " += S_" * i)
    end
    dCdt_expr_adv = String[]

    if cf
        # solid
        # species_solid = @subset(substances, .!isnothing.(match.(r"solid$", :type)))
        species_solid = @subset(substances, :type .== "solid")

        for i in species_solid.substance
            push!(dCdt_expr_adv, "mul!(d" * i * ", Bm" * i * ", S_" * i * ", 1.0, 1.0)")
        end
        for i in species_solid.substance
            push!(dCdt_expr_adv, "d" * i * "[1]+=BcBm" * i * "[1]*S_" * i * "[1]")
        end
        for i in species_solid.substance
            push!(dCdt_expr_adv, "d" * i * "[Ngrid]+=BcBm" * i * "[2]*S_" * i * "[Ngrid]")
        end
    end
    return vcat(dCdt_expr, dCdt_expr_adv)
end



function species_in_model(species_join, species_extra)
    # all the modelled species from species_joi and _extra
    spec_in_model =
        @subset(species_extra, :comment .== "modelled but not in chemical equation")
    spec = vcat(spec_in_model.species, species_join.formula)
    unique!(spec)
    spec = split.(spec, ",")
    spec = reduce(vcat, spec)
    spec = split.(spec, "/")
    spec = reduce(vcat, spec)
    spec = split.(spec, "{")

    for i in spec
        if length(i) > 1
            deleteat!(i, 2)
        end
    end

    spec = unique(reduce(vcat, spec))
    return spec
end


#-------------------------------------------------------------------------------------------
# Generate reaction code
#-------------------------------------------------------------------------------------------

function reaction_code(reactions, substances,  speciation_df, cf, discontinuity)

    # parse species from the chemical reaction equations
    species_eq, element_eq = species_from_equation(reactions)
    # join that to the modelled species list
    species_join, species_extra = join_eq_to_model(species_eq, substances, speciation_df)



    # formate rate expressions
    rate_expr, omega_expr = format_rate_expr(reactions, discontinuity)

    # rate expression for each species
    species_rate, reacspec = species_rate_expr(species_join, species_extra)

    # append reaction rate expressions to total rate expressions
    dCdt = dCdt_expr(substances, reacspec, cf)


    code = vcat(
        # isempty(speciation) ? String[] : vcat("# speciation", "@. " .* spec_expr),
        # "",
        "# Individual reaction rates",
        "@. " .* omega_expr,
        "@. " .* rate_expr,
        "",
        "# Summed rates for model substances",
        "@. " .* species_rate,
        "",
        "@. " .* dCdt,
        "",
    )




    # speciation_new = @chain begin
    #     speciation
    #     # @transform(:label = :substance .* "_ligand")
    #     select(:substance,:label, :equation)
    #     @transform(:check = 1)
    # end


    # species_eq_specition, element_eq_speciation = species_from_equation(speciation)
    # transform!(species_eq_specition,:species_eq => (x -> replace.(x, r"[\(\)\[\]]+" => "_")), renamecols = false)
    # transform!(species_eq_specition,:species_eq => (x -> replace.(x, r"\_$" => "")), renamecols = false)
    # transform!(species_eq_specition,:species_eq => (x -> x.*"_aq"), renamecols = false)

    # # join that to the modelled species list
    # species_join_specition, species_extra_specition =
    #     join_eq_to_model(species_eq_specition, substances,adsorption)


    # species_join_all = vcat(species_join,species_join_specition)
    # species_extra_all = vcat(species_extra,species_extra_specition)

    species_modelled = species_in_model(species_join, species_extra)



    # pHspecies = pH_rate_species(species_join_all)
    pHspecies = pH_rate_species(species_join)


    reac_expr = (
        # spec_expr = isempty(speciation) ? String[] : spec_expr,
        rate_expr = rate_expr,
        omega_expr = omega_expr,
        species_rate = species_rate,
    )

    cache_str = vcat(
        # isempty(speciation) ? String[] : spec_expr, 
        omega_expr, rate_expr, species_rate)
    cache_str = split.(cache_str, r"\=|\+\=|\*\=|\-\=|\/\=")
    cache_str = unique([replace(i[1], r"\s" => "") for i in cache_str])

    parsing_df = (
        species_model_df = species_join,
        species_extra_df = species_extra,
        elements_df = element_eq,
    )
    # return code, species_modelled, reac_expr, cache_str, react_jp
    return code, parsing_df, species_modelled, reac_expr, cache_str, pHspecies

end




