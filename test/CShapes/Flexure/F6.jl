##########################################################################################
# Design of members for flexure - Section F2
##########################################################################################

# check C10x30
let 
    c_name = "c10x30"

    ϕM_n_expected = 9.9 * kip*ft 
    ϕM_n = test_minor_flexure(c_name=c_name)

    @test ϕM_n_expected == ϕM_n
    
end

# check MC10x30
let 
    c_name = "mc12x40"

    ϕM_n_expected = 29.9 * kip*ft 
    ϕM_n = test_minor_flexure(c_name=c_name)

    @test ϕM_n_expected == ϕM_n
    
end