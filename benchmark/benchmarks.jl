using FastPower, BenchmarkTools
using StableRNGs

const SUITE = BenchmarkGroup()
const rng = StableRNG(123)

xs = rand(rng, 10_000)

# =============================================================================
# fastpower vs ^
# =============================================================================

SUITE["fastpower"] = BenchmarkGroup()

SUITE["fastpower"]["int_exp"] = @benchmarkable sum(fastpower.($xs, 3))
SUITE["fastpower"]["int_large"] = @benchmarkable sum(fastpower.($xs, 17))
SUITE["fastpower"]["float_exp"] = @benchmarkable sum(fastpower.($xs, 2.5))
SUITE["fastpower"]["neg_exp"] = @benchmarkable sum(fastpower.($xs, -2))

SUITE["baseline"] = BenchmarkGroup()
SUITE["baseline"]["pow3"] = @benchmarkable sum($xs .^ 3)
SUITE["baseline"]["pow2_5"] = @benchmarkable sum($xs .^ 2.5)
