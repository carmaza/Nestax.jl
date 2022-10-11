# Distributed under the MIT License.
# See LICENSE for details.

module Euclidean

using LinearAlgebra
using StaticArrays

"""
    cartesian_from_spherical(r, theta, phi)

Return the Cartesian components of the given spherical coordinates.

## Arguments

  - `r::Float64, theta::Float64, phi::Float64`: the spherical coordinates.

## Returns

  - `SVector{3, Float}`: the Cartesian coordinates.
"""
function cartesian_from_spherical(r::Float64, theta::Float64, phi::Float64)
    return SVector{3, Float64}(
        r * [sin(theta) * cos(phi), sin(theta) * sin(phi), cos(theta)]
    )
end

"""
    rotate_about(v, k, a)

Rotate the given vector using Rodrigues' axis-angle formula.

## Arguments

  - `v::SVector{3, Float64}`: the vector to be rotated.
  - `k::SVector{3, Float64}`: the axis of rotation.
  - `a::Float64`: the angle of rotation.

## returns

  - `SVector{3, Float64}`: the vector after its rotated.
"""
function rotate_about(
    v::SVector{3, Float64},
    k::SVector{3, Float64},
    a::Float64
)
    k_unit = k / norm(k)
    return v * cos(a) +
           cross(k_unit, v) * sin(a) +
           k_unit * dot(k_unit, v) * (1.0 - cos(a))
end
end
