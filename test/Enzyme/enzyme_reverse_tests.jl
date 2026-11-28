using FastPower: fastlog2, fastpower
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

@testset "Reverse derivative of the Float32 rational logarithm approximation" begin
    for x in (0.2f0, 0.6f0, 1.2f0, 1.6f0, 2.3f0, 7.2f0)
        ((dx,),) = autodiff(Reverse, fastlog2, Active, Active(x))
        h = cbrt(eps(Float32)) * x
        reference = (fastlog2(x + h) - fastlog2(x - h)) / (2h)
        @test dx ≈ reference rtol = 8 * cbrt(eps(Float32))^2
    end
end

@testset "Subnormal logarithm derivatives" begin
    flush = get_zero_subnormals()
    try
        set_zero_subnormals(false)
        for fraction in (eps(Float32), 0.25f0, 0.75f0, 1.0f0 - eps(Float32))
            ((slope,),) = autodiff(Reverse, fastlog2, Active, Active(1.0f0 + fraction))
            for sign in (-1.0f0, 1.0f0)
                x = sign * fraction * floatmin(Float32)
                ((dx,),) = autodiff(Reverse, fastlog2, Active, Active(x))
                @test dx ≈ sign * ldexp(slope, 126) rtol = 8eps(Float32)
            end
        end
    finally
        set_zero_subnormals(flush)
    end
end
