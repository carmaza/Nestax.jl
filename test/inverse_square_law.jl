# Distributed under the MIT License.
# See LICENSE for details.

using Random
using StaticArrays
using Test

include("../src/Orbits/inverse_square_law.jl")

function test()
    seed = Random.rand(1:(10^10))
    rng = Xoshiro(seed)

    @testset verbose = true "InverseSquareLaw | Seed: $seed" begin
        @testset "Acceleration" begin
            x = SVector{3, Float64}(Random.randn(rng, 3))
            acc = InverseSquareLaw.acceleration(x)

            acc_expected = -1.0 * x / (x[1]^2 + x[2]^2 + x[3]^2)^1.5
            @test isapprox(acc, acc_expected)
        end

        @testset "Energy" begin
            x = SVector{3, Float64}(Random.randn(rng, 3))
            v = SVector{3, Float64}(Random.randn(rng, 3))
            e = InverseSquareLaw.energy(x, v)

            e_expected =
                0.5 * (v[1]^2 + v[2]^2 + v[3]^2) -
                1.0 / sqrt(x[1]^2 + x[2]^2 + x[3]^2)
            @test isapprox(e, e_expected)
        end
    end
end

test()
