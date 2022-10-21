# Distributed under the MIT License.
# See LICENSE for details.

using Random
using Test

include("../src/Orbits/Profiles/Profiles.jl")

function test()
    seed = Random.rand(1:(10^10))
    rng = Random.Xoshiro(seed)

    @testset verbose = true "Exponential | Seed: $seed" begin
        @testset verbose = true "R90" begin
            @test isapprox(2.661, Profiles.Exponential.r90())
        end

        @testset verbose = true "Number fraction" begin
            N = Random.rand(4:10)
            r = [0.2 * k for k in 1:N]

            frac = Vector{Float64}(undef, N)
            Profiles.Exponential.number_fraction!(frac, r)

            frac_expected = Vector{Float64}(undef, N)
            for k in 1:N
                frac_expected[k] =
                    exp(-2.0 * r[k]) * (1.0 + 2.0 * r[k] + 2.0 * r[k]^2.0)
            end

            @test isapprox(frac, frac_expected)
        end
    end
    return nothing
end

test()
