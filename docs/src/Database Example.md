```@meta
CollapsedDocStrings = true
```

## AISC Database API

The AISC Steel package provides access to the AISC steel shapes database, allowing users to easily retrieve and utilize information about various steel shapes. There is one function:

```@autodocs
Modules = [AISCSteel.Database]
```

## AISC Database Example

### Loading the WShape Database

This document serves as an example of how to work with the AISC database within the package.

Lets try to load the aisc database for `WShapes`.

``` @example database
import AISCSteel.Database: aisc_database
import AISCSteel.Shapes.IShapes.RolledIShapes as ris
df = aisc_database(ris.WShape)
first(df, 5)
```

Place the shape of the database you want into the function, and the function will return a `DataFrame` with all the aisc shapes.

### Loading the CShape Database

Here is another example loading the aisc database for `CShapes`

``` @example database
import AISCSteel.Shapes.CShapes as cs
df = aisc_database(cs.CShape)
first(df, 5)
```

## Filtering the data

The `aisc_database` function can also be used with a `filter_function` passed as the first argument. A neat way to do this is using the `do` block syntax.

``` @example database
df = aisc_database(ris.WShape) do wshapes
        filter!(wshapes) do w
            w.Ix < 100
        end
        sort!(wshapes, :weight)
     end
first(df, 5)
```

## Use Database to find optimum shapes

You can use the database to step through and find the optimum shape! 

Let's see if we can find the optimum `WShape` for a member that can resist a moment of 250 kip-ft with an unbraced length of 20 ft.

``` @example database
using StructuralUnits
function optimum_shape(M_u, L_b)
    wshapes = aisc_database(ris.WShape) do wshapes
        sort!(wshapes, :weight)
    end

    for w_data in eachrow(wshapes)
        w = ris.WShape(w_data.shape)
        if ris.Flexure.calc_Mnx(w, L_b) * 0.9 >= M_u
            return w
        end
    end
    error("No shape found!")
end

w = optimum_shape(250kip*ft, 20ft)
w.shape
```

Wow! Now you can quickly find optimum members for your designs!