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

## FastPower vs FastMath (`@fastmath`)

The name simply derives from the Julia standard of `x_fast` for things that are approximations.
FastPower is simply the the `^_fast` or `pow_fast` function, following the standard conventions
developed from Base. However, this differs from the `pow_fast` you get from Base which is still
a lot more accurate. `FastPower.fastpower` loses about 6 digits of accuracy on Float64, so it's
about 10 digits of accuracy. For many applications, such as solving differential equations to
6 digits of accuracy, this can 

## What about FastPow.jl?

These two packages are completely unrelated since FastPow.jl is a specialization for integer powers.
It does things like:

```julia
2^5
```

which can be computed via:

```julia
sq = 2^2
fourth = sq^2
fourth * 2
```

This is a bit faster than `^(::AbstractFloat, Integer)` but with a bit of accuracy loss.

Meanwhile, FastPower.jl is all about floating point powers. 

## Why is this not in Base?

Maybe it could be. If you wish to change `pow_fast` to this, open a PR. There can be a debate
as to which one is better. However, as separate package there is no debate: use this one if
the less accuracy and more speed is appropriate for your needs. Arguably, FastMath should be
split from Base.

Also, one major purpose of this package is to allow for the bithacking to be held in a place 
that allows for extensions which enable compatbility with automatic differentiation. Extensions
for:

* Enzyme
* ForwardDiff
* Tracker
* ReverseDiff
* MonteCarloMeasurements
* Measurements

currently exist for this function. More can be added on-demand. This allows for `pow_fast` to be
safe in most AD contexts, though in some cases improved extensions could be created which
improve performance.
