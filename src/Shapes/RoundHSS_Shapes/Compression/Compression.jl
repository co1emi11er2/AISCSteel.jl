
"""
    module Compression

This module includes useful functions to calculate compression capacity of round hss-shape sections (`RoundHSS_Shape`).

# Functions
- `classify_wall` - classify wall for slenderness
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
    classify_wall(shape::T) where T <: AISCSteel.Shapes.RoundHSS_Shapes.AbstractRoundHSS_Shapes

This function classifies wall for compression for the shape.

# Arguments
- `shape`: rolled hss-shape section (`RoundHSS_Shape`)

# Returns
    (λ_f, λ_rf, λ_fclass)
- `λ_f`: slenderness ratio of the wall
- `λ_rf`: nonslender slenderness ratio limit of the wall
- `λ_fclass`: `nonslender` or `slender` classification for the wall
"""
function classify_wall((;OD, t_des, E, F_y)::T) where T <: AISCSteel.Shapes.RoundHSS_Shapes.AbstractRoundHSS_Shapes

    D = OD
    t = t_des
    λ_fclass = TableB4⬝1a.case9(D, t, E, F_y)

    return λ_fclass

end


"""
    calc_Pn(shape::T, L_cx, L_cy) where T <: AISCSteel.Shapes.RoundHSS_Shapes.AbstractRoundHSS_Shapes
    calc_Pn(shape::T, L_cx, L_cy, λ_b, λ_rb, λ_bclass, λ_h, λ_rh, λ_hclass) where T <: AISCSteel.Shapes.RoundHSS_Shapes.AbstractRoundHSS_Shapes

This function calculates Pn of the shape.

# Arguments
- `shape`: rolled hss-shape section (`RoundHSS_Shape`)
- `L_cx`: effective length of member for buckling about the x-axis (inch)
- `L_cy`: effective length of member for buckling about the y-axis (inch)
- `λ`: slenderness ratio of the wall
- `λ_r`: nonslender slenderness ratio limit of the wall
- `λ_class`: `nonslender` or `slender` classification for the wall

# Returns
- `P_n`: nominal compressive strength of the section (kip)

# Reference
- AISC Section E3, E7
"""
function calc_Pn((;A_g, r_x, r_y, E, F_y, OD, t_des)::T, L_cx, L_cy, λ, λ_r, λ_class) where T <: AISCSteel.Shapes.RoundHSS_Shapes.AbstractRoundHSS_Shapes

    D = OD
    t = t_des

    if L_cx/r_x >= L_cy/r_y
        L_c = L_cx
        r = r_x
    else
        L_c = L_cy
        r = r_y
    end

    F_e = E3.calc_Fe(E, L_c, r)
    F_n = E3.calc_Fn(L_c, r, E, F_y, F_e)

    if λ_class == :nonslender
        P_n = E3.calc_Pn(F_n, A_g)
    else
        if D/t <= 0.11*E/F_y
            A_e = E7.Equations.EqE7▬6(A_g)
            P_n = E7.calc_Pn(F_n, A_e)
        else
            A_e = E7.Equations.EqE7▬7(E, F_y, D, t, A_g)
            P_n = E7.calc_Pn(F_n, A_e)
        end
    end

    return P_n
end

function calc_Pn(hss::T, L_cx, L_cy) where T <: AISCSteel.Shapes.RoundHSS_Shapes.AbstractRoundHSS_Shapes
    
    λ, λ_r, λ_class = classify_wall(hss)

    P_n = calc_Pn(hss, L_cx, L_cy, λ, λ_r, λ_class)

    return P_n
end

end # module
