module Equations

export EqF11▬1, EqF11▬2, EqF11▬3, EqF11▬4, EqF11▬5

function EqF11▬1(F_y, Z, S_x)
    M_nY = min(F_y*Z, 1.5 * F_y * S_x)
end

function EqF11▬2(F_y, Z, S_x)
    M_nY = min(F_y*Z, 1.6 * F_y * S_x)
end

function EqF11▬3(C_b, L_b, d, t, F_y, E, M_y)
    M_nLTB = C_b * (1.52 - 0.274 * ((L_b*d)/t^2) * F_y/E) * M_y
end

function EqF11▬4(F_cr, S_x)
    M_nLTB = F_cr * S_x
end

function EqF11▬5(E, C_b, L_b, d, t)
    F_cr = (1.9*E*C_b)/((L_b*d)/t^2)
end

end # module