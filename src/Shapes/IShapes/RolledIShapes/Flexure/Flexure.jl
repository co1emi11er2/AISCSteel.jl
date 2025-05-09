"""
    module Flexure

This module includes useful functions to calculate bending capacity of rolled i-shape sections (`WShape`, `MShape`, `SShape`, `HPShape`).

# Functions
- `classify_flange_major_axis` - classify flange for slenderness when bent about the x-axis
- `classify_flange_minor_axis` - classify flange for slenderness when bent about the y-axis
- `classify_web` - classify web for slnderness
- `calc_Mnx` - moment capacity about the x-axis
- `calc_Mny` - moment capacity about the y-axis

# Modules
- `F2` - includes functions specific for F2 sections
- `F3` - includes functions specific for F3 sections
- `F4` - includes functions specific for F4 sections
- `F5` - includes functions specific for F5 sections
- `F6` - includes functions specific for F6 sections
"""
module Flexure
import AISCSteel
import AISCSteel.ChapterBDesignRequirements.B4.TableB4⬝1a as TableB4⬝1a

# Extend F2 functions
include("F2.jl")

# Extend F3 functions
include("F3.jl")

# Extend F4 functions
include("F4.jl")

# Extend F5 functions
include("F5.jl")

# Extend F6 functions
include("F6.jl")

"""
    classify_flange_major_axis(shape::T) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

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
function classify_flange_major_axis((;b_f, t_f, E, F_y)::T) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

    b = b_f/2
    t = t_f
    λ_fvariabels = TableB4⬝1a.case10(b, t, E, F_y)

    return λ_fvariabels

end

"""
    classify_flange_minor_axis(shape::T) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

This function classifies flange for flexure for the shape in minor axis bending.

# Arguments
- `shape`: rolled i-shape section (`WShape`, `MShape`, `SShape`, `HPShape`)

# Returns
    (λ_f, λ_pf, λ_rf, λ_fclass)
- `λ_f`: slenderness ratio of the flange
- `λ_pf`: compact slenderness ratio limit of the flange
- `λ_rf`: noncompact slenderness ratio limit of the flange
- `λ_fclass`: `compact` `noncompact` or `slender` classification for the flange
"""
function classify_flange_minor_axis((;b_f, t_f, E, F_y)::T) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

    b = b_f/2
    t = t_f
    λ_fvariabels = TableB4⬝1a.case13(b, t, E, F_y)

    return λ_fvariabels

end

"""
    classify_web(shape::T) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

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
function classify_web((;h, t_w, E, F_y)::T) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

    h = h
    t_w = t_w
    λ_wvariables = TableB4⬝1a.case15(h, t_w, E, F_y)

    return λ_wvariables

end

"""
    classify_section(w::T) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

This function classifies section for flexure for the shape.

# Arguments
- `shape`: rolled i-shape section (`WShape`, `MShape`, `SShape`, `HPShape`)

# Returns
- `section_class`: `F2`, `F3`, `F4`, or `F5`
"""
function classify_section(w::T) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

    _, _, _, λ_fclass = classify_flange_major_axis(w)
    _, _, _, λ_wclass = classify_web(w)

    if λ_wclass == :compact
        if λ_fclass == :compact
            section = :F2
        else
            section = :F3
        end
    elseif λ_wclass == :noncompact
        section = :F4
    else
        section = :F5
    end
    

    return section

end

"""
    calc_Mnx(shape::T, L_b, C_b=1) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

This function calculates Mnx of the shape.

# Arguments
- `shape`: rolled i-shape section (`WShape`, `MShape`, `SShape`, `HPShape`)
- `L_b`: unbraced length (inch)
- `C_b`: lateral torsional buckling modification factor (default = 1)

# Returns
- `M_nx`: nominal moment of the section (kip-ft)

# Reference
- AISC Section F2-F5
"""
function calc_Mnx(w::T, L_b, C_b=1) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes
    
    λ_fvariabels = classify_flange_major_axis(w)
    λ_wvariabels = classify_web(w)

    λ_f, λ_pf, λ_rf, λ_fclass = λ_fvariabels
    λ_w, λ_pw, λ_rw, λ_wclass = λ_wvariabels

    if λ_wclass == :compact
        if λ_fclass == :compact
            M_nx = F2.calc_Mn(w, L_b, C_b)
        else
            M_nx = F3.calc_Mn(w, L_b, λ_fvariabels..., C_b)
        end
    elseif λ_wclass == :noncompact
        M_nx = F4.calc_Mn(w, L_b, λ_w, λ_pw, λ_rw, λ_f, λ_pf, λ_rf, λ_fclass, C_b)
    else
        M_nx = F5.calc_Mn(w, L_b, λ_w, λ_pw, λ_rw, λ_f, λ_pf, λ_rf, λ_fclass, C_b)
    end

    return M_nx
end

"""
    calc_Mny(shape::T) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

This function calculates Mny of the shape.

# Arguments
- `shape`: rolled i-shape section (`WShape`, `MShape`, `SShape`, `HPShape`)

# Returns
- `M_ny`: nominal moment of the section (kip-ft)

# Reference
- AISC Section F6
"""
function calc_Mny(w::T) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes
    
    λ_fvariabels = classify_flange_minor_axis(w)

    M_ny = F6.calc_Mn(w, λ_fvariabels...)

    return M_ny
end

end # module
