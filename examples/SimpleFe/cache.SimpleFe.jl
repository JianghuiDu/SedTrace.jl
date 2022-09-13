module Cache
using PreallocationTools, ForwardDiff
mutable struct Reactran{T}
    Fe::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Fe_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Fe_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Fe_ads_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
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
    Fe_free::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    FeCl_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    FeSO4_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    FeCO3_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    FeHS_aq::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Omega_RFeS_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Omega_RFeS_pre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RO2POC::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RFeOOHPOC::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RSO4POC::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RO2Fe::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RO2Fe_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RO2H2S::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RFeOOHH2S::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RFeS_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    RFeS_pre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_POC::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_O2::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_TCO2::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_FeOOH::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_TFe::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_SO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_TH2S::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_FeS::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_TA::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_H::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
end

function init(u0::Array{T,1}, Ngrid::Int, chunk_size::Int) where {T}
    Fe = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Fe_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Fe_ads = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Fe_ads_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    OH = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    HCO3 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    CO3 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    CO2 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H2S = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    HS = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    OH_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    HCO3_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    CO3_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    CO2_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H2S_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    HS_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TA_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    dTA_dH = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    dTA_dTCO2 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    dTA_dTH2S = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Fe_free = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    FeCl_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    FeSO4_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    FeCO3_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    FeHS_aq = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Omega_RFeS_dis = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    Omega_RFeS_pre = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RO2POC = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RFeOOHPOC = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RSO4POC = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RO2Fe = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RO2Fe_ads = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RO2H2S = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RFeOOHH2S = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RFeS_dis = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    RFeS_pre = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_POC = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_O2 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_TCO2 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_FeOOH = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_TFe = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_SO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_TH2S = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_FeS = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_TA = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_H = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)

    cache = Reactran(
        Fe,
        Fe_tran,
        Fe_ads,
        Fe_ads_tran,
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
        Fe_free,
        FeCl_aq,
        FeSO4_aq,
        FeCO3_aq,
        FeHS_aq,
        Omega_RFeS_dis,
        Omega_RFeS_pre,
        RO2POC,
        RFeOOHPOC,
        RSO4POC,
        RO2Fe,
        RO2Fe_ads,
        RO2H2S,
        RFeOOHH2S,
        RFeS_dis,
        RFeS_pre,
        S_POC,
        S_O2,
        S_TCO2,
        S_FeOOH,
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
