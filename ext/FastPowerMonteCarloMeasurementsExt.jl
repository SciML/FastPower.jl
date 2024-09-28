module FastPowerMonteCarloMeasurementsExt

using FastPower
using MonteCarloMeasurements

@inline function FastPower.fastpow(x::MonteCarloMeasurements.AbstractParticles,
        y::MonteCarloMeasurements.AbstractParticles)
    x^y
end

end