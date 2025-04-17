"""
    module E4

This section applies to singly symmetric and unsymmetric members, certain doubly symmetric 
members, such as cruciform or built-up members, and doubly symmetric members when the 
torsional unbraced length exceeds the lateral unbraced length, all without slender elements. 
These provisions also apply to single angles with `` b/t > 0.71*sqrt{E/F_y} ``
"""
module E4
using StructuralUnits

# include equations
include("Equations.jl")

##########################################################################################
# Equations below are the public API for E4
##########################################################################################

end