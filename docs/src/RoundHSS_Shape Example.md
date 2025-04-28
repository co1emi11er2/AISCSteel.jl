```@meta
CollapsedDocStrings = true
```

# RoundHSS_Shape Example

See link below for the current RoundHSS_Shapes from the AISC v16 steel database.

- [Round HSS Shapes](@ref)

## Constructing a RoundHSS_Shape:

Before constructing, import the `AISCSteel` package. Also import the `StructuralUnits` package since we will use it later on.

```@example rhss_shape
using StructuralUnits
import AISCSteel
import AISCSteel.Shapes.RoundHSS_Shapes as rhss
```

Now that the package has been imported, lets construct a HSS20.000x0.500.

``` @example rhss_shape
rhss_shape = rhss.RoundHSS_Shape("HSS20.000x0.500", F_y=46ksi)
```

The following went and searched through the AISC v16 steel database and pulled the relevant info to construct a `RoundHSS_Shape`. You can now access information in the struct like so:

The overall diameter of the shape:

``` @example rhss_shape
rhss_shape.OD
```

The weight of the RoundHSS_Shape:

``` @example rhss_shape
rhss_shape.weight
```

## Flexure Capacity of RoundHSS_Shape:

See link below for the available functions relating to flexure for the RoundHSS_Shape member:

- [Flexure API for Round HSS Shapes](@ref)

### Compact Shape

We can calculate the flexural capacity of the HSS20.000x0.500 shape we just constructed:

```@example rhss_shape

ϕ_b = 0.9
M_n = rhss.Flexure.calc_Mn(rhss_shape)
ϕM_nx = ϕ_b * M_n
```

Lets see what the `calc_Mn` function did:

```@example rhss_shape
using Handcalcs
@handcalcs M_n = rhss.Flexure.calc_Mn(rhss_shape)
```

### Non-Compact Shape

We can calculate the flexural capacity of the HSS20.000x0.375 shape:

```@example rhss_shape
rhss_shape = rhss.RoundHSS_Shape("HSS20.000x0.375", F_y=46ksi)
ϕ_b = 0.9
M_n = rhss.Flexure.calc_Mn(rhss_shape)
ϕM_nx = ϕ_b * M_n
```

Lets see what the `calc_Mn` function did:

```@example rhss_shape
using Handcalcs
@handcalcs M_n = rhss.Flexure.calc_Mn(rhss_shape)
```
