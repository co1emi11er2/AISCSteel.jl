
"""
    module Flexure

This module includes useful functions to calculate bending capacity of rolled HSS sections (`HSS_Shape`).

# Functions
- `classify_flange_major_axis` - classify flange for slenderness when bent about the x-axis
- `classify_flange_minor_axis` - classify flange for slenderness when bent about the y-axis
- `classify_web_major_axis` - classify web for slnderness when bent about the x-axis
- `classify_web_minor_axis` - classify web for slnderness when bent about the y-axis
- `calc_Mnx` - moment capacity about the x-axis
- `calc_Mny` - moment capacity about the y-axis
"""
module Flexure
import AISCSteel
import AISCSteel.ChapterBDesignRequirements.B4.TableB4⬝1a as TableB4⬝1a
import AISCSteel.ChapterFFlexure.F7 as F7

"""
    classify_flange_major_axis(shape::T) where T <: AISCSteel.Shapes.HSS_Shapes.AbstractHSS_Shapes

This function classifies flange for flexure for the shape.

# Arguments
- `shape`: rolled HSS sections (`HSS_Shape`)

# Returns
    (λ_f, λ_pf, λ_rf, λ_fclass)
- `λ_f`: slenderness ratio of the flange
- `λ_pf`: compact slenderness ratio limit of the flange
- `λ_rf`: noncompact slenderness ratio limit of the flange
- `λ_fclass`: `compact` `noncompact` or `slender` classification for the flange
"""
function classify_flange_major_axis((;b, t_des, E, F_y)::T) where T <: AISCSteel.Shapes.HSS_Shapes.AbstractHSS_Shapes

    λ_fvariabels = TableB4⬝1a.case17(b, t_des, E, F_y)

    return λ_fvariabels

end


"""
    classify_flange_minor_axis(shape::T) where T <: AISCSteel.Shapes.HSS_Shapes.AbstractHSS_Shapes

This function classifies flange for flexure for the shape.

# Arguments
- `shape`: rolled HSS sections (`HSS_Shape`)

# Returns
    (λ_f, λ_pf, λ_rf, λ_fclass)
- `λ_f`: slenderness ratio of the flange
- `λ_pf`: compact slenderness ratio limit of the flange
- `λ_rf`: noncompact slenderness ratio limit of the flange
- `λ_fclass`: `compact` `noncompact` or `slender` classification for the flange
"""
function classify_flange_minor_axis((;h, t_des, E, F_y)::T) where T <: AISCSteel.Shapes.HSS_Shapes.AbstractHSS_Shapes

    λ_fvariabels = TableB4⬝1a.case17(h, t_des, E, F_y)

    return λ_fvariabels

end

"""
    classify_web(shape::T) where T <: AISCSteel.Shapes.HSS_Shapes.AbstractHSS_Shapes

This function classifies web for flexure for the shape.

# Arguments
- `shape`: rolled HSS sections (`HSS_Shape`)

# Returns
    (λ_w, λ_pw, λ_rw, λ_wclass)
- `λ_w`: slenderness ratio of the web
- `λ_pw`: compact slenderness ratio limit of the web
- `λ_rw`: noncompact slenderness ratio limit of the web
- `λ_wclass`: `compact` `noncompact` or `slender` classification for the web
"""
function classify_web_major_axis((;h, t_des, E, F_y)::T) where T <: AISCSteel.Shapes.HSS_Shapes.AbstractHSS_Shapes

    λ_wvariables = TableB4⬝1a.case19(h, t_des, E, F_y)

    return λ_wvariables

end


"""
    classify_web(shape::T) where T <: AISCSteel.Shapes.HSS_Shapes.AbstractHSS_Shapes

This function classifies web for flexure for the shape.

# Arguments
- `shape`: rolled HSS sections (`HSS_Shape`)

# Returns
    (λ_w, λ_pw, λ_rw, λ_wclass)
- `λ_w`: slenderness ratio of the web
- `λ_pw`: compact slenderness ratio limit of the web
- `λ_rw`: noncompact slenderness ratio limit of the web
- `λ_wclass`: `compact` `noncompact` or `slender` classification for the web
"""
function classify_web_minor_axis((;b, t_des, E, F_y)::T) where T <: AISCSteel.Shapes.HSS_Shapes.AbstractHSS_Shapes

    λ_wvariables = TableB4⬝1a.case19(b, t_des, E, F_y)

    return λ_wvariables

