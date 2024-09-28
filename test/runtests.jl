using FastPower
using FastPower: fastlog2, fastpow
using Enzyme, EnzymeTestUtils
using ForwardDiff, ReverseDiff, Tracker
using Test

@testset "Fast log2" begin
    for x in 0.001:0.001:1.2 # (0, 1+something] is the domain which a controller uses
        @test log2(x)≈fastlog2(Float32(x)) atol=1e-3
    end
end

@testset "Fast pow" begin
    @test fastpow(1, 1) isa Float64
    @test fastpow(1.0, 1.0) isa Float64
    errors = [abs(^(x, y) - fastpow(x, y)) for x in 0.001:0.001:1, y in 0.08:0.001:0.5]
    @test maximum(errors) < 1e-4
end

@testset "Fast pow - Enzyme forward rule" begin
    @testset for RT in (Duplicated, DuplicatedNoNeed),
        Tx in (Const, Duplicated),
        Ty in (Const, Duplicated)

        x = 3.0
        y = 2.0
        @test_skip test_forward(fastpow, RT, (x, Tx), (y, Ty), atol = 1e-10)
    end
end

@testset "Fast pow - Enzyme reverse rule" begin
    @testset for RT in (Active,), Tx in (Active,), Ty in (Active,)
        x = 2.0
        y = 3.0
        @test_skip test_reverse(fastpow, RT, (x, Tx), (y, Ty), atol = 1e-10)
    end
end

@testset "Fast pow - Other AD Engines" begin
    x = 1.5123233245141
    y = 2.2342351513252
    @test ForwardDiff.derivative(x -> fastpow(x, x + y), x) ≈
          ForwardDiff.derivative(x -> ^(x, x + y), x)
    @test Tracker.gradient(x -> fastpow(x, x + y), x)[1] ≈
          Tracker.gradient(x -> ^(x, x + y), x)[1]
    @test ReverseDiff.gradient(x -> fastpow(x[1], x[1] + y), [x])[1] ≈
          ReverseDiff.gradient(x -> ^(x[1], x[1] + y), [x])[1]
end
