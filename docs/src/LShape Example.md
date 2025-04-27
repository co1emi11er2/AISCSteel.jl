```@meta
CollapsedDocStrings = true
```

# LShape Example

See link below for the current LShapes from the AISC v16 steel database.

- [LShapes](@ref)

## Constructing a LShape:

Before constructing, import the `AISCSteel` package. Also import the `StructuralUnits` package since we will use it later on.

```@example lshape
using StructuralUnits
import AISCSteel
import AISCSteel.Shapes.LShapes as ls
```

Now that the package has been imported, lets construct a W14X90.

``` @example lshape
c = ls.LShape("L4x4x1/4")
```

The following went and searched through the AISC v16 steel database and pulled the relevant info to construct a `LShape`. You can now access information in the struct like so:

The width of the longer leg:

``` @example lshape
c.b
```

The weight of the LShape:

``` @example lshape
c.weight
```

## Flexure Capacity of LShape:

See link below for the available functions relating to flexure for the LShape member:

- [Flexure API for LShapes](@ref)

### Major Axis Bending

We can calculate the flexural capacity about the x-axis of the W14X90 shape we just constructed:

```@example lshape

L_b = 5ft
ϕ_b = 0.9
M_nx = ls.Flexure.calc_Mnx(c, L_b)
ϕM_nx = ϕ_b * M_nx
```

Lets see what the `calc_Mnx` function did:

```@example lshape
using Handcalcs
@handcalcs M_nx = ls.Flexure.calc_Mnx(c, L_b)
```

### Minor Axis Bending

We can calculate the flexural capacity about the y-axis of the W14X90 shape we just constructed:

```@example lshape

M_ny = ls.Flexure.calc_Mny(c)
ϕM_ny = ϕ_b * M_ny
```

Lets see what the `calc_Mny` function did:

```@example lshape
@handcalcs M_ny = ls.Flexure.calc_Mny(c)
```
