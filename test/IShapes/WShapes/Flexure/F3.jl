using StructuralUnits
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