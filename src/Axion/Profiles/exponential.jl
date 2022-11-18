# Distibuted unde the MIT License.
# See LICENSE for details.

module Exponential

"""
    r90()

The R_90 radius of the profile.
"""
function r90()
    return 2.661160168917105
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
        d[k] = exp(-2.0 * r[k]) / pi
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
        n[k] = 1.0 - exp(-2.0 * r[k]) * (1.0 + 2.0 * r[k] * (1.0 + r[k]))
    end
end

end
