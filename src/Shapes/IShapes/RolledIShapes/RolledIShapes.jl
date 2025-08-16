module RolledIShapes

using StructuralUnits
import AISCSteel.Database: aisc_database

import AISCSteel.Shapes.IShapes: AbstractRolledIShapes
import AISCSteel

# include Shapes
include("WShape.jl")
include("SShape.jl")
include("MShape.jl")
include("HPShape.jl")

# # Include Flexure
include("Flexure/Flexure.jl")

# # Include Compression
include("Compression/Compression.jl")


# ##########################################################################################
# # Database
# ##########################################################################################

function aisc_database(::Type{WShape})
    csv_file_name = "W_shapes.csv"
    csv_file_path = joinpath("shape files", csv_file_name)
    AISCSteel.Utils.DatabaseUtils.import_database(csv_file_path)
end

function aisc_database(::Type{MShape})
    csv_file_name = "M_shapes.csv"
    csv_file_path = joinpath("shape files", csv_file_name)
    AISCSteel.Utils.DatabaseUtils.import_database(csv_file_path)
end

function aisc_database(::Type{SShape})
    csv_file_name = "S_shapes.csv"
    csv_file_path = joinpath("shape files", csv_file_name)
    AISCSteel.Utils.DatabaseUtils.import_database(csv_file_path)
end

function aisc_database(::Type{HPShape})
    csv_file_name = "HP_shapes.csv"
    csv_file_path = joinpath("shape files", csv_file_name)
    AISCSteel.Utils.DatabaseUtils.import_database(csv_file_path)
end

end # module
