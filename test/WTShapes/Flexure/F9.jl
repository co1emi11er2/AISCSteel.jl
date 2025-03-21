##########################################################################################
# Design of members for flexure - Section F2
##########################################################################################

# check WT5x6
let 
    wt_name = "wt5x6"
    # L_b <= L_p at 0 ft
    L_b=0ft
    ϕM_n_expected = 7.32 * kip*ft # Example F10 in AISC v16 design example
    ϕM_n = test_positive_flexure(wt_name=wt_name, L_b=L_b)

    @test ϕM_n_expected == ϕM_n

    # L_p < L_b <= L_r at 6 ft
    L_b=6ft
    ϕM_n_expected = 6.75 * kip*ft # TODO: add real check
    ϕM_n = test_positive_flexure(wt_name=wt_name, L_b=L_b)

    @test ϕM_n_expected == ϕM_n

    # L_b > L_r at 20 ft
    L_b=20ft
    ϕM_n_expected = 4.09 * kip*ft # TODO: add real check
    ϕM_n = test_positive_flexure(wt_name=wt_name, L_b=L_b)

    @test ϕM_n_expected == ϕM_n
    
end