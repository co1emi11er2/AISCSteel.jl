# AISCSteel

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://co1emi11er2.github.io/AISCSteel.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://co1emi11er2.github.io/AISCSteel.jl/dev/)
[![Build Status](https://github.com/co1emi11er2/AISCSteel.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/co1emi11er2/AISCSteel.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/co1emi11er2/AISCSteel.jl?svg=true)](https://ci.appveyor.com/project/co1emi11er2/AISCSteel-jl)
[![Coverage](https://codecov.io/gh/co1emi11er2/AISCSteel.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/co1emi11er2/AISCSteel.jl)
[![Coverage](https://coveralls.io/repos/github/co1emi11er2/AISCSteel.jl/badge.svg?branch=main)](https://coveralls.io/github/co1emi11er2/AISCSteel.jl?branch=main)

# AISCSteel.jl

AISCSteel is a Julia package that follows the American Institute of Steel Construction Manual (Sixteenth Edition). You can use this package to help design steel members. This is currently in active development.

## Installation

To install AISCSteel.jl, use the Julia package manager: (not registered yet)

```julia
using Pkg
Pkg.add("AISCSteel")
```

## Roadmap

- **Steel Shapes Database**
  - [x] W Shapes
  - [x] M Shapes
  - [x] S Shapes
  - [x] HP Shapes
  - [x] C Shapes
  - [x] MC Shapes
  - [x] L Shapes
  - [x] WT Shapes
  - [x] MT Shapes
  - [x] ST Shapes
  - [x] HSS Shapes
  - [x] HSS_R Shapes
  - [x] PIPE Shapes
  - [x] 2L Shapes
- **Structs**
  - [x] WShape
  - [ ] BuiltUpIShape
  - [x] M Shape
  - [x] S Shape
  - [x] HP Shape
  - [x] C Shape
  - [x] MC Shape
  - [ ] L Shape
  - [ ] WT Shape
  - [ ] MT Shape
  - [ ] ST Shape
  - [ ] HSS Shape
  - [ ] HSS_R Shape
  - [ ] PIPE Shape
  - [ ] 2L Shape
- **Compression Design** (Chapter E)
  - [ ] Calculate based on E2
  - [ ] Calculate based on E3
  - [ ] Calculate based on E4
  - [ ] Calculate based on E5
  - [ ] Calculate based on E6
  - [ ] Calculate based on E7
- **Flexure Design** (Chapter F)
  - [x] Calculate based on F2
  - [x] Calculate based on F3
  - [x] Calculate based on F4
  - [x] Calculate based on F5
  - [ ] Calculate based on F6
  - [ ] Calculate based on F7
  - [ ] Calculate based on F8
  - [ ] Calculate based on F9
  - [ ] Calculate based on F10
  - [ ] Calculate based on F11
  - [ ] Calculate based on F12
- **Shear Design** (Chapter G)
  - [ ] Calculate based on G2
  - [ ] Calculate based on G3
  - [ ] Calculate based on G4
  - [ ] Calculate based on G5
  - [ ] Calculate based on G6
  - [ ] Calculate based on G7