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

Now that the package has been imported, lets construct a L4x4x1/4.

```@example lshape
lshape = ls.LShape("L4x4x1/4")
```

The following went and searched through the AISC v16 steel database and pulled the relevant info to construct a `LShape`. You can now access information in the struct like so:

The width of the longer leg:

```@example lshape
lshape.b
```

The weight of the LShape:

```@example lshape
lshape.weight
```

## Flexure Capacity of LShape:

See link below for the available functions relating to flexure for the LShape member:

- [Flexure API for LShapes](@ref)

### Major Axis Bending

We can calculate the flexural capacity about the x-axis of the L4x4x1/4 shape we just constructed:

```@example lshape

L_b = 6ft
ϕ_b = 0.9
restraint_type = :unrestrained
C_b = 1.14
M_nx = ls.Flexure.calc_positive_Mnx(lshape, L_b, restraint_type, C_b)
ϕM_nx = ϕ_b * M_nx
```

Lets see what the `calc_positive_Mnx` function did:

```@example lshape
using Handcalcs
set_handcalcs(precision=2) # sets number of decimals displayed

@handcalcs M_nx = ls.Flexure.calc_positive_Mnx(lshape, L_b, restraint_type, C_b)
```

### Minor Axis Bending

We can calculate the flexural capacity about the y-axis of the L4x4x1/4 shape we just constructed:

```@example lshape

M_ny = ls.Flexure.calc_positive_Mny(lshape, L_b, restraint_type, C_b)
ϕM_ny = ϕ_b * M_ny
```

Lets see what the `calc_positive_Mny` function did:

```@example lshape
@handcalcs M_ny = ls.Flexure.calc_positive_Mny(lshape, L_b, restraint_type, C_b)
```
