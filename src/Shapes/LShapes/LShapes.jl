module LShapes

using StructuralUnits
import AISCSteel
import AISCSteel.Shapes: AbstractSteelShapes
abstract type AbstractLShapes <: AbstractSteelShapes end

include("LShape.jl")

include("Flexure/Flexure.jl")
end
