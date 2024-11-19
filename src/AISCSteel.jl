module AISCSteel
using CSV, DataFramesMeta, EnumX, StructuralUnits

export DoublySymmetricBuiltUpIShape, flange_slenderness_flexure, web_slenderness_flexure
export classify_section_for_lb_case10, classify_section_for_lb_case13, classify_section_for_lb_case15
export WShape
export flexure_capacity_f2_variables, flexure_capacity_f2_1, flexure_capacity_f2_2, flexure_capacity_f2, _calc_Mp
export flexure_capacity_f3_variables, flexure_capacity_f3_1, flexure_capacity_f3_2, flexure_capacity_f3, _calc_Fcr
export flexure_capacity_f4_variables, flexure_capacity_f4, flexure_capacity_f4_1, flexure_capacity_f4_2, flexure_capacity_f4_3, flexure_capacity_f4_4, _calc_aw, _calc_rt, _calc_FL, _calc_Rpc, _calc_Rpt
export classify_flange_for_flexure, classify_web_for_flexure, classify_section_for_flexure

# Directories
projectdir(parts...) = normpath(joinpath(@__DIR__, "..", parts...))
datadir(parts...) = normpath(joinpath(@__DIR__, "..", "data", parts...))

include("Utils.jl")
include("Classifications.jl")


# include steel shapes
include("Shapes/Steel_Shapes.jl")

# include ishape members
include("Shapes/I_Shapes.jl")
include("Shapes/BuiltUpIShapes.jl")
include("Shapes/WShape.jl")

# include Flexure
include("Flexure/F2.jl")

end
