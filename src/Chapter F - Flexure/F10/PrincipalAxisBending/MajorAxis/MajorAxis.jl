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

"""
    calc_variables(F_y, S_min, E, A_g, r_z, t, β_w, b, L_b, C_b)

Calculates the intermediate variables needed to then solve for moment capacities of the LShape.

# Arguments
- `F_y`: yield strength of steel (ksi)
- `S_min`: elastic section modulous for desired axis (x or y) (inch^3)
- `E`: modulous of elasticity (ksi)
- `A_g`: gross section area of lshape (inch^2)
- `r_z`: radius of gyration about the minor principal axis (inch)
- `t`: thickness of leg (inch)
- `β_w`: section property for single angles about major principal axis (inch)
- `b`: length of leg in compression (long leg) (inch)
- `L_b`: unbraced length (inch)
- `C_b`: lateral torsional buckling modification factor (default = 1)

# Returns
    (;M_y, M_cr, F_cr)
- `M_y`: yield moment of the section bent about the respective axis (kip-in)
- `M_cr`: elastic lateral-torsional buckling moment of the section bent about the respective axis (kip-in)
- `F_cr`: critical stress (ksi)

# Reference
- AISC Section F10
"""
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