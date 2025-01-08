module PrincipalAxisBending

function calc_Mcr(E, A_g, r_z, t, C_b, L_b, B_w)
    C_b = max(C_b, 1.5)
    M_cr = Equations.EqF10▬4(E, A_g, r_z, t, C_b, L_b, B_w)
end

# include Positive Bending
include("PositiveBending.jl")

# include Negative Bending
include("NegativeBending.jl")

end