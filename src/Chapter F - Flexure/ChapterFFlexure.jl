##########################################################################################
##########################################################################################
# Design of members for flexure
##########################################################################################
##########################################################################################
module ChapterFFlexure

# Section F1
include("F1/F1.jl")

# Section F2
include("F2/F2.jl")

# Section F3
include("F3/F3.jl")

# Section F4
include("F4/F4.jl")

# Section F5
include("F5/F5.jl")

# Plastic moment 
function _calc_Mp(F_y, Z_x) 
    M_p = F_y * Z_x |> kip*ft
end

function _calc_Fcr(C_b, E, L_b, r_ts, J, c, S_x, h_0)
    F_cr = ((C_b*π^2*E)/(L_b/r_ts)^2)*sqrt(1 + 0.078*((J*c)/(S_x*h_0))*(L_b/r_ts)^2) |> ksi
end

##########################################################################################
# Design of members for flexure - Section F2
##########################################################################################

function flexure_capacity_f2_variables(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, C_b=1)

    M_p = _calc_Mp(F_y, Z_x) 

    L_p = 1.76*r_y*sqrt(E/F_y)
    L_r = 1.95*r_ts*(E/(0.7*F_y))*sqrt((J*c)/(S_x*h_0) + sqrt(((J*c)/(S_x*h_0))^2 + 6.76*((0.7*F_y)/E)^2))
    F_cr = _calc_Fcr(C_b, E, L_b, r_ts, J, c, S_x, h_0)

    return (;M_p, L_p, L_r, F_cr)
end

"""
    flexure_capacity_f2_1(M_p)

Calculates the moment capacity of the applicable section for yielding.

Description of applicable member: Doubly symmetric compact I-shaped members and channels bent about their major axis. 

# Arguments
- `M_p`: plastic moment of the section (kip-ft)

# Returns 
- `M_nFY`: moment capacity of the section for yielding.

# Reference
- AISC Section F2.1
"""
function flexure_capacity_f2_1(M_p)
    # 1. Yielding 
    M_nFY = M_p
end

"""
    flexure_capacity_f2_2(M_p, F_y, S_x, F_cr, L_b, L_p, L_r, C_b=1)

Calculates the moment capacity of the applicable section for lateral torsional buckling.

Description of applicable member: Doubly symmetric compact I-shaped members and channels bent about their major axis. 

# Arguments
- `M_p`: plastic moment of the section (kip-ft)
- `F_y`: yield strength of steel (ksi)
- `S_x`: elastic section modulous (inch^3)
- `F_cr`: critical stress (ksi)
- `L_b`: unbraced length (inch)
- `L_p`: the limiting laterally unbraced length for the limit state of yielding (inch)
- `L_r`: the limiting laterally unbraced length for the limit state of inelastic lateral-torsional buckling (inch)
- `C_b`: lateral torsional buckling modification factor (default = 1)

# Returns 
- `M_nLTB`: moment capacity of the section for lateral torsional buckling.

# Reference
- AISC Section F2.2
"""
function flexure_capacity_f2_2(M_p, F_y, S_x, F_cr, L_b, L_p, L_r, C_b=1)

    # 2. Lateral-Torsional Buckling
    M_nLTB =   if L_b <= L_p
                M_p
            elseif L_p < L_b <= L_r
                C_b*(M_p - (M_p-0.7*F_y*S_x)*((L_b-L_p)/(L_r-L_p)))
            else
                F_cr*S_x
            end |> kip*ft
    
end

"""
    flexure_capacity_f2(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, C_b=1)

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
- `C_b`: lateral torsional buckling modification factor (default = 1)

# Returns 
- `M_n`: moment capacity of the section.

# Reference
- AISC Section F2
"""
function flexure_capacity_f2(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, C_b=1)

    (;M_p, L_p, L_r, F_cr) = flexure_capacity_f2_variables(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, C_b)

    # 1. Yielding 
    M_nFY = flexure_capacity_f2_1(M_p)

    # 2. Lateral-Torsional Buckling
    M_nLTB = flexure_capacity_f2_2(M_p, F_y, S_x, F_cr, L_b, L_p, L_r, C_b)

    M_n = min(M_nFY, M_nLTB)

    return M_n
end

