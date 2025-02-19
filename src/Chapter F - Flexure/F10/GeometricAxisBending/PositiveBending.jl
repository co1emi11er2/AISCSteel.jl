"""
    module PositiveBending

LShapes bent about their geometric axis (x-axis, y-axis) when compression is in the toe of the leg.
"""
module PositiveBending
import AISCSteel.ChapterFFlexure.F10 as F10

"""
    calc_Mcr(E, b, t, C_b, L_b)

Calculates the elastic lateral-torsional buckling moment of the section bent about the respective axis (kip-ft)

Description of applicable member: L-shaped members bent about their geometric axis. For the geometric axis, it is assumed the legs are of equal length.

# Arguments
- `E`: modulous of elasticity (ksi)
- `b`: length of leg (inch)
- `t`: thickness of leg (inch)
- `C_b`: lateral torsional buckling modification factor (default = 1)
- `L_b`: unbraced length (inch)

# Returns 
- `M_cr`: elastic lateral-torsional buckling moment of the section bent about the respective axis (kip-ft)

# Reference
- AISC Section F10 (F10-5aS)
"""
function calc_Mcr(E, b, t, C_b, L_b)
    C_b = min(C_b, 1.5)
    M_cr = F10.Equations.EqF10▬5a(E, b, t, C_b, L_b)
end

"""
    calc_positive_Mn(F_y, S_min, E, b, t, λ_class, L_b, restraint_type, C_b)

Calculates positive moment (when toe of leg is in compression) about geometric axis for an LShape.

# Arguments
- `F_y`: yield strength of steel (ksi)
- `S_min`: elastic section modulous for desired axis (x or y) (inch^3)
- `E`: modulous of elasticity (ksi)
- `b`: length of leg perpendicular to axis of bending (inch)
- `t`: thickness of leg (inch)
- `λ_class`: slenderness classification of angle leg
- `L_b`: unbraced length (inch)
- `restraint_type`: type of restraint on leg (`:fully_restrained`, `:unrestrained`, or `:at_max_moment_only`)
- `C_b`: lateral torsional buckling modification factor
"""
function calc_positive_Mn(F_y, S_min, E, b, t, λ_class, L_b, restraint_type, C_b)

    M_y = F10.calc_My(F_y, S_min)

    if L_b == 0
        M_nY = F10.calc_MnY(M_y)
        M_nLTB = M_ny
    else
        M_cr = calc_Mcr(E, b, t, C_b, L_b)
        if restraint_type == :unrestrained
            M_y = 0.8 * M_y
        elseif restraint_type == :at_max_moment_only
            M_cr = 1.25 * M_cr
        else
            @warn "Code assumes `unrestrained` or `at_max_moment_only`. Function may not work otherwise"
        end
        M_nY = F10.calc_MnY(M_y)
        M_nLTB = F10.calc_MnLTB(M_y, M_cr)
    end

    S_c = 0.8 * S_min
    F_cr = F10.calc_Fcr(E, b, t)
    M_nLLB = F10.calc_MnLLB(λ_class, M_y, F_y, S_c, b, t, E, F_cr)

    M_n = min(M_nY, M_nLTB, M_nLLB)

    return M_n
end

end