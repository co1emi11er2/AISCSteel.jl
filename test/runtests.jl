using Test, TestItems, TestItemRunner

if isdefined(@__MODULE__,:LanguageServer)
    include("../src/AISCSteel.jl")
end

# @testitem "Compression - IShapes" begin
#     include("Compression/IShapes.jl")
# end

# @testitem "Flexure - IShapes" begin
#     include("Flexure/IShapes.jl")
# end

# @testitem "Flexure - CShapes" begin
#     include("Flexure/CShapes.jl")
# end

# @testitem "Compression - WTShapes" begin
#     include("Compression/WTShapes.jl")
# end
# @testitem "Flexure - WTShapes" begin
#     include("Flexure/WTShapes.jl")
# end

include("IShapes/IShapes.jl")


include("CShapes/CShapes.jl")


include("WTShapes/WTShapes.jl")

# @testitem "Flexure - LShapes" begin
#     include("Flexure/LShapes.jl")
# end

# @testitem "Flexure - HSS_Shapes" begin
#     include("Flexure/HSS_Shapes.jl")
# end

# @testitem "Flexure - RoundHSS_Shapes" begin
#     include("Flexure/RoundHSS_Shapes.jl")
# end

@run_package_tests verbose=true