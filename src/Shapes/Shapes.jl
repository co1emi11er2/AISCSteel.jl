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
end # module
