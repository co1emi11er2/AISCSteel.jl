module PositiveBending

import AISCSteel.ChapterFFlexure.F9.Equations as Equations
import AISCSteel.ChapterFFlexure.F9: calc_MnY, calc_Lp, calc_Lr, calc_My, calc_Mcr
export calc_MnY, calc_Lp, calc_Lr, calc_My, calc_Mcr

"""
    calc_Mp(M_y)

Calculates the plastic moment capacity of the applicable section.

Description of applicable member: WT-shaped member loaded in the plane of symmetry. 

# Arguments
- `F_y`: yield strength of steel (ksi)
- `Z_x`: plastic section modulous  (inch^4)
- `M_y`: yield moment of the section bent about the respective axis (kip-in)

# Returns 
- `M_p`: plastic moment of the section (kip-in)

# Reference
- AISC Section F9 (9-2)
"""
calc_Mp(F_y, Z_x, M_y) = M_p =  Equations.EqF9▬2(F_y, Z_x, M_y)


"""
    calc_B(d, L_b, I_y, J)

Calculates `B` of the applicable section.

Description of applicable member: WT-shaped member loaded in the plane of symmetry. 

# Arguments
- `d`: depth of the tee in compression
- `L_b`: unbraced length (inch)
- `I_y`: second moment of inertia about the y-axis (inch^4)
- `J`: torsional constant (inch^4)

# Returns 
- `B`: see AISC F9

# Reference
- AISC Section F9 (9-11)
"""
calc_B(d, L_b, I_y, J) = B = Equations.EqF9▬11(d, L_b, I_y, J)


"""
    calc_variables(r_y, E, F_y, I_y, J, S_x, Z_x, d, L_b)

Calculates the intermediate variables needed to then solve for moment capacities of the applicable section.

Description of applicable member: WT-shaped member loaded in the plane of symmetry. 

# Arguments
- `r_y`: radius of gyration about the y-axis (inch)
- `E`: modulous of elasticity (ksi)
- `F_y`: yield strength of steel (ksi)
- `I_y`: second moment of inertia about the y-axis (inch^4)
- `J`: torsional constant (inch^4)
- `S_x`: elastic section modulous (inch^3)
- `Z_x`: plastic section modulous  (inch^4)
- `d`: depth of the tee in compression
- `L_b`: unbraced length (inch)

# Returns 
(; L_p, L_r, M_p, M_y, M_cr)
- `L_p`: the limiting laterally unbraced length for the limit state of yielding (inch)
- `L_r`: the limiting laterally unbraced length for the limit state of inelastic lateral-torsional buckling (inch)
- `M_p`: plastic moment of the section (kip-in)
- `M_y`: yield moment of the section bent about the respective axis (kip-in)
- `M_cr`: elastic lateral-torsional buckling moment of the section bent about the respective axis (kip-in)

# Reference
- AISC Section F9
"""
function calc_variables(r_y, E, F_y, I_y, J, S_x, Z_x, d, L_b)
    L_p = calc_Lp(r_y, E, F_y)
    L_r = calc_Lr(E, F_y, I_y, J, S_x, d)
    M_y = calc_My(F_y, S_x)
    M_p = calc_Mp(F_y, Z_x, M_y)
    B = calc_B(d, L_b, I_y, J)
    M_cr = calc_Mcr(E, L_b, I_y, J, B)
    return (; L_p, L_r, M_p, M_y, M_cr)
end


"""
    calc_MnLTB(M_p, M_y, M_cr, L_b, L_p, L_r)

Calculates the moment capacity of the applicable section for lateral torsional buckling.

Description of applicable member: WT-shaped member loaded in the plane of symmetry. 

# Arguments
- `M_p`: plastic moment of the section (kip-in)
- `M_y`: yield moment of the section bent about the respective axis (kip-in)
- `M_cr`: elastic lateral-torsional buckling moment of the section bent about the respective axis (kip-in)
- `L_b`: unbraced length (inch)
- `L_p`: the limiting laterally unbraced length for the limit state of yielding (inch)
- `L_r`: the limiting laterally unbraced length for the limit state of inelastic lateral-torsional buckling (inch)

# Returns 
- `M_nLTB`: moment capacity of the section for lateral torsional buckling.

# Reference
- AISC Section F9 (F9-6 through F97)
"""
function calc_MnLTB(M_p, M_y, M_cr, L_b, L_p, L_r)

    # 2. Lateral Torsional Buckling
    if L_b <= L_p
        M_nLTB = M_p
    elseif L_p < L_b <= L_r
        M_nLTB = Equations.EqF9▬6(M_p, M_y, L_b, L_p, L_r)
    else
        M_nLTB = Equations.EqF9▬7(M_cr)
    end

    return M_nLTB
