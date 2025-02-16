"""
    module NegativeBending

LShapes bent about their principal major axis (w-axis) when compression is in the long leg.
"""
module NegativeBending

import AISCSteel
import AISCSteel.ChapterFFlexure.F10.PrincipalAxisBending as PAB
import AISCSteel.ChapterFFlexure.F10.PrincipalAxisBending.MajorAxis.NegativeBending: calc_negative_Mnw
export calc_negative_Mnw, calc_variables

function calc_variables((;F_y, S_wC, E, area, r_z, t, β_w , b)::T, L_b, C_b=1) where T <: AISCSteel.Shapes.LShapes.AbstractLShapes
    
    S_min = S_wC
    β_w = -β_w
    A_g = area

    (;M_y, M_cr, F_cr) = PAB.calc_variables(F_y, S_min, E, area, r_z, t, C_b, L_b, β_w, b)

    return (;M_y, M_cr, F_cr)
end

function calc_negative_Mnw((;F_y, S_wC, E, area, r_z, t, β_w , b)::T, λ_class, L_b, C_b=1) where T <: AISCSteel.Shapes.LShapes.AbstractLShapes

    β_w = -β_w
    A_g = area
    S_c = S_wC

    M_nw = calc_negative_Mnw(F_y, S_wC, E, A_g, r_z, t, β_w , b, S_c, λ_class, L_b, C_b)

    return M_nw
end

end