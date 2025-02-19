using Test, TestItems, TestItemRunner

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

# @testset verbose = true "IShapes" begin
# include("IShapes/IShapes.jl")
# end

# @testset verbose = true "CShapes" begin
#     include("CShapes/CShapes.jl")
# end

# @testset verbose = true "WTShapes" begin
#     include("WTShapes/WTShapes.jl")
# end
@run_package_tests verbose=true