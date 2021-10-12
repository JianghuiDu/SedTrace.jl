
set_zero_subnormals(true)
cd(@__DIR__)
pwd()
using SciMLBase, Sundials, DiffEqCallbacks, Sundials
using SpecialFunctions, PreallocationTools
using DiffEqOperators, Preconditioners, ILUZero, FiniteDiff, ForwardDiff
using LinearAlgebra, SparseArrays, SparseDiffTools, BandedMatrices, FastBroadcast
using DataFramesMeta, DataFrames, CSV, JLD2, DelimitedFiles, XLSX
using Plots, StatsPlots, JuliaFormatter, Dates
using BenchmarkTools
BLAS.set_num_threads(8)
gr(; size = (400, 1000))

include("config.jl")
include("generate_code.jl")
include("generate_jacobian.jl")
include("generate_preconditioner.jl")
include("generate_problem.jl")

input_path = "model_config.HH3000.workingversionnew.xlsx"
modelName = split(input_path, ".")[2]

modelconfig = Config.ModelConfig(
    input_path,
    UpdateParamOnly = false,
    JacType = :banded,
    Template = false,
    AutoDiff = true,
    CompleteFlux = false,
)

CodeGeneration.generate_code(modelconfig)


include("parm.$modelName.jl");
include("cache.$modelName.jl");
include("reactran.$modelName.jl"); # ode
include("jactype.$modelName.jl"); # ode

ForwardDiff.pickchunksize(maximum(matrix_colors(JacType())))

solverconfig = Config.SolverConfig(
    12,
    C_uni,
    (0.0, 3000.0),
    :LapackBand,
    reltol = 1e-6,
    abstol = 1e-16,
    saveat = 1000.0,
    callback = TerminateSteadyState(1e-8, 1e-6, DiffEqCallbacks.allDerivPass),
)


sol = modelrun(solverconfig);





reactran_fvcf = Cache.init(zeros(Ngrid * nspec), Ngrid, Val(chunk_size));

JacFun = generate_jacobian(reactran_fvcf, p_sparse, chunk_size);

# Jv = JacVecOperator(reactran_fvcf,C0,nothing,0.0,autodiff=true);


# reactran = ODEFunction(reactran_fvcf,jac_prototype=Jv);

# @load "sol.$(modelName).jld2" sol;

# C0 = sol[end];

C0 = C_uni;

tspan = (0.0, 15000.0);
prob = ODEProblem(reactran_fvcf, C0, tspan, nothing);
cb = TerminateSteadyState(1e-12, 1e-6, DiffEqCallbacks.allDerivPass);

@time sol = solve(
    prob,
    # QBDF(autodiff=true,chunk_size=chunk_size),
    # CVODE_BDF(linear_solver = :LapackBand, jac_upper = Upbdwth, jac_lower = Lwbdwth),
    # CVODE_BDF(linear_solver = :KLU),
    CVODE_BDF(
        linear_solver = :FGMRES,
        prec = prec,
        psetup = psetup,
        prec_side = 2,
        krylov_dim = Ngrid,
        maxrs = 0,
    ),
    reltol = 1e-6,
    abstol = 1e-15,
    save_everystep = false,
    callback = cb,
    saveat = 500.0,
    # tstops = 5.0,
    # dtmax = 1.0,
    maxiters = Int(1e6),
);
sol.retcode



include("generate_output.jl")
generate_output(["HH3000"], L, true)


@save "sol.$(modelName).n200.u.jld2"
@save "sol.$modelName." * string(Dates.format(now(), "yyyy-mm-dd-HH-MM")) * ".jld2"

C0 = C_uni;
dC0 = zeros(Nmat);
Age = @view C0[AgeID]
dAge = @view dC0[AgeID]

mul!(dAge, AmAge, Age)



@load "sol.$(modelName).n200.u.jld2" sol;
xint = broadcast(x -> x, ξ) # cm # no grid 
xcen = (xint[2:(Ngrid+1)] .+ xint[1:Ngrid]) / 2 # cm # cell center
p = plot(
    nu ./ (a .⊕ sol[end][AgeID]) .⊗ sol[end][POCID],
    -xcen,
    label = "u1600",
    xaxis = :log,
)
@load "sol.$(modelName).n200.p20.jld2" sol;
xint = broadcast(x -> L * (exp(x * L / 20 / L) - 1) / (exp(L / 20) - 1), ξ) # cm # no grid 
xcen = (xint[2:(Ngrid+1)] .+ xint[1:Ngrid]) / 2 # cm # cell center
plot!(p, nu ./ (a .⊕ sol[end][AgeID]) .⊗ sol[end][POCID], -xcen, label = "p20u1600")
@load "sol.$(modelName).n200.p10.jld2" sol;
xint = broadcast(x -> L * (exp(x * L / 10 / L) - 1) / (exp(L / 10) - 1), ξ) # cm # no grid 
xcen = (xint[2:(Ngrid+1)] .+ xint[1:Ngrid]) / 2 # cm # cell center
plot!(p, nu ./ (a .⊕ sol[end][AgeID]) .⊗ sol[end][POCID], -xcen, label = "p10u1600")


