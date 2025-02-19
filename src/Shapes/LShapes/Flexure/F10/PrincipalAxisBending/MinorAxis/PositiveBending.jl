"""
    module PositiveBending

LShapes bent about their principal minor axis (z-axis) when tension is in the toe of the legs.
"""
module PositiveBending
import AISCSteel
import AISCSteel.ChapterFFlexure.F10.PrincipalAxisBending.MinorAxis as MA
import AISCSteel.ChapterFFlexure.F10.PrincipalAxisBending.MinorAxis.PositiveBending: calc_positive_Mnz
export calc_positive_Mnz

function calc_positive_Mnz((;F_y, S_zA, S_zB)::T) where T <: AISCSteel.Shapes.LShapes.AbstractLShapes

    S_min = min(S_zA, S_zB)

    M_nw = calc_positive_Mnz(F_y, S_min)

    return M_nw
end
end