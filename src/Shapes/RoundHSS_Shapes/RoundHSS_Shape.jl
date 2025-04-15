
"""
    struct RoundHSS_Shape <: AbstractHSS_Shapes

RoundHSS_Shape in the AISC steel database.

# Fields

- `shape`: name of the HSS
- `weight`: weight of section (plf)
- `area`: area of shape (inch2)
- `OD`: outside diameter of round HSS or pipe (inch)
- `t_nom`: nominal thickness of HSS and pipe wall (inch)
- `t_des`: design thickness of HSS and pipe wall (inch)
- `I_x`: Moment of inertia about the x-axis (inch4)
- `Z_x`: Plastic section modulus about the x-axis (inch3)
- `S_x`: Elastic section modulus about the x-axis (inch3)
- `r_x`: Radius of gyration about the x-axis (inch)
- `I_y`: Moment of inertia about the y-axis (inch4)
- `Z_y`: Plastic section modulus about the y-axis (inch3)
- `S_y`: Elastic section modulus about the y-axis (inch3)
- `r_y`: Radius of gyration about the y-axis (inch)
- `J`: Torsional constant (inch4)
- `C`: HSS torsional constant (inch3)
- `E`: Elastic section modulus (ksi) = 29000ksi
- `F_y`: Yield strength(ksi) = 50ksi
"""
Base.@kwdef struct RoundHSS_Shape <: AbstractRoundHSS_Shapes
    shape::String
    weight::AISCSteel.Units.float_plf
    area::AISCSteel.Units.float_inch2
    OD::AISCSteel.Units.float_inch
    t_nom::AISCSteel.Units.float_inch
    t_des::AISCSteel.Units.float_inch
    I_x::AISCSteel.Units.float_inch4
    Z_x::AISCSteel.Units.float_inch3
    S_x::AISCSteel.Units.float_inch3
    r_x::AISCSteel.Units.float_inch
    I_y::AISCSteel.Units.float_inch4
    Z_y::AISCSteel.Units.float_inch3
    S_y::AISCSteel.Units.float_inch3
    r_y::AISCSteel.Units.float_inch
    J::AISCSteel.Units.float_inch4
    C::AISCSteel.Units.float_inch3
    E::AISCSteel.Units.float_ksi = 29000ksi
    F_y::AISCSteel.Units.float_ksi = 50ksi
end

"""
    RoundHSS_Shape(shape; E=29000ksi, F_y=50ksi, C_b=1)

Constructor for `RoundHSS_Shape`.
"""
function RoundHSS_Shape(shape; E=29000ksi, F_y=50ksi, C_b=1)
    csv_file_name = "HSS_R_shapes.csv"
    csv_file_path = joinpath("shape files", csv_file_name)
    lookup_col_name = :shape
    lookup_value = uppercase(shape)
    hss_shape = AISCSteel.Utils.DatabaseUtils.import_data(lookup_value, lookup_col_name, csv_file_path)

    # WGo = ismissing(hss_shape.WGo) ? 0 * inch : hss_shape.WGo * inch

    RoundHSS_Shape(
        hss_shape.shape,
        hss_shape.weight * plf,
        hss_shape.area * inch^2,
        hss_shape.OD * inch,
        hss_shape.tnom * inch,
        hss_shape.tdes * inch,
        hss_shape.Ix * inch^4,
        hss_shape.Zx * inch^3,
        hss_shape.Sx * inch^3,
        hss_shape.rx * inch,
        hss_shape.Iy * inch^4,
        hss_shape.Zy * inch^3,
        hss_shape.Sy * inch^3,
        hss_shape.ry * inch,
        hss_shape.J * inch^4,
        hss_shape.C * inch^3,
        E,
        F_y
    )
end

