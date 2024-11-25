module AISCSteel

##########################################################################################
# Imports
##########################################################################################
using CSV, DataFramesMeta, EnumX, StructuralUnits

##########################################################################################
# Exports
##########################################################################################

# Shape exports
export DoublySymmetricBuiltUpIShape, flange_slenderness_flexure, web_slenderness_flexure
export classify_section_for_lb_case10, classify_section_for_lb_case13, classify_section_for_lb_case15
export WShape

# Flexure exports
export classify_flange_for_flexure, classify_web_for_flexure, classify_section_for_flexure, flexure_capacity

export flexure_capacity_f2_variables, flexure_capacity_f2_1, flexure_capacity_f2_2, flexure_capacity_f2, _calc_Mp
export flexure_capacity_f3_variables, flexure_capacity_f3_1, flexure_capacity_f3_2, flexure_capacity_f3, _calc_Fcr
export flexure_capacity_f4_variables, flexure_capacity_f4, flexure_capacity_f4_1, flexure_capacity_f4_2, flexure_capacity_f4_3, flexure_capacity_f4_4, _calc_aw, _calc_rt, _calc_FL, _calc_Rpc, _calc_Rpt
export flexure_capacity_f5_variables, flexure_capacity_f5, flexure_capacity_f5_1, flexure_capacity_f5_2, flexure_capacity_f5_3, flexure_capacity_f5_4


##########################################################################################
# Paths
##########################################################################################

# Directories
projectdir(parts...) = normpath(joinpath(@__DIR__, "..", parts...))
datadir(parts...) = normpath(joinpath(@__DIR__, "..", "data", parts...))

##########################################################################################
# Includes
##########################################################################################

# include utilities
include("Utils.jl")
include("Classifications.jl")


# include steel shapes
include("Shapes/Steel_Shapes.jl")

# include ishape members
include("Shapes/I_Shapes.jl")
include("Shapes/BuiltUpIShapes.jl")
include("Shapes/WShape.jl")

# include Flexure
include("Flexure/Flexure.jl")

end
