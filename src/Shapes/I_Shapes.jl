abstract type AbstractIShapes <: AbstractSteelShapes end 

abstract type AbstractBuiltUpIShapes <: AbstractIShapes end 

struct Compact end
struct Noncompact end
struct Slender end

struct DoublySymmetricBuiltUpIShape{T, S, F, W} <: AbstractBuiltUpIShapes
    dw::T
    tw::T
    bf::T
    tf::T
    E
    F_y

    function DoublySymmetricBuiltUpIShape(dw::T, tw, bf, tf, E::S, F_y) where {T, S}
        flange_class = _dbishape_flange_slenderness_flexure(dw,tw,bf,tf,E,F_y)
        web_class = _dbishape_web_slenderness_flexure(dw,tw,E,F_y)
        return new{T, S, flange_class, web_class}(dw, tw, bf, tf, E, F_y)
    end

end

function _dbishape_flange_slenderness_flexure(dw,tw,bf,tf,E,F_y)
    λ_p = 0.38*sqrt(E/F_y)
    k_c = min(max(4/(sqrt(dw/tw)),0.35), 0.76)
    F_L = 0.7*F_y
    λ_r = 0.95*sqrt(k_c*E/F_L)
    λ = bf/(2*tf)
    class = if λ <= λ_p
                Compact
            elseif λ_p < λ < λ_r
                Noncompact
            else
                Slender
            end
end

function _dbishape_web_slenderness_flexure(dw,tw,E,F_y)
    λ_p = 3.76*sqrt(E/F_y)
    λ_r = 5.70*sqrt(E/F_y)
    λ = dw/tw
    class = if λ <= λ_p
                Compact
            elseif λ_p < λ < λ_r
                Noncompact
            else
                Slender
            end
end

function flange_slenderness_flexure((;dw,tw,bf,tf,E,F_y)::DoublySymmetricBuiltUpIShape)
    λ_p = 0.38*sqrt(E/F_y)
    k_c = min(max(4/(sqrt(dw/tw)),0.35), 0.76)
    F_L = 0.7*F_y
    λ_r = 0.95*sqrt(k_c*E/F_L)
    λ = bf/(2*tf)
    class = if λ <= λ_p
                :compact
            elseif λ_p < λ < λ_r
                :noncompact
            else
                :slender
            end
end

function web_slenderness_flexure((;dw,tw,E,F_y)::DoublySymmetricBuiltUpIShape)
    λ_p = 3.76*sqrt(E/F_y)
    λ_r = 5.70*sqrt(E/F_y)
    λ = dw/tw
    class = if λ <= λ_p
                :compact
            elseif λ_p < λ < λ_r
                :noncompact
            else
                :slender
            end
end

struct SinglySymmetricBuiltUpIShape{T} <: AbstractBuiltUpIShapes
    dw::T
    tw::T
    bf_top::T
    tf_top::T
    bf_bot::T
    tf_bot::T
end

struct WShape
    shape
    weight
    area
    d
    bf
    tw
    tf
    k
    k1
    Ix
    Zx
    Sx
    rx
    Iy
    Zy
    Sy
    ry
    J
    Cw
    Wno
    Sw1
    Qf
    Qw
    rts
    ho
    PA
    PB
    PC
    PD
    T
    WGi
    WGo
end

function WShape(shape)
    csv_file_name = "W_shapes.csv"
    csv_file_path = joinpath("shape files", csv_file_name)
    lookup_col_name = :shape
    lookup_value = uppercase(shape)
    wshape = import_data(lookup_value, lookup_col_name, csv_file_path)

    WShape(
        wshape.shape,
        wshape.weight,
        wshape.area,
        wshape.d,
        wshape.bf,
        wshape.tw,
        wshape.tf,
        wshape.k,
        wshape.k1,
        wshape.Ix,
        wshape.Zx,
        wshape.Sx,
        wshape.rx,
        wshape.Iy,
        wshape.Zy,
        wshape.Sy,
        wshape.ry,
        wshape.J,
        wshape.Cw,
        wshape.Wno,
        wshape.Sw1,
        wshape.Qf,
        wshape.Qw,
        wshape.rts,
        wshape.ho,
        wshape.PA,
        wshape.PB,
        wshape.PC,
        wshape.PD,
        wshape.T,
        wshape.WGi,
        wshape.WGo,
    )
end