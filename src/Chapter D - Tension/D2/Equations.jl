module Equations
using StructuralUnits
import AISCSteel.Conversions as cnv
export EqD2▬1, EqD2▬2

function EqD2▬1(F_y, A_g)
    P_gy = F_y * A_g |> cnv.to_force
end

function EqD2▬2(F_u, A_e)
    P_rn = F_u * A_e |> cnv.to_force
end

end # module
