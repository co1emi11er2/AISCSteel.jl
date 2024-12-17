module Equations

export EqF5▬1, EqF5▬2, EqF5▬3, EqF5▬4, EqF5▬5, EqF5▬6, EqF5▬7, EqF5▬8, EqF5▬9, EqF5▬10

function EqF5▬1(R_pg, F_y, S_xc)
    M_p = R_pg * F_y * S_xc
end

function EqF5▬2(R_pg, F_crLTB, S_xc)
    M_nLTB = R_pg * F_crLTB * S_xc
end

function EqF5▬3(C_b, F_y, L_b, L_p, L_r)
    F_crLTB = C_b * (F_y - 0.3 * F_y * ((L_b - L_p) / (L_r - L_p)))
end

function EqF5▬4(C_b, E, L_b, r_t)
    F_crLTB = (C_b * π^2 * E) / (L_b / r_t)^2
end

function EqF5▬5(r_t, E, F_y)
    L_r = π * r_t * sqrt(E / (0.7 * F_y))
end

function EqF5▬6(a_w, h_c, t_w, E, F_y)
    R_pg = 1 - a_w / (1200 + 300 * a_w) * (h_c / t_w - 5.7 * sqrt(E / F_y))
end

function EqF5▬7(R_pg, F_crCFLB, S_xc)
    M_nCFLB = R_pg * F_crCFLB * S_xc
end

function EqF5▬8(F_y, λ_f, λ_pf, λ_rf)
    F_crCFLB = F_y - 0.3 * F_y * ((λ_f - λ_pf) / (λ_rf - λ_pf))
end

function EqF5▬9(E, k_c, b_fc, t_fc)
    F_crCFLB = (0.9 * E * k_c) / (b_fc / (2 * t_fc))^2
end

function EqF5▬10(F_y, S_xt)
    M_nTFY = F_y * S_xt
end

end # module
