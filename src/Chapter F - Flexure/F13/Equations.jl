module Equations
import AISCSteel.Utils.UnitConversions as cnv

export EqF13▬1, EqF13▬2, EqF13▬3, EqF13▬4, EqF13▬5, EqF13▬6, EqF13▬7

function EqF13▬1(F_u, A_fn, A_fg, S_x)
    M_n = ((F_u * A_fn)/A_fg) * S_x |> cnv.to_moment
end

function EqF13▬2(I_yc, I_y)
    0.1 <= I_yc/I_y <= 0.9
end

function EqF13▬3(E, F_y)
    h_tw_max = 12.0 * sqrt(E/F_y)
end

function EqF13▬4(E, F_y)
    h_tw_max = (0.40*E)/F_y
end

function EqF13▬5(w)
    a′ = w |> cnv.to_L
end

function EqF13▬6(w)
    a′ = 1.5 * w |> cnv.to_L
end

function EqF13▬7(w)
    a′ = 2 * w |> cnv.to_L
end

end # module
