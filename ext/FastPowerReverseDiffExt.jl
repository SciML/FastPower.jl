module FastPowerReverseDiffExt

using FastPower, ReverseDiff
FastPower.fastpow(x::ReverseDiff.TrackedReal, y::ReverseDiff.TrackedReal) = x^y

end
