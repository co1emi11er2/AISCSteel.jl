"""
    module NegativeBending

LShapes bent about their principal major axis (w-axis) when compression is in the long leg.
"""
module NegativeBending

import AISCSteel
import AISCSteel.ChapterFFlexure.F10: calc_MnY, calc_MnLTB, calc_MnLLB
import AISCSteel.ChapterFFlexure.F10.PrincipalAxisBending.MajorAxis: calc_variables

"""
    calc_negative_Mnw(F_y, S_wC, E, A_g, r_z, t, β_w , b, S_c, λ_class, L_b, C_b)
    calc_negative_Mnw(lshape, λ_class, L_b, C_b)
    calc_negative_Mnw(lshape, L_b, C_b)

Calculates negative moment about major principal axis when compression is in the long leg for an LShape.

# Arguments
- `F_y`: yield strength of steel (ksi)
- `S_wC`: elastic section modulous about w-axis for Point C (see aisc-shapes-database-v16.0) (inch^3)
- `E`: modulous of elasticity (ksi)
- `A_g`: gross section area of lshape (inch^2)
- `r_z`: radius of gyration about the minor principal axis (inch)
- `t`: thickness of leg (inch)
- `β_w`: section property for single angles about major principal axis (inch)
- `b`: length of leg in compression (long leg) (inch)
- `S_c`: elastic section modulous to the toe in compression relative to the axis of bending (inch^3)
- `λ_class`: slenderness classification of angle leg
- `L_b`: unbraced length (inch)
- `C_b`: lateral torsional buckling modification factor (default = 1)
"""
function calc_negative_Mnw(F_y, S_wC, E, A_g, r_z, t, β_w , b, S_c, λ_class, L_b, C_b)

    S_min = S_wC

    (;M_y, M_cr, F_cr) = calc_variables(F_y, S_min, E, A_g, r_z, t, β_w, b, L_b, C_b)

    M_nY = calc_MnY(M_y)
    M_nLTB = calc_MnLTB(M_y, M_cr)
    M_nLLB = calc_MnLLB(λ_class, M_y, F_y, S_c, b, t, E, F_cr)

    M_nw = min(M_nY, M_nLTB, M_nLLB)

    return M_nw
end

end