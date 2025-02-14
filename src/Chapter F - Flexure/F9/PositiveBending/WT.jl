module WT
import AISCSteel.ChapterFFlexure.F9.Equations as Equations
import AISCSteel.ChapterFFlexure.F9: calc_MnY, calc_Lp, calc_Lr, calc_My, calc_Mcr
import AISCSteel.ChapterFFlexure.F9.PositiveBending: calc_B, calc_Mp, calc_MnLTB

function calc_variables(r_y, E, F_y, I_y, J, S_x, Z_x, d, L_b)
    L_p = calc_Lp(r_y, E, F_y)
    L_r = calc_Lr(E, F_y, I_y, J, S_x, d)
    M_y = calc_My(F_y, S_x)
    M_p = calc_Mp(F_y, Z_x, M_y)
    B = calc_B(d, L_b, I_y, J)
    M_cr = calc_Mcr(E, L_b, I_y, J, B)
    return (; L_p, L_r, M_p, M_y, M_cr)
end

function calc_MnFLB(M_p, F_y, S_xc, λ_f, λ_pf, λ_rf, λ_fclass, M_y, E, b_f, t_f)

    # 3. Flange Local Buckling
    if λ_fclass == :noncompact
        M_nFLB = Equations.EqF9▬14(M_p, F_y, S_xc, λ_f, λ_pf, λ_rf, M_y)
    elseif λ_fclass == :slender
        M_nFLB = Equations.EqF9▬15(E, S_xc, b_f, t_f)
    else
        M_nFLB = M_p
    end

    return M_p

end

function calc_Mn(r_y, E, F_y, I_y, J, S_x, Z_x, d, L_b, S_xc, λ_f, λ_pf, λ_rf, λ_fclass, b_f, t_f)

    (; L_p, L_r, M_p, M_y, M_cr) = calc_variables(r_y, E, F_y, I_y, J, S_x, Z_x, d, L_b)

    # 1. Yielding
    M_nY = calc_MnY(M_p)

    # 2. Lateral Torsional Buckling
    M_nLTB = calc_MnLTB(M_p, M_y, M_cr, L_b, L_p, L_r)

    # 3. Flange Local Buckling
    M_nFLB = calc_MnFLB(M_p, F_y, S_xc, λ_f, λ_pf, λ_rf, λ_fclass, M_y, E, b_f, t_f)

    M_n = min(M_nY, M_nLTB, M_nFLB)
end
end
