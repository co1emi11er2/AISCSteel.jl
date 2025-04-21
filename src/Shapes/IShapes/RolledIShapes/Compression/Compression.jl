"""
    module Compression

This module includes useful functions to calculate compression capacity of rolled i-shape sections (`WShape`, `MShape`, `SShape`, `HPShape`).

# Functions
- `classify_flange` - classify flange for slenderness
- `classify_web` - classify web for slenderness
- `calc_Pn` - Compressive capacity of the shape
"""
module Compression
import AISCSteel
import AISCSteel.ChapterBDesignRequirements.B4.TableB4⬝1a as TableB4⬝1a
import AISCSteel.ChapterECompression.E3 as E3
import AISCSteel.ChapterECompression.E7 as E7

"""
    classify_flange(shape::T) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

This function classifies flange for compression for the shape.

# Arguments
- `shape`: rolled i-shape section (`WShape`, `MShape`, `SShape`, `HPShape`)

# Returns
    (λ_f, λ_rf, λ_fclass)
- `λ_f`: slenderness ratio of the flange
- `λ_rf`: nonslender slenderness ratio limit of the flange
- `λ_fclass`: `nonslender` or `slender` classification for the flange
"""
function classify_flange((;b_f, t_f, E, F_y)::T) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

    b = b_f/2
    t = t_f
    λ_fclass = TableB4⬝1a.case1(b, t, E, F_y)

    return λ_fclass

end

"""
    classify_web(shape::T) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

This function classifies web for compression for the shape.

# Arguments
- `shape`: rolled i-shape section (`WShape`, `MShape`, `SShape`, `HPShape`)

# Returns
    (λ_w, λ_rw, λ_wclass)
- `λ_w`: slenderness ratio of the web
- `λ_rw`: nonslender slenderness ratio limit of the web
- `λ_wclass`: `nonslender` or `slender` classification for the web
"""
function classify_web((;h, t_w, E, F_y)::T) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

    h = h
    t_w = t_w
    λ_wvariables = TableB4⬝1a.case5(h, t_w, E, F_y)

    return λ_wvariables

end

"""
    calc_Pn(shape::T, L_cx, L_cy) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes
    calc_Pn(shape::T, L_cx, L_cy, λ_f, λ_rf, λ_fclass, λ_w, λ_rw, λ_wclass) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

This function calculates Pn of the shape.

# Arguments
- `shape`: rolled i-shape section (`WShape`, `MShape`, `SShape`, `HPShape`)
- `L_cx`: effective length of member for buckling about the x-axis (inch)
- `L_cy`: effective length of member for buckling about the y-axis (inch)
- `λ_f`: slenderness ratio of the flange
- `λ_rf`: nonslender slenderness ratio limit of the flange
- `λ_fclass`: `nonslender` or `slender` classification for the flange
- `λ_w`: slenderness ratio of the web
- `λ_rw`: nonslender slenderness ratio limit of the web
- `λ_wclass`: `nonslender` or `slender` classification for the web

# Returns
- `P_n`: nominal compressive strength of the section (kip)

# Reference
- AISC Section E3, E7
"""
function calc_Pn((;area, r_x, r_y, E, F_y, b_f, t_f, h, t_w)::T, L_cx, L_cy, λ_f, λ_rf, λ_fclass, λ_w, λ_rw, λ_wclass) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

    if L_cx/r_x > L_cy/r_y
        L_c = L_cx
        r = r_x
    else
        L_c = L_cy
        r = r_y
    end

    F_e = E3.calc_Fe(E, L_c, r)
    F_n = E3.calc_Fn(L_c, r, E, F_y, F_e)

    if λ_wclass == :nonslender
        if λ_fclass == :nonslender
            P_n = E3.calc_Pn(F_n, area)
        else
            b = b_f/2
            t = t_f
            c_1 = 0.22
            c_2 = 1.49
            F_el = E7.calc_Fel(c_2, λ_rf, λ_f, F_y)
            b_e = E7.calc_be(λ_f, λ_rf, F_y, F_n, b, c_1, F_el)
            A_e = area - 4*(b - b_e)*t
            P_n = E7.calc_Pn(F_n, A_e)
        end
    else
        if λ_fclass == :nonslender
            b = h
            t = t_w
            c_1 = 0.18
            c_2 = 1.31
            F_el = E7.calc_Fel(c_2, λ_rw, λ_w, F_y)
            b_e = E7.calc_be(λ_w, λ_rw, F_y, F_n, b, c_1, F_el)
            A_e = E7.calc_Ae(area, b, b_e, t)
            P_n = E7.calc_Pn(F_n, A_e)
        else   
            # flanges
            c_1 = 0.22
            c_2 = 1.49
            F_el = E7.calc_Fel(c_2, λ_rf, λ_f, F_y)
            b = b_f/2
            t = t_f
            b_e = E7.calc_be(λ_f, λ_rf, F_y, F_n, b, c_1, F_el)
            A_e = area - 4*(b - b_e)*t

            # web
            c_1 = 0.18
            c_2 = 1.31
            F_el = E7.calc_Fel(c_2, λ_rw, λ_w, F_y)
            b = h
            t = t_w
            b_e = E7.calc_be(λ_w, λ_rw, F_y, F_n, b, c_1, F_el)
            A_e = A_e - (b - b_e)*t

            P_n = E7.calc_Pn(F_n, A_e)
        end
    end

    return P_n
end

function calc_Pn(w::T, L_cx, L_cy) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes
    
    λ_f, λ_rf, λ_fclass = classify_flange(w)
    λ_w, λ_rw, λ_wclass = classify_web(w)

    P_n = calc_Pn(w, L_cx, L_cy, λ_f, λ_rf, λ_fclass, λ_w, λ_rw, λ_wclass)

    return P_n
end

end # module