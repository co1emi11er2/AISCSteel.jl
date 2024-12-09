##########################################################################################
# SShape struct and initialization methods
##########################################################################################

Base.@kwdef struct SShape <: AISCSteel.Shapes.IShapes.AbstractRolledIShapes
    shape::String
    weight::AISCSteel.Units.float_plf
    area::AISCSteel.Units.float_inch2
    d::AISCSteel.Units.float_inch
    b_f::AISCSteel.Units.float_inch
    t_w::AISCSteel.Units.float_inch
    t_f::AISCSteel.Units.float_inch
    k::AISCSteel.Units.float_inch
    k_1::AISCSteel.Units.float_inch
    h::AISCSteel.Units.float_inch
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
    Q_f::AISCSteel.Units.float_inch3
    Q_w::AISCSteel.Units.float_inch3
    r_ts::AISCSteel.Units.float_inch
    h_0::AISCSteel.Units.float_inch
    PA::AISCSteel.Units.float_inch
    PB::AISCSteel.Units.float_inch
    PC::AISCSteel.Units.float_inch
    PD::AISCSteel.Units.float_inch
    T::AISCSteel.Units.float_inch
    WG_i::AISCSteel.Units.float_inch
    WG_0::AISCSteel.Units.float_inch
    E::AISCSteel.Units.float_ksi = 29000ksi
    F_y::AISCSteel.Units.float_ksi = 60ksi
end

function SShape(shape; E=29000ksi, F_y=60ksi, C_b=1)
    csv_file_name = "S_shapes.csv"
    csv_file_path = joinpath("shape files", csv_file_name)
    lookup_col_name = :shape
    lookup_value = uppercase(shape)
    ishape = AISCSteel.Utils.import_data(lookup_value, lookup_col_name, csv_file_path)

    WGo = ismissing(ishape.WGo) ? 0 * inch : ishape.WGo * inch

    SShape(
        ishape.shape,
        ishape.weight * plf,
        ishape.area * inch^2,
        ishape.d * inch,
        ishape.bf * inch,
        ishape.tw * inch,
        ishape.tf * inch,
        ishape.k * inch,
        ishape.k1 * inch,
        ishape.h * inch,
        ishape.Ix * inch^4,
        ishape.Zx * inch^3,
        ishape.Sx * inch^3,
        ishape.rx * inch,
        ishape.Iy * inch^4,
        ishape.Zy * inch^3,
        ishape.Sy * inch^3,
        ishape.ry * inch,
        ishape.J * inch^4,
        ishape.Cw * inch^6,
        ishape.Wno * inch^2,
        ishape.Sw1 * inch^4,
        ishape.Qf * inch^3,
        ishape.Qw * inch^3,
        ishape.rts * inch,
        ishape.ho * inch,
        ishape.PA * inch,
        ishape.PB * inch,
        ishape.PC * inch,
        ishape.PD * inch,
        ishape.T * inch,
        ishape.WGi * inch,
        WGo,
        E,
        F_y
    )
end
