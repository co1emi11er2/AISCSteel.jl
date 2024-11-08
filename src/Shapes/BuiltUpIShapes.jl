##########################################################################################
# BuiltUpIShape struct and initialization methods
##########################################################################################

struct BuiltUpIShape{T, S} <: AbstractBuiltUpIShapes
    dw::T
    tw::T
    bf::T
    tf::T
    E::S
    F_y::S

    # function DoublySymmetricBuiltUpIShape(dw::T, tw, bf, tf, E::S, F_y) where {T, S}
    #     flange_class = _dbishape_flange_slenderness_flexure(dw,tw,bf,tf,E,F_y)
    #     web_class = _dbishape_web_slenderness_flexure(dw,tw,E,F_y)
    #     return new{T, S, flange_class, web_class}(dw, tw, bf, tf, E, F_y)
    # end

end



##########################################################################################
# BuiltUpIShape classification
# TODO: Find place for Buckling type (maybe change name)
##########################################################################################

@enumx BuiltUpIShapeType begin
    DoublySymmetric
    SinglySymmetric
end



function _classify_flange_flexure_doublysymmetric((;dw,tw,bf,tf,E,F_y)::BuiltUpIShape)
    λ_p = 0.38*sqrt(E/F_y)
    k_c = min(max(4/(sqrt(dw/tw)),0.35), 0.76)
    F_L = 0.7*F_y
    λ_r = 0.95*sqrt(k_c*E/F_L)
    λ = bf/(2*tf)
    class = if λ <= λ_p
                :compact
            elseif λ_p < λ < λ_r
                :noncompact
            else
                :slender
            end
end

function _classify_flange_flexure_singlysymmetric((;dw,tw,bf,tf,E,F_y)::BuiltUpIShape)
    λ_p = 0.38*sqrt(E/F_y)
    k_c = min(max(4/(sqrt(dw/tw)),0.35), 0.76)
    F_L = 0.7*F_y
    λ_r = 0.95*sqrt(k_c*E/F_L)
    λ = bf/(2*tf)
    class = if λ <= λ_p
                :compact
            elseif λ_p < λ < λ_r
                :noncompact
            else
                :slender
            end
end