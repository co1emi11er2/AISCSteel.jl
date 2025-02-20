"""
    module F9

This section applies to tees and double angles loaded in the plane of symmetry.

There are two sections:
- WT - for WT shapes (`WTShape`, `STShape`, `MTShape`)
- DoubleAngles - for double angles
"""
module F9

# include equations
include("Equations.jl")

##########################################################################################
# Equations below are the public API for F9
##########################################################################################
"""
    calc_Lp(E, F_y, r_y)

Calculates the limiting laterally unbraced length for the limit state of yielding of the applicable section.

Description of applicable member: WT-shaped member loaded in the plane of symmetry. 

# Arguments
- `r_y`: radius of gyration about the y-axis (inch)
- `E`: modulous of elasticity (ksi)
- `F_y`: yield strength of steel (ksi)

# Returns 
- `L_p`: the limiting laterally unbraced length for the limit state of yielding (inch)

# Reference
- AISC Section F9 (F9-8)
"""
calc_Lp(r_y, E, F_y) = L_p = Equations.EqF9▬8(r_y, E, F_y)


"""
    calc_Lr(E, F_y, I_y, J, S_x, d)

Calculates the limiting laterally unbraced length for the limit state of inelastic lateral-torsional buckling of the applicable section.

Description of applicable member: WT-shaped member loaded in the plane of symmetry. 

# Arguments
- `E`: modulous of elasticity (ksi)
- `F_y`: yield strength of steel (ksi)
- `I_y`: second moment of inertia about the y-axis (inch^4)
- `J`: torsional constant (inch^4)
- `S_x`: elastic section modulous (inch^3)
- `d`: depth of the tee or leg of angle in compression

# Returns 
- `L_r`: the limiting laterally unbraced length for the limit state of inelastic lateral-torsional buckling (inch)

# Reference
- AISC Section F2 (F9-9)
"""
calc_Lr(E, F_y, I_y, J, S_x, d) = L_r = Equations.EqF9▬9(E, F_y, I_y, J, S_x, d)


"""
    calc_Mcr(E, L_b, I_y, J, B)

Calculates `M_cr` of the applicable section.

Description of applicable member: WT-shaped member loaded in the plane of symmetry. 

# Arguments
- `E`: modulous of elasticity (ksi)
- `L_b`: unbraced length (inch)
- `I_y`: second moment of inertia about the y-axis (inch^4)
- `J`: torsional constant (inch^4)
- `B`: see AISC F9

# Returns 
- `M_cr`: elastic lateral-torsional buckling moment of the section bent about the respective axis (kip-in)

# Reference
- AISC Section F2 (F9-10)
"""
calc_Mcr(E, L_b, I_y, J, B) = M_cr = Equations.EqF9▬10(E, L_b, I_y, J, B)


"""
    calc_My(F_y, S_x)

Calculates `M_y` of the applicable section.

Description of applicable member: WT-shaped member loaded in the plane of symmetry. 

# Arguments
- `F_y`: yield strength of steel (ksi)
- `S_x`: elastic section modulous (inch^3)

# Returns 
- `M_y`: yield moment of the section bent about the respective axis (kip-in)

# Reference
- AISC Section F2 (F9-3)
"""
calc_My(F_y, S_x) = M_p =  Equations.EqF9▬3(F_y, S_x)


"""
    calc_MnY(M_p)

Calculates `M_nY` of the applicable section.

Description of applicable member: WT-shaped member loaded in the plane of symmetry. 

# Arguments
- `M_p`: plastic moment of the section (kip-in)

# Returns 
- `M_nY`: moment capacity of the section for yielding. (kip-in)

# Reference
- AISC Section F2 (F9-3)
"""
calc_MnY(M_p) = M_nY = M_p


# include API for WTs
include("WT/WT.jl")

# include API for DoubleAngles
include("DoubleAngles/DoubleAngles.jl")

end # module
