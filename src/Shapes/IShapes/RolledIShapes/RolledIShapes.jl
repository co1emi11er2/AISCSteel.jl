module RolledIShapes

using StructuralUnits
import AISCSteel.Shapes.IShapes: AbstractRolledIShapes
import AISCSteel


# include Shapes
include("WShape.jl")
# include("SShape.jl")
# include("MShape.jl")
# include("HPShape.jl")

# # Include Flexure
include("Flexure/Flexure.jl")



end # module