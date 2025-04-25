```@meta
CollapsedDocStrings = true
```

# WShape Example

See link below for the current IShapes from the AISC v16 steel database.

- [IShapes](@ref)

## Constructing a WShape:

Before constructing, import the `AISCSteel` package. Also import the `StructuralUnits` package since we will use it later on.

```@example wshape
using StructuralUnits
import AISCSteel
import AISCSteel.Shapes.IShapes.RolledIShapes as ris
```

!!! note "Importing the Package"
    The reason to call `using` for `StructuralUnits` is so the variables like `ft`, `inch`, `kip`, etc are available automatically to you. Using the `import` for `AISCSteel` is better so the functions are still contained in the `AISCSteel` package. This is how `AISCSteel` was intened to be used. The structure of the package will help guide you to where you want to go. As you type the `.`, suggestions will pop up giving you an idea of where you need to go. You may have to hit `Tab` to see the suggestions. In the Julia REPL you will need to hit `Tab` twice to see the list of suggestions.

Now that the package has been imported, lets construct a W14X90.

``` @example wshape
w = ris.WShape("W14x90")
```

The following went and searched through the AISC v16 steel database and pulled the relevant info to construct a `WShape`. You can now access information in the struct like so:

The width of the flange:

``` @example wshape
w.b_f
```

The weight of the WShape:

``` @example wshape
w.weight
```

## Compression Capacity of WShape:

See link below for the available functions relating to compression for the WShape member:

- [Compression API for IShapes](@ref)

We can calculate the compressive capacity of the W14X90 shape we just constructed:

```@example wshape

L_cx = L_cy = 20ft
ϕ_c = 0.9
P_n = ris.Compression.calc_Pn(w, L_cx, L_cy)
ϕP_n = ϕ_c * P_n
```

This is great. However, as engineers, we would like it if we could see what the function did. That is where [Handcalcs.jl](https://github.com/co1emi11er2/Handcalcs.jl) comes in. This package can look into the function and show you what the function did. All you need to do is type `@handcalcs` in front of the line that called the `calc_Pn` function:

```@example wshape
using Handcalcs
set_handcalcs(precision=2) # sets number of decimals displayed

@handcalcs P_n = ris.Compression.calc_Pn(w, L_cx, L_cy)
```

Wow! No more black boxes! 

!!! note "AISCSteel and Handcalcs"
    AISCSteel has been designed with [Handcalcs.jl](https://github.com/co1emi11er2/Handcalcs.jl) in mind. So if you are in an environment like [Pluto](https://plutojl.org/) or [Jupyter Notebook](https://jupyter.org/), you can use `@handcalcs` to understand what is going on inside the function. You can also use it to generate nice, readable calculations. See [here](https://github.com/co1emi11er2/Handcalcs.jl/blob/master/examples/aisc_example.pdf). There is also an extensive demo to see more functionality. See the [Handcalcs Demo](https://featured.plutojl.org/math/handcalcsdemo).

## Flexure Capacity of WShape:

See link below for the available functions relating to flexure for the WShape member:

- [Flexure API for IShapes](@ref)

### Major Axis Bending

We can calculate the flexural capacity about the x-axis of the W14X90 shape we just constructed:

```@example wshape

L_b = 20ft
ϕ_b = 0.9
M_nx = ris.Flexure.calc_Mnx(w, L_b)
ϕM_nx = ϕ_b * M_nx
```

Lets see what the `calc_Mnx` function did:

```@example wshape
@handcalcs M_nx = ris.Flexure.calc_Mnx(w, L_b)
```

### Minor Axis Bending

We can calculate the flexural capacity about the y-axis of the W14X90 shape we just constructed:

```@example wshape

M_ny = ris.Flexure.calc_Mny(w)
ϕM_ny = ϕ_b * M_ny
```

Lets see what the `calc_Mny` function did:

```@example wshape
@handcalcs M_ny = ris.Flexure.calc_Mny(w)
```