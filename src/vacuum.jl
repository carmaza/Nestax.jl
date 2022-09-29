# Distributed under the MIT License.
# See LICENSE for details.

"""
    vacuum!(dw::Matrix{Float64}, w::Matrix{Float64}, p, t)

The right-hand side of the Eikonal equation for a vacuum dispersion
relation.
"""
function vacuum!(dw::Matrix{Float64}, w::Matrix{Float64}, p, t)
    inv_k_norm = 1.0 ./ sqrt.(w[:, 4] .^ 2.0 + w[:, 5] .^ 2.0 + w[:, 6] .^ 2.0)
    dw[:, 1:3] = inv_k_norm .* w[:, 4:6]
    dw[:, 4:7] .= 0.0
end
