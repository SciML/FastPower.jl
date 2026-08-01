module FastPowerMooncakeExt

using FastPower: FastPower
using Mooncake: Mooncake

Mooncake.@mooncake_overlay FastPower.fastpower(x, y) = x^y

end
