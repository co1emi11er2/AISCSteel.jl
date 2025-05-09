"""
    module F3

This section applies to doubly symmetric I-shaped members bent about their major
axis having compact webs and noncompact or slender flanges as defined in Section
B4.1 for flexure.
"""
module F3
using StructuralUnits

# include equations
include("Equations.jl")

##########################################################################################
# Equations below are the public API for F3
##########################################################################################
import AISCSteel.ChapterFFlexure.F2 as F2

"""
    calc_variables(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, h, t_w, C_b=1)

Calculates the intermediate variables needed to then solve for moment capacities of the applicable section.

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
- `C_b`: lateral torsional buckling modification factor (default = 1)

# Returns 
    (;M_p, L_p, L_r, F_cr, k_c)
- `M_p`: plastic moment of the section (kip-in)
- `L_p`: the limiting laterally unbraced length for the limit state of yielding (inch)
- `L_r`: the limiting laterally unbraced length for the limit state of inelastic lateral-torsional buckling (inch)
- `F_cr`: critical stress (ksi)
- `k_c`: 

# Reference
- AISC Section F3
"""
function calc_variables(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, h, t_w, C_b=1)
    (;M_p, L_p, L_r, F_cr) = F2.calc_variables(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, C_b)

    k_c = 4/sqrt(h/t_w)
    k_c = max(min(k_c, 0.76), 0.35)

    return (;M_p, L_p, L_r, F_cr, k_c)
end


"""
    calc_MnLTB(M_p, F_y, S_x, F_cr, L_b, L_p, L_r, C_b=1)

Calculates the moment capacity of the applicable section for yielding.

Description of applicable member: Doubly symmetric I-shaped members with compact webs and noncompact or slender flanges bent about their major axis. 

# Arguments
- `M_p`: plastic moment of the section (kip-in)
- `F_y`: yield strength of steel (ksi)
- `S_x`: elastic section modulous (inch^3)
- `F_cr`: critical stress (ksi)
- `L_b`: unbraced length (inch)
- `L_p`: the limiting laterally unbraced length for the limit state of yielding (inch)
- `L_r`: the limiting laterally unbraced length for the limit state of inelastic lateral-torsional buckling (inch)
- `C_b`: lateral torsional buckling modification factor (default = 1)

# Returns 
- `M_nLTB`: moment capacity of the section for lateral torsional buckling. (kip-in)

# Reference
- AISC Section F3.1
"""
function calc_MnLTB(M_p, F_y, S_x, F_cr, L_b, L_p, L_r, C_b=1)

    # 1. Lateral-Torsional Buckling
    M_nLTB = F2.calc_MnLTB(M_p, F_y, S_x, F_cr, L_b, L_p, L_r, C_b)
end


"""
    calc_MnCFLB(M_p, E, F_y, S_x, k_c, λ_f, λ_pf, λ_rf, λ_fclass)

Calculates the moment capacity of the applicable section for compression flange local buckling.

Description of applicable member: Doubly symmetric I-shaped members with compact webs and noncompact or slender flanges bent about their major axis. 

# Arguments
- `M_p`: plastic moment of the section (kip-in)
- `E`: modulous of elasticity (ksi)
- `F_y`: yield strength of steel (ksi)
- `S_x`: elastic section modulous (inch^3)
- `k_c`: 
- `λ_f`: slenderness ratio of the flange
- `λ_pf`: compact slenderness ratio limit of the flange
- `λ_rf`: noncompact slenderness ratio limit of the flange
- `λ_fclass`: `compact` `noncompact` or `slender` classification for the flange

# Returns 
- `M_nCFLB`: moment capacity of the section for compression flange local buckling. (kip-in)

# Reference
- AISC Section F3.2
"""
function calc_MnCFLB(M_p, E, F_y, S_x, k_c, λ_f, λ_pf, λ_rf, λ_fclass)

    # 2. Compression Flange Local Buckling
    if λ_fclass == :noncompact
        M_nCFLB = Equations.EqF3▬1(M_p, F_y, S_x, λ_f, λ_pf, λ_rf)
    elseif λ_fclass == :slender
        M_nCFLB = Equations.EqF3▬2(E, k_c, S_x, λ_f)
    else
        M_nCFLB = M_p
    end

    return M_nCFLB
end


"""
    calc_Mn(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, h, t_w, λ_f, λ_pf, λ_rf, λ_fclass, C_b=1)

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
- `M_n`: moment capacity of the section. (kip-in)

# Reference
- AISC Section F3
"""
function calc_Mn(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, h, t_w, λ_f, λ_pf, λ_rf, λ_fclass, C_b=1)

    (;M_p, L_p, L_r, F_cr, k_c) = calc_variables(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, h, t_w, C_b)

    # 1. Lateral Torsional Buckling from F2
    M_nLTB = calc_MnLTB(M_p, F_y, S_x, F_cr, L_b, L_p, L_r, C_b)

    # 2. Compression Flange Local Buckling
    M_nCFLB = calc_MnCFLB(M_p, E, F_y, S_x, k_c, λ_f, λ_pf, λ_rf, λ_fclass)

    M_n = min(M_nLTB, M_nCFLB)

    return M_n
end

end # module