push!(LOAD_PATH,"../src/")
# using SedTrace
using Documenter




makedocs(
    sitename = "SedTrace.jl",
    # modules  = [SedTrace],
    pages=[
        "Home" => "index.md",
        "User Guide" => "guide.md",
        "Examples" =>  Any[
            "examples/Analytical.md",
            "examples/SimpleFe.md",
            "examples/SBB.md"
        ] 
    ]
)

deploydocs(;
    repo="github.com/JianghuiDu/SedTrace.jl",
)
