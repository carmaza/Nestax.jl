# Distibuted unde the MIT License.
# See LICENSE for details.

module HyperbolicSecant

using Polylogarithms

"""
    r90()

The R_90 radius of the profile.
"""
function r90()
    return 2.799014381010456
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
        d[k] = 3.0 * sech(r[k])^2.0 / pi^3.0
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
    for k in eachindex(n)
        n[k] =
            1.0 +
            12.0 * (
                # For numbers < 1, polylog gives a round-off imaginary part.
                # We get rid of it by simply taking the real part.
                real.(polylog(2.0, -exp(-2.0 * r[k]))) -
                r[k] *
                (r[k] * (1.0 - tanh(r[k])) + 2.0 * log(1.0 + exp(-2.0 * r[k])))
            ) / pi^2.0
    end
end

end
