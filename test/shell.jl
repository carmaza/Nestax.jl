# Distributed under the MIT License.
# See LICENSE for details.

using Random
using Test

include("../src/Axion/Profiles/exponential.jl")
include("../src/Axion/Orbits/shell.jl")

function test()
    seed = Random.rand(1:(10^10))
    rng = Random.Xoshiro(seed)

    @testset verbose = true "Shell | Seed: $seed" begin
        @testset verbose = true "Particle Number" begin
            N = UInt64(Random.rand(rng, 100:1000))
            nshells = Random.rand(rng, 3:10)

            profile = Exponential
            bounds = [0.1 * k for k in 0:nshells]

            numbers = Vector{Int}(undef, nshells)
            Shell.particle_number!(numbers, profile, N, bounds)

            fraction = Vector{Float64}(undef, length(bounds))
            profile.particle_number!(fraction, bounds)

            numbers_expected = Vector{Float64}(undef, nshells)
            for j in 1:nshells
                numbers_expected[j] = round(N * (fraction[j + 1] - fraction[j]))
            end

            @test isapprox(numbers, numbers_expected)
        end
    end
    return nothing
end

test()
