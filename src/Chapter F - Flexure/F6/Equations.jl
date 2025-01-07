module Equations
import AISCSteel.Utils.UnitConversions as cnv

export EqF6▬1, EqF6▬2, EqF6▬3, EqF6▬4

function EqF6▬1(F_y, Z_y, S_y)
    M_p = min(F_y * Z_y, 1.6 * F_y * S_y) |> cnv.to_moment
end

function EqF6▬2(M_p, F_y, S_y, λ_f, λ_pf, λ_rf)
    M_nLTB = (M_p - (M_p-0.7*F_y*S_y)*((λ_f-λ_pf)/(λ_rf-λ_pf))) |> cnv.to_moment
end

function EqF6▬3(F_cr, S_y)
    M_nLTB = F_cr * S_y |> cnv.to_moment
end

function EqF6▬4(E, b, t_f)
    F_cr = (0.7 * E) / (b/t_f)^2 |> cnv.to_stress
end

end # module
