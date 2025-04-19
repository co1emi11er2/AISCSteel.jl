"""
    module E7

This section applies to slender element compression members, as defined in Section B4.1 for 
elements in axial compression.
"""
module E7
using StructuralUnits

# include equations
include("Equations.jl")

##########################################################################################
# Equations below are the public API for E7
##########################################################################################

"""
    calc_be(λ, λ_r, F_y, F_n, c_1, F_el)

Calculates the effective width for slender elements of the applicable section.

Description of applicable member: member with slender elements.  

# Arguments
- `λ`: slenderness ratio
- `λ_r`: onslender slenderness ratio limit
- `F_y`: yield strength of steel (ksi)
- `F_n`: nominal stress (ksi)
- `c_1`: effective width imprtfection adjustment factor
- `F_el`: elastic local buckling stress (ksi)

# Returns 
- `b_e`: effective width for slender elements (inch)

# Reference
- AISC Section E7 (F7-2 and E7-3)
"""
function calc_be(λ, λ_r, F_y, F_n, b, c_1, F_el)
    if λ <= λ_r*sqrt(F_y/F_n)
        b_e = Equations.EqE7▬2(b)
    else
        b_e = Equations.EqE7▬3(b, c_1, F_el, F_n)
    end

    return b_e
end


"""
    calc_Fel(c_2, λ_r, λ, F_y)

Calculates the elastic local buckling stress of the applicable section.

Description of applicable member: member with slender elements.  

# Arguments
- `c_2`: second effective width imprtfection adjustment factor
- `λ_r`: onslender slenderness ratio limit
- `λ`: slenderness ratio
- `F_y`: yield strength of steel (ksi)

# Returns 
- `F_el`: elastic local buckling stress (ksi)

# Reference
- AISC Section E7 (F7-5)
"""
function calc_Fel(c_2, λ_r, λ, F_y)
    F_el = Equations.EqE7▬5(c_2, λ_r, λ, F_y)
end


"""
    calc_Ae(A_g, b, b_e, t)

Calculates the effective area for slender elements of the applicable section.

Description of applicable member: member with slender elements.  

# Arguments
- `A_g`: gross area of member (inch^2)
- `b` width of element (for tees this is `d`; for webs this is `h`)
- `b_e`: effective width for slender elements (inch)
- `t`: thickness of element

# Returns 
- `A_e`: effective area of member (inch^2)

# Reference
- AISC Section E7
"""
function calc_Ae(A_g, b, b_e, t)
    A_e = A_g - (b - b_e)*t

    return A_e
end


"""
    calc_Pn(F_n, A_e)

Calculates the nominal compressive strength for local buckling of the applicable section.

Description of applicable member: member with slender elements.  

# Arguments
- `F_n`: nominal stress (ksi)
- `A_e`: effective area of member (inch^2)

# Returns 
- `P_n`: nominal compressive strength for local buckling (kip)

# Reference
- AISC Section E7 (E7-1)
"""
function calc_Pn(F_n, A_e)
    P_n = Equations.EqE7▬1(F_n, A_e)
end

end