"""
    module PositiveBending

LShapes bent about their geometric axis (x-axis, y-axis) when compression is in the toe of the leg.
"""
module PositiveBending

import AISCSteel
import AISCSteel.Shapes.LShapes.Flexure: classify_leg
import AISCSteel.ChapterFFlexure.F10.GeometricAxisBending.PositiveBending: calc_positive_Mn

"""
    calc_positive_Mnx(lshape, λ_class, L_b, restraint_type, C_b)
    calc_positive_Mnx(lshape, L_b, restraint_type, C_b)

Calculates positive moment (when toe of leg is in compression) about geometric axis for an LShape.

# Arguments
- `lshape`: LShape object
- `λ_class`: slenderness classification of angle leg
- `L_b`: unbraced length (inch)
- `restraint_type`: type of restraint on leg (`:fully_restrained`, `:unrestrained`, or `:at_max_moment_only`)
- `C_b`: lateral torsional buckling modification factor
"""
function calc_positive_Mnx((;F_y, S_x, E, b, d, t)::T, λ_class::Symbol, L_b, restraint_type, C_b) where T <: AISCSteel.Shapes.LShapes.AbstractLShapes

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

function calc_positive_Mnx(lshape::T, L_b, restraint_type, C_b) where T <: AISCSteel.Shapes.LShapes.AbstractLShapes

    _..., λ_class = classify_leg(lshape)

    M_nx = calc_positive_Mnx(lshape, λ_class, L_b, restraint_type, C_b)
    
    return M_nx
end

"""
    calc_positive_Mny(lshape, λ_class, L_b, restraint_type, C_b)
    calc_positive_Mny(lshape, L_b, restraint_type, C_b)

Calculates positive moment (when toe of leg is in compression) about geometric axis for an LShape.

# Arguments
- `lshape`: LShape object
- `λ_class`: slenderness classification of angle leg
- `L_b`: unbraced length (inch)
- `restraint_type`: type of restraint on leg (`:fully_restrained`, `:unrestrained`, or `:at_max_moment_only`)
- `C_b`: lateral torsional buckling modification factor
"""
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

function calc_positive_Mny(lshape::T, L_b, restraint_type, C_b) where T <: AISCSteel.Shapes.LShapes.AbstractLShapes

    _..., λ_class = classify_leg(lshape)

    M_ny = calc_positive_Mny(lshape, λ_class, L_b, restraint_type, C_b)
    
    return M_ny
end

end