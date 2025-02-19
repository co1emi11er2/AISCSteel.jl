"""
    module PositiveBending

LShapes bent about their geometric axis (x-axis, y-axis) when compression is in the toe of the leg.
"""
module PositiveBending

import AISCSteel
import AISCSteel.ChapterFFlexure.F10.GeometricAxisBending.PositiveBending: calc_positive_Mn

function calc_positive_Mnx((;F_y, S_x, E, b, d, t)::T, λ_class, L_b, restraint_type, C_b) where T <: AISCSteel.Shapes.LShapes.AbstractLShapes

    S_min = S_x

    if restraint_type == :fully_restrained
        M_nx = calc_positive_Mn(F_y, S_min, E, b, t, λ_class, L_b, restraint_type, C_b)
    else
        if b == d
            M_nx = calc_positive_Mn(F_y, S_min, E, b, t, λ_class, L_b, restraint_type, C_b)
        else
            @warn "code assumes equal legs when not fully restrained."
            M_nx = calc_positive_Mn(F_y, S_min, E, b, t, λ_class, L_b, restraint_type, C_b)
        end
    end

    return M_nx
end

function calc_positive_Mny((;F_y, S_y, E, b, d, t)::T, λ_class, L_b, restraint_type, C_b) where T <: AISCSteel.Shapes.LShapes.AbstractLShapes

    S_min = S_y

    if restraint_type == :fully_restrained
        M_ny = calc_positive_Mn(F_y, S_min, E, d, t, λ_class, L_b, restraint_type, C_b)
    else
        if b == d
            M_ny = calc_positive_Mn(F_y, S_min, E, b, t, λ_class, L_b, restraint_type, C_b)
        else
            @warn "code assumes equal legs when not fully restrained."
            M_ny = calc_positive_Mn(F_y, S_min, E, d, t, λ_class, L_b, restraint_type, C_b)
        end
    end

    return M_ny
end

end