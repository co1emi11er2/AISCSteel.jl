"""
    module Flexure

This module includes useful functions to calculate bending capacity of LShapes.

# Functions
- `classify_leg`
- `calc_positive_Mnw` - moment capacity about w-axis when compression is in the short leg.
- `calc_negative_Mnw` - moment capacity about w-axis when compression is in the long leg.
- `calc_positive_Mnz` - moment capacity about z-axis when compression is in the toe of the legs.
- `calc_negative_Mnz` - moment capacity about z-axis when tension is in the toe of the legs.
- `calc_positive_Mnx` - moment capacity about x-axis when compression is in the toe of the leg.
- `calc_positive_Mny` - moment capacity about y-axis when compression is in the toe of the leg.
- `calc_negative_Mnx` - moment capacity about x-axis when tension is in the toe of the leg.
- `calc_negative_Mny` - moment capacity about y-axis when tension is in the toe of the leg.

# Modules
- `F10` - module where functions are exported from. No need to step into this module
"""
module Flexure

import AISCSteel
import AISCSteel.ChapterBDesignRequirements.B4.TableB4⬝1a as TableB4⬝1a
import AISCSteel.ChapterFFlexure.F10.PrincipalAxisBending.MajorAxis.PositiveBending: calc_positive_Mnw
import AISCSteel.ChapterFFlexure.F10.PrincipalAxisBending.MajorAxis.NegativeBending: calc_negative_Mnw
import AISCSteel.ChapterFFlexure.F10.PrincipalAxisBending.MinorAxis.PositiveBending: calc_positive_Mnz
import AISCSteel.ChapterFFlexure.F10.PrincipalAxisBending.MinorAxis.NegativeBending: calc_negative_Mnz

export calc_positive_Mnw, calc_negative_Mnw, calc_positive_Mnz, calc_negative_Mnz

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

# Extend F10 functions
include("F10/F10.jl")

import .F10.GeometricAxisBending.PositiveBending: calc_positive_Mnx, calc_positive_Mny
import .F10.GeometricAxisBending.NegativeBending: calc_negative_Mnx, calc_negative_Mny

export calc_positive_Mnx, calc_positive_Mny, calc_negative_Mnx, calc_negative_Mny


end