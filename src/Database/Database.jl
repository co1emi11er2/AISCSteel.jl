module Database

"""
    aisc_database(SteelShape)
    aisc_database(filter_function::Function, SteelShape)

The `aisc_database` function provides access to the AISC Steel Shapes database.
It can be used to retrieve all shapes or filter them based on a provided function.

# Parameters
- `SteelShape`: A type representing the steel shape, such as `WShape`, `CShape`, `LShape`, etc.
- `filter_function`: An optional function that takes a collection of shapes and returns a filtered collection
  based on specific criteria.

# Returns
- If `SteelShape` is provided, it returns a collection of shapes of that type.
- If `filter_function` is provided, it applies the function to the collection of shapes and returns the filtered results.

# Example
```julia-repl
julia> aisc_database(WShape); # Returns all WShapes from the AISC database.

julia> aisc_database(WShape) do wshapes
            filter!(wshapes) do w
                w.Ix < 100
            end
            sort!(wshapes, :weight)
       end; # Returns WShapes with Ix less than 100 that is sorted by weight.
```
"""
function aisc_database(SteelShape)
    return error("The function `aisc_database` is not implemented for the type: $(typeof(SteelShape)). \nTry `WShape`, `CShape`, etc. instead.")
end

function aisc_database(filter_function::Function, SteelShape)
    return filter_function(aisc_database(SteelShape))
end

end