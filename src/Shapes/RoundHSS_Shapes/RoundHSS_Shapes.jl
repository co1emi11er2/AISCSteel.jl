module RoundHSS_Shapes

using StructuralUnits
import AISCSteel
import AISCSteel.Shapes: AbstractSteelShapes
import AISCSteel.Database: aisc_database

abstract type AbstractRoundHSS_Shapes <: AbstractSteelShapes end

# include Shapes
include("RoundHSS_Shape.jl")

# Include Flexure
include("Flexure/Flexure.jl")

# Include Compression
include("Compression/Compression.jl")

# ##########################################################################################
# # Database
# ##########################################################################################

function aisc_database(::Type{RoundHSS_Shape})
    csv_file_name = "HSS_R_shapes.csv"
    csv_file_path = joinpath("shape files", csv_file_name)
    AISCSteel.Utils.DatabaseUtils.import_database(csv_file_path)
end

end # module
