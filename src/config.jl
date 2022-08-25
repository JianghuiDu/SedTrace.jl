
abstract type TEIConfig end



struct ModelConfig <: TEIConfig
    ModelDirectory::String
    ModelFile::String
    ModelName::String
    UpdateParamOnly::Bool
    JacType::Symbol
    AssembleParam::Bool
    Template::Bool
    AutoDiff::Bool
    CompleteFlux::Bool
    AllowDiscontinuity::Bool
    FastBroadcast::Bool
    UnflattenOp::Bool
    MTK::Bool
end

function ModelConfig(
    ModelDirectory,
    ModelFile,
    ModelName;
    UpdateParamOnly = true,
    JacType = :sparse_banded,
    AssembleParam = false,
    Template = false,
    AutoDiff = true,
    CompleteFlux = false,
    AllowDiscontinuity = false,
    FastBroadcast = true,
    UnflattenOp = true,
    MTK = false,
)
    return ModelConfig(
        ModelDirectory,
        ModelFile,
        ModelName,
        UpdateParamOnly,
        JacType,
        AssembleParam,
        Template,
        AutoDiff,
        CompleteFlux,
        AllowDiscontinuity,
        FastBroadcast,
        UnflattenOp,
        MTK,
    )
end



struct SolverConfig <: TEIConfig
    chunk_size::Int
    linsolve::Symbol
    Precondition::Symbol
    PrecSide::Int
end

function SolverConfig(
    chunk_size,
    linsolve;
    Precondition = :ILU0,
    PrecSide = 1
)
    return SolverConfig(
        chunk_size,
        linsolve,
        Precondition,
        PrecSide,
    )
end

struct SolverCtrlConfig <: TEIConfig
    u0::AbstractArray
    tspan::Tuple{Real,Real}
    reltol::Real
    abstol::Union{Real,AbstractArray}
    callback::Union{Nothing,SciMLBase.DECallback}
    saveat::Union{Nothing,Real,AbstractArray}
    dtmax::Union{Nothing,Real}
    maxiters::Int
    # tstops::Union{Nothing,Real}
end

function SolverCtrlConfig(
    u0,
    tspan;
    reltol = 1e-6,
    abstol = 1e-14,
    callback = nothing,
    saveat = nothing,
    dtmax = nothing,
    maxiters = Int(1e5),
    # tstops = nothing
)
    return SolverCtrlConfig(
        u0,
        tspan,
        reltol,
        abstol,
        callback,
        saveat,
        dtmax,
        maxiters,
        # tstops
    )
end

struct OutputConfig
    x::Vector{Float64}
    L::Float64
    Ngrid::Int
    IDdict::Dict{String, StepRange{Int64, Int64}}
end

struct SolutionConfig
    sol::SciMLBase.ODESolution
    x::Vector{Float64}
    L::Float64
    Ngrid::Int
    IDdict::Dict{String, StepRange{Int64, Int64}}
    VarVal::Dict{String,Matrix{Float64}}
end

