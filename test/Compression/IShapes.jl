using StructuralUnits
import AISCSteel.Shapes.IShapes.RolledIShapes: WShape, HPShape
import AISCSteel.Shapes.IShapes.RolledIShapes.Compression: calc_Pn

function test_compression(;w_name, L_cx, L_cy, F_y=50ksi)
    w = WShape(w_name, F_y=F_y)
    ϕ_b = 0.9

    ϕP_n = calc_Pn(w, L_cx, L_cy) * ϕ_b
    ϕP_n = round(kip, ϕP_n, sigdigits=3)
end

function test_compression_HP(;w_name, L_cx, L_cy, F_y=50ksi)
    w = HPShape(w_name, F_y=F_y)
    ϕ_b = 0.9

    ϕP_n = calc_Pn(w, L_cx, L_cy) * ϕ_b
    ϕP_n = round(kip, ϕP_n, sigdigits=3)
end
##########################################################################################
# Design of members for compression
##########################################################################################

# AISC Example E.1A
let 
    w_name = "w14x132"
    L_cx = L_cy = 30ft
    ϕP_n_expected = 893 * kip # AISC Example E.1A
    ϕP_n = test_compression(w_name=w_name, L_cx=L_cx, L_cy=L_cy)

    @test ϕP_n_expected == ϕP_n
    
end

# AISC Example E.1D
let 
    w_name = "w14x90"
    L_cx = 30ft
    L_cy = 15ft
    ϕP_n_expected = 927 * kip # AISC Example E.1D
    ϕP_n = test_compression(w_name=w_name, L_cx=L_cx, L_cy=L_cy)

    @test ϕP_n_expected == ϕP_n
    
end

# AISC Example E.1E
let 
    # part a
    w_name = "w16x31"
    L_cx = L_cy = 5ft
    ϕP_n_expected = 313 * kip # AISC Example E.1E
    ϕP_n = test_compression(w_name=w_name, L_cx=L_cx, L_cy=L_cy)

    @test ϕP_n_expected == ϕP_n

    # part b
    L_cx = L_cy = 10ft
    ϕP_n_expected = 190 * kip # AISC Example E.1E
    ϕP_n = test_compression(w_name=w_name, L_cx=L_cx, L_cy=L_cy)

    @test ϕP_n_expected == ϕP_n

    # part c
    L_cx = L_cy = 15ft
    ϕP_n_expected = 87.1 * kip # AISC Example E.1E
    ϕP_n = test_compression(w_name=w_name, L_cx=L_cx, L_cy=L_cy)

    @test ϕP_n_expected == ϕP_n
    
end

# Table 4-1a (flange thickness greater than 2")
let 
    w_name = "w14x605"
    L_cx = L_cy = 0ft
    ϕP_n_expected = 8010 * kip # AISC Table 4-1a
    ϕP_n = test_compression(w_name=w_name, L_cx=L_cx, L_cy=L_cy)

    @test ϕP_n_expected == ϕP_n

    L_cx = L_cy = 11ft
    ϕP_n_expected = 7530 * kip # AISC Table 4-1a
    ϕP_n = test_compression(w_name=w_name, L_cx=L_cx, L_cy=L_cy)

    @test ϕP_n_expected == ϕP_n

    L_cx = L_cy = 22ft
    ϕP_n_expected = 6260 * kip # AISC Table 4-1a
    ϕP_n = test_compression(w_name=w_name, L_cx=L_cx, L_cy=L_cy)

    @test ϕP_n_expected == ϕP_n

    L_cx = L_cy = 42ft
    ϕP_n_expected = 3270 * kip # Table 4-1a
    ϕP_n = test_compression(w_name=w_name, L_cx=L_cx, L_cy=L_cy)

    @test ϕP_n_expected == ϕP_n
    
end

# Table 4-2 (flange is slender)
let 
    w_name = "HP16x88"
    L_cx = L_cy = 0ft
    ϕP_n_expected = 1130 * kip # AISC Table 4-2
    ϕP_n = test_compression_HP(w_name=w_name, L_cx=L_cx, L_cy=L_cy)

    @test ϕP_n_expected == ϕP_n

    L_cx = L_cy = 11ft
    ϕP_n_expected = 1050 * kip # AISC Table 4-2
    ϕP_n = test_compression_HP(w_name=w_name, L_cx=L_cx, L_cy=L_cy)

    @test ϕP_n_expected == ϕP_n

end