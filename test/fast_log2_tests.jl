using FastPower: fastlog2
using Test

for x in 0.001:0.001:1.2 # (0, 1+something] is the domain which a controller uses
    @test log2(x) ≈ fastlog2(Float32(x)) atol = 1.0e-3
end
