module CodeGeneration
using SedTrace: ModelConfig
import XLSX
import SymPy
using DataFrames, DataFramesMeta, Chain, RCall, Printf, LinearAlgebra, JuliaFormatter


include("helpers.jl")
include("moleculardiff.jl")
include("generate_reaction.jl")
include("generate_transport.jl")
include("generate_parameter.jl")
include("generate_parameter_template.jl")
include("generate_struct.jl")
include("generate_initval.jl")
include("generate_jacprototype.jl")
include("pH_helpers.jl")
include("identify_parameters.jl")

# export generate_code
function generate_code(modelconfig::ModelConfig, ParamDict::Dict = Dict())
    if !(modelconfig.JacType in [:banded, :sparse_banded, :sparse])
        throw(
            error(
                "Jacobian of type $(modelconfig.JacType) is not allowed. Choose one from banded, sparse_banded or sparse!",
            ),
        )
    end

    model_path = modelconfig.ModelDirectory * modelconfig.ModelFile
    model_config = XLSX.readxlsx(model_path)


    # substance must be sorted by TYPE otherwise will NOT get banded jacobian!
    ord = [
        "dissolved_adsorbed_summed",
        "solid",
        "dissolved",
        "dissolved_adsorbed",
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
    adsorption = @chain begin
        DataFrame(XLSX.gettable(model_config["adsorption"])...)
        @subset(:include .== 1)
    end

    options = DataFrame(XLSX.gettable(model_config["options"])...)
    parameters = @chain begin
        DataFrame(XLSX.gettable(model_config["parameters"])...)
        @subset(:include .== 1)
    end

    if !isempty(ParamDict)
        for (key, value) in ParamDict
            if !in(key,parameters.parameter)
                throw(error("$key is not a parameter!"))
            else
                setval!(parameters, :parameter, key, :value, value)
            end
        end
    end
    # remove empty space or weird minus signs
    df_str_replace!(substances, [r"\s", r"[\u2212\u2014\u2013]"], ["", "\u002D"])
    df_str_replace!(reactions, [r"\s", r"[\u2212\u2014\u2013]"], ["", "\u002D"])
    df_str_replace!(speciation, [r"\s", r"[\u2212\u2014\u2013]"], ["", "\u002D"])
    df_str_replace!(adsorption, [r"\s", r"[\u2212\u2014\u2013]"], ["", "\u002D"])

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
    check_illegal_char(adsorption)
    check_illegal_char(select(options, :options, :value))
    check_illegal_char(select(parameters, :class, :type, :parameter, :value))


    params_code = parameter_code(
        parameters,
        substances,
        adsorption,
        options,
        modelconfig.CompleteFlux,
    )



    if modelconfig.JacType == :banded || modelconfig.JacType == :sparse_banded
        initval_code("banded", substances, params_code)
    elseif modelconfig.JacType == :sparse
        initval_code("Notbanded", substances, params_code)
    end

    open(modelconfig.ModelDirectory * "parm.$(modelconfig.ModelName).jl", "w") do io
        # for i in vcat(params_code,"# Assmeble parameters",param_assemble)
        for i in params_code
            write(io, i * "\n")
        end
        write(io, "nothing")
    end
    format_file(
        modelconfig.ModelDirectory * "parm.$(modelconfig.ModelName).jl",
        overwrite = true,
        verbose = true,
        margin = 80,
    )

    if modelconfig.UpdateParamOnly
        return nothing
    end


    tran_code, tran_expr, tran_cache, ads_summed_expr_str =
        transport_code(substances, adsorption, options, modelconfig.MTK)

    react_code, species_modelled, react_expr, react_cache, react_jp = reaction_code(
        reactions,
        substances,
        speciation,
        adsorption,
        tran_cache,
        ads_summed_expr_str,
        modelconfig.CompleteFlux,
        modelconfig.MTK,
        modelconfig.AllowDiscontinuity,
        modelconfig.ModelDirectory,
    )

    tran_param = identify_param(species_modelled, tran_expr, tran_cache, "tran")
    react_param = identify_param(species_modelled, react_expr, react_cache, "react")

    # if modelconfig.AssembleParam
    #     param_required = @chain begin
    #         outerjoin(tran_param,react_param,on=[:class, :type, :parameter, :value, :unit, :comment])
    #         select!(:parameter,:comment)
    #         groupby(:parameter)
    #         combine(:comment => x->join(x,"/"),renamecols=false)
    #     end
    #     # CSV.write("p.csv",param_required)
    #     ParamDict = String[]
    #     for i in eachrow(param_required)
    #         push!(ParamDict,"\"$(i.parameter)\" => $(i.parameter)")
    #     end

    #     param_assemble = "ParamDict = Dict("*join(ParamDict,",")*")"
    # end




    code = vcat(tran_code, react_code)

    if modelconfig.FastBroadcast
        code = replace.(code, r"@\." => "@..")
    end

    if modelconfig.UnflattenOp
        code = replace.(code, r"(?<!\de)\+(?!=)" => "⊕")
        code = replace.(code, r"\*(?!=)" => "⊗")
    end



    cache = unique(vcat(tran_cache, react_cache))

    if !modelconfig.AutoDiff
        open(modelconfig.ModelDirectory * "cache.$(modelconfig.ModelName).jl", "w") do io
            for i in cache
                # write(io, "const $i = @MVector(zeros(Ngrid)) \n")
                write(io, "const $i = zeros(Ngrid) \n")
            end
            # write(io, "nothing")
        end

        header = "function reactran_fvcf_auto(dC,C,parms,t)"
        footer = ["return nothing", "end"]

        open(modelconfig.ModelDirectory * "reactran.$(modelconfig.ModelName).jl", "w") do io
            for i in vcat(header, code, footer)
                write(io, i * "\n")
            end
        end

        format_file(
            modelconfig.ModelDirectory * "cache.$(modelconfig.ModelName).jl",
            overwrite = true,
            verbose = true,
            margin = 80,
        )
        format_file(
            modelconfig.ModelDirectory * "reactran.$(modelconfig.ModelName).jl",
            overwrite = true,
            verbose = true,
            margin = 80,
        )
    else
        cache_code = struct_code(cache)
        cache_struct = String[]
        for i in cache
            push!(cache_struct, "$i = PreallocationTools.get_tmp(f.$i, C)")
        end
        push!(cache_struct, "")

        open(modelconfig.ModelDirectory * "cache.$(modelconfig.ModelName).jl", "w") do io
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
        open(modelconfig.ModelDirectory * "reactran.$(modelconfig.ModelName).jl", "w") do io
            for i in vcat(header, cache_struct, code, footer)
                write(io, i * "\n")
            end
        end

        format_file(
            modelconfig.ModelDirectory * "cache.$(modelconfig.ModelName).jl",
            overwrite = true,
            verbose = true,
            margin = 80,
        )
        format_file(
            modelconfig.ModelDirectory * "reactran.$(modelconfig.ModelName).jl",
            overwrite = true,
            verbose = true,
            margin = 80,
        )
    end

    jp_str = generate_jacprototype(
        modelconfig.JacType,
        substances,
        adsorption,
        react_jp,
        modelconfig.CompleteFlux,
    )
    open(modelconfig.ModelDirectory * "jactype.$(modelconfig.ModelName).jl", "w") do io
        for i in jp_str
            write(io, i * "\n")
        end
    end
    format_file(
        modelconfig.ModelDirectory * "jactype.$(modelconfig.ModelName).jl",
        overwrite = true,
        verbose = true,
        margin = 80,
    )

    if modelconfig.Template
        params = generat_parameter_template(model_path)
        param_all = append!(params, react_param)
        template_path = replace(model_path, r".xlsx" => "_parameter_template.xlsx")

        XLSX.writetable(
            template_path,
            overwrite = true,
            parameters = (
                collect(DataFrames.eachcol(param_all)),
                DataFrames.names(param_all),
            ),
        )
    end

    return nothing
end


end