##########################################################################################
# Design of members for flexure - Section F3
##########################################################################################
function flexure_capacity_f3_variables(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, h, t_w, C_b=1)

    (;M_p, L_p, L_r, F_cr) = flexure_capacity_f2_variables(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, C_b)

    k_c = 4/sqrt(h/t_w)
    k_c = max(min(k_c, 0.76), 0.35)

    return (;M_p, L_p, L_r, F_cr, k_c)
end

"""
    flexure_capacity_f3_1(M_p, F_y, S_x, F_cr, L_b, L_p, L_r, C_b=1)

Calculates the moment capacity of the applicable section for yielding.

Description of applicable member: Doubly symmetric I-shaped members with compact webs and noncompact or slender flanges bent about their major axis. 

# Arguments
- `M_p`: plastic moment of the section (kip-ft)
- `F_y`: yield strength of steel (ksi)
- `S_x`: elastic section modulous (inch^3)
- `F_cr`: critical stress (ksi)
- `L_b`: unbraced length (inch)
- `L_p`: the limiting laterally unbraced length for the limit state of yielding (inch)
- `L_r`: the limiting laterally unbraced length for the limit state of inelastic lateral-torsional buckling (inch)
- `C_b`: lateral torsional buckling modification factor (default = 1)

# Returns 
- `M_nLTB`: moment capacity of the section for lateral torsional buckling.

# Reference
- AISC Section F3.1
"""
function flexure_capacity_f3_1(M_p, F_y, S_x, F_cr, L_b, L_p, L_r, C_b=1)

    # 1. Lateral-Torsional Buckling
    M_nLTB = flexure_capacity_f2_2(M_p, F_y, S_x, F_cr, L_b, L_p, L_r, C_b)
end

"""
    flexure_capacity_f3_2(M_p, E, F_y, S_x, k_c, λ_f, λ_pf, λ_rf, λ_fclass)

Calculates the moment capacity of the applicable section for compression flange local buckling.

Description of applicable member: Doubly symmetric I-shaped members with compact webs and noncompact or slender flanges bent about their major axis. 

# Arguments
- `M_p`: plastic moment of the section (kip-ft)
- `E`: modulous of elasticity (ksi)
- `F_y`: yield strength of steel (ksi)
- `S_x`: elastic section modulous (inch^3)
- `k_c`: 
- `λ_f`: slenderness ratio of the flange
- `λ_pf`: compact slenderness ratio limit of the flange
- `λ_rf`: noncompact slenderness ratio limit of the flange
- `λ_fclass`: `compact` `noncompact` or `slender` classification for the flange

# Returns 
- `M_nCFLB`: moment capacity of the section for compression flange local buckling.

# Reference
- AISC Section F3.2
"""
function flexure_capacity_f3_2(M_p, E, F_y, S_x, k_c, λ_f, λ_pf, λ_rf, λ_fclass)

    # 2. Compression Flange Local Buckling
    M_nCFLB =  if λ_fclass == :noncompact
                    M_p - (M_p - 0.7*F_y*S_x)*((λ_f - λ_pf)/(λ_rf - λ_pf))
                elseif λ_fclass == :slender
                    (0.9*E*k_c*S_x)/(λ_f^2)
                else
                    M_p
                end

end


"""
    flexure_capacity_f3(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, h, t_w, λ_f, λ_pf, λ_rf, λ_fclass, C_b=1)

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
- `λ_fclass`: `compact` `noncompact` or `slender` classification for the flange
- `C_b`: lateral torsional buckling modification factor (default = 1)

# Returns 
- `M_n`: moment capacity of the section.

# Reference
- AISC Section F3
"""
function flexure_capacity_f3(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, h, t_w, λ_f, λ_pf, λ_rf, λ_fclass, C_b=1)

    (;M_p, L_p, L_r, F_cr, k_c) = flexure_capacity_f3_variables(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, h, t_w, C_b)

    # 1. Lateral Torsional Buckling from F2
    M_n1 = flexure_capacity_f3_1(M_p, F_y, S_x, F_cr, L_b, L_p, L_r, C_b)

    # 2. Compression Flange Local Buckling
    M_n2 = flexure_capacity_f3_2(M_p, E, F_y, S_x, k_c, λ_f, λ_pf, λ_rf, λ_fclass)

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

function _calc_Rpc(I_yc, I_y, h_c, t_w, λ_w, λ_pw, λ_rw, M_p, M_yc) 
    R_pc =  if I_yc/I_y > 0.23
                if h_c/t_w <= λ_pw
                    M_p/M_yc
                else
                    min((M_p/M_yc) - (M_p/M_yc - 1)*((λ_w - λ_pw)/(λ_rw - λ_pw)), M_p/M_yc)
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

