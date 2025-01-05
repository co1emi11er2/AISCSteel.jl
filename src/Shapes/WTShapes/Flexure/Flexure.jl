module Flexure
import AISCSteel

# Extend F9 functions
include("F9/F9.jl")


"""
    classify_flange(shape::T) where T <: AISCSteel.Shapes.WTShapes.AbstractWTShapes

This function classifies flange for flexure for the shape.

# Arguments
- `shape`: rolled WT-Shape section (`WTShape`)

# Returns
    (λ_f, λ_pf, λ_rf, λ_fclass)
- `λ_f`: slenderness ratio of the flange
- `λ_pf`: compact slenderness ratio limit of the flange
- `λ_rf`: noncompact slenderness ratio limit of the flange
- `λ_fclass`: `compact` `noncompact` or `slender` classification for the flange
"""
function classify_flange((;b_f, t_f, E, F_y)::T) where T <: AISCSteel.Shapes.WTShapes.AbstractWTShapes

    b = b_f
    t = t_f
    λ_fvariabels = AISCSteel.Classifications.classify_section_for_lb_case10(b, t, E, F_y)

    return λ_fvariabels

end

# """
#     classify_web(shape::T) where T <: AISCSteel.Shapes.WTShapes.AbstractWTShapes

# This function classifies web for flexure for the shape.

# # Arguments
# - `shape`: rolled C-Shape section (`WTShape`, `MWTShape`)

# # Returns
#     (λ_w, λ_pw, λ_rw, λ_wclass)
# - `λ_w`: slenderness ratio of the web
# - `λ_pw`: compact slenderness ratio limit of the web
# - `λ_rw`: noncompact slenderness ratio limit of the web
# - `λ_wclass`: `compact` `noncompact` or `slender` classification for the web
# """
# function classify_web((;h, t_w, E, F_y)::T) where T <: AISCSteel.Shapes.WTShapes.AbstractWTShapes

#     h = h
#     t_w = t_w
#     λ_wvariables = AISCSteel.Classifications.classify_section_for_lb_case15(h, t_w, E, F_y)

#     return λ_wvariables

# end

"""
    calc_positive_Mnx(shape::T, L_b, λ_f, λ_pf, λ_rf, λ_fclass) where T <: AISCSteel.Shapes.WTShapes.AbstractWTShapes

This function calculates Mnx of the shape.

# Arguments
- `shape`: rolled WT-Shape section (`WTShape`)
- `L_b`: unbraced length (inch)

# Returns
- `M_nx`: nominal moment of the section (kip-ft)

# Reference
- AISC Section F9
"""
function calc_positive_Mnx(wt::T, L_b) where T <: AISCSteel.Shapes.WTShapes.AbstractWTShapes

    λ_fvariabels = classify_flange(wt)
    
    M_nx = F9.PositiveBending.calc_Mn(wt, L_b, λ_fvariabels...)

    return M_nx
end


"""
    calc_negative_Mnx(shape::T, L_b) where T <: AISCSteel.Shapes.WTShapes.AbstractWTShapes

This function calculates Mnx of the shape.

# Arguments
- `shape`: rolled WT-Shape section (`WTShape`)
- `L_b`: unbraced length (inch)

# Returns
- `M_nx`: nominal moment of the section (kip-ft)

# Reference
- AISC Section F9
"""
function calc_negative_Mnx(wt::T, L_b) where T <: AISCSteel.Shapes.WTShapes.AbstractWTShapes
    
    M_nx = F9.NegativeBending.calc_Mn(wt, L_b)

    return M_nx
end

end # module
