using TestItems, TestItemRunner

if isdefined(@__MODULE__,:LanguageServer)
    include("../src/AISCSteel.jl")
end

@testitem "Flexure - IShapes" begin
    include("Flexure/IShapes.jl")
end

@testitem "Flexure - CShapes" begin
    include("Flexure/CShapes.jl")
end

@testitem "Flexure - WTShapes" begin
    include("Flexure/WTShapes.jl")
end

@testitem "Flexure - LShapes" begin
    include("Flexure/LShapes.jl")
end

@run_package_tests verbose=true