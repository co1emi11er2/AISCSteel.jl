"""
    struct LShape <: AbstractLShapes

LShape in the AISC steel database.
shape,weight,area,d,b,t,k,x,y,xp,yp,Ix,Zx,Sx,rx,Iy,Zy,Sy,ry,Iz,rz,Sz,J,Cw,ro,H,tan_a,Iw,zA,zB,zC,wA,wB,wC,SwA,SwB,SwC,SzA,SzB,SzC,PA,PA2,PB
# Fields
- `shape`: name of the WShape
- `weight`: weight of section (plf)
- `area`: area of wshape (inch^2)
- `d`: width of shorter leg (inch)
- `b`: width of the longer leg (inch)
- `t`: Thickness of angle leg (inch)
- `k`: Distance from outer face of flange to web toe of fillet used for design (inch)
- `x̄`: Horizontal distance from designated edge of member, as defined in the AISC Steel Construction Manual Part 1, to center of gravity of member (inch)
- `ȳ`: Vertical distance from designated edge of member, as defined in the AISC Steel Construction Manual Part 1, to center of gravity of member (inch)
- `x_p`: Horizontal distance from designated edge of member, as defined in the AISC Steel Construction Manual Part 1, to plastic neutral axis of member (inch)
- `y_p`: Vertical distance from designated edge of member, as defined in the AISC Steel Construction Manual Part 1, to plastic neutral axis of member (inch)
- `I_x`: Moment of inertia about the x-axis (inch^4)
- `Z_x`: Plastic section modulus about the x-axis (inch^3)
- `S_x`: Elastic section modulus about the x-axis (inch^3)
- `r_x`: Radius of gyration about the x-axis (inch)
- `I_y`: Moment of inertia about the y-axis (inch^4)
- `Z_y`: Plastic section modulus about the y-axis (inch^3)
- `S_y`: Elastic section modulus about the y-axis (inch^3)
- `r_y`: Radius of gyration about the y-axis (inch)
- `J`: Torsional constant (inch^4)
- `C_w`: Warping constant (inch^6)
- `r_0`: Polar radius of gyration about the shear center, in.
- `E`: Elastic section modulus (ksi) = 29000ksi
- `F_y`: Yield strength(ksi) = 50ksi
"""
Base.@kwdef struct LShape <: AbstractLShapes
    shape::String
    weight::AISCSteel.Units.float_plf
    area::AISCSteel.Units.float_inch2
    d::AISCSteel.Units.float_inch
    b::AISCSteel.Units.float_inch
    t::AISCSteel.Units.float_inch
    k::AISCSteel.Units.float_inch
    x̄::AISCSteel.Units.float_inch
    ȳ::AISCSteel.Units.float_inch
    x_p::AISCSteel.Units.float_inch
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
    E::AISCSteel.Units.float_ksi = 29000ksi
    F_y::AISCSteel.Units.float_ksi = 50ksi
end

"""
    LShape(shape; E=29000ksi, F_y=50ksi, C_b=1)

Constructor for `LShape`.
"""
function LShape(shape; E=29000ksi, F_y=50ksi)
    csv_file_name = "L_shapes.csv"
    csv_file_path = joinpath("shape files", csv_file_name)
    lookup_col_name = :shape
    lookup_value = uppercase(shape)
    lookup_value = replace(lookup_value, " " => "_") # replace spaces with underscores
    L_shape = AISCSteel.Utils.DatabaseUtils.import_data(lookup_value, lookup_col_name, csv_file_path)

    LShape(
        L_shape.shape,
        L_shape.weight * plf,
        L_shape.area * inch^2,
        L_shape.d * inch,
        L_shape.b * inch,
        L_shape.t * inch,
        L_shape.k * inch,
        L_shape.x * inch,
        L_shape.y * inch,
        L_shape.xp * inch,
        L_shape.yp * inch,
        L_shape.Ix * inch^4,
        L_shape.Zx * inch^3,
        L_shape.Sx * inch^3,
        L_shape.rx * inch,
        L_shape.Iy * inch^4,
        L_shape.Zy * inch^3,
        L_shape.Sy * inch^3,
        L_shape.ry * inch,
        L_shape.J * inch^4,
        L_shape.Cw * inch^6,
        L_shape.ro * inch,
        E,
        F_y
    )
end