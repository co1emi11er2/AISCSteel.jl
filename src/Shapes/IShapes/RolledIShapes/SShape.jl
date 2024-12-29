##########################################################################################
# SShape struct and initialization methods
##########################################################################################

"""
    struct SShape <: AbstractRolledIShapes

SShape in the AISC steel database.

# Fields

- `shape`: name of the SShape
- `weight`: weight of section (plf)
- `area`: area of wshape (inch2)
- `d`: depth of wshape (inch)
- `b_f`: width of flange (inch)
- `t_w`: thickness of web (inch)
- `t_f`: thickness of flange (inch)
- `k`: Distance from outer face of flange to web toe of fillet used for design (inch)
- `k_1`: Distance from web center line to flange toe of fillet used for detailing (inch)
- `h`: clear distance between flanges less the fillets (inch)
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
- `Q_f`: Statical moment for a point in the flange directly above the vertical edge of the web, as used in AISC Design Guide 9 (inch3)
- `Q_w`: Statical moment for a point at mid-depth of the cross section, as used in AISC Design Guide 9 (inch3)
- `r_ts`: Effective radius of gyration (inch)
- `h_0`: Distance between the flange centroids (inch)
- `PA`: Shape perimeter minus one flange surface (or short leg surface for a single angle), as used in Design Guide 19 (inch)
- `PB`: Shape perimeter, as used in AISC Design Guide 19 (inch)
- `PC`: Box perimeter minus one flange surface, as used in Design Guide 19 (inch)
- `PD`: Box perimeter, as used in AISC Design Guide 19 (inch)
- `T`: Distance between web toes od fillets at the top and bottom of web (inch)
- `WG_i`: The workable gage for the inner fastener holes in the flange that provides for entering and tightening clearances and edge distance and spacing requirements. The actual size, combination, and orientation of fastener components should be compared with the geometry of the cross section to ensure compatibility. See AISC Manual Part 1 for additional information (inch)
- `WG_0`: The bolt spacing between inner and outer fastener holes when the workable gage is compatible with four holes across the flange. See AISC Manual Part 1 for additional information (inch)
- `E`: Elastic section modulus (ksi) = 29000ksi
- `F_y`: Yield strength(ksi) = 50ksi
"""
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
    F_y::AISCSteel.Units.float_ksi = 50ksi
end

"""
    SShape(shape; E=29000ksi, F_y=50ksi, C_b=1)

Constructor for `SShape`.
"""
function SShape(shape; E=29000ksi, F_y=50ksi, C_b=1)
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
