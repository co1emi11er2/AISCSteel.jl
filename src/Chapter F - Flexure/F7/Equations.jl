module Equations
import AISCSteel.Utils.UnitsConversions as cnv
export EqF7▬1, EqF7▬2, EqF7▬3, EqF7▬4, EqF7▬5, EqF7▬6, EqF7▬7, EqF7▬10, EqF7▬11, EqF7▬12, EqF7▬13

function EqF7▬1(F_y, Z)
    M_p = F_y*Z |> cnv.to_moment
end

function EqF7▬2(M_p, F_y, S, λ_f, λ_pf, λ_rf)
    M_nFLB = (M_p - (M_p-F_y*S)*((λ_f-λ_pf)/(λ_rf-λ_pf))) |> cnv.to_moment
end

function EqF7▬3(F_y, S_e)
    M_nLTB = F_y * S_e |> cnv.to_moment
end

function EqF7▬4(t_f, E, F_y, b)
    b_e = 1.92 * t_f * sqrt(E/F_y) * (1 - ((0.38)/(b/t_f))*sqrt(E/F_y)) |> cnv.to_L
end

function EqF7▬5(t_f, E, F_y, b)
    b_e = 1.92 * t_f * sqrt(E/F_y) * (1 - ((0.34)/(b/t_f))*sqrt(E/F_y)) |> cnv.to_L
end

function EqF7▬6(M_p, F_y, S, λ_w, λ_pw, λ_rw)
    M_nWLB = (M_p - (M_p-F_y*S)*((λ_w-λ_pw)/(λ_rw-λ_pw))) |> cnv.to_moment
end

function EqF7▬7(R_pg, F_y, S)
    M_nWLB = R_pg * F_y * S |> cnv.to_moment
end

function EqF7▬10(M_p, F_y, S_x, L_b, L_p, L_r, C_b)
    M_nLTB = C_b*(M_p - (M_p-0.7*F_y*S_x)*((L_b-L_p)/(L_r-L_p))) |> cnv.to_moment
end

function EqF7▬11(E, C_b, J, A_g, L_b, r_y)
    M_nLTB = 2 * E*C_b*sqrt(J*A_g)/(L_b/r_y) |> cnv.to_moment
end

function EqF7▬12(E, r_y, J, A_g, M_p)
    L_p = 0.13*E*r_y*sqrt(J*A_g)/M_p |> cnv.to_large_L
end

function EqF7▬13(E, r_y, J, A_g, F_y, S_x)
    L_r = 2*E*r_y*sqrt(J*A_g)/(0.7*F_y*S_x) |> cnv.to_large_L
end

end # module