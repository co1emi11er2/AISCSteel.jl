
Base.@kwdef struct CShape <: AbstractCShapes
    shape::String
    weight::AISCSteel.Units.float_plf
    area::AISCSteel.Units.float_inch2
    d::AISCSteel.Units.float_inch
    b_f::AISCSteel.Units.float_inch
    t_w::AISCSteel.Units.float_inch
    t_f::AISCSteel.Units.float_inch
    k::AISCSteel.Units.float_inch
    h::AISCSteel.Units.float_inch
    x::AISCSteel.Units.float_inch4
    e_0::AISCSteel.Units.float_inch4
    x_p::AISCSteel.Units.float_inch4
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
    W_no::AISCSteel.Units.float_inch2
    S_w1::AISCSteel.Units.float_inch4
    S_w2::AISCSteel.Units.float_inch6
    S_w3::AISCSteel.Units.float_inch6
    Q_f::AISCSteel.Units.float_inch3
    Q_w::AISCSteel.Units.float_inch3
    r_0::AISCSteel.Units.float_inch
    H::Float64
    r_ts::AISCSteel.Units.float_inch
    h_0::AISCSteel.Units.float_inch
    PA::AISCSteel.Units.float_inch
    PB::AISCSteel.Units.float_inch
    PC::AISCSteel.Units.float_inch
    PD::AISCSteel.Units.float_inch
    T::AISCSteel.Units.float_inch
    WG_i::AISCSteel.Units.float_inch
    E::AISCSteel.Units.float_ksi = 29000ksi
    F_y::AISCSteel.Units.float_ksi = 60ksi
end

function CShape(shape; E=29000ksi, F_y=60ksi, C_b=1)
    csv_file_name = "C_shapes.csv"
    csv_file_path = joinpath("shape files", csv_file_name)
    lookup_col_name = :shape
    lookup_value = uppercase(shape)
    cshape = AISCSteel.Utils.import_data(lookup_value, lookup_col_name, csv_file_path)

    WGi = ismissing(cshape.WGi) ? 0 * inch : cshape.WGi * inch

    CShape(
        cshape.shape,
        cshape.weight * plf,
        cshape.area * inch^2,
        cshape.d * inch,
        cshape.bf * inch,
        cshape.tw * inch,
        cshape.tf * inch,
        cshape.k * inch,
        cshape.k1 * inch,
        cshape.h * inch,
        cshape.x * inch,
        cshape.eo * inch,
        cshape.xp * inch,
        cshape.Ix * inch^4,
        cshape.Zx * inch^3,
        cshape.Sx * inch^3,
        cshape.rx * inch,
        cshape.Iy * inch^4,
        cshape.Zy * inch^3,
        cshape.Sy * inch^3,
        cshape.ry * inch,
        cshape.J * inch^4,
        cshape.Cw * inch^6,
        cshape.Wno * inch^2,
        cshape.Sw1 * inch^4,
        cshape.Sw2 * inch^6,
        cshape.Sw3 * inch^6,
        cshape.Qf * inch^3,
        cshape.Qw * inch^3,
        cshape.r_0 * inch,
        cshape.H,
        cshape.rts * inch,
        cshape.ho * inch,
        cshape.PA * inch,
        cshape.PB * inch,
        cshape.PC * inch,
        cshape.PD * inch,
        cshape.T * inch,
        WGi * inch,
        E,
        F_y
    )
end
