"""
    module HSS

This section applies to square and rectangular HSS.
"""
module HSS

import AISCSteel.ChapterFFlexure.F7.Equations as Equations
import AISCSteel.ChapterFFlexure.F7: calc_Mp, calc_Ie, calc_Se, calc_Lp, calc_Lr, calc_aw, calc_Rpg
import AISCSteel.ChapterFFlexure.F7: calc_MnY, calc_MnWLB, calc_MnLTB
export calc_Mp, calc_be, calc_Ie, calc_Se, calc_Lp, calc_Lr, calc_aw, calc_Rpg, calc_MnY
export calc_MnWLB, calc_MnLTB, calc_MnFLB, calc_Mnx, calc_Mny


"""
    calc_be(t_f, E, F_y, b)

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
calc_be(t_f, E, F_y, b) = b_e = Equations.EqF7▬4(t_f, E, F_y, b)


"""
    calc_MnFLB(M_p, F_y, S, t_f, E, b, I, Ht, λ_f, λ_pf, λ_rf, λ_fclass)

Calculates the moment capacity of the applicable section for compression flange local buckling.

Description of applicable member: square and rectangular HSS, and box sections bent about
either axis

# Arguments
- `M_p`: plastic moment of the section (kip-in)
- `F_y`: yield strength of steel (ksi)
- `S`: elastic section modulus about the axis of bending (inch^3)
- `t_f`: thickness of flange (inch)
- `E`: modulous of elasticity (ksi)
- `b`: width of flange (inch)
- `I`: second moment of inertia about axis of bending (inch^4)
- `Ht`: overall depth of square HSS or longer wall of rectangular HSS (inch)
- `λ_f`: slenderness ratio of the flange
- `λ_pf`: compact slenderness ratio limit of the flange
- `λ_rf`: noncompact slenderness ratio limit of the flange
- `λ_fclass`: `compact` `noncompact` or `slender` classification for the flange

# Returns 
- `M_nFLB`: moment capacity of the section for flange local buckling. (kip-in)

# Reference
- AISC Section F7.2
"""
function calc_MnFLB(M_p, F_y, S, t_f, E, b, I, Ht, λ_f, λ_pf, λ_rf, λ_fclass)
    # 2. Flange Local Buckling
    if λ_fclass == :compact
        M_nFLB = M_p
    elseif λ_fclass == :noncompact
        M_nFLB = Equations.EqF7▬2(M_p, F_y, S, λ_f, λ_pf, λ_rf)
    else
        b_e = calc_be(t_f, E, F_y, b)
        I_e = calc_Ie(I, b, b_e, t_f, Ht)
        S_e = calc_Se(I_e, Ht)
        M_nFLB = Equations.EqF7▬3(F_y, S_e)
    end

    return M_nFLB
end


"""
    calc_Mnx(E, F_y, Z, h, t_w, b, t_f, r_y, J, A_g, S, I, Ht, λ_f, λ_pf, λ_rf, λ_fclass, λ_w, λ_pw, λ_rw, λ_wclass, L_b, C_b=1)

Calculates the moment capacity of the applicable section.

Description of applicable member: rectangular HSS, and box sections bent about their major axis 

# Arguments
- `E`: modulous of elasticity (ksi)
- `F_y`: yield strength of steel (ksi)
- `Z`: plastic section modulous  (inch^4)
- `h`: depth of the web, as defined in Section B4.1b (inch)
- `t_w`: thickness of the web (inch)
- `b`: width of the compression flange (inch)
- `t_f`: thickness of the compression flange (inch)
- `r_y`: radius of gyration about the y-axis (inch)
- `J`: torsional constant (inch^4)
- `A_g`: gross area of member (inch)
- `S`: elastic section modulous (inch^3)
- `I`: second moment of inertia about axis of bending (inch^4)
- `Ht`: overall depth of square HSS or longer wall of rectangular HSS (inch)
- `λ_f`: slenderness ratio of the flange
- `λ_pf`: compact slenderness ratio limit of the flange
- `λ_rf`: noncompact slenderness ratio limit of the flange
- `λ_fclass`: `compact` `noncompact` or `slender` classification for the flange
- `λ_w`: slenderness ratio of the flange
- `λ_pw`: compact slenderness ratio limit of the web
- `λ_rw`: noncompact slenderness ratio limit of the web
- `λ_wclass`: `compact` `noncompact` or `slender` classification for the web
- `L_b`: unbraced length (inch)
- `C_b`: lateral torsional buckling modification factor (default = 1)

