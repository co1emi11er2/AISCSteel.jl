```@meta
CollapsedDocStrings = true
```

# HSS_Shape Example

See link below for the current HSS_Shapes from the AISC v16 steel database.

- [HSS Shapes](@ref)

## Constructing a HSS_Shape:

Before constructing, import the `AISCSteel` package. Also import the `StructuralUnits` package since we will use it later on.

```@example hss_shape
using StructuralUnits
import AISCSteel
import AISCSteel.Shapes.HSS_Shapes as hss
```

Now that the package has been imported, lets construct a HSS10x6x3/16.

``` @example hss_shape
hss_shape = hss.HSS_Shape("HSS10x6x3/16")
```

The following went and searched through the AISC v16 steel database and pulled the relevant info to construct a `HSS_Shape`. You can now access information in the struct like so:

The overall width of the shape:

``` @example hss_shape
hss_shape.B
```

The weight of the HSS_Shape:

``` @example hss_shape
hss_shape.weight
```

## Compression Capacity of HSS_Shape:

See link below for the available functions relating to compression for the HSS_Shape member:

- [Compression API for HSS Shapes](@ref)

We can calculate the compressive capacity of the HSS10x6x3/16 shape we just constructed:

```@example hss_shape

L_cx = L_cy = 12ft
ϕ_c = 0.9
P_n = hss.Compression.calc_Pn(hss_shape, L_cx, L_cy)
ϕP_n = ϕ_c * P_n
```

Lets see what the `calc_Pn` function did:

```@example hss_shape
using Handcalcs
set_handcalcs(precision=2) # sets number of decimals displayed

@handcalcs P_n = hss.Compression.calc_Pn(hss_shape, L_cx, L_cy)
```

## Flexure Capacity of HSS_Shape:

See link below for the available functions relating to flexure for the HSS_Shape member:

- [Flexure API for HSS Shapes](@ref)

### Major Axis Bending

We can calculate the flexural capacity about the x-axis of the HSS10x6x3/16 shape we just constructed:

```@example hss_shape

L_b = 21ft
ϕ_b = 0.9
C_b = 1.14
M_nx = hss.Flexure.calc_Mnx(hss_shape, L_b, C_b)
ϕM_nx = ϕ_b * M_nx
```

Lets see what the `calc_Mnx` function did:

```@example hss_shape
@handcalcs M_nx = hss.Flexure.calc_Mnx(hss_shape, L_b, C_b)
```

### Minor Axis Bending

We can calculate the flexural capacity about the y-axis of the HSS10x6x3/16 shape we just constructed:

```@example hss_shape

M_ny = hss.Flexure.calc_Mny(hss_shape)
ϕM_ny = ϕ_b * M_ny
```

Lets see what the `calc_Mny` function did:

```@example hss_shape
@handcalcs M_ny = hss.Flexure.calc_Mny(hss_shape)
```
