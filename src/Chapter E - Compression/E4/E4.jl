"""
    module E4

This section applies to singly symmetric and unsymmetric members, certain doubly symmetric 
members, such as cruciform or built-up members, and doubly symmetric members when the 
torsional unbraced length exceeds the lateral unbraced length, all without slender elements. 
These provisions also apply to single angles with `` b/t > 0.71*sqrt{E/F_y} ``
"""
module E4
using StructuralUnits

# include equations
include("Equations.jl")

##########################################################################################
# Equations below are the public API for E4
##########################################################################################
"""
    calc_Pn(F_n, A_g)

Calculates the nominal compressive strength for flexural buckling of the applicable section.

Description of applicable member: member without slender elements.  

# Arguments
- `F_n`: nominal stress (ksi)
- `A_g`: gross area of member (inch^2)

# Returns 
- `P_n`: nominal compressive strength for flexural buckling (kip)

# Reference
- AISC Section E4 (E4-1)
"""
function calc_Pn(F_n, A_g)
    P_n = Equations.EqE4▬1(F_n, A_g)
end


"""
    calc_Fex(E, L_cx, r_x)

Calculates the elastic buckling stress of the applicable section about the x-axis.

Description of applicable member: member without slender elements.  

# Arguments
- `E`: modulous of elasticity (ksi)
- `L_cx`: effective length of member for buckling about the x-axis (inch)
- `r_x`: radius of gyration about the x-axis (inch)

# Returns 
- `F_ex`: elastic buckling stress about the x-axis (ksi)

# Reference
- AISC Section E4 (E4-5)
"""
function calc_Fex(E, L_cx, r_x)
    F_ex = Equations.EqE4▬5(E, L_cx, r_x)
end


"""
    calc_Fey(E, L_cy, r_y)

Calculates the elastic buckling stress of the applicable section about the y-axis.

Description of applicable member: member without slender elements.  

# Arguments
- `E`: modulous of elasticity (ksi)
- `L_cy`: effective length of member for buckling about the y-axis (inch)
- `r_y`: radius of gyration about the y-axis (inch)

# Returns 
- `F_ey`: elastic buckling stress about the y-axis (ksi)

# Reference
- AISC Section E4 (E4-6)
"""
function calc_Fey(E, L_cy, r_y)
    F_ey = Equations.EqE4▬6(E, L_cy, r_y)
end


"""
    calc_Fez(E, C_w, L_cz, G, J, A_g, r̄_0)

Calculates the elastic buckling stress of the applicable section about the z-axis.

Description of applicable member: member without slender elements.  

# Arguments
- `E`: modulous of elasticity (ksi)
- `C_w`: warping constant (inch^6)
- `G`: shear modulus elasticity of steel (ksi)
- `J`: torsional constant (inch^4)
- `A_g`: gross area of member (inch^2)
- `r̄_0`: polar radius of gyration about the shear center (inch)

# Returns 
- `F_ez`: elastic buckling stress about the z-axis (ksi)

# Reference
- AISC Section E4 (E4-7)
"""
function calc_Fez(E, C_w, L_cz, G, J, A_g, r̄_0)
    F_ez = Equations.EqE4▬7(E, C_w, L_cz, G, J, A_g, r̄_0)
end


"""
    calc_H(x_0, y_0, r̄_0)

Calculates the flexural constant.

Description of applicable member: member without slender elements.  

# Arguments
- `x_0`: x-coordinate of the shear center with respect to the centroid (inch)
- `y_0`: y-coordinate of the shear center with respect to the centroid (inch)
- `r̄_0`: polar radius of gyration about the shear center (inch)

# Returns 
- `H`: flexural constant

# Reference
- AISC Section E4 (E4-8)
"""
function calc_H(x_0, y_0, r̄_0)
    H = Equations.EqE4▬8(x_0, y_0, r̄_0)
end

end