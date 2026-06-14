using FastPower: fastpower
using Enzyme, EnzymeTestUtils
using Test

@testset for RT in (Duplicated, DuplicatedNoNeed),
        Tx in (Const, Duplicated),
        Ty in (Const, Duplicated)
    x = 1.0
    y = 0.5
    test_forward(fastpower, RT, (x, Tx), (y, Ty), atol = 1.0e-4, rtol = 1.0e-3)
end
