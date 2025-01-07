module NegativeBending
import AISCSteel.ChapterFFlexure.F9.Equations as Equations


calc_Mp_angles(M_y) = M_p =  Equations.EqF9▬5(M_y)
calc_B(d, L_b, I_y, J) = B = Equations.EqF9▬12(d, L_b, I_y, J)

# include WT specific functions
include("WT.jl")

# include double angle specific functions
include("DoubleAngles.jl")

        

function calc_Fcr_angles()

    # 2. Lateral Torsional Buckling
    F_cr = error("not implemented")
end



function calc_MnLTB_angles(M_cr, M_y)

    # 2. Lateral Torsional Buckling
    M_nLTB = error("not implemented")
end
end


        
