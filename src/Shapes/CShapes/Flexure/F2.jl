module F2
import AISCSteel
import AISCSteel.ChapterFFlexure.F2: calc_variables, calc_Mn

"""
    calc_variables(shape::T, L_b, C_b=1) where T <: AISCSteel.Shapes.CShapes.AbstractCShapes

This function calculates the following miscellaneous variables that are used to calculate Mn of the shape for AISC Section F2. 

# Arguments
- `shape`: rolled i-shape section (`WShape`, `MShape`, `SShape`, `HPShape`)
- `L_b`: unbraced length (inch)
- `C_b`: lateral torsional buckling modification factor (default = 1)

# Returns
    (; M_p, L_p, L_r, F_cr)
- `M_p`: plastic moment of the section (kip-ft)
- `L_p`: the limiting laterally unbraced length for the limit state of yielding (inch)
- `L_r`: the limiting laterally unbraced length for the limit state of inelastic lateral-torsional buckling (inch)
- `F_cr`: critical stress (ksi)

# Reference
- AISC Section F2
"""
function calc_variables((; E, F_y, Z_x, S_x, I_y, r_y, C_w, r_ts, J, h_0)::T, L_b, C_b=1) where T <: AISCSteel.Shapes.CShapes.AbstractCShapes

    c = h_0 / 2 * sqrt(I_y / C_w)
    
    t = calc_variables(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, C_b)

    return t
end

"""
    calc_Mn(shape::T, L_b, C_b=1) where T <: AISCSteel.Shapes.CShapes.AbstractCShapes

This function calculates Mn of the shape for AISC Section F2.

# Arguments
- `shape`: rolled i-shape section (`WShape`, `MShape`, `SShape`, `HPShape`)
- `L_b`: unbraced length (inch)
- `C_b`: lateral torsional buckling modification factor (default = 1)

# Returns
- `M_n`: nominal moment of the section (kip-ft)

# Reference
- AISC Section F2
"""
function calc_Mn((; E, F_y, Z_x, S_x, I_y, r_y, C_w, r_ts, J, h_0)::T, L_b, C_b=1) where T <: AISCSteel.Shapes.CShapes.AbstractCShapes

    c = h_0 / 2 * sqrt(I_y / C_w)

    M_n = calc_Mn(
        E,
        F_y,
        Z_x,
        S_x,
        r_y,
        h_0,
        J,
        c,
        r_ts,
        L_b,
        C_b
    )

    return M_n
end

end # module
