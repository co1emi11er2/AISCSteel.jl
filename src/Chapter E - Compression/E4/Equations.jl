module Equations

export EqE4▬1, EqE4▬2, EqE4▬3, EqE4▬4, EqE4▬5, EqE4▬6, EqE4▬7
export EqE4▬8, EqE4▬9, EqE4▬10, EqE4▬11, EqE4▬12

function EqE4▬1(F_n, A_g)
    P_n = F_n*A_g
end

function EqE4▬2(E, C_w, L_cz, G, J, I_x, I_y)
    F_e = ( (π^2*E*C_w)/L_cz^2 + G*J)*(1/(I_x+I_y))
end

function EqE4▬3(F_ey, F_ez, H)
    F_e = ((F_ey + F_ez)/(2*H) * (1 - sqrt(1 - (4*F_ey*F_ez*H)/(F_ey + F_ez)^2)) )
end

# TODO: Write EqE4▬4
function EqE4▬4 end

function EqE4▬5(E, L_cx, r_x)
    F_ex = (π^2*E)/(L_cx*r_x)^2
end

function EqE4▬6(E, L_cy, r_y)
    F_ey = (π^2*E)/(L_cy*r_y)^2
end

function EqE4▬7(E, C_w, L_cz, G, J, A_g, r̄_0)
    F_ez = ( (π^2*E*C_w)/L_cz^2 + G*J)*(1/(A_g*r̄_0^2))
end

function EqE4▬8(x_0, y_0, r̄_0)
    H = 1 - (x_0^2 + y_0^2)/r̄_0^2
end

function EqE4▬9(x_0, y_0, I_x, I_y, A_g)
    r̄_0 = sqrt(x_0^2 + y_0^2 + (I_x + I_y)/A_g)
end

function EqE4▬10(E, I_y, L_cz, h_0, y_a, G, J, A_g, r_0)
    F_e = ( (π^2*E*I_y)/L_cz^2 * (h_0^2/4 + y_a^2) + G*J)*(1/(A_g*r_0^2))
end

function EqE4▬11(r_x, r_y, y_a, x_a)
    r_0 = sqrt(r_x^2 + r_y^2 + y_a^2 + x_a^2)
end

function EqE4▬12(E, I_y, L_cz, h_0, I_x, x_a, G, J, A_g, r_0)
    F_e = ( (π^2*E*I_y)/L_cz^2 * (h_0^2/4 + (I_x,I_y)*x_a^2) + G*J)*(1/(A_g*r_0^2))
end

end # module