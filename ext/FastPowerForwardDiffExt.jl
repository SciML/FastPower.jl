module FastPowerForwardDiffExt

import FastPower
using ForwardDiff

@inline FastPower.fastpow(x::ForwardDiff.Dual, y::ForwardDiff.Dual) = x^y

end