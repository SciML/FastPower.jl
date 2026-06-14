using FastPower: fastpower
using Enzyme, EnzymeTestUtils
using Test

@testset for RT in (Active,), Tx in (Active, Const), Ty in (Active, Const)
    x = 1.0
    y = 0.5
    test_reverse(fastpower, RT, (x, Tx), (y, Ty), atol = 1.0e-4, rtol = 1.0e-3)
end
