##########################################################################################
##########################################################################################
# Classifications of Sections for Local Buckling - AISC Section B4
##########################################################################################
##########################################################################################
module Classifications

# @enumx CommpressionBucklingType begin
#     Nonslender
#     Slender
# end

# @enumx FlexuralBucklingType begin
#     Compact
#     Noncompact
#     Slender
# end

"""
    classify_section_for_lb_case1(b, t, E, F_y)

Classifies the section of a member subject to axial compression.

Description of applicable member: Flanges of rolled I-shaped sections, plates projecting from rolled I-shaped sections, outstanding legs of pairs of angles connected with continuous contact, flanges of channels, and flanges of tees.

# Arguments
- `b`: width of the plate or half the width of the flange.
- `t`: thickness of the flange.
- `E`: elastic section modulous.
- `F_y`: yield strength of steel.

# Returns
- `CompressionBucklingType` enum whose value is either `Nonslender` or `Slender`

# Reference
- AISC Table B4.1a
"""
function classify_section_for_lb_case1(b, t, E, F_y)
    λ = b / t
    λ_r = 0.56 * sqrt(E / F_y)

    class = if λ <= λ_r
        :nonslender
    else
        :slender
    end

    return class
end

"""
    classify_section_for_lb_case10(b, t, E, F_y)

Classifies the compressive elements of a member subject to flexural.

Description of applicable member: Flanges of rolled I-shaped sections, channels, and tees.

# Arguments
- `b`: width of the plate or half the width of the flange.
- `t`: thickness of the flange.
- `E`: elastic section modulous.
- `F_y`: yield strength of steel.

# Returns
- `FlexureBucklingType` enum whose value is either `Compact`, `Noncompact`, or `Slender`

# Reference
- AISC Table B4.1b
"""
function classify_section_for_lb_case10(b, t, E, F_y)
    λ = b / t
    λ_p = 0.38 * sqrt(E / F_y)
    λ_r = 1.0 * sqrt(E / F_y)

    class = if λ <= λ_p
        :compact
    elseif λ_p < λ <= λ_r
        :noncompact
    else
        :slender
    end

    return λ, λ_p, λ_r, class
end

"""
    classify_section_for_lb_case11(b, t, E, F_L, k_c)

Classifies the compressive elements of a member subject to flexural.

Description of applicable member: Flanges of built-up I-shaped sections (singly or doubly symmetric).

# Arguments
- `b`: width of the plate or half the width of the flange.
- `t`: thickness of the flange.
- `E`: elastic section modulous.
- `F_L`: nominal compression flange stress above which the inelastic buckling limit states apply (ksi)
- `k_c`:

# Returns
- `FlexureBucklingType` enum whose value is either `Compact`, `Noncompact`, or `Slender`

# Reference
- AISC Table B4.1b
"""
function classify_section_for_lb_case11(b, t, E, F_y, F_L, k_c)
    λ = b / t
    λ_p = 0.38 * sqrt(E / F_y)
    λ_r = 0.95 * sqrt(k_c * E / F_L)

    class = if λ <= λ_p
        :compact
    elseif λ_p < λ <= λ_r
        :noncompact
    else
        :slender
    end

    return λ, λ_p, λ_r, class
end

"""
    classify_section_for_lb_case13(b, t, E, F_y)

Classifies the compressive elements of a member subject to flexural.

Description of applicable member: Flanges of all I-shaped sections and channels bent about their minor axis.

# Arguments
- `b`: width of the plate or half the width of the flange.
- `t`: thickness of the flange.
- `E`: elastic section modulous.
- `F_y`: yield strength of steel.

# Returns
- `FlexureBucklingType` enum whose value is either `Compact`, `Noncompact`, or `Slender`

# Reference
- AISC Table B4.1b
"""
function classify_section_for_lb_case13(b, t, E, F_y)
    λ = b / t
    λ_p = 0.38 * sqrt(E / F_y)
    λ_r = 1.0 * sqrt(E / F_y)

    class = if λ <= λ_p
        :compact
    elseif λ_p < λ <= λ_r
        :noncompact
    else
        :slender
    end

    return λ, λ_p, λ_r, class
end


"""
    classify_section_for_lb_case15(b, t, E, F_y)

Classifies the compressive elements of a member subject to flexural.

Description of applicable member: Webs of doubly-symmetric I-shaped sections and channels.

# Arguments
- `h`:
    - For rolled sections: the clear distance between flanges less the fillet at each flange.
    - For built-up sections: clear distance between flanges when welds are used.
- `t_w`: thickness of the web.
- `E`: elastic section modulous.
- `F_y`: yield strength of steel.

# Returns
- `FlexureBucklingType` enum whose value is either `Compact`, `Noncompact`, or `Slender`

# Reference
- AISC Table B4.1b
"""
function classify_section_for_lb_case15(h, t_w, E, F_y)
    λ = h / t_w
    λ_p = 3.76 * sqrt(E / F_y)
    λ_r = 5.7 * sqrt(E / F_y)

    class = if λ <= λ_p
        :compact
    elseif λ_p < λ <= λ_r
        :noncompact
    else
        :slender
    end

    return λ, λ_p, λ_r, class
end

end # module
