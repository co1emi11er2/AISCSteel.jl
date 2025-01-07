##########################################################################################
##########################################################################################
# Design of members for flexure
##########################################################################################
##########################################################################################
module ChapterFFlexure
using StructuralUnits

# Section F1
include("F1/F1.jl")

# Section F2
include("F2/F2.jl")

# Section F3
include("F3/F3.jl")

# Section F4
include("F4/F4.jl")

# Section F5
include("F5/F5.jl")

# Section F6
include("F6/F6.jl")

# Section F7
include("F7/F7.jl")

# Section F8
include("F8/F8.jl")

# Section F9
include("F9/F9.jl")

# Section F10
include("F10/F10.jl")

# Section F11
include("F11/F11.jl")

# Section F12
include("F12/F12.jl")

# Section F13
include("F13/F13.jl")

# classification functions
function classify_flange_major_axis end
function classify_flange_minor_axis end
function classify_web end
function classify_section end

# moment functions
function calc_positive_Mnx end
function calc_negative_Mnx end
function calc_Mny end

end
