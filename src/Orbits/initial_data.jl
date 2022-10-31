# Distributed under the MIT License.
# See LICENSE for details.

module InitialData

using Random
using StaticArrays

include("./euclidean.jl")
include("./shell.jl")

"""
    set!(x, v, clump, Nshells, write=true)

Set the initial positions and velocities of each particle in the axion clump.
The effective number of particles to evolve is computed in this function, using
as input the total number of particles in the clump, as well as their profile
and distributions. Currently, this function will choose all particles inside of
R90, i.e. the radius within which 90% of the particles are enclosed.

## Arguments

  - `x::Vector{SVector{3, Float64}}, v::Vector{SVector{3, Float64}}`: the
    Cartesian positions and velocities of each particle. Note that these must be
    uninitialized arrays.
  - `clump`: the clump. Must hold particles' profile and angular distribution on
    a particular spherical shell.
  - `Nshells`: the number of shells used to distribute the particles in the
    clump.
  - `write`: whether to write to disk the initial position of each particle.
    (Default: true)
"""
function set!(
    x::Vector{SVector{3, Float64}},
    v::Vector{SVector{3, Float64}},
    clump,
    Nshells,
    write = true
)
    N = clump.N % UInt64
    dr = clump.profile.r90() / Nshells
    bounds = [dr * k for k in 0:Nshells]
    numbers = Vector{Int}(undef, Nshells)
    Shell.particle_number!(numbers, clump.profile, N, bounds)

    # Assign radial coordinate of each shell to outer bound.
    # TO-DO: maybe assign bounds average instead?
    popfirst!(bounds) # Delete origin.
    R = 40.0 * sqrt(clump.gamma)
    for k in eachindex(bounds)
        bounds[k] *= R
    end

    Neff = sum(numbers)
    for i in 1:Neff
        push!(x, clump.position)
    end

    seed = Random.rand(1:(10^10))
    rng = Random.Xoshiro(seed)
    shift = 0
    for k in eachindex(numbers)
        n = numbers[k]
        if n > 0
            theta = Vector{Float64}(undef, n)
            phi = Vector{Float64}(undef, n)
            clump.distribution.set_angles!(theta, phi)

            axis = SVector{3}(Random.randn(rng, 3))
            angle = Random.randn(rng)
            for j in 1:n
                ind = j + shift
                x[ind] += Euclidean.rotated_about(
                    Euclidean.cartesian_from_spherical(
                        bounds[k],
                        theta[j],
                        phi[j]
                    ),
                    axis,
                    angle
                )
            end
        end
        shift += n
    end

    for i in 1:Neff
        push!(v, clump.velocity)
    end

    if write
        initial = open("initial.dat", "w+")
        for i in 1:Neff
            println(initial, x[i][1], " ", x[i][2], " ", x[i][3])
        end
        close(initial)
    end
    return nothing
end

end
