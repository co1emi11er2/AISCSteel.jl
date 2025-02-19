"""
    module GeometricAxisBending

LShapes bent about their geometric axis (x-axis, y-axis).

There are two sections:
- Positive Bending - when compression is in the toe of the leg
- Negative Bending - when tension is in the toe of the leg
"""
module GeometricAxisBending

# include Positive Bending
include("PositiveBending.jl")

# include Negative Bending
include("NegativeBending.jl")

end