using SciMLTesting, FastPower, JET, Test

# ExplicitImports can only see an extension module once its trigger package is loaded,
# so every weakdep is loaded here to bring all of FastPower's extensions under QA.
using Enzyme, ForwardDiff, Measurements, MonteCarloMeasurements, Mooncake, ReverseDiff,
    Tracker

# An extension that fails to load is skipped by ExplicitImports rather than reported, so
# assert the loads here instead of letting the scan silently shrink.
@testset "Extensions loaded" begin
    for ext in (
            :FastPowerEnzymeExt, :FastPowerForwardDiffExt, :FastPowerMeasurementsExt,
            :FastPowerMonteCarloMeasurementsExt, :FastPowerMooncakeExt,
            :FastPowerReverseDiffExt, :FastPowerTrackerExt,
        )
        @test Base.get_extension(FastPower, ext) !== nothing
    end
end

run_qa(
    FastPower;
    ei_kwargs = (;
        all_qualified_accesses_are_public = (;
            ignore = (
                # ForwardDiff.Dual, ReverseDiff.TrackedReal and Tracker.TrackedReal are the
                # number types the AD extensions must dispatch on; none of the three owners
                # exports them or declares them `public`.
                :Dual, :TrackedReal,
                # EnzymeRules.@easy_rule and Mooncake.@mooncake_overlay are the documented
                # rule-definition macros of those backends, likewise not declared public.
                Symbol("@easy_rule"), Symbol("@mooncake_overlay"),
            ),
        ),
    )
)