@load "sol.$(modelName).n200.u.jld2" sol;
xint = broadcast(x -> x, ξ) # cm # no grid 
xcen = (xint[2:(Ngrid+1)] .+ xint[1:Ngrid]) / 2 # cm # cell center
p = plot(sol[end][POCID], -xcen, label = "u1600", xaxis = :log)
@load "sol.$(modelName).n200.p20.jld2" sol;
xint = broadcast(x -> L * (exp(x * L / 20 / L) - 1) / (exp(L / 20) - 1), ξ) # cm # no grid 
xcen = (xint[2:(Ngrid+1)] .+ xint[1:Ngrid]) / 2 # cm # cell center
plot!(p, sol[end][POCID], -xcen, label = "p20u1600")
@load "sol.$(modelName).n200.p10.jld2" sol;
xint = broadcast(x -> L * (exp(x * L / 10 / L) - 1) / (exp(L / 10) - 1), ξ) # cm # no grid 
xcen = (xint[2:(Ngrid+1)] .+ xint[1:Ngrid]) / 2 # cm # cell center
plot!(p, sol[end][POCID], -xcen, label = "p10u1600")


@load "sol.$(modelName).n200.u.jld2" sol;
xint = broadcast(x -> x, ξ) # cm # no grid 
xcen = (xint[2:(Ngrid+1)] .+ xint[1:Ngrid]) / 2 # cm # cell center
p = plot(sol[end][AgeID], -xcen, label = "u1600", xaxis = :log)
@load "sol.$(modelName).n200.p20.jld2" sol;
xint = broadcast(x -> L * (exp(x * L / 20 / L) - 1) / (exp(L / 20) - 1), ξ) # cm # no grid 
xcen = (xint[2:(Ngrid+1)] .+ xint[1:Ngrid]) / 2 # cm # cell center
plot!(p, sol[end][AgeID], -xcen, label = "p20u1600")
@load "sol.$(modelName).n200.p10.jld2" sol;
xint = broadcast(x -> L * (exp(x * L / 10 / L) - 1) / (exp(L / 10) - 1), ξ) # cm # no grid 
xcen = (xint[2:(Ngrid+1)] .+ xint[1:Ngrid]) / 2 # cm # cell center
plot!(p, sol[end][AgeID], -xcen, label = "p10u1600")


@load "sol.$(modelName).n200.u.jld2" sol;
xint = broadcast(x -> x, ξ) # cm # no grid 
xcen = (xint[2:(Ngrid+1)] .+ xint[1:Ngrid]) / 2 # cm # cell center
p = plot(sol[end][MnID], -xcen, label = "u1600", xaxis = :log)
@load "sol.$(modelName).n200.p20.jld2" sol;
xint = broadcast(x -> L * (exp(x * L / 20 / L) - 1) / (exp(L / 20) - 1), ξ) # cm # no grid 
xcen = (xint[2:(Ngrid+1)] .+ xint[1:Ngrid]) / 2 # cm # cell center
plot!(p, sol[end][MnID], -xcen, label = "p20u1600")
@load "sol.$(modelName).n200.p10.jld2" sol;
xint = broadcast(x -> L * (exp(x * L / 10 / L) - 1) / (exp(L / 10) - 1), ξ) # cm # no grid 
xcen = (xint[2:(Ngrid+1)] .+ xint[1:Ngrid]) / 2 # cm # cell center
plot!(p, sol[end][MnID], -xcen, label = "p10u1600")

@load "sol.$(modelName).n200.u.jld2" sol;
xint = broadcast(x -> x, ξ) # cm # no grid 
xcen = (xint[2:(Ngrid+1)] .+ xint[1:Ngrid]) / 2 # cm # cell center
p = plot(sol[end][NdnrID], -xcen, label = "u1600")
@load "sol.$(modelName).n200.p20.jld2" sol;
xint = broadcast(x -> L * (exp(x * L / 20 / L) - 1) / (exp(L / 20) - 1), ξ) # cm # no grid 
xcen = (xint[2:(Ngrid+1)] .+ xint[1:Ngrid]) / 2 # cm # cell center
plot!(p, sol[end][NdnrID], -xcen, label = "p20u1600")
@load "sol.$(modelName).n200.p10.jld2" sol;
xint = broadcast(x -> L * (exp(x * L / 10 / L) - 1) / (exp(L / 10) - 1), ξ) # cm # no grid 
xcen = (xint[2:(Ngrid+1)] .+ xint[1:Ngrid]) / 2 # cm # cell center
plot!(p, sol[end][NdnrID], -xcen, label = "p10u1600")
