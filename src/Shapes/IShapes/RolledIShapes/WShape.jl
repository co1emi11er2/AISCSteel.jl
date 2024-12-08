

Base.@kwdef struct WShape <: AbstractRolledIShapes
    shape::String
    weight::AISCSteel.float_plf
    area::AISCSteel.float_inch2
    d::AISCSteel.float_inch
    b_f::AISCSteel.float_inch
    t_w::AISCSteel.float_inch
    t_f::AISCSteel.float_inch
    k::AISCSteel.float_inch
    k_1::AISCSteel.float_inch
    h::AISCSteel.float_inch
    I_x::AISCSteel.float_inch4
    Z_x::AISCSteel.float_inch3
    S_x::AISCSteel.float_inch3
    r_x::AISCSteel.float_inch
    I_y::AISCSteel.float_inch4
    Z_y::AISCSteel.float_inch3
    S_y::AISCSteel.float_inch3
    r_y::AISCSteel.float_inch
    J::AISCSteel.float_inch4
    C_w::AISCSteel.float_inch6
    W_no::AISCSteel.float_inch2
    S_w1::AISCSteel.float_inch4
    Q_f::AISCSteel.float_inch3
    Q_w::AISCSteel.float_inch3
    r_ts::AISCSteel.float_inch
    h_0::AISCSteel.float_inch
    PA::AISCSteel.float_inch
    PB::AISCSteel.float_inch
    PC::AISCSteel.float_inch
    PD::AISCSteel.float_inch
    T::AISCSteel.float_inch
    WG_i::AISCSteel.float_inch
    WG_0::AISCSteel.float_inch
    E::AISCSteel.float_ksi = 29000ksi
    F_y::AISCSteel.float_ksi = 60ksi
end

function WShape(shape; E=29000ksi, F_y=60ksi, C_b=1)
    csv_file_name = "W_shapes.csv"
    csv_file_path = joinpath("shape files", csv_file_name)
    lookup_col_name = :shape
    lookup_value = uppercase(shape)
    wshape = AISCSteel.Utils.import_data(lookup_value, lookup_col_name, csv_file_path)

    WGo = ismissing(wshape.WGo) ? 0*inch : wshape.WGo*inch
    
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
        WGo,
        E,
        F_y
    )
end