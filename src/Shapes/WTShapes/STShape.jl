"""
    struct STShape <: AbstractWTShapes

STShape in the AISC steel database.

# Fields
- `shape`: name of the WShape
- `weight`: weight of section (plf)
- `area`: area of wshape (inch2)
- `d`: depth of wshape (inch)
- `b_f`: width of flange (inch)
- `t_w`: thickness of web (inch)
- `t_f`: thickness of flange (inch)
- `k`: Distance from outer face of flange to web toe of fillet used for design (inch)
- `ȳ`: 
- `y_p`:
- `I_x`: Moment of inertia about the x-axis (inch4)
- `Z_x`: Plastic section modulus about the x-axis (inch3)
- `S_x`: Elastic section modulus about the x-axis (inch3)
- `r_x`: Radius of gyration about the x-axis (inch)
- `I_y`: Moment of inertia about the y-axis (inch4)
- `Z_y`: Plastic section modulus about the y-axis (inch3)
- `S_y`: Elastic section modulus about the y-axis (inch3)
- `r_y`: Radius of gyration about the y-axis (inch)
- `J`: Torsional constant (inch4)
- `C_w`: Warping constant (inch6)
- `r_0`:
- `H`:
- `E`: Elastic section modulus (ksi) = 29000ksi
- `F_y`: Yield strength(ksi) = 50ksi
"""
Base.@kwdef struct STShape <: AbstractWTShapes
    shape::String
    weight::AISCSteel.Units.float_plf
    area::AISCSteel.Units.float_inch2
    d::AISCSteel.Units.float_inch
    b_f::AISCSteel.Units.float_inch
    t_w::AISCSteel.Units.float_inch
    t_f::AISCSteel.Units.float_inch
    k::AISCSteel.Units.float_inch
    ȳ::AISCSteel.Units.float_inch
    y_p::AISCSteel.Units.float_inch
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
    r_0::AISCSteel.Units.float_inch
    H::Float64
    E::AISCSteel.Units.float_ksi = 29000ksi
    F_y::AISCSteel.Units.float_ksi = 50ksi
end

"""
    STShape(shape; E=29000ksi, F_y=50ksi, C_b=1)

Constructor for `STShape`.
"""
function STShape(shape; E=29000ksi, F_y=50ksi)
    csv_file_name = "ST_shapes.csv"
    csv_file_path = joinpath("shape files", csv_file_name)
    lookup_col_name = :shape
    lookup_value = uppercase(shape)
    wt_shape = AISCSteel.Utils.DatabaseUtils.import_data(lookup_value, lookup_col_name, csv_file_path)

    STShape(
        wt_shape.shape,
        wt_shape.weight * plf,
        wt_shape.area * inch^2,
        wt_shape.d * inch,
        wt_shape.bf * inch,
        wt_shape.tw * inch,
        wt_shape.tf * inch,
        wt_shape.k * inch,
        wt_shape.y * inch,
        wt_shape.yp * inch,
        wt_shape.Ix * inch^4,
        wt_shape.Zx * inch^3,
        wt_shape.Sx * inch^3,
        wt_shape.rx * inch,
        wt_shape.Iy * inch^4,
        wt_shape.Zy * inch^3,
        wt_shape.Sy * inch^3,
        wt_shape.ry * inch,
        wt_shape.J * inch^4,
        wt_shape.Cw * inch^6,
        wt_shape.ro * inch,
        wt_shape.H,
        E,
        F_y
    )
end
