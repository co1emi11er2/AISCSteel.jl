module F9

# include equations
include("Equations.jl")

##########################################################################################
# Equations below are the public API for F9
##########################################################################################
calc_Lp(r_y, E, F_y) = L_p = Equations.EqF9▬8(r_y, E, F_y)
calc_Lr(E, F_y, I_y, J, S_x, d) = L_r = Equations.EqF9▬9(E, F_y, I_y, J, S_x, d)
calc_Mcr(E, L_b, I_y, J, B) = M_cr = Equations.EqF9▬10(E, L_b, I_y, J, B)

calc_MnY(M_p) = M_nY = M_p

module PositiveBending
import AISCSteel.ChapterFFlexure.F9.Equations as Equations
calc_positive_My(F_y, S_x) = M_p =  Equations.EqF9▬3(F_y, S_x)
calc_positive_Mp(F_y, Z_x, M_y) = M_p =  Equations.EqF9▬2(F_y, Z_x, M_y)
calc_positive_B(d, L_b, I_y, J) = B = Equations.EqF9▬11(d, L_b, I_y, J)

function calc_positive_MnLTB(M_p, M_y, M_cr, L_b, L_p, L_r)

    # 2. Lateral Torsional Buckling
    M_nLTB = if L_b <= L_p
        M_p
    elseif L_p < L_b <= L_r
        Equations.EqF9▬6(M_p, M_y, L_b, L_p, L_r)
    else
        Equations.EqF9▬7(M_cr)
    end
end

function calc_positive_MnFLB(M_p, F_y, S_xc, λ_f, λ_pf, λ_rf, M_y)

    # 3. Flange Local Buckling
    M_nFLB =  if λ_fclass == :noncompact
                    Equations.EqF9▬14(M_p, F_y, S_xc, λ_f, λ_pf, λ_rf, M_y)
                elseif λ_fclass == :slender
                    Equations.EqF9▬15(E, S_xc, b_f, t_f)
                else
                    M_p
                end

end
end


module NegativeBending
import AISCSteel.ChapterFFlexure.F9.Equations as Equations
calc_negative_Mp_WT(M_y) = M_p =  Equations.EqF9▬4(M_y)
calc_negative_Mp_angles(M_y) = M_p =  Equations.EqF9▬5(M_y)
calc_negative_B(d, L_b, I_y, J) = B = Equations.EqF9▬12(d, L_b, I_y, J)
function calc_negative_MnLTB_WT(M_cr, M_y)

    # 2. Lateral Torsional Buckling
    M_nLTB = min(M_cr, M_y)
end

function calc_negative_MnLTB_angles(M_cr, M_y)

    # 2. Lateral Torsional Buckling
    M_nLTB = error("not implemented")
end
function calc_nagative_MnLB_WT(F_cr, S_x)

    # 4. Local Buckling of Tee Stems
    M_n = Equations.EqF9▬16(F_cr, S_x)
end
end

function calc_Fcr_WT(d, t_w, E, F_y)
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

function calc_Fcr_angles()

    # 2. Lateral Torsional Buckling
    F_cr = error("not implemented")
end

end # module
