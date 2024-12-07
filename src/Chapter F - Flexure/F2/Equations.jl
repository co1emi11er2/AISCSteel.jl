module Equations

export EqF2▬1, EqF2▬2, EqF2▬3, EqF2▬4, EqF2▬5, EqF2▬6, EqF2▬7, EqF2▬8a, EqF2▬8b

function EqF2▬1(F_y, Z_x)
    M_nFY = F_y * Z_x
end

function EqF2▬2(M_p, F_y, S_x, L_b, L_p, L_r, C_b=1)
    M_nLTB = C_b*(M_p - (M_p-0.7*F_y*S_x)*((L_b-L_p)/(L_r-L_p)))
end

function EqF2▬3(F_cr, S_x)
    M_nLTB = F_cr*S_x
end

function EqF2▬4(C_b, E, L_b, r_ts, J, c, S_x, h_0)
    F_cr = ((C_b*π^2*E)/(L_b/r_ts)^2)*sqrt(1 + 0.078*((J*c)/(S_x*h_0))*(L_b/r_ts)^2)
end

function EqF2▬5(E, F_y, r_y)
    L_p = 1.76*r_y*sqrt(E/F_y)
end

function EqF2▬6(r_ts, E, F_y, J, c, S_x, h_0)
    L_r = 1.95*r_ts*(E/(0.7*F_y))*sqrt((J*c)/(S_x*h_0) + sqrt(((J*c)/(S_x*h_0))^2 + 6.76*((0.7*F_y)/E)^2))
end

function EqF2▬7(I_y, C_w, S_x)
    r_ts = sqrt(sqrt(I_y*C_w)/S_x)
end

function EqF2▬8a()
    c = 1
end

function EqF2▬8b(h_0, I_y, C_w)
    c = (h_0/2)*sqrt(I_y/C_w)
end

end # module