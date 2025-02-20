"""
    module WT

This section applies to tees loaded in the plane of symmetry.

There are two sections:
- Negative Bending - when tee stems are in compression
- Positive Bending - when tee stems are in tension
"""
module WT

# include Positive Bending
include("PositiveBending.jl")

# include Negative Bending
include("NegativeBending.jl")

end