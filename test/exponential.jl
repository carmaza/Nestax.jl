# Distributed under the MIT License.
# See LICENSE for details.

using Random
using Test

include("../src/Axion/Profiles/Profiles.jl")

function test()
    seed = Random.rand(1:(10^10))
    rng = Random.Xoshiro(seed)

    @testset verbose = true "Exponential | Seed: $seed" begin
        @testset verbose = true "R90" begin
            @test isapprox(2.661, Profiles.Exponential.r90())
        end

        @testset verbose = true "Particle number" begin
            N = Random.rand(4:10)
            r = [0.2 * k for k in 1:N]

            n = Vector{Float64}(undef, N)
            Profiles.Exponential.particle_number!(n, r)

            n_expected = Vector{Float64}(undef, N)
            for k in 1:N
                n_expected[k] =
                    1.0 - exp(-2.0 * r[k]) * (1.0 + 2.0 * r[k] + 2.0 * r[k]^2.0)
            end

            @test isapprox(n, n_expected)
        end
    end
    return nothing
end

test()
