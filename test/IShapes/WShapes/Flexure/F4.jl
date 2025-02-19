using StructuralUnits
test_major_flexure = Flexure.test_major_flexure
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