function flexure_capacity_f4_variables(E, F_y, Z_x, S_x, S_xc, S_xt, b_fc, t_fc, h, h_c, t_w, J, h_0, I_y, I_yc, λ_w, λ_pw, λ_rw, L_b, C_b)

    M_p = min(F_y*Z_x, 1.6*F_y*S_x)

    M_yc = F_y*S_xc
    M_yt = F_y*S_xt

    # (2) F_cr
    a_w = _calc_aw(h_c, t_w, b_fc, t_fc)
    r_t = _calc_rt(b_fc, a_w)
    J = if I_yc/I_y <= 0.23
            zero(typeof(J))
        else
            J
        end

    k_c = 4/sqrt(h/t_w)
    k_c = max(min(k_c, 0.76), 0.35)

    F_cr = ((C_b*π^2*E)/(L_b/r_t)^2)*sqrt(1 + 0.078*((J)/(S_xc*h_0))*(L_b/r_t)^2) |> ksi

    # (3) F_L
    F_L = _calc_FL(S_xt, S_xc, F_y) 

    # (4) L_p
    L_p = 1.1*r_t*sqrt(E/F_y)

    # (5) L_r
    L_r = 1.95*r_t*(E/(F_L))*sqrt((J)/(S_xc*h_0) + sqrt(((J)/(S_xc*h_0))^2 + 6.76*((F_L)/E)^2))

    R_pc = _calc_Rpc(I_yc, I_y, h_c, t_w, λ_w, λ_pw, λ_rw, M_p, M_yc) 
    R_pt = _calc_Rpt(I_yc, I_y, h_c, t_w, λ_w, λ_pw, λ_rw, M_p, M_yt) 

    return (;M_p, M_yc, M_yt, k_c, F_cr, F_L, L_p, L_r, R_pc, R_pt)
end

"""
    flexure_capacity_f4_1(R_pc, M_yc)

Calculates the moment capacity of the applicable section for compression flange yielding.

Description of applicable member: Other I-shaped members with compact webs or noncompact webs bent about their major axis.

# Arguments
- `R_pc`: web plastification factor
- `M_yc`: yield moment in the compression flange 

# Returns 
- `M_nCFY`: moment capacity of the section for compression flange yielding.

# Reference
- AISC Section F4.1
"""
function flexure_capacity_f4_1(R_pc, M_yc)
    # 1. Compression Flange Yielding
    M_nCFY = R_pc*M_yc

    return M_nCFY
end

"""
    flexure_capacity_f4_2(M_p, R_pc, M_yc, F_L, S_xc, F_cr, L_b, L_p, L_r, C_b=1)

Calculates the moment capacity of the applicable section for lateral torsional buckling.

Description of applicable member: Other I-shaped members with compact webs or noncompact webs bent about their major axis.

# Arguments
- `M_p`: plastic moment of the section (kip-ft)
- `R_pc`: web plastification factor
- `M_yc`: yield moment in the compression flange 
- `F_L`: nominal compression flange stress above which the inelastic buckling limit states apply (ksi)
- `S_xc`: elastic section modulous referred to compression flange (inch^3)
- `F_cr`: critical stress (ksi)
- `L_b`: unbraced length (inch)
- `L_p`: the limiting laterally unbraced length for the limit state of yielding (inch)
- `L_r`: the limiting laterally unbraced length for the limit state of inelastic lateral-torsional buckling (inch)
- `C_b`: lateral torsional buckling modification factor (default = 1)

# Returns 
- `M_nLTB`: moment capacity of the section for lateral torsional buckling.

# Reference
- AISC Section F4.2
"""
function flexure_capacity_f4_2(M_p, R_pc, M_yc, F_L, S_xc, F_cr, L_b, L_p, L_r, C_b=1)
    # 2. Lateral Torsional Buckling
    M_nLTB =  if L_b <= L_p
        M_p
    elseif L_p < L_b <= L_r
        C_b*(R_pc*M_yc - (R_pc*M_yc - F_L*S_xc)*((L_b - L_p)/(L_r - L_p)))
    else
        F_cr*S_xc
    end

    return M_nLTB
end

