module TableB4⬝1a

"""
    case1(b, t, E, F_y)

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
function case1(b, t, E, F_y)
    λ = b / t
    λ_r = 0.56 * sqrt(E / F_y)

    if λ <= λ_r
        class = :nonslender
    else
        class = :slender
    end

    return class
end

"""
    case10(b, t, E, F_y)

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
function case10(b, t, E, F_y)
    λ = b / t
    λ_p = 0.38 * sqrt(E / F_y)
    λ_r = 1.0 * sqrt(E / F_y)

    if λ <= λ_p
        class = :compact
    elseif λ_p < λ <= λ_r
        class = :noncompact
    else
        class = :slender
    end

    return λ, λ_p, λ_r, class
end

"""
    case11(b, t, E, F_L, k_c)

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
function case11(b, t, E, F_y, F_L, k_c)
    λ = b / t
    λ_p = 0.38 * sqrt(E / F_y)
    λ_r = 0.95 * sqrt(k_c * E / F_L)

    if λ <= λ_p
        class = :compact
    elseif λ_p < λ <= λ_r
        class = :noncompact
    else
        class = :slender
    end

    return λ, λ_p, λ_r, class
end

"""
    case12(b, t, E, F_L, k_c)

Classifies the compressive elements of a member subject to flexural.

Description of applicable member: Flanges of built-up I-shaped sections (singly or doubly symmetric).

# Arguments
- `b`: width of the plate or half the width of the flange.
- `t`: thickness of the flange.
- `E`: elastic section modulous.
- `E`: elastic section modulous.
- `F_y`: yield strength of steel.

# Returns
- `FlexureBucklingType` enum whose value is either `Compact`, `Noncompact`, or `Slender`

# Reference
- AISC Table B4.1b
"""
function case12(b, t, E, F_y)
    λ = b / t
    λ_p = 0.54 * sqrt(E / F_y)
    λ_r = 0.91 * sqrt(E / F_y)

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
    case13(b, t, E, F_y)

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
function case13(b, t, E, F_y)
    λ = b / t
    λ_p = 0.38 * sqrt(E / F_y)
    λ_r = 1.0 * sqrt(E / F_y)

    if λ <= λ_p
        class = :compact
    elseif λ_p < λ <= λ_r
        class = :noncompact
    else
        class = :slender
    end

    return λ, λ_p, λ_r, class
end

"""
    case14(d, t, E, F_y)

Classifies the compressive elements of a member subject to flexure.

Description of applicable member: Webs of doubly-symmetric I-shaped sections and channels.

# Arguments
- `d`: depth of the WT section
- `t_w`: thickness of the web.
- `E`: elastic section modulous.
- `F_y`: yield strength of steel.

# Returns
- `FlexureBucklingType` enum whose value is either `Compact`, `Noncompact`, or `Slender`

# Reference
- AISC Table B4.1b
"""
function case14(d, t_w, E, F_y)
    λ = d / t_w
    λ_p = 0.84 * sqrt(E / F_y)
    λ_r = 1.52 * sqrt(E / F_y)

    if λ <= λ_p
        class = :compact
    elseif λ_p < λ <= λ_r
        class = :noncompact
    else
        class = :slender
    end

    return λ, λ_p, λ_r, class
end


"""
    case15(b, t, E, F_y)

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
function case15(h, t_w, E, F_y)
    λ = h / t_w
    λ_p = 3.76 * sqrt(E / F_y)
    λ_r = 5.7 * sqrt(E / F_y)

    if λ <= λ_p
        class = :compact
    elseif λ_p < λ <= λ_r
        class = :noncompact
    else
        class = :slender
    end

    return λ, λ_p, λ_r, class
end


"""
    case17(b, t, E, F_y)

Classifies the compressive elements of a member subject to flexural.

Description of applicable member: Webs of doubly-symmetric I-shaped sections and channels.

# Arguments
- `b`: width of the flat wall of the flange HSS (inch)
- `t`: thickness of the flange (inch)
- `E`: elastic section modulous.
- `F_y`: yield strength of steel.

# Returns
- `FlexureBucklingType` enum whose value is either `Compact`, `Noncompact`, or `Slender`

# Reference
- AISC Table B4.1b
"""
function case17(b, t, E, F_y)
    λ = b / t
    λ_p = 1.12 * sqrt(E / F_y)
    λ_r = 1.40 * sqrt(E / F_y)

    if λ <= λ_p
        class = :compact
    elseif λ_p < λ <= λ_r
        class = :noncompact
    else
        class = :slender
    end

    return λ, λ_p, λ_r, class
end


"""
    case19(h, t, E, F_y)

Classifies the compressive elements of a member subject to flexural.

Description of applicable member: Webs of doubly-symmetric I-shaped sections and channels.

# Arguments
- `h`: height of the flat wall of the web HSS (inch)
- `t`: thickness of the web (inch)
- `E`: elastic section modulous.
- `F_y`: yield strength of steel.

# Returns
- `FlexureBucklingType` enum whose value is either `Compact`, `Noncompact`, or `Slender`

# Reference
- AISC Table B4.1b
"""
function case19(h, t, E, F_y)
    λ = h / t
    λ_p = 2.42 * sqrt(E / F_y)
    λ_r = 5.70 * sqrt(E / F_y)

    if λ <= λ_p
        class = :compact
    elseif λ_p < λ <= λ_r
        class = :noncompact
    else
        class = :slender
    end

    return λ, λ_p, λ_r, class
end


"""
    case20(D, t, E, F_y)

Classifies the compressive elements of a member subject to flexural.

Description of applicable member: Webs of doubly-symmetric I-shaped sections and channels.

# Arguments
- `D`: outer diameter of the round HSS (inch)
- `t`: thickness of the wall (inch)
- `E`: elastic section modulous.
- `F_y`: yield strength of steel.

# Returns
- `FlexureBucklingType` enum whose value is either `Compact`, `Noncompact`, or `Slender`

# Reference
- AISC Table B4.1b
"""
function case20(D, t, E, F_y)
    λ = D / t
    λ_p = 0.07 * E / F_y
    λ_r = 0.31 * E / F_y

    if λ <= λ_p
        class = :compact
    elseif λ_p < λ <= λ_r
        class = :noncompact
    else
        class = :slender
    end

    return λ, λ_p, λ_r, class
end


end
