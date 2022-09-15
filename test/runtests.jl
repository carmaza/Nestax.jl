# Distributed under the MIT License.
# See LICENSE for details.

using Test

@testset verbose = true "All tests" begin
    all_tests = ["neutron_star", "vacuum"]

    for name in all_tests
        include("$name.jl")
    end
end
