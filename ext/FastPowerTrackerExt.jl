module FastPowerTrackerExt

using FastPower, Tracker
FastPower.fastpow(x::Tracker.TrackedReal, y::Tracker.TrackedReal) = x^y

end