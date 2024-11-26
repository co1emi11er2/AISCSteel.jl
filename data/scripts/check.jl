using CSV, TidierData

name = "W_shapes"

db_w1 = CSV.read("$name.csv", DataFrame)
db_w2 = CSV.read("../shape files/$name.csv", DataFrame)

for name in names(db_w1)
    name == "h" && continue
    name == "WGo" && continue
    name == "k1" && continue
    if db_w1[!, Symbol(name)] != db_w2[!, Symbol(name)]
        
        println(name)
        if name == "PD"
            r = db_w1[!, Symbol(name)] .- db_w2[!, Symbol(name)]
            println(r)
        end
    end
end
db_w1.h == db_w2.h
