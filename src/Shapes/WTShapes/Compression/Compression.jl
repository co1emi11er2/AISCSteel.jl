"""
    module Compression

This module includes useful functions to calculate compression capacity of rolled i-shape sections (`WShape`, `MShape`, `SShape`, `HPShape`).

# Functions
- `classify_flange` - classify flange for slenderness
- `classify_web` - classify web for slenderness
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
    classify_flange(shape::T) where T <: AISCSteel.Shapes.WTShapes.AbstractWTShapes

This function classifies flange for compression for the shape.

# Arguments
- `shape`: rolled i-shape section (`WTShape`)

# Returns
    (λ_f, λ_rf, λ_fclass)
- `λ_f`: slenderness ratio of the flange
- `λ_rf`: nonslender slenderness ratio limit of the flange
- `λ_fclass`: `nonslender` or `slender` classification for the flange
"""
function classify_flange((;b_f, t_f, E, F_y)::T) where T <: AISCSteel.Shapes.WTShapes.AbstractWTShapes

    b = b_f/2
    t = t_f
    λ_fclass = TableB4⬝1a.case1(b, t, E, F_y)

    return λ_fclass

end

"""
    classify_web(shape::T) where T <: AISCSteel.Shapes.WTShapes.AbstractWTShapes

This function classifies web for compression for the shape.

# Arguments
- `shape`: rolled i-shape section (`WShape`, `MShape`, `SShape`, `HPShape`)

# Returns
    (λ_w, λ_rw, λ_wclass)
- `λ_w`: slenderness ratio of the web
- `λ_rw`: nonslender slenderness ratio limit of the web
- `λ_wclass`: `nonslender` or `slender` classification for the web
"""
function classify_web((;d, t_w, E, F_y)::T) where T <: AISCSteel.Shapes.WTShapes.AbstractWTShapes

    d = d
    t_w = t_w
    λ_wvariables = TableB4⬝1a.case4(d, t_w, E, F_y)

    return λ_wvariables

end

"""
    calc_Fe(F_ey, F_ez, H)

This function calculates F_e of the shape.

# Arguments
- `F_ey`: elastic buckling stress with respect to the y-axis (ksi)
- `F_ez`: elastic buckling stress with respect to the z-axis (ksi)
- `H`: flexural constant

# Returns
- `F_e`: elastic buckling stress (ksi)

# Reference
- AISC Section E4 (E4-3)
"""
function calc_Fe(F_ey, F_ez, H)
    F_e = E4.Equations.EqE4▬3(F_ey, F_ez, H)
end

"""
    calc_r̄0(x_0, y_0, I_x, I_y, A_g)

Calculates the polar radius of gyration about the shear center.

Description of applicable member: member without slender elements.  

# Arguments
- `x_0`: x-coordinate of the shear center with respect to the centroid (inch)
- `y_0`: y-coordinate of the shear center with respect to the centroid (inch)
- `I_x`: Moment of inertia about the x-axis (inch^4)
- `I_y`: Moment of inertia about the y-axis (inch^4)
- `A_g`: gross area of member (inch^2)

# Returns 
- `r̄_0`: polar radius of gyration about the shear center (inch)

# Reference
- AISC Section E4 (E4-8)
"""
function calc_r̄0(x_0, y_0, I_x, I_y, A_g)
    r̄_0 = E4.Equations.EqE4▬9(x_0, y_0, I_x, I_y, A_g)
end

"""
    calc_Pn(shape::T, L_cx, L_cy, L_cz) where T <: AISCSteel.Shapes.WTShapes.AbstractWTShapes
    calc_Pn(shape::T, L_cx, L_cy, L_cz, λ_f, λ_rf, λ_fclass, λ_w, λ_rw, λ_wclass) where T <: AISCSteel.Shapes.WTShapes.AbstractWTShapes

This function calculates Pn of the shape.

# Arguments
- `shape`: rolled i-shape section (`WTShape`)
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
- AISC Section E3, E4, E7
"""
function calc_Pn((;A_g, r_x, r_y, G, E, F_y, b_f, t_f, d, t_w, ȳ, I_x, I_y, C_w, J)::T, L_cx, L_cy, L_cz, λ_f, λ_rf, λ_fclass, λ_w, λ_rw, λ_wclass) where T <: AISCSteel.Shapes.WTShapes.AbstractWTShapes

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

function calc_Pn(w::T, L_cx, L_cy, L_cz) where T <: AISCSteel.Shapes.WTShapes.AbstractWTShapes
    
    λ_f, λ_rf, λ_fclass = classify_flange(w)
    λ_w, λ_rw, λ_wclass = classify_web(w)

    P_n = calc_Pn(w, L_cx, L_cy, L_cz, λ_f, λ_rf, λ_fclass, λ_w, λ_rw, λ_wclass)

    return P_n
end

end # module