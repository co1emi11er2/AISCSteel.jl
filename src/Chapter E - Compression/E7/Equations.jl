module Equations


function EqE7▬1(F_n, A_e)
    P_n = F_n*A_e
end

function EqE7▬2(b)
    b_e = b
end

function EqE7▬3(b, c_1, F_el, F_n)
    b_e = b*(1 - c_1*sqrt(F_el/F_n))*sqrt(F_el/F_n)
end

function EqE7▬4(c_1)
    c_2 = (1 - sqrt(1 - 4*c_1))/(2*c_1)
end

function EqE7▬5(c_2, λ_r, λ, F_y)
    F_el = (c_2*(λ_r/λ))^2*F_y
end

function EqE7▬6(A_g)
    A_e = A_g
end

function EqE7▬7(A_g)
    A_e = ((0.038*E)/(F_y*(D/t)) + 2/3)*A_g
end

end # module