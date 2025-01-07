##########################################################################################
# C-Shapes
##########################################################################################
module CShapes

using StructuralUnits
import AISCSteel
import AISCSteel.Shapes: AbstractSteelShapes
abstract type AbstractCShapes <: AbstractSteelShapes end

# include shapes
include("CShape.jl")
include("MCShape.jl")


# # Include Flexure
include("Flexure/Flexure.jl")

# ##########################################################################################
# # Design of members for flexure - Section F2
# ##########################################################################################

# function flexure_capacity_f2_variables((; E, F_y, Z_x, S_x, I_y, r_y, C_w, r_ts, J, h_0)::T, L_b, C_b=1) where {T<:AbstractCShapes}

#     c = h_0 / 2 * sqrt(I_y / C_w)

#     t = flexure_capacity_f2_variables(E, F_y, Z_x, S_x, r_y, r_ts, J, c, h_0, L_b, C_b)

#     return t
# end

# function flexure_capacity_f2((; E, F_y, Z_x, S_x, I_y, r_y, C_w, r_ts, J, h_0)::T, L_b, C_b=1) where {T<:AbstractCShapes}

#     c = h_0 / 2 * sqrt(I_y / C_w)

#     M_n = flexure_capacity_f2(
#         E,
#         F_y,
#         Z_x,
#         S_x,
#         r_y,
#         h_0,
#         J,
#         c,
#         r_ts,
#         L_b,
#         C_b
#     )

#     return M_n
# end

# ##########################################################################################
# # Design of members for flexure
# ##########################################################################################

# function flexure_capacity(c::T, L_b, C_b=1) where {T<:AbstractCShapes}

#     M_n = flexure_capacity_f2(c, L_b, C_b)

#     return M_n
# end

end # module
