```@meta
CollapsedDocStrings = true
```

# CShape Example

See link below for the current CShapes from the AISC v16 steel database.

- [CShapes](@ref)

## Constructing a CShape:

Before constructing, import the `AISCSteel` package. Also import the `StructuralUnits` package since we will use it later on.

```@example cshape
using StructuralUnits
import AISCSteel
import AISCSteel.Shapes.CShapes as cs
```

Now that the package has been imported, lets construct a C15x33.9.

``` @example cshape
c = cs.CShape("C15x33.9")
```

The following went and searched through the AISC v16 steel database and pulled the relevant info to construct a `CShape`. You can now access information in the struct like so:

The width of the flange:

``` @example cshape
c.b_f
```

The weight of the CShape:

``` @example cshape
c.weight
```

## Flexure Capacity of CShape:

See link below for the available functions relating to flexure for the CShape member:

- [Flexure API for CShapes](@ref)

### Major Axis Bending

We can calculate the flexural capacity about the x-axis of the C15x33.9 shape we just constructed:

```@example cshape

L_b = 5ft
ϕ_b = 0.9
M_nx = cs.Flexure.calc_Mnx(c, L_b)
ϕM_nx = ϕ_b * M_nx
```

Lets see what the `calc_Mnx` function did:

```@example cshape
using Handcalcs
set_handcalcs(precision=2) # sets number of decimals displayed

@handcalcs M_nx = cs.Flexure.calc_Mnx(c, L_b)
```

### Minor Axis Bending

We can calculate the flexural capacity about the y-axis of the C15x33.9 shape we just constructed:

```@example cshape

M_ny = cs.Flexure.calc_Mny(c)
ϕM_ny = ϕ_b * M_ny
```

Lets see what the `calc_Mny` function did:

```@example cshape
@handcalcs M_ny = cs.Flexure.calc_Mny(c)
```
