module FastPowerEnzymeExt

using FastPower: FastPower, fastpower
# `@easy_rule` expands to fully-escaped code referring to unqualified EnzymeCore names
# (`Annotation`, `Const`, ...), so the blanket `using Enzyme` is load-bearing; the
# explicit import is how the macro call below is spelled.
using Enzyme
using Enzyme: Enzyme

Enzyme.EnzymeRules.@easy_rule(
    FastPower.fastpower(x, y),
    (y * fastpower(x, y - 1), Ω * log(x))
)

end
