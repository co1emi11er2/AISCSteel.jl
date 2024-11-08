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
        wshape.weight,
        wshape.area,
        wshape.d,
        wshape.bf,
        wshape.tw,
        wshape.tf,
        wshape.k,
        wshape.k1,
        wshape.Ix,
        wshape.Zx,
        wshape.Sx,
        wshape.rx,
        wshape.Iy,
        wshape.Zy,
        wshape.Sy,
        wshape.ry,
        wshape.J,
        wshape.Cw,
        wshape.Wno,
        wshape.Sw1,
        wshape.Qf,
        wshape.Qw,
        wshape.rts,
        wshape.ho,
        wshape.PA,
        wshape.PB,
        wshape.PC,
        wshape.PD,
        wshape.T,
        wshape.WGi,
        wshape.WGo,
    )
end

function classify_flange_for_lb((;bf, tf)::WShape, E, F_y)

    b = bf/2
    t = tf
    class = classify_section_for_lb_case10(b, t, E, F_y)

    return class

end

function classify_web_for_lb((;T, tw)::WShape, E, F_y)

    h = T
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
