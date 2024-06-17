
function find_param_in_expr(species_modelled, expr_str, cache_str, type)

    param = DataFrame(label = String[], variable = String[], isparam = Bool[])

    if type == "react"
        expr_str_split = @chain begin
            expr_str
            replace.(r"\s" => "")
            # split.(r"[\+\-\*\/]?\=")
            split.(r"[\+\-\*\/]?(?<![\>\<])\=")
        end


        for i in expr_str_split
            variable = myeachmatch(r"\b[A-Za-zΑ-Ωα-ω_][\wΑ-Ωα-ω]*\b(?!\()", i[2])
            if !isnothing(variable)
                variable = unique(variable)

                # variable = filter(x->!(x in preallocate),variable)
                append!(param.variable, variable)
                append!(param.label, fill(i[1], length(variable)))
                append!(param.isparam, fill(false, length(variable)))
            end
        end

    elseif type == "tran"
        for i in expr_str
            variable = myeachmatch(r"\b[A-Za-zΑ-Ωα-ω_][\wΑ-Ωα-ω]*\b(?!\()", i)
            if !isnothing(variable)
                variable = unique(variable)

                # variable = filter(x->!(x in preallocate),variable)
                append!(param.variable, variable)
                append!(param.label, fill("transport", length(variable)))
                append!(param.isparam, fill(false, length(variable)))
            end
        end
    end

    # find which are species (also Omegas) and which are parameters
    for i in eachrow(param)
        if !in(i.variable, species_modelled) &&
           !in(i.variable, cache_str) &&
           !in(i.variable, "d" .* species_modelled)
            i.isparam = true
        end
    end

    return param
end

function find_param_in_expr_ads(species_modelled, expr_str, cache_str,adsorption)

    param = DataFrame(label = String[], variable = String[], isparam = Bool[])
    expr_str_split = @chain begin
        expr_str
        replace.(r"\s" => "")
        split.(r"[\+\-\*\/]?\=")
    end

    for i in expr_str_split
        variable = myeachmatch(r"\b[A-Za-zΑ-Ωα-ω_][\wΑ-Ωα-ω]*\b(?!\()", i[2])
        for j in eachindex(variable)
            if variable[j] in adsorption.adsorbed
                variable[j] = getval!(adsorption,:adsorbed,variable[j],:substance)
            end
            if variable[j] in adsorption.dissolved
                variable[j] = getval!(adsorption,:dissolved,variable[j],:substance)
            end
        end
        if !isnothing(variable)
            variable = unique(variable)

            # variable = filter(x->!(x in preallocate),variable)
            append!(param.variable, variable)
            append!(param.label, fill(i[1], length(variable)))
            append!(param.isparam, fill(false, length(variable)))
        end
    end

    # find which are species (also Omegas) and which are parameters
    for i in eachrow(param)
        if !in(i.variable, species_modelled) &&
           !in(i.variable, cache_str) &&
           !in(i.variable, "d" .* species_modelled)
            i.isparam = true
        end
    end

    return unique(param)
end

# function identify_param(species_modelled, expr_str, cache_str, type)

#     if type == "tran"
#         parameters = @chain begin
#             find_param_in_expr(species_modelled, expr_str, cache_str, "tran")
#             unique()
#             @subset(:isparam) # only parameters
#             select!(:label, :variable)
#             rename!(:variable => :parameter)
#             groupby(:parameter)
#             @transform!(:class = "transport")
#             @transform!(:type = "")
#             @transform!(:value = "")
#             @transform!(:unit = "")
#             @transform!(:comment = find_param_type.(:parameter))
#             select!(:class, :parameter, :comment)
#             sort!([:comment, :parameter])
#         end
#         return parameters

#     elseif type == "react"
#         parameters = @chain begin
#             find_param_in_expr(species_modelled, expr_str, cache_str, "react")
#             unique!()
#             @subset!(:isparam) # only parameters
#             select!(:label, :variable)
#             rename!(:variable => :parameter)
#             groupby(:parameter)
#             combine(:label => x -> join(x, ",")) # join the reactions of each parameter
#             rename!(:label_function => :comment)
#             @transform!(:class = "reaction")
#             @transform!(:type = "")
#             @transform!(:value = "")
#             @transform!(:unit = "")
#             select(:class, :parameter, :comment)
#         end
#         return parameters
#     end
# end

# function find_param_type(param)

#     if !isnothing(match(r"\w+ID\b", param))
#         return "index"
#     end
#     if !isnothing(match(r"\bAm\w+", param))
#         return "interior transport"
#     end
#     if !isnothing(match(r"\b((BcAm)|(BcCm))\w+", param))
#         return "boundary transport"
#     end
#     if !isnothing(match(r"\w+((BW)|0)\b", param))
#         return "bottom water"
#     end
#     return "others"
# end


function identify_tran_param(species_modelled, expr_str, cache_str)

    comment = ["index","transport matrix","boundary condition","bioirrigation","adsorption","pH"]
    tran_param = DataFrame(label = String[],variable = String[],isparam=Bool[],type =String[])

    for i in eachindex(comment)
        p_par = find_param_in_expr(species_modelled, expr_str[i], cache_str, "tran")
        @subset!(p_par,:isparam)
        @transform!(p_par,:type=comment[i])
        unique!(p_par)
        append!(tran_param,p_par)
    end

    select!(tran_param,Not([:isparam,:label]))
    rename!(tran_param,:variable => :parameter)

    return tran_param
end