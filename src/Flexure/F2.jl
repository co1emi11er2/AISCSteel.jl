##########################################################################################
##########################################################################################
# Design of members for flexure
##########################################################################################
##########################################################################################

# Plastic moment 
function _calc_Mp(F_y, Z_x) 
    M_p = F_y * Z_x |> kip*ft
end

function _calc_Fcr(C_b, E, L_b, r_ts, J, c, S_x, h_0)
    F_cr = ((C_b*π^2*E)/(L_b/r_ts)^2)*sqrt(1 + 0.078*((J*c)/(S_x*h_0))*(L_b/r_ts)^2) |> ksi
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

##########################################################################################
# Design of members for flexure - Section F2
##########################################################################################

function flexure_capacity_f2_1(F_y, Z_x)
    # 1. Yielding 
    M_p = _calc_Mp(F_y, Z_x) |> kip*ft
end

function flexure_capacity_f2_2(M_p, E, F_y, S_x, r_y, h_0, J, c, r_ts, L_b, C_b=1)
    # 2. Lateral-Torsional Buckling
    L_p = 1.76*r_y*sqrt(E/F_y)
    L_r = 1.95*r_ts*(E/(0.7*F_y))*sqrt((J*c)/(S_x*h_0) + sqrt(((J*c)/(S_x*h_0))^2 + 6.76*((0.7*F_y)/E)^2))
    F_cr = _calc_Fcr(C_b, E, L_b, r_ts, J, c, S_x, h_0)

    M_n2 =   if L_b <= L_p
                M_p
            elseif L_p < L_b <= L_r
                C_b*(M_p - (M_p-0.7*F_y*S_x)*((L_b-L_p)/(L_r-L_p)))
            else
                F_cr*S_x
            end |> kip*ft
    
end

"""
    function flexure_capacity_f2(E, G, F_y, Z_x, S_x, I_y, r_y, h_0, J, C_w, c, r_ts, L_b)

Calculates the moment capacity of the applicable section.

Description of applicable member: Doubly symmetric compact I-shaped members and channels bent about their major axis. 

# Arguments
- `E`: modulous of elasticity (ksi)
- `F_y`: yield strength of steel (ksi)
- `Z_x`: plastic section modulous  (inch^4)
- `S_x`: elastic section modulous (inch^3)
- `r_y`: radius of gyration about the y-axis (inch)
- `h_0`: distance between the flange centroids (inch)
- `J`: torsional constant (inch^4)
- `c`:
- `r_ts`:
- `L_b`: unbraced length (inch)

# Returns 
- `M_n`: moment capacity of the section.

# Reference
- AISC Section F2
"""
function flexure_capacity_f2(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, C_b=1)

    # 1. Yielding 
    M_p = flexure_capacity_f2_1(F_y, Z_x)

    # 2. Lateral-Torsional Buckling
    M_n2 = flexure_capacity_f2_2(M_p, E, F_y, S_x, r_y, h_0, J, c, r_ts, L_b, C_b)

    M_n = min(M_n2, M_p)

    return M_n
end

##########################################################################################
# Design of members for flexure - Section F3
##########################################################################################
function flexure_capacity_f3_1(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b)

    # 1. Lateral Torsional Buckling from F2
    C_b = 1

    # Plastic Moment
    M_p = _calc_Mp(F_y, Z_x)

    # Lateral Torsional Buckling
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
end

function flexure_capacity_f3_2(E, F_y, Z_x, S_x, h, t_w, λ_f, λ_pf, λ_rf, λ_fclass)

    # Plastic Moment
    M_p = _calc_Mp(F_y, Z_x)

    # 2. Compression Flange Local Buckling
    k_c = 4/sqrt(h/t_w)
    k_c = max(min(k_c, 0.76), 0.35)

    M_n2 =  if λ_fclass == :noncompact
                M_p - (M_p - 0.7*F_y*S_x)*((λ_f - λ_pf)/(λ_rf - λ_pf))
            elseif λ_fclass == :slender
                (0.9*E*k_c*S_x)/(λ_f^2)
            else
                M_p
            end

    return M_n2
end


