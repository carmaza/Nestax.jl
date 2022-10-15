# Distibuted unde the MIT License.
# See LICENSE for details.

module Exponential

function number_fraction!(frac::Vector{Float64}, r::Vector{Float64})
    @. frac[:] = exp(-2.0 * r) * (1.0 + 2.0 * r * (1.0 + r))
end

end
