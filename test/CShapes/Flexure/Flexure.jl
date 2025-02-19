module Flexure
using  Test
using StructuralUnits
import AISCSteel.Shapes.CShapes: CShape, MCShape
import AISCSteel.Shapes.CShapes.Flexure: calc_Mnx, calc_Mny


function test_major_flexure(;c_name, L_b, F_y=50ksi)
    if startswith(c_name, "c")
        c = CShape(c_name, F_y=F_y)
    else
        c = MCShape(c_name, F_y=F_y)
    end
    ϕ_b = 0.9

    ϕM_n = calc_Mnx(c, L_b) * ϕ_b
    ϕM_n = round(kip*ft, ϕM_n, sigdigits=3)
end

function test_minor_flexure(;c_name, F_y=50ksi)
    if startswith(c_name, "c")
        c = CShape(c_name, F_y=F_y)
    else
        c = MCShape(c_name, F_y=F_y)
    end
    ϕ_b = 0.9

    ϕM_n = calc_Mny(c) * ϕ_b
    ϕM_n = round(kip*ft, ϕM_n, sigdigits=3)
end

# Extend F2 functions
@testset verbose = true "F2" begin
    include("F2.jl")
end

# Extend F6 functions
@testset verbose = true "F6" begin
    include("F6.jl")
end

end