
abstract type TEIConfig end



struct ModelConfig <: TEIConfig
    ModelDirectory::String
    ModelFile::String
    ModelName::String
    AssembleParam::Bool
    CompleteFlux::Bool
    AllowDiscontinuity::Bool
    FastBroadcast::Bool
    UnflattenOp::Bool
end

function ModelConfig(
    ModelDirectory,
    ModelFile,
    ModelName;
    AssembleParam = true,
    CompleteFlux = false,
    AllowDiscontinuity = false,
    FastBroadcast = true,
    UnflattenOp = true,
)
    return ModelConfig(
        ModelDirectory,
        ModelFile,
        ModelName,
        AssembleParam,
        CompleteFlux,
        AllowDiscontinuity,
        FastBroadcast,
        UnflattenOp,
    )
end



struct SolverConfig <: TEIConfig
    # chunk_size::Int
    linsolve::Symbol
    Precondition::Symbol
    PrecSide::Int
end

function SolverConfig(
    # chunk_size,
    linsolve;
    Precondition = :ILU0,
    PrecSide = 2
)
    return SolverConfig(
        # chunk_size,
        linsolve,
        Precondition,
        PrecSide,
    )
end

struct SolutionConfig <: TEIConfig
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

function SolutionConfig(
    u0,
    tspan;
    reltol = 1e-6,
    abstol = 1e-14,
    callback = nothing,
    saveat = nothing,
    dtmax = nothing,
    maxiters = Int(1e6),
    # tstops = nothing
)
    return SolutionConfig(
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
    sol::SciMLBase.ODESolution
    IntVal::Dict{String,Matrix{Float64}}
end

