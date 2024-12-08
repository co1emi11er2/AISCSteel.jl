module F3
import AISCSteel
import AISCSteel.ChapterFFlexure.F3: calc_variables, calc_Mn

function calc_variables((;E, F_y, Z_x, S_x, r_y, r_ts, J, h_0, h, t_w)::T, L_b, C_b=1) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

    c = 1
    
    t = calc_variables(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, h, t_w, C_b)

    return t
end

function calc_Mn((;Z_x, S_x, r_y, h_0, J, r_ts, h, t_w, E, F_y)::T, L_b, λ_f, λ_pf, λ_rf, λ_fclass, C_b=1) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

    c = 1

    M_n = calc_Mn(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, h, t_w, λ_f, λ_pf, λ_rf, λ_fclass, C_b)

    return M_n
end

end # module