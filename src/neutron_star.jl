# Distributed under the MIT License.
# See LICENSE for details.

Base.@kwdef struct NeutronStar{T <: Vector{Float64}}
    magnetic_moment::T = [0.0, 0.0, 0.5]
end

function conversion_radius!(
    radius::AbstractArray{Float64},
    angle::AbstractArray{Float64}
)
    if size(radius) != size(angle)
        throw(AssertionError("sizes of `radius` and `angle` are not equal."))
    end

    radius[:] = abs.((3 * cos.(angle) .^ 2 .- 1) ./ 2) .^ (1 / 3)
end

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
