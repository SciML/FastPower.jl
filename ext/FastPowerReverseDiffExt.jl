module FastPowerReverseDiffExt

using FastPower: FastPower
using ReverseDiff: ReverseDiff

FastPower.fastpower(x::ReverseDiff.TrackedReal, y::ReverseDiff.TrackedReal) = x^y

end
