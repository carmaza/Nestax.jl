# Distributed under the MIT License.
# See LICENSE for details.

module GeneralizedSpiral

function _h!(h::Vector{Float64})
    N = size(h)[1]
    pref = 2.0 / (N - 1.0)
    for l in 1:N
        h[l] = -1.0 + pref * (l - 1.0)
    end
end

function _phase(h::Float64, N::UInt64)
    return 3.6 / sqrt(N * (1.0 - h^2.0))
end

function set_angles!(theta::Vector{Float64}, phi::Vector{Float64})
    N = UInt64(size(theta, 1))

    h = Vector{Float64}(undef, N)
    _h!(h)

    for l in eachindex(theta)
        theta[l] = acos(h[l])
    end

    phi[1] = 0.0
    for l in 2:(N - 1)
        phi[l] = phi[l - 1] + _phase(h[l], N)
    end
    phi[N] = 0.0
end

end
