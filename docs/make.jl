push!(LOAD_PATH,"../src/")
using SedTrace
using Documenter
makedocs(
         sitename = "SedTrace.jl",
         modules  = [SedTrace],
         pages=[
                "Home" => "index.md",
                "Manual" => Any[
                    "Guide" => "man/guide.md",
                    "man/examples.md",
                ],
        
               ])
deploydocs(;
    repo="github.com/JianghuiDu/SedTrace.jl",
)
