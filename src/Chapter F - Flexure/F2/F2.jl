module F2

# include equations
include("Equations.jl")

##########################################################################################
# Equations below are the public API for F2
##########################################################################################
function variables(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, C_b=1)

    M_p = EqF2▬1(F_y, Z_x)

    L_p = 1.76*r_y*sqrt(E/F_y)
    L_r = 1.95*r_ts*(E/(0.7*F_y))*sqrt((J*c)/(S_x*h_0) + sqrt(((J*c)/(S_x*h_0))^2 + 6.76*((0.7*F_y)/E)^2))
    F_cr = _calc_Fcr(C_b, E, L_b, r_ts, J, c, S_x, h_0)

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





end