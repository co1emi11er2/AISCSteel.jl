"""
    module F8

This section applies round HSS having ``D/t`` ratios less than ``\\frac{0.45E}{F_y}``
"""
module F8

# include equations
include("Equations.jl")

##########################################################################################
# Equations below are the public API for F8
##########################################################################################
"""
    calc_Mp(F_y, Z)

Calculates the plastic moment capacity of the applicable section.

Description of applicable member: round HSS

# Arguments
- `F_y`: yield strength of steel (ksi)
- `Z`: plastic section modulous about the axis of bending (inch^4)

# Returns 
- `M_p`: plastic moment of the section (kip-in)

# Reference
- AISC Section F8 (F8-1)
"""
calc_Mp(F_y, Z) = M_p = Equations.EqF8▬1(F_y, Z)

"""
    calc_Fcr(E, D, t)

Calculates the critical stress of the applicable section.

Description of applicable member: Doubly symmetric compact I-shaped members and channels bent about their major axis. 

# Arguments
- `E`: modulous of elasticity (ksi)
- `D`: outside diameter of round HSS (inch)
- `t`: design wall thickness of round HSS

# Returns 
- `F_cr`: critical stress (ksi)

# Reference
- AISC Section F8 (F8-4)
"""
calc_Fcr(E, D, t) = F_cr = Equations.EqF8▬4(E, D, t)


"""
    calc_MnY(M_p)

Calculates the moment capacity of the applicable section for yielding.

Description of applicable member: round HSS

# Arguments
- `M_p`: plastic moment of the section (kip-in)

# Returns 
- `M_nY`: moment capacity of the section for yielding. (kip-in)

# Reference
- AISC Section F8.1
"""
calc_MnY(M_p) = M_nFY = M_p


"""
    calc_MnLB(M_p, E, F_y, D, t, S, λ_class)

Calculates the moment capacity of the applicable section for compression flange local buckling.

Description of applicable member: round HSS

# Arguments
- `M_p`: plastic moment of the section (kip-in)
- `E`: modulous of elasticity (ksi)
- `F_y`: yield strength of steel (ksi)
- `D`: outside diameter of round HSS (inch)
- `t`: design wall thickness of round HSS
- `S`: elastic section modulus about the axis of bending (inch^3)
- `λ_class`: `compact` `noncompact` or `slender` classification for the HSS

# Returns 
- `M_nLB`: moment capacity of the section for local buckling. (kip-in)

# Reference
- AISC Section F8.2
"""
function calc_MnLB(M_p, E, F_y, D, t, S, λ_class)
    # 3. Local Buckling
    if λ_class == :compact
        M_nLB = M_p
    elseif λ_class == :noncompact
        M_nLB = Equations.EqF8▬2(E, D, t, F_y, S)
    else
        F_cr = calc_Fcr(E, D, t)
        M_nLB = Equations.EqF8▬3(F_cr, S)
    end

    return M_nLB
end


"""
    calc_Mn(E, F_y, Z, D, t, S, λ_class)

Calculates the moment capacity of the applicable section.

Description of applicable member: rectangular HSS, and box sections bent about their major axis 

# Arguments
- `E`: modulous of elasticity (ksi)
- `F_y`: yield strength of steel (ksi)
- `Z`: plastic section modulous about the axis of bending (inch^4)
- `D`: outside diameter of round HSS (inch)
- `t`: design wall thickness of round HSS
- `S`: elastic section modulus about the axis of bending (inch^3)
- `λ_class`: `compact` `noncompact` or `slender` classification for the HSS

# Returns 
- `M_n`: moment capacity of the section. (kip-in)

# Reference
- AISC Section F8
"""
function calc_Mn(E, F_y, Z, D, t, S, λ_class)

    M_p = calc_Mp(F_y, Z)
    
    # 1. Yielding
    M_nY = calc_MnY(M_p)

    # 2. Flange Local Buckling
    M_nLB = calc_MnLB(M_p, E, F_y, D, t, S, λ_class)
    
    M_n = min(M_nY, M_nLB)

    return M_n
end

end # module