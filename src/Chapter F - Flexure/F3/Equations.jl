module Equations

export EqF3▬1, EqF3▬2

function EqF3▬1(M_p, F_y, S_x, λ_f, λ_pf, λ_rf)
    M_nCFLB = M_p - (M_p - 0.7 * F_y * S_x) * ((λ_f - λ_pf) / (λ_rf - λ_pf))
end

function EqF3▬2(E, k_c, S_x, λ_f)
    M_nCFLB = (0.9 * E * k_c * S_x) / (λ_f^2)
end

end # module
