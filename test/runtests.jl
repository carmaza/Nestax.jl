# Distributed under the MIT License.
# See LICENSE for details.

using Test

@testset verbose = true "All tests" begin
    all_tests = [
        "clump",
        "euclidean",
        "exponential",
        "generalized_spiral",
        "inverse_square_law",
        "leapfrog",
        "neutron_star",
        "shell",
        "vacuum"
    ]

    for name in all_tests
        include("$name.jl")
    end
end
