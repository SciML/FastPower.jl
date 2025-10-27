module FastPowerEnzymeExt

using FastPower
import FastPower: fastpower
using Enzyme
using Enzyme.EnzymeRules: FwdConfig

Enzyme.EnzymeRules.@easy_rule(
    FastPower.fastpower(x, y),
    ( y * fastpower(x, y - 1), Ω * log(x) )
)

end
