module PositiveBending

import AISCSteel
import AISCSteel.ChapterFFlexure.F9.PositiveBending.WT: calc_variables, calc_Mn
export calc_variables, calc_Mn

"""
    calc_variables(shape::T) where T <: AISCSteel.Shapes.WTShapes.AbstractWTShapes

This function calculates the following miscellaneous variables that are used to calculate Mn of the shape for AISC Section F6. 

# Arguments
- `shape`: rolled WT-Shape section (`WTShape`)
- `L_b`: lateral unbraced length

# Returns
    (;M_p, F_cr)
- `M_p`: plastic moment of the section (kip-ft)
- `F_cr`: critical stress (ksi)

# Reference
- AISC Section F9
"""
function calc_variables((; r_y, E, F_y, I_y, J, S_x, Z_x, d)::T, L_b) where T <: AISCSteel.Shapes.WTShapes.AbstractWTShapes
    
    t = calc_variables(r_y, E, F_y, I_y, J, S_x, Z_x, d)

    return t
end

"""
    calc_Mn(shape::T) where T <: AISCSteel.Shapes.WTShapes.AbstractWTShapes

This function calculates Mn of the shape for AISC Section F6.

# Arguments
- `shape`: rolled WT-Shape section (`WTShape`)
- `L_b`: unbraced length (inch)
- `λ_f`: slenderness ratio of the flange
- `λ_pf`: compact slenderness ratio limit of the flange
- `λ_rf`: noncompact slenderness ratio limit of the flange
- `λ_fclass`: `compact` `noncompact` or `slender` classification for the flange

# Returns
- `M_n`: nominal moment of the section (kip-ft)

# Reference
- AISC Section F9
"""
function calc_Mn((; r_y, E, F_y, I_y, J, S_x, Z_x, d, b_f, t_f, I_x, ȳ)::T, L_b, λ_f, λ_pf, λ_rf, λ_fclass) where T <: AISCSteel.Shapes.WTShapes.AbstractWTShapes

    S_xc = I_x/ȳ
    M_n = calc_Mn(r_y, E, F_y, I_y, J, S_x, Z_x, d, L_b, S_xc, λ_f, λ_pf, λ_rf, λ_fclass, b_f, t_f)
    
    return M_n
end

end
