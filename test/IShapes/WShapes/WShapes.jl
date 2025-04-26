module WShapes
using  Test, TestItems, TestItemRunner

@testitem "Flexure" begin
include("Flexure/Flexure.jl")
end

@testitem "Compression" begin
    include("Compression/Compression.jl")
end

end