# FastPower.jl

A faster approximation to floating point power, at the trade-off of some accuracy. While Julia's
built-in floating point `^` tries to achieve ~1ulp accuracy, this version of floating point power
approximation achieves much fewer digits of accuracy (approximately 10 digits of accuracy) while
being much faster. This is developed as a library in order to make the choice to opt-in as a
replacement to `^` very easy but deliberate on the side of the user.

## Installation

```julia
using Pkg
Pkg.add("FastPower")
```

## Using FastPower.jl

Using FastPower.jl is dead simple: instead of `x^y`, do the following:

```julia
using FastPower
FastPower.fastpower(x,y)
```

That's it. That's all there is.