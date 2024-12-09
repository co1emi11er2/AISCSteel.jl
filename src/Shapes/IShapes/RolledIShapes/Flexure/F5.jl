module F5
import AISCSteel
import AISCSteel.ChapterFFlexure.F5: calc_variables, calc_Mn

function calc_variables((;E, F_y, S_x, b_f, t_f, h, t_w)::T, L_b, λ_f, λ_pf, λ_rf, λ_fclass, C_b=1) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes
    
    t = calc_variables(E, F_y, S_x, b_f, t_f, h, h, t_w, λ_f, λ_pf, λ_rf, λ_fclass, L_b, C_b)

    return t
end


function calc_Mn((;E, F_y, Z_x, S_x, b_f, t_f, h, t_w, J, h_0, I_y)::T, L_b, λ_w, λ_pw, λ_rw, λ_f, λ_pf, λ_rf, λ_fclass, C_b=1) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes
    
    M_n = calc_Mn(E, F_y, S_x, S_x, b_f, t_f, h, h, t_w, λ_f, λ_pf, λ_rf, λ_fclass, L_b, C_b)

    return M_n
end

end # module