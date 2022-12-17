# Distibuted unde the MIT License.
# See LICENSE for details.

module EighthPower

"""
    r90()

The R_90 radius of the profile.
"""
function r90()
    return 2.5549901960650603
end

"""
    alpha()

The lengthscale set by the condition rho(R_c) = 0.5 rho_c, where rho_c
is the central density.
"""
function alpha()
    return sqrt(2.0^(0.125) - 1.0)
end

"""
    particle_density!(d, r)

For a spherical distribution of N particles, this function computes the density
of particles at a radial coordinate r.

## Arguments

    - `d::Vector{Float64}`: the density of particles.
    - `r::Vector{Float64}`: the radial coordinate.
"""
function particle_density!(d::Vector{Float64}, r::Vector{Float64})
    for k in eachindex(d)
        d[k] =
            (1024.0 * alpha()^3 / (33.0 * pi^2.0)) /
            (1.0 + (alpha() * r[k])^2.0)^8.0
    end
end

"""
    particle_number!(n, r)

For a spherical distribution of N particles, this function computes n(r),
the number of particles enclosed in a radius r.

## Arguments

    - `n::Vector{Float64}`: the number of particles.
    - `r::Vector{Float64}`: the radius of the sphere enclosing the particles.
"""
function particle_number!(n::Vector{Float64}, r::Vector{Float64})
    pre = 2.0 / (3465.0 * pi)
    for k in eachindex(n)
        x = alpha() * r[k]
        x_sqrd = x * x
        n[k] =
            pre * (
                x * (
                    -3465.0 +
                    x_sqrd * (
                        48580.0 +
                        11.0 *
                        x_sqrd *
                        (
                            8393.0 +
                            x_sqrd * (
                                9216.0 +
                                x_sqrd *
                                (5943.0 + x_sqrd * (2100.0 + 315.0 * x_sqrd))
                            )
                        )
                    )
                ) / (1.0 + x_sqrd)^7.0 + 3465.0 * atan(x)
            )
    end
end

end
