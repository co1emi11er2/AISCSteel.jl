"""
    struct CShape <: AbstractCShapes

CShape in the AISC steel database.

# Fields

- `shape`: name of the WShape
- `weight`: weight of section (plf)
- `A_g`: area of wshape (inch2)
- `d`: depth of wshape (inch)
- `b_f`: width of flange (inch)
- `t_w`: thickness of web (inch)
- `t_f`: thickness of flange (inch)
- `k`: Distance from outer face of flange to web toe of fillet used for design (inch)
- `h`: clear distance between flanges less the fillets (inch)
- `x`:
- `e_0`:
- `x_p`:
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
- `W_no`: Normalized warping function, as used in Design Guide 9 (inch2)
- `S_w1`: Warping statical moment at point 1 on cross section, as used in AISC Design Guide 9 (inch4)
- `S_w2`:
- `S_w3`:
- `Q_f`: Statical moment for a point in the flange directly above the vertical edge of the web, as used in AISC Design Guide 9 (inch3)
- `Q_w`: Statical moment for a point at mid-depth of the cross section, as used in AISC Design Guide 9 (inch3)
- `r_0`:
- `H`:
- `r_ts`: Effective radius of gyration (inch)
- `h_0`: Distance between the flange centroids (inch)
- `PA`: Shape perimeter minus one flange surface (or short leg surface for a single angle), as used in Design Guide 19 (inch)
- `PB`: Shape perimeter, as used in AISC Design Guide 19 (inch)
- `PC`: Box perimeter minus one flange surface, as used in Design Guide 19 (inch)
- `PD`: Box perimeter, as used in AISC Design Guide 19 (inch)
- `T`: Distance between web toes od fillets at the top and bottom of web (inch)
- `WG_i`: The workable gage for the inner fastener holes in the flange that provides for entering and tightening clearances and edge distance and spacing requirements. The actual size, combination, and orientation of fastener components should be compared with the geometry of the cross section to ensure compatibility. See AISC Manual Part 1 for additional information (inch)
- `G`: Shear modulus of elasticity of steel = 11200ksi
- `E`: Elastic section modulus (ksi) = 29000ksi
- `F_y`: Yield strength(ksi) = 50ksi
"""
Base.@kwdef struct CShape <: AbstractCShapes
    shape::String
    weight::AISCSteel.Units.float_plf
    A_g::AISCSteel.Units.float_inch2
    d::AISCSteel.Units.float_inch
    b_f::AISCSteel.Units.float_inch
    t_w::AISCSteel.Units.float_inch
    t_f::AISCSteel.Units.float_inch
    k::AISCSteel.Units.float_inch
    h::AISCSteel.Units.float_inch
    x::AISCSteel.Units.float_inch
    e_0::AISCSteel.Units.float_inch
    x_p::AISCSteel.Units.float_inch
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
    G::AISCSteel.Units.float_ksi = 11200ksi
    E::AISCSteel.Units.float_ksi = 29000ksi
    F_y::AISCSteel.Units.float_ksi = 50ksi
end

"""
    CShape(shape; G=11200ksi, E=29000ksi, F_y=50ksi, C_b=1)

Constructor for `CShape`.
"""
function CShape(shape; G=11200ksi, E=29000ksi, F_y=50ksi)
    csv_file_name = "C_shapes.csv"
    csv_file_path = joinpath("shape files", csv_file_name)
    lookup_col_name = :shape
    lookup_value = uppercase(shape)
    cshape = AISCSteel.Utils.DatabaseUtils.import_data(lookup_value, lookup_col_name, csv_file_path)
    WGi = cshape.WGi == "–" ? 0 * inch : parse(Float64, cshape.WGi) * inch

    CShape(
        cshape.shape,
        cshape.weight * plf,
        cshape.area * inch^2,
        cshape.d * inch,
        cshape.bf * inch,
        cshape.tw * inch,
        cshape.tf * inch,
        cshape.k * inch,
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
        cshape.ro * inch,
        cshape.H,
        cshape.rts * inch,
        cshape.ho * inch,
        cshape.PA * inch,
        cshape.PB * inch,
        cshape.PC * inch,
        cshape.PD * inch,
        cshape.T * inch,
        WGi,
        G,
        E,
        F_y
    )
end
