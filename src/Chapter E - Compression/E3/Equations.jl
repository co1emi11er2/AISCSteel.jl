module Equations

export EqE3▬1, EqE3▬2, EqE3▬3, EqE3▬4

function EqE3▬1(F_n, A_g)
    P_n = F_n*A_g
end

function EqE3▬2(F_y, F_e)
    F_n = (0.658^(F_y/F_e))*F_y
end

function EqE3▬3(F_e)
    F_n = 0.877*F_e
end

function EqE3▬4(E, L_c, r)
    F_e = (π^2*E)/(L_c/r)^2
end

end # module