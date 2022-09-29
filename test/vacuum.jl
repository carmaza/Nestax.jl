# Distributed under the MIT License.
# See LICENSE for details.

using Random
using Test

include("../src/vacuum.jl")

function test()
    seed = rand(1:(10^10))
    rng = Random.MersenneTwister(seed)

    @testset verbose = true "Vacuum | Seed: $seed" begin
        N = Random.rand(rng, 2:10)
        w = Random.randn(rng, N, 7)

        dw = Matrix{Float64}(undef, N, 7)
        vacuum!(dw, w, 0, 0)

        dw_expected = Matrix{Float64}(undef, N, 7)
        for i in 1:N
            inv_k_norm = 1.0 / sqrt(w[i, 4]^2.0 + w[i, 5]^2.0 + w[i, 6]^2.0)
            dw_expected[i, 1] = inv_k_norm * w[i, 4]
            dw_expected[i, 2] = inv_k_norm * w[i, 5]
            dw_expected[i, 3] = inv_k_norm * w[i, 6]
            for j in 4:7
                dw_expected[i, j] = 0.0
            end
        end

        @test Base.isapprox(dw, dw_expected)
    end
end

test()
