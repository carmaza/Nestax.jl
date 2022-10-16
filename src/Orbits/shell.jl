# Distributed under the MIT License.
# See LICENSE for details.

module Shell

"""
    cartesian_from_spherical(r, theta, phi)

Return the Cartesian components of the given spherical coordinates.

## Arguments

  - `r::Float64, theta::Float64, phi::Float64`: the spherical coordinates.

## Returns

  - `SVector{3, Float}`: the Cartesian coordinates.
"""
function particle_number!(
    numbers::Vector{Float64},
    profile::Any,
    N::UInt64,
    bounds::Vector{Float64}
)
    fraction = Vector{Float64}(undef, length(bounds))
    profile.number_fraction!(fraction, bounds)
    for k in eachindex(numbers)
        numbers[k] = N * (fraction[k] - fraction[k + 1])
    end
end

end
