module Equations
import AISCSteel.Utils.UnitsConversions as cnv

export EqF12▬1, EqF12▬2, EqF12▬3, EqF12▬4

function EqF12▬1(F_n, S_min)
    M_n = F_n * S_min |> cnv.to_moment
end

function EqF12▬2(F_y)
    F_nY = F_y |> cnv.to_stress
end

function EqF12▬3(F_cr)
    F_nLTB = F_cr |> cnv.to_stress
end

function EqF12▬4(F_cr)
    F_nLB = F_cr |> cnv.to_stress
end

end # module
