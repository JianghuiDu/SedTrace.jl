
function generate_parameter_struct(tran_param,react_param,parameters)

    param_required = @chain begin
        tran_param
        append!(select(react_param,:parameter,:type))
        unique!()
        @transform!(:jtype = "")
    end

    parameters_func = @subset(parameters,:type.=="function")

    for i in eachrow(param_required)
        if i.parameter == "Ngrid"
            i.jtype = "::Int64"
        elseif i.type == "index"
            i.jtype = "::StepRange{Int64, Int64}"
        elseif i.parameter in parameters_func.parameter
            i.jtype = "::Vector{T}"
        elseif i.parameter in ["dstopw","pwtods","phi","Dbt","Dbir","alpha","x"]
            i.jtype = "::Vector{T}"
        elseif i.type == "transport matrix"
            i.jtype = "::Tridiagonal{T, Vector{T}}"
        elseif i.type == "boundary condition"
            i.jtype = "::Vector{T}"
        else
            i.jtype = "::T"
        end
    end
    select!(param_required,Not(:type))
    unique!(param_required)
    # @subset!(param_required,:parameter.!="Ngrid")
    return param_required
end