"""
    flexure_capacity_f3(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, h, t_w, λ_f, λ_pf, λ_rf, λ_fclass)

Calculates the moment capacity of the applicable section.

Description of applicable member: Doubly symmetric I-shaped members with compact webs and noncompact or slender flanges bent about their major axis.

# Arguments
- `E`: modulous of elasticity (ksi)
- `F_y`: yield strength of steel (ksi)
- `Z_x`: plastic section modulous  (inch^4)
- `S_x`: elastic section modulous (inch^3)
- `r_y`: radius of gyration about the y-axis (inch)
- `h_0`: distance between the flange centroids (inch)
- `J`: torsional constant (inch^4)
- `c`:
- `r_ts`:
- `L_b`: unbraced length (inch)
- `h`: clear distance between flanges less the fillets (inch)
- `t_w`: thickness of the web (inch)
- `λ_f`: slenderness ratio of the flange
- `λ_pf`: compact slenderness ratio limit of the flange
- `λ_rf`: noncompact slenderness ratio limit of the flange
- `λ_fclass`: `compact` `noncompact` or `slender`

# Returns 
- `M_n`: moment capacity of the section.

# Reference
- AISC Section F3
"""
function flexure_capacity_f3(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, h, t_w, λ_f, λ_pf, λ_rf, λ_fclass)

    # 1. Lateral Torsional Buckling from F2
    M_n1 = flexure_capacity_f3_1(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b)

    # 2. Compression Flange Local Buckling
    M_n2 =  flexure_capacity_f3_2(E, F_y, Z_x, S_x, h, t_w, λ_f, λ_pf, λ_rf, λ_fclass)

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
    flexure_capacity_f4(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, h, t_w, λ, λ_pf, λ_rf, λ_fclass)

Calculates the moment capacity of the applicable section.

Description of applicable member: Doubly symmetric I-shaped members with compact webs and noncompact or slender flanges bent about their major axis.

# Arguments
- `E`: modulous of elasticity (ksi)
- `F_y`: yield strength of steel (ksi)
- `Z_x`: plastic section modulous  (inch^4)
- `S_x`: elastic section modulous (inch^3)
- `r_y`: radius of gyration about the y-axis (inch)
- `h_0`: distance between the flange centroids (inch)
- `J`: torsional constant (inch^4)
- `c`:
- `r_ts`:
- `L_b`: unbraced length (inch)
- `h`: clear distance between flanges less the fillets (inch)
- `t_w`: thickness of the web (inch)
- `λ_f`: slenderness ratio of the flange
- `λ_pf`: compact slenderness ratio limit of the flange
- `λ_rf`: noncompact slenderness ratio limit of the flange
- `λ_fclass`: `compact` `noncompact` or `slender`

# Returns 
- `M_n`: moment capacity of the section.

# Reference
- AISC Section F4
"""
function flexure_capacity_f4(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, h, t_w, λ_f, λ_pf, λ_rf, λ_fclass)

    C_b=1

    M_p = min(F_y*Z_x, 1.6*F_y*S_x)

    R_pc = _calc_Rpc(I_yc, I_y, h_c, t_w, λ_f, λ_pw, λ_rw, M_p, M_yc) 

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
    M_n3 =  if λ_fclass == :compact
                M_p
            elseif λ_fclass == :noncompact
                R_pc*M_yc - (R_pc*M_yc - F_L*S_xc) * ((λ_f - λ_pf)/(λ_rf - λ_pf))
            else
                (0.9*E*k_c*S_xc)/λ_f^2
            end

    # 4. Tension Flange Yielding
    R_pt = _calc_Rpt(I_yc, I_y, h_c, t_w, λ_f, λ_pw, λ_rw, M_p, M_yt) 
    M_n4 =  if S_xt >= S_xc
                M_p
            else
                R_pt*M_yt
            end

    M_n = min(M_n1, M_n2, M_n3, M_n4)

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
function flexure_capacity_f5(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, h, t_w, λ, λ_pf, λ_rf, f_class)

    C_b=1
    M_n = error("Not implemented")
    
    # 1. Compression Flange Yielding
    a_w = _calc_aw(h_c, t_w, b_fc, t_fc)
    R_pg = 1 - a_w/(1200 + 300*a_w) * (h_c/t_w - 5.7*sqrt(E/F_y))
    R_pg = min(R_pg, 1.0)

    M_p = R_pg*F_y*S_xc

    # 2. Lateral Torsional Buckling
    r_t = _calc_rt(b_fc, a_w)
    L_p = 1.1*r_t*sqrt(E/F_y)
    L_r = π*r_t*sqrt(E/(0.7*F_y))
    F_cr =  if L_b <= L_p
                F_y
            elseif L_p < L_b <= L_r
                C_b*(F_y - (0.3*F_y)((L_b - L_p)/ (L_r - L_p)))
            else
                (C_b*π^2*E)/(L_b/r_t)^2
            end
    
    F_cr = min(F_cr, F_y)

    M_n2 = R_pg*F_cr*S_xc

    # 3. Compression Flange Local Buckling
    k_c = 4/sqrt(h/t_w)
    F_cr =  if f_class == :compact
                F_y
            elseif f_class == :noncompact
                (F_y - (0.3*F_y)((λ - λ_pf)/ (λ_rf - λ_pf)))
            else
                (0.9*E*k_c)/(b_f/(2*t_f))^2
            end
    
    M_n3 = R_pg*F_cr*S_xc

    # 4. Tension Flange Yielding
    M_n4 =  if S_xt >= S_xc
                M_n = M_p
            else
                M_n = F_y*S_xt
            end

    M_n = min(M_p, M_n2, M_n3, M_n4)

    return M_n
end