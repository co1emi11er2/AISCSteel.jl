
using StructuralUnits
import AISCSteel.Shapes.HSS_Shapes: HSS_Shape
import AISCSteel.Shapes.HSS_Shapes.Compression: calc_Pn

function test_compression(;hss_name, L_cx, L_cy, F_y=50ksi)
    w = HSS_Shape(hss_name, F_y=F_y)
    ϕ_b = 0.9

    ϕP_n = calc_Pn(w, L_cx, L_cy) * ϕ_b
    ϕP_n = round(kip, ϕP_n, sigdigits=3)
end

##########################################################################################
# Design of members for compression
##########################################################################################

# AISC Example E.9
let 
    hss_name = "HSS12x10x3/8"
    L_cx = L_cy = 16ft
    ϕP_n_expected = 556 * kip # AISC Example E.9
    ϕP_n = test_compression(hss_name=hss_name, L_cx=L_cx, L_cy=L_cy)

    @test ϕP_n_expected == ϕP_n
    
end

# AISC Example E.10
let 
    hss_name = "HSS12x8x3/16"
    L_cx = L_cy = 24ft
    ϕP_n_expected = 151 * kip # AISC Example E.10
    ϕP_n = test_compression(hss_name=hss_name, L_cx=L_cx, L_cy=L_cy)

    @test ϕP_n_expected == ϕP_n
    
    
    L_cx = L_cy = 18ft
    ϕP_n_expected = 178 * kip # AISC Example E.10
    ϕP_n = test_compression(hss_name=hss_name, L_cx=L_cx, L_cy=L_cy)

    @test ϕP_n_expected == ϕP_n
    
    
    L_cx = L_cy = 40ft
    ϕP_n_expected = 74.4 * kip # AISC Example E.10
    ϕP_n = test_compression(hss_name=hss_name, L_cx=L_cx, L_cy=L_cy)

    @test ϕP_n_expected == ϕP_n
    
end

# AISC Table 4-3
let 
    hss_name = "HSS12x6x3/16"
    L_cx = L_cy = 0ft
    ϕP_n_expected = 202 * kip # AISC Table 4-3
    ϕP_n = test_compression(hss_name=hss_name, L_cx=L_cx, L_cy=L_cy)

    @test ϕP_n_expected == ϕP_n
   
    
    L_cx = L_cy = 15ft
    ϕP_n_expected = 153 * kip # AISC Table 4-3
    ϕP_n = test_compression(hss_name=hss_name, L_cx=L_cx, L_cy=L_cy)

    @test ϕP_n_expected == ϕP_n
    
    
    L_cx = L_cy = 40ft
    ϕP_n_expected = 39.2 * kip # AISC Table 4-3
    ϕP_n = test_compression(hss_name=hss_name, L_cx=L_cx, L_cy=L_cy)

    @test ϕP_n_expected == ϕP_n
    
end

