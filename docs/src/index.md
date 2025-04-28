# AISCSteel

[![Build Status](https://github.com/co1emi11er2/AISCSteel.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/co1emi11er2/AISCSteel.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/co1emi11er2/AISCSteel.jl?svg=true)](https://ci.appveyor.com/project/co1emi11er2/AISCSteel-jl)
[![Coverage](https://codecov.io/gh/co1emi11er2/AISCSteel.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/co1emi11er2/AISCSteel.jl)
[![Coverage](https://coveralls.io/repos/github/co1emi11er2/AISCSteel.jl/badge.svg?branch=main)](https://coveralls.io/github/co1emi11er2/AISCSteel.jl?branch=main)

# AISCSteel.jl

AISCSteel is a Julia package that follows the American Institute of Steel Construction Manual (Sixteenth Edition). You can use this package to help design steel members. This is currently in active development.

# How to Get Started

```@contents
Pages = [
    "GettingStarted.md",
    "WShape Example.md",
    "WTShape Example.md",
    "CShape Example.md",
    "HSS_Shape Example.md",
    "RoundHSS_Shape Example.md"
]
Depth = 1
```

# Other Content

```@contents
Pages = [
    "Shapes.md",
    "ChapterBDesignRequirements.md",
    "ChapterDTension.md",
    "ChapterECompression.md",
    "ChapterFFlexure.md",
    "ChapterGShear.md",
    "Utils.md"
]
Depth = 1
```

```@autodocs
Modules = [AISCSteel]
```

# Roadmap

## Steel Shapes Database

| Shape Type    | Status      |
|---------------|-------------|
| W Shapes      | ✅ Implemented |
| M Shapes      | ✅ Implemented |
| S Shapes      | ✅ Implemented |
| HP Shapes     | ✅ Implemented |
| C Shapes      | ✅ Implemented |
| MC Shapes     | ✅ Implemented |
| L Shapes      | ✅ Implemented |
| WT Shapes     | ✅ Implemented |
| MT Shapes     | ✅ Implemented |
| ST Shapes     | ✅ Implemented |
| HSS Shapes    | ✅ Implemented |
| HSS_R Shapes  | ✅ Implemented |
| PIPE Shapes   | ❌ Not Implemented |
| 2L Shapes     | ❌ Not Implemented |

## Structs

| Struct Type        | Status      |
|--------------------|-------------|
| WShape             | ✅ Implemented |
| BuiltUpIShape      | ❌ Not Implemented |
| M Shape            | ✅ Implemented |
| S Shape            | ✅ Implemented |
| HP Shape           | ✅ Implemented |
| C Shape            | ✅ Implemented |
| MC Shape           | ✅ Implemented |
| L Shape            | ✅ Implemented |
| WT Shape           | ✅ Implemented |
| MT Shape           | ✅ Implemented |
| ST Shape           | ✅ Implemented |
| HSS Shape          | ✅ Implemented |
| HSS_R Shape        | ✅ Implemented |
| PIPE Shape         | ❌ Not Implemented |
| 2L Shape           | ❌ Not Implemented |

## Compression Design (Chapter E)

| Task                          | Status      |
|-------------------------------|-------------|
| Calculate based on E2         | ✅ Implemented |
| Calculate based on E3         | ✅ Implemented |
| Calculate based on E4         | ✅ Implemented |
| Calculate based on E5         | ❌ Not Implemented |
| Calculate based on E6         | ❌ Not Implemented |
| Calculate based on E7         | ✅ Implemented |

## Flexure Design (Chapter F)

| Task                          | Status      |
|-------------------------------|-------------|
| Calculate based on F2         | ✅ Implemented |
| Calculate based on F3         | ✅ Implemented |
| Calculate based on F4         | ✅ Implemented |
| Calculate based on F5         | ✅ Implemented |
| Calculate based on F6         | ✅ Implemented |
| Calculate based on F7         | ✅ Implemented |
| Calculate based on F8         | ✅ Implemented |
| Calculate based on F9         | ✅ Implemented |
| Calculate based on F10        | ✅ Implemented |
| Calculate based on F11        | ❌ Not Implemented |
| Calculate based on F12        | ❌ Not Implemented |

## Shear Design (Chapter G)

| Task                          | Status      |
|-------------------------------|-------------|
| Calculate based on G2         | ❌ Not Implemented |
| Calculate based on G3         | ❌ Not Implemented |
| Calculate based on G4         | ❌ Not Implemented |
| Calculate based on G5         | ❌ Not Implemented |
| Calculate based on G6         | ❌ Not Implemented |
| Calculate based on G7         | ❌ Not Implemented |

