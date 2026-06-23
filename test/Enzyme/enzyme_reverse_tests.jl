using FastPower: fastpower
using Enzyme, EnzymeTestUtils
using StableRNGs
using Test

# See test/Enzyme/enzyme_forward_tests.jl: the finite-difference reference is taken on the
# approximate `fastpower` primal, so the tolerance must cover its inherent approximation error.
# Draw the cotangents from a StableRNG (stream is identical across Julia versions, so the test
# is deterministic) and match `fastpower`'s documented accuracy with atol=1e-3, rtol=1e-2.
rng = StableRNG(123)
@testset for RT in (Active,), Tx in (Active, Const), Ty in (Active, Const)
    x = 1.0
    y = 0.5
    test_reverse(fastpower, RT, (x, Tx), (y, Ty), rng = rng, atol = 1.0e-3, rtol = 1.0e-2)
end
