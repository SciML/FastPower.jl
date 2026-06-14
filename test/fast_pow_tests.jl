using FastPower: fastpower
using Test

@test fastpower(1, 1) isa Float64
@test fastpower(1.0, 1.0) isa Float64
errors = [abs(^(x, y) - fastpower(x, y)) for x in 0.001:0.001:1, y in 0.08:0.001:0.5]
@test maximum(errors) < 1.0e-4

errors = [abs(^(x, y) - fastpower(x, y)) for x in 0.001:0.001:1, y in 0.08:0.001:1000.0]
@test maximum(errors) < 1.0e-3

errors = [abs(^(x, y) - fastpower(x, y)) for x in 0.001:0.001:100, y in 0.08:0.001:1.0]
@test maximum(errors) < 1.0e-2
