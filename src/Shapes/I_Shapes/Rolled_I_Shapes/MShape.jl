##########################################################################################
# SShape struct and initialization methods
##########################################################################################

Base.@kwdef struct MShape <: AbstractRolledIShapes
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
    WG_0::float_inch
    E::float_ksi = 29000ksi
    F_y::float_ksi = 60ksi
end

function MShape(shape; E=29000ksi, F_y=60ksi, C_b=1)
    csv_file_name = "M_shapes.csv"
    csv_file_path = joinpath("shape files", csv_file_name)
    lookup_col_name = :shape
    lookup_value = uppercase(shape)
    ishape = import_data(lookup_value, lookup_col_name, csv_file_path)
    
    WGo = ismissing(ishape.WGo) ? 0*inch : ishape.WGo*inch


    MShape(
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