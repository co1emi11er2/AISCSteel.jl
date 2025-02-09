module F3
import AISCSteel
import AISCSteel.ChapterFFlexure.F3: calc_variables, calc_Mn
export calc_variables, calc_Mn

"""
    calc_variables(shape::T, L_b, C_b=1) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

This function calculates the following miscellaneous variables that are used to calculate Mn of the shape for AISC Section F3. 

# Arguments
- `shape`: rolled i-shape section (`WShape`, `MShape`, `SShape`, `HPShape`)
- `L_b`: unbraced length (inch)
- `C_b`: lateral torsional buckling modification factor (default = 1)

# Returns
    (; M_p, L_p, L_r, F_cr, k_c)
- `M_p`: plastic moment of the section (kip-ft)
- `L_p`: the limiting laterally unbraced length for the limit state of yielding (inch)
- `L_r`: the limiting laterally unbraced length for the limit state of inelastic lateral-torsional buckling (inch)
- `F_cr`: critical stress (ksi)
- `k_c`: 

# Reference
- AISC Section F3
"""
function calc_variables((;E, F_y, Z_x, S_x, r_y, r_ts, J, h_0, h, t_w)::T, L_b, C_b=1) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

    c = 1
    
    t = calc_variables(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, h, t_w, C_b)

    return t
end

"""
    calc_Mn(shape::T, L_b, C_b=1) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

This function calculates Mn of the shape for AISC Section F3.

# Arguments
- `shape`: rolled i-shape section (`WShape`, `MShape`, `SShape`, `HPShape`)
- `L_b`: unbraced length (inch)
- `C_b`: lateral torsional buckling modification factor (default = 1)

# Returns
- `M_n`: nominal moment of the section (kip-ft)

# Reference
- AISC Section F3
"""
function calc_Mn((;Z_x, S_x, r_y, h_0, J, r_ts, h, t_w, E, F_y)::T, L_b, λ_f, λ_pf, λ_rf, λ_fclass, C_b=1) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

    c = 1

    M_n = calc_Mn(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, h, t_w, λ_f, λ_pf, λ_rf, λ_fclass, C_b)

    return M_n
end

end # module
