##########################################################################################
# WT-Shapes
##########################################################################################
module WTShapes

using StructuralUnits
import AISCSteel
import AISCSteel.Shapes: AbstractSteelShapes
abstract type AbstractWTShapes <: AbstractSteelShapes end

# include shapes
include("WTShape.jl")

# include shapes
include("MTShape.jl")

# include shapes
include("STShape.jl")

# Include Flexure
include("Flexure/Flexure.jl")

# Include Compression
include("Compression/Compression.jl")

end # module
