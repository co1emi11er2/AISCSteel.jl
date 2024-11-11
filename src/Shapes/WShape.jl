##########################################################################################
# WShape struct and initialization methods
##########################################################################################

struct WShape
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
end

function WShape(shape)
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
    )
end

function classify_flange_for_lb((;bf, tf)::WShape, E, F_y)

    b = bf/2
    t = tf
    class = classify_section_for_lb_case10(b, t, E, F_y)

    return class

end

function classify_web_for_lb((;h, tw)::WShape, E, F_y)

    h = h
    tw = tw
    class = classify_section_for_lb_case15(h, tw, E, F_y)

    return class

end

function flexure_capacity_f2((;Zx, Sx, ry, ho, J, rts)::WShape, E, F_y, L_b)
    M = flexure_capacity_f2(
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

    return M
end
