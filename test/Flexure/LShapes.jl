using StructuralUnits
import AISCSteel.Shapes.LShapes: LShape
import AISCSteel.Shapes.LShapes.Flexure: classify_leg
import AISCSteel.Shapes.LShapes.Flexure: calc_positive_Mnx, calc_positive_Mny, calc_negative_Mnx, calc_negative_Mny
import AISCSteel.Shapes.LShapes.Flexure: calc_positive_Mnw, calc_negative_Mnw, calc_positive_Mnz, calc_negative_Mnz

function test_positive_flexure_Mnx(;l_name, L_b, restraint_type, C_b, F_y=50ksi)
    
    l = LShape(l_name, F_y=F_y)
    ϕ_b = 0.9

    ϕM_n = calc_positive_Mnx(l, L_b, restraint_type, C_b) * ϕ_b
    ϕM_n = round(kip*ft, ϕM_n, sigdigits=3)
end

function test_positive_flexure_Mny(;l_name, L_b, restraint_type, C_b, F_y=50ksi)
    
    l = LShape(l_name, F_y=F_y)
    ϕ_b = 0.9

    ϕM_n = calc_positive_Mny(l, L_b, restraint_type, C_b) * ϕ_b
    ϕM_n = round(kip*ft, ϕM_n, sigdigits=3)
end

function test_negative_flexure_Mnx(;l_name, L_b, restraint_type, C_b, F_y=50ksi)
    
    l = LShape(l_name, F_y=F_y)
    ϕ_b = 0.9

    ϕM_n = calc_negative_Mnx(l, L_b, restraint_type, C_b) * ϕ_b
    ϕM_n = round(kip*ft, ϕM_n, sigdigits=3)
end

function test_negative_flexure_Mny(;l_name, L_b, restraint_type, C_b, F_y=50ksi)
    
    l = LShape(l_name, F_y=F_y)
    ϕ_b = 0.9

    ϕM_n = calc_negative_Mny(l, L_b, restraint_type, C_b) * ϕ_b
    ϕM_n = round(kip*ft, ϕM_n, sigdigits=3)
end

function test_positive_flexure_Mnz(;l_name, F_y=50ksi)
    
    l = LShape(l_name, F_y=F_y)
    ϕ_b = 0.9

    ϕM_n = calc_positive_Mnz(l) * ϕ_b
    ϕM_n = round(kip*ft, ϕM_n, sigdigits=3)
end

function test_negative_flexure_Mnz(;l_name, F_y=50ksi)
    
    l = LShape(l_name, F_y=F_y)
    ϕ_b = 0.9

    ϕM_n = calc_negative_Mnz(l) * ϕ_b
    ϕM_n = round(kip*ft, ϕM_n, sigdigits=3)
end

function test_positive_flexure_Mnw(;l_name, L_b, C_b=1, F_y=50ksi)
    
    l = LShape(l_name, F_y=F_y)
    ϕ_b = 0.9

    ϕM_n = calc_positive_Mnw(l, L_b, C_b) * ϕ_b
    ϕM_n = round(kip*ft, ϕM_n, sigdigits=3)
end

function test_negative_flexure_Mnw(;l_name, L_b, C_b=1, F_y=50ksi)
    
    l = LShape(l_name, F_y=F_y)
    ϕ_b = 0.9

    ϕM_n = calc_negative_Mnw(l, L_b, C_b) * ϕ_b
    ϕM_n = round(kip*ft, ϕM_n, sigdigits=3)
end

##########################################################################################
# Design of members for flexure - Section F10
##########################################################################################

# check L4X4X1/4 Example F11.A in AISC v16 design example
let 
    l_name = "l4x4x1/4"
    L_b=6ft
    C_b = 1.14

    # M_nx
    ϕM_n_expected = 3.69 * kip*ft
    ϕM_n = test_positive_flexure_Mnx(l_name=l_name, L_b=L_b, restraint_type=:unrestrained, C_b=C_b)
    @test ϕM_n_expected == ϕM_n

    # M_ny
    ϕM_n_expected = 3.69 * kip*ft
    ϕM_n = test_positive_flexure_Mny(l_name=l_name, L_b=L_b, restraint_type=:unrestrained, C_b=C_b)
    @test ϕM_n_expected == ϕM_n
    
end

# check L4X4X1/4 Example F11.B in AISC v16 design example
let 
    l_name = "l4x4x1/4"
    L_b=6ft
    C_b = 1.14

    # M_nx
    ϕM_n_expected = 3.98 * kip*ft
    ϕM_n = test_positive_flexure_Mnx(l_name=l_name, L_b=L_b, restraint_type=:at_max_moment_only, C_b=C_b)
    @test ϕM_n_expected == ϕM_n

    # M_ny
    ϕM_n_expected = 3.98 * kip*ft
    ϕM_n = test_positive_flexure_Mny(l_name=l_name, L_b=L_b, restraint_type=:at_max_moment_only, C_b=C_b)
    @test ϕM_n_expected == ϕM_n
    
end

# check L4X4X1/4 Example F11.C in AISC v16 design example
let 
    l_name = "l4x4x1/4"
    L_b=6ft
    C_b = 1.14

    # M_nz
    ϕM_n_expected = 4.38 * kip*ft
    ϕM_n = test_positive_flexure_Mnz(l_name=l_name)
    @test ϕM_n_expected == ϕM_n

    ϕM_n_expected = 4.13 * kip*ft
    ϕM_n = test_negative_flexure_Mnz(l_name=l_name)
    @test ϕM_n_expected == ϕM_n

    # M_nw
    ϕM_n_expected = 7.49 * kip*ft

    ϕM_n = test_positive_flexure_Mnw(l_name=l_name, L_b=L_b, C_b=C_b)
    @test ϕM_n_expected == ϕM_n

    ϕM_n = test_negative_flexure_Mnw(l_name=l_name, L_b=L_b, C_b=C_b)
    @test ϕM_n_expected == ϕM_n
    
end
