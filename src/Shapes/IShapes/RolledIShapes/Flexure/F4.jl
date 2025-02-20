module F4
import AISCSteel
import AISCSteel.ChapterFFlexure.F4: calc_variables, calc_Mn
export calc_variables, calc_Mn

"""
    calc_variables(shape::T, L_b, λ_w, λ_pw, λ_rw, C_b=1) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

This function calculates the following miscellaneous variables that are used to calculate Mn of the shape for AISC Section F4. 

# Arguments
- `shape`: rolled i-shape section (`WShape`, `MShape`, `SShape`, `HPShape`)
- `L_b`: unbraced length (inch)
- `C_b`: lateral torsional buckling modification factor (default = 1)

# Returns
    (;M_p, M_yc, M_yt, k_c, F_cr, F_L, L_p, L_r, R_pc, R_pt)
- `M_p`: plastic moment of the section (kip-ft)
- `M_yc`: yield moment in the compression flange 
- `M_yt`: yield moment in the tension flange 
- `k_c`: 
- `F_cr`: critical stress (ksi)
- `F_L`: nominal compression flange stress above which the inelastic buckling limit states apply (ksi)
- `L_p`: the limiting laterally unbraced length for the limit state of yielding (inch)
- `L_r`: the limiting laterally unbraced length for the limit state of inelastic lateral-torsional buckling (inch)
- `R_pc`: web plastification factor
- `R_pt`: web plastification factor corresponding to the tension flange yielding limit state

# Reference
- AISC Section F4
"""
function calc_variables((;E, F_y, Z_x, S_x, b_f, t_f, h, t_w, J, h_0, I_y)::T, L_b, λ_w, λ_pw, λ_rw, C_b=1) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

    I_yc = (b_f * t_f^3)/12 
    
    t = calc_variables(E, F_y, Z_x, S_x, S_x, S_x, b_f, t_f, h, h, t_w, J, h_0, I_y, I_yc, λ_w, λ_pw, λ_rw, L_b, C_b)

    return t
end


"""
    calc_Mn(shape::T, L_b, C_b=1) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

This function calculates Mn of the shape for AISC Section F4.

# Arguments
- `shape`: rolled i-shape section (`WShape`, `MShape`, `SShape`, `HPShape`)
- `L_b`: unbraced length (inch)
- `C_b`: lateral torsional buckling modification factor (default = 1)

# Returns
- `M_n`: nominal moment of the section (kip-ft)

# Reference
- AISC Section F4
"""
function calc_Mn((;E, F_y, Z_x, S_x, b_f, t_f, h, t_w, J, h_0, I_y)::T, L_b, λ_w, λ_pw, λ_rw, λ_f, λ_pf, λ_rf, λ_fclass, C_b=1) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

    I_yc = (b_f * t_f^3)/12 
    
    M_n = calc_Mn(E, F_y, Z_x, S_x, S_x, S_x, b_f, t_f, h, h, t_w, J, h_0, I_y, I_yc, λ_w, λ_pw, λ_rw, λ_f, λ_pf, λ_rf, λ_fclass, L_b, C_b)

    return M_n
end

end # module
