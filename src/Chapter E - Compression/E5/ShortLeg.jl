
"""
    module ShortLeg

This section applies to single-angle compression members attached through the longer leg.
"""
module ShortLeg
import AISCSteel.ChapterECompression.E5.Equations as Equations
import AISCSteel.ChapterECompression.E5.LongLeg as LongLeg

"""
    calc_Lc_part_a(L, r_a, r_z, b_l, b_s)

This function calculates L_c of the shape. For angles (connected through shorter leg) that are individual members or are web members of planar trusses with adjacent web members attached to the same side of the gusset plate or chord.

# Arguments
- `L`: length of member between work points (inch)
- `r_a`: radius of gyration about the geometric axis parallel to the connected leg (inch)
- `r_z`: radius of gyration about the minor principal axis (inch)
- `b_l`: length of long leg (inch)
- `b_s`: length of short leg (inch)

# Returns
- `L_ceff`: effective length of the member for buckling about the minor axis (inch)

# Reference
- AISC Section E5 part a
"""
function calc_Lc_part_a(L, r_a, r_z, b_l, b_s)
    
    L_c = LongLeg.calc_Lc_part_a(L, r_a)
    
    L_c = L_c + 4*r_a*((b_l/b_s)^2 - 1)
    L_c = max(L_c, 0.95*L/r_z)

    return L_c
end

"""
    calc_Lc_part_b(L, r_a, r_z, b_l, b_s)

This function calculates L_c of the shape. For angles (connected through shorter leg) that are web members of box or space trusses with adjacent web members attached to the same side of the gusset plate or chord.

# Arguments
- `L`: length of member between work points (inch)
- `r_a`: radius of gyration about the geometric axis parallel to the connected leg (inch)
- `r_z`: radius of gyration about the minor principal axis (inch)
- `b_l`: length of long leg (inch)
- `b_s`: length of short leg (inch)

# Returns
- `L_ceff`: effective length of the member for buckling about the minor axis (inch)

# Reference
- AISC Section E5 part b
"""
function calc_Lc_part_b(L, r_a, r_z, b_l, b_s)
    
    L_c = LongLeg.calc_Lc_part_b(L, r_a)

    L_c = L_c + 6*r_a*((b_l/b_s)^2 - 1)
    L_c = max(L_c, 0.82*L/r_z)

    return L_c
end

end
