module FastPowerMonteCarloMeasurementsExt

using FastPower: FastPower
using MonteCarloMeasurements: MonteCarloMeasurements

@inline function FastPower.fastpower(
        x::MonteCarloMeasurements.AbstractParticles,
        y::MonteCarloMeasurements.AbstractParticles
    )
    return x^y
end

end
