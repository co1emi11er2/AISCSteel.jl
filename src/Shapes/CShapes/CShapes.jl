##########################################################################################
# C-Shapes
##########################################################################################
module CShapes

using StructuralUnits
import AISCSteel
import AISCSteel.Shapes: AbstractSteelShapes
abstract type AbstractCShapes <: AbstractSteelShapes end

# include shapes
include("CShape.jl")
include("MCShape.jl")


# # Include Flexure
include("Flexure/Flexure.jl")

# # Include Compression
include("Compression/Compression.jl")

# ##########################################################################################
# # Database
# ##########################################################################################

function cshapes_database()
    csv_file_name = "C_shapes.csv"
    csv_file_path = joinpath("shape files", csv_file_name)
    AISCSteel.Utils.DatabaseUtils.import_database(csv_file_path)
end

function mcshapes_database()
    csv_file_name = "MC_shapes.csv"
    csv_file_path = joinpath("shape files", csv_file_name)
    AISCSteel.Utils.DatabaseUtils.import_database(csv_file_path)
end

end # module
