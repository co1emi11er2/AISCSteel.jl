module AISCSteel
using CSV, DataFramesMeta, EnumX, StructuralUnits

export DoublySymmetricBuiltUpIShape, flange_slenderness_flexure, web_slenderness_flexure
export classify_section_for_lb_case10, classify_section_for_lb_case13, classify_section_for_lb_case15
export WShape
export flexure_capacity_f2_1, flexure_capacity_f2_2, flexure_capacity_f2, _calc_Mp
export flexure_capacity_f3_1, flexure_capacity_f3_2, flexure_capacity_f3, _calc_Fcr

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
