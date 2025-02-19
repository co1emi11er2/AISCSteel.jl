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

"""
    calc_Mcr(E, A_g, r_z, t, C_b, L_b, β_w)

Calculates the elastic lateral-torsional buckling moment of the section bent about the respective axis (kip-ft)

Description of applicable member: L-shaped members bent about their principal axis.

# Arguments
- `E`: modulous of elasticity (ksi)
- `A_g`: gross section area of lshape (inch^2)
- `r_z`: radius of gyration about the minor principal axis (inch)
- `t`: thickness of leg (inch)
- `C_b`: lateral torsional buckling modification factor (default = 1)
- `L_b`: unbraced length (inch)
- `β_w`: section property for single angles about major principal axis (inch)

# Returns 
- `M_cr`: elastic lateral-torsional buckling moment of the section bent about the respective axis (kip-ft)

# Reference
- AISC Section F10 (F10-4)
"""
function calc_Mcr(E, A_g, r_z, t, C_b, L_b, β_w)
    C_b = min(C_b, 1.5)
    M_cr = F10.Equations.EqF10▬4(E, A_g, r_z, t, C_b, L_b, β_w)
end

# include Major Axis Bending
include("MajorAxis/MajorAxis.jl")

# include Minor Axis Bending
include("MinorAxis/MinorAxis.jl")

end
