# Distributed under the MIT License.
# See LICENSE for details.

using Test

@testset "All tests" begin
    all_tests = ["vacuum"]

    for name in all_tests
        print("Running $name.jl. ")
        include("$name.jl")
    end
end
