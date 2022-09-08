# using UnPack
function jac_react_dependence(
    species_join,
    species_modelled,
    react_expr,
    cache_str,
    ads_expr,
    adsorption,
    pHspecies
)
    UnPack.@unpack  spec_expr, rate_expr, omega_expr ,species_rate = react_expr


    p_spec = find_param_in_expr(species_modelled, spec_expr, cache_str, "react")
    p_par = @subset(p_spec,:isparam)
    @transform!(p_par,:type = "speciation")
    @subset!(p_spec,.!:isparam)
    @select!(p_spec,:label, :variable)

    p_ads = find_param_in_expr_ads(species_modelled, ads_expr, cache_str, adsorption)
    append!(p_par,@transform!(@subset(p_ads,:isparam),:type = "adsorption"))
    @subset!(p_ads,.!:isparam)
    @select!(p_ads,:label, :variable)


    p_omega = find_param_in_expr(species_modelled, omega_expr, cache_str, "react")
    append!(p_par,@transform!(@subset(p_omega,:isparam),:type = "saturation"))
    @subset!(p_omega,.!:isparam)
    @select!(p_omega,:label, :variable)


    p_species_rate = find_param_in_expr(species_modelled, species_rate, cache_str, "react")
    append!(p_par,@transform!(@subset(p_species_rate,:isparam),:type = "reaction rate"))

    p_rate = find_param_in_expr(species_modelled, rate_expr, cache_str, "react")
    append!(p_par,@transform!(@subset(p_rate,:isparam),:type = "reaction rate"))
    @subset!(p_rate,.!:isparam)
    @select!(p_rate,:label, :variable)

    p_all = leftjoin(p_rate, p_rate, on = [:variable => :label], renamecols = "" => "_tmp")
    @transform!(p_all,:variable = ifelse.(ismissing.(:variable_tmp), :variable, :variable_tmp))
    @select!(p_all,:label, :variable)

    p_all = leftjoin(p_all,p_omega, on = [:variable => :label], renamecols = "" => "_tmp")
    @transform!(p_all,:variable = ifelse.(ismissing.(:variable_tmp), :variable, :variable_tmp))
    @select!(p_all,:label, :variable)

    p_all = leftjoin(p_all,p_spec, on = [:variable => :label], renamecols = "" => "_tmp")
    @transform!(p_all,:variable = ifelse.(ismissing.(:variable_tmp), :variable, :variable_tmp))
    @select!(p_all,:label, :variable)

    p_all = leftjoin(p_all,p_ads, on = [:variable => :label], renamecols = "" => "_tmp")
    @transform!(p_all,
            :dependence = ifelse.(ismissing.(:variable_tmp), :variable, :variable_tmp)
    )
    @select!(p_all,:label, :dependence)
    
    
    for i in eachrow(pHspecies)
        if i.sumspecies != "H"
            append!(pHspecies, DataFrame(sumspecies = "H", subspecies = i.subspecies))
        end
    end

    p_all = leftjoin(p_all, pHspecies, on = [:dependence => :subspecies])
    @transform!(p_all,:dependence = ifelse.(ismissing.(:sumspecies), :dependence, :sumspecies))
    @select!(p_all,:label, :dependence)
    unique!(p_all)
    
    species_join_H = @subset(species_join,:substance_type .== "dissolved_summed_pH")
    @select!(species_join_H,:label, :substance)
    @transform!(species_join_H,:substance = "H")
    unique!(species_join_H)

    react_dependence = @select(species_join,:substance, :label)
    react_dependence = outerjoin(react_dependence,species_join_H, on = [:label, :substance])
    unique!(react_dependence)
    react_dependence = leftjoin(react_dependence,p_all, on = :label)
    @select!(react_dependence,:substance, :dependence)
    unique!(react_dependence)
    react_dependence = groupby(react_dependence,:substance)
    react_dependence= combine(react_dependence,:dependence => (x -> join(x, ",")), renamecols = false)


    react_param = @chain begin
        select!(p_par,Not("isparam"))
        groupby([:variable,:type])
        combine(:label => x -> join(x, ",")) # join the reactions of each parameter
        rename!(:label_function => :comment)
        rename!(:variable => :parameter)
    end

    return react_dependence,react_param
end

