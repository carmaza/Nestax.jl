# Distributed under the MIT License.
# See LICENSE for details.

using LinearAlgebra
using StaticArrays

"""
    NeutronStar(magnetic_moment)

Class representing a neutron star.

## Members

  - `mass::Float64`: the mass, in solar masses.
  - `radius::Float64`: the radius, in kilometers.
  - `period::Float64`: the rotational period, in seconds.
  - `rotation_axis::SVector{3, Float64}`: the Cartesian components of the
    direction of the angular velocity. If not unit, this vector will be
    normalized internally in the constructor.
  - `magnetic_moment::SVector{3, Float64}`: the Cartesian components of the
    magnetic moment.
"""
Base.@kwdef struct NeutronStar{T <: SVector{3, Float64}}
    mass::Float64
    radius::Float64
    period::Float64
    rotation_axis::T
    magnetic_moment::T
    angular_velocity::T

    function NeutronStar{T}(
        mass::Float64,
        radius::Float64,
        period::Float64,
        rotation_axis::T,
        magnetic_moment::T
    ) where {T <: SVector{3, Float64}}
        rotation_axis = rotation_axis / norm(rotation_axis)
        angular_velocity =
            (2.0 * pi / period) * rotation_axis / norm(rotation_axis)
        return new(
            mass,
            radius,
            period,
            rotation_axis,
            magnetic_moment,
            angular_velocity
        )
    end
end

NeutronStar(
    mass::Float64,
    radius::Float64,
    period::Float64,
    rotation_axis::T,
    magnetic_moment::T
) where {T <: SVector{3, Float64}} =
    NeutronStar{T}(mass, radius, period, rotation_axis, magnetic_moment)

"""
    conversion_radius!(radius, angle)

The axion-photon conversion radius as a function of the misalignment angle
between the magnetic axis and the rotation axis.

## Parameters

  - `radius::AbstractArray{Float64}`: the conversion radius.
  - `angle::AbstractArray{Float64}` : the misalignment angle.
"""
function conversion_radius!(
    radius::AbstractArray{Float64},
    angle::AbstractArray{Float64}
)
    if size(radius) != size(angle)
        throw(AssertionError("sizes of `radius` and `angle` are not equal."))
    end

    @. radius[:] = abs(0.5 * (3.0 * cos(angle)^2.0 - 1.0))^(1.0 / 3.0)
end

"""
    conversion_surface!(pos, theta, phi)

The Cartesian points on the axion-photon conversion surface evaluated at the
given spherical angles.

The ordering convention for spherical coordinates is r, theta, phi.

This function is specialized to no misalignment between the magnetic and
rotational axes.

## Parameters

  - `pos::Matrix{Float64}`: the Cartesian points on the surface.
  - `theta::Vector{Float64}, phi::vector{Float64}`: the spherical angles.
"""
function conversion_surface!(
    pos::Matrix{Float64},
    theta::Vector{Float64},
    phi::Vector{Float64}
)
    if size(pos)[1] != size(theta)[1] * size(phi)[1]
        throw(
            AssertionError(
                "size of `pos` columns not equal to size of `theta` * size of `phi`."
            )
        )
    end

    rad = Random.randn(size(theta))
    conversion_radius!(rad, theta)
    pos[:] = hcat(
        vec(rad .* sin.(theta) .* adjoint(cos.(phi))),
        vec(rad .* sin.(theta) .* adjoint(sin.(phi))),
        vec(rad .* cos.(theta) .* adjoint(ones(size(phi))))
    )
end
