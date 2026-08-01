module FastPowerMeasurementsExt

using FastPower: FastPower
using Measurements: Measurements

@inline FastPower.fastpower(x::Measurements.Measurement, y::Measurements.Measurement) = x^y

end
