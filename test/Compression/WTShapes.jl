using StructuralUnits
import AISCSteel.Shapes.WTShapes: WTShape
import AISCSteel.Shapes.WTShapes.Compression: calc_Pn

function test_compression(;w_name, L_cx, L_cy, L_cz, F_y=50ksi)
    wt = WTShape(w_name, F_y=F_y)
    ϕ_b = 0.9

    ϕP_n = calc_Pn(wt, L_cx, L_cy, L_cz) * ϕ_b
    ϕP_n = round(kip, ϕP_n, sigdigits=3)
end
##########################################################################################
# Design of members for compression
##########################################################################################

# AISC Example E.7
let 
    w_name = "wt7x34"
    L_cx = L_cy = L_cz = 20ft
    ϕP_n_expected = 128 * kip # AISC Example E.1A
    ϕP_n = test_compression(w_name=w_name, L_cx=L_cx, L_cy=L_cy, L_cz=L_cz)

    @test ϕP_n_expected == ϕP_n
    
end

# AISC Example E.8
let 
    w_name = "wt7x15"
    L_cx = L_cy = L_cz = 20ft
    ϕP_n_expected = 36.6 * kip # AISC Example E.1A
    ϕP_n = test_compression(w_name=w_name, L_cx=L_cx, L_cy=L_cy, L_cz=L_cz)

    @test ϕP_n_expected == ϕP_n
    
end