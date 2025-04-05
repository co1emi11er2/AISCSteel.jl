"""
    module F7

This section applies to square and rectangular HSS, and box sections bent about
either axis, having compact, noncompact, or slender webs or flanges as defined in Section
B4.1 for flexure.
"""
module F7

import AISCSteel.ChapterFFlexure.F5.Equations: EqF5▬6

# include equations
include("Equations.jl")

##########################################################################################
# Equations below are the public API for F7
##########################################################################################
"""
    calc_Mp(F_y, Z)

Calculates the plastic moment capacity of the applicable section.

Description of applicable member: square and rectangular HSS, and box sections bent about
either axis

# Arguments
- `F_y`: yield strength of steel (ksi)
- `Z`: plastic section modulous about the axis of bending (inch^4)

# Returns 
- `M_p`: plastic moment of the section (kip-in)

# Reference
- AISC Section F7 (F7-1)
"""
calc_Mp(F_y, Z) = M_p = Equations.EqF7▬1(F_y, Z)


"""
    calc_be_HSS(t_f, E, F_y, b)

Calculates the effective width of the compression flange.

Description of applicable member: square and rectangular HSS sections bent about
either axis

# Arguments
- `t_f`: thickness of the compression flange (inch)
- `E`: modulous of elasticity (ksi)
- `F_y`: yield strength of steel (ksi)
- `b`: width of the compression flange (inch)

# Returns 
- `b_e`: effective width of the compression flange

# Reference
- AISC Section F7 (F7-4)
"""
calc_be_HSS(t_f, E, F_y, b) = b_e = Equations.EqF7▬4(t_f, E, F_y, b)


"""
    calc_be_box(t_f, E, F_y, b)

Calculates the effective width of the compression flange.

Description of applicable member: box sections bent about either axis

# Arguments
- `t_f`: thickness of the compression flange (inch)
- `E`: modulous of elasticity (ksi)
- `F_y`: yield strength of steel (ksi)
- `b`: width of the compression flange (inch)

# Returns 
- `b_e`: effective width of the compression flange

# Reference
- AISC Section F7 (F7-4)
"""
calc_be_box(t_f, E, F_y, b) = b_e = Equations.EqF7▬5(t_f, E, F_y, b)


"""
    calc_Lp(E, r_y, J, A_g, M_p)

Calculates the limiting laterally unbraced length for the limit state of yielding of the applicable section.

Description of applicable member: square and rectangular HSS, and box sections bent about
either axis

# Arguments
- `E`: modulous of elasticity (ksi)
- `r_y`: radius of gyration about the y-axis (inch)
- `J`: torsional constant (inch^4)
- `A_g`: gross area of member (inch)
- `M_p`: plastic moment of the section (kip-in)

# Returns 
- `L_p`: the limiting laterally unbraced length for the limit state of yielding (inch)

# Reference
- AISC Section F7 (F7-12)
"""
calc_Lp(E, r_y, J, A_g, M_p) = L_p = Equations.EqF7▬12(E, r_y, J, A_g, M_p)


"""
    calc_Lr(E, r_y, J, A_g, F_y, S_x)

Calculates the limiting laterally unbraced length for the limit state of inelastic lateral-torsional buckling of the applicable section.

Description of applicable member: square and rectangular HSS, and box sections bent about
either axis

# Arguments
- `E`: modulous of elasticity (ksi)
- `r_y`: radius of gyration about the y-axis (inch)
- `J`: torsional constant (inch^4)
- `A_g`: gross area of member (inch)
- `F_y`: yield strength of steel (ksi)
- `S_x`: elastic section modulous (inch^3)

# Returns 
- `L_r`: the limiting laterally unbraced length for the limit state of inelastic lateral-torsional buckling (inch)

# Reference
- AISC Section F7 (F7-13)
"""
calc_Lr(E, r_y, J, A_g, F_y, S_x) = L_r = Equations.EqF7▬13(E, r_y, J, A_g, F_y, S_x)


"""
    calc_aw(h, t_w, b, t_f)

Calculates `a_w` of the applicable section.

Description of applicable member: square and rectangular HSS, and box sections bent about
either axis

# Arguments
- `h`: depth of the web, as defined in Section B4.1b (inch)
- `t_w`: thickness of the web (inch)
- `b`: width of flange (inch)
- `t_f`: thickness of flange (inch)

# Returns 
- `a_w`: see AISC F4-12

# Reference
- AISC Section F4 (F4-12)
"""
calc_aw(h, t_w, b, t_f) = a_w = (2*h*t_w)/(b*t_f)


"""
    calc_Rpg(a_w, h, t_w, E, F_y)

Calculates the intermediate variables needed to then solve for moment capacities of the applicable section.

Description of applicable member: I-shaped members with slender webs bent about their major axis.

# Arguments
- `a_w`: see F7 section 3
- `h`: depth of the web, as defined in Section B4.1b (inch)
- `t_w`: thickness of the web (inch)
- `E`: modulous of elasticity (ksi)
- `F_y`: yield strength of steel (ksi)

# Returns 
- `R_pg`: bending strength reduction factor

# Reference
- AISC Section F5 (F5-6)
"""
function calc_Rpg(a_w, h, t_w, E, F_y)
    h_c = h
    R_pg = EqF5▬6(a_w, h_c, t_w, E, F_y)
    R_pg = min(R_pg, 1.0)
