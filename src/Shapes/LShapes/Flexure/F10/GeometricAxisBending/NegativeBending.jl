"""
    module NegativeBending

LShapes bent about their geometric axis (x-axis, y-axis) when tension is in the toe of the leg.
"""
module NegativeBending

import AISCSteel
import AISCSteel.ChapterFFlexure.F10.GeometricAxisBending.NegativeBending: calc_negative_Mn

"""
    calc_negative_Mnx(lshape, L_b, restraint_type, C_b)

Calculates negative moment (when toe of leg is in tension) about geometric axis for an LShape.

# Arguments
- `lshape`: LShape object
- `L_b`: unbraced length (inch)
- `restraint_type`: type of restraint on leg (`:fully_restrained`, `:unrestrained`, or `:at_max_moment_only`)
- `C_b`: lateral torsional buckling modification factor
"""
function calc_negative_Mnx((;F_y, S_x, E, b, d, t)::T, L_b, restraint_type, C_b) where T <: AISCSteel.Shapes.LShapes.AbstractLShapes

    S_min = S_x

    if restraint_type == :fully_restrained
        M_nx = calc_negative_Mn(F_y, S_min, E, b, t, L_b, restraint_type, C_b)
    else
        if b == d
            M_nx = calc_negative_Mn(F_y, S_min, E, b, t, L_b, restraint_type, C_b)
        else
            @warn "code assumes equal legs when not fully restrained."
            M_nx = calc_negative_Mn(F_y, S_min, E, b, t, L_b, restraint_type, C_b)
        end
    end

    return M_nx
end

"""
    calc_negative_Mny(lshape, L_b, restraint_type, C_b)

Calculates negative moment (when toe of leg is in tension) about geometric axis for an LShape.

# Arguments
- `lshape`: LShape object
- `L_b`: unbraced length (inch)
- `restraint_type`: type of restraint on leg (`:fully_restrained`, `:unrestrained`, or `:at_max_moment_only`)
- `C_b`: lateral torsional buckling modification factor
"""
function calc_negative_Mny((;F_y, S_y, E, b, d, t)::T, L_b, restraint_type, C_b) where T <: AISCSteel.Shapes.LShapes.AbstractLShapes

    S_min = S_y

    if restraint_type == :fully_restrained
        M_ny = calc_negative_Mn(F_y, S_min, E, b, t, L_b, restraint_type, C_b)
    else
        if b == d
            M_ny = calc_negative_Mn(F_y, S_min, E, b, t, L_b, restraint_type, C_b)
        else
            @warn "code assumes equal legs when not fully restrained."
            M_ny = calc_negative_Mn(F_y, S_min, E, d, t, L_b, restraint_type, C_b)
        end
    end

    return M_ny
end

end