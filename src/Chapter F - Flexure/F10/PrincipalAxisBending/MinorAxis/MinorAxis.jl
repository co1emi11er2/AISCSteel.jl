"""
    module MinorAxis

LShapes bent about their principal minor axis (z-axis).

There are two sections:
- Positive Bending - when tension is in the toe of the legs
- Negative Bending - when compression is in the toe of the legs
"""
module MinorAxis
import AISCSteel.Utils.UnitConversions as cnv
import AISCSteel.ChapterFFlexure.F10.PrincipalAxisBending: calc_Fcr, calc_Mcr

# Positive Bending
include("PositiveBending.jl")

# Negative Bending
include("NegativeBending.jl")

end