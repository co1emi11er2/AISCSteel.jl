"""
    module PositiveBending

LShapes bent about their principal major axis (w-axis) when compression is in the short leg.
"""
module PositiveBending

import AISCSteel
import AISCSteel.ChapterFFlexure.F10.PrincipalAxisBending.MajorAxis as MA
import AISCSteel.ChapterFFlexure.F10.PrincipalAxisBending.MajorAxis.PositiveBending: calc_positive_Mnw
import AISCSteel.Shapes.LShapes.Flexure: classify_leg
export calc_positive_Mnw, calc_variables

function calc_variables((;F_y, S_wC, E, area, r_z, t, β_w , b)::T, L_b, C_b=1) where T <: AISCSteel.Shapes.LShapes.AbstractLShapes
    
    S_min = S_wC
    β_w = β_w
    A_g = area

    (;M_y, M_cr, F_cr) = MA.calc_variables(F_y, S_min, E, A_g, r_z, t, β_w, b, L_b, C_b)

    return (;M_y, M_cr, F_cr)
end

function calc_positive_Mnw((;F_y, S_wC, E, area, r_z, t, β_w , b, S_wA)::T, λ_class::Symbol, L_b, C_b=1) where T <: AISCSteel.Shapes.LShapes.AbstractLShapes

    β_w = β_w
    A_g = area
    S_c = S_wA

    M_nw = calc_positive_Mnw(F_y, S_wC, E, A_g, r_z, t, β_w , b, S_c, λ_class, L_b, C_b)

    return M_nw
end

function calc_positive_Mnw(lshape::T, L_b, C_b=1) where T <: AISCSteel.Shapes.LShapes.AbstractLShapes

    _..., λ_class = classify_leg(lshape)

    M_nw = calc_positive_Mnw(lshape, λ_class, L_b, C_b)

    return M_nw
end

end