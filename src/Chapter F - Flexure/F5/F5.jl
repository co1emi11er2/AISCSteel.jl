module F5
using StructuralUnits
import AISCSteel.ChapterFFlexure.F4 as F4

# include equations
include("Equations.jl")

##########################################################################################
# Equations below are the public API for F5
##########################################################################################
import AISCSteel.ChapterFFlexure.F4: calc_aw, calc_rt, calc_Lp

calc_Mp(R_pg, F_y, S_xc) = M_p = Equations.EqF5▬1(R_pg, F_y, S_xc)


function calc_FcrLTB(E, F_y, C_b, L_b, L_p, L_r, r_t)
    if L_b <= L_p
        F_crLTB = F_y
    elseif L_p < L_b <= L_r
        F_crLTB = Equations.EqF5▬3(C_b, F_y, L_b, L_p, L_r)
    else
        F_crLTB = Equations.EqF5▬4(C_b, E, L_b, r_t)
    end

    F_crLTB = min(F_crLTB, F_y)

    return F_crLTB
end

calc_Lr(r_t, E, F_y) = L_r = Equations.EqF5▬5(r_t, E, F_y)

function calc_Rpg(a_w, h_c, t_w, E, F_y)
    R_pg = Equations.EqF5▬6(a_w, h_c, t_w, E, F_y)
    R_pg = min(R_pg, 1.0)
end

function calc_FcrCFLB(E, F_y, k_c, b_fc, t_fc, λ_f, λ_pf, λ_rf, λ_fclass)
    if λ_fclass == :compact
        F_crCFLB = F_y
    elseif λ_fclass == :noncompact
        F_crCFLB = Equations.EqF5▬8(F_y, λ_f, λ_pf, λ_rf)
    else
        F_crCFLB = Equations.EqF5▬9(E, k_c, b_fc, t_fc)
    end

    return F_crCFLB
end

function calc_variables(E, F_y, S_xc, b_fc, t_fc, h, h_c, t_w, λ_f, λ_pf, λ_rf, λ_fclass, L_b, C_b=1)

    a_w = calc_aw(h_c, t_w, b_fc, t_fc)
    a_w = min(a_w, 10.0)

    R_pg = Equations.EqF5▬6(a_w, h_c, t_w, E, F_y)
    R_pg = min(R_pg, 1.0)
    
    M_p = calc_Mp(R_pg, F_y, S_xc)

    r_t = calc_rt(b_fc, a_w)

    L_p = F4.calc_Lp(r_t, E, F_y)
    L_r = calc_Lr(r_t, E, F_y)

    F_crLTB = calc_FcrLTB(E, F_y, C_b, L_b, L_p, L_r, r_t)

    k_c = 4/sqrt(h/t_w) # no reference equation (in section F5.3)
    k_c = max(min(k_c, 0.76), 0.35)

    F_crCFLB = calc_FcrCFLB(E, F_y, k_c, b_fc, t_fc, λ_f, λ_pf, λ_rf, λ_fclass)

    return (;M_p, R_pg, F_crLTB, F_crCFLB)
end

"""
    calc_MnCFY(M_p)

Calculates the moment capacity of the applicable section for compression flange yielding.

Description of applicable member: I-shaped members with slender webs bent about their major axis.

# Arguments
- `M_p`: plastic moment of the section (kip-ft)

# Returns 
- `M_nCFY`: moment capacity of the section for compression flange yielding.

# Reference
- AISC Section F5.1
"""
function calc_MnCFY(M_p)
    M_nCFY = M_p
end

"""
    calc_MnLTB(R_pg, F_crLTB, S_xc)

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
function calc_MnLTB(R_pg, F_crLTB, S_xc)
    M_nLTB = R_pg*F_crLTB*S_xc
end

"""
    calc_MnCFLB(R_pg, F_crCFLB, S_xc)

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
function calc_MnCFLB(R_pg, F_crCFLB, S_xc)
    M_nCFLB = R_pg*F_crCFLB*S_xc
end

"""
    calc_MnTFY(F_y, S_xt)

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
function calc_MnTFY(F_y, S_xt)
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
function calc_Mn(E, F_y, S_xc, S_xt, b_fc, t_fc, h, h_c, t_w, λ_f, λ_pf, λ_rf, λ_fclass, L_b, C_b=1)

    (;M_p, R_pg, F_crLTB, F_crCFLB) = calc_variables(E, F_y, S_xc, b_fc, t_fc, h, h_c, t_w, λ_f, λ_pf, λ_rf, λ_fclass, L_b, C_b)
    
    # 1. Compression Flange Yielding
    M_nCFY = calc_MnCFY(M_p)

    # 2. Lateral Torsional Buckling
    M_nLTB = calc_MnLTB(R_pg, F_crLTB, S_xc)

    # 3. Compression Flange Local Buckling
    M_nCFLB = calc_MnCFLB(R_pg, F_crCFLB, S_xc)

    # 4. Tension Flange Yielding
    M_nTFY = calc_MnTFY(F_y, S_xt)

    M_n = min(M_nCFY, M_nLTB, M_nCFLB, M_nTFY)

    return M_n
end


end # module