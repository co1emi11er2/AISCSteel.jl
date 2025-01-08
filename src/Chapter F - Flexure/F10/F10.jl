module F10

# include equations
include("Equations.jl")

##########################################################################################
# Equations below are the public API for F10
##########################################################################################
function calc_Mcr(E, A_g, r_z, t, C_b, L_b, B_w)
    C_b = max(C_b, 1.5)
    M_cr = Equations.EqF10▬4(E, A_g, r_z, t, C_b, L_b, B_w)
end

calc_MnY(M_y) = M_nY = Equations.EqF10▬1(M_y)

function calc_MnLTB(M_y, M_cr)
    M_nLTB = if M_y/M_cr <= 1.0
        Equations.EqF10▬2(M_y, M_cr)
    else
        Equations.EqF10▬3(M_cr, M_y)
    end
end


include("PrincipalAxisBending/PrincipalAxisBending.jl")
include("GeometricAxisBending/GeometricAxisBending.jl")

end # module