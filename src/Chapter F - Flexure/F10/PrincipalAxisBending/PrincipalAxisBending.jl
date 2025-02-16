# TODO: Move this to LShape - I don't think we need anything here since equations are the same
# just the section properties change
module PrincipalAxisBending
import AISCSteel
import AISCSteel.Utils.UnitConversions as cnv
import AISCSteel.ChapterFFlexure.F10 as F10
import AISCSteel.ChapterFFlexure.F10: calc_Fcr

function calc_Mcr(E, A_g, r_z, t, C_b, L_b, β_w)
    C_b = min(C_b, 1.5)
    M_cr = F10.Equations.EqF10▬4(E, A_g, r_z, t, C_b, L_b, β_w)
end

function calc_variables(F_y, S_min, E, A_g, r_z, t, β_w, b, L_b, C_b)
    M_y = F_y * S_min |> cnv.to_moment
    M_cr = calc_Mcr(E, A_g, r_z, t, C_b, L_b, β_w)
    F_cr = calc_Fcr(E, b, t)

    return (;M_y, M_cr, F_cr)
end

# include Major Axis Bending
include("MajorAxis/MajorAxis.jl")

# include Minor Axis Bending
include("MinorAxis/MinorAxis.jl")

end
