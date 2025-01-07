module Equations
import AISCSteel.Utils.UnitsConversions as cnv

export EqF8▬1, EqF8▬2, EqF8▬3, EqF8▬4

function EqF8▬1(F_y, Z)
    M_p = F_y*Z |> cnv.to_moment
end

function EqF8▬2(E, D, t, F_y, S)
    M_nLB = ((0.021*E)/(D/t) + F_y)*S |> cnv.to_moment
end

function EqF8▬3(F_cr, S)
    M_nLB = F_cr * S |> cnv.to_moment
end

function EqF8▬4(E, D, t)
    F_cr = (0.33*E)/(D/t) |> cnv.to_stress
end

end # module
