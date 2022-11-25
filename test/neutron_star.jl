# Distributed under the MIT License.
# See LICENSE for details.

using LinearAlgebra
using Random
using StaticArrays
using Test

include("../src/neutron_star.jl")

function test()
    seed = Random.rand(1:(10^10))
    rng = Xoshiro(seed)

    @testset verbose = true "NeutronStar | Seed: $seed" begin
        @testset "Class" begin
            mass = Random.rand(rng)
            radius = Random.rand(rng)
            period = Random.rand(rng)
            unn_rotation_axis = SVector{3, Float64}(Random.randn(rng, 3))
            magnetic_moment = SVector{3, Float64}(Random.randn(rng, 3))
            ns = NeutronStar(
                mass,
                radius,
                period,
                unn_rotation_axis,
                magnetic_moment
            )

            @test isa(ns, NeutronStar)
            @test isapprox(mass, ns.mass)
            @test isapprox(radius, ns.radius)
            @test isapprox(period, ns.period)
            @test isapprox(
                unn_rotation_axis / norm(unn_rotation_axis),
                ns.rotation_axis
            )
            @test isapprox(magnetic_moment, ns.magnetic_moment)
            @test isapprox((2.0 * pi / period), norm(ns.angular_velocity))
        end

        @testset "ConversionRadius" begin
            n_the::UInt64 = Random.rand(rng, 2:5)
            angle = Random.randn(rng, n_the)
            rad = Vector{Float64}(undef, n_the)
            conversion_radius!(rad, angle)

            rad_expected =
                abs.((3.0 * cos.(angle) .^ 2.0 .- 1.0) / 2.0) .^ (1.0 / 3.0)

            @test isapprox(rad, rad_expected)
            @test_throws AssertionError conversion_radius!(
                Random.randn(rng, 3),
                Random.randn(rng, 4)
            )
        end

        @testset "ConversionSurface" begin
            n_the = Random.rand(rng, 2:5)
            n_phi::UInt64 = Random.rand(rng, 2:5)
            n_surf = n_the * n_phi

            theta = Random.randn(rng, n_the)
            phi = Random.randn(rng, n_phi)
            surf = Matrix{Float64}(undef, n_surf, 3)
            conversion_surface!(surf, theta, phi)

            rad = Random.randn(rng, size(theta))
            conversion_radius!(rad, theta)

            surf_expected = Matrix{Float64}(undef, n_surf, 3)
            for k in 1:n_phi
                inc = (k - 1) * n_the
                for j in 1:n_the
                    q = j + inc
                    surf_expected[q, 1] = rad[j] * sin(theta[j]) * cos(phi[k])
                    surf_expected[q, 2] = rad[j] * sin(theta[j]) * sin(phi[k])
                    surf_expected[q, 3] = rad[j] * cos(theta[j])
                end
            end

            @test isapprox(surf, surf_expected)
            @test_throws AssertionError conversion_surface!(
                Random.randn(rng, 3, 4),
                Random.randn(rng, 2),
                Random.randn(rng, 3)
            )
        end
    end
    return nothing
end

test()
