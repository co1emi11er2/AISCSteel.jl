module Equations
using StructuralUnits

export EqD3▬1

function EqD3▬1(A_n, U)
    A_e = A_n * U
end

module TblD3⬝1

function case_1()
    U = 1.0
end

function case_2(x̄, l)
    U = 1 - x̄/l
end

function case_3()
    U = 1.0
end

function case_4(l, w, x̄)
    U = ((3*l^2)/(3*l^2 + w^2))*(1 - x̄/l)
end


end

end # module