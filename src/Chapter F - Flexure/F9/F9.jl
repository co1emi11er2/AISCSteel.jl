module F9

# include equations
include("Equations.jl")

##########################################################################################
# Equations below are the public API for F9
##########################################################################################
calc_Lp(r_y, E, F_y) = L_p = Equations.EqF9▬8(r_y, E, F_y)
calc_Lr(E, F_y, I_y, J, S_x, d) = L_r = Equations.EqF9▬9(E, F_y, I_y, J, S_x, d)
calc_Mcr(E, L_b, I_y, J, B) = M_cr = Equations.EqF9▬10(E, L_b, I_y, J, B)
calc_My(F_y, S_x) = M_p =  Equations.EqF9▬3(F_y, S_x)

calc_MnY(M_p) = M_nY = M_p

# include API for positive bending
include("PositiveBending/PositiveBending.jl")

# include API for negative bending
include("NegativeBending/NegativeBending.jl")





end # module
