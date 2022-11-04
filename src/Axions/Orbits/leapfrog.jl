# Distributed under the MIT License.
# See LICENSE for details.

module Leapfrog

using StaticArrays

"""
    update!(x, v, a, force, dt)

Update the Cartesian position, velocity, and acceleration of a particle, using
the syncronized second-order Leapfrog method.

## Arguments

  - `x::SVector{3, Float64}`: the position of the particle.
  - `v::SVector{3, Float64}`: the velocity of the particle.
  - `a::SVector{3, Float64}`: the acceleration of the particle.
  - `force::Any`: the function to calculate the acceleration.
  - `dt::Float64`: the timestep used to update the variables.

## Returns

  - `SVector{3, Float64}, SVector{3, Float64}, SVector{3, Float64}`: the new
    particle's position, velocity, and acceleration.
"""
function update(
    x::SVector{3, Float64},
    v::SVector{3, Float64},
    a::SVector{3, Float64};
    force::Any,
    dt::Float64
)
    half_dt = 0.5 * dt
    vnew = v + half_dt * a
    xnew = x + dt * vnew
    anew = force(xnew)
    vnew = vnew + half_dt * anew
    return xnew, vnew, anew
end

end
