module Flexure
import AISCSteel
import AISCSteel.ChapterBDesignRequirements.B4.TableB4⬝1a as TableB4⬝1a

# Extend F10 functions
include("F10/F10.jl")

"""
    classify_leg(shape::T) where T <: AISCSteel.Shapes.LShapes.AbstractLShapes

This function classifies leg for flexure for the shape.

# Arguments
- `shape`: rolled L-Shape section (`LShape`)

# Returns
    (λ_f, λ_p, λ_r, λ_class)
- `λ`: slenderness ratio of the leg
- `λ_p`: compact slenderness ratio limit of the leg
- `λ_rf`: noncompact slenderness ratio limit of the leg
- `λ_fclass`: `compact` `noncompact` or `slender` classification for the leg
"""
function classify_leg((;b, t, E, F_y)::T) where T <: AISCSteel.Shapes.LShapes.AbstractLShapes

    λ_variabels = TableB4⬝1a.case10(b, t, E, F_y)

    return λ_variabels

end

function calc_positive_Mnw end
function calc_negative_Mnw end
function calc_positive_Mnz end
function calc_negative_Mnz end
function calc_positive_Mnx end
function calc_negative_Mnx end
function calc_positive_Mny end
function calc_negative_Mny end

end