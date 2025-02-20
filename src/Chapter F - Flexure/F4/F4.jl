module F4
using StructuralUnits
import AISCSteel.Utils.UnitConversions as cnv
# include equations
include("Equations.jl")

##########################################################################################
# Equations below are the public API for F4
##########################################################################################
"""
    calc_Myc(F_y, S_xc)

Calculates the yield moment in the compression flange of the applicable section.

Description of applicable member: Other I-shaped members with compact webs or noncompact webs bent about their major axis.

# Arguments
- `F_y`: yield strength of steel (ksi)
- `S_xc`: elastic section modulous referred to compression flange (inch^3)

# Returns 
- `M_yc`: yield moment in the compression flange (kip-in)

# Reference
- AISC Section F4
"""
calc_Myc(F_y, S_xc) = M_yc = Equations.EqF4▬4(F_y, S_xc)


"""
    calc_Myt(F_y, S_xt)

Calculates the yield moment in the tension flange of the applicable section.

Description of applicable member: Other I-shaped members with compact webs or noncompact webs bent about their major axis.

# Arguments
- `F_y`: yield strength of steel (ksi)
- `S_xt`: elastic section modulous referred to tension flange (inch^3)

# Returns 
- `M_yt`: yield moment in the tension flange (kip-inch)

# Reference
- AISC Section F4
"""
calc_Myt(F_y, S_xt) = M_yt = F_y*S_xt |> cnv.to_moment # no reference equation (in section F4.4)


"""
    calc_Fcr(C_b, E, L_b, r_t, J, S_xc, h_0)

Calculates the critical stress of the applicable section.

Description of applicable member: Other I-shaped members with compact webs or noncompact webs bent about their major axis.

# Arguments
- `C_b`: lateral torsional buckling modification factor (default = 1)
- `E`: modulous of elasticity (ksi)
- `L_b`: unbraced length (inch)
- `r_t`: radius of gyration of the flange components in flexural compression plus 1/3 of the web area (inch)
- `J`: torsional constant (inch^4)
- `S_xc`: elastic section modulous referred to compression flange (inch^3)
- `h_0`: distance between the flange centroids (inch)

# Returns 
- `F_cr`: critical stress (ksi)

# Reference
- AISC Section F4 (F4-5)
"""
calc_Fcr(C_b, E, L_b, r_t, J, S_xc, h_0) = F_cr = Equations.EqF4▬5(C_b, E, L_b, r_t, J, S_xc, h_0)


"""
    calc_FL(S_xt, S_xc, F_y) 

Calculates the nominal compression flange stress above which the inelastic buckling limit states apply for the applicable section.

Description of applicable member: Other I-shaped members with compact webs or noncompact webs bent about their major axis.

# Arguments
- `S_xt`: elastic section modulous referred to tension flange (inch^3)
- `S_xc`: elastic section modulous referred to compression flange (inch^3)
- `F_y`: yield strength of steel (ksi)

# Returns 
- `F_L`: nominal compression flange stress above which the inelastic buckling limit states apply (ksi)

# Reference
- AISC Section F4 (F4-6a through F4-6b)
"""
function calc_FL(S_xt, S_xc, F_y) 

    F_L_min = 0.5 * F_y

    if S_xt/S_xc >= 0.7
        F_L = Equations.EqF4▬6a(F_y)
    else
        F_L = Equations.EqF4▬6b(F_y, S_xt, S_xc)
    end
    
    F_L = max(F_L_min, F_L)

    return F_L
end


"""
    calc_Lp(r_t, E, F_y)

Calculates the limiting laterally unbraced length for the limit state of yielding of the applicable section.

Description of applicable member: Other I-shaped members with compact webs or noncompact webs bent about their major axis.

# Arguments
- `r_t`: radius of gyration of the flange components in flexural compression plus 1/3 of the web area (inch)
- `E`: modulous of elasticity (ksi)
- `F_y`: yield strength of steel (ksi)

# Returns 
- `L_p`: the limiting laterally unbraced length for the limit state of yielding (inch)

# Reference
- AISC Section F4 (F4-7)
"""
calc_Lp(r_t, E, F_y)= L_p = Equations.EqF4▬7(r_t, E, F_y)


