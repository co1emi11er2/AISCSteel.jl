module Equations
import AISCSteel.Conversions as cnv

export EqF9▬1, EqF9▬2, EqF9▬3, EqF9▬4, EqF9▬5, EqF9▬6, EqF9▬7, EqF9▬8, EqF9▬9, EqF9▬10
export EqF9▬11, EqF9▬12, EqF9▬13, EqF9▬14, EqF9▬15, EqF9▬16, EqF9▬17, EqF9▬18, EqF9▬19

function EqF9▬1(M_p)
    M_nY = M_p |> cnv.to_moment
end

function EqF9▬2(F_y, Z_x, M_y)
    M_p = min(F_y * Z_x, 1.6*M_y) |> cnv.to_moment
end

function EqF9▬3(F_y, S_x)
    M_y = F_y * S_x |> cnv.to_moment
end

function EqF9▬4(M_y)
    M_p = M_y |> cnv.to_moment
end

function EqF9▬5(M_y)
    M_p = 1.5 * M_y |> cnv.to_moment
end

function EqF9▬6(M_p, M_y, L_b, L_p, L_r)
    M_nLTB = (M_p - (M_p-M_y)*((L_b-L_p)/(L_r-L_p))) |> cnv.to_moment
end

function EqF9▬7(M_cr)
    M_nLTB = M_cr |> cnv.to_moment
end

function EqF9▬8(r_y, E, F_y)
    L_p = 1.76 * r_y * sqrt(E/F_y) |> cnv.to_large_L
end

function EqF9▬9(E, F_y, I_y, J, S_x, d)
    L_r = 1.95 * (E/F_y) * sqrt(I_y*J)/S_x * sqrt(2.36 * (F_y/E) * (d*S_x)/J + 1) |> cnv.to_large_L
end

function EqF9▬10(E, L_b, I_y, J, B)
    M_cr = (1.95*E)/L_b * sqrt(I_y*J) * (B + sqrt(1 + B^2)) |> cnv.to_moment
end

function EqF9▬11(d, L_b, I_y, J)
    B = 2.3 * (d/L_b) * sqrt(I_y/J)
end

function EqF9▬12(d, L_b, I_y, J)
    B = -2.3 * (d/L_b) * sqrt(I_y/J)
end

function EqF9▬13(M_cr, M_y)
    M_nLTB = min(M_cr, M_y) |> cnv.to_moment
end

function EqF9▬14(M_p, F_y, S_xc, λ_f, λ_pf, λ_rf, M_y)
    M_nFLB1 = (M_p - (M_p-F_y*S_xc)*((λ_f-λ_pf)/(λ_rf-λ_pf))) |> cnv.to_moment
    M_nFLB2 = 1.6*M_y |> cnv.to_moment

    M_nFLB = min(M_nFLB1, M_nFLB2)
end

function EqF9▬15(E, S_xc, b_f, t_f)
    M_nFLB = (0.7 * E * S_xc)/(b_f/(2*t_f))^2 |> cnv.to_moment
end

function EqF9▬16(F_cr, S_x)
    M_nLB = F_cr * S_x |> cnv.to_moment
end

function EqF9▬17(F_y)
    F_cr = F_y |> cnv.to_stress
end

function EqF9▬18(d, t_w, F_y, E)
    F_cr = (1.43 - 0.515*(d/t_w)*sqrt(F_y/E)) * F_y |> cnv.to_stress
end

function EqF9▬19(E, d, t_w)
    F_cr = (1.52 * E)/(d/t_w)^2 |> cnv.to_stress
end

end # module
