module FastPowerForwardDiffExt

using FastPower: FastPower
using ForwardDiff: ForwardDiff

@inline FastPower.fastpower(x::ForwardDiff.Dual, y::ForwardDiff.Dual) = x^y

end
