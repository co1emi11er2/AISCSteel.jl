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
        collapselevel=1,
    ),
    pages=[
        "Introduction" => [
            "Home" => "index.md",
            "Getting Started" => "GettingStarted.md",
        ],
        "Examples" => [
            "WShapes" => "WShape Example.md",
            "CShapes" => "CShape Example.md",
            "LShapes" => "LShape Example.md",
            "WTShapes" => "WTShape Example.md",
            "HSS_Shapes" => "HSS_Shape Example.md",
            "RoundHSS_Shapes" => "RoundHSS_Shape Example.md",
            "Working with AISC Databases" => "Database Example.md",
        ],
        "AISC Steel Shapes API" => [
            "Shapes API/IShapes API.md",
            "Shapes API/CShapes API.md",
            "Shapes API/WTShapes API.md",
            "Shapes API/LShapes API.md",
            "Shapes API/HSS_Shapes API.md",
            "Shapes API/RoundHSS_Shapes API.md",
        ],
        "Chapters" => [
            "Chapter B - Design Requirements" => "ChapterBDesignRequirements.md",
            "Chapter D - Tension" => "ChapterDTension.md",
            "Chapter E - Compression" => "ChapterECompression.md",
            "Chapter F - Flexure" => "ChapterFFlexure.md",
            "Chapter G - Shear" => "ChapterGShear.md",
        ],
        "Utils" => "Utils.md",
    ],
)

deploydocs(;
    repo="github.com/co1emi11er2/AISCSteel.jl",
    devbranch="main",
)
