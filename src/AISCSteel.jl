module AISCSteel

##########################################################################################
# Imports
##########################################################################################
using CSV, DataFramesMeta, EnumX, StructuralUnits, PrecompileTools

##########################################################################################
# Exports
##########################################################################################


##########################################################################################
# Paths
##########################################################################################

# Directories
projectdir(parts...) = normpath(joinpath(@__DIR__, "..", parts...))
datadir(parts...) = normpath(joinpath(@__DIR__, "..", "data", parts...))

##########################################################################################
# Constants
##########################################################################################

# Constant Units
include("Units.jl")

##########################################################################################
# Includes
##########################################################################################

# include utilities
include("Utils/Utils.jl")

#include Chapter B - Design Requirements
include("Chapter B - Design Requirements/ChapterBDesignRequirements.jl")

# include Chapter E - Compression
include("Chapter E - Compression/ChapterECompression.jl")

# include Chapter F - Flexure
include("Chapter F - Flexure/ChapterFFlexure.jl")

# include Shapes
include("Shapes/Shapes.jl")

# include precompilation
include("precompile.jl")

end
