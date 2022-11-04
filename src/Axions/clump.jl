# Distributed under the MIT License.
# See LICENSE for details.

using StaticArrays

"""
    Clump(gamma, fa, N, profile, distribution, position, velocity)

Class representing the properties of an axion clump.

## Members

  - `gamma::Float64`: equal to 1 - 3 mu md/(mu + md)^2.
  - `fa::Float64`: the PQ symmetry breaking scale, in units of 6e11 GeV.
  - `N:Int`: the number of particles in the clump.
  - `profile::Module`: the spherical profile of the particle density.
  - `distribution::Module`: the angular distribution of particles on each shell.
  - `position::SVector{3, Float64}`: the initial position in Cartesian space.
  - `velocity::SVector{3, Float64}`: the initial velocity in Cartesian space.
"""
Base.@kwdef struct Clump
    gamma::Float64
    fa::Float64
    N::Int
    profile::Module
    distribution::Module
    position::SVector{3, Float64}
    velocity::SVector{3, Float64}
end
