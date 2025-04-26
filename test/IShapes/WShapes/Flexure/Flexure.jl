module Flexure
using StructuralUnits
using  Test, TestItems, TestItemRunner
import AISCSteel
import AISCSteel.ChapterBDesignRequirements.B4.TableB4⬝1a as TableB4⬝1a
import AISCSteel.Shapes.IShapes.RolledIShapes: WShape
import AISCSteel.Shapes.IShapes.RolledIShapes.Flexure: calc_Mnx, calc_Mny


function test_major_flexure(;w_name, L_b, F_y=50ksi)
    w = WShape(w_name, F_y=F_y)
    ϕ_b = 0.9

    ϕM_n = calc_Mnx(w, L_b) * ϕ_b
    ϕM_n = round(kip*ft, ϕM_n, sigdigits=3)
end

function test_minor_flexure(;w_name, F_y=50ksi)
    w = WShape(w_name, F_y=F_y)
    ϕ_b = 0.9

    ϕM_n = calc_Mny(w) * ϕ_b
    ϕM_n = round(kip*ft, ϕM_n, sigdigits=3)
end

# Extend F2 functions
@testset verbose = true "F2" begin
    include("F2.jl")
end

# Extend F3 functions
@testset verbose = true "F3" begin
include("F3.jl")
end

# Extend F4 functions
@testset verbose = true "F4" begin
include("F4.jl")
end

# Extend F5 functions
@testset verbose = true "F5" begin
include("F5.jl")
end

# Extend F6 functions
@testset verbose = true "F6" begin
include("F6.jl")
end

end