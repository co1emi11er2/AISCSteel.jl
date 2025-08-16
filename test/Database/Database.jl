import AISCSteel.Database: aisc_database
import AISCSteel.Shapes.IShapes.RolledIShapes: WShape, SShape, MShape, HPShape
import AISCSteel.Shapes.WTShapes: WTShape, MTShape, STShape
import AISCSteel.Shapes.HSS_Shapes: HSS_Shape
import AISCSteel.Shapes.RoundHSS_Shapes: RoundHSS_Shape
import AISCSteel.Shapes.LShapes: LShape
import AISCSteel.Shapes.CShapes: CShape, MCShape

##########################################################################################
# AISC Databases
##########################################################################################

function test_database(SteelShape, shape_names)
    db = aisc_database(SteelShape)
    @test first(db.shape, 2) == shape_names
end

# Rolled I Shapes
test_database(WShape, ["W44X408", "W44X368"])
test_database(SShape, ["S24X121", "S24X106"])
test_database(MShape, ["M12.5X12.4", "M12.5X11.6"])
test_database(HPShape, ["HP18X204", "HP18X181"])

# WT Shapes
test_database(WTShape, ["WT22X204", "WT22X184"])
test_database(MTShape, ["MT6.25X6.2", "MT6.25X5.8"])
test_database(STShape, ["ST12X60.5", "ST12X53"])

# HSS Shapes
test_database(HSS_Shape, ["HSS34X10X1", "HSS34X10X7/8"])

# Round HSS Shapes
test_database(RoundHSS_Shape, ["HSS28.000X1.000", "HSS28.000X0.875"])

# L Shapes
test_database(LShape, ["L12X12X1-3/8", "L12X12X1-1/4"])

# C Shapes
test_database(CShape, ["C15X50", "C15X40"])
test_database(MCShape, ["MC18X58", "MC18X51.9"])


############################################################################################
# AISC Databases with Filter
############################################################################################

df = aisc_database(WShape) do shapes
        filter!(shapes) do shape
            shape.Ix < 100
        end
end
@test first(df.shape, 2) == ["W12X14", "W10X19"]