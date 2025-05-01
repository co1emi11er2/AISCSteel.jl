"""
    module LongLeg

This section applies to single-angle compression members attached through the longer leg.
"""
module LongLeg
import AISCSteel.ChapterECompression.E5.Equations as Equations

"""
    calc_Lc_type_a(L, r_a)

This function calculates L_c of the shape. For angles that are individual members or are web members of planar trusses with adjacent web members attached to the same side of the gusset plate or chord.

# Arguments
- `L`: length of member between work points (inch)
- `r_a`: radius of gyration about the geometric axis parallel to the connected leg (inch)

# Returns
- `L_ceff`: effective length of the member for buckling about the minor axis (inch)

# Reference
- AISC Section E5 part a
"""
function calc_Lc_type_a(L, r_a)
    if L/r_a <= 80
        L_c = Equations.EqE5▬1(L, r_a)
    else
        L_c = Equations.EqE5▬2(L, r_a)
    end
end

"""
    calc_Lc_type_b(L, r_a)

This function calculates L_c of the shape. For angles that are web members of box or space trusses with adjacent web members attached to the same side of the gusset plate or chord.

# Arguments
- `L`: length of member between work points (inch)
- `r_a`: radius of gyration about the geometric axis parallel to the connected leg (inch)

# Returns
- `L_ceff`: effective length of the member for buckling about the minor axis (inch)

# Reference
- AISC Section E5 part b
"""
function calc_Lc_type_b(L, r_a)
    if L/r_a <= 75
        L_c = Equations.EqE5▬3(L, r_a)
    else
        L_c = Equations.EqE5▬4(L, r_a)
    end
end

end
