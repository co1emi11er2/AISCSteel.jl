"""
    module MajorAxis

LShapes bent about their principal major axis (w-axis).

There are two sections:
- Positive Bending - when compression is in the short leg
- Negative Bending - when compression is in the long leg
"""
module MajorAxis

# Positive Bending
include("PositiveBending.jl")

# Negative Bending
include("NegativeBending.jl")


end
