"""
    module NegativeBending

LShapes bent about their principal major axis (w-axis) when compression is in the long leg.
"""
module NegativeBending

import AISCSteel
import AISCSteel.ChapterFFlexure.F10: calc_MnY, calc_MnLTB, calc_MnLLB
import AISCSteel.ChapterFFlexure.F10.PrincipalAxisBending.MajorAxis: calc_variables


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