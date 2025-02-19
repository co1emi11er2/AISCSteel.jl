module WTShapes
using Test

@testset verbose = true "Flexure" begin
include("Flexure/Flexure.jl")
end

end