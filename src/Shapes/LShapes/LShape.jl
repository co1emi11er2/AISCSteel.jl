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
- `r_z`: Radius of gyration about the z-axis (inch)
- `J`: Torsional constant (inch^4)
- `C_w`: Warping constant (inch^6)
- `r_0`: Polar radius of gyration about the shear center, in.
- `S_wA`: Elastic section modulus about the w-axis at Point A on the cross section
- `S_wC`: Elastic section modulus about the w-axis at Point C on the cross section
- `S_zA`: Elastic section modulus about the z-axis at Point A on the cross section
- `S_zB`: Elastic section modulus about the z-axis at Point B on the cross section
- `S_zC`: Elastic section modulus about the z-axis at Point C on the cross section
- `β_w`: See F11 commentary for values
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
    r_z::AISCSteel.Units.float_inch
    J::AISCSteel.Units.float_inch4
    C_w::AISCSteel.Units.float_inch6
    r_0::AISCSteel.Units.float_inch
    S_wA::AISCSteel.Units.float_inch3
    S_wC::AISCSteel.Units.float_inch3
    S_zA::AISCSteel.Units.float_inch3
    S_zB::AISCSteel.Units.float_inch3
    S_zC::AISCSteel.Units.float_inch3
    β_w::AISCSteel.Units.float_inch
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
        L_shape.rz * inch,
        L_shape.J * inch^4,
        L_shape.Cw * inch^6,
        L_shape.ro * inch,
        L_shape.SwA * inch^3,
        L_shape.SwC * inch^3,
        L_shape.SzA * inch^3,
        L_shape.SzB * inch^3,
        L_shape.SzC * inch^3,
        calc_βw(L_shape.b, L_shape.d) * inch,
        E,
        F_y
    )
end

function calc_βw(b, d)
    if b == d
        β_w = 0
    elseif b == 8
        if d == 6
            β_w = 3.31
        else #d = 4
            β_w = 5.48
        end
    elseif b == 7 #d = 4
        β_w = 4.37
    elseif b == 6
        if d == 4
            β_w = 3.14
        else #d = 3.5
            β_w = 3.69
        end
    elseif b == 5
        if d == 3.5
            β_w = 2.40
        else #d = 3
            β_w = 2.99
        end 
    elseif b == 4
        if d == 3.5
            β_w = 0.87
        else #d = 3
            β_w = 1.65
        end
    elseif b == 3.5
        if d == 3
            β_w = 0.87
        else #d = 2.5
            β_w = 1.62
        end
    elseif b == 3
        if d == 2.5
            β_w = 0.86
        else #d = 2
            β_w = 1.56
        end
    else # b == 2.5
        if d == 2
            β_w = 0.85
        else #d = 1.5
            β_w = 1.49
        end
    end

    return β_w
end