"""
    calc_Lr(r_t, E, F_L, J, S_xc, h_0)

Calculates the limiting laterally unbraced length for the limit state of inelastic lateral-torsional buckling of the applicable section.

Description of applicable member: Other I-shaped members with compact webs or noncompact webs bent about their major axis.

# Arguments
- `r_t`: radius of gyration of the flange components in flexural compression plus 1/3 of the web area (inch)
- `E`: modulous of elasticity (ksi)
- `F_L`: nominal compression flange stress above which the inelastic buckling limit states apply (ksi)
- `J`: torsional constant (inch^4)
- `S_xc`: elastic section modulous referred to compression flange (inch^3)
- `h_0`: distance between the flange centroids (inch)

# Returns 
- `L_r`: the limiting laterally unbraced length for the limit state of inelastic lateral-torsional buckling (inch)

# Reference
- AISC Section F4 (F4-8)
"""
calc_Lr(r_t, E, F_L, J, S_xc, h_0) = L_r = Equations.EqF4▬8(r_t, E, F_L, J, S_xc, h_0)


"""
    calc_Rpc(I_yc, I_y, h_c, t_w, λ_w, λ_pw, λ_rw, M_p, M_yc)

Calculates the web plastification factor of the applicable section.

Description of applicable member: Other I-shaped members with compact webs or noncompact webs bent about their major axis.

# Arguments
- `I_yc`: second moment of inertia about the y-axis for the compression flange (inch^4)
- `I_y`: second moment of inertia about the y-axis (inch^4)
- `h_c`: twice the distance from the centroid to the following: (inch)
    - the inside face of the compression flange less the fillet or corner radius for rolled shapes
    - the nearest line of fasteners at the compression flange or inside face of the compression flange when welds are used for built-up sections
- `t_w`: thickness of the web (inch)
- `λ_w`: slenderness ratio of the flange
- `λ_pw`: compact slenderness ratio limit of the web
- `λ_rw`: noncompact slenderness ratio limit of the web
- `M_p`: plastic moment of the section (kip-ft)
- `M_yc`: yield moment in the compression flange (kip-in)

# Returns 
- `R_pc`: web plastification factor

# Reference
- AISC Section F4 (F4-9a through F4-9b)
"""
function calc_Rpc(I_yc, I_y, h_c, t_w, λ_w, λ_pw, λ_rw, M_p, M_yc) 

    if I_yc/I_y > 0.23
        if h_c/t_w <= λ_pw
            R_pc = Equations.EqF4▬9a(M_p, M_yc)
        else
            R_pc = Equations.EqF4▬9b(M_p, M_yt, λ, λ_pw, λ_rw)
        end
    else
        R_pc = 1.0
    end

    return R_pc
    
end

"""
    calc_rt(b_fc, a_w)

Calculates `r_t` of the applicable section.

Description of applicable member: Other I-shaped members with compact webs or noncompact webs bent about their major axis.

# Arguments
- `b_fc`: width of compression flange (inch)
- `a_w`: see AISC F4-12

# Returns 
- `r_t`: radius of gyration of the flange components in flexural compression plus 1/3 of the web area (inch)

# Reference
- AISC Section F4 (F4-11)
"""
calc_rt(b_fc, a_w) = r_t = Equations.EqF4▬11(b_fc, a_w)


"""
    calc_aw(h_c, t_w, b_fc, t_fc)

Calculates `a_w` of the applicable section.

Description of applicable member: Other I-shaped members with compact webs or noncompact webs bent about their major axis.

# Arguments
- `h_c`: twice the distance from the centroid to the following: (inch)
    - the inside face of the compression flange less the fillet or corner radius for rolled shapes
    - the nearest line of fasteners at the compression flange or inside face of the compression flange when welds are used for built-up sections
- `t_w`: thickness of the web (inch)
- `b_fc`: width of compression flange (inch)
- `t_fc`: thickness of compression flange (inch)

# Returns 
- `a_w`: see AISC F4-12

# Reference
- AISC Section F4 (F4-12)
"""
calc_aw(h_c, t_w, b_fc, t_fc) = a_w = Equations.EqF4▬12(h_c, t_w, b_fc, t_fc)


