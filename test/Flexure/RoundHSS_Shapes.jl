using StructuralUnits
import AISCSteel.Shapes.RoundHSS_Shapes: RoundHSS_Shape
import AISCSteel.Shapes.RoundHSS_Shapes.Flexure: calc_Mn


function test_flexure(;hss_name, F_y=50ksi)
    hss = RoundHSS_Shape(hss_name, F_y=F_y)
    ϕ_b = 0.9

    ϕM_n = calc_Mn(hss) * ϕ_b
    ϕM_n = round(kip*ft, ϕM_n, sigdigits=3)
end

##########################################################################################
# Design of members for flexure - Section F8
##########################################################################################

# check HSS20.000X0.500
let 
    # compact wall
    hss_name = "HSS20.000x0.500"


    ϕM_n_expected = 611 * kip*ft # AISC Table 3-14
    ϕM_n = test_flexure(hss_name=hss_name, F_y=46ksi)

    @test ϕM_n_expected == ϕM_n
    
end

# check HSS20.000X0.375
let 
    # non-compact wall
    hss_name = "HSS20.000x0.375"


    ϕM_n_expected = 442 * kip*ft # AISC Table 3-14
    ϕM_n = test_flexure(hss_name=hss_name, F_y=46ksi)

    @test ϕM_n_expected == ϕM_n
    
end
