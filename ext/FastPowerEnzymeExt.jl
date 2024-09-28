module FastPowerEnzymeExt

using FastPower
import FastPower: fastpower
using Enzyme

Enzyme.Compiler.known_ops[typeof(FastPower.fastpower)] = (:pow, 2, nothing)

end
