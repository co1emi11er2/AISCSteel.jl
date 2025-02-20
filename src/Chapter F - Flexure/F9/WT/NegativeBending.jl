module NegativeBending

import AISCSteel.ChapterFFlexure.F9.Equations as Equations
import AISCSteel.ChapterFFlexure.F9: calc_MnY, calc_My, calc_Mcr
export calc_MnY, calc_My, calc_Mcr

"""
    calc_Mp(M_y)

Calculates the plastic moment capacity of the applicable section.

Description of applicable member: WT-shaped member loaded in the plane of symmetry. 

# Arguments
- `M_y`: yield moment of the section bent about the respective axis (kip-in)

# Returns 
- `M_p`: plastic moment of the section (kip-in)

# Reference
- AISC Section F9 (9-4)
"""
calc_Mp(M_y) = M_p =  Equations.EqF9▬4(M_y)


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
- AISC Section F9 (9-12)
"""
calc_B(d, L_b, I_y, J) = B = Equations.EqF9▬12(d, L_b, I_y, J)


"""
    calc_Fcr(d, t_w, E, F_y)

Calculates the critical stress of the applicable section.

Description of applicable member: WT-shaped member loaded in the plane of symmetry. 

# Arguments
- `d`: depth of the tee in compression
- `t_w`: thickness of the web (inch)
- `E`: modulous of elasticity (ksi)
- `F_y`: yield strength of steel (ksi)

# Returns 
- `F_cr`: critical stress (ksi)

# Reference
- AISC Section F9 (9-12)
"""
function calc_Fcr(d, t_w, E, F_y)
    dtw_ratio = d/t_w
    limit_1 = 0.84*sqrt(E/F_y)
    limit_2 = 1.52*sqrt(E/F_y)
    if dtw_ratio <= limit_1
        F_cr = F_y
    elseif limit_1 < dtw_ratio <= limit_2
        F_cr = Equations.EqF9▬18(d, t_w, F_y, E)
    else
        F_cr = Equations.EqF9▬19(E, d, t_w)
    end

    return F_cr
end


"""
    calc_variables(F_y, S_x, d, L_b, I_y, J, t_w, E)

Calculates the intermediate variables needed to then solve for moment capacities of the applicable section.

Description of applicable member: WT-shaped member loaded in the plane of symmetry. 

# Arguments
- `F_y`: yield strength of steel (ksi)
- `S_x`: elastic section modulous (inch^3)
- `d`: depth of the tee in compression
- `L_b`: unbraced length (inch)
- `I_y`: second moment of inertia about the y-axis (inch^4)
- `J`: torsional constant (inch^4)
- `t_w`: thickness of the web (inch)
- `E`: modulous of elasticity (ksi)

# Returns 
(; M_p, M_y, M_cr, F_cr)
- `M_p`: plastic moment of the section (kip-in)
- `M_y`: yield moment of the section bent about the respective axis (kip-in)
- `M_cr`: elastic lateral-torsional buckling moment of the section bent about the respective axis (kip-in)
- `F_cr`: critical stress (ksi)

# Reference
- AISC Section F9
"""
function calc_variables(F_y, S_x, d, L_b, I_y, J, t_w, E)
    M_y = calc_My(F_y, S_x)
    M_p = calc_Mp(M_y)
    B = calc_B(d, L_b, I_y, J)
    M_cr = calc_Mcr(E, L_b, I_y, J, B)
    F_cr = calc_Fcr(d, t_w, E, F_y)
    return (; M_p, M_y, M_cr, F_cr)
end


"""
    calc_MnLTB(M_cr, M_y)

Calculates the moment capacity of the applicable section for lateral torsional buckling.

Description of applicable member: WT-shaped member loaded in the plane of symmetry. 

# Arguments
- `M_cr`: elastic lateral-torsional buckling moment of the section bent about the respective axis (kip-in)
- `M_y`: yield moment of the section bent about the respective axis (kip-in)

# Returns 
- `M_nLTB`: moment capacity of the section for lateral torsional buckling.

# Reference
- AISC Section F9 (F9-13)
"""
function calc_MnLTB(M_cr, M_y)

    # 2. Lateral Torsional Buckling
    M_nLTB = Equations.EqF9▬13(M_cr, M_y)
end


"""
    calc_MnLB(F_cr, S_x)

Calculates the moment capacity of the applicable section for local buckling of tee stems.

Description of applicable member: WT-shaped member loaded in the plane of symmetry. 

# Arguments
- `F_cr`: critical stress (ksi)
- `S_x`: elastic section modulous (inch^3)

# Returns 
- `M_nLB`: moment capacity of the section for local buckling of tee stems.

# Reference
- AISC Section F9 (F9-16)
"""
function calc_MnLB(F_cr, S_x)

    # 4. Local Buckling of Tee Stems
    M_nLB = Equations.EqF9▬16(F_cr, S_x)
end


"""
    calc_Mn(F_y, S_x, d, L_b, I_y, J, t_w, E)

Calculates the moment capacity of the applicable section for local buckling of tee stems.

Description of applicable member: WT-shaped member loaded in the plane of symmetry. 

# Arguments
- `F_y`: yield strength of steel (ksi)
- `S_x`: elastic section modulous (inch^3)
- `d`: depth of the tee in compression
- `L_b`: unbraced length (inch)
- `I_y`: second moment of inertia about the y-axis (inch^4)
- `J`: torsional constant (inch^4)
- `t_w`: thickness of the web (inch)
- `E`: modulous of elasticity (ksi)

# Returns 
- `M_n`: moment capacity of the section.

# Reference
- AISC Section F9
"""
function calc_Mn(F_y, S_x, d, L_b, I_y, J, t_w, E)

    (; M_p, M_y, M_cr, F_cr) = calc_variables(F_y, S_x, d, L_b, I_y, J, t_w, E)

    # 1. Yielding
    M_nY = calc_MnY(M_p)

    # 2. Lateral Torsional Buckling
    M_nLTB = calc_MnLTB(M_cr, M_y)

    # 3. Local Buckling of Tee Stems
    M_nLB = calc_MnLB(F_cr, S_x)

    M_n = min(M_nY, M_nLTB, M_nLB)
end


end