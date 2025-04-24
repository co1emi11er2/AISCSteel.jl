```@meta
CollapsedDocStrings = true
```

# WTShape Example

See link below for the current WTShapes from the AISC v16 steel database.

- [WTShapes](@ref)

## Constructing a WTShape:

Before constructing, import the `AISCSteel` package. Also import the `StructuralUnits` package since we will use it later on.

```@example wtshape
using Revise # this is for Handcalcs.jl to work properly
using StructuralUnits
import AISCSteel
import AISCSteel.Shapes.WTShapes as wts
```

``` @example wtshape
wt = wts.WTShape("WT5x6")
```

The following went and searched through the AISC v16 steel database and pulled the relevant info to construct a `WTShape`. You can now access information in the struct like so:

The width of the flange:

``` @example wtshape
wt.b_f
```

The weight of the WTShape:

``` @example wtshape
wt.weight
```

## Compression Capacity of WTShape:

See link below for the available functions relating to compression for the WTShape member:

- [Compression API for WTShapes](@ref)

We can calculate the compressive capacity of the WT5X6 shape we just constructed:

```@example wtshape

L_cx = L_cy = L_cz = 12ft
ϕ_c = 0.9
P_n = wts.Compression.calc_Pn(wt, L_cx, L_cy, L_cz)
ϕP_n = ϕ_c * P_n
```

Lets see what the `calc_Pn` function did:

```@example wtshape
using Handcalcs
set_handcalcs(precision=2) # sets number of decimals displayed

@handcalcs P_n = wts.Compression.calc_Pn(wt, L_cx, L_cy, L_cz)
```

## Flexure Capacity of WTShape:

See link below for the available functions relating to flexure for the WTShape member:

- [Flexure API for WTShapes](@ref)

### Positive Bending

We can calculate the flexural capacity about the x-axis in positive bending of the WT5X6 shape we just constructed:

```@example wtshape

L_b = 0ft
ϕ_b = 0.9
M_nx = wts.Flexure.calc_positive_Mnx(wt, L_b)
ϕM_nx = ϕ_b * M_nx
```

Lets see what the `calc_Mnx` function did:

```@example wtshape
@handcalcs M_nx = wts.Flexure.calc_positive_Mnx(wt, L_b)
```

### Negative Bending

We can calculate the flexural capacity about the y-axis of the WT5X6 shape we just constructed:

```@example wtshape

M_ny = wts.Flexure.calc_negative_Mnx(wt, L_b)
ϕM_ny = ϕ_b * M_ny
```

Lets see what the `calc_Mny` function did:

```@example wtshape
@handcalcs M_ny = wts.Flexure.calc_negative_Mnx(wt, L_b)
```