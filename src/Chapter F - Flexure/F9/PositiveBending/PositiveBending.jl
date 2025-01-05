module PositiveBending
import AISCSteel.ChapterFFlexure.F9.Equations as Equations


calc_Mp(F_y, Z_x, M_y) = M_p =  Equations.EqF9▬2(F_y, Z_x, M_y)
calc_B(d, L_b, I_y, J) = B = Equations.EqF9▬11(d, L_b, I_y, J)


function calc_MnLTB(M_p, M_y, M_cr, L_b, L_p, L_r)

    # 2. Lateral Torsional Buckling
    M_nLTB = if L_b <= L_p
        M_p
    elseif L_p < L_b <= L_r
        Equations.EqF9▬6(M_p, M_y, L_b, L_p, L_r)
    else
        Equations.EqF9▬7(M_cr)
    end
end

# include WT specific functions
include("WT.jl")

# include double angle specific functions
include("DoubleAngles.jl")




end
