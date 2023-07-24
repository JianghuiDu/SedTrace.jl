module Cache
using PreallocationTools, ForwardDiff
struct Reactran{T}
    TFe_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Fe_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Fe_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TFe_ads_POC::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TFe_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TFe_dis_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TFe_ads_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    OH::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    HCO3::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    CO3::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    CO2::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H2S::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    HS::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    OH_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    HCO3_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    CO3_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    CO2_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H2S_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    HS_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TA_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    dTA_dH::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    dTA_dTCO2::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    dTA_dTH2S::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Omega_RFeS_pre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RFeOOHPOC::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RSO4POC::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RFeOOHH2S::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RFeS_pre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_POC::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_FeOOH::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_TCO2::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_TFe::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_SO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_TH2S::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_FeS::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_TA::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_H::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
end

function init(u0::Array{T,1}, Ngrid::Int) where {T}
    TFe_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Fe_aq = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Fe_ads = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TFe_ads_POC = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TFe_ads = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TFe_dis_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TFe_ads_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    OH = PreallocationTools.DiffCache(zeros(T, Ngrid))
    HCO3 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    CO3 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    CO2 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H2S = PreallocationTools.DiffCache(zeros(T, Ngrid))
    HS = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    OH_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    HCO3_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    CO3_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    CO2_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    H2S_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    HS_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TA_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    dTA_dH = PreallocationTools.DiffCache(zeros(T, Ngrid))
    dTA_dTCO2 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    dTA_dTH2S = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Omega_RFeS_pre = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RFeOOHPOC = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RSO4POC = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RFeOOHH2S = PreallocationTools.DiffCache(zeros(T, Ngrid))
    RFeS_pre = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_POC = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_FeOOH = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_TCO2 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_TFe = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_SO4 = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_TH2S = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_FeS = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_TA = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_H = PreallocationTools.DiffCache(zeros(T, Ngrid))

    cache = Reactran(
        TFe_dis,
        Fe_aq,
        Fe_ads,
        TFe_ads_POC,
        TFe_ads,
        TFe_dis_tran,
        TFe_ads_tran,
        OH,
        HCO3,
        CO3,
        CO2,
        H2S,
        HS,
        H_tran,
        OH_tran,
        HCO3_tran,
        CO3_tran,
        CO2_tran,
        H2S_tran,
        HS_tran,
        TA_tran,
        dTA_dH,
        dTA_dTCO2,
        dTA_dTH2S,
        Omega_RFeS_pre,
        RFeOOHPOC,
        RSO4POC,
        RFeOOHH2S,
        RFeS_pre,
        S_POC,
        S_FeOOH,
        S_TCO2,
        S_TFe,
        S_SO4,
        S_TH2S,
        S_FeS,
        S_TA,
        S_H,
    )
    return cache
end
end
