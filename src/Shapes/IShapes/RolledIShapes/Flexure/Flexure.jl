module Flexure
import AISCSteel
# Extend F2 functions
include("F2.jl")

# Extend F3 functions
include("F3.jl")

# Extend F4 functions
include("F4.jl")

# Extend F5 functions
include("F5.jl")

function classify_flange((;b_f, t_f, E, F_y)::T) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

    b = b_f/2
    t = t_f
    λ_fvariabels = AISCSteel.Classifications.classify_section_for_lb_case10(b, t, E, F_y)

    return λ_fvariabels

end

function classify_web((;h, t_w, E, F_y)::T) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

    h = h
    t_w = t_w
    λ_wvariables = AISCSteel.Classifications.classify_section_for_lb_case15(h, t_w, E, F_y)

    return λ_wvariables

end

function classify_section(w::T) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes

    _, _, _, λ_fclass = classify_flange(w)
    _, _, _, λ_wclass = classify_web(w)

    if λ_wclass == :compact
        if λ_fclass == :compact
            section = :F2
        else
            section = :F3
        end
    elseif λ_wclass == :noncompact
        section = :F4
    else
        section = :F5
    end
    

    return section

end

function calc_Mn(w::T, L_b, C_b=1) where T <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes
    
    λ_fvariabels = classify_flange(w)
    λ_wvariabels = classify_web(w)

    λ_f, λ_pf, λ_rf, λ_fclass = λ_fvariabels
    λ_w, λ_pw, λ_rw, λ_wclass = λ_wvariabels

    if λ_wclass == :compact
        if λ_fclass == :compact
            M_n = F2.calc_Mn(w, L_b, C_b)
        else
            M_n = F3.calc_Mn(w, L_b, λ_fvariabels..., C_b)
        end
    elseif λ_wclass == :noncompact
        M_n = F4.calc_Mn(w, L_b, λ_w, λ_pw, λ_rw, λ_f, λ_pf, λ_rf, λ_fclass, C_b)
    else
        M_n = F5.calc_Mn(w, L_b, λ_w, λ_pw, λ_rw, λ_f, λ_pf, λ_rf, λ_fclass, C_b)
    end

    return M_n
end

end # module