"""
    flexure_capacity_f4_3(M_p, R_pc, M_yc, F_L, S_xc, E, k_c, λ_f, λ_pf, λ_rf, λ_fclass)

Calculates the moment capacity of the applicable section for compression flange local buckling.

Description of applicable member: Other I-shaped members with compact webs or noncompact webs bent about their major axis.

# Arguments
- `M_p`: plastic moment of the section (kip-ft)
- `R_pc`: web plastification factor
- `M_yc`: yield moment in the compression flange 
- `F_L`: nominal compression flange stress above which the inelastic buckling limit states apply (ksi)
- `S_xc`: elastic section modulous referred to compression flange (inch^3)
- `E`: modulous of elasticity (ksi)
- `k_c`: 
- `λ_f`: slenderness ratio of the flange
- `λ_pf`: compact slenderness ratio limit of the flange
- `λ_rf`: noncompact slenderness ratio limit of the flange
- `λ_fclass`: `compact` `noncompact` or `slender` classification for the flange

# Returns 
- `M_nCFLB`: moment capacity of the section for compression flange local buckling.

# Reference
- AISC Section F4.3
"""
function flexure_capacity_f4_3(M_p, R_pc, M_yc, F_L, S_xc, E, k_c, λ_f, λ_pf, λ_rf, λ_fclass)
    # 3. Compression Flange Local Buckling
    M_nCFLB =  if λ_fclass == :compact
        M_p
    elseif λ_fclass == :noncompact
        R_pc*M_yc - (R_pc*M_yc - F_L*S_xc) * ((λ_f - λ_pf)/(λ_rf - λ_pf))
    else
        (0.9*E*k_c*S_xc)/λ_f^2
    end

    return M_nCFLB
end

"""
    flexure_capacity_f4_4(M_p, R_pt, M_yt, S_xc, S_xt)

Calculates the moment capacity of the applicable section for tension flange yielding.

Description of applicable member: Other I-shaped members with compact webs or noncompact webs bent about their major axis.

# Arguments
- `M_p`: plastic moment of the section (kip-ft)
- `R_pt`: web plastification factor corresponding to the tension flange yielding limit state
- `M_yt`: yield moment in the tension flange 
- `S_xc`: elastic section modulous referred to compression flange (inch^3)
- `S_xt`: elastic section modulous referred to tension flange (inch^3)

# Returns 
- `M_nTFY`: moment capacity of the section for tension flange yielding.

# Reference
- AISC Section F4.4
"""
function flexure_capacity_f4_4(M_p, R_pt, M_yt, S_xc, S_xt)
    # 4. Tension Flange Yielding
    M_nTFY =  if S_xt >= S_xc
        M_p
    else
        R_pt*M_yt
    end

    return M_nTFY
end

