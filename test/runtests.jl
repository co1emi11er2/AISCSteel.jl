using TestItems, TestItemRunner

if isdefined(@__MODULE__,:LanguageServer)
    include("../src/AISCSteel.jl")
end
@testitem "Flexure - F2" begin
    include("Flexure/F2.jl")
end

@run_package_tests verbose=true