# Returns 
- `M_n`: moment capacity of the section. (kip-in)

# Reference
- AISC Section F7
"""
function calc_Mnx(E, F_y, Z, h, t_w, b, t_f, r_y, J, A_g, S, I, Ht, λ_f, λ_pf, λ_rf, λ_fclass, λ_w, λ_pw, λ_rw, λ_wclass, L_b, C_b=1)

    M_p = calc_Mp(F_y, Z)
    a_w = calc_aw(h, t_w, b, t_f)
    R_pg = calc_Rpg(a_w, h, t_w, E, F_y)
    L_p = calc_Lp(E, r_y, J, A_g, M_p)
    L_r = calc_Lr(E, r_y, J, A_g, F_y, S)
    
    # 1. Yielding
    M_nY = calc_MnY(M_p)

    # 2. Flange Local Buckling
    M_nFLB = calc_MnFLB(M_p, F_y, S, t_f, E, b, I, Ht, λ_f, λ_pf, λ_rf, λ_fclass)

    # 3. Web Local Buckling
    M_nWLB = calc_MnWLB(M_p, F_y, S, R_pg, λ_w, λ_pw, λ_rw, λ_wclass)

    # 4. Lateral Torsional Buckling
    M_nLTB = calc_MnLTB(M_p, F_y, S, E, J, A_g, r_y, L_b, L_p, L_r, C_b)
    
    M_n = min(M_nY, M_nFLB, M_nWLB, M_nLTB)

    return M_n
end


"""
    calc_Mny(E, F_y, Z, h, t_w, b, t_f, S, I, Ht, λ_f, λ_pf, λ_rf, λ_fclass, λ_w, λ_pw, λ_rw, λ_wclass)

Calculates the moment capacity of the applicable section.

Description of applicable member: rectangular HSS, and box sections bent about their major axis 

# Arguments
- `E`: modulous of elasticity (ksi)
- `F_y`: yield strength of steel (ksi)
- `Z`: plastic section modulous  (inch^4)
- `h`: depth of the web, as defined in Section B4.1b (inch)
- `t_w`: thickness of the web (inch)
- `b`: width of the compression flange (inch)
- `t_f`: thickness of the compression flange (inch)
- `S`: elastic section modulous (inch^3)
- `I`: second moment of inertia about axis of bending (inch^4)
- `Ht`: overall depth of square HSS or longer wall of rectangular HSS (inch)
- `λ_f`: slenderness ratio of the flange
- `λ_pf`: compact slenderness ratio limit of the flange
- `λ_rf`: noncompact slenderness ratio limit of the flange
- `λ_fclass`: `compact` `noncompact` or `slender` classification for the flange
- `λ_w`: slenderness ratio of the flange
- `λ_pw`: compact slenderness ratio limit of the web
- `λ_rw`: noncompact slenderness ratio limit of the web
- `λ_wclass`: `compact` `noncompact` or `slender` classification for the web

# Returns 
- `M_n`: moment capacity of the section. (kip-in)

# Reference
- AISC Section F7
"""
function calc_Mny(E, F_y, Z, h, t_w, b, t_f, S, I, Ht, λ_f, λ_pf, λ_rf, λ_fclass, λ_w, λ_pw, λ_rw, λ_wclass)

    M_p = calc_Mp(F_y, Z)
    a_w = calc_aw(h, t_w, b, t_f)
    R_pg = calc_Rpg(a_w, h, t_w, E, F_y)
    
    # 1. Yielding
    M_nY = calc_MnY(M_p)

    # 2. Flange Local Buckling
    M_nFLB = calc_MnFLB(M_p, F_y, S, t_f, E, b, I, Ht, λ_f, λ_pf, λ_rf, λ_fclass)

    # 3. Web Local Buckling
    M_nWLB = calc_MnWLB(M_p, F_y, S, R_pg, λ_w, λ_pw, λ_rw, λ_wclass)

    M_n = min(M_nY, M_nFLB, M_nWLB)

    return M_n
end

end