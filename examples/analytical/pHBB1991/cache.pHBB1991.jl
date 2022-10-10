module Cache
using PreallocationTools, ForwardDiff
mutable struct Reactran{T}
    OH::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    HCO3::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    CO3::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    CO2::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H2S::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    HS::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H3BO3::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H4BO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    OH_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    HCO3_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    CO3_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    CO2_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H2S_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    HS_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H3BO3_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    H4BO4_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TA_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    dTA_dH::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    dTA_dTCO2::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    dTA_dTH2S::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    dTA_dTH3BO3::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    ROS::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_O2::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_TH2S::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_TA::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_H::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
end

function init(u0::Array{T,1}, Ngrid::Int, chunk_size::Int) where {T}
    OH = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    HCO3 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    CO3 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    CO2 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H2S = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    HS = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H3BO3 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H4BO4 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    OH_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    HCO3_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    CO3_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    CO2_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H2S_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    HS_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H3BO3_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    H4BO4_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    TA_tran = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    dTA_dH = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    dTA_dTCO2 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    dTA_dTH2S = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    dTA_dTH3BO3 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    ROS = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_O2 = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_TH2S = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_TA = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)
    S_H = PreallocationTools.dualcache(zeros(T, Ngrid), chunk_size)

    cache = Reactran(
        OH,
        HCO3,
        CO3,
        CO2,
        H2S,
        HS,
        H3BO3,
        H4BO4,
        H_tran,
        OH_tran,
        HCO3_tran,
        CO3_tran,
        CO2_tran,
        H2S_tran,
        HS_tran,
        H3BO3_tran,
        H4BO4_tran,
        TA_tran,
        dTA_dH,
        dTA_dTCO2,
        dTA_dTH2S,
        dTA_dTH3BO3,
        ROS,
        S_O2,
        S_TH2S,
        S_TA,
        S_H,
    )
    return cache
end
end