end


"""
    calc_MnFLB(M_p, F_y, S_xc, λ_f, λ_pf, λ_rf, λ_fclass, M_y, E, b_f, t_f)

Calculates the moment capacity of the applicable section for flange local buckling.

Description of applicable member: WT-shaped member loaded in the plane of symmetry. 

# Arguments
- `M_p`: plastic moment of the section (kip-in)
- `F_y`: yield strength of steel (ksi)
- `S_xc`: elastic section modulous referred to compression flange (inch^3)
- `λ_f`: slenderness ratio of the flange
- `λ_pf`: compact slenderness ratio limit of the flange
- `λ_rf`: noncompact slenderness ratio limit of the flange
- `λ_fclass`: `compact` `noncompact` or `slender` classification for the flange
- `M_y`: yield moment of the section bent about the respective axis (kip-in)
- `E`: modulous of elasticity (ksi)
- `b_f`: width of flange (inch)
- `t_f`: thickness of flange (inch)

# Returns 
- `M_nFLB`: moment capacity of the section for flange local buckling.

# Reference
- AISC Section F9 (F9-14 through F915)
"""
function calc_MnFLB(M_p, F_y, S_xc, λ_f, λ_pf, λ_rf, λ_fclass, M_y, E, b_f, t_f)

    # 3. Flange Local Buckling
    if λ_fclass == :noncompact
        M_nFLB = Equations.EqF9▬14(M_p, F_y, S_xc, λ_f, λ_pf, λ_rf, M_y)
    elseif λ_fclass == :slender
        M_nFLB = Equations.EqF9▬15(E, S_xc, b_f, t_f)
    else
        M_nFLB = M_p
    end

    return M_p

end

"""
    calc_Mn(r_y, E, F_y, I_y, J, S_x, Z_x, d, L_b, S_xc, λ_f, λ_pf, λ_rf, λ_fclass, b_f, t_f)

Calculates the moment capacity of the applicable section.

Description of applicable member: WT-shaped member loaded in the plane of symmetry. 

# Arguments
- `r_y`: radius of gyration about the y-axis (inch)
- `E`: modulous of elasticity (ksi)
- `F_y`: yield strength of steel (ksi)
- `I_y`: second moment of inertia about the y-axis (inch^4)
- `J`: torsional constant (inch^4)
- `S_x`: elastic section modulous (inch^3)
- `Z_x`: plastic section modulous  (inch^4)
- `d`: depth of the tee in compression
- `L_b`: unbraced length (inch)
- `S_xc`: elastic section modulous referred to compression flange (inch^3)
- `λ_f`: slenderness ratio of the flange
- `λ_pf`: compact slenderness ratio limit of the flange
- `λ_rf`: noncompact slenderness ratio limit of the flange
- `λ_fclass`: `compact` `noncompact` or `slender` classification for the flange
- `b_f`: width of flange (inch)
- `t_f`: thickness of flange (inch)

# Returns 
- `M_n`: moment capacity of the section.

# Reference
- AISC Section F9
"""
function calc_Mn(r_y, E, F_y, I_y, J, S_x, Z_x, d, L_b, S_xc, λ_f, λ_pf, λ_rf, λ_fclass, b_f, t_f)

    (; L_p, L_r, M_p, M_y, M_cr) = calc_variables(r_y, E, F_y, I_y, J, S_x, Z_x, d, L_b)

    # 1. Yielding
    M_nY = calc_MnY(M_p)

    # 2. Lateral Torsional Buckling
    M_nLTB = calc_MnLTB(M_p, M_y, M_cr, L_b, L_p, L_r)

    # 3. Flange Local Buckling
    M_nFLB = calc_MnFLB(M_p, F_y, S_xc, λ_f, λ_pf, λ_rf, λ_fclass, M_y, E, b_f, t_f)

    M_n = min(M_nY, M_nLTB, M_nFLB)
end


end