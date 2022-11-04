# Distributed under the MIT License.
# See LICENSE for details.

using Random
using LinearAlgebra
using StaticArrays
using Test

include("../src/Axion/Orbits/inverse_square_law.jl")
include("../src/Axion/Orbits/leapfrog.jl")

function test()
    seed = Random.rand(1:(10^10))
    rng = Xoshiro(seed)

    # Specific acceleration doesn't matter.
    acceleration = InverseSquareLaw.acceleration

    @testset verbose = true "Leapfrog | Seed: $seed" begin
        @testset "Update" begin
            dt = 1.e-3 * Random.randn(rng)
            N = Random.rand(rng, 1:10)

            x = Vector{SVector{3, Float64}}(undef, N)
            v = Vector{SVector{3, Float64}}(undef, N)
            a = Vector{SVector{3, Float64}}(undef, N)
            e = Vector{Float64}(undef, N)
            for i in 1:length(x)
                x[i] = Random.randn(rng, 3)
                v[i] = Random.randn(rng, 3)
                a[i] = acceleration(x[i])
                e[i] = 0.5 * norm(v[i])^2 - 1.0 / norm(x[i])
            end

            # Copies to compare with later.
            x_updated = x
            v_updated = v
            a_updated = a

            # From copies, calculated expected after updating.
            for i in 1:N
                v_new = v[i] + 0.5 * dt * a[i]
                x_new = x[i] + dt * v_new
                a_new = acceleration(x[i])
                v_new = v_new + 0.5 * dt * a_new
                x_updated[i] = x_new
                v_updated[i] = v_new
                a_updated[i] = a_new
            end

            for i in 1:N
                x[i], v[i], a[i] = Leapfrog.update(
                    x[i],
                    v[i],
                    a[i];
                    force = acceleration,
                    dt = dt
                )
            end

            @test isapprox(x_updated, x)
            @test isapprox(v_updated, v)
            @test isapprox(a_updated, a)

            e_new = Vector{Float64}(undef, N)
            for i in 1:length(x)
                e_new[i] = 0.5 * norm(v_updated[i])^2 - 1.0 / norm(x_updated[i])
            end

            # Energy should be conserved within truncation error.
            @test isapprox(e, e_new, atol = 1.e-5, rtol = 1.e-5)
        end
    end
    return nothing
end

test()
