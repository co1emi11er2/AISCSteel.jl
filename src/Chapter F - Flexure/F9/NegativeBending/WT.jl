module WT
import AISCSteel.ChapterFFlexure.F9.Equations as Equations
import AISCSteel.ChapterFFlexure.F9: calc_MnY, calc_My, calc_Mcr
import AISCSteel.ChapterFFlexure.F9.NegativeBending: calc_B

calc_Mp(M_y) = M_p =  Equations.EqF9▬4(M_y)


function calc_Fcr(d, t_w, E, F_y)
    dtw_ratio = d/t_w
    limit_1 = 0.84*sqrt(E/F_y)
    limit_2 = 1.52*sqrt(E/F_y)
    F_cr = if dtw_ratio <= limit_1
        F_y
    elseif limit_1 < dtw_ratio <= limit_2
        Equations.EqF9▬18(d, t_w, F_y, E)
    else
        Equations.EqF9▬19(E, d, t_w)
    end

    return F_cr
end

function calc_variables(F_y, S_x, d, L_b, I_y, J, t_w, E)
    M_y = calc_My(F_y, S_x)
    M_p = calc_Mp(M_y)
    B = calc_B(d, L_b, I_y, J)
    M_cr = calc_Mcr(E, L_b, I_y, J, B)
    F_cr = calc_Fcr(d, t_w, E, F_y)
    return (; M_p, M_y, M_cr, F_cr)
end

function calc_MnLTB(M_cr, M_y)

    # 2. Lateral Torsional Buckling
    M_nLTB = min(M_cr, M_y)
end

function calc_MnLB(F_cr, S_x)

    # 4. Local Buckling of Tee Stems
    M_nLB = Equations.EqF9▬16(F_cr, S_x)
end

function calc_Mn(F_y, S_x, d, L_b, I_y, J, t_w, E)

    (; M_p, M_y, M_cr, F_cr) = calc_variables(F_y, S_x, d, L_b, I_y, J, t_w, E)

    # 1. Yielding
    M_nY = calc_MnY(M_p)

    # 2. Lateral Torsional Buckling
    M_nLTB = calc_MnLTB(M_cr, M_y)

    # 3. Local Buckling of Tee Stems
    M_nLB = calc_MnLB(F_cr, S_x)

    M_n = min(M_nY, M_nLTB, M_nLB)
end
end
