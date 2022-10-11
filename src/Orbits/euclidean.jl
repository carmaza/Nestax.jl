# Distributed under the MIT License.
# See LICENSE for details.

module Euclidean

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

end
