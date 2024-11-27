##########################################################################################
# C-Shapes
##########################################################################################

abstract type AbstractCShapes <: AbstractSteelShapes end 

Base.@kwdef struct CShape <: AbstractCShapes
    shape::String
    weight::float_plf
    area::float_inch2
    d::float_inch
    b_f::float_inch
    t_w::float_inch
    t_f::float_inch
    k::float_inch
    h::float_inch
    x::float_inch4
    e_0::float_inch4
    x_p::float_inch4
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
    S_w2::float_inch6
    S_w3::float_inch6
    Q_f::float_inch3
    Q_w::float_inch3
    r_0::float_inch
    H::Float64
    r_ts::float_inch
    h_0::float_inch
    PA::float_inch
    PB::float_inch
    PC::float_inch
    PD::float_inch
    T::float_inch
    WG_i::float_inch
    E::float_ksi = 29000ksi
    F_y::float_ksi = 60ksi
    C_b::Float64 = 1.0
end

function CShape(shape; E=29000ksi, F_y=60ksi, C_b=1)
    csv_file_name = "C_shapes.csv"
    csv_file_path = joinpath("shape files", csv_file_name)
    lookup_col_name = :shape
    lookup_value = uppercase(shape)
    cshape = import_data(lookup_value, lookup_col_name, csv_file_path)

    WGi = ismissing(cshape.WGi) ? 0*inch : cshape.WGi*inch
    
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
        F_y,
        C_b
    )
end

Base.@kwdef struct MCShape <: AbstractCShapes
    shape::String
    weight::float_plf
    area::float_inch2
    d::float_inch
    b_f::float_inch
    t_w::float_inch
    t_f::float_inch
    k::float_inch
    h::float_inch
    x::float_inch4
    e_0::float_inch4
    x_p::float_inch4
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
    S_w2::float_inch6
    S_w3::float_inch6
    Q_f::float_inch3
    Q_w::float_inch3
    r_0::float_inch
    H::Float64
    r_ts::float_inch
    h_0::float_inch
    PA::float_inch
    PB::float_inch
    PC::float_inch
    PD::float_inch
    T::float_inch
    WG_i::float_inch
    E::float_ksi = 29000ksi
    F_y::float_ksi = 60ksi
    C_b::Float64 = 1.0
end

function MCShape(shape; E=29000ksi, F_y=60ksi, C_b=1)
    csv_file_name = "MC_shapes.csv"
    csv_file_path = joinpath("shape files", csv_file_name)
    lookup_col_name = :shape
    lookup_value = uppercase(shape)
    cshape = import_data(lookup_value, lookup_col_name, csv_file_path)

    WGi = ismissing(cshape.WGi) ? 0*inch : cshape.WGi*inch
    
    MCShape(
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
        F_y,
        C_b
    )
end
##########################################################################################
# Design of members for flexure - Section F2
##########################################################################################

function flexure_capacity_f2_variables((;E, F_y, Z_x, S_x, I_y, r_y, C_w, r_ts, J, h_0)::T, L_b, C_b=1) where T <: AbstractCShapes

    c = h_0/2*sqrt(I_y/C_w)
    
    t = flexure_capacity_f2_variables(E, F_y, Z_x, S_x, r_y, r_ts, J, c, h_0, L_b, C_b)

    return t
end

function flexure_capacity_f2((;E, F_y, Z_x, S_x, I_y, r_y, C_w, r_ts, J, h_0) where T <: AbstractCShapes

    c = h_0/2*sqrt(I_y/C_w)

    M_n = flexure_capacity_f2(
        E,
        F_y,
        Z_x,
        S_x,
        r_y,
        h_0,
        J,
        c,
        r_ts,
        L_b,
        C_b
    )

    return M_n
end

##########################################################################################
# Design of members for flexure
##########################################################################################

function flexure_capacity(c::T, L_b, C_b=1) where T <: AbstractCShapes
    
    M_n = flexure_capacity_f2(c, L_b, C_b)

    return M_n
end