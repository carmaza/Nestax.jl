# Distributed under the MIT License.
# See LICENSE for details.

using Random
using LinearAlgebra
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

        @testset "RotatedAbout" begin
            v = SVector{3, Float64}(Random.randn(rng, 3))
            k = SVector{3, Float64}(Random.randn(rng, 3))
            a = Random.randn(rng)

            v_rot = Euclidean.rotated_about(v, k, a)

            u = k / sqrt(k[1]^2 + k[2]^2 + k[3]^2)
            v_expected =
                v * cos(a) +
                sin(a) * cross(u, v) +
                u * dot(u, v) * (1.0 - cos(a))
            @test isapprox(v_rot, v_expected)
        end
    end
    return nothing
end

test()
