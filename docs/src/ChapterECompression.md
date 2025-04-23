
```@meta
CollapsedDocStrings = true
```

# Chapter E - Design of Members for Compression

This chapter applies to members subject to axial compression.

- [E1. General Provisions](@ref)
- [E2. Effective Length](@ref)
- [E3. Flexural Buckling of Members without Slender Elements](@ref)
- [E4. Torsional and Flexural-Torsional Buckling of Single Angles and Members without Slender Elements](@ref)
- [E5. Single Angle Compression Members](@ref)
- [E6. Built-Up Members](@ref)
- [E7. Members with Slender Elements](@ref)

## E1. General Provisions

The design compressive strength, ${\phi}_c P_{n}$, and the allowable compressive strength, $P_n/{\Omega}_c$, are determined as follows.

The nominal compressive strength, $P_n$ shall be the lowest value obtained based on the applicable limit states of flexural buckling, torsional buckling, and flexural-torsional buckling.

$ {\phi}_c = 0.90 \text{(LRFD)} $

## E2. Effective Length

The effective length, $L_c$, for calculatios of member slenderness, $L_c/r$, shall be determined in accordance with Chapter C or Appendix 7.

## E3. Flexural Buckling of Members without Slender Elements

This section applies to nonslender-element compression members, as defined in Section B4.1, for elements in axial compression.

```@autodocs
Modules = [AISCSteel.ChapterECompression.E3]
```

## E4. Torsional and Flexural-Torsional Buckling of Single Angles and Members without Slender Elements

This section applies to singly symmetric and unsymmetric members, certain doubly
symmetric members, such as cruciform or built-up members, and doubly symmetric
members when the torsional unbraced length exceeds the lateral unbraced length, all
without slender elements. These provisions also apply to single angles with $b/t > 0.71\sqrt{E/F_y}$
, where $b$ is the width of the longest leg and $t$ is the thickness.

```@autodocs
Modules = [AISCSteel.ChapterECompression.E4]
```

## E5. Single Angle Compression Members

This section is *not implemented*.

## E6. Built-Up Members

This section is *not implemented*.

## E7. Members with Slender Elements

This section applies to slender-element compression members, as defined in Section
B4.1 for elements in axial compression.

```@autodocs
Modules = [AISCSteel.ChapterECompression.E7]
```