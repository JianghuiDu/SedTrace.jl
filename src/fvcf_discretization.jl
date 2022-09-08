# finite volume complete flux
@inline Afun(zᵢ, zᵢ₊₁, Peᵢ, Peᵢ₊₁) =
    zᵢ * zᵢ₊₁ /
    ((-exp(-Peᵢ / 2 - Peᵢ₊₁ / 2) + exp(-Peᵢ / 2)) * zᵢ + (1 - exp(-Peᵢ / 2)) * zᵢ₊₁)


@inline Bfunₗ(hᵢ, uᵢ, φᵢ, uᵢ₊₁, φᵢ₊₁, Peᵢ, Peᵢ₊₁) =
    hᵢ * (exp(-Peᵢ / 2.0) / (uᵢ * Peᵢ) + 1.0 / (2.0*uᵢ) - 1 / (uᵢ * Peᵢ)) / (
        (1 - exp(-Peᵢ / 2)) / (uᵢ * φᵢ) +
        (exp(-Peᵢ / 2) - exp(-Peᵢ / 2 - Peᵢ₊₁ / 2)) / (uᵢ₊₁ * φᵢ₊₁)
    )

@inline Bfunᵤ(hᵢ₊₁, uᵢ, φᵢ, uᵢ₊₁, φᵢ₊₁, Peᵢ, Peᵢ₊₁) =
    hᵢ₊₁ * (
        exp(-Peᵢ / 2) / (uᵢ₊₁ * Peᵢ₊₁) - exp(-Peᵢ / 2 - Peᵢ₊₁ / 2) / (uᵢ₊₁ * Peᵢ₊₁) -
        1 / 2 / (uᵢ₊₁) * exp(-Peᵢ / 2 - Peᵢ₊₁ / 2)
    ) / (
        (1 - exp(-Peᵢ / 2)) / (uᵢ * φᵢ) +
        (exp(-Peᵢ / 2) - exp(-Peᵢ / 2 - Peᵢ₊₁ / 2)) / (uᵢ₊₁ * φᵢ₊₁)
    )



function fvcf(φ, D, u, dx, N)
    D.+=eps()
    Pe = u .* dx ./ D
    Aₗ = zeros(N - 1)
    Aᵤ = zeros(N - 1)
    Aₘ = zeros(N)
    Aₘₗ = zeros(N)
    Aₘᵤ = zeros(N)

    Bₗ = zeros(N - 1)
    Bᵤ = zeros(N - 1)
    Bₘ = zeros(N)
    Bₘₗ = zeros(N)
    Bₘᵤ = zeros(N)


    for i = 1:(N-1)
        Aₗ[i] = Afun(u[i]φ[i], u[i+1]φ[i+1], Pe[i], Pe[i+1]) / (dx[i+1]φ[i+1])
        Aₘₗ[i+1] =
            -Afun(u[i]φ[i], u[i+1]φ[i+1], Pe[i], Pe[i+1]) * exp(-Pe[i] / 2 - Pe[i+1] / 2) /
            (dx[i+1]φ[i+1])
        Aₘᵤ[i] = -Afun(u[i]φ[i], u[i+1]φ[i+1], Pe[i], Pe[i+1]) / (dx[i]φ[i])
        Aᵤ[i] =
            Afun(u[i]φ[i], u[i+1]φ[i+1], Pe[i], Pe[i+1]) * exp(-Pe[i] / 2 - Pe[i+1] / 2) /
            (dx[i]φ[i])

        Bₗ[i] = Bfunₗ(dx[i], u[i], φ[i], u[i+1], φ[i+1], Pe[i], Pe[i+1]) / (dx[i+1]φ[i+1])
        Bₘₗ[i+1] =
            -Bfunᵤ(dx[i+1], u[i], φ[i], u[i+1], φ[i+1], Pe[i], Pe[i+1]) / (dx[i+1]φ[i+1])
        Bₘᵤ[i] = -Bfunₗ(dx[i], u[i], φ[i], u[i+1], φ[i+1], Pe[i], Pe[i+1]) / (dx[i]φ[i])
        Bᵤ[i] = Bfunᵤ(dx[i+1], u[i], φ[i], u[i+1], φ[i+1], Pe[i], Pe[i+1]) / (dx[i]φ[i])
    end

    Aₘ .= Aₘₗ .+ Aₘᵤ
    A = Tridiagonal(Aₗ, Aₘ, Aᵤ)
    Bₘ .= Bₘₗ .+ Bₘᵤ #.+ 1.0
    B = Tridiagonal(Bₗ, Bₘ, Bᵤ)


    return (A, B)
end


function fvcf_bc(φ, D, u, dx, BC::Tuple{Tuple,Tuple}, N, ads = false)
    A_bc = zeros(2)
    B_bc = zeros(2)
    b_bc = zeros(2)

    if ads
        A_bc[1] = u[1]φ[1] / (dx[1]φ[1])
        A_bc[2] = -u[N]φ[N] / (dx[N]φ[N])
        b_bc[1] = 0
        b_bc[2] = 0
    else
        α⁰, β⁰, γ⁰ = BC[1]
        αᴸ, βᴸ, γᴸ = BC[2]

        D.+=eps()
        Pe = u .* dx ./ D

        A_bc[1] =
            u[1]φ[1] * exp(-Pe[1] / 2) * (α⁰ * D[1] + β⁰ * u[1]) /
            (α⁰ * D[1] * exp(-Pe[1] / 2) - α⁰ * D[1] + β⁰ * u[1] * exp(-Pe[1] / 2)) /
            (dx[1]φ[1])
        A_bc[2] =
            u[N]φ[N] * (αᴸ * D[N] + βᴸ * u[N]) /
            (αᴸ * D[N] * exp(-Pe[N] / 2) - αᴸ * D[N] - βᴸ * u[N]) / (dx[N]φ[N])

        B_bc[1] =
            (α⁰ * D[1] + β⁰ * u[1]) *
            (-exp(-Pe[1] / 2) / Pe[1] + 1 / Pe[1] - 1 / 2 * exp(-Pe[1] / 2)) /
            (α⁰ * D[1] * exp(-Pe[1] / 2) - α⁰ * D[1] + β⁰ * u[1] * exp(-Pe[1] / 2)) 
        B_bc[2] =
            (αᴸ * D[N] + βᴸ * u[N]) *
            (exp(-Pe[N] / 2) / Pe[N] - 1 / Pe[N] + 1 / 2) /
            (αᴸ * D[N] * exp(-Pe[N] / 2) - αᴸ * D[N] - βᴸ * u[N])


        b_bc[1] =
            φ[1]u[1]D[1] * γ⁰ /
            (-α⁰ * D[1] * exp(-Pe[1] / 2) + α⁰ * D[1] - β⁰ * u[1] * exp(-Pe[1] / 2)) /
            (dx[1]φ[1])
        b_bc[2] =
            φ[N]u[N]D[N] * γᴸ * exp(-Pe[N] / 2) /
            (-αᴸ * D[N] * exp(-Pe[N] / 2) + αᴸ * D[N] + βᴸ * u[N]) / (dx[N]φ[N])
    end
    return (A_bc, B_bc, b_bc)
end
