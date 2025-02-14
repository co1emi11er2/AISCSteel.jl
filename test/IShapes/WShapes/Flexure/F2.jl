using StructuralUnits
test_major_flexure = Flexure.test_major_flexure
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