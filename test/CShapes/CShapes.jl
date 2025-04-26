module CShapes
using  Test, TestItems, TestItemRunner

@testitem "Flexure" begin
include("Flexure/Flexure.jl")
end

end