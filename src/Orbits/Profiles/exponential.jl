# Distibuted unde the MIT License.
# See LICENSE for details.

module Exponential

"""
    number_fraction!(frac, r)

For a spherical distribution of N particles, this function computes f(r),
defined such that there are n = N * (f(r1) - f(r2)) particles in the shell
with bounds r in [r1, r2].

## Arguments

    - `frac::Vector{Float64}`: the fraction of particles.
    - `r::Vector{Float64}`: any bound(s) within which to compute the fraction.
"""
function number_fraction!(frac::Vector{Float64}, r::Vector{Float64})
    @. frac[:] = exp(-2.0 * r) * (1.0 + 2.0 * r * (1.0 + r))
end

end
