
abstract type TEIConfig end

struct ModelConfig <: TEIConfig
    ModelPath::String
    ModelName::String
    UpdateParamOnly::Bool
    JacType::Symbol
    Template::Bool
    AutoDiff::Bool
    CompleteFlux::Bool
    AllowDiscontinuity::Bool
    FastBroadcast::Bool
    UnflattenOp::Bool
    MTK::Bool
end

function ModelConfig(
    ModelPath,
    ModelName;
    UpdateParamOnly = true,
    JacType = :sparse_banded,
    Template = false,
    AutoDiff = true,
    CompleteFlux = false,
    AllowDiscontinuity = false,
    FastBroadcast = true,
    UnflattenOp = true,
    MTK = false,
)
    return ModelConfig(
        ModelPath,
        ModelName,
        UpdateParamOnly,
        JacType,
        Template,
        AutoDiff,
        CompleteFlux,
        AllowDiscontinuity,
        FastBroadcast,
        UnflattenOp,
        MTK,
    )
end


# struct JacConfig <: TEIConfig
#     JacType::Symbol
#     JacFun::Bool
#     JacVec::Bool
# end

# function JacConfig(JacType; JacFun = true, JacVec = false)
#     return JacConfig(JacType, JacFun, JacVec)
# end



struct SolverConfig <: TEIConfig
    chunk_size::Int
    u0::AbstractArray
    tspan::Tuple{Real,Real}
    linsolve::Symbol
    Precondition::Symbol
    reltol::Real
    abstol::Union{Real,AbstractArray}
    callback::Union{Nothing,SciMLBase.DECallback}
    saveat::Union{Nothing,Real,AbstractArray}
    dtmax::Union{Nothing,Real}
    maxiters::Int
end

function SolverConfig(
    chunk_size,
    u0,
    tspan,
    linsolve;
    Precondition = :ILU0,
    reltol = 1e-6,
    abstol = 1e-14,
    callback = nothing,
    saveat = nothing,
    dtmax = nothing,
    maxiters = Int(1e5),
)
    return SolverConfig(
        chunk_size,
        u0,
        tspan,
        linsolve,
        Precondition,
        reltol,
        abstol,
        callback,
        saveat,
        dtmax,
        maxiters,
    )
end

