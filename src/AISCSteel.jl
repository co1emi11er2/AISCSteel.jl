module AISCSteel

##########################################################################################
# Imports
##########################################################################################
using CSV, DataFramesMeta, EnumX, StructuralUnits

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
include("Utils.jl")
include("Conversions.jl")

#include Chapter B - Design Requirements
include("Chapter B - Design Requirements/ChapterBDesignRequirements.jl")

# include Chapter F - Flexure
include("Chapter F - Flexure/ChapterFFlexure.jl")

# include Shapes
include("Shapes/Shapes.jl")



end
