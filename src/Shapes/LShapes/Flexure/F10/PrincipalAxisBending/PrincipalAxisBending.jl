# TODO: Move this to LShape - I don't think we need anything here since equations are the same
# just the section properties change
module PrincipalAxisBending



# include Major Axis Bending
include("MajorAxis/MajorAxis.jl")

# include Minor Axis Bending
include("MinorAxis/MinorAxis.jl")

end