# Distributed under the MIT License.
# See LICENSE for details.

module InverseSquareLaw

using LinearAlgebra
using StaticArrays

"""
    acceleration(x)

The acceleration on a test particle produced by a point mass at the origin.

## Arguments

  - `x::SVector{3, Float64}`: the Cartesian position of the test particle.

## Returns

  - `SVector{3, Float}`: the Cartesian acceleration.
"""
function acceleration(x::SVector{3, Float64})
    return -x / norm(x)^3
end

"""
    energy(x, v)

The total energy of a test particle orbiting a point mass at the origin.

## Arguments

  - `x::SVector{3, Float64}`: the Cartesian position of the test particle.
  - `v::SVector{3, Float64}`: the Cartesian velocity of the test particle.

## Returns

  - `Float64`: the total energy.
"""
function energy(x::SVector{3, Float64}, v::SVector{3, Float64})
    return 0.5 * norm(v)^2 - 1.0 / norm(x)
end

end
