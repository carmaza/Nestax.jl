# Distributed under the MIT License.
# See LICENSE for details.

"""
    NeutronStar(magnetic_moment[0.0, 0.0, 0.5])

A class containing functions depending on neutron star properties.

...

# Members

  - `magnetic_moment::Vector{Float64}`: the Cartesian components of the magnetic
    moment.
    ...
"""
Base.@kwdef struct NeutronStar{T <: Vector{Float64}}
    magnetic_moment::T = [0.0, 0.0, 0.5]
end

"""
    conversion_radius!(radius::AbstractArray{Float64}, angle::AbstractArray{Float64})

The axion-photon conversion radius as a function of the misalignment angle
between the magnetic axis and the rotation axis.

...

# Parameters

  - `radius::AbstractArray{Float64}`: the conversion radius.
  - `angle::AbstractArray{Float64}` : the misalignment angle.
    ...
"""
function conversion_radius!(
    radius::AbstractArray{Float64},
    angle::AbstractArray{Float64}
)
    if size(radius) != size(angle)
        throw(AssertionError("sizes of `radius` and `angle` are not equal."))
    end

    radius[:] = abs.(0.5 * (3.0 * cos.(angle) .^ 2.0 .- 1)) .^ (1.0 / 3.0)
end

"""
    conversion_surface!(pos::Matrix{Float64}, theta::Vector{Float64}, phi::Vector{Float64})

The Cartesian points on the axion-photon conversion surface evaluated at the
given spherical angles.

The ordering convention for spherical coordinates is r, theta, phi.

This function is specialized to no misalignment between the magnetic and
rotational axes.
...

# Parameters

  - `pos::Matrix{Float64}`: the Cartesian points on the surface.
  - `theta::Vector{Float64}, phi::vector{Float64}`: the spherical angles.
    ...
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
