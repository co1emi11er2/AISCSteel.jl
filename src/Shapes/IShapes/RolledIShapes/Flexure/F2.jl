module F2
import AISCSteel
import AISCSteel.ChapterFFlexure.F2: calc_variables, calc_Mn

function calc_variables((;E, F_y, Z_x, S_x, r_y, r_ts, J, h_0)::T, L_b, C_b=1) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

    c = 1
    
    t = calc_variables(E, F_y, Z_x, S_x, r_y, r_ts, J, c, h_0, L_b, C_b)

    return t
end

function calc_Mn((;Z_x, S_x, r_y, h_0, J, r_ts, E, F_y,)::T, L_b, C_b=1) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

    c = 1

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