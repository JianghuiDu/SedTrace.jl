module CodeGeneration
using SedTrace: ModelConfig
import XLSX
using JLD2,Interpolations
import SymPy
using DataFrames,
    DataFramesMeta, Chain, Printf, 
    LinearAlgebra, JuliaFormatter, UnPack, Parameters


include("helpers.jl")
include("moleculardiff.jl")
include("generate_reaction.jl")
include("generate_transport.jl")
include("generate_parameter.jl")
include("generate_struct.jl")
include("generate_initval.jl")
include("generate_jacprototype.jl")
include("pH_helpers.jl")
include("identify_parameters.jl")
include("preprocessing.jl")
include("parsing_jacobian.jl")
include("generate_parameter_struct.jl")
include("speciation_code.jl")

function generate_code(
    modelconfig::ModelConfig;
    ParamDict::Dict = Dict(),
    EnableList::Dict = Dict(),
)

    #---------------------------------------------------------------------------
    # read Excel sheets and preprocess
    #---------------------------------------------------------------------------
    model_path = modelconfig.ModelDirectory * modelconfig.ModelFile
    model_config = XLSX.readxlsx(model_path)

    for i in ["substances", "reactions", "parameters", "speciation", "adsorption"]
        if !(i in XLSX.sheetnames(model_config))
            throw(error("Sheet $i is not found in $model_path."))
        end
    end

    substances = DataFrame(XLSX.gettable(model_config["substances"]))
    reactions = DataFrame(XLSX.gettable(model_config["reactions"]))
    speciation = DataFrame(XLSX.gettable(model_config["speciation"]))
    adsorption = DataFrame(XLSX.gettable(model_config["adsorption"]))
    parameters = DataFrame(XLSX.gettable(model_config["parameters"]))


    preprocessSubstances!(substances, EnableList)
    preprocessReactions!(reactions, EnableList)
    preprocessAdsorption!(adsorption, EnableList)
    preprocessSpeciation!(speciation, EnableList)
    preprocessParameters!(parameters, ParamDict, EnableList)

    #---------------------------------------------------------------------------
    # generate parameter, transport and reaction code
    #---------------------------------------------------------------------------
    params_code =
        parameter_code(parameters, substances, adsorption, modelconfig.AssembleParam)


    view_code,tran_code, tran_expr, tran_cache = transport_code(substances, adsorption)

    spec_code,spec_expr,spec_cache,speciation_df = speciation_code(substances,speciation,adsorption)

    react_code, parsing_df, species_modelled, react_expr, react_cache, pHspecies =
        reaction_code(
            reactions,
            substances,
            speciation_df,
            modelconfig.CompleteFlux,
            modelconfig.AllowDiscontinuity,
        )

    #---------------------------------------------------------------------------
    # generate jacobian pattern
    #---------------------------------------------------------------------------

    cache_str = unique(vcat(spec_cache,react_cache, tran_cache))
    @unpack species_model_df, species_extra_df, elements_df = parsing_df

    tran_param = identify_tran_param(species_modelled, tran_expr, cache_str)

    react_jp, react_param = jac_react_dependence(
        species_model_df,
        species_modelled,
        spec_expr,
        react_expr,
        cache_str,
        speciation_df,
        pHspecies,
    )

    jp_code = generate_jacprototype(
        substances,
        adsorption,
        react_jp,
        modelconfig.CompleteFlux,
    )


    #---------------------------------------------------------------------------
    # assemble parameters if necessary
    #---------------------------------------------------------------------------
    if modelconfig.AssembleParam
        param_required = generate_parameter_struct(tran_param, react_param, parameters)

        ParamDict = String[]
        for i in eachrow(param_required)
            push!(ParamDict, "$(i.parameter)$(i.jtype) = $(i.parameter)")
        end

        pfile = "$(modelconfig.ModelDirectory)parm.$(modelconfig.ModelName).jl"

        param_struct_code = vcat(
            "module Param",
            "using SedTrace: fvcf,fvcf_bc",
            "using Parameters, LinearAlgebra,SpecialFunctions",
            "include(\"$(escape_string(pfile))\")",
            "",
            "#---------------------------------------------------------------",
            "# assemble parameter struct",
            "#---------------------------------------------------------------",
            "@with_kw mutable struct ParamStruct{T}",
            ParamDict,
            "end",
            "end",
        )
        unpack_str = "@unpack " * join(param_required.parameter, ",") * "=parms"
    
    else
        param_struct_code = [""]
    end


    #---------------------------------------------------------------------------
    # cache code 
    #---------------------------------------------------------------------------

    cache = unique(vcat(spec_cache,tran_cache, react_cache))
    cache_code = vcat(
        "module Cache",
        "using PreallocationTools,ForwardDiff",
        struct_code(cache),
        "end",
    )

    #---------------------------------------------------------------------------
    # reaction-transport code 
    #---------------------------------------------------------------------------
    if modelconfig.AssembleParam
        reactran_header = [
            "function (f::Cache.Reactran)(dC,C,parms::Param.ParamStruct,t)",
            "#---------------------------------------------------------------------",
            "#  Parameters",
            "#---------------------------------------------------------------------",    
            unpack_str,
        ]
    else
        reactran_header = ["function (f::Cache.Reactran)(dC,C,parms,t)"]
    end

    push!(reactran_header, "#---------------------------------------------------------------------")
    push!(reactran_header, "#  Cache")
    push!(reactran_header, "#---------------------------------------------------------------------")

    for i in cache
        push!(reactran_header, "$i = PreallocationTools.get_tmp(f.$i, C)")
    end

    code = vcat(
        "#---------------------------------------------------------------------",
        "#  Model state",
        "#---------------------------------------------------------------------",
        view_code,
        "#---------------------------------------------------------------------",
        "#  Transport of solid and dissolved substances",
        "#---------------------------------------------------------------------",
        tran_code[1],
        "#---------------------------------------------------------------------",
        "#  pH code",
        "#---------------------------------------------------------------------",
        tran_code[2],
        "#---------------------------------------------------------------------",
        "#  Speciation code",
        "#---------------------------------------------------------------------",
        "#  Concentrations of adsorbed/dissolved species",
        spec_code,
        "#  Transport of adsorbed/dissolved species",
        tran_code[3],
        "#---------------------------------------------------------------------",
        "#  Reaction code",
        "#---------------------------------------------------------------------",
        react_code)

    if modelconfig.FastBroadcast
        code = replace.(code, r"@\." => "@..")
    end

    if modelconfig.UnflattenOp
        code = replace.(code, r"(?<!\de)\+(?!=)" => "⊕")
        code = replace.(code, r"\*(?!=)" => "⊗")
    end


    reactran_code = vcat(reactran_header, "",code, ["return nothing", "end"])


    #---------------------------------------------------------------------------
    # write code into julia files and format
    #---------------------------------------------------------------------------
    allcode = (params_code,param_struct_code,cache_code,reactran_code,jp_code)
    tags = ["parm","parm.struct","cache","reactran","jactype"]

    for i in eachindex(allcode)
        open(modelconfig.ModelDirectory * "$(tags[i]).$(modelconfig.ModelName).jl", "w") do io
            # for i in vcat(params_code,"# Assmeble parameters",param_assemble)
            for j in allcode[i]
                write(io, j * "\n")
            end
            # write(io, "nothing")
        end
        format_file(
            modelconfig.ModelDirectory * "$(tags[i]).$(modelconfig.ModelName).jl",
            overwrite = true,
            verbose = true,
            margin = 80,
        )        
    end


    #---------------------------------------------------------------------------
    # write parsing results into excel sheets
    #---------------------------------------------------------------------------
    XLSX.writetable(
        modelconfig.ModelDirectory * "model_parsing_diagnostics."* modelconfig.ModelName * ".xlsx",
        overwrite = true,
        species_in_model = (
            collect(DataFrames.eachcol(species_model_df)),
            DataFrames.names(species_model_df),
        ),
        species_extra = (
            collect(DataFrames.eachcol(species_extra_df)),
            DataFrames.names(species_extra_df),
        ),
        elements_in_reactions = (
            collect(DataFrames.eachcol(elements_df)),
            DataFrames.names(elements_df),
        ),
        reaction_dependency = (
            collect(DataFrames.eachcol(react_jp)),
            DataFrames.names(react_jp),
        ),
        transport_parameters = (
            collect(DataFrames.eachcol(tran_param)),
            DataFrames.names(tran_param),
        ),
        reaction_parameters = (
            collect(DataFrames.eachcol(react_param)),
            DataFrames.names(react_param),
        ),
    )

    return nothing
end


end



