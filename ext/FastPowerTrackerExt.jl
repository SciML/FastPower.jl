module FastPowerTrackerExt

using FastPower: FastPower
using Tracker: Tracker

FastPower.fastpower(x::Tracker.TrackedReal, y::Tracker.TrackedReal) = x^y

end
