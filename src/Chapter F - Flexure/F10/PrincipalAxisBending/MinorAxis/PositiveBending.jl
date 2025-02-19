"""
    module PositiveBending

LShapes bent about their principal minor axis (z-axis) when tension is in the toe of the legs.
"""
module PositiveBending

import AISCSteel.ChapterFFlexure.F10: calc_MnY, calc_My


function calc_positive_Mnz(F_y, S_min)

    M_y = calc_My(F_y, S_min)
    M_nY = calc_MnY(M_y)

    M_nw = M_nY

    return M_nw
end

end