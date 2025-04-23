"""
    struct WTShape <: AbstractWTShapes

WTShape in the AISC steel database.

# Fields
- `shape`: name of the WShape
- `weight`: weight of section (plf)
- `A_g`: area of wshape (inch2)
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
- `PA`: Shape perimeter minus one flange surface (or short leg surface for a single angle), as used in Design Guide 19 (inch)
- `PB`: Shape perimeter, as used in AISC Design Guide 19 (inch)
- `PC`: Box perimeter minus one flange surface, as used in Design Guide 19 (inch)
- `PD`: Box perimeter, as used in AISC Design Guide 19 (inch)
- `WG_i`: The workable gage for the inner fastener holes in the flange that provides for entering and tightening clearances and edge distance and spacing requirements. The actual size, combination, and orientation of fastener components should be compared with the geometry of the cross section to ensure compatibility. See AISC Manual Part 1 for additional information (inch)
- `WG_0`: The bolt spacing between inner and outer fastener holes when the workable gage is compatible with four holes across the flange. See AISC Manual Part 1 for additional information (inch)
- `G`: Shear modulus of elasticity of steel = 11200ksi
- `E`: Elastic section modulus (ksi) = 29000ksi
- `F_y`: Yield strength(ksi) = 50ksi
"""
Base.@kwdef struct WTShape <: AbstractWTShapes
    shape::String
    weight::AISCSteel.Units.float_plf
    A_g::AISCSteel.Units.float_inch2
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
    PA::AISCSteel.Units.float_inch
    PB::AISCSteel.Units.float_inch
    PC::AISCSteel.Units.float_inch
    PD::AISCSteel.Units.float_inch
    WG_i::AISCSteel.Units.float_inch
    WG_0::AISCSteel.Units.float_inch
    G::AISCSteel.Units.float_ksi = 11200ksi
    E::AISCSteel.Units.float_ksi = 29000ksi
    F_y::AISCSteel.Units.float_ksi = 50ksi
end

"""
    WTShape(shape; E=29000ksi, F_y=50ksi, C_b=1)

Constructor for `WTShape`.
"""
function WTShape(shape; G=11200ksi, E=29000ksi, F_y=50ksi)
    csv_file_name = "WT_shapes.csv"
    csv_file_path = joinpath("shape files", csv_file_name)
    lookup_col_name = :shape
    lookup_value = uppercase(shape)
    wt_shape = AISCSteel.Utils.DatabaseUtils.import_data(lookup_value, lookup_col_name, csv_file_path)
    WGo = wt_shape.WGo == "–" ? 0 * inch : parse(Float64, wt_shape.WGo) * inch

    WTShape(
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
        wt_shape.PA * inch,
        wt_shape.PB * inch,
        wt_shape.PC * inch,
        wt_shape.PD * inch,
        wt_shape.WGi * inch,
        WGo,
        G,
        E,
        F_y
    )
end
