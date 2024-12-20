##########################################################################################
# BuiltUpIShape struct and initialization methods
# NOTE: This is not usable currently
##########################################################################################
module BuiltUpIShapes

using StructuralUnits
using EnumX
import AISCSteel.Shapes.IShapes: AbstractBuiltUpIShapes
import AISCSteel

Base.@kwdef struct BuiltUpIShape <: AbstractBuiltUpIShapes
    h::AISCSteel.Units.float_inch
    t_w::AISCSteel.Units.float_inch
    b_ftop::AISCSteel.Units.float_inch
    t_ftop::AISCSteel.Units.float_inch
    b_fbot::AISCSteel.Units.float_inch
    t_fbot::AISCSteel.Units.float_inch
    d::AISCSteel.Units.float_inch
    I_x::AISCSteel.Units.float_inch4
    Z_x::AISCSteel.Units.float_inch3
    S_x::AISCSteel.Units.float_inch3
    r_x::AISCSteel.Units.float_inch
    I_y::AISCSteel.Units.float_inch4
    Z_y::AISCSteel.Units.float_inch3
    S_y::AISCSteel.Units.float_inch3
    r_y::AISCSteel.Units.float_inch
    J::AISCSteel.Units.float_inch4
    C_w::AISCSteel.Units.float_inch6
    r_ts::AISCSteel.Units.float_inch
    h_0::AISCSteel.Units.float_inch
    area::AISCSteel.Units.float_inch2
    weight::AISCSteel.Units.float_plf
    E::AISCSteel.Units.float_ksi = 29000ksi
    F_y::AISCSteel.Units.float_ksi = 60ksi

end

# struct to help with
Base.@kwdef struct InitBuiltUpIShape <: AbstractBuiltUpIShapes
    h::AISCSteel.Units.float_inch
    t_w::AISCSteel.Units.float_inch
    b_ftop::AISCSteel.Units.float_inch
    t_ftop::AISCSteel.Units.float_inch
    b_fbot::AISCSteel.Units.float_inch
    t_fbot::AISCSteel.Units.float_inch
    E::AISCSteel.Units.float_ksi
    F_y::AISCSteel.Units.float_ksi
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

function _calc_ishape_xbar(b_ftop, b_fbot)
    x_bar = max(b_ftop, b_fbot) / 2
end

function _calc_ishape_Iy((; h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)::T) where {T<:AbstractBuiltUpIShapes}
    I_yftop = t_ftop * b_ftop^3 / 12
    I_yfbot = t_fbot * b_fbot^3 / 12
    I_yw = h * t_w^3 / 12

    I_y = I_yftop + I_yfbot + I_yw

end

function _calc_ishape_Sy(I_y, x_bar)
    S_y = I_y / x_bar
end

function _calc_ishape_Zy(h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)
    Z_yfbot = (t_fbot * b_fbot^2) / 6
    Z_yftop = (t_ftop * b_ftop^2) / 6
    Z_yw = (h * t_w^2) / 6

    Z_x = Z_yftop + Z_yfbot + Z_yw
end

function _calc_ishape_ry(I_y, a)
    r_y = sqrt(I_y / a)
end

function _calc_ishape_J(h, t_w, b_ftop, t_ftop, b_fbot, t_fbot)
    J = ((b_ftop * t_ftop^3) + (b_fbot * t_fbot^3) + (h * t_w^3)) / 3
end

function _calc_ishape_Cw(I_y, h_0, S_x)
    C_w = (I_y * h_0) / (2 * S_x)
end

function _calc_ishape_rts(I_y, C_w, S_x)
    rts_squared = sqrt(I_y * C_w) / S_x
    r_ts = sqrt(rts_squared)
end

function _calc_ishape_h0(t_ftop, h, t_fbot)
    h_0 = t_ftop + h + t_fbot
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

end # module
