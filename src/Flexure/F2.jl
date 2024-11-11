##########################################################################################
##########################################################################################
# Design of members for flexure
##########################################################################################
##########################################################################################

# Plastic moment 
function _calc_Mp(F_y, Z_x) 
    M_p = F_y * Z_x
end

function _calc_Mp(F_y::T, Z_x) where T <: Quantity
    M_p =  _calc_Mp(F_y, Z_x)  |> kip*ft
end

function _calc_Fcr(C_b, E, L_b, r_ts, J, c, S_x, h_0)
    F_cr = ((C_b*π^2*E)/(L_b/r_ts)^2)*sqrt(1 + 0.078*((J*c)/(S_x*h_0))*(L_b/r_ts)^2)
end


# Lateral Torsionsal Buckling
function _calc_ltb(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, C_b=1)
    # 1. Yielding 
    M_p = _calc_Mp(F_y, Z_x)

    # 2. Lateral-Torsional Buckling
    L_p = 1.76*r_y*sqrt(E/F_y)
    L_r = 1.95*r_ts*(E/(0.7*F_y))*sqrt((J*c)/(S_x*h_0) + sqrt(((J*c)/(S_x*h_0))^2 + 6.76*((0.7*F_y)/E)^2))
    F_cr = _calc_Fcr(C_b, E, L_b, r_ts, J, c, S_x, h_0)

    M_n =   if L_b <= L_p
                M_p
            elseif L_p < L_b <= L_r
                C_b*(M_p - (M_p-0.7*F_y*S_x)*((L_b-L_p)/(L_r-L_p)))
            else
                F_cr*S_x
            end

    M_n = min(M_n, M_p)
end

function _calc_ltb(E::T, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, C_b=1) where T <: Quantity
    M_n =  _calc_ltb(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, C_b)  |> kip*ft
end
##########################################################################################
# Design of members for flexure - Section F2
##########################################################################################

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
    M_p = _calc_Mp(F_y, Z_x)

    # 2. Lateral-Torsional Buckling
    L_p = 1.76*r_y*sqrt(E/F_y)
    L_r = 1.95*r_ts*(E/(0.7*F_y))*sqrt((J*c)/(S_x*h_0) + sqrt(((J*c)/(S_x*h_0))^2 + 6.76*((0.7*F_y)/E)^2))
    F_cr = _calc_Fcr(C_b, E, L_b, r_ts, J, c, S_x, h_0)

    M_n =   if L_b <= L_p
                M_p
            elseif L_p < L_b <= L_r
                C_b*(M_p - (M_p-0.7*F_y*S_x)*((L_b-L_p)/(L_r-L_p)))
            else
                F_cr*S_x
            end

    M_n = min(M_n, M_p)
end

##########################################################################################
# Design of members for flexure - Section F3
##########################################################################################

"""
    flexure_capacity_f3(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, C_b=1, h, t_w, λ, λ_pf, λ_rf, f_class)

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
- `C_b`:
- `h`:
- `t_w`:
- `λ`:
- `λ_pf`:
- `λ_rf`:
- `f_class`:

# Returns 
- `M_n`: moment capacity of the section.

# Reference
- AISC Section F3
"""
function flexure_capacity_f3(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, C_b=1, h, t_w, λ, λ_pf, λ_rf, f_class)

    # Plastic Moment
    M_p = _calc_Mp(F_y, Z_x)

    # 1. Lateral Torsional Buckling from F2
    L_p = 1.76*r_y*sqrt(E/F_y)
    L_r = 1.95*r_ts*(E/(0.7*F_y))*sqrt((J*c)/(S_x*h_0) + sqrt(((J*c)/(S_x*h_0))^2 + 6.76*((0.7*F_y)/E)^2))
    F_cr = _calc_Fcr(C_b, E, L_b, r_ts, J, c, S_x, h_0)

    M_n1 =   if L_b <= L_p
                M_p
            elseif L_p < L_b <= L_r
                C_b*(M_p - (M_p-0.7*F_y*S_x)*((L_b-L_p)/(L_r-L_p)))
            else
                F_cr*S_x
            end

    k_c = 4/sqrt(h/t_w)
    k_c = max(min(k_c, 0.76), 0.35)

    # 2. Compression Flange Local Buckling
    M_n2 =  if f_class == :noncompact
                M_p - (M_p - 0.7*F_y*S_x)((λ - λ_pf)/(λ_rf - λ_pf))
            elseif f_class == :slender
                (0.9*E*k_c*S_x)/(λ^2)
            else
                error("Flange should be either :noncompact or :slender. Got $f_class")
            end

    M_n = min(M_n1, M_n2)

    return M_n
end


##########################################################################################
# Design of members for flexure - Section F4
##########################################################################################