"""
    calc_Rpt(I_yc, I_y, h_c, t_w, λ_w, λ_pw, λ_rw, M_p, M_yt) 

Calculates the web plastification factor corresponding to the tension flange yielding limit state of the applicable section.

Description of applicable member: Other I-shaped members with compact webs or noncompact webs bent about their major axis.

# Arguments
- `I_yc`: second moment of inertia about the y-axis for the compression flange (inch^4)
- `I_y`: second moment of inertia about the y-axis (inch^4)
- `h_c`: twice the distance from the centroid to the following: (inch)
    - the inside face of the compression flange less the fillet or corner radius for rolled shapes
    - the nearest line of fasteners at the compression flange or inside face of the compression flange when welds are used for built-up sections
- `t_w`: thickness of the web (inch)
- `λ_w`: slenderness ratio of the flange
- `λ_pw`: compact slenderness ratio limit of the web
- `λ_rw`: noncompact slenderness ratio limit of the web
- `M_p`: plastic moment of the section (kip-inch)
- `M_yt`: yield moment in the tension flange (kip-inch)

# Returns 
- `R_pt`: web plastification factor corresponding to the tension flange yielding limit state

# Reference
- AISC Section F4 (F4-9a through F4-9b)
"""
function calc_Rpt(I_yc, I_y, h_c, t_w, λ_w, λ_pw, λ_rw, M_p, M_yt) 

    if I_yc/I_y > 0.23
        if h_c/t_w <= λ_pw
            R_pt = Equations.EqF4▬16a(M_p, M_yt)
        else
            R_pt = Equations.EqF4▬16b(M_p, M_yc, λ_w, λ_pw, λ_rw)
        end
    else
        R_pt = 1.0
    end

    return R_pt

end

"""
    calc_variables(E, F_y, Z_x, S_x, S_xc, S_xt, b_fc, t_fc, h, h_c, t_w, J, h_0, I_y, I_yc, λ_w, λ_pw, λ_rw, L_b, C_b)

Calculates the intermediate variables needed to then solve for moment capacities of the applicable section.

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
- `L_b`: unbraced length (inch)
- `C_b`: lateral torsional buckling modification factor

# Returns 
    (;M_p, M_yc, M_yt, k_c, F_cr, F_L, L_p, L_r, R_pc, R_pt)
- `M_p`: plastic moment of the section (kip-ft)
- `M_yc`: yield moment in the compression flange (kip-in)
- `M_yt`: yield moment in the tension flange (kip-inch)
- `k_c`:
- `F_cr`: critical stress (ksi)
- `F_L`: nominal compression flange stress above which the inelastic buckling limit states apply (ksi) 
- `L_p`: the limiting laterally unbraced length for the limit state of yielding (inch)
- `L_r`: the limiting laterally unbraced length for the limit state of inelastic lateral-torsional buckling (inch)
- `R_pc`: web plastification factor
- `R_pt`: web plastification factor corresponding to the tension flange yielding limit state

# Reference
- AISC Section F4
"""
function calc_variables(E, F_y, Z_x, S_x, S_xc, S_xt, b_fc, t_fc, h, h_c, t_w, J, h_0, I_y, I_yc, λ_w, λ_pw, λ_rw, L_b, C_b)

    M_p = min(F_y*Z_x, 1.6*F_y*S_x) # no reference equation (in section F4.2.6)

    M_yc = calc_Myc(F_y, S_xc)
    M_yt = calc_Myt(F_y, S_xt)

    # (2) F_cr
    a_w = calc_aw(h_c, t_w, b_fc, t_fc)
    r_t = calc_rt(b_fc, a_w)

    if I_yc/I_y <= 0.23
        J = zero(typeof(J))
    else
        J = J
    end

    k_c = 4/sqrt(h/t_w) # no reference equation (in section F4.3)
    k_c = max(min(k_c, 0.76), 0.35)

    F_cr = calc_Fcr(C_b, E, L_b, r_t, J, S_xc, h_0)

    # (3) F_L
    F_L = calc_FL(S_xt, S_xc, F_y) 

    # (4) L_p
    L_p = calc_Lp(r_t, E, F_y)

    # (5) L_r
    L_r = calc_Lr(r_t, E, F_L, J, S_xc, h_0)

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
    M_nCFY = Equations.EqF4▬1(R_pc, M_yc)

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
    if L_b <= L_p
        M_nLTB = M_p
    elseif L_p < L_b <= L_r
        M_nLTB = Equations.EqF4▬2(C_b, R_pc, M_yc, F_L, S_xc, L_b, L_p, L_r)
    else
        M_nLTB = Equations.EqF4▬3(F_cr, S_xc)
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
    if λ_fclass == :compact
        M_nCFLB = M_p
    elseif λ_fclass == :noncompact
        M_nCFLB = Equations.EqF4▬13(R_pc, M_yc, F_L, S_xc, λ_f, λ_pf, λ_rf)
    else
        M_nCFLB = Equations.EqF4▬14(E, k_c, S_xc, λ_f)
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
    if S_xt >= S_xc
        M_nTFY = M_p
    else
        M_nTFY = Equations.EqF4▬15(R_pt, M_yt)
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
