module F4
import AISCSteel
import AISCSteel.ChapterFFlexure.F4: calc_variables, calc_Mn

function calc_variables((;E, F_y, Z_x, S_x, b_f, t_f, h, t_w, J, h_0, I_y)::T, L_b, λ_w, λ_pw, λ_rw, C_b=1) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

    I_yc = (b_f * t_f^3)/12 
    
    t = calc_variables(E, F_y, Z_x, S_x, S_x, S_x, b_f, t_f, h, h, t_w, J, h_0, I_y, I_yc, λ_w, λ_pw, λ_rw, L_b, C_b)

    return t
end


function calc_Mn((;E, F_y, Z_x, S_x, b_f, t_f, h, t_w, J, h_0, I_y)::T, L_b, λ_w, λ_pw, λ_rw, λ_f, λ_pf, λ_rf, λ_fclass, C_b=1) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

    I_yc = (b_f * t_f^3)/12 
    
    M_n = calc_Mn(E, F_y, Z_x, S_x, S_x, S_x, b_f, t_f, h, h, t_w, J, h_0, I_y, I_yc, λ_w, λ_pw, λ_rw, λ_f, λ_pf, λ_rf, λ_fclass, L_b, C_b)

    return M_n
end

end # module