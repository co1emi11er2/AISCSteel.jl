"""
    module NegativeBending

LShapes bent about their principal minor axis (z-axis) when compression is in the toe of the legs.
"""
module NegativeBending

import AISCSteel.ChapterFFlexure.F10: calc_MnY, calc_MnLLB, calc_My, calc_Fcr

"""
    calc_negative_Mnz(F_y, S_min, E, b, t, S_c, λ_class)
    calc_negative_Mnz(lshape, λ_class)
    calc_negative_Mnz(lshape)

Calculates negative moment about the minor principal axis when compression is in the toe of the legs for an LShape.

# Arguments
- `F_y`: yield strength of steel (ksi)
- `S_min`: minimum elastic section modulous about z-axis (inch^3)
- `E`: modulous of elasticity (ksi)
- `b`: length of leg in compression (long leg) (inch)
- `t`: thickness of leg (inch)
- `S_c`: elastic section modulous to the toe in compression relative to the axis of bending (inch^3)
- `λ_class`: slenderness classification of angle leg
"""
function calc_negative_Mnz(F_y, S_min, E, b, t, S_c, λ_class)

    M_y = calc_My(F_y, S_min)
    F_cr = calc_Fcr(E, b, t)

    M_nY = calc_MnY(M_y)
    M_nLLB = calc_MnLLB(λ_class, M_y, F_y, S_c, b, t, E, F_cr)

    M_nw = min(M_nY, M_nLLB)

    return M_nw
end

end