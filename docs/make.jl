using AISCSteel
using Documenter

DocMeta.setdocmeta!(AISCSteel, :DocTestSetup, :(using AISCSteel); recursive=false)

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
        "Chapter B - Design Requirements" => "ChapterBDesignRequirements.md",
        "Chapter D - Tension" => "ChapterDTension.md",
        "Chapter E - Compression" => "ChapterECompression.md",
        "Chapter F - Flexure" => "ChapterFFlexure.md",
        "Chapter G - Shear" => "ChapterGShear.md",
        "AISC Steel Shapes" => "Shapes.md",
        "Utils" => "Utils.md",
    ],
)

deploydocs(;
    repo="github.com/co1emi11er2/AISCSteel.jl",
    devbranch="main",
)
