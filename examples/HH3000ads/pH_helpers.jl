struct EquilibriumInvariant
    # container of summed species like TCO2
    name::String
    species::Vector{String} # subspecies
    expr::Vector{String}
    coef::Vector{String} # subspecies coefficient in TA definition
    dTAdsum::String
    dTAdH::String
end

list_summed_species =
    ["TCO2", "TNH4", "TH3PO4", "TH2S", "THSO4", "TH3BO3", "THF", "TH4SiO4", "H"]

function EquilibriumInvariant(Tsum)
    if Tsum == "TCO2"
        return EquilibriumInvariant(
            "TCO2",
            ["HCO3", "CO3", "CO2"],
            [
                "H * KCO2 * TCO2 / (H^2 + H * KCO2 + KCO2 * KHCO3)",
                "KCO2 * KHCO3 * TCO2 / (H^2 + H * KCO2 + KCO2 * KHCO3)",
                "H^2 * TCO2 / (H^2 + H * KCO2 + KCO2 * KHCO3)",
            ],
            ["1", "2", "0"],
            "KCO2*(H + 2*KHCO3)/(H^2 + H*KCO2 + KCO2*KHCO3)",
            "-KCO2*TCO2*(H^2 + 4*H*KHCO3 + KCO2*KHCO3)/(H^2+ H*KCO2 + KCO2*KHCO3)^2",
        )
    elseif Tsum == "TNH4"
        return EquilibriumInvariant(
            "TNH4",
            ["NH3", "NH4"],
            ["KNH4 * TNH4 / (H + KNH4)", "KNH4 * TNH4 / (H + KNH4)"],
            ["1", "0"],
            "KNH4/(H + KNH4)",
            "-KNH4 * TNH4 / (H + KNH4)^2",
        )
    elseif Tsum == "TH3PO4"
        return EquilibriumInvariant(
            "TH3PO4",
            ["H3PO4", "H2PO4", "HPO4", "PO4"],
            [
                "H^3 * TH3PO4 / (H^3 + H^2 * KH3PO4 + H * KH2PO4 * KH3PO4 + KH2PO4 * KH3PO4 * KHPO4)",
                "H^2 * KH3PO4 * TH3PO4 / (H^3 + H^2 * KH3PO4 + H * KH2PO4 * KH3PO4 + KH2PO4 * KH3PO4 * KHPO4)",
                "H * KH2PO4 * KH3PO4 * TH3PO4 / (H^3 + H^2 * KH3PO4 + H * KH2PO4 * KH3PO4 + KH2PO4 * KH3PO4 * KHPO4)",
                "KH2PO4 * KH3PO4 * KHPO4 * TH3PO4 / (H^3 + H^2 * KH3PO4 + H * KH2PO4 * KH3PO4 + KH2PO4 * KH3PO4 * KHPO4)",
            ],
            ["-1", "0", "1", "2"],
            "H*KH2PO4*KH3PO4/(H^3 + H^2*KH3PO4 + H*KH2PO4*KH3PO4 + KH2PO4*KH3PO4*KHPO4) +
            2*KH2PO4*KH3PO4*KHPO4/(H^3 + H^2*KH3PO4 + H*KH2PO4*KH3PO4 + KH2PO4*KH3PO4*KHPO4) +
            -H^3/(H^3 + H^2*KH3PO4 + H*KH2PO4*KH3PO4 + KH2PO4*KH3PO4*KHPO4)",
            "-KH2PO4*KH3PO4*TH3PO4*(2*H^3 + H^2*KH3PO4 - KH2PO4*KH3PO4*KHPO4)/(H^3 + H^2*KH3PO4 + H*KH2PO4*KH3PO4 + KH2PO4*KH3PO4*KHPO4)^2 +
            -2*KH2PO4*KH3PO4*KHPO4*TH3PO4*(3*H^2 + 2*H*KH3PO4 + KH2PO4*KH3PO4)/(H^3 + H^2*KH3PO4 + H*KH2PO4*KH3PO4 + KH2PO4*KH3PO4*KHPO4)^2 +
            -H^2*KH3PO4*TH3PO4*(H^2 + 2*H*KH2PO4 + 3*KH2PO4*KHPO4)/(H^3 + H^2*KH3PO4 + H*KH2PO4*KH3PO4 + KH2PO4*KH3PO4*KHPO4)^2",
        )
    elseif Tsum == "TH2S"
        return EquilibriumInvariant(
            "TH2S",
            ["H2S", "HS"],
            ["H * TH2S / (H + KH2S)", "KH2S * TH2S / (H + KH2S)"],
            ["0", "1"],
            "KH2S / (H + KH2S)",
            "-KH2S * TH2S / (H + KH2S)^2",
        )
    elseif Tsum == "THSO4"
        return EquilibriumInvariant(
            "THSO4",
            ["HSO4", "SO4"],
            ["H * THSO4 / (H + KHSO4)", "KHSO4 * THSO4 / (H + KHSO4)"],
            ["-1", "0"],
            "-H/(H + KHSO4)",
            "-KHSO4 * THSO4 / (H + KHSO4)^2",
        )
    elseif Tsum == "TH3BO3"
        return EquilibriumInvariant(
            "TH3BO3",
            ["H3BO3", "H4BO4"],
            ["H * TH3BO3 / (H + KH3BO3)", "KH3BO3 * TH3BO3 / (H + KH3BO3)"],
            ["0", "1"],
            "KH3BO3 / (H + KH3BO3)",
            "-KH3BO3 * TH3BO3 / (H + KH3BO3)^2",
        )
    elseif Tsum == "THF"
        return EquilibriumInvariant(
            "THF",
            ["HF", "F"],
            ["H * THF / (H + KHF)", "KHF * THF / (H + KHF)"],
            ["-1", "0"],
            "-H/(H + KHF)",
            "-KHF * THF / (H + KHF)^2",
        )
    elseif Tsum == "TH4SiO4"
        return EquilibriumInvariant(
            "TH4SiO4",
            ["H4SiO4", "H3SiO4"],
            ["H * TH4SiO4 / (H + KH4SiO4)", "KH4SiO4 * TH4SiO4 / (H + KH4SiO4)"],
            ["0", "1"],
            "KH4SiO4 / (H + KH4SiO4)",
            "-KH4SiO4 * TH4SiO4 / (H + KH4SiO4)^2",
        )
    elseif Tsum == "H"
        return EquilibriumInvariant(
            "H",
            ["H", "OH"],
            ["H", "KH2O / H"],
            ["-1", "1"],
            "",
            "-(H^2 + KH2O) / H^2",
        )
    end

end
