# Distributed under the MIT License.
# See LICENSE for details.

using Random
using StaticArrays
using Test

include("../src/Orbits/euclidean.jl")

function test()
    seed = Random.rand(1:(10^10))
    rng = Xoshiro(seed)

    @testset verbose = true "Euclidean | Seed: $seed" begin
        @testset "CartesianFromSpherical" begin
            r = Random.rand(rng)
            theta = Random.randn(rng)
            phi = Random.randn(rng)

            cart = Euclidean.cartesian_from_spherical(r, theta, phi)

            expected = Vector{Float64}(undef, 3)
            expected[1] = r * sin(theta) * cos(phi)
            expected[2] = r * sin(theta) * sin(phi)
            expected[3] = r * cos(theta)
            cart_expected = SVector{3, Float64}(expected)

            @test isapprox(cart, cart_expected)
        end
    end
end

test()
