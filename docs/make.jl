using AISCSteel
using Documenter

DocMeta.setdocmeta!(AISCSteel, :DocTestSetup, :(using AISCSteel); recursive=true)

makedocs(;
    modules=[AISCSteel],
    authors="Cole Miller",
    sitename="AISCSteel.jl",
    format=Documenter.HTML(;
        canonical="https://co1emi11er2.github.io/AISCSteel.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/co1emi11er2/AISCSteel.jl",
    devbranch="main",
)
