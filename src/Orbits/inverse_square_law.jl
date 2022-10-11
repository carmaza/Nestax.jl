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

end
