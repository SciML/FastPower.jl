using FastPower: fastpower
using ForwardDiff, ReverseDiff, Tracker, Mooncake
using Test

function mooncake_derivative(f, x)
    return Mooncake.value_and_gradient!!(Mooncake.build_rrule(f, x), f, x)[2][2]
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
