module F10

import AISCSteel.Utils.UnitConversions as cnv

# include equations
include("Equations.jl")

##########################################################################################
# Equations below are the public API for F10
##########################################################################################


calc_MnY(M_y) = M_nY = Equations.EqF10▬1(M_y)

function calc_MnLTB(M_y, M_cr)
    if M_y/M_cr <= 1.0
        M_nLTB = Equations.EqF10▬2(M_y, M_cr)
    else
        M_nLTB = Equations.EqF10▬3(M_cr, M_y)
    end

    return M_nLTB
end

function calc_MnLLB(λ_class, M_y, F_y, S_c, b, t, E, F_cr)
    
    if λ_class == :compact
        M_nLLB = Equations.EqF10▬1(M_y)
    elseif λ_class == :noncompact
        M_nLLB = Equations.EqF10▬6(F_y, S_c, b, t, E)
    else
        M_nLLB = Equations.EqF10▬7(F_cr, S_c)
    end

    return M_nLLB
end

function calc_Fcr(E, b, t)
    F_cr = Equations.EqF10▬8(E, b, t)
end

function calc_My(F_y, S_min)
    M_y = F_y * S_min |> cnv.to_moment # no code reference
end


include("PrincipalAxisBending/PrincipalAxisBending.jl")
include("GeometricAxisBending/GeometricAxisBending.jl")

end # module