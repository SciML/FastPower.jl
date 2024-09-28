module FastPowerMeasurementsExt

using FastPower
using Measurements

@inline FastPower.fastpow(x::Measurements.Measurement, y::Measurements.Measurement) = x^y

end