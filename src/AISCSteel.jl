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
# Constants
##########################################################################################

# Constant Units
const float_ft = typeof(1.0ft)
const float_inch = typeof(1.0inch)
const float_klf = typeof(1.0klf)
const float_plf = typeof(1.0plf)
const float_mph = typeof(1.0mph)
const float_kcf = typeof(1.0kcf)
const float_pcf = typeof(1.0pcf)
const float_ksi = typeof(1.0ksi)
const float_deg = typeof(1.0°)
const float_inch2 = typeof(1.0inch^2)
const float_inch3 = typeof(1.0inch^3)
const float_inch4 = typeof(1.0inch^4)
const float_inch6 = typeof(1.0inch^6)

##########################################################################################
# Includes
##########################################################################################

# include utilities
include("Utils.jl")
include("Classifications.jl")


# include steel shapes
include("Shapes/Steel_Shapes.jl")

# include ishape members
include("Shapes/I_Shapes/I_Shapes.jl")
include("Shapes/I_Shapes/Builtup_I_Shapes/BuiltUpIShapes.jl")
include("Shapes/I_Shapes/Rolled_I_Shapes/WShape.jl")
include("Shapes/I_Shapes/Rolled_I_Shapes/SShape.jl")
include("Shapes/I_Shapes/Rolled_I_Shapes/MShape.jl")
include("Shapes/I_Shapes/Rolled_I_Shapes/HPShape.jl")

# include Flexure
include("Flexure/Flexure.jl")

end
