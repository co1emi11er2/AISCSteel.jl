# Getting Started

Before moving onto the Examples, it is important to understand the structure of the package and the best way to navigate through it. Please read below. 

Below is a basic outline of how to get started with AISCSteel.

- [Installation](@ref)
- [Organization of AISCSteel](@ref)
- [Navigating the Package](@ref)
- [Examples](@ref)

## Installation

This package is registered in the Julia registry, so to install it you can just
run:

```julia
import Pkg
Pkg.add("AISCSteel")
```

## Importing the Package

Once the `AISCSteel` package has been installed, you can import the package. There are two ways to do this in julia, with the `using` keyword or with the `import` keyword. Both have their strengths. The `using` keyword is used when you want to import the package and additional elements that the developer of the package has decided. The `import` keyword just brings the package into the environment. With `AISCSteel`, use the `import` keyword.

```julia
import AISCSteel
```

## Organization of AISCSteel

AISCSteel contains many different equations that are in the AISCSteel manual. In order to organize these well,  `AISCSteel` uses many different submodules. Think of submodules as folders. These submodules are organized in such a way to mirror the organization of the AISCSteel manual. They can be accessed using the `.` syntax. 

To give an example, lets say I wanted to access Equation F2-1 in the AISC steel manual. This equation is located in Chapter F, Section F2. In the AISCSteel package you can access this equation by the following:

```julia
AISCSteel.ChapterFFlexure.F2.Equations.EqF2▬1(F_y, Z_x)
```

However, without the AISC manual, it would be difficult to understand what that function did. In this case, that function is the equation to calculate the nominal moment capacity for yielding of the flange (which is the plastic moment in this case). You could use one of the following functions instead:

```julia
AISCSteel.ChapterFFlexure.F2.calc_Mp(F_y, Z_x)
AISCSteel.ChapterFFlexure.F2.calc_MnFY(M_p)
```

The `calc_Mp` function only calls the `EqF2▬1` function, so it is the same thing. This way if that reference of "F2-1" were to change in future versions of the AISC manual, say it becomes "F2▬2", then the `EqF2-1` equation could be updated to `EqF2-2` and the `calc_Mp` could then call `EqF2-2`, but all the other functions that call `calc_Mp` would not need to be updated. That is why it is recommended to not call `EqF2-2` in your own package, since that may change in future versions of the AISC manual. 

## Navigating the Package

AISCSteel was organized in such a way that it should be intuative for someone who is familiar with the AISC manual. But in order for you to navigate, you need to take advantage of the `.` syntax in julia and julia's language server that gives you helpful information.

See the example below in the julia REPL:

```julia-repl
julia> AISCSteel.
ChapterBDesignRequirements  ChapterECompression
ChapterFFlexure             Shapes
Units                       Utils
datadir                     eval
include                     projectdir
julia> AISCSteel.
```

After typing `.` and then hitting `Tab` twice in the REPL, a list of available objects are shown. This can then lead you to where you intend to go. Lets say I wanted to access a certain shape in the AISC database. Lets say it was a W14x90. From the list, it looks like I should go to the Shapes submodule.

```julia-repl
julia> AISCSteel.Shapes.
AbstractSteelShapes  CShapes
HSS_Shapes           IShapes
LShapes              RoundHSS_Shapes
WTShapes             eval
include
julia> AISCSteel.Shapes.
```

Next I would guess IShapes.

```julia-repl
julia> AISCSteel.Shapes.IShapes.
AbstractBuiltUpIShapes  AbstractIShapes
AbstractRolledIShapes   BuiltUpIShapes
RolledIShapes           eval
include
julia> AISCSteel.Shapes.IShapes.
```
I would then guess RolledIShapes.

```julia-repl
julia> AISCSteel.Shapes.IShapes.RolledIShapes.
Compression  Flexure
HPShape      MShape
SShape       WShape
eval         include
julia> AISCSteel.Shapes.IShapes.RolledIShapes.
```

Then WShape.

```julia-repl
julia> AISCSteel.Shapes.IShapes.RolledIShapes.WShape("W14x90")
AISCSteel.Shapes.IShapes.RolledIShapes.WShape("W14X90", 90.0 plf, 26.5 inch^2, 14.0 inch, 14.5 inch, 0.44 inch, 0.71 inch, 1.31 inch, 1.4375 inch, 11.396 inch, 999.0 inch^4, 157.0 inch^3, 143.0 inch^3, 6.14 inch, 362.0 inch^4, 75.6 inch^3, 49.9 inch^3, 3.7 inch, 4.06 inch^4, 16000.0 inch^6, 48.2 inch^2, 124.0 inch^4, 33.2 inch^3, 77.1 inch^3, 4.1 inch, 13.3 inch, 69.6 inch, 84.1 inch, 42.5 inch, 57.0 inch, 10.0 inch, 5.5 inch, 0.0 inch, 29000.0 ksi, 50.0 ksi)
```

!!! note "Reduce amount of `.`'s"
    You may be thinking that is too many layers to get to anything. However, for most use cases, you will be working with a specific shape. What you will want to do is set a variable at the submodule with the specific shape you will be using. For example, with the Rolled I-Shapes you can set a variable `ris` to reduce the amount of `.`'s.

    ```julia-repl
    julia> import AISCSteel.Shapes.IShapes.RolledIShapes as ris

    julia> ris.
    Compression  Flexure
    HPShape      MShape
    SShape       WShape
    eval         include
    julia> ris.
    ```

## Examples

Next move on to the Examples to see basic use cases:

- [WShape Example](@ref)
- [WTShape Example](@ref)
- [CShape Example](@ref)
- [HSS_Shape Example](@ref)
- [RoundHSS_Shape Example](@ref)
