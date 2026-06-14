using SafeTestsets, Test

@safetestset "Fast log2" begin
    using FastPower: fastlog2
    using Test

    for x in 0.001:0.001:1.2 # (0, 1+something] is the domain which a controller uses
        @test log2(x)≈fastlog2(Float32(x)) atol=1e-3
    end
end

@safetestset "Fast pow" begin
    using FastPower: fastpower
    using Test

    @test fastpower(1, 1) isa Float64
    @test fastpower(1.0, 1.0) isa Float64
    errors = [abs(^(x, y) - fastpower(x, y)) for x in 0.001:0.001:1, y in 0.08:0.001:0.5]
    @test maximum(errors) < 1e-4

    errors = [abs(^(x, y) - fastpower(x, y)) for x in 0.001:0.001:1, y in 0.08:0.001:1000.0]
    @test maximum(errors) < 1e-3

    errors = [abs(^(x, y) - fastpower(x, y)) for x in 0.001:0.001:100, y in 0.08:0.001:1.0]
    @test maximum(errors) < 1e-2
end

@safetestset "Fast pow - Enzyme forward rule" begin
    using FastPower: fastpower
    using Enzyme, EnzymeTestUtils
    using Test

    @testset for RT in (Duplicated, DuplicatedNoNeed),
        Tx in (Const, Duplicated),
        Ty in (Const, Duplicated)
        x = 1.0
        y = 0.5
        test_forward(fastpower, RT, (x, Tx), (y, Ty), atol = 1e-4, rtol = 1e-3)
    end
end

@safetestset "Fast pow - Enzyme reverse rule" begin
    using FastPower: fastpower
    using Enzyme, EnzymeTestUtils
    using Test

    @testset for RT in (Active,), Tx in (Active, Const), Ty in (Active, Const)
        x = 1.0
        y = 0.5
        test_reverse(fastpower, RT, (x, Tx), (y, Ty), atol = 1e-4, rtol = 1e-3)
    end
end

@safetestset "Fast pow - Other AD Engines" begin
    using FastPower: fastpower
    using ForwardDiff, ReverseDiff, Tracker, Mooncake
    using Test

    function mooncake_derivative(f, x)
        Mooncake.value_and_gradient!!(Mooncake.build_rrule(f, x), f, x)[2][2]
    end

    x = 1.5123233245141
    y = 0.22352354326
    @test ForwardDiff.derivative(x -> fastpower(x, x + y), x) ≈
          ForwardDiff.derivative(x -> ^(x, x + y), x)
    @test Tracker.gradient(x -> fastpower(x, x + y), x)[1] ≈
          Tracker.gradient(x -> ^(x, x + y), x)[1]
    @test ReverseDiff.gradient(x -> fastpower(x[1], x[1] + y), [x])[1] ≈
          ReverseDiff.gradient(x -> ^(x[1], x[1] + y), [x])[1]
    @test mooncake_derivative(x -> fastpower(x, x + y), x) ≈
          mooncake_derivative(x -> ^(x, x + y), x)
end
