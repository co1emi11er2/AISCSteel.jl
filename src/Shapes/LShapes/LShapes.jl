module LShapes

using StructuralUnits
import AISCSteel
import AISCSteel.Shapes: AbstractSteelShapes
import AISCSteel.Database: aisc_database

abstract type AbstractLShapes <: AbstractSteelShapes end

include("LShape.jl")

include("Flexure/Flexure.jl")

include("Compression/Compression.jl")

# ##########################################################################################
# # Database
# ##########################################################################################

function aisc_database(::Type{LShape})
    csv_file_name = "L_shapes.csv"
    csv_file_path = joinpath("shape files", csv_file_name)
    AISCSteel.Utils.DatabaseUtils.import_database(csv_file_path)
end

end
