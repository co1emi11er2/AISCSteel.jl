"""
    module NegativeBending

LShapes bent about their principal minor axis (z-axis) when compression is in the toe of the legs.
"""
module NegativeBending
import AISCSteel
import AISCSteel.ChapterFFlexure.F10.PrincipalAxisBending.MinorAxis as MA
import AISCSteel.ChapterFFlexure.F10.PrincipalAxisBending.MinorAxis.NegativeBending: calc_negative_Mnz
export calc_negative_Mnz

function calc_negative_Mnz((;F_y, S_zA, S_zB, E, b, t)::T, λ_class) where T <: AISCSteel.Shapes.LShapes.AbstractLShapes

    S_min = min(S_zA, S_zB)
    S_c = S_zA

    M_nw = calc_negative_Mnz(F_y, S_min, E, b, t, S_c, λ_class)

    return M_nw
end

end