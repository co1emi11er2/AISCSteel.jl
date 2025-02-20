"""
    module PositiveBending

LShapes bent about their principal minor axis (z-axis) when tension is in the toe of the legs.
"""
module PositiveBending

import AISCSteel.ChapterFFlexure.F10: calc_MnY, calc_My

"""
    calc_positive_Mnz(F_y, S_min)
    calc_positive_Mnz(lshape)

Calculates positive moment about the minor principal axis when tension is in the toe of the legs for an LShape.

# Arguments
- `F_y`: yield strength of steel (ksi)
- `S_min`: minimum elastic section modulous about z-axis (inch^3)

# Returns
- `M_nz`: moment capacity of the section about the z-axis. (kip-in)

# Reference
- AISC Section F10
"""
function calc_positive_Mnz(F_y, S_min)

    M_y = calc_My(F_y, S_min)
    M_nY = calc_MnY(M_y)

    M_nz = M_nY

    return M_nz
end

end