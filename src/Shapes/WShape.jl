##########################################################################################
# WShape struct and initialization methods
##########################################################################################

Base.@kwdef struct WShape <: AbstractRolledIShapes
    shape::String
    weight::float_plf
    area::float_inch2
    d::float_inch
    b_f::float_inch
    t_w::float_inch
    t_f::float_inch
    k::float_inch
    k_1::float_inch
    h::float_inch
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
    W_no::float_inch2
    S_w1::float_inch4
    Q_f::float_inch3
    Q_w::float_inch3
    r_ts::float_inch
    h_0::float_inch
    PA::float_inch
    PB::float_inch
    PC::float_inch
    PD::float_inch
    T::float_inch
    WG_i::float_inch
    WG_0#::Union{float_inch, Missing}
    E::float_ksi = 29000ksi
    F_y::float_ksi = 60ksi
    C_b::Float64 = 1.0
end

function WShape(shape; E=29000ksi, F_y=60ksi, C_b=1)
    csv_file_name = "W_shapes.csv"
    csv_file_path = joinpath("shape files", csv_file_name)
    lookup_col_name = :shape
    lookup_value = uppercase(shape)
    wshape = import_data(lookup_value, lookup_col_name, csv_file_path)
    
    WShape(
        wshape.shape,
        wshape.weight * plf,
        wshape.area * inch^2,
        wshape.d * inch,
        wshape.bf * inch,
        wshape.tw * inch,
        wshape.tf * inch,
        wshape.k * inch,
        wshape.k1 * inch,
        wshape.h * inch,
        wshape.Ix * inch^4,
        wshape.Zx * inch^3,
        wshape.Sx * inch^3,
        wshape.rx * inch,
        wshape.Iy * inch^4,
        wshape.Zy * inch^3,
        wshape.Sy * inch^3,
        wshape.ry * inch,
        wshape.J * inch^4,
        wshape.Cw * inch^6,
        wshape.Wno * inch^2,
        wshape.Sw1 * inch^4,
        wshape.Qf * inch^3,
        wshape.Qw * inch^3,
        wshape.rts * inch,
        wshape.ho * inch,
        wshape.PA * inch,
        wshape.PB * inch,
        wshape.PC * inch,
        wshape.PD * inch,
        wshape.T * inch,
        wshape.WGi * inch,
        wshape.WGo,
        E,
        F_y,
        C_b
    )
end

function classify_flange_for_flexure((;b_f, t_f, E, F_y)::T) where T <: AbstractRolledIShapes

    b = b_f/2
    t = t_f
    λ_fvariabels = classify_section_for_lb_case10(b, t, E, F_y)

    return λ_fvariabels

end

function classify_web_for_flexure((;h, t_w, E, F_y)::WShape)

    h = h
    t_w = t_w
    λ_wvariables = classify_section_for_lb_case15(h, t_w, E, F_y)

    return λ_wvariables

end

function classify_section_for_flexure(w::WShape)

    _, _, _, λ_fclass = classify_flange_for_flexure(w)
    _, _, _, λ_wclass = classify_web_for_flexure(w)

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

##########################################################################################
# Design of members for flexure - Section F2
##########################################################################################

function flexure_capacity_f2_variables((;E, F_y, Z_x, S_x, r_y, r_ts, J, h_0)::WShape, L_b, C_b=1)

    c = 1
    
    t = flexure_capacity_f2_variables(E, F_y, Z_x, S_x, r_y, r_ts, J, c, h_0, L_b, C_b)

    return t
end

function flexure_capacity_f2((;Z_x, S_x, r_y, h_0, J, r_ts, E, F_y,)::WShape, L_b, C_b=1)

    c = 1

    M_n = flexure_capacity_f2(
        E,
        F_y,
        Z_x,
        S_x,
        r_y,
        h_0,
        J,
        c,
        r_ts,
        L_b,
        C_b
    )

    return M_n
end

##########################################################################################
# Design of members for flexure - Section F3
##########################################################################################

function flexure_capacity_f3_variables((;E, F_y, Z_x, S_x, r_y, r_ts, J, h_0, h, t_w)::WShape, L_b, C_b=1)

    c = 1
    
    t = flexure_capacity_f3_variables(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, h, t_w, C_b)

    return t
end

