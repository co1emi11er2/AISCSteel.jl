using StructuralUnits
import AISCSteel.Shapes.HSS_Shapes: HSS_Shape
import AISCSteel.Shapes.HSS_Shapes.Flexure: calc_Mnx, calc_Mny

function test_major_flexure(;hss_name, L_b, F_y=50ksi, C_b=1)
    hss = HSS_Shape(hss_name, F_y=F_y)
    ϕ_b = 0.9

    ϕM_n = calc_Mnx(hss, L_b, C_b) * ϕ_b
    ϕM_n = round(kip*ft, ϕM_n, sigdigits=3)
end

function test_minor_flexure(;hss_name, F_y=50ksi)
    hss = HSS_Shape(hss_name, F_y=F_y)
    ϕ_b = 0.9

    ϕM_n = calc_Mny(hss) * ϕ_b
    ϕM_n = round(kip*ft, ϕM_n, sigdigits=3)
end

##########################################################################################
# Design of members for flexure - Section F7
##########################################################################################

# check HSS8x8x3/16
let 
    hss_name = "HSS3-1/2X3-1/2X1/8"
    # L_b <= L_p at 0 ft
    L_b=0ft
    ϕM_n_expected = 7.21 * kip*ft # Example F6 in AISC v16 design example
    ϕM_n = test_major_flexure(hss_name=hss_name, L_b=L_b, C_b=1.0)

    @test ϕM_n_expected == ϕM_n
    
end

# check HSS8x8x3/16
let 
    hss_name = "HSS10x6x3/16"
    # L_b <= L_p at 0 ft
    L_b=21ft
    ϕM_n_expected = 59.7 * kip*ft # Example F7.B in AISC v16 design example
    ϕM_n = test_major_flexure(hss_name=hss_name, L_b=L_b, C_b=1.14)

    @test ϕM_n_expected == ϕM_n
    
end


# check HSS8x8x3/16
let 
    hss_name = "HSS8x8x3/16"

    ϕM_n_expected = 45.3 * kip*ft # Example F8.B in AISC v16 design example
    ϕM_n = test_minor_flexure(hss_name=hss_name)

    @test ϕM_n_expected == ϕM_n
    
end

