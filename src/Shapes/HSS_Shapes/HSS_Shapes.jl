module HSS_Shapes

using StructuralUnits
import AISCSteel
import AISCSteel.Shapes: AbstractSteelShapes

abstract type AbstractHSS_Shapes <: AbstractSteelShapes end

# include Shapes
include("HSS_Shape.jl")

end # module