function flexure_capacity_f3((;Z_x, S_x, r_y, h_0, J, r_ts, h, t_w, E, F_y)::WShape, L_b, C_b=1)

    λ_fvariabels = classify_section_for_lb_case10(b, t, E, F_y)

    c = 1

    M_n = flexure_capacity_f3(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, h, t_w, λ_fvariabels..., C_b)

    return M_n
end

function flexure_capacity_f3((;Z_x, S_x, r_y, h_0, J, r_ts, h, t_w, E, F_y)::WShape, L_b, λ_f, λ_pf, λ_rf, λ_fclass, C_b=1)

    c = 1

    M_n = flexure_capacity_f3(E, F_y, Z_x, S_x, r_y, h_0, J, c, r_ts, L_b, h, t_w, λ_f, λ_pf, λ_rf, λ_fclass, C_b)

    return M_n
end

##########################################################################################
# Design of members for flexure - Section F4
##########################################################################################

calc_Sxc((;S_x)::WShape) = S_xc = S_x
calc_Sxt((;S_x)::WShape) = S_xt = S_x
calc_Iyc((;b_f, t_f)::WShape) = I_yc = (b_f * t_f^3)/12 
calc_hc((;h)::WShape) = h_c = h

function flexure_capacity_f4_variables((;E, F_y, Z_x, S_x, b_f, t_f, h, t_w, J, h_0, I_y)::WShape, L_b, λ_w, λ_pw, λ_rw, C_b=1)

    I_yc = (b_f * t_f^3)/12 
    
    t = flexure_capacity_f4_variables(E, F_y, Z_x, S_x, S_x, S_x, b_f, t_f, h, h, t_w, J, h_0, I_y, I_yc, λ_w, λ_pw, λ_rw, L_b, C_b)

    return t
end


function flexure_capacity_f4((;E, F_y, Z_x, S_x, b_f, t_f, h, t_w, J, h_0, I_y)::WShape, L_b, λ_w, λ_pw, λ_rw, λ_f, λ_pf, λ_rf, λ_fclass, C_b=1)

    I_yc = (b_f * t_f^3)/12 
    
    M_n = flexure_capacity_f4(E, F_y, Z_x, S_x, S_x, S_x, b_f, t_f, h, h, t_w, J, h_0, I_y, I_yc, λ_w, λ_pw, λ_rw, λ_f, λ_pf, λ_rf, λ_fclass, L_b, C_b)

    return M_n
end

##########################################################################################
# Design of members for flexure - Section F5
##########################################################################################
function flexure_capacity_f5_variables((;E, F_y, S_x, b_f, t_f, h, t_w)::WShape, L_b, λ_f, λ_pf, λ_rf, λ_fclass, C_b=1)
    
    t = flexure_capacity_f5_variables(E, F_y, S_x, b_f, t_f, h, h, t_w, λ_f, λ_pf, λ_rf, λ_fclass, L_b, C_b)

    return t
end


function flexure_capacity_f5((;E, F_y, Z_x, S_x, b_f, t_f, h, t_w, J, h_0, I_y)::WShape, L_b, λ_w, λ_pw, λ_rw, λ_f, λ_pf, λ_rf, λ_fclass, C_b=1)
    
    M_n = flexure_capacity_f5(E, F_y, S_x, S_x, b_f, t_f, h, h, t_w, λ_f, λ_pf, λ_rf, λ_fclass, L_b, C_b)

    return M_n
end

##########################################################################################
# Design of members for flexure
##########################################################################################

function flexure_capacity(w::WShape, L_b, C_b=1)
    
    λ_fvariabels = classify_flange_for_flexure(w)
    λ_wvariabels = classify_web_for_flexure(w)

    λ_f, λ_pf, λ_rf, λ_fclass = λ_fvariabels
    λ_w, λ_pw, λ_rw, λ_wclass = λ_wvariabels

    if λ_wclass == :compact
        if λ_fclass == :compact
            M_n = flexure_capacity_f2(w, L_b, C_b)
        else
            M_n = flexure_capacity_f3(w, L_b, λ_fvariabels..., C_b)
        end
    elseif λ_wclass == :noncompact
        M_n = flexure_capacity_f4(w, L_b, λ_w, λ_pw, λ_rw, λ_f, λ_pf, λ_rf, λ_fclass, C_b)
    else
        M_n = flexure_capacity_f5(w, L_b, λ_w, λ_pw, λ_rw, λ_f, λ_pf, λ_rf, λ_fclass, C_b)
    end

    return M_n
end
