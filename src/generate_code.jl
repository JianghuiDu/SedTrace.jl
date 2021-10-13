# module CodeGeneration
# using Base: Real
# using ..Config
# ENV["R_HOME"] = "C:\\Program Files\\R\\R-4.0.5"
# using XLSX,
#     # CSV,
#     DataFrames,
#     DataFramesMeta,
#     Chain,
#     SymPy,
#     RCall,
#     Printf,
#     # SpecialFunctions,
#     LinearAlgebra,
#     JuliaFormatter



# export generate_code
function generate_code(modelconfig::ModelConfig)
    if !(modelconfig.JacType in [:banded, :sparse_banded, :sparse])
        throw(
            error(
                "Jacobian of type $(modelconfig.JacType) is not allowed. Choose one from banded, sparse_banded or sparse!",
            ),
        )
    end

    model_config = XLSX.readxlsx(modelconfig.ModelPath)
    # modelName = split(modelconfig.ModelPath, ".")[2]

    if modelconfig.UpdateParamOnly
        ord = [
            "solid",
            "dissolved_adsorbed",
            "dissolved",
            "dissolved_summed",
            "dissolved_summed_pH",
        ]
        orderdict = Dict(x => i for (i, x) in enumerate(ord))
        substances = @chain begin
            DataFrame(XLSX.gettable(model_config["substances"])...)
            @subset(:include .== 1)
            sort!(:type, by = x -> orderdict[x])
        end
        df_str_replace!(substances, [r"\s", r"[\u2212\u2014\u2013]"], ["", "\u002D"])
        substances = @chain begin
            substances
            transform(
                [:top_bc_type, :bot_bc_type] .=> ByRow(x -> lowercase(x)),
                renamecols = false,
            )
            @transform(:order = 1:length(:substance))
        end

        options = DataFrame(XLSX.gettable(model_config["options"])...)

        options = @chain begin
            options
            transform(
                [:options, :value] .=> ByRow(x -> lowercase((replace(x, r"\s" => "")))),
                renamecols = false,
            )
        end
    
    
        parameters = @chain begin
            DataFrame(XLSX.gettable(model_config["parameters"])...)
            @subset(:include .== 1)
            transform(
                [:class, :type, :parameter] .=> ByRow(x -> replace(x, r"\s" => "")),
                renamecols = false,
            )
            transform(
                :value => ByRow(
                    x ->
                        (typeof(x) <: Real || !isnothing(tryparse(Float64, x))) ?
                        x : replace(x, r"\s" => ""),
                ),
                renamecols = false,
            )
        end
        check_illegal_char(select(parameters, :class, :type, :parameter, :value))
        params_code = parameter_code(
            parameters,
            substances,
            options,
            modelconfig.CompleteFlux,
        )

        
        if modelconfig.JacType == :banded || modelconfig.JacType == :sparse_banded
            initval_code("banded", substances,params_code)
        elseif modelconfig.JacType == :sparse
            initval_code("Notbanded", substances,params_code)
        end


        open("parm.$modelName.jl", "w") do io
            for i in params_code
                write(io, i * "\n")
            end
            write(io, "nothing")
        end
        format_file("parm.$modelName.jl", overwrite = true, verbose = true, margin = 80)
        
        return nothing

    end


    # substance must be sorted by TYPE otherwise will NOT get banded jacobian!
    ord = [
        "solid",
        "dissolved_adsorbed",
        "dissolved",
        "dissolved_summed",
        "dissolved_summed_pH",
    ]
    orderdict = Dict(x => i for (i, x) in enumerate(ord))
    substances = @chain begin
        DataFrame(XLSX.gettable(model_config["substances"])...)
        @subset(:include .== 1)
        sort!(:type, by = x -> orderdict[x])
    end

    reactions = @chain begin
        DataFrame(XLSX.gettable(model_config["reactions"])...)
        @subset(:include .== 1)
    end
    speciation = @chain begin
        DataFrame(XLSX.gettable(model_config["speciation"])...)
        @subset(:include .== 1)
    end
    options = DataFrame(XLSX.gettable(model_config["options"])...)
    parameters = @chain begin
        DataFrame(XLSX.gettable(model_config["parameters"])...)
        @subset(:include .== 1)
    end

    # remove empty space or weird minus signs
    df_str_replace!(substances, [r"\s", r"[\u2212\u2014\u2013]"], ["", "\u002D"])
    df_str_replace!(reactions, [r"\s", r"[\u2212\u2014\u2013]"], ["", "\u002D"])
    df_str_replace!(speciation, [r"\s", r"[\u2212\u2014\u2013]"], ["", "\u002D"])

    substances = @chain begin
        substances
        transform(
            [:top_bc_type, :bot_bc_type] .=> ByRow(x -> lowercase(x)),
            renamecols = false,
        )
        @transform(:order = 1:length(:substance))
    end
    options = @chain begin
        options
        transform(
            [:options, :value] .=> ByRow(x -> lowercase((replace(x, r"\s" => "")))),
            renamecols = false,
        )
    end
    parameters = @chain begin
        parameters
        transform(
            [:class, :type, :parameter] .=> ByRow(x -> replace(x, r"\s" => "")),
            renamecols = false,
        )
        transform(
            :value => ByRow(
                x ->
                    (typeof(x) <: Real || !isnothing(tryparse(Float64, x))) ? x :
                    replace(x, r"\s" => ""),
            ),
            renamecols = false,
        )
    end

    check_illegal_char(substances)
    check_illegal_char(reactions)
    check_illegal_char(speciation)
    check_illegal_char(select(options, :options, :value))
    check_illegal_char(select(parameters, :class, :type, :parameter, :value))

    tran_code, tran_cache = transport_code(substances, options, modelconfig.MTK)

    params_code = parameter_code(
        parameters,
        substances,
        options,
        modelconfig.CompleteFlux,
    )

    react_code, react_parameters, react_cache, react_jp = reaction_code(
        reactions,
        substances,
        speciation,
        tran_cache,
        modelconfig.CompleteFlux,
        modelconfig.MTK,
        modelconfig.AllowDiscontinuity,
    )


    cache = unique(vcat(tran_cache, react_cache))
    code = vcat(tran_code, react_code)

    cache_struct = String[]
    for i in cache
        push!(cache_struct, "$i = PreallocationTools.get_tmp(f.$i, C)")
    end
    push!(cache_struct, "")


    if modelconfig.JacType == :banded || modelconfig.JacType == :sparse_banded
        initval_code("banded", substances,params_code)
    elseif modelconfig.JacType == :sparse
        initval_code("Notbanded", substances,params_code)
    end



    if modelconfig.FastBroadcast
        code = replace.(code, r"@\." => "@..")
    end

    if modelconfig.UnflattenOp
        code = replace.(code, r"(?<!\de)\+(?!=)" => "⊕")
        code = replace.(code, r"\*(?!=)" => "⊗")
    end

    if modelconfig.Template
        params = generat_parameter_template(modelconfig.ModelPath)
        param_all = append!(params, react_parameters)
        template_path =
            replace(modelconfig.ModelPath, r".xlsx" => "_parameter_template.xlsx")

        XLSX.writetable(
            template_path,
            overwrite = true,
            parameters = (
                collect(DataFrames.eachcol(param_all)),
                DataFrames.names(param_all),
            ),
        )
    end

    # modelName = split(modelconfig.ModelPath, ".")[2]

    open("parm.$(modelconfig.ModelName).jl", "w") do io
        for i in params_code
            write(io, i * "\n")
        end
        write(io, "nothing")
    end
    format_file("parm.$(modelconfig.ModelName).jl", overwrite = true, verbose = true, margin = 80)

    if !modelconfig.AutoDiff
        open("cache.$(modelconfig.ModelName).jl", "w") do io
            for i in cache
                # write(io, "const $i = @MVector(zeros(Ngrid)) \n")
                write(io, "const $i = zeros(Ngrid) \n")
            end
            # write(io, "nothing")
        end

        header = "function reactran_fvcf_auto(dC,C,parms,t)"
        footer = ["return nothing", "end"]

        open("reactran.$(modelconfig.ModelName).jl", "w") do io
            for i in vcat(header, code, footer)
                write(io, i * "\n")
            end
        end

        format_file("cache.$(modelconfig.ModelName).jl", overwrite = true, verbose = true, margin = 80)
        format_file("reactran.$(modelconfig.ModelName).jl", overwrite = true, verbose = true, margin = 80)
    else
        cache_code = struct_code(cache)

        open("cache.$(modelconfig.ModelName).jl", "w") do io
            for i in vcat(
                "module Cache",
                "using PreallocationTools,ForwardDiff",
                cache_code,
                "end",
            )
                write(io, i * "\n")
            end
            write(io, "nothing")
        end

        header = "function (f::Cache.Reactran)(dC,C,parms,t)"
        footer = ["return nothing", "end"]
        open("reactran.$(modelconfig.ModelName).jl", "w") do io
            for i in vcat(header, cache_struct, code, footer)
                write(io, i * "\n")
            end
        end

        format_file("cache.$(modelconfig.ModelName).jl", overwrite = true, verbose = true, margin = 80)
        format_file("reactran.$(modelconfig.ModelName).jl", overwrite = true, verbose = true, margin = 80)
    end

    jp_str = generate_jacprototype(
        modelconfig.JacType,
        substances,
        react_jp,
        modelconfig.CompleteFlux,
    )
    open("jactype.$(modelconfig.ModelName).jl", "w") do io
        for i in jp_str
            write(io, i * "\n")
        end
    end
    format_file("jactype.$(modelconfig.ModelName).jl", overwrite = true, verbose = true, margin = 80)

    return nothing
end

# end
