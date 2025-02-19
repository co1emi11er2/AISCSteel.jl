module Flexure
using  Test
using StructuralUnits
import AISCSteel.Shapes.WTShapes: WTShape
import AISCSteel.Shapes.WTShapes.Flexure: calc_positive_Mnx


function test_positive_flexure(;wt_name, L_b, F_y=50ksi)
    if startswith(wt_name, "w")
        c = WTShape(wt_name, F_y=F_y)
    else
        nothing
    end
    ϕ_b = 0.9

    ϕM_n = calc_positive_Mnx(c, L_b) * ϕ_b
    ϕM_n = round(kip*ft, ϕM_n, sigdigits=3)
end

# Extend F9 functions
@testset verbose = true "F9" begin
    include("F9.jl")
end

end