# Distributed under the MIT License.
# See LICENSE for details.

using Random
using Test

include("../src/Axion/Profiles/Profiles.jl")

function test()
    seed = Random.rand(1:(10^10))
    rng = Random.Xoshiro(seed)

    @testset verbose = true "EighthPower | Seed: $seed" begin
        @testset verbose = true "R90" begin
            @test isapprox(2.5549901960650603, Profiles.EighthPower.r90())
        end

        alpha = Profiles.EighthPower.alpha()

        @testset verbose = true "Particle density" begin
            N = Random.rand(4:10)
            r = Random.randn(rng, N)

            d = Vector{Float64}(undef, N)
            Profiles.EighthPower.particle_density!(d, r)

            d_expected = Vector{Float64}(undef, N)
            pre = 1024.0 * alpha^3.0 / (33.0 * pi^2.0)
            for k in 1:N
                d_expected[k] = pre / (1.0 + (alpha * r[k])^2.0)^8.0
            end

            @test isapprox(d, d_expected)
        end

        @testset verbose = true "Particle number" begin
            N = Random.rand(4:10)
            r = [0.2 * k for k in 1:N]

            n = Vector{Float64}(undef, N)
            Profiles.EighthPower.particle_number!(n, r)

            n_expected = Vector{Float64}(undef, N)
            pre = 2.0 / 3465.0 / pi
            for k in 1:N
                x = alpha * r[k]
                n_expected[k] =
                    pre * (
                        x * (
                            -3465.0 +
                            48580 * x^2.0 +
                            11.0 *
                            x^4.0 *
                            (
                                8393.0 +
                                9216.0 * x^2.0 +
                                5943.0 * x^4.0 +
                                2100.0 * x^6.0 +
                                315.0 * x^8.0
                            )
                        ) / (1.0 + x^2.0)^7.0 + 3465.0 * atan(x)
                    )
            end

            @test isapprox(n, n_expected)
        end
    end
    return nothing
end

test()
