
"""
    module Flexure

This module includes useful functions to calculate bending capacity of rolled HSS sections (`HSS_Shape`).

# Functions
- `classify_round_hss` - classify round hss for slenderness
- `calc_Mn` - moment capacity
"""
module Flexure
import AISCSteel
import AISCSteel.ChapterBDesignRequirements.B4.TableB4⬝1a as TableB4⬝1a
import AISCSteel.ChapterFFlexure.F8 as F8

"""
    classify_round_hss(shape::T) where T <: AISCSteel.Shapes.HSS_Shapes.AbstractHSS_Shapes

This function classifies flange for flexure for the shape.

# Arguments
- `shape`: rolled HSS sections (`HSS_Shape`)

# Returns
    (λ_f, λ_pf, λ_rf, λ_fclass)
- `λ_f`: slenderness ratio of the round hss
- `λ_pf`: compact slenderness ratio limit of the round hss
- `λ_rf`: noncompact slenderness ratio limit of the round hss
- `λ_fclass`: `compact` `noncompact` or `slender` classification for the round hss
"""
function classify_round_hss((;OD, t_des, E, F_y)::T) where T <: AISCSteel.Shapes.RoundHSS_Shapes.AbstractRoundHSS_Shapes

    λ_fvariabels = TableB4⬝1a.case20(OD, t_des, E, F_y)

    return λ_fvariabels

end


"""
    classify_flange_minor_axis(shape::T) where T <: AISCSteel.Shapes.HSS_Shapes.AbstractHSS_Shapes

This function classifies flange for flexure for the shape.

# Arguments
- `shape`: rolled HSS sections (`HSS_Shape`)

# Returns
    (λ_f, λ_pf, λ_rf, λ_fclass)
- `λ`: slenderness ratio of the flange
- `λ_p`: compact slenderness ratio limit of the flange
- `λ_r`: noncompact slenderness ratio limit of the flange
- `λ_class`: `compact` `noncompact` or `slender` classification for the flange
"""
function classify_flange_minor_axis((;h, t_des, E, F_y)::T) where T <: AISCSteel.Shapes.HSS_Shapes.AbstractHSS_Shapes

    λ_fvariabels = TableB4⬝1a.case17(h, t_des, E, F_y)

    return λ_fvariabels

end


"""
    calc_Mn(shape::T, L_b, C_b=1) where T <: AISCSteel.Shapes.RoundHSS_Shapes.AbstractRoundHSS_Shapes
    calc_Mn(shape::T, λ_class) where T <: AISCSteel.Shapes.RoundHSS_Shapes.AbstractRoundHSS_Shapes

This function calculates Mnx of the shape.

# Arguments
- `shape`: HSS section (`HSS_Shape`)
- `λ_class`: `compact` `noncompact` or `slender` classification for the round hss

# Returns
- `M_n`: nominal moment of the section (kip-ft)

# Reference
- AISC Section F8
"""
function calc_Mn((;E, F_y, Z_x, OD, t_des, S_x)::T, λ_class) where T <: AISCSteel.Shapes.RoundHSS_Shapes.AbstractRoundHSS_Shapes
    
    M_n = F8.calc_Mn(E, F_y, Z_x, OD, t_des, S_x, λ_class)

    return M_n
end

function calc_Mn(hss::T) where T <: AISCSteel.Shapes.RoundHSS_Shapes.AbstractRoundHSS_Shapes

    _, _, _, λ_class = classify_round_hss(hss)
    
    M_n = calc_Mn(hss, λ_class)

    return M_n
end

end # module
