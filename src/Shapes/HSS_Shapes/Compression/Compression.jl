
"""
    module Compression

This module includes useful functions to calculate compression capacity of rolled hss-shape sections (`HSS_Shape`).

# Functions
- `classify_long_wall` - classify longer wall for slenderness
- `classify_short_wall` - classify shorter wall for slenderness
- `calc_Pn` - Compressive capacity of the shape
"""
module Compression
using StructuralUnits
import AISCSteel
import AISCSteel.ChapterBDesignRequirements.B4.TableB4⬝1a as TableB4⬝1a
import AISCSteel.ChapterECompression.E3 as E3
import AISCSteel.ChapterECompression.E4 as E4
import AISCSteel.ChapterECompression.E7 as E7

"""
    classify_long_wall(shape::T) where T <: AISCSteel.Shapes.HSS_Shapes.AbstractHSS_Shapes

This function classifies wall for compression for the shape.

# Arguments
- `shape`: rolled hss-shape section (`HSS_Shape`)

# Returns
    (λ_f, λ_rf, λ_fclass)
- `λ_f`: slenderness ratio of the wall
- `λ_rf`: nonslender slenderness ratio limit of the wall
- `λ_fclass`: `nonslender` or `slender` classification for the wall
"""
function classify_long_wall((;h, t_des, E, F_y)::T) where T <: AISCSteel.Shapes.HSS_Shapes.AbstractHSS_Shapes

    b = h
    t = t_des
    λ_fclass = TableB4⬝1a.case6(b, t, E, F_y)

    return λ_fclass

end


"""
    classify_short_wall(shape::T) where T <: AISCSteel.Shapes.HSS_Shapes.AbstractHSS_Shapes

This function classifies wall for compression for the shape.

# Arguments
- `shape`: rolled hss-shape section (`HSS_Shape`)

# Returns
    (λ_f, λ_rf, λ_fclass)
- `λ_f`: slenderness ratio of the wall
- `λ_rf`: nonslender slenderness ratio limit of the wall
- `λ_fclass`: `nonslender` or `slender` classification for the wall
"""
function classify_short_wall((;b, t_des, E, F_y)::T) where T <: AISCSteel.Shapes.HSS_Shapes.AbstractHSS_Shapes

    b = b
    t = t_des
    λ_fclass = TableB4⬝1a.case6(b, t, E, F_y)

    return λ_fclass

end


"""
    calc_Pn(shape::T, L_cx, L_cy) where T <: AISCSteel.Shapes.HSS_Shapes.AbstractHSS_Shapes
    calc_Pn(shape::T, L_cx, L_cy, λ_b, λ_rb, λ_bclass, λ_h, λ_rh, λ_hclass) where T <: AISCSteel.Shapes.HSS_Shapes.AbstractHSS_Shapes

This function calculates Pn of the shape.

# Arguments
- `shape`: rolled hss-shape section (`HSS_Shape`)
- `L_cx`: effective length of member for buckling about the x-axis (inch)
- `L_cy`: effective length of member for buckling about the y-axis (inch)
- `λ_b`: slenderness ratio of the shorter wall
- `λ_rb`: nonslender slenderness ratio limit of the shorter wall
- `λ_bclass`: `nonslender` or `slender` classification for the shorter wall
- `λ_h`: slenderness ratio of the longer wall
- `λ_rh`: nonslender slenderness ratio limit of the longer wall
- `λ_hclass`: `nonslender` or `slender` classification for the longer wall

# Returns
- `P_n`: nominal compressive strength of the section (kip)

# Reference
- AISC Section E3, E7
"""
function calc_Pn((;A_g, r_x, r_y, E, F_y, b, t_des, h)::T, L_cx, L_cy, λ_b, λ_rb, λ_bclass, λ_h, λ_rh, λ_hclass) where T <: AISCSteel.Shapes.HSS_Shapes.AbstractHSS_Shapes

    if L_cx/r_x > L_cy/r_y
        L_c = L_cx
        r = r_x
    else
        L_c = L_cy
        r = r_y
    end

    F_e = E3.calc_Fe(E, L_c, r)
    F_n = E3.calc_Fn(L_c, r, E, F_y, F_e)

    if λ_hclass == :nonslender
        # if long wall is not slender, then short wall is not either
        P_n = E3.calc_Pn(F_n, A_g)
    else
        if λ_bclass == :nonslender
            b = h
            t = t_des
            c_1 = 0.20
            c_2 = 1.38
            F_el = E7.calc_Fel(c_2, λ_rh, λ_h, F_y)
            b_e = E7.calc_be(λ_h, λ_rh, F_y, F_n, b, c_1, F_el)
            A_e = A_g - 2*(b - b_e)*t
            P_n = E7.calc_Pn(F_n, A_e)
        else   
            # short wall
            c_1 = 0.20
            c_2 = 1.38
            F_el = E7.calc_Fel(c_2, λ_rb, λ_b, F_y)
            b = b
            t = t_des
            b_e = E7.calc_be(λ_b, λ_rb, F_y, F_n, b, c_1, F_el)
            A_e = A_g - 2*(b - b_e)*t

            # long wall
            c_1 = 0.20
            c_2 = 1.38
            F_el = E7.calc_Fel(c_2, λ_rh, λ_h, F_y)
            b = h
            t = t_des
            b_e = E7.calc_be(λ_h, λ_rh, F_y, F_n, b, c_1, F_el)
            A_e = A_e - 2*(b - b_e)*t

            P_n = E7.calc_Pn(F_n, A_e)
        end
    end

    return P_n
end

function calc_Pn(hss::T, L_cx, L_cy) where T <: AISCSteel.Shapes.HSS_Shapes.AbstractHSS_Shapes
    
    λ_b, λ_rb, λ_bclass = classify_short_wall(hss)
    λ_h, λ_rh, λ_hclass = classify_long_wall(hss)

    P_n = calc_Pn(hss, L_cx, L_cy, λ_b, λ_rb, λ_bclass, λ_h, λ_rh, λ_hclass)

    return P_n
end

end # module
