module RoundHSS_Shapes

using StructuralUnits
import AISCSteel
import AISCSteel.Shapes: AbstractSteelShapes

abstract type AbstractRoundHSS_Shapes <: AbstractSteelShapes end

# include Shapes
include("RoundHSS_Shape.jl")

# Include Flexure
include("Flexure/Flexure.jl")

# Include Compression
include("Compression/Compression.jl")

end # module
