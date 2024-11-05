module AISCSteel
using CSV, DataFramesMeta
# Directories
projectdir(parts...) = normpath(joinpath(@__DIR__, "..", parts...))
datadir(parts...) = normpath(joinpath(@__DIR__, "..", "data", parts...))

include("Utils.jl")
# Write your package code here.
export DoublySymmetricBuiltUpIShape, flange_slenderness_flexure, web_slenderness_flexure
# include steel shapes
include("Shapes/Steel_Shapes.jl")
include("Shapes/I_Shapes.jl")

end
