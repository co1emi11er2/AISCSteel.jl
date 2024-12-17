module Equations

export EqF8▬1, EqF8▬2, EqF8▬3, EqF8▬4

function EqF8▬1(F_y, Z)
    M_p = F_y*Z
end

function EqF8▬2(E, D, t, F_y, S)
    M_nLB = ((0.021*E)/(D/t) + F_y)*S
end

function EqF8▬3(F_cr, S)
    M_nLB = F_cr * S
end

function EqF8▬4(E, D, t)
    F_cr = (0.33*E)/(D/t)
end

end # module