##########################################################################################
# C-Shapes
##########################################################################################
module CShapes

using StructuralUnits
import AISCSteel
import AISCSteel.Shapes: AbstractSteelShapes
import AISCSteel.Database: aisc_database

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

function aisc_database(::Type{CShape})
    csv_file_name = "C_shapes.csv"
    csv_file_path = joinpath("shape files", csv_file_name)
    AISCSteel.Utils.DatabaseUtils.import_database(csv_file_path)
end

function aisc_database(::Type{MCShape})
    csv_file_name = "MC_shapes.csv"
    csv_file_path = joinpath("shape files", csv_file_name)
    AISCSteel.Utils.DatabaseUtils.import_database(csv_file_path)
end

end # module
