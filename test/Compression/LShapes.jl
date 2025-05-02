using StructuralUnits
import AISCSteel.Shapes.LShapes: LShape
import AISCSteel.Shapes.LShapes.Compression: calc_Pn

function test_compression(;l_name, leg_connected, L, connection_type=:type_a , F_y=50ksi)
    lshape = LShape(l_name, F_y=F_y)
    ϕ_b = 0.9
    if connection_type == :type_a # make sure to test simpler function
        ϕP_n = calc_Pn(lshape, leg_connected, L) * ϕ_b
    else
        ϕP_n = calc_Pn(lshape, connection_type, leg_connected, L) * ϕ_b
    end
    ϕP_n = round(kip, ϕP_n, sigdigits=3)
end
##########################################################################################
# Design of members for compression
##########################################################################################

# AISC Example E.14A
let 
    l_name = "l5x3x1/2"
    L= 5ft
    ϕP_n_expected = 52.8 * kip # AISC Example E.14A
    ϕP_n = test_compression(l_name=l_name, leg_connected=:long, L=L)

    @test ϕP_n_expected == ϕP_n


    ϕP_n_expected = 60.6 * kip # Assume type_b connection
    ϕP_n = test_compression(l_name=l_name, connection_type=:type_b, leg_connected=:long, L=L)

    @test ϕP_n_expected == ϕP_n

    
    ϕP_n_expected = 72.4 * kip # short leg
    ϕP_n = test_compression(l_name=l_name, leg_connected=:short, L=L)

    @test ϕP_n_expected == ϕP_n


    ϕP_n_expected = 80.0 * kip # Assume type_b connection
    ϕP_n = test_compression(l_name=l_name, connection_type=:type_b, leg_connected=:short, L=L)

    @test ϕP_n_expected == ϕP_n
    
    
    L= 10ft
    ϕP_n_expected = 18.5 * kip # AISC Example E.14A
    ϕP_n = test_compression(l_name=l_name, leg_connected=:long, L=L)

    @test ϕP_n_expected == ϕP_n


    ϕP_n_expected = 23.3 * kip # Assume type_b connection
    ϕP_n = test_compression(l_name=l_name, connection_type=:type_b, leg_connected=:long, L=L)

    @test ϕP_n_expected == ϕP_n

    
    ϕP_n_expected = 26.9 * kip # short leg
    ϕP_n = test_compression(l_name=l_name, leg_connected=:short, L=L)

    @test ϕP_n_expected == ϕP_n


    ϕP_n_expected = 36.1 * kip # Assume type_b connection
    ϕP_n = test_compression(l_name=l_name, connection_type=:type_b, leg_connected=:short, L=L)

    @test ϕP_n_expected == ϕP_n
end

