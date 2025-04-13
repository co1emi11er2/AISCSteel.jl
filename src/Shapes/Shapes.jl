module Shapes

abstract type AbstractSteelShapes end

# include IShapes
include("IShapes/IShapes.jl")

# include CShapes
include("CShapes/CShapes.jl")

# include WTShapes
include("WTShapes/WTShapes.jl")

# include LShapes
include("LShapes/LShapes.jl")

# include HSS_Shapes
include("HSS_Shapes/HSS_Shapes.jl")

# include RoundHSS_Shapes
include("RoundHSS_Shapes/RoundHSS_Shapes.jl")
end # module
