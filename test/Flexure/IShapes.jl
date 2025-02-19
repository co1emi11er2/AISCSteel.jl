using StructuralUnits
import AISCSteel.Shapes.IShapes.RolledIShapes: WShape
import AISCSteel.Shapes.IShapes.RolledIShapes.Flexure: calc_Mnx, calc_Mny

function test_major_flexure(;w_name, L_b, F_y=50ksi)
    w = WShape(w_name, F_y=F_y)
    ϕ_b = 0.9

    ϕM_n = calc_Mnx(w, L_b) * ϕ_b
    ϕM_n = round(kip*ft, ϕM_n, sigdigits=3)
end

function test_minor_flexure(;w_name, F_y=50ksi)
    w = WShape(w_name, F_y=F_y)
    ϕ_b = 0.9

    ϕM_n = calc_Mny(w) * ϕ_b
    ϕM_n = round(kip*ft, ϕM_n, sigdigits=3)
end

##########################################################################################
# Design of members for flexure - Section F2
##########################################################################################

# check W10x15
let 
    w_name = "w10x15"
    # L_b <= L_p at 0 ft
    L_b=0ft
    ϕM_n_expected = 60.0 * kip*ft # AISC Table 6-2
    ϕM_n = test_major_flexure(w_name=w_name, L_b=L_b)

    @test ϕM_n_expected == ϕM_n

    # L_p < L_b <= L_r at 6 ft
    L_b=6ft
    ϕM_n_expected = 47.0 * kip*ft # AISC Table 6-2
    ϕM_n = test_major_flexure(w_name=w_name, L_b=L_b)

    @test ϕM_n_expected == ϕM_n

    # L_b > L_r at 20 ft
    L_b=20ft
    ϕM_n_expected = 11.0 * kip*ft # AISC Table 6-2
    ϕM_n = test_major_flexure(w_name=w_name, L_b=L_b)

    @test ϕM_n_expected == ϕM_n
    
end

##########################################################################################
# Design of members for flexure - Section F3
##########################################################################################

# check W10x12
let 
    w_name = "w10x12"
    # L_b <= L_p at 0 ft
    L_b=0ft
    ϕM_n_expected = 46.9 * kip*ft # AISC Table 6-2
    ϕM_n = test_major_flexure(w_name=w_name, L_b=L_b)

    @test ϕM_n_expected == ϕM_n

    # L_p < L_b <= L_r at 6 ft
    L_b=6ft
    ϕM_n_expected = 35.9 * kip*ft # AISC Table 6-2
    ϕM_n = test_major_flexure(w_name=w_name, L_b=L_b)

    @test ϕM_n_expected == ϕM_n

    # L_b > L_r at 20 ft
    L_b=20ft
    ϕM_n_expected = 7.25 * kip*ft # AISC Table 6-2
    ϕM_n = test_major_flexure(w_name=w_name, L_b=L_b)

    @test ϕM_n_expected == ϕM_n
    
end

##########################################################################################
# Design of members for flexure - Section F4 (this is not a realistic check)
##########################################################################################

# check W10x12
let 
    w_name = "w10x12"
    # L_b <= L_p at 0 ft
    L_b=0ft
    ϕM_n_expected = 132.0 * kip*ft # AISC Table 6-2
    ϕM_n = test_major_flexure(w_name=w_name, L_b=L_b, F_y=200ksi)

    @test ϕM_n_expected == ϕM_n

    # L_p < L_b <= L_r at 6 ft
    L_b=3ft
    ϕM_n_expected = 128.0 * kip*ft # AISC Table 6-2
   ϕM_n = test_major_flexure(w_name=w_name, L_b=L_b, F_y=200ksi)

    @test ϕM_n_expected == ϕM_n

    # L_b > L_r at 20 ft
    L_b=5ft
    ϕM_n_expected = 63.5 * kip*ft # AISC Table 6-2
    ϕM_n = test_major_flexure(w_name=w_name, L_b=L_b, F_y=200ksi)

    @test ϕM_n_expected == ϕM_n
    
end

##########################################################################################
# Design of members for flexure - Section F5 (this is not a realistic check)
##########################################################################################

# check W10x12
let 
    w_name = "w10x12"
    # L_b <= L_p at 0 ft
    L_b=0ft
    ϕM_n_expected = 140.0 * kip*ft # AISC Table 6-2
    ϕM_n = test_major_flexure(w_name=w_name, L_b=L_b, F_y=500ksi)

    @test ϕM_n_expected == ϕM_n

    # L_p < L_b <= L_r at 6 ft
    L_b=2ft
    ϕM_n_expected = 140.0 * kip*ft # AISC Table 6-2
   ϕM_n = test_major_flexure(w_name=w_name, L_b=L_b, F_y=500ksi)

    @test ϕM_n_expected == ϕM_n

    # L_b > L_r at 20 ft
    L_b=5ft
    ϕM_n_expected = 63.3 * kip*ft # AISC Table 6-2
    ϕM_n = test_major_flexure(w_name=w_name, L_b=L_b, F_y=500ksi)

    @test ϕM_n_expected == ϕM_n
    
end

##########################################################################################
# Design of members for flexure - Section F6
##########################################################################################

# check W12X58 - AISC V16 Design Example F.5
let
    w_name = "w12x58"
    ϕM_n_expected = 122 * kip*ft
    ϕM_n = test_minor_flexure(w_name=w_name)

    @test ϕM_n_expected == ϕM_n
    
end

# check W44X335 Table 6-2
let
    w_name = "w44x335"
    ϕM_n_expected = 885 * kip*ft
    ϕM_n = test_minor_flexure(w_name=w_name)

    @test ϕM_n_expected == ϕM_n
    
end

# check W24X162 Table 6-2
let
    w_name = "W24X162"
    ϕM_n_expected = 394 * kip*ft
    ϕM_n = test_minor_flexure(w_name=w_name)

    @test ϕM_n_expected == ϕM_n
    
end
