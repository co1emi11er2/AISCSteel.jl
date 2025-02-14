using StructuralUnits
test_minor_flexure = Flexure.test_minor_flexure
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