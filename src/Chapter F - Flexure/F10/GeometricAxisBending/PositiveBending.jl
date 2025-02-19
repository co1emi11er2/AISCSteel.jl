"""
    module PositiveBending

LShapes bent about their geometric axis (x-axis, y-axis) when compression is in the toe of the leg.
"""
module PositiveBending
import AISCSteel.ChapterFFlexure.F10 as F10

function calc_Mcr(E, b, t, C_b, L_b)
    C_b = min(C_b, 1.5)
    M_cr = F10.Equations.EqF10▬5a(E, b, t, C_b, L_b)
end

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