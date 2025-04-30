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

    b = b_f/2
    t = t_f
    λ_class = TableB4⬝1a.case3(b, t, E, F_y)

    return λ_class

end


"""
    calc_Pn(shape::T, leg_connected, L_c) where T <: AISCSteel.Shapes.LShapes.AbstractLShapes
    calc_Pn(shape::T, leg_connected, L_c, λ, λ_r, λ_class) where T <: AISCSteel.Shapes.LShapes.AbstractLShapes

This function calculates Pn of the shape.

# Arguments
- `shape`: rolled i-shape section (`WTShape`)
- `leg_connected`: the leg that is connected (`:short` or `:long`)
- `L_c`: effective length of member for buckling about the x-axis (inch)
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
function calc_Pn((;A_g, r_x, r_y, G, E, F_y, b_f, t_f, d, t_w, ȳ, I_x, I_y, C_w, J)::T, L_cx, λ, λ_r, λ_class) where T <: AISCSteel.Shapes.LShapes.AbstractLShapes

    F_ex = E4.calc_Fex(E, L_cx, r_x)
    F_ey = E4.calc_Fey(E, L_cy, r_y)

    # calc F_ez
    x_0 = 0inch
    y_0 = ȳ - t_f/2
    r̄_0 = calc_r̄0(x_0, y_0, I_x, I_y, A_g)
    F_ez = E4.calc_Fez(E, C_w, L_cz, G, J, A_g, r̄_0)

    H = E4.calc_H(x_0, y_0, r̄_0)
    F_e = calc_Fe(F_ey, F_ez, H)
    F_e = min(F_ex, F_ey, F_e)
    F_n = E3.calc_Fn(F_y, F_e)

    if λ_wclass == :nonslender
        if λ_fclass == :nonslender
            P_n = E3.calc_Pn(F_n, A_g)
        else
            b = b_f/2
            t = t_f
            c_1 = 0.22
            c_2 = 1.49
            F_el = E7.calc_Fel(c_2, λ_rf, λ_f, F_y)
            b_e = E7.calc_be(λ_f, λ_rf, F_y, F_n, b, c_1, F_el)
            A_e = A_g - 2*(b - b_e)*t
            P_n = E7.calc_Pn(F_n, A_e)
        end
    else
        if λ_fclass == :nonslender
            b = d
            t = t_w
            c_1 = 0.22
            c_2 = 1.49
            F_el = E7.calc_Fel(c_2, λ_rw, λ_w, F_y)
            b_e = E7.calc_be(λ_w, λ_rw, F_y, F_n, b, c_1, F_el)
            A_e = E7.calc_Ae(A_g, b, b_e, t)
            P_n = E7.calc_Pn(F_n, A_e)
        else   
            # flanges
            c_1 = 0.22
            c_2 = 1.49
            F_el = E7.calc_Fel(c_2, λ_rf, λ_f, F_y)
            b = b_f/2
            t = t_f
            b_e = E7.calc_be(λ_f, λ_rf, F_y, F_n, b, c_1, F_el)
            A_e = A_g - 4*(b - b_e)*t

            # web
            c_1 = 0.22
            c_2 = 1.49
            F_el = E7.calc_Fel(c_2, λ_rw, λ_w, F_y)
            b = d
            t = t_w
            b_e = E7.calc_be(λ_w, λ_rw, F_y, F_n, b, c_1, F_el)
            A_e = A_e - (b - b_e)*t

            P_n = E7.calc_Pn(F_n, A_e)
        end
    end

    return P_n
end

function calc_Pn(w::T, L_cx, L_cy, L_cz) where T <: AISCSteel.Shapes.LShapes.AbstractLShapes
    
    λ_f, λ_rf, λ_fclass = classify_leg(w)
    λ_w, λ_rw, λ_wclass = classify_web(w)

    P_n = calc_Pn(w, L_cx, L_cy, L_cz, λ_f, λ_rf, λ_fclass, λ_w, λ_rw, λ_wclass)

    return P_n
end

end # module
