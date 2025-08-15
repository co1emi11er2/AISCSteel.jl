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

# ##########################################################################################
# # Database
# ##########################################################################################

function wtshapes_database()
    csv_file_name = "WT_shapes.csv"
    csv_file_path = joinpath("shape files", csv_file_name)
    AISCSteel.Utils.DatabaseUtils.import_database(csv_file_path)
end

function mtshapes_database()
    csv_file_name = "MT_shapes.csv"
    csv_file_path = joinpath("shape files", csv_file_name)
    AISCSteel.Utils.DatabaseUtils.import_database(csv_file_path)
end

function stshapes_database()
    csv_file_name = "sT_shapes.csv"
    csv_file_path = joinpath("shape files", csv_file_name)
    AISCSteel.Utils.DatabaseUtils.import_database(csv_file_path)
end

end # module
