module Equations

export EqF4▬1, EqF4▬2, EqF4▬3, EqF4▬4, EqF4▬5, EqF4▬6a, EqF4▬6b, EqF4▬7, EqF4▬8, EqF4▬9a, EqF4▬9b
export EqF4▬10, EqF4▬11, EqF4▬12, EqF4▬13, EqF4▬14, EqF4▬15, EqF4▬16a, EqF4▬16b, EqF4▬17

function EqF4▬1(R_pc, M_yc)
    M_nCFY = R_pc*M_yc
end

function EqF4▬2(C_b, R_pc, M_yc, F_L, S_xc, L_b, L_p, L_r)
    M_nLTB = C_b*(R_pc*M_yc - (R_pc*M_yc - F_L*S_xc)*((L_b - L_p)/(L_r - L_p)))
end

function EqF4▬3(F_cr, S_xc)
    M_nLTB = F_cr * S_xc
end

function EqF4▬4(F_y, S_xc)
    M_yc = F_y * S_xc
end

function EqF4▬5(C_b, E, L_b, r_t, J, S_xc, h_0)
    F_cr = ((C_b*π^2*E)/(L_b/r_t)^2)*sqrt(1 + 0.078*((J)/(S_xc*h_0))*(L_b/r_t)^2)
end

function EqF4▬6a(F_y)
    F_L = 0.7*F_y
end

function EqF4▬6b(F_y, S_xt, S_xc)
    F_L = F_y*(S_xt/S_xc)
end

function EqF4▬7(r_t, E, F_y)
    L_p = 1.1*r_t*sqrt(E/F_y)
end

function EqF4▬8(r_t, E, F_L, J, S_xc, h_0)
    L_p = 1.95*r_t*(E/(F_L))*sqrt((J)/(S_xc*h_0) + sqrt(((J)/(S_xc*h_0))^2 + 6.76*((F_L)/E)^2))
end

function EqF4▬9a(M_p, M_yc)
    R_pc = M_p/M_yc
end

function EqF4▬9b(M_p, M_yt, λ, λ_pw, λ_rw)
    R_pc = min((M_p/M_yt) - (M_p/M_yt - 1)*((λ - λ_pw)/(λ_rw - λ_pw)), M_p/M_yt)
end

function EqF4▬10()
    R_pc = 1.0
end

function EqF4▬11(b_fc, a_w)
    r_t = b_fc/sqrt(12*(1 + (1/6)*a_w))
end

function EqF4▬12(h_c, t_w, b_fc, t_fc)
    a_w = (h_c*t_w)/(b_fc*t_fc)
end

function EqF4▬13(R_pc, M_yc, F_L, S_xc, λ, λ_pf, λ_rf)
    M_nCFLB = R_pc*M_yc - (R_pc*M_yc - F_L*S_xc) * ((λ_f - λ_pf)/(λ_rf - λ_pf))
end

function EqF4▬14(R_pc, M_yc, F_L, S_xc, λ, λ_pf, λ_rf)
    M_nCFLB = (0.9*E*k_c*S_xc)/λ_f^2
end

function EqF4▬15(R_pt, M_yt)
    M_nTFY = R_pt*M_yt
end

function EqF4▬16a(M_p, M_yt)
    R_pt = M_p/M_yt
end

function EqF4▬16b(M_p, M_yc, λ, λ_pw, λ_rw)
    R_pt = min((M_p/M_yc) - (M_p/M_yc - 1)*((λ_w - λ_pw)/(λ_rw - λ_pw)), M_p/M_yc)
end

function EqF4▬17()
    R_pt = 1.0
end

end # module