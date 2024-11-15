##########################################################################################
# WShape struct and initialization methods
##########################################################################################

Base.@kwdef struct WShape
    shape
    weight
    area
    d
    bf
    tw
    tf
    k
    k1
    h
    Ix
    Zx
    Sx
    rx
    Iy
    Zy
    Sy
    ry
    J
    Cw
    Wno
    Sw1
    Qf
    Qw
    rts
    ho
    PA
    PB
    PC
    PD
    T
    WGi
    WGo
    E = 29000ksi
    F_y = 60ksi
    C_b = 1
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

function classify_flange_for_flexure((;bf, tf, E, F_y)::WShape)

    b = bf/2
    t = tf
    λ_fvariabels = classify_section_for_lb_case10(b, t, E, F_y)

    return λ_fvariabels

end

function classify_web_for_flexure((;h, tw, E, F_y)::WShape)

    h = h
    tw = tw
    λ_wvariables = classify_section_for_lb_case15(h, tw, E, F_y)

    return λ_wvariables

end

##########################################################################################
# Design of members for flexure - Section F2
##########################################################################################

function flexure_capacity_f2_1((;Zx, F_y)::WShape)

    M_n1 = flexure_capacity_f2_1(F_y, Z_x)

    return M_n1
end

function flexure_capacity_f2_2((;Zx, Sx, ry, ho, J, rts, E, F_y,)::WShape, M_p, L_b)
    M_n2 = flexure_capacity_f2_2(
        M_p,
        E,
        F_y,
        Sx,
        ry,
        ho,
        J,
        1,
        rts,
        L_b,
    )

    return M_n2
end

function flexure_capacity_f2((;Zx, Sx, ry, ho, J, rts, E, F_y,)::WShape, L_b)
    M_n = flexure_capacity_f2(
        E,
        F_y,
        Zx,
        Sx,
        ry,
        ho,
        J,
        1,
        rts,
        L_b,
    )

    return M_n
end

##########################################################################################
# Design of members for flexure - Section F3
##########################################################################################

function flexure_capacity_f3_1((;Zx, Sx, ry, ho, J, rts, E, F_y)::WShape, L_b)

    M_n1 = flexure_capacity_f3_1(E, F_y, Zx, Sx, ry, ho, J, 1, rts, L_b)

    return M
end

function flexure_capacity_f3_2((;E, F_y, Zx, Sx, h, tw)::WShape, λ_f, λ_pf, λ_rf, λ_fclass)

    M_n2 = flexure_capacity_f3_2(E, F_y, Zx, Sx, h, tw, λ_f, λ_pf, λ_rf, λ_fclass)

    return M_n2
end

function flexure_capacity_f3((;Zx, Sx, ry, ho, J, rts, h, tw, E, F_y)::WShape, L_b)

    λ_fvariabels = classify_section_for_lb_case10(b, t, E, F_y)

    M_n = flexure_capacity_f3(E, F_y, Zx, Sx, ry, ho, J, c, rts, L_b, h, t_w, λ_fvariabels...)

    return M_n
end

function flexure_capacity_f3((;Zx, Sx, ry, ho, J, rts, h, tw, E, F_y)::WShape, L_b, λ_f, λ_pf, λ_rf, λ_fclass)

    M_n = flexure_capacity_f3(E, F_y, Zx, Sx, ry, ho, J, 1, rts, L_b, h, tw, λ_f, λ_pf, λ_rf, λ_fclass)

    return M_n
end

##########################################################################################
# Design of members for flexure - Section F4
##########################################################################################

##########################################################################################
# Design of members for flexure - Section F5
##########################################################################################

##########################################################################################
# Design of members for flexure
##########################################################################################

function flexure_capacity(w::WShape, L_b)
    
    λ_fvariabels = classify_flange_for_flexure(w)
    λ_wvariabels = classify_web_for_flexure(w)

    λ_f, λ_pf, λ_rf, λ_fclass = λ_fvariabels
    λ_w, λ_pw, λ_rw, λ_wclass = λ_wvariabels

    if λ_wclass == :compact
        if λ_fclass == :compact
            M_n = flexure_capacity_f2(w, L_b)
        else
            M_n = flexure_capacity_f3(w, L_b, λ_f, λ_pf, λ_rf, λ_fclass)
        end
    elseif λ_wclass == :noncompact
        error("not implemented")
    else
        error("not implemented")
    end

    return M_n
end
