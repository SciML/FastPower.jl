using FastPower
using Aqua
using JET
using Test

@testset "Aqua" begin
    Aqua.test_all(FastPower; deps_compat = (; check_extras = false))
    @test_broken false  # Aqua deps_compat (extras): Pkg has no [compat] entry — see https://github.com/SciML/FastPower.jl/issues/53
end

@testset "JET" begin
    JET.test_package(FastPower; target_defined_modules = true)
end
