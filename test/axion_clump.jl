# Distributed under the MIT License.
# See LICENSE for details.

using Random
using StaticArrays
using Test

include("../src/Orbits/Distributions/Distributions.jl")
include("../src/Orbits/Profiles/Profiles.jl")
include("../src/Orbits/axion_clump.jl")

function test()
    seed = Random.rand(1:(10^10))
    rng = Xoshiro(seed)

    @testset verbose = true "Axion Clump | Seed: $seed" begin
        @testset "Class" begin
            gamma = Random.randn(rng)
            fa = Random.randn(rng)
            N = Random.rand(100:1000)
            profile = Profiles.Exponential
            distribution = Distributions.GeneralizedSpiral
            position = SVector{3, Float64}(Random.randn(rng, 3))
            velocity = SVector{3, Float64}(Random.randn(rng, 3))

            clump = AxionClump(
                gamma,
                fa,
                N,
                profile,
                distribution,
                position,
                velocity
            )

            @test isapprox(gamma, clump.gamma)
            @test isapprox(fa, clump.fa)
            @test isequal(N, clump.N)
            @test isequal(profile, clump.profile)
            @test isequal(distribution, clump.distribution)
            @test isapprox(position, clump.position)
            @test isapprox(velocity, clump.velocity)
        end
    end
    return nothing
end

test()
