module DatabaseUtils
using CSV, DataFramesMeta
import AISCSteel
"""
    import_data(lookup_value, lookup_col_name::Symbol, data_location::String)

Searches the specified data location and filters for the first row of data found where
the value in the column specified is equal to the lookup value.

# Parameters
- `lookup_value` - The value to search for
- `lookup_col_name`::Symbol - the column name to search in
- `csv_file_path`::String - The name of csv file in the data directory
"""
function import_data(lookup_value, lookup_col_name::Symbol, csv_file_path::String)
    df = CSV.read(AISCSteel.datadir(csv_file_path), DataFrame)

    @subset!(df, $lookup_col_name .== lookup_value)
    return first(df)
end

end