_calc_aw(h_c, t_w, b_fc, t_fc) = a_w = (h_c*t_w)/(b_fc*t_fc)
_calc_rt(b_fc, a_w) = r_t = b_fc/sqrt(12*(1 + (1/6)*a_w))
function _calc_FL(S_xt, S_xc, F_y) 
    F_L_min = 0.5 * F_y
    F_L =   if S_xt/S_xc >= 0.7
                0.7*F_y
            else
                F_y*(S_xt/S_xc)
            end
    
    F_L = max(F_L_min, F_L)

    return F_L
end

function _calc_Rpc(I_yc, I_y, h_c, t_w, λ, λ_pw, λ_rw, M_p, M_yc) 
    R_pc =  if I_yc/I_y > 0.23
                if h_c/t_w <= λ_pw
                    M_p/M_yc
                else
                    min((M_p/M_yc) - (M_p/M_yc - 1)*((λ - λ_pw)/(λ_rw - λ_pw)), M_p/M_yc)
                end
            else
                1.0
            end

    return R_pc
    
end

function _calc_Rpt(I_yc, I_y, h_c, t_w, λ, λ_pw, λ_rw, M_p, M_yt) 

    R_pt =  if I_yc/I_y > 0.23
        if h_c/t_w <= λ_pw
            M_p/M_yt
        else
            min((M_p/M_yt) - (M_p/M_yt - 1)*((λ - λ_pw)/(λ_rw - λ_pw)), M_p/M_yt)
        end
    else
        1.0
    end

return R_pt

end

"""
    flexure_capacity_f4(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, C_b=1, h, t_w, λ, λ_pf, λ_rf, f_class)

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
- `C_b`:
- `h`:
- `t_w`:
- `λ`:
- `λ_pf`:
- `λ_rf`:
- `f_class`:

# Returns 
- `M_n`: moment capacity of the section.

# Reference
- AISC Section F4
"""
function flexure_capacity_f4(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, C_b=1, h, t_w, λ, λ_pf, λ_rf, f_class)

    M_n = error("Not implemented")
    M_p = min(F_y*Z_x, 1.6*F_y*S_x)

    R_pc = _calc_Rpc(I_yc, I_y, h_c, t_w, λ, λ_pw, λ_rw, M_p, M_yc) 

    # 1. Compression Flange Yielding
    M_n1 = R_pc*M_yc


    # 2. Lateral Torsional Buckling
    # (1) M_yc
    M_yc = F_y*S_xc

    # (2) F_cr
    # TODO: I_yc, h_c, b_fc, t_fc
    c = 1
    a_w = _calc_aw(h_c, t_w, b_fc, t_fc)
    r_t = _calc_rt(b_fc, a_w)
    J = if I_yc/I_y <= 0.23
            0
        else
            J
        end
    
    F_cr = _calc_Fcr(C_b, E, L_b, r_t, J, c, S_xc, h_0)

    # (3) F_L
    F_L = _calc_FL(S_xt, S_xc, F_y) 

    # (4) L_p
    L_p = 1.1*r_t*sqrt(E/F_y)

    # (5) L_r
    L_r = 1.95*r_t*(E/(F_L))*sqrt((J)/(S_xc*h_0) + sqrt(((J)/(S_xc*h_0))^2 + 6.76*((F_L)/E)^2))

    # (6) R_pc
    

    M_n2 =  if L_b <= L_p
                M_p
            elseif L_p < L_b <= L_r
                C_b*(R_pc*M_yc - (R_pc*M_yc - F_L*S_xc)*((L_b - L_p)/(L_r - L_p)))
            else
                F_cr*S_xc
            end

    # 3. Compression Flange Local Buckling
    M_n3 =  if f_class == :compact
                M_p
            elseif f_class == :noncompact
                R_pc*M_yc - (R_pc*M_yc - F_L*S_xc) * ((λ - λ_pf)/(λ_rf - λ_pf))
            else
                (0.9*E*k_c*S_xc)/λ^2
            end

    # 4. Tension Flange Yielding
    R_pt = _calc_Rpt(I_yc, I_y, h_c, t_w, λ, λ_pw, λ_rw, M_p, M_yt) 
    M_n4 =  if S_xt >= S_xc
                M_p
            else
                R_pt*M_yt
            end



    return M_n
end

##########################################################################################
# Design of members for flexure - Section F5
##########################################################################################

"""
    flexure_capacity_f5(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, C_b=1, h, t_w, λ, λ_pf, λ_rf, f_class)

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
- `C_b`:
- `h`:
- `t_w`:
- `λ`:
- `λ_pf`:
- `λ_rf`:
- `f_class`:

# Returns 
- `M_n`: moment capacity of the section.

# Reference
- AISC Section F5
"""
function flexure_capacity_f5(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, C_b=1, h, t_w, λ, λ_pf, λ_rf, f_class)

    M_n = error("Not implemented")

    return M_n
end