module FastPowerForwardDiffExt

import FastPower
using ForwardDiff: value, Dual, _mul_partials, partials, @define_binary_dual_op

# Copy of https://github.com/JuliaDiff/ForwardDiff.jl/blob/v0.10.36/src/dual.jl#L519
for f in (FastPower.fastpow,)
    @eval begin
        @define_binary_dual_op(
            $f,
            begin
                vx, vy = value(x), value(y)
                expv = ($f)(vx, vy)
                powval = vy * ($f)(vx, vy - 1)
                if isconstant(y)
                    logval = one(expv)
                elseif iszero(vx) && vy > 0
                    logval = zero(vx)
                else
                    logval = expv * log(vx)
                end
                new_partials = _mul_partials(partials(x), partials(y), powval, logval)
                return Dual{Txy}(expv, new_partials)
            end,
            begin
                v = value(x)
                expv = ($f)(v, y)
                if y == zero(y) || iszero(partials(x))
                    new_partials = zero(partials(x))
                else
                    new_partials = partials(x) * y * ($f)(v, y - 1)
                end
                return Dual{Tx}(expv, new_partials)
            end,
            begin
                v = value(y)
                expv = ($f)(x, v)
                deriv = (iszero(x) && v > 0) ? zero(expv) : expv*log(x)
                return Dual{Ty}(expv, deriv * partials(y))
            end
        )
    end
end

end