module F2
using StructuralUnits

# include equations
include("Equations.jl")

##########################################################################################
# Equations below are the public API for F2
##########################################################################################
calc_Mp(F_y, Z_x) = M_p = Equations.EqF2▬1(F_y, Z_x)
calc_L_p(E, F_y, r_y) = L_p = Equations.EqF2▬5(E, F_y, r_y)
calc_L_r(r_ts, E, F_y, J, c, S_x, h_0) = L_r = Equations.EqF2▬6(r_ts, E, F_y, J, c, S_x, h_0)
calc_Fcr(C_b, E, L_b, r_ts, J, c, S_x, h_0) = F_cr = Equations.EqF2▬4(C_b, E, L_b, r_ts, J, c, S_x, h_0)

function calc_variables(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, C_b=1)

    M_p = calc_Mp(F_y, Z_x)
    L_p = calc_L_p(E, F_y, r_y)
    L_r = calc_L_r(r_ts, E, F_y, J, c, S_x, h_0)
    F_cr = calc_Fcr(C_b, E, L_b, r_ts, J, c, S_x, h_0)

    return (;M_p, L_p, L_r, F_cr)
end

"""
    calc_MnFY(M_p)

Calculates the moment capacity of the applicable section for yielding.

Description of applicable member: Doubly symmetric compact I-shaped members and channels bent about their major axis. 

# Arguments
- `M_p`: plastic moment of the section (kip-ft)

# Returns 
- `M_nFY`: moment capacity of the section for yielding.

# Reference
- AISC Section F2.1
"""
calc_MnFY(M_p) = M_nFY = M_p

"""
    calc_MnLTB(M_p, F_y, S_x, F_cr, L_b, L_p, L_r, C_b=1)

Calculates the moment capacity of the applicable section for lateral torsional buckling.

Description of applicable member: Doubly symmetric compact I-shaped members and channels bent about their major axis. 

# Arguments
- `M_p`: plastic moment of the section (kip-ft)
- `F_y`: yield strength of steel (ksi)
- `S_x`: elastic section modulous (inch^3)
- `F_cr`: critical stress (ksi)
- `L_b`: unbraced length (inch)
- `L_p`: the limiting laterally unbraced length for the limit state of yielding (inch)
- `L_r`: the limiting laterally unbraced length for the limit state of inelastic lateral-torsional buckling (inch)
- `C_b`: lateral torsional buckling modification factor (default = 1)

# Returns 
- `M_nLTB`: moment capacity of the section for lateral torsional buckling.

# Reference
- AISC Section F2.2
"""
function calc_MnLTB(M_p, F_y, S_x, F_cr, L_b, L_p, L_r, C_b=1)
    M_nLTB = if L_b <= L_p
        M_p
    elseif L_p < L_b <= L_r
        C_b*(M_p - (M_p-0.7*F_y*S_x)*((L_b-L_p)/(L_r-L_p)))
    else
        F_cr*S_x
    end |> kip*ft
end

"""
    calc_Mn(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, C_b=1)

Calculates the moment capacity of the applicable section.

Description of applicable member: Doubly symmetric compact I-shaped members and channels bent about their major axis. 

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
- `C_b`: lateral torsional buckling modification factor (default = 1)

# Returns 
- `M_n`: moment capacity of the section.

# Reference
- AISC Section F2
"""
function calc_Mn(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, C_b=1)

    (;M_p, L_p, L_r, F_cr) = calc_variables(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, C_b)

    # 1. Yielding 
    M_nFY = calc_MnFY(M_p)

    # 2. Lateral-Torsional Buckling
    M_nLTB = calc_MnLTB(M_p, F_y, S_x, F_cr, L_b, L_p, L_r, C_b)

    M_n = min(M_nFY, M_nLTB)

    return M_n
end



end