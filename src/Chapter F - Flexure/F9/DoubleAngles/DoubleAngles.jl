"""
    module DoubleAngles

This section applies to tees loaded in the plane of symmetry.

There are two sections:
- Negative Bending - when leg stems are in compression
- Positive Bending - when leg stems are in tension
"""
module DoubleAngles

# include Positive Bending
include("PositiveBending.jl")

# include Negative Bending
include("NegativeBending.jl")

end