"""
    flexure_capacity_f4(E, F_y, Z_x, S_x, S_xc, S_xt, b_fc, t_fc, h, h_c, t_w, J, h_0, I_y, I_yc, λ_w, λ_pw, λ_rw, λ_f, λ_pf, λ_rf, λ_fclass, L_b, C_b=1)

Calculates the moment capacity of the applicable section.

Description of applicable member: Other I-shaped members with compact webs or noncompact webs bent about their major axis.

# Arguments
- `E`: modulous of elasticity (ksi)
- `F_y`: yield strength of steel (ksi)
- `Z_x`: plastic section modulous  (inch^4)
- `S_x`: elastic section modulous (inch^3)
- `S_xc`: elastic section modulous referred to compression flange (inch^3)
- `S_xt`: elastic section modulous referred to tension flange (inch^3)
- `b_fc`: width of compression flange (inch)
- `t_fc`: thickness of compression flange (inch)
- `h`: clear distance between flanges less the fillets (inch)
- `h_c`: twice the distance from the centroid to the following: (inch)
    - the inside face of the compression flange less the fillet or corner radius for rolled shapes
    - the nearest line of fasteners at the compression flange or inside face of the compression flange when welds are used for built-up sections
- `t_w`: thickness of the web (inch)
- `J`: torsional constant (inch^4)
- `h_0`: distance between the flange centroids (inch)
- `I_y`: second moment of inertia about the y-axis (inch^4)
- `I_yc`: second moment of inertia about the y-axis for the compression flange (inch^4)
- `λ_w`: slenderness ratio of the flange
- `λ_pw`: compact slenderness ratio limit of the web
- `λ_rw`: noncompact slenderness ratio limit of the web
- `λ_f`: slenderness ratio of the flange
- `λ_pf`: compact slenderness ratio limit of the flange
- `λ_rf`: noncompact slenderness ratio limit of the flange
- `λ_fclass`: `compact` `noncompact` or `slender` classification for the flange
- `L_b`: unbraced length (inch)
- `C_b`: lateral torsional buckling modification factor (default = 1)

# Returns 
- `M_n`: moment capacity of the section.

# Reference
- AISC Section F4
"""
function flexure_capacity_f4(E, F_y, Z_x, S_x, S_xc, S_xt, b_fc, t_fc, h, h_c, t_w, J, h_0, I_y, I_yc, λ_w, λ_pw, λ_rw, λ_f, λ_pf, λ_rf, λ_fclass, L_b, C_b)

    (;M_p, M_yc, M_yt, k_c, F_cr, F_L, L_p, L_r, R_pc, R_pt) = flexure_capacity_f4_variables(E, F_y, Z_x, S_x, S_xc, S_xt, b_fc, t_fc, h, h_c, t_w, J, h_0, I_y, I_yc, λ_w, λ_pw, λ_rw, L_b, C_b)

    # 1. Compression Flange Yielding
    M_nCFY = flexure_capacity_f4_1(R_pc, M_yc)

    # 2. Lateral Torsional Buckling
    M_nLTB =  flexure_capacity_f4_2(M_p, R_pc, M_yc, F_L, S_xc, F_cr, L_b, L_p, L_r, C_b)

    # 3. Compression Flange Local Buckling
    M_nCFLB =  flexure_capacity_f4_3(M_p, R_pc, M_yc, F_L, S_xc, E, k_c, λ_f, λ_pf, λ_rf, λ_fclass)

    # 4. Tension Flange Yielding
    M_nTFY =  flexure_capacity_f4_4(M_p, R_pt, M_yt, S_xc, S_xt)

    M_n = min(M_nCFY, M_nLTB, M_nCFLB, M_nTFY)

    return M_n
end

##########################################################################################
# Design of members for flexure - Section F5
##########################################################################################
function flexure_capacity_f5_variables(E, F_y, S_xc, b_fc, t_fc, h, h_c, t_w, λ_f, λ_pf, λ_rf, λ_fclass, L_b, C_b=1)

    a_w = _calc_aw(h_c, t_w, b_fc, t_fc)
    a_w = min(a_w, 10.0)

    R_pg = 1 - a_w/(1200 + 300*a_w) * (h_c/t_w - 5.7*sqrt(E/F_y))
    R_pg = min(R_pg, 1.0)
    
    M_p = R_pg*F_y*S_xc

    r_t = _calc_rt(b_fc, a_w)

    L_p = 1.1*r_t*sqrt(E/F_y)
    L_r = π*r_t*sqrt(E/(0.7*F_y))

    F_crLTB =   if L_b <= L_p
                    F_y
                elseif L_p < L_b <= L_r
                    C_b*(F_y - 0.3*F_y*((L_b-L_p)/(L_r-L_p)))
                else
                    (C_b*π^2*E)/(L_b/r_t)^2
                end

    F_crLTB = min(F_crLTB, F_y)

    k_c = 4/sqrt(h/t_w)
    k_c = max(min(k_c, 0.76), 0.35)

    F_crCFLB =  if λ_fclass == :compact
                    F_y
                elseif λ_fclass == :noncompact
                    F_y - 0.3*F_y*((λ_f-λ_pf)/(λ_rf-λ_pf))
                else
                    (0.9*E*k_c)/(b_fc/(2*t_fc))^2
                end

    return (;M_p, R_pg, F_crLTB, F_crCFLB)
end

"""
    flexure_capacity_f5_1(M_p)

Calculates the moment capacity of the applicable section for compression flange yielding.

Description of applicable member: I-shaped members with slender webs bent about their major axis.

# Arguments
- `M_p`: plastic moment of the section (kip-ft)

# Returns 
- `M_nCFY`: moment capacity of the section for compression flange yielding.

# Reference
- AISC Section F5.1
"""
function flexure_capacity_f5_1(M_p)
    M_nCFY = M_p
end

