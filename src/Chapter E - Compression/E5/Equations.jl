module Equations
import AISCSteel.Utils.UnitConversions as cnv

export EqE5▬1, EqE5▬2, EqE5▬3, EqE5▬4

function EqE5▬1(L, r_a)
    L_c = (72 + 0.75*(L/r_a))*r_a |> cnv.to_L
end

function EqE5▬2(L, r_a)
    L_c = (32 + 1.25*(L/r_a))*r_a |> cnv.to_L
end

function EqE5▬3(L, r_a)
    L_c = (60 + 0.8*(L/r_a))*r_a |> cnv.to_L
end

function EqE5▬4(L, r_a)
    L_c = (45 + (L/r_a))*r_a |> cnv.to_L
end

end # module
