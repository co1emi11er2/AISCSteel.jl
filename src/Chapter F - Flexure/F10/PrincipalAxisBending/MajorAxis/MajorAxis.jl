"""
    module MajorAxis

LShapes bent about their principal major axis (w-axis).

There are two sections:
- Positive Bending - when compression is in the short leg
- Negative Bending - when compression is in the long leg
"""
module MajorAxis
import AISCSteel.ChapterFFlexure.F10: calc_Fcr, calc_My
import AISCSteel.ChapterFFlexure.F10.PrincipalAxisBending: calc_Mcr

function calc_variables(F_y, S_min, E, A_g, r_z, t, β_w, b, L_b, C_b)
    M_y = calc_My(F_y, S_min)
    M_cr = calc_Mcr(E, A_g, r_z, t, C_b, L_b, β_w)
    F_cr = calc_Fcr(E, b, t)

    return (;M_y, M_cr, F_cr)
end

# Positive Bending
include("PositiveBending.jl")

# Negative Bending
include("NegativeBending.jl")

end