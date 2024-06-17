
# used in reactions
#-------------------------------------------------------------------------------------------
## helper functions dealing with operations on strings
#-------------------------------------------------------------------------------------------
function mymatch(reg, str, nothing_replace = nothing)
    # find a single match of a string using regex
    res = match(reg, str)
    if isnothing(res) # no match
        return nothing_replace
    else
        return getfield(res, :match) # return matched string
    end
end

function myeachmatch(reg, str, nothing_replace = nothing)
    # find multiple matches of a string using regex
    res = eachmatch(reg, str)
    if isempty(res) # no match
        return nothing_replace
    else
        return getfield.(res, :match) # return all matched strings
    end
end

function str_in(str1::Union{String,Array{String}}, str2::Array{String})
    # if str1 (array or single) is in str2 (array)
    if typeof(str1) == String
        return str1 in str2
    else
        return [i in str2 for i in str1]
    end
end

function to_rational(x) # input x is a string expression
    # convert to rational format in symbolic calculations
    x = replace(x, "/" => "//") # escape "/"
    x = eval(Meta.parse(x)) # evaluate x, in case it's a number 
    if typeof(x) <: SymPy.Sym # if x is a symbolic expression
        y = SymPy.simplify(x, tolerance = 1e-15, rational = false)
        y = "(" * string(y) * ")"
    else
        if isinteger(x) # if x is an integer
            y = Int(x)
        elseif typeof(x) <: Rational
            y = x
        else  # if x is a non-integer number
            y = rationalize(x)
        end
    end
    y = replace(string(y), "//" => "/") # go back to "/"
end

function str_simplify(str::Array{String})
    # simplify in symbolic calculations
    # find strings in coefficients and convert to symbolic variables
    coef_vars = filter(!isnothing, myeachmatch.(r"[A-Za-z]+", str))
    if !isempty(coef_vars)
        coef_sym = Meta.parse("SymPy.@syms " * join(unique(vcat(coef_vars...)), " "))
        eval(coef_sym)
    end
    return to_rational.(str)
end


function df_str_replace!(df::DataFrame, strs_old, strs_new)
    # replace strings in a dataframe
    transform!(
        df,
        names(df) .=> (x -> passmissing(multi_replace).(x, Ref(strs_old), Ref(strs_new))),
        renamecols = false,
    )
end

function df_str_replace!(df::DataFrame, strs_old::Regex, strs_new::Union{String,Char})
    # replace strings in a dataframe
    transform!(
        df,
        names(df) .=>
            (x -> passmissing(replace).(passmissing(string).(x), strs_old => strs_new)),
        renamecols = false,
    )
end

function multi_replace(x, str1, str2)
    x = string(x)
    for i in eachindex(str1)
        x = replace(x, str1[i] => str2[i])
    end
    return x
end




# # helper functions
# function mymatch(reg, str, nothing_replace = nothing)
#     # find a single match of a string using regex
#     res = match(reg, str)
#     if isnothing(res) # no match
#         return nothing_replace
#     else
#         return getfield(res, :match) # return matched string
#     end
# end

function setval!(df, coltoindex, rowtoindex, coltosetval, val)
    rowID = findfirst(x -> x .== rowtoindex, df[!, coltoindex])
    setindex!(df, val, rowID, coltosetval)
end

function getval!(df, coltoindex, rowtoindex, coltogetval)
    rowID = findfirst(x -> x .== rowtoindex, df[!, coltoindex])
    if isnothing(rowID)
        nothing
    else
        getindex(df, rowID, coltogetval)
    end
end

function getNumber!(df, coltoindex, rowtoindex, coltogetval)
    rowID = findfirst(x -> x .== rowtoindex, df[!, coltoindex])
    tmp = getindex(df, rowID, coltogetval)
    typeof(tmp) <: Real ? tmp : parse(Float64, tmp)
end

function getvalALL!(df, coltoindex, rowtoindex, coltogetval)
    rowID = findall(x -> x .== rowtoindex, df[!, coltoindex])
    getindex(df, rowID, coltogetval)
end


function appendtostr!(str, df, comment,assemble=false,bcast=true)
    if isempty(df)
        return nothing
    else
        push!(str, "")
        push!(str, "#----------------------------------------------")
        push!(str, "# " * comment)
        push!(str, "#----------------------------------------------")
        header = assemble ? "" : "const "
        append!(
            str,
            header .* df.parameter .* " = " .* ifelse.(
                (df.type .== "function") .&& bcast,
                "broadcast(x->" .* string.(df.value) .* ",x)",
                string.(df.value),
            ) .* " # " .* string.(df.unit) .* " # " .* string.(df.comment),
        )
    end
end

function densitySW(depth, temp, salinity)
    _depth = depth[1]
    _temp = temp[1]
    _salinity = salinity[1]

    (
        999.842594 + 6.793952 * 1e-2 * _temp - 9.095290 * 1e-3 * _temp^2 +
        1.001685 * 1e-4 * _temp^3 - 1.120083 * 1e-6 * _temp^4 +
        6.536332 * 1e-9 * _temp^5 +
        (
            8.24493 * 1e-1 - 4.0899 * 1e-3 * _temp + 7.6438 * 1e-5 * _temp^2 -
            8.2467 * 1e-7 * _temp^3 + 5.3875 * 1e-9 * _temp^4
        ) * _salinity +
        (-5.72466 * 1e-3 + 1.0227 * 1e-4 * _temp - 1.6546 * 1e-6 * _temp^2) *
        _salinity^0.5 +
        4.8314 * 1e-4 * _salinity^2
    ) / 1000.0
end


function newdf()
    DataFrame(
        type = String[],
        parameter = String[],
        value = Any[],
        unit = String[],
        comment = String[],
    )
end



nothing
