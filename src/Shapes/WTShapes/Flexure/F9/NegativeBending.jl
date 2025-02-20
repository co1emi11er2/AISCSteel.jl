module NegativeBending

import AISCSteel
import AISCSteel.ChapterFFlexure.F9.WT.NegativeBending: calc_variables, calc_Mn
export calc_variables, calc_Mn

"""
    calc_variables(shape::T) where T <: AISCSteel.Shapes.WTShapes.AbstractWTShapes

This function calculates the following miscellaneous variables that are used to calculate Mn of the shape for AISC Section F6. 

# Arguments
- `shape`: rolled WT-Shape section (`WTShape`)

# Returns
    (;M_p, F_cr)
- `M_p`: plastic moment of the section (kip-ft)
- `F_cr`: critical stress (ksi)

# Reference
- AISC Section F9
"""
function calc_variables((; F_y, S_x, d, I_y, J, t_w, E)::T, L_b) where T <: AISCSteel.Shapes.WTShapes.AbstractWTShapes
    
    t = calc_variables(F_y, S_x, d, L_b, I_y, J, t_w, E)

    return t
end

"""
    calc_Mn(shape::T) where T <: AISCSteel.Shapes.WTShapes.AbstractWTShapes

This function calculates Mn of the shape for AISC Section F6.

# Arguments
- `shape`: rolled WT-Shape section (`WTShape`)
- `λ_f`: slenderness ratio of the flange
- `λ_pf`: compact slenderness ratio limit of the flange
- `λ_rf`: noncompact slenderness ratio limit of the flange
- `λ_fclass`: `compact` `noncompact` or `slender` classification for the flange

# Returns
- `M_n`: nominal moment of the section (kip-ft)

# Reference
- AISC Section F9
"""
function calc_Mn((; F_y, S_x, d, I_y, J, t_w, E)::T, L_b) where T <: AISCSteel.Shapes.WTShapes.AbstractWTShapes

    M_n = calc_Mn(F_y, S_x, d, L_b, I_y, J, t_w, E)

    return M_n
end

end