end


## TODO: Complete updates below
"""
    calc_Mnx(shape::T, L_b, C_b=1) where T <: AISCSteel.Shapes.HSS_Shapes.AbstractHSS_Shapes
    calc_Mnx(shape::T, λ_f, λ_pf, λ_rf, λ_fclass, λ_w, λ_pw, λ_rw, λ_wclass, L_b, C_b=1) where T <: AISCSteel.Shapes.HSS_Shapes.AbstractHSS_Shapes

This function calculates Mnx of the shape.

# Arguments
- `shape`: HSS section (`HSS_Shape`)
- `λ_f`: slenderness ratio of the flange
- `λ_pf`: compact slenderness ratio limit of the flange
- `λ_rf`: noncompact slenderness ratio limit of the flange
- `λ_fclass`: `compact` `noncompact` or `slender` classification for the flange
- `λ_w`: slenderness ratio of the web
- `λ_pw`: compact slenderness ratio limit of the web
- `λ_rw`: noncompact slenderness ratio limit of the web
- `λ_wclass`: `compact` `noncompact` or `slender` classification for the web
- `L_b`: unbraced length (inch)
- `C_b`: lateral torsional buckling modification factor (default = 1)

# Returns
- `M_nx`: nominal moment of the section (kip-ft)

# Reference
- AISC Section F7
"""
function calc_Mnx((;E, F_y, Z_x, h, t_des, b, r_y, J, area, S_x, I_x, Ht)::T, λ_f, λ_pf, λ_rf, λ_fclass, λ_w, λ_pw, λ_rw, λ_wclass, L_b, C_b) where T <: AISCSteel.Shapes.HSS_Shapes.AbstractHSS_Shapes
    
    M_nx = F7.HSS.calc_Mnx(E, F_y, Z_x, h, t_des, b, t_des, r_y, J, area, S_x, I_x, Ht, λ_f, λ_pf, λ_rf, λ_fclass, λ_w, λ_pw, λ_rw, λ_wclass, L_b, C_b)

    return M_nx
end

function calc_Mnx(hss::T, L_b, C_b=1) where T <: AISCSteel.Shapes.HSS_Shapes.AbstractHSS_Shapes

    λ_f, λ_pf, λ_rf, λ_fclass = classify_flange_major_axis(hss)
    λ_w, λ_pw, λ_rw, λ_wclass = classify_web_major_axis(hss)
    
    M_nx = calc_Mnx(hss, λ_f, λ_pf, λ_rf, λ_fclass, λ_w, λ_pw, λ_rw, λ_wclass, L_b, C_b)

    return M_nx
end


"""
    calc_Mny(shape::T) where T <: AISCSteel.Shapes.HSS_Shapes.AbstractHSS_Shapes
    calc_Mny(shape::T, λ_f, λ_pf, λ_rf, λ_fclass, λ_w, λ_pw, λ_rw, λ_wclass) where T <: AISCSteel.Shapes.HSS_Shapes.AbstractHSS_Shapes

This function calculates Mny of the shape.

# Arguments
- `shape`: HSS section (`HSS_Shape`)

# Returns
- `M_ny`: nominal moment of the section (kip-ft)

# Reference
- AISC Section F7
"""
function calc_Mny((;E, F_y, Z_y, h, t_des, b, r_y, J, area, S_y, I_y, B)::T, λ_f, λ_pf, λ_rf, λ_fclass, λ_w, λ_pw, λ_rw, λ_wclass) where T <: AISCSteel.Shapes.HSS_Shapes.AbstractHSS_Shapes
    
    M_nx = F7.HSS.calc_Mny(E, F_y, Z_y, b, t_des, h, t_des, S_y, I_y, B, λ_f, λ_pf, λ_rf, λ_fclass, λ_w, λ_pw, λ_rw, λ_wclass)

    return M_nx
end

function calc_Mny(hss::T) where T <: AISCSteel.Shapes.HSS_Shapes.AbstractHSS_Shapes
    
    λ_f, λ_pf, λ_rf, λ_fclass = classify_flange_minor_axis(hss)
    λ_w, λ_pw, λ_rw, λ_wclass = classify_web_minor_axis(hss)

    M_ny = calc_Mny(hss, λ_f, λ_pf, λ_rf, λ_fclass, λ_w, λ_pw, λ_rw, λ_wclass)

    return M_ny
end

end # module
