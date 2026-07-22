using Documenter
using FastPower

makedocs(
    sitename = "FastPower.jl",
    modules = [FastPower],
    pages = [
        "Home" => "index.md",
        "API" => "api.md",
    ],
)

deploydocs(repo = "github.com/SciML/FastPower.jl.git"; push_preview = true)
