module FastPower

export fastpower

# From David Goldberg's blog post with minor modifications
# https://tech.ebayinc.com/engineering/fast-approximate-logarithms-part-iii-the-formulas/
@inline function fastlog2(x::Float32)::Float32
    # (x-1)*(a*(x-1) + b)/((x-1) + c) (line 8 of table 2)
    # b = b-a and c = c-1 so we can delay subtracting 1 from signif
    # in the computation of quot to get better ipc
    a = 0.338953f0
    b = 1.8596461f0
    c = 0.523692f0
    # IEEE is sgn(1):exp(8):frac(23) representing
    # (1+frac)*2^(exp-127). 1+frac is called the significand

    bits = reinterpret(UInt32, x)
    biased_exponent = (bits >> 23) & 0xff
    upper_half = !iszero(bits & 0x00400000)
    twice_significand = if 0 < biased_exponent < 0xff
        # Twice the reciprocal power of two stays normal across the Float32 range.
        scale = ldexp(1.0f0, Int32(128) - Int32(biased_exponent))
        abs(x) * scale
    else
        bits_fraction = Float32(bits & 0x007fffff) * (2 * eps(Float32))
        if iszero(biased_exponent)
            scaled = abs(x) * ldexp(1.0f0, 127)
            # The fraction bits preserve the primal when the device flushes subnormals.
            2.0f0 + ifelse(iszero(scaled), bits_fraction, scaled)
        else
            2.0f0 + bits_fraction
        end
    end
    signif = twice_significand * ifelse(upper_half, 0.25f0, 0.5f0)
    exp = Int32(biased_exponent) - Int32(127) + upper_half
    quot = muladd(signif, a, b) / (signif + c)
    return muladd(signif - 1.0f0, quot, exp)
end

"""
    fastpower(x::Real, y::Real) -> AbstractFloat

Compute an approximate floating-point value of ``x^y`` quickly.

`fastpower` evaluates its approximation through a `Float32` logarithm polynomial, trading
accuracy for speed. It is intended for nonnegative bases and exponents when a few digits of
accuracy are sufficient. Inputs that are not both `Real` use Julia's ordinary `^` operation.

## Examples

```jldoctest
julia> using FastPower

julia> fastpower(1.0, 1.0)
1.0
```
"""
@inline function fastpower(x::T, y::T) where {T <: Real}
    outT = float(T)
    if iszero(x)
        return zero(outT)
    elseif isinf(x) && isinf(y)
        return convert(outT, Inf)
    else
        return convert(
            outT,
            @fastmath exp2(convert(Float32, y) * fastlog2(convert(Float32, x)))
        )
    end
end

fastpower(x, y) = x^y

using PrecompileTools: @compile_workload, @setup_workload

@setup_workload begin
    @compile_workload begin
        fastpower(1.25f0, 0.5f0)
        fastpower(1.25, 2.0)
        fastpower(0.0, 2.0)
        fastpower(ComplexF64(1.25), 2.0)
    end
end

end
