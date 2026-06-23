using FastPower: fastpower
using Enzyme, EnzymeTestUtils
using StableRNGs
using Test

# `test_forward` compares the rule (which returns the *exact* `^` derivative) against finite
# differences of the *approximate* `fastpower` primal. Because `fastpower` routes through a
# Float32 `fastlog2` polynomial, the *slope* of its primal differs from the exact slope by
# ~1e-2 relative near x=1 (even where the primal value itself is exact), so the FD reference
# is off from the exact rule by that inherent approximation error rather than by any rule bug.
# The previous atol=1e-4, rtol=1e-3 sat below that gap, so whether the lane passed depended on
# the random tangents `test_forward` drew from the global RNG (it went red ~4% of the time).
#
# Fix: draw the tangents from a StableRNG (a fixed seed gives the *same* stream on every Julia
# version, unlike the global RNG / Xoshiro whose stream can change across versions) so the test
# is genuinely deterministic, and use atol=1e-3, rtol=1e-2 matched to `fastpower`'s documented
# accuracy envelope (see test/fast_pow_tests.jl). That tolerance is ~5x above the measured
# worst-case relative discrepancy in this grid (~2e-3) yet far below the O(1) relative error a
# genuinely wrong derivative rule would produce, so real regressions are still caught. Reverting
# to rtol=1e-3 is not possible without cherry-picking a lucky seed to hide the inherent gap.
rng = StableRNG(123)
@testset for RT in (Duplicated, DuplicatedNoNeed),
        Tx in (Const, Duplicated),
        Ty in (Const, Duplicated)
    x = 1.0
    y = 0.5
    test_forward(fastpower, RT, (x, Tx), (y, Ty), rng = rng, atol = 1.0e-3, rtol = 1.0e-2)
end
