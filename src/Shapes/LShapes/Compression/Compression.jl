"""
    module Compression

This module includes useful functions to calculate compression capacity of angle sections (`LShape`).

# Functions
- `classify_leg` - classify leg for slenderness
- `classify_web` - classify web for slenderness
- `calc_Pn` - Compressive capacity of the shape
"""
module Compression
using StructuralUnits
import AISCSteel
import AISCSteel.ChapterBDesignRequirements.B4.TableB4⬝1a as TableB4⬝1a
import AISCSteel.ChapterECompression.E3 as E3
import AISCSteel.ChapterECompression.E5 as E5
import AISCSteel.ChapterECompression.E7 as E7

"""
    classify_leg(shape::T) where T <: AISCSteel.Shapes.LShapes.AbstractLShapes

This function classifies flange for compression for the shape.

# Arguments
- `shape`: rolled i-shape section (`WTShape`)

# Returns
    (λ_f, λ_rf, λ_fclass)
- `λ_f`: slenderness ratio of the flange
- `λ_rf`: nonslender slenderness ratio limit of the flange
- `λ_fclass`: `nonslender` or `slender` classification for the flange
"""
function classify_leg((;b, t, E, F_y)::T) where T <: AISCSteel.Shapes.LShapes.AbstractLShapes

    b = b
    t = t
    λ_class = TableB4⬝1a.case3(b, t, E, F_y)

    return λ_class

end


"""
    calc_Pn(shape::T, leg_connected, L) where T <: AISCSteel.Shapes.LShapes.AbstractLShapes
    calc_Pn(shape::T, leg_connected, L, λ, λ_r, λ_class) where T <: AISCSteel.Shapes.LShapes.AbstractLShapes

This function calculates Pn of the shape.

# Arguments
- `shape`: rolled i-shape section (`WTShape`)
- `leg_connected`: the leg that is connected (`:short` or `:long`)
- `L`: length of member between work points (inch)
- `λ`: slenderness ratio of the long leg
- `λ_r`: nonslender slenderness ratio limit of the long leg
- `λ_class`: `nonslender` or `slender` classification for the long leg

# Returns
- `P_n`: nominal compressive strength of the section (kip)

# Assumptions
- Members are loaded at the ends in compression though the same one leg
- Members are attached by welding or by connections with a minimum of two bolts
- There are no intermediate transverse loads
- Lc/r as determined in this section does not exceed 200
- For unequal leg angles, the ratio of long leg width to short leg width is less than 1.7

# Reference
- AISC Section E3, E5, E7
"""
function calc_Pn((;A_g, r_x, r_y, r_z, E, F_y, b, t, d)::T, leg_connected, L, λ, λ_r, λ_class) where T <: AISCSteel.Shapes.LShapes.AbstractLShapes

    
    if leg_connected == :long
        r_a = r_y
        L_c = E5.LongLeg.calc_Lc_part_a(L, r_a)
    else
        r_a = r_x
        L_c = E5.ShortLeg.calc_Lc_part_a(L, r_a, r_z, b, d)
    end
    
    F_e = E3.calc_Fe(E, L_c, r_a)
    F_n = E3.calc_Fn(F_y, F_e)

    if λ_class == :nonslender
        P_n = E3.calc_Pn(F_n, A_g)
    else
        b = b
        t = t
        c_1 = 0.22
        c_2 = 1.49
        F_el = E7.calc_Fel(c_2, λ_r, λ, F_y)
        b_e = E7.calc_be(λ, λ_r, F_y, F_n, b, c_1, F_el)
        A_e = E7.calc_Ae(A_g, b, b_e, t)
        P_n = E7.calc_Pn(F_n, A_e)
    end

    return P_n
end

function calc_Pn(lshape::T, leg_connected, L) where T <: AISCSteel.Shapes.LShapes.AbstractLShapes
    
    λ, λ_r, λ_class = classify_leg(lshape)

    P_n = calc_Pn(lshape, leg_connected, L, λ, λ_r, λ_class)

    return P_n
end

end # module
