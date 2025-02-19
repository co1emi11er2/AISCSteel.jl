"""
    module PrincipalAxisBending

LShapes bent about their principal axis (w-axis, z-axis).

There are two sections:
- Major Axis - LShapes bent about their w-axis
- Minor Axis - LShapes bent about their z-axis
"""
module PrincipalAxisBending
import AISCSteel
import AISCSteel.ChapterFFlexure.F10 as F10
import AISCSteel.ChapterFFlexure.F10: calc_Fcr

function calc_Mcr(E, A_g, r_z, t, C_b, L_b, β_w)
    C_b = min(C_b, 1.5)
    M_cr = F10.Equations.EqF10▬4(E, A_g, r_z, t, C_b, L_b, β_w)
end

# include Major Axis Bending
include("MajorAxis/MajorAxis.jl")

# include Minor Axis Bending
include("MinorAxis/MinorAxis.jl")

end
