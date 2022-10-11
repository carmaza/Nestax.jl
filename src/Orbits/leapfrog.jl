# Distributed under the MIT License.
# See LICENSE for details.

module Leapfrog

using StaticArrays

"""
    update!(x, v, a, force, dt)

Update the Cartesian position, velocity, and acceleration of N particles, using
the syncronized second-order Leapfrog method.

## Arguments

  - `x::Vector{SVector{3, Float64}}`: the position of the particles.
  - `v::Vector{SVector{3, Float64}}`: the velocity of the particles.
  - `a::Vector{SVector{3, Float64}}`: the acceleration of the particles.
  - `force::Any`: the function to calculate the acceleration.
  - `dt::Float64`: the timestep used to update the variables.
"""
function update!(
    x::Vector{SVector{3, Float64}},
    v::Vector{SVector{3, Float64}},
    a::Vector{SVector{3, Float64}};
    force::Any,
    dt::Float64
)
    half_dt = 0.5 * dt
    for i in 1:length(x)
        v[i] += half_dt * a[i]
        x[i] += dt * v[i]
        a[i] = force(x[i])
        v[i] += half_dt * a[i]
    end
end

end
