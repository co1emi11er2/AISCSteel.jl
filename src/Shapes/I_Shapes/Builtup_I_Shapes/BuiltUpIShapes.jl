##########################################################################################
# BuiltUpIShape struct and initialization methods
# NOTE: This is not usable currently
##########################################################################################

Base.@kwdef struct BuiltUpIShape <: AbstractBuiltUpIShapes
    h::float_inch
    t_w::float_inch
    b_ftop::float_inch
    t_ftop::float_inch
    b_fbot::float_inch
    t_fbot::float_inch
    I_x::float_inch4
    Z_x::float_inch3
    S_x::float_inch3
    r_x::float_inch
    I_y::float_inch4
    Z_y::float_inch3
    S_y::float_inch3
    r_y::float_inch
    J::float_inch4
    C_w::float_inch6
    r_ts::float_inch
    h_0::float_inch
    area::float_inch2
    weight::float_plf
    E::float_ksi = 29000ksi
    F_y::float_ksi = 60ksi

end

# struct to help with 
Base.@kwdef struct InitBuiltUpIShape <: AbstractBuiltUpIShapes
    h::float_inch
    t_w::float_inch
    b_ftop::float_inch
    t_ftop::float_inch
    b_fbot::float_inch
    t_fbot::float_inch
    E::float_ksi
    F_y::float_ksi
end

function section_properties()
    nothing
end

function _calc_area((;h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)::T) where T <: AbstractBuiltUpIShapes
    nothing
end

function _calc_ybar((;h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)::T) where T <: AbstractBuiltUpIShapes
    nothing
end

function _calc_Ix((;h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)::T) where T <: AbstractBuiltUpIShapes
    nothing
end

function _calc_Sxc((;h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)::T) where T <: AbstractBuiltUpIShapes
    nothing
end

function _calc_Sxt((;h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)::T) where T <: AbstractBuiltUpIShapes
    nothing
end

function _calc_yp((;h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)::T) where T <: AbstractBuiltUpIShapes
    nothing
end

function _calc_Zx((;h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)::T) where T <: AbstractBuiltUpIShapes
    nothing
end

function _calc_xbar((;h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)::T) where T <: AbstractBuiltUpIShapes
    nothing
end

function _calc_Iy((;h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)::T) where T <: AbstractBuiltUpIShapes
    nothing
end

function _calc_Sy((;h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)::T) where T <: AbstractBuiltUpIShapes
    nothing
end

function _calc_Zy((;h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)::T) where T <: AbstractBuiltUpIShapes
    nothing
end

function _calc_ry((;h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)::T) where T <: AbstractBuiltUpIShapes
    nothing
end

function _calc_J((;h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)::T) where T <: AbstractBuiltUpIShapes
    nothing
end

function _calc_Cw((;h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)::T) where T <: AbstractBuiltUpIShapes
    nothing
end

function _calc_rts((;h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)::T) where T <: AbstractBuiltUpIShapes
    nothing
end

function _calc_h_0((;h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)::T) where T <: AbstractBuiltUpIShapes
    nothing
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