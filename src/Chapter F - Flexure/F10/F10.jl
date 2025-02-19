module F10

import AISCSteel.Utils.UnitConversions as cnv

# include equations
include("Equations.jl")

##########################################################################################
# Equations below are the public API for F10
##########################################################################################
"""
    calc_MnY(M_y)

Calculates the moment capacity of the applicable section for yielding.

Description of applicable member: L-shaped members bent about their geometric or principal axis. 

# Arguments
- `M_y`: yield moment of the section bent about the respective axis (kip-ft)

# Returns 
- `M_nY`: moment capacity of the section for yielding.

# Reference
- AISC Section F10.1
"""
calc_MnY(M_y) = M_nY = Equations.EqF10▬1(M_y)

"""
    calc_MnLTB(M_y, M_cr)

Calculates the moment capacity of the applicable section for lateral torsional buckling.

Description of applicable member: L-shaped members bent about their geometric or principal axis. For the geometric axis, it is assumed the legs are of equal length.

# Arguments
- `M_y`: yield moment of the section bent about the respective axis (kip-ft)
- `M_cr`: elastic lateral-torsional buckling moment of the section bent about the respective axis (kip-ft)

# Returns 
- `M_nLTB`: moment capacity of the section for lateral torsional buckling.

# Reference
- AISC Section F10.2
"""
function calc_MnLTB(M_y, M_cr)
    if M_y/M_cr <= 1.0
        M_nLTB = Equations.EqF10▬2(M_y, M_cr)
    else
        M_nLTB = Equations.EqF10▬3(M_cr, M_y)
    end

    return M_nLTB
end

"""
    calc_MnLLB(λ_class, M_y, F_y, S_c, b, t, E, F_cr)

Calculates the moment capacity of the applicable section for local leg buckling.

Description of applicable member: L-shaped members bent about their geometric or principal axis.

# Arguments
- `λ_class`: slenderness classification of angle leg
- `M_y`: yield moment of the section bent about the respective axis (kip-ft)
- `F_y`: yield strength of steel (ksi)
- `S_c`: elastic section modulous to the toe in compression relative to the axis of bending (inch^3)
- `b`: length of leg in compression (inch)
- `t`: thickness of leg (inch)
- `E`: modulous of elasticity (ksi)
- `F_cr`: critical stress (ksi)

# Returns 
- `M_nLLB`: moment capacity of the section for local leg buckling.

# Reference
- AISC Section F10.3
"""
function calc_MnLLB(λ_class, M_y, F_y, S_c, b, t, E, F_cr)
    
    if λ_class == :compact
        M_nLLB = Equations.EqF10▬1(M_y)
    elseif λ_class == :noncompact
        M_nLLB = Equations.EqF10▬6(F_y, S_c, b, t, E)
    else
        M_nLLB = Equations.EqF10▬7(F_cr, S_c)
    end

    return M_nLLB
end

"""
    calc_Fcr(E, b, t)

Calculates the critical stress of the applicable section for local leg buckling.

Description of applicable member: L-shaped members bent about their geometric or principal axis.

# Arguments
- `E`: modulous of elasticity (ksi)
- `b`: length of leg in compression (inch)
- `t`: thickness of leg (inch)

# Returns 
- `F_cr`: critical stress (ksi)

# Reference
- AISC Section F10 (F10-8)
"""
function calc_Fcr(E, b, t)
    F_cr = Equations.EqF10▬8(E, b, t)
end

"""
    calc_My(F_y, S_min)

Calculates the critical stress of the applicable section for local leg buckling.

Description of applicable member: L-shaped members bent about their geometric or principal axis.

# Arguments
- `F_y`: yield strength of steel (ksi)
- `S_min`: minimum elastic section modulous about respective axis (inch^3)

# Returns 
- `M_y`: yield moment of the section bent about the respective axis (kip-ft)

# Reference
- AISC Section F10 (no code reference)
"""
function calc_My(F_y, S_min)
    M_y = F_y * S_min |> cnv.to_moment # no code reference
end


include("PrincipalAxisBending/PrincipalAxisBending.jl")
include("GeometricAxisBending/GeometricAxisBending.jl")

end # module