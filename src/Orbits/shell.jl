# Distributed under the MIT License.
# See LICENSE for details.

module Shell

"""
    particle_number!(numbers, profile, N, bounds)

For the given spherical profile, compute the number of particles on each shell
of given bounds.

## Arguments

  - `numbers::Vector{Float64}`: the number of particle in each shell.
  - `profile::Any`: the spherical profile. Must contain a
    `number_fraction!(fraction, bounds)` function.
  - `N::UInt`: the total number of particles across all shells.
  - `bounds::Vector{Float}`: the radial extents of each shell.
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
