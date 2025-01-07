module F6
import AISCSteel
import AISCSteel.ChapterFFlexure.F6: calc_variables, calc_Mn

"""
    calc_variables(shape::T) where T <: AISCSteel.Shapes.CShapes.AbstractCShapes

This function calculates the following miscellaneous variables that are used to calculate Mn of the shape for AISC Section F6. 

# Arguments
- `shape`: rolled C-Shape section (`CShape`, `MCShape`)

# Returns
    (;M_p, F_cr)
- `M_p`: plastic moment of the section (kip-ft)
- `F_cr`: critical stress (ksi)

# Reference
- AISC Section F6
"""
function calc_variables((; E, F_y, Z_y, S_y, b_f, t_f)::T) where T <: AISCSteel.Shapes.CShapes.AbstractCShapes
    
    t = calc_variables(E, F_y, Z_y, S_y, b_f, t_f)

    return t
end

"""
    calc_Mn(shape::T) where T <: AISCSteel.Shapes.CShapes.AbstractCShapes

This function calculates Mn of the shape for AISC Section F6.

# Arguments
- `shape`: rolled C-Shape section (`CShape`, `MCShape`)
- `λ_f`: slenderness ratio of the flange
- `λ_pf`: compact slenderness ratio limit of the flange
- `λ_rf`: noncompact slenderness ratio limit of the flange
- `λ_fclass`: `compact` `noncompact` or `slender` classification for the flange

# Returns
- `M_n`: nominal moment of the section (kip-ft)

# Reference
- AISC Section F6
"""
function calc_Mn((; E, F_y, Z_y, S_y, b_f, t_f)::T, λ_f, λ_pf, λ_rf, λ_fclass) where T <: AISCSteel.Shapes.CShapes.AbstractCShapes

    M_n = calc_Mn(E, F_y, Z_y, S_y, b_f, t_f, λ_f, λ_pf, λ_rf, λ_fclass)

    return M_n
end

end # module
