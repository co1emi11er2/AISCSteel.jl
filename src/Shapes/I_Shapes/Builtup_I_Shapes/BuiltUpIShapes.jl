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
    d::float_inch
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

function _calc_ishape_d(h, t_w, t_ftop)
    d = h + t_w + t_ftop
end

function _calc_ishape_areas(h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)
    a_ftop = b_ftop * t_ftop
    a_fbot = b_fbot * t_fbot
    a_w = h * t_w

    a = a_ftop + a_fbot + a_w

    return a_ftop, a_fbot, a_w, a
end

function _calc_ishape_ybars(a_ftop, a_fbot, a_w, a, h, t_ftop, t_fbot)
    y_ftop = t_fbot + h + t_ftop / 2
    y_fbot = t_fbot / 2
    y_w = t_fbot + h / 2

    y_bar = (a_ftop * y_ftop + a_fbot * y_fbot + a_w * y_w) / a

    return y_ftop, y_fbot, y_w, y_bar
end

function _calc_ishape_Ix(h, t_w, b_ftop, t_ftop, b_fbot, t_fbot, y_ftop, y_fbot, y_w, y_bar, a_ftop, a_fbot, a_w)
    I_xftop = b_ftop * t_ftop^3 / 12 + a_ftop * (y_ftop - y_bar)^2
    I_xfbot = b_fbot * t_fbot^3 / 12 + a_fbot * (y_fbot - y_bar)^2
    I_xw = t_w * h^3 / 12 + a_w * (y_w - y_bar)^2

    I_x = I_xftop + I_xfbot + I_xw
end

function _calc_ishape_Sxc(I_x, y_c)
    S_xc = I_x / y_c
end

function _calc_ishape_Sxt(I_x, y_t)
    S_xt = I_x / y_t
end

function _calc_ishape_yp(a, a_fbot, t_w, t_fbot)
    # assume y_p is in web
    y_p = (a / 2 - a_fbot) / t_w + t_fbot
end

function _calc_ishape_Zx(t_fbot, h, t_w, a_ftop, a_fbot, y_ftop, y_fbot, y_p)
    Z_xfbot = a_fbot * abs(y_fbot - y_p)
    Z_xftop = a_ftop * abs(y_ftop - y_p)
    h_w1 = (y_p - t_fbot)
    h_w2 = h - h_w1
    Z_xw1 = h_w1 * t_w * (h_w1 / 2)
    Z_xw2 = h_w2 * t_w * (h_w2 / 2)

    Z_x = Z_xftop + Z_xfbot + Z_xw1 + Z_xw2
end

function _calc_ishape_xbar((; h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)::T) where {T<:AbstractBuiltUpIShapes}
    nothing
end

function _calc_Iy((; h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)::T) where {T<:AbstractBuiltUpIShapes}
    nothing
end

function _calc_Sy((; h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)::T) where {T<:AbstractBuiltUpIShapes}
    nothing
end

function _calc_Zy((; h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)::T) where {T<:AbstractBuiltUpIShapes}
    nothing
end

function _calc_ry((; h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)::T) where {T<:AbstractBuiltUpIShapes}
    nothing
end

function _calc_J((; h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)::T) where {T<:AbstractBuiltUpIShapes}
    nothing
end

function _calc_Cw((; h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)::T) where {T<:AbstractBuiltUpIShapes}
    nothing
end

function _calc_rts((; h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)::T) where {T<:AbstractBuiltUpIShapes}
    nothing
end

function _calc_h_0((; h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)::T) where {T<:AbstractBuiltUpIShapes}
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



function _classify_flange_flexure_doublysymmetric((; dw, tw, bf, tf, E, F_y)::BuiltUpIShape)
    λ_p = 0.38 * sqrt(E / F_y)
    k_c = min(max(4 / (sqrt(dw / tw)), 0.35), 0.76)
    F_L = 0.7 * F_y
    λ_r = 0.95 * sqrt(k_c * E / F_L)
    λ = bf / (2 * tf)
    class = if λ <= λ_p
        :compact
    elseif λ_p < λ < λ_r
        :noncompact
    else
        :slender
    end
end

function _classify_flange_flexure_singlysymmetric((; dw, tw, bf, tf, E, F_y)::BuiltUpIShape)
    λ_p = 0.38 * sqrt(E / F_y)
    k_c = min(max(4 / (sqrt(dw / tw)), 0.35), 0.76)
    F_L = 0.7 * F_y
    λ_r = 0.95 * sqrt(k_c * E / F_L)
    λ = bf / (2 * tf)
    class = if λ <= λ_p
        :compact
    elseif λ_p < λ < λ_r
        :noncompact
    else
        :slender
    end
end
