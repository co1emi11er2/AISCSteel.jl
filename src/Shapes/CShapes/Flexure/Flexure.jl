"""
    module Flexure

This module includes useful functions to calculate bending capacity of rolled C-Shape sections (`CShape`, `MCShape`).

# Functions
- `classify_flange_major_axis` - classify flange for slenderness when bent about the x-axis
- `classify_flange_minor_axis` - classify flange for slenderness when bent about the y-axis
- `classify_web` - classify web for slnderness
- `calc_Mnx` - moment capacity about the x-axis
- `calc_Mny` - moment capacity about the y-axis

# Modules
- `F2` - includes functions specific for F2 sections
- `F6` - includes functions specific for F6 sections
"""
module Flexure
import AISCSteel
import AISCSteel.ChapterBDesignRequirements.B4.TableB4⬝1a as TableB4⬝1a
# Extend F2 functions
include("F2.jl")

# Extend F2 functions
include("F6.jl")


"""
    classify_flange_major_axis(shape::T) where T <: AISCSteel.Shapes.CShapes.AbstractCShapes

This function classifies flange for flexure for the shape.

# Arguments
- `shape`: rolled C-Shape section (`CShape`, `MCShape`)

# Returns
    (λ_f, λ_pf, λ_rf, λ_fclass)
- `λ_f`: slenderness ratio of the flange
- `λ_pf`: compact slenderness ratio limit of the flange
- `λ_rf`: noncompact slenderness ratio limit of the flange
- `λ_fclass`: `compact` `noncompact` or `slender` classification for the flange
"""
function classify_flange_major_axis((;b_f, t_f, E, F_y)::T) where T <: AISCSteel.Shapes.CShapes.AbstractCShapes

    b = b_f
    t = t_f
    λ_fvariabels = TableB4⬝1a.case10(b, t, E, F_y)

    return λ_fvariabels

end


"""
    classify_flange_minor_axis(shape::T) where T <: AISCSteel.Shapes.CShapes.AbstractCShapes

This function classifies flange for flexure for the shape.

# Arguments
- `shape`: rolled C-Shape section (`CShape`, `MCShape`)

# Returns
    (λ_f, λ_pf, λ_rf, λ_fclass)
- `λ_f`: slenderness ratio of the flange
- `λ_pf`: compact slenderness ratio limit of the flange
- `λ_rf`: noncompact slenderness ratio limit of the flange
- `λ_fclass`: `compact` `noncompact` or `slender` classification for the flange
"""
function classify_flange_minor_axis((;b_f, t_f, E, F_y)::T) where T <: AISCSteel.Shapes.CShapes.AbstractCShapes

    b = b_f
    t = t_f
    λ_fvariabels = TableB4⬝1a.case13(b, t, E, F_y)

    return λ_fvariabels

end


"""
    classify_web(shape::T) where T <: AISCSteel.Shapes.CShapes.AbstractCShapes

This function classifies web for flexure for the shape.

# Arguments
- `shape`: rolled C-Shape section (`CShape`, `MCShape`)

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
    λ_wvariables = TableB4⬝1a.case15(h, t_w, E, F_y)

    return λ_wvariables

end


"""
    calc_Mnx(shape::T, L_b, C_b=1) where T <: AISCSteel.Shapes.CShapes.AbstractCShapes

This function calculates Mnx of the shape.

# Arguments
- `shape`: rolled C-Shape section (`CShape`, `MCShape`)
- `L_b`: unbraced length (inch)
- `C_b`: lateral torsional buckling modification factor (default = 1)

# Returns
- `M_nx`: nominal moment of the section (kip-ft)

# Reference
- AISC Section F2
"""
function calc_Mnx(c::T, L_b, C_b=1) where T <: AISCSteel.Shapes.CShapes.AbstractCShapes
    
    M_nx = F2.calc_Mn(c, L_b, C_b)

    return M_nx
end


"""
    calc_Mny(shape::T) where T <: AISCSteel.Shapes.CShapes.AbstractCShapes

This function calculates Mny of the shape.

# Arguments
- `shape`: rolled C-Shape section (`CShape`, `MCShape`)

# Returns
- `M_ny`: nominal moment of the section (kip-ft)

# Reference
- AISC Section F6
"""
function calc_Mny(c::T) where T <: AISCSteel.Shapes.CShapes.AbstractCShapes
    
    λ_fvariabels = classify_flange_minor_axis(c)

    M_ny = F6.calc_Mn(c, λ_fvariabels...)

    return M_ny
end

end # module
