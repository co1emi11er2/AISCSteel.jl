module Shapes

abstract type AbstractSteelShapes end

# include IShapes
include("IShapes/IShapes.jl")

# include CShapes
include("CShapes/CShapes.jl")
end # module
