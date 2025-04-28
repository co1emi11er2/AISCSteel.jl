using Revise
using AISCSteel
using Documenter

DocMeta.setdocmeta!(AISCSteel, :DocTestSetup, :(using AISCSteel); recursive=false)

makedocs(;
    modules=[AISCSteel],
    checkdocs=:none,
    authors="Cole Miller",
    sitename="AISCSteel.jl",
    format=Documenter.HTML(;
        canonical="https://co1emi11er2.github.io/AISCSteel.jl",
        edit_link="main",
        assets=String[],
        size_threshold_warn=200 * 2^10, # raise slightly from 100 to 200 KiB
        size_threshold=300 * 2^10,      # raise slightly 200 to to 300 KiB
    ),
    pages=[
        "Home" => "index.md",
        "Getting Started" => "GettingStarted.md",
        "WShape Example" => "WShape Example.md",
        "WTShape Example" => "WTShape Example.md",
        "CShape Example" => "CShape Example.md",
        "HSS_Shape Example" => "HSS_Shape Example.md",
        "RoundHSS_Shape Example" => "RoundHSS_Shape Example.md",
        "AISC Steel Shapes" => "Shapes.md",
        "Chapter B - Design Requirements" => "ChapterBDesignRequirements.md",
        "Chapter D - Tension" => "ChapterDTension.md",
        "Chapter E - Compression" => "ChapterECompression.md",
        "Chapter F - Flexure" => "ChapterFFlexure.md",
        "Chapter G - Shear" => "ChapterGShear.md",
        "Utils" => "Utils.md",
    ],
)

deploydocs(;
    repo="github.com/co1emi11er2/AISCSteel.jl",
    devbranch="main",
)
