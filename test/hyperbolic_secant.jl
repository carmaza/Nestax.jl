# Distributed under the MIT License.
# See LICENSE for details.

using Polylogarithms
using Random
using Test

include("../src/Axion/Profiles/Profiles.jl")

function test()
    seed = Random.rand(1:(10^10))
    rng = Random.Xoshiro(seed)

    @testset verbose = true "HyperbolicSecant | Seed: $seed" begin
        @testset verbose = true "R90" begin
            @test isapprox(2.799014381010456, Profiles.HyperbolicSecant.r90())
        end

        @testset verbose = true "Particle density" begin
            N = Random.rand(4:10)
            r = Random.randn(rng, N)

            d = Vector{Float64}(undef, N)
            Profiles.HyperbolicSecant.particle_density!(d, r)

            d_expected = Vector{Float64}(undef, N)
            for k in 1:N
                d_expected[k] = 3.0 * sech(r[k])^2.0 / pi^3.0
            end

            @test isapprox(d, d_expected)
        end

        @testset verbose = true "Particle number" begin
            N = Random.rand(4:10)
            r = [0.2 * k for k in 1:N]

            n = Vector{Float64}(undef, N)
            Profiles.HyperbolicSecant.particle_number!(n, r)

            n_expected = Vector{Float64}(undef, N)
            for k in 1:N
                n_expected[k] =
                    1.0 +
                    12.0 * (
                        real.(polylog(2.0, -exp(-2.0 * r[k]))) -
                        r[k] * (
                            r[k] * (1.0 - tanh(r[k])) +
                            2.0 * log(1.0 + exp(-2.0 * r[k]))
                        )
                    ) / pi^2.0
            end

            @test isapprox(n, n_expected)
        end
    end
    return nothing
end

test()
