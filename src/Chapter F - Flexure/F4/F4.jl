module F4
using StructuralUnits

# include equations
include("Equations.jl")

##########################################################################################
# Equations below are the public API for F4
##########################################################################################
calc_aw(h_c, t_w, b_fc, t_fc) = a_w = (h_c*t_w)/(b_fc*t_fc)
calc_rt(b_fc, a_w) = r_t = b_fc/sqrt(12*(1 + (1/6)*a_w))
function calc_FL(S_xt, S_xc, F_y) 
    F_L_min = 0.5 * F_y
    F_L =   if S_xt/S_xc >= 0.7
                0.7*F_y
            else
                F_y*(S_xt/S_xc)
            end
    
    F_L = max(F_L_min, F_L)

    return F_L
end

function calc_Rpc(I_yc, I_y, h_c, t_w, λ_w, λ_pw, λ_rw, M_p, M_yc) 
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

function calc_Rpt(I_yc, I_y, h_c, t_w, λ, λ_pw, λ_rw, M_p, M_yt) 

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

function calc_variables(E, F_y, Z_x, S_x, S_xc, S_xt, b_fc, t_fc, h, h_c, t_w, J, h_0, I_y, I_yc, λ_w, λ_pw, λ_rw, L_b, C_b)

    M_p = min(F_y*Z_x, 1.6*F_y*S_x)

    M_yc = F_y*S_xc
    M_yt = F_y*S_xt

    # (2) F_cr
    a_w = calc_aw(h_c, t_w, b_fc, t_fc)
    r_t = calc_rt(b_fc, a_w)
    J = if I_yc/I_y <= 0.23
            zero(typeof(J))
        else
            J
        end

    k_c = 4/sqrt(h/t_w)
    k_c = max(min(k_c, 0.76), 0.35)

    F_cr = ((C_b*π^2*E)/(L_b/r_t)^2)*sqrt(1 + 0.078*((J)/(S_xc*h_0))*(L_b/r_t)^2) |> ksi

    # (3) F_L
    F_L = calc_FL(S_xt, S_xc, F_y) 

    # (4) L_p
    L_p = 1.1*r_t*sqrt(E/F_y)

    # (5) L_r
    L_r = 1.95*r_t*(E/(F_L))*sqrt((J)/(S_xc*h_0) + sqrt(((J)/(S_xc*h_0))^2 + 6.76*((F_L)/E)^2))

    R_pc = calc_Rpc(I_yc, I_y, h_c, t_w, λ_w, λ_pw, λ_rw, M_p, M_yc) 
    R_pt = calc_Rpt(I_yc, I_y, h_c, t_w, λ_w, λ_pw, λ_rw, M_p, M_yt) 

    return (;M_p, M_yc, M_yt, k_c, F_cr, F_L, L_p, L_r, R_pc, R_pt)
end

"""
    calc_MnCFY(R_pc, M_yc)

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
function calc_MnCFY(R_pc, M_yc)
    # 1. Compression Flange Yielding
    M_nCFY = R_pc*M_yc

    return M_nCFY
end

"""
    calc_MnLTB(M_p, R_pc, M_yc, F_L, S_xc, F_cr, L_b, L_p, L_r, C_b=1)

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
function calc_MnLTB(M_p, R_pc, M_yc, F_L, S_xc, F_cr, L_b, L_p, L_r, C_b=1)
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
    calc_MnCFLB(M_p, R_pc, M_yc, F_L, S_xc, E, k_c, λ_f, λ_pf, λ_rf, λ_fclass)

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
function calc_MnCFLB(M_p, R_pc, M_yc, F_L, S_xc, E, k_c, λ_f, λ_pf, λ_rf, λ_fclass)
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
    calc_MnTFY(M_p, R_pt, M_yt, S_xc, S_xt)

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
function calc_MnTFY(M_p, R_pt, M_yt, S_xc, S_xt)
    # 4. Tension Flange Yielding
    M_nTFY =  if S_xt >= S_xc
        M_p
    else
        R_pt*M_yt
    end

    return M_nTFY
end

"""
    calc_Mn(E, F_y, Z_x, S_x, S_xc, S_xt, b_fc, t_fc, h, h_c, t_w, J, h_0, I_y, I_yc, λ_w, λ_pw, λ_rw, λ_f, λ_pf, λ_rf, λ_fclass, L_b, C_b=1)

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
function calc_Mn(E, F_y, Z_x, S_x, S_xc, S_xt, b_fc, t_fc, h, h_c, t_w, J, h_0, I_y, I_yc, λ_w, λ_pw, λ_rw, λ_f, λ_pf, λ_rf, λ_fclass, L_b, C_b)

    (;M_p, M_yc, M_yt, k_c, F_cr, F_L, L_p, L_r, R_pc, R_pt) = calc_variables(E, F_y, Z_x, S_x, S_xc, S_xt, b_fc, t_fc, h, h_c, t_w, J, h_0, I_y, I_yc, λ_w, λ_pw, λ_rw, L_b, C_b)

    # 1. Compression Flange Yielding
    M_nCFY = calc_MnCFY(R_pc, M_yc)

    # 2. Lateral Torsional Buckling
    M_nLTB =  calc_MnLTB(M_p, R_pc, M_yc, F_L, S_xc, F_cr, L_b, L_p, L_r, C_b)

    # 3. Compression Flange Local Buckling
    M_nCFLB =  calc_MnCFLB(M_p, R_pc, M_yc, F_L, S_xc, E, k_c, λ_f, λ_pf, λ_rf, λ_fclass)

    # 4. Tension Flange Yielding
    M_nTFY =  calc_MnTFY(M_p, R_pt, M_yt, S_xc, S_xt)

    M_n = min(M_nCFY, M_nLTB, M_nCFLB, M_nTFY)

    return M_n
end

end # module