end


"""
    calc_MnY(M_p)

Calculates the moment capacity of the applicable section for yielding.

Description of applicable member: square and rectangular HSS, and box sections bent about
either axis

# Arguments
- `M_p`: plastic moment of the section (kip-in)

# Returns 
- `M_nY`: moment capacity of the section for yielding. (kip-in)

# Reference
- AISC Section F7.1
"""
calc_MnY(M_p) = M_nFY = M_p


"""
    calc_MnFLB(M_p, F_y, S, S_e, λ_f, λ_pf, λ_rf, λ_fclass)

Calculates the moment capacity of the applicable section for compression flange local buckling.

Description of applicable member: square and rectangular HSS, and box sections bent about
either axis

# Arguments
- `M_p`: plastic moment of the section (kip-in)
- `F_y`: yield strength of steel (ksi)
- `S`: elastic section modulus about the axis of bending (inch^3)
- `S_e`: effective elastic section modulus about the axis of bending (inch^3)
- `λ_f`: slenderness ratio of the flange
- `λ_pf`: compact slenderness ratio limit of the flange
- `λ_rf`: noncompact slenderness ratio limit of the flange
- `λ_fclass`: `compact` `noncompact` or `slender` classification for the flange

# Returns 
- `M_nFLB`: moment capacity of the section for flange local buckling. (kip-in)

# Reference
- AISC Section F7.2
"""
function calc_MnFLB(M_p, F_y, S, S_e, λ_f, λ_pf, λ_rf, λ_fclass)
    # 2. Flange Local Buckling
    if λ_fclass == :compact
        M_nFLB = M_p
    elseif λ_fclass == :noncompact
        M_nFLB = Equations.EqF7▬2(M_p, F_y, S, λ_f, λ_pf, λ_rf)
    else
        M_nFLB = Equations.EqF7▬3(F_y, S_e)
    end

    return M_nFLB
end


"""
    calc_MnWLB(M_p, F_y, S, R_pg, λ_w, λ_pw, λ_rw, λ_fclass)

Calculates the moment capacity of the applicable section for compression flange local buckling.

Description of applicable member: square and rectangular HSS, and box sections bent about
either axis

# Arguments
- `M_p`: plastic moment of the section (kip-in)
- `F_y`: yield strength of steel (ksi)
- `S`: elastic section modulus about the axis of bending (inch^3)
- `R_pg`: bending strength reduction factor
- `λ_w`: slenderness ratio of the web
- `λ_pw`: compact slenderness ratio limit of the web
- `λ_rw`: noncompact slenderness ratio limit of the web
- `λ_wclass`: `compact` `noncompact` or `slender` classification for the web

# Returns 
- `M_nWLB`: moment capacity of the section for web local buckling. (kip-in)

# Reference
- AISC Section F7.3
"""
function calc_MnWLB(M_p, F_y, S, R_pg, λ_w, λ_pw, λ_rw, λ_wclass)
    # 2. Flange Local Buckling
    if λ_wclass == :compact
        M_nFLB = M_p
    elseif λ_wclass == :noncompact
        M_nFLB = Equations.EqF7▬6(M_p, F_y, S, λ_w, λ_pw, λ_rw)
    else
        M_nFLB = Equations.EqF7▬7(R_pg, F_y, S)
    end

    return M_nFLB
end


"""
    calc_MnLTB(M_p, F_y, S_x, L_b, L_p, L_r, E, J, A_g, r_y, C_b=1)

Calculates the moment capacity of the applicable section for lateral torsional buckling.
Lateral torsional buckling will not occur in square sections or sections bending about their minor axis.

Description of applicable member: rectangular HSS, and box sections bent about their major axis 

# Arguments
- `M_p`: plastic moment of the section (kip-in)
- `F_y`: yield strength of steel (ksi)
- `S_x`: elastic section modulous (inch^3)
- `E`: modulous of elasticity (ksi)
- `J`: torsional constant (inch^4)
- `A_g`: gross area of member (inch)
- `r_y`: radius of gyration about the y-axis (inch)
- `L_b`: unbraced length (inch)
- `L_p`: the limiting laterally unbraced length for the limit state of yielding (inch)
- `L_r`: the limiting laterally unbraced length for the limit state of inelastic lateral-torsional buckling (inch)
- `C_b`: lateral torsional buckling modification factor (default = 1)

# Returns 
- `M_nLTB`: moment capacity of the section for lateral torsional buckling. (kip-in)

# Reference
- AISC Section F7.4
"""
function calc_MnLTB(M_p, F_y, S_x, E, J, A_g, r_y, L_b, L_p, L_r, C_b=1)
    if L_b <= L_p
        M_nLTB = M_p
    elseif L_p < L_b <= L_r
        M_nLTB = Equations.EqF7▬10(M_p, F_y, S_x, L_b, L_p, L_r, C_b)
    else
        M_nLTB = Equations.EqF7▬11(E, C_b, J, A_g, L_b, r_y)
    end

    return M_nLTB
end


end # module
