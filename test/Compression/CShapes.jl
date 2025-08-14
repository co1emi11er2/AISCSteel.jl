
using StructuralUnits
import AISCSteel.Shapes.CShapes: CShape, MCShape
import AISCSteel.Shapes.CShapes.Compression: calc_Pn

function test_compression(;cs_name, L_cx, L_cy, L_cz, F_y=50ksi)
    w = CShape(cs_name, F_y=F_y)
    ϕ_b = 0.9

    ϕP_n = calc_Pn(w, L_cx, L_cy, L_cz) * ϕ_b
    ϕP_n = round(kip, ϕP_n, sigdigits=3)
end

##########################################################################################
# Design of members for compression
##########################################################################################

# Non Slender C-Shape
let 
    cs_name = "C15x50"
    L_cx = L_cy = L_cz = 5ft
    ϕP_n_expected = 465 * kip # Fy/Fe <= 2.25
    ϕP_n = test_compression(cs_name=cs_name, L_cx=L_cx, L_cy=L_cy, L_cz=L_cz)

    @test ϕP_n_expected == ϕP_n


    L_cx = L_cy = L_cz = 16ft
    ϕP_n_expected = 67.4 * kip # Fy/Fe > 2.25
    ϕP_n = test_compression(cs_name=cs_name, L_cx=L_cx, L_cy=L_cy, L_cz=L_cz)

    @test ϕP_n_expected == ϕP_n
    
end


# Slender webs C-Shape
let 
    cs_name = "C15x33.9"
    L_cx = L_cy = L_cz = 5ft
    ϕP_n_expected = 400 * kip # Fy/Fe <= 2.25
    ϕP_n = test_compression(cs_name=cs_name, L_cx=L_cx, L_cy=L_cy, L_cz=L_cz, F_y=70ksi)

    @test ϕP_n_expected == ϕP_n


    L_cx = L_cy = L_cz = 16ft
    ϕP_n_expected = 49.7 * kip # Fy/Fe > 2.25
    ϕP_n = test_compression(cs_name=cs_name, L_cx=L_cx, L_cy=L_cy, L_cz=L_cz, F_y=70ksi)

    @test ϕP_n_expected == ϕP_n
    
end

# Slender flanges C-Shape
let 
    cs_name = "C10x30"
    L_cx = L_cy = L_cz = 0.5ft
    ϕP_n_expected = 1550 * kip # Fy/Fe <= 2.25
    ϕP_n = test_compression(cs_name=cs_name, L_cx=L_cx, L_cy=L_cy, L_cz=L_cz, F_y=200ksi)

    @test ϕP_n_expected == ϕP_n


    L_cx = L_cy = L_cz = 5ft
    ϕP_n_expected = 247 * kip # Fy/Fe > 2.25
    ϕP_n = test_compression(cs_name=cs_name, L_cx=L_cx, L_cy=L_cy, L_cz=L_cz, F_y=200ksi)

    @test ϕP_n_expected == ϕP_n
    
end

# Slender flanges and webs C-Shape
let 
    cs_name = "C12x30"
    L_cx = L_cy = L_cz = 0.5ft
    ϕP_n_expected = 1790 * kip # Fy/Fe <= 2.25
    ϕP_n = test_compression(cs_name=cs_name, L_cx=L_cx, L_cy=L_cy, L_cz=L_cz, F_y=250ksi)

    @test ϕP_n_expected == ϕP_n


    L_cx = L_cy = L_cz = 5ft
    ϕP_n_expected = 321 * kip # Fy/Fe > 2.25
    ϕP_n = test_compression(cs_name=cs_name, L_cx=L_cx, L_cy=L_cy, L_cz=L_cz, F_y=250ksi)

    @test ϕP_n_expected == ϕP_n
    
end
