module Equations
import AISCSteel.Utils.UnitConversions as cnv

export EqF10▬1, EqF10▬2, EqF10▬3, EqF10▬4, EqF10▬5a, EqF10▬5b, EqF10▬6, EqF10▬7, EqF10▬8 

function EqF10▬1(M_y)
    M_nY = 1.5 * M_y |> cnv.to_moment
end

function EqF10▬2(M_y, M_cr)
    M_nLTB = (1.92 - 1.17 * sqrt(M_y/M_cr)) * M_y |> cnv.to_moment
end

function EqF10▬3(M_cr, M_y)
    M_nLTB = (0.92 - (0.17*M_cr)/M_y)*M_cr |> cnv.to_moment
end

function EqF10▬4(E, A_g, r_z, t, C_b, L_b, β_w)

    x = 4.4*(β_w* r_z)/(L_b*t)

    M_cr = (9 * E * A_g * r_z * t * C_b)/(8* L_b) * (sqrt(1 + x^2) + x) |> cnv.to_moment
end

function EqF10▬5a(E, b, t, C_b, L_b)
    M_cr = (0.58 * E * b^4 * t * C_b)/L_b^2 * (sqrt(1 + 0.88 * ((L_b*t)/b^2)^2) - 1) |> cnv.to_moment
end

function EqF10▬5b(E, b, t, C_b, L_b)
    M_cr = (0.58 * E * b^4 * t * C_b)/L_b^2 * (sqrt(1 + 0.88 * ((L_b*t)/b^2)^2) + 1) |> cnv.to_moment
end

function EqF10▬6(F_y, S_c, b, t, E)
    M_nLB = F_y * S_c * (2.43 - 1.72*(b/t)*sqrt(F_y/E)) |> cnv.to_moment
end

function EqF10▬7(F_cr, S_c)
    M_nLB = F_cr * S_c |> cnv.to_moment
end

function EqF10▬8(E, b, t)
    F_cr = (0.71*E)/(b/t)^2 |> cnv.to_stress
end

end # module
