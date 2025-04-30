using StructuralUnits
import AISCSteel.Shapes.LShapes: LShape
import AISCSteel.Shapes.LShapes.Compression: calc_Pn

function test_compression(;l_name, leg_connected, L, F_y=50ksi)
    lshape = LShape(l_name, F_y=F_y)
    ϕ_b = 0.9

    ϕP_n = calc_Pn(lshape, leg_connected, L) * ϕ_b
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
    
end