"""
    flexure_capacity_f5_2(R_pg, F_crLTB, S_xc)

Calculates the moment capacity of the applicable section for lateral torsional buckling.

Description of applicable member: I-shaped members with slender webs bent about their major axis.

# Arguments
- `R_pg`: bending strength reduction factor
- `F_crLTB`: critical stress relating to lateral torsional buckling
- `S_xc`: elastic section modulous referred to compression flange (inch^3)

# Returns 
- `M_nLTB`: moment capacity of the section for lateral torsional buckling.

# Reference
- AISC Section F5.2
"""
function flexure_capacity_f5_2(R_pg, F_crLTB, S_xc)
    M_nLTB = R_pg*F_crLTB*S_xc
end

"""
    flexure_capacity_f5_3(R_pg, F_crCFLB, S_xc)

Calculates the moment capacity of the applicable section for compression flange lateral buckling.

Description of applicable member: I-shaped members with slender webs bent about their major axis.

# Arguments
- `R_pg`: bending strength reduction factor
- `F_crCFLB`: critical stress relating to compression flange lateral buckling
- `S_xc`: elastic section modulous referred to compression flange (inch^3)

# Returns 
- `M_nCFLB`: moment capacity of the section for compression flange lateral buckling.

# Reference
- AISC Section F5.3
"""
function flexure_capacity_f5_3(R_pg, F_crCFLB, S_xc)
    M_nCFLB = R_pg*F_crCFLB*S_xc
end

"""
    flexure_capacity_f5_4(F_y, S_xt)

Calculates the moment capacity of the applicable section for tension flange yielding.

Description of applicable member: I-shaped members with slender webs bent about their major axis.

# Arguments
- `F_y`: yield strength of steel (ksi)
- `S_xt`: elastic section modulous referred to tension flange (inch^3)

# Returns 
- `M_nTFY`: moment capacity of the section for tension flange yielding.

# Reference
- AISC Section F5.4
"""
function flexure_capacity_f5_4(F_y, S_xt)
    M_nTFY = F_y*S_xt
end

"""
    flexure_capacity_f5(E, F_y, S_xc, S_xt, b_fc, t_fc, h, h_c, t_w, λ_f, λ_pf, λ_rf, λ_fclass, L_b, C_b=1)

Calculates the moment capacity of the applicable section.

Description of applicable member: I-shaped members with slender webs bent about their major axis.

# Arguments
- `E`: modulous of elasticity (ksi)
- `F_y`: yield strength of steel (ksi)
- `S_x`: elastic section modulous (inch^3)
- `S_xc`: elastic section modulous referred to compression flange (inch^3)
- `S_xt`: elastic section modulous referred to tension flange (inch^3)
- `b_fc`: width of compression flange (inch)
- `t_fc`: thickness of compression flange (inch)
- `h`: clear distance between flanges less the fillets (inch)
- `h_c`: twice the distance from the centroid to the following: (inch)
    - the inside face of the compression flange less the fillet or corner radius for rolled shapes
    - the nearest line of fasteners at the compression flange or inside face of the compression flange when welds are used for built-up sections
- `t_w`: thickness of the web (inch)
- `λ_f`: slenderness ratio of the flange
- `λ_pf`: compact slenderness ratio limit of the flange
- `λ_rf`: noncompact slenderness ratio limit of the flange
- `λ_fclass`: `compact` `noncompact` or `slender` classification for the flange
- `L_b`: unbraced length (inch)
- `C_b`: lateral torsional buckling modification factor (default = 1)

# Returns 
- `M_n`: moment capacity of the section.

# Reference
- AISC Section F5
"""
function flexure_capacity_f5(E, F_y, S_xc, S_xt, b_fc, t_fc, h, h_c, t_w, λ_f, λ_pf, λ_rf, λ_fclass, L_b, C_b=1)

    (;M_p, R_pg, F_crLTB, F_crCFLB) = flexure_capacity_f5_variables(E, F_y, S_xc, b_fc, t_fc, h, h_c, t_w, λ_f, λ_pf, λ_rf, λ_fclass, L_b, C_b)
    
    # 1. Compression Flange Yielding
    M_nCFY = flexure_capacity_f5_1(M_p)

    # 2. Lateral Torsional Buckling
    M_nLTB = flexure_capacity_f5_2(R_pg, F_crLTB, S_xc)

    # 3. Compression Flange Local Buckling
    M_nCFLB = flexure_capacity_f5_3(R_pg, F_crCFLB, S_xc)

    # 4. Tension Flange Yielding
    M_nTFY = flexure_capacity_f5_4(F_y, S_xt)

    M_n = min(M_nCFY, M_nLTB, M_nCFLB, M_nTFY)

    return M_n
end

end