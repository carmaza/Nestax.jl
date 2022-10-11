module InverseSquareLaw

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
    pref = -1.0 / (x[1]^2 + x[2]^2 + x[3]^2)^1.5
    return pref * x
end

end
