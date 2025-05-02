"""
    module E5

This section applies to single-angle compression members.
"""
module E5
using StructuralUnits

# include equations
include("Equations.jl")

##########################################################################################
# Equations below are the public API for E5
##########################################################################################

include("LongLeg.jl")
include("ShortLeg.jl")

end
