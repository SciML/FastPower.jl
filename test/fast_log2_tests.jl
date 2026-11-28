using FastPower: fastlog2
using Test

for x in 0.001:0.001:1.2 # (0, 1+something] is the domain which a controller uses
    @test log2(x) ≈ fastlog2(Float32(x)) atol = 1.0e-3
end

@testset "Subnormal values across flush modes" begin
    xs = reinterpret(Float32, UInt32[0x00000001, 0x00200000, 0x00600000, 0x007fffff])
    flush = get_zero_subnormals()
    try
        set_zero_subnormals(false)
        gradual = fastlog2.(xs)
        set_zero_subnormals(true)
        @test reinterpret(UInt32, fastlog2.(xs)) == reinterpret(UInt32, gradual)
    finally
        set_zero_subnormals(flush)
    end
end

@testset "Normalization across Float32 exponents" begin
    @test fastlog2(0.0f0) === fastlog2(-0.0f0)
    midpoint_value = fastlog2(1.5f0)
    @test abs(fastlog2(nextfloat(1.5f0)) - midpoint_value) <= 8eps(midpoint_value)
    for e in (-126, -63, 0, 63, 127)
        @test fastlog2(ldexp(1.0f0, e)) === Float32(e)
        midpoint = ldexp(1.5f0, e)
        for x in (prevfloat(midpoint), midpoint, nextfloat(midpoint))
            @test fastlog2(x) ≈ log2(x) atol = 1.0e-3
        end
    end
end
