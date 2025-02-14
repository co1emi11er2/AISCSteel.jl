##########################################################################################
# Design of members for flexure - Section F2
##########################################################################################

# check C10x30
let 
    c_name = "c10x30"
    # L_b <= L_p at 0 ft
    L_b=0ft
    ϕM_n_expected = 100 * kip*ft # AISC Table 3-11
    ϕM_n = test_major_flexure(c_name=c_name, L_b=L_b)

    @test ϕM_n_expected == ϕM_n

    # L_p < L_b <= L_r at 6 ft
    L_b=6ft
    ϕM_n_expected = 86.5 * kip*ft # AISC Table 3-11
    ϕM_n = test_major_flexure(c_name=c_name, L_b=L_b)

    @test ϕM_n_expected == ϕM_n

    # L_b > L_r at 20 ft
    L_b=20ft
    ϕM_n_expected = 39.2 * kip*ft # AISC Table 3-11
    ϕM_n = test_major_flexure(c_name=c_name, L_b=L_b)

    @test ϕM_n_expected == ϕM_n
    
end

# check MC10x30
let 
    c_name = "mc12x40"
    # L_b <= L_p at 0 ft
    L_b=0ft
    ϕM_n_expected = 179 * kip*ft # AISC Table 3-11
    ϕM_n = test_major_flexure(c_name=c_name, L_b=L_b)

    @test ϕM_n_expected == ϕM_n

    # L_p < L_b <= L_r at 6 ft
    L_b=6ft
    ϕM_n_expected = 167 * kip*ft # AISC Table 3-11
    ϕM_n = test_major_flexure(c_name=c_name, L_b=L_b)

    @test ϕM_n_expected == ϕM_n

    # L_b > L_r at 20 ft
    L_b=20ft
    ϕM_n_expected = 90.2 * kip*ft # AISC Table 3-11
    ϕM_n = test_major_flexure(c_name=c_name, L_b=L_b)

    @test ϕM_n_expected == ϕM_n
    
end