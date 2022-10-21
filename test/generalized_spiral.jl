# Distributed under the MIT License.
# See LICENSE for details.

using Random
using Test

include("../src/Orbits/Distributions/generalized_spiral.jl")

function test()
    seed = Random.rand(1:(10^10))
    rng = Random.Xoshiro(seed)

    @testset verbose = true "Generalized Spiral | Seed: $seed" begin
        N = UInt64(Random.rand(rng, 2:10))

        h = Vector{Float64}(undef, N)
        GeneralizedSpiral._h!(h)

        @testset verbose = true "Functions h and phi" begin
            h_expected = [-1.0 + 2.0 * (l - 1.0) / (N - 1.0) for l in 1:N]
            @test isapprox(h, h_expected)

            phase = GeneralizedSpiral._phase(h[1], N)
            phase_expected = 3.6 / sqrt(N * (1.0 - h[1]^2))

            @test isapprox(phase, phase_expected)
        end

        @testset verbose = true "Set angles" begin
            theta = Vector{Float64}(undef, N)
            phi = Vector{Float64}(undef, N)
            GeneralizedSpiral.set_angles!(theta, phi)

            theta_expected = [acos(hl) for hl in h]
            phi_expected = zeros(N)

            for l in 2:(N - 1)
                phi_expected[l] =
                    phi_expected[l - 1] + GeneralizedSpiral._phase(h[l], N)
            end

            @test isapprox(theta, theta_expected)
            @test isapprox(phi, phi_expected)
        end
    end
    return nothing
end

test()
