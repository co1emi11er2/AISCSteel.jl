using StructuralUnits
import AISCSteel.Shapes.LShapes: LShape
import AISCSteel.Shapes.LShapes.Flexure: classify_leg
import AISCSteel.Shapes.LShapes.Flexure.F10.PrincipalAxisBending.MajorAxis.PositiveBending: calc_positive_Mnw
import AISCSteel.Shapes.LShapes.Flexure.F10.PrincipalAxisBending.MajorAxis.NegativeBending: calc_negative_Mnw

function test_positive_flexure(;l_name, L_b, C_b=1, F_y=50ksi)
    
    l = LShape(l_name, F_y=F_y)
    _..., λ_class = classify_leg(l)
    ϕ_b = 0.9

    ϕM_n = calc_positive_Mnw(l, λ_class, L_b, C_b) * ϕ_b
    ϕM_n = round(kip*ft, ϕM_n, sigdigits=3)
end

function test_negative_flexure(;l_name, L_b, C_b=1, F_y=50ksi)
    
    l = LShape(l_name, F_y=F_y)
    _..., λ_class = classify_leg(l)
    ϕ_b = 0.9

    ϕM_n = calc_negative_Mnw(l, λ_class, L_b, C_b) * ϕ_b
    ϕM_n = round(kip*ft, ϕM_n, sigdigits=3)
end

##########################################################################################
# Design of members for flexure - Section F2
##########################################################################################

# check L4X4X1/4 Example F11 in AISC v16 design example
let 
    l_name = "l4x4x1/4"
    L_b=6ft
    C_b = 1.14
    ϕM_n_expected = 7.49 * kip*ft

    ϕM_n = test_positive_flexure(l_name=l_name, L_b=L_b, C_b=C_b)
    @test ϕM_n_expected == ϕM_n

    ϕM_n = test_negative_flexure(l_name=l_name, L_b=L_b, C_b=C_b)
    @test ϕM_n_expected == ϕM_n
    
end
