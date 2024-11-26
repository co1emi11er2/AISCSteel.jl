using CSV, XLSX, TidierData

projectdir(parts...) = normpath(joinpath(@__DIR__, "..", parts...))

db_path = projectdir("aisc-shapes-database-v16.0.xlsx")
xf = XLSX.readxlsx("aisc-shapes-database-v16.0.xlsx")

sh = xf["Database v16.0"]

db = XLSX.gettable(sh)

db = DataFrame(db)

db_steel = @chain db begin
    @rename(shape=AISC_Manual_Label,weight=W, area=A, k=kdes, h_tw=`h/tw`, tan_a=`tan(α)`)
end 

# I-shapes
let
    function get_ishapes(db_steel, type)
        df = @chain db_steel begin
            @filter(Type == !!type)
            @mutate(h = round(h_tw*tw, digits=4))
            @mutate(WGo = if_else(WGo == "–", missing, WGo))
            @select(shape, weight,area,d,bf,tw,tf,k,k1,h,Ix,Zx,Sx,rx,Iy,Zy,Sy,ry,J,Cw,Wno,Sw1,Qf,Qw,rts,ho,PA,PB,PC,PD,T,WGi,WGo)
        end
    end

    function write_ishapes(db_steel, ishape_types)
        for ishape in ishape_types
            db = get_ishapes(db_steel, ishape)
            fname = "$(ishape)_shapes.csv"
            CSV.write(fname, db)
        end
    end

    ishape_types = ["W", "M", "S", "HP"]

    write_ishapes(db_steel, ishape_types)
end

# Channels
let
    function get_cshapes(db, type)
        db_cshape = @chain db begin
            @filter(Type == !!type)
            @mutate(h = round(h_tw*tw, digits=4))
            @select(shape,weight,area,d,bf,tw,tf,k,h,x,eo,xp,Ix,Zx,Sx,rx,Iy,Zy,Sy,ry,J,Cw,Wno,Sw1,Sw2,Sw3,Qf,Qw,ro,H,rts,ho,PA,PB,PC,PD,T,WGi)
        end
    end

    function write_cshapes(db_steel, cshape_types)
        for cshape in cshape_types
            db = get_cshapes(db_steel, cshape)
            fname = "$(cshape)_shapes.csv"
            CSV.write(fname, db)
        end
    end

    cshape_types = ["C", "MC"]

    write_cshapes(db_steel, cshape_types)
end

# Angles
let
    function get_lshapes(db, type)
        db_lshape = @chain db begin
            @filter(Type == !!type)
            @select(shape,weight,area,d,b,t,k,x,y,xp,yp,Ix,Zx,Sx,rx,Iy,Zy,Sy,ry,Iz,rz,Sz,J,Cw,ro,H,tan_a,Iw,zA,zB,zC,wA,wB,wC,SwA,SwB,SwC,SzA,SzB,SzC,PA,PA2,PB)
        end
    end

    function write_lshapes(db_steel, lshape_types)
        for lshape in lshape_types
            db = get_lshapes(db_steel, lshape)
            fname = "$(lshape)_shapes.csv"
            CSV.write(fname, db)
        end
    end

    lshape_types = ["L"]

    write_lshapes(db_steel, lshape_types)
end

# WT
let
    function get_wtshapes(db, type)
        db_lshape = @chain db begin
            @filter(Type == !!type)
            @select(shape,weight,area,d,bf,tw,tf,k,y,yp,Ix,Zx,Sx,rx,Iy,Zy,Sy,ry,J,Cw,ro,H,PA,PB,PC,PD,WGi,WGo)
        end
    end

    function write_wtshapes(db_steel, wtshape_types)
        for wtshape in wtshape_types
            db = get_wtshapes(db_steel, wtshape)
            fname = "$(wtshape)_shapes.csv"
            CSV.write(fname, db)
        end
    end

    wtshape_types = ["WT", "MT", "ST"]

    write_wtshapes(db_steel, wtshape_types)
end

# 2L
let
    function get_2lshapes(db, type)
        db_lshape = @chain db begin
            @filter(Type == !!type)
            @select(shape,weight,area,d,b,t,y,yp,Ix,Zx,Sx,rx,Iy,Zy,Sy,ry,ro,H)
        end
    end

    function write_2lshapes(db_steel, lshape_types)
        for lshape in lshape_types
            db = get_2lshapes(db_steel, lshape)
            fname = "$(lshape)_shapes.csv"
            CSV.write(fname, db)
        end
    end

    lshape_types = ["2L"]

    write_2lshapes(db_steel, lshape_types)
end

# HSS
let
    function write_HSSshapes(db)
        type = "HSS"
        db_HSS = @chain db begin
            @filter(Type == !!type)
            @filter(!contains(shape, "."))
            @select(shape,weight,area,Ht,h,B,b,tnom,tdes,Ix,Zx,Sx,rx,Iy,Zy,Sy,ry,J,C)
        end

        db_HSS_R = @chain db begin
            @filter(Type == !!type)
            @filter(contains(shape, "."))
            @select(shape,weight,area,OD,tnom,tdes,Ix,Zx,Sx,rx,Iy,Zy,Sy,ry,J,C)
        end
        
        CSV.write("HSS_shapes.csv", db_HSS)
        CSV.write("HSS_R_shapes.csv", db_HSS_R)
    end

    write_HSSshapes(db_steel)
end

# HSS
let
    function write_PIPEshapes(db)
        type = "PIPE"
        db_PIPE = @chain db begin
            @filter(Type == !!type)
            @select(shape,weight,area,OD,ID,tnom,tdes,Ix,Zx,Sx,rx,Iy,Zy,Sy,ry,J)
        end
        
        CSV.write("PIPE_shapes.csv", db_PIPE)
    end

    write_PIPEshapes(db_steel)
end

# clean csvs
# gets rid of computer error
function round_floats!(df)
    for col in names(df)
        if eltype(df[!, col]) <: AbstractFloat
            df[!, col] = round.(df[!, col], digits=6)
        end
    end
    df
end

function clean_csvs(csv_list)
    for csv in csv_list
        df = CSV.read(csv, DataFrame)
        round_floats!(df)
        CSV.write(csv, df)
    end
end
csv_list = filter(x -> endswith(x, ".csv"), readdir())

clean_csvs(csv_list)

println("Created AISC csv files")