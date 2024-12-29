module Flexure
import AISCSteel
# Extend F2 functions
include("F2.jl")


"""
    classify_flange(shape::T) where T <: AISCSteel.Shapes.CShapes.AbstractCShapes

This function classifies flange for flexure for the shape.

# Arguments
- `shape`: rolled i-shape section (`WShape`, `MShape`, `SShape`, `HPShape`)

# Returns
    (λ_f, λ_pf, λ_rf, λ_fclass)
- `λ_f`: slenderness ratio of the flange
- `λ_pf`: compact slenderness ratio limit of the flange
- `λ_rf`: noncompact slenderness ratio limit of the flange
- `λ_fclass`: `compact` `noncompact` or `slender` classification for the flange
"""
function classify_flange((;b_f, t_f, E, F_y)::T) where T <: AISCSteel.Shapes.CShapes.AbstractCShapes

    b = b_f
    t = t_f
    λ_fvariabels = AISCSteel.Classifications.classify_section_for_lb_case10(b, t, E, F_y)

    return λ_fvariabels

end

"""
    classify_web(shape::T) where T <: AISCSteel.Shapes.CShapes.AbstractCShapes

This function classifies web for flexure for the shape.

# Arguments
- `shape`: rolled i-shape section (`WShape`, `MShape`, `SShape`, `HPShape`)

# Returns
    (λ_w, λ_pw, λ_rw, λ_wclass)
- `λ_w`: slenderness ratio of the web
- `λ_pw`: compact slenderness ratio limit of the web
- `λ_rw`: noncompact slenderness ratio limit of the web
- `λ_wclass`: `compact` `noncompact` or `slender` classification for the web
"""
function classify_web((;h, t_w, E, F_y)::T) where T <: AISCSteel.Shapes.CShapes.AbstractCShapes

    h = h
    t_w = t_w
    λ_wvariables = AISCSteel.Classifications.classify_section_for_lb_case15(h, t_w, E, F_y)

    return λ_wvariables

end

"""
    calc_Mn(shape::T, L_b, C_b=1) where T <: AISCSteel.Shapes.CShapes.AbstractCShapes

This function calculates Mn of the shape.

# Arguments
- `shape`: rolled i-shape section (`WShape`, `MShape`, `SShape`, `HPShape`)
- `L_b`: unbraced length (inch)
- `C_b`: lateral torsional buckling modification factor (default = 1)

# Returns
- `M_n`: nominal moment of the section (kip-ft)

# Reference
- AISC Section F2
"""
function calc_Mn(w::T, L_b, C_b=1) where T <: AISCSteel.Shapes.CShapes.AbstractCShapes
    
    M_n = F2.calc_Mn(w, L_b, C_b)

    return M_n
end

end # module
