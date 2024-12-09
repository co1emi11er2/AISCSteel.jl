##########################################################################################
# I-Shapes
# NOTE: This is not usable
##########################################################################################
module IShapes

import AISCSteel.Shapes: AbstractSteelShapes

abstract type AbstractIShapes <: AbstractSteelShapes end

abstract type AbstractRolledIShapes <: AbstractIShapes end

abstract type AbstractBuiltUpIShapes <: AbstractIShapes end

# Rolled I-Shapes
include("RolledIShapes/RolledIShapes.jl")

# Built-Up I-Shapes
include("Builtup_I_Shapes/BuiltUpIShapes.jl")

end # module
# struct DoublySymmetricBuiltUpIShape{T, S, F, W} <: AbstractBuiltUpIShapes
#     dw::T
#     tw::T
#     bf::T
#     tf::T
#     E
#     F_y

#     function DoublySymmetricBuiltUpIShape(dw::T, tw, bf, tf, E::S, F_y) where {T, S}
#         flange_class = _dbishape_flange_slenderness_flexure(dw,tw,bf,tf,E,F_y)
#         web_class = _dbishape_web_slenderness_flexure(dw,tw,E,F_y)
#         return new{T, S, flange_class, web_class}(dw, tw, bf, tf, E, F_y)
#     end

# end

# function _dbishape_flange_slenderness_flexure(dw,tw,bf,tf,E,F_y)
#     λ_p = 0.38*sqrt(E/F_y)
#     k_c = min(max(4/(sqrt(dw/tw)),0.35), 0.76)
#     F_L = 0.7*F_y
#     λ_r = 0.95*sqrt(k_c*E/F_L)
#     λ = bf/(2*tf)
#     class = if λ <= λ_p
#                 Compact
#             elseif λ_p < λ < λ_r
#                 Noncompact
#             else
#                 Slender
#             end
# end

# function _dbishape_web_slenderness_flexure(dw,tw,E,F_y)
#     λ_p = 3.76*sqrt(E/F_y)
#     λ_r = 5.70*sqrt(E/F_y)
#     λ = dw/tw
#     class = if λ <= λ_p
#                 Compact
#             elseif λ_p < λ < λ_r
#                 Noncompact
#             else
#                 Slender
#             end
# end

# function flange_slenderness_flexure((;dw,tw,bf,tf,E,F_y)::DoublySymmetricBuiltUpIShape)
#     λ_p = 0.38*sqrt(E/F_y)
#     k_c = min(max(4/(sqrt(dw/tw)),0.35), 0.76)
#     F_L = 0.7*F_y
#     λ_r = 0.95*sqrt(k_c*E/F_L)
#     λ = bf/(2*tf)
#     class = if λ <= λ_p
#                 :compact
#             elseif λ_p < λ < λ_r
#                 :noncompact
#             else
#                 :slender
#             end
# end

# function web_slenderness_flexure((;dw,tw,E,F_y)::DoublySymmetricBuiltUpIShape)
#     λ_p = 3.76*sqrt(E/F_y)
#     λ_r = 5.70*sqrt(E/F_y)
#     λ = dw/tw
#     class = if λ <= λ_p
#                 :compact
#             elseif λ_p < λ < λ_r
#                 :noncompact
#             else
#                 :slender
#             end
# end

# struct SinglySymmetricBuiltUpIShape{T} <: AbstractBuiltUpIShapes
#     dw::T
#     tw::T
#     bf_top::T
#     tf_top::T
#     bf_bot::T
#     tf_bot::T
# end
