"""
    module E3

This section applies to nonslender element compression members, as defined in Section B4.1, 
for elements in axial compression.
"""
module E3
using StructuralUnits

# include equations
include("Equations.jl")

##########################################################################################
# Equations below are the public API for E3
##########################################################################################

"""
    calc_Fe(E, L_c, r)

Calculates the elastic buckling stress of the applicable section.

Description of applicable member: member without slender elements.  

# Arguments
- `E`: modulous of elasticity (ksi)
- `L_c`: effective length of member (inch)
- `r`: radius of gyration (inch)

# Returns 
- `F_e`: elastic buckling stress (ksi)


# Reference
- AISC Section E3 (F3-4)
"""
function calc_Fe(E, L_c, r)
    F_e = Equations.EqE3▬4(E, L_c, r)
end


"""
    calc_Fn(L_c, r, F_y, F_e)

Calculates the nominal stress of the applicable section.

Description of applicable member: member without slender elements.  

# Arguments
- `L_c`: effective length of member (inch)
- `r`: radius of gyration (inch)
- `F_y`: yield strength of steel (ksi)
- `F_e`: elastic buckling stress (ksi)

# Returns 
- `F_n`: nominal stress (ksi)


# Reference
- AISC Section E3
"""
function calc_Fn(L_c, r, F_y, F_e)
    if L_c/r <= 4.71*sqrt(E/F_y)
        F_n = Equations.EqE3▬2(F_y, F_e)
    else
        F_n = Equations.EqE3▬3(F_e)
    end
end


"""
    calc_Pn(F_n, A_g)

Calculates the nominal compressive strength of the applicable section.

Description of applicable member: member without slender elements.  

# Arguments
- `F_n`: nominal stress (ksi)
- `A_g`: gross area of member (inch^2)

# Returns 
- `P_n`: nominal compressive strength (kip)


# Reference
- AISC Section E3 (E3-1)
"""
function calc_Pn(F_n, A_g)
    P_n = Equations.EqE3▬1(F_n, A_g)
end

end