"""
    module F6

This section applies to I-shaped members and channels bent about ther minor axis.
"""
module F6

# include equations
include("Equations.jl")

##########################################################################################
# Equations below are the public API for F6
##########################################################################################
"""
    calc_Mp(F_y, Z_y, S_y)

Calculates the plastic moment capacity of the applicable section.

Description of applicable member: I-shaped members or C-shaped members bent about their minor axis.

# Arguments
- `F_y`: yield strength of steel (ksi)
- `Z_y`: plastic section modulous  (inch^4)
- `S_y`: elastic section modulous about y-axis (inch^3)

# Returns 
- `M_p`: plastic moment of the section (kip-ft)

# Reference
- AISC Section F6 (F6-1)
"""
calc_Mp(F_y, Z_y, S_y) = M_p = Equations.EqF6▬1(F_y, Z_y, S_y)


"""
    calc_Fcr(E, b, t_f)

Calculates the critical stress of the applicable section.

Description of applicable member: I-shaped members or C-shaped members bent about their minor axis.

# Arguments
- `E`: modulous of elasticity (ksi)
- `b`: 
    - I-Shapes: half full flange width 
    - C-Shapes: full nominal dimension of flange
- `t_f`: thickness of flange (inch)

# Returns 
- `F_cr`: critical stress (ksi)

# Reference
- AISC Section F6 (F6-4)
"""
calc_Fcr(E, b, t_f) = F_cr = Equations.EqF6▬4(E, b, t_f)


"""
    calc_variables(E, F_y, Z_y, S_y, b, t_f)

Calculates the intermediate variables needed to then solve for moment capacities of the applicable section.

Description of applicable member: I-shaped members or C-shaped members bent about their minor axis.

# Arguments
- `E`: modulous of elasticity (ksi)
- `F_y`: yield strength of steel (ksi)
- `Z_y`: plastic section modulous  (inch^4)
- `S_y`: elastic section modulous about y-axis (inch^3)
- `b`: 
    - I-Shapes: half full flange width 
    - C-Shapes: full nominal dimension of flange
- `t_f`: thickness of flange (inch)

# Returns 
    (;M_p, F_cr)
- `M_p`: plastic moment of the section (kip-ft)
- `F_cr`: critical stress (ksi)

# Reference
- AISC Section F6
"""
function calc_variables(E, F_y, Z_y, S_y, b, t_f)

    
    M_p = calc_Mp(F_y, Z_y, S_y)

    F_cr = calc_Fcr(E, b, t_f)

    return (;M_p, F_cr)
end


"""
    calc_MnFY(M_p)

Calculates the moment capacity of the applicable section for flange yielding.

Description of applicable member: I-shaped members or C-shaped members bent about their minor axis.

# Arguments
- `M_p`: plastic moment of the section (kip-ft)

# Returns 
- `M_nFY`: moment capacity of the section for compression flange yielding.

# Reference
- AISC Section F6.1
"""
function calc_MnFY(M_p)
    M_nFY = M_p
end


"""
    calc_MnFLB(M_p, F_y, S_y, λ_f, λ_pf, λ_rf, λ_fclass, F_cr)

Calculates the moment capacity of the applicable section for flange lateral buckling.

Description of applicable member: I-shaped members or C-shaped members bent about their minor axis.

# Arguments
- `M_p`: plastic moment of the section (kip-ft)
- `F_y`: yield strength of steel (ksi)
- `S_y`: elastic section modulous about y-axis (inch^3)
- `λ_f`: slenderness ratio of the flange
- `λ_pf`: compact slenderness ratio limit of the flange
- `λ_rf`: noncompact slenderness ratio limit of the flange
- `λ_fclass`: `compact` `noncompact` or `slender` classification for the flange
- `F_cr`: critical stress 

# Returns 
- `M_nFLB`: moment capacity of the section for flange lateral buckling.

# Reference
- AISC Section F6.2
"""
function calc_MnFLB(M_p, F_y, S_y, λ_f, λ_pf, λ_rf, λ_fclass, F_cr)

    if λ_fclass == :compact
        M_nFLB = M_p
    elseif λ_fclass == :noncompact
        M_nFLB = Equations.EqF6▬2(M_p, F_y, S_y, λ_f, λ_pf, λ_rf)
    else
        M_nFLB = Equations.EqF6▬3(F_cr, S_y)
    end

    return M_nFLB
end


"""
    calc_Mn(E, F_y, Z_y, S_y, b, t_f, λ_f, λ_pf, λ_rf, λ_fclass)

Calculates the moment capacity of the applicable section.

Description of applicable member: I-shaped members or C-shaped members bent about their minor axis.

# Arguments
- `E`: modulous of elasticity (ksi)
- `F_y`: yield strength of steel (ksi)
- `S_y`: elastic section modulous about y-axis (inch^3)
- `b`: 
    - I-Shapes: half full flange width 
    - C-Shapes: full nominal dimension of flange
- `t_f`: thickness of flange (inch)
- `λ_f`: slenderness ratio of the flange
- `λ_pf`: compact slenderness ratio limit of the flange
- `λ_rf`: noncompact slenderness ratio limit of the flange
- `λ_fclass`: `compact` `noncompact` or `slender` classification for the flange

# Returns 
- `M_n`: moment capacity of the section.

# Reference
- AISC Section F6
"""
function calc_Mn(E, F_y, Z_y, S_y, b, t_f, λ_f, λ_pf, λ_rf, λ_fclass)

    (;M_p, F_cr) = calc_variables(E, F_y, Z_y, S_y, b, t_f)
    
    # 1. Flange Yielding
    M_nFY = calc_MnFY(M_p)

    # 3. Flange Local Buckling
    M_nFLB = calc_MnFLB(M_p, F_y, S_y, λ_f, λ_pf, λ_rf, λ_fclass, F_cr)


    M_n = min(M_nFY,M_nFLB)

    return M_n
end


end # module