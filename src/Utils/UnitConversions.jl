module UnitConversions
using StructuralUnits

# preferred L (distance)
to_large_L(x::Real) = x # do nothing if type real
to_large_L(x::Quantity) = x |> ft

to_L(x::Real) = x # do nothing if type real
to_L(x::Quantity) = x |> inch

to_L²(x::Real) = x # do nothing if type real
to_L²(x::Quantity) = x |> inch^2

to_L³(x::Real) = x # do nothing if type real
to_L³(x::Quantity) = x |> inch^3

to_L⁴(x::Real) = x # do nothing if type real
to_L⁴(x::Quantity) = x |> inch^4

# preferred force
to_force(x::Real) = x # do nothing if type real
to_force(x::Quantity) = x |> kip

# preferred moment
to_moment(x::Real) = x # do nothing if type real
to_moment(x::Quantity) = x |> kip*ft

# preferred stress
to_stress(x::Real) = x # do nothing if type real
to_stress(x::Quantity) = x |> ksi

end