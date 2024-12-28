module F5
import AISCSteel
import AISCSteel.ChapterFFlexure.F5: calc_variables, calc_Mn

"""
    calc_variables(shape::T, L_b, C_b=1) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

This function calculates the following miscellaneous variables that are used to calculate Mn of the shape for AISC Section F5. 

# Arguments
- `shape`: rolled i-shape section (`WShape`, `MShape`, `SShape`, `HPShape`)
- `L_b`: unbraced length (inch)
- `C_b`: lateral torsional buckling modification factor (default = 1)

# Returns
    (;M_p, R_pg, F_crLTB, F_crCFLB)
- `M_p`: plastic moment of the section (kip-ft)
- `R_pg`: bending strength reduction factor
- `F_crLTB`: critical stress relating to lateral torsional buckling
- `F_crCFLB`: critical stress relating to compression flange lateral buckling

# Reference
- AISC Section F5
"""
function calc_variables((;E, F_y, S_x, b_f, t_f, h, t_w)::T, L_b, λ_f, λ_pf, λ_rf, λ_fclass, C_b=1) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes
    
    t = calc_variables(E, F_y, S_x, b_f, t_f, h, h, t_w, λ_f, λ_pf, λ_rf, λ_fclass, L_b, C_b)

    return t
end


"""
    calc_Mn(shape::T, L_b, C_b=1) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

This function calculates Mn of the shape for AISC Section F5.

# Arguments
- `shape`: rolled i-shape section (`WShape`, `MShape`, `SShape`, `HPShape`)
- `L_b`: unbraced length (inch)
- `C_b`: lateral torsional buckling modification factor (default = 1)

# Returns
- `M_n`: nominal moment of the section (kip-ft)

# Reference
- AISC Section F5
"""
function calc_Mn((;E, F_y, Z_x, S_x, b_f, t_f, h, t_w, J, h_0, I_y)::T, L_b, λ_w, λ_pw, λ_rw, λ_f, λ_pf, λ_rf, λ_fclass, C_b=1) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes
    
    M_n = calc_Mn(E, F_y, S_x, S_x, b_f, t_f, h, h, t_w, λ_f, λ_pf, λ_rf, λ_fclass, L_b, C_b)

    return M_n
end

end # module
