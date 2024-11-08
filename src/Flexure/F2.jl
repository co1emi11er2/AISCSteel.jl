struct F2{T}
    s::T
end

"""
    function flexure_capacity_f2(;E, G, F_y, Z_x, S_x, I_y, r_y, h_0, J, C_w, c, r_ts, L_b)

Calculates the moment capacity of the applicable section.

Description of applicable member: Doubly symmetric compact I-shaped members and channels bent about their major axis. 

# Arguments
- `E`: elastic section modulous.
- `G`: shear modulous.
- `F_y`: yield strength of steel.
- `Z_x`: 
- `S_x`:
- `I_y`:
- `r_y`:
- `h_0`:
- `J`:
- `C_w`:
- `c`:
- `r_ts`:
- `L_b`:

# Returns 
- `M_n`: moment capacity of the section.

# Reference
- AISC Section F2
"""
function flexure_capacity_f2(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, C_b=1)
    
    # 1. Yielding 
    M_p = F_y*Z_x

    # 2. Lateral-Torsional Buckling
    L_p = 1.76*r_y*sqrt(E/F_y)
    L_r = 1.95*r_ts*(E/(0.7*F_y))*sqrt((J*c)/(S_x*h_0) + sqrt(((J*c)/(S_x*h_0))^2 + 6.76*((0.7*F_y)/E)))
    F_cr = ((C_b*π^2*E)/(L_b/r_ts)^2)*sqrt(1 + 0.078*((J*c)/(S_x*h_0))*(L_b/r_ts)^2)

    M_n =   if L_b <= L_p
                M_p
            elseif L_p < L_b <= L_r
                C_b*(M_p - (M_p-0.7*F_y*S_x)*((L_b-L_p)/(L_r-L_p)))
            else
                F_cr*S_x
            end

    M_n = min(M_n, M_p)

    return M_n
end
