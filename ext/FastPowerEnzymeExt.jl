module FastPowerEnzymeExt

using FastPower
import FastPower: fastpow
using Enzyme

Enzyme.Compiler.known_ops[typeof(FastPower.fastpow)] = (:pow, 2, nothing)

end