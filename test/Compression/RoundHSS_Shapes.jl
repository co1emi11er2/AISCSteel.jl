
using StructuralUnits
import AISCSteel.Shapes.RoundHSS_Shapes: RoundHSS_Shape
import AISCSteel.Shapes.RoundHSS_Shapes.Compression: calc_Pn

function test_compression(;hss_name, L_cx, L_cy, F_y=50ksi)
    w = RoundHSS_Shape(hss_name, F_y=F_y)
    ϕ_b = 0.9

    ϕP_n = calc_Pn(w, L_cx, L_cy) * ϕ_b
    ϕP_n = round(kip, ϕP_n, sigdigits=3)
end

##########################################################################################
# Design of members for compression
##########################################################################################

# AISC Table 4-5
let 
    hss_name = "HSS20.000x0.500"
    L_cx = L_cy = 0ft
    ϕP_n_expected = 1280 * kip # AISC Table 4-5
    ϕP_n = test_compression(hss_name=hss_name, L_cx=L_cx, L_cy=L_cy)

    @test ϕP_n_expected == ϕP_n
    
    L_cx = L_cy = 18ft
    ϕP_n_expected = 1190 * kip # AISC Table 4-5
    ϕP_n = test_compression(hss_name=hss_name, L_cx=L_cx, L_cy=L_cy)

    @test ϕP_n_expected == ϕP_n

    L_cx = L_cy = 40ft
    ϕP_n_expected = 901 * kip # AISC Table 4-5
    ϕP_n = test_compression(hss_name=hss_name, L_cx=L_cx, L_cy=L_cy)

    @test ϕP_n_expected == ϕP_n
end

let 
    hss_name = "HSS20.000x0.250"
    L_cx = L_cy = 0ft
    ϕP_n_expected = 598 * kip
    ϕP_n = test_compression(hss_name=hss_name, L_cx=L_cx, L_cy=L_cy)

    @test ϕP_n_expected == ϕP_n
    
    L_cx = L_cy = 18ft
    ϕP_n_expected = 558 * kip
    ϕP_n = test_compression(hss_name=hss_name, L_cx=L_cx, L_cy=L_cy)

    @test ϕP_n_expected == ϕP_n

    L_cx = L_cy = 40ft
    ϕP_n_expected = 424 * kip
    ϕP_n = test_compression(hss_name=hss_name, L_cx=L_cx, L_cy=L_cy)

    @test ϕP_n_expected == ϕP_n
end
