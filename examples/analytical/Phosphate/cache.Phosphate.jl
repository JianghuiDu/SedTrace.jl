module Cache
using PreallocationTools, ForwardDiff
struct Reactran{T}
    P_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TH3PO4_ads_nsf::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TH3PO4_ads::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TH3PO4_dis::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TH3PO4_dis_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    TH3PO4_ads_tran::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Rremin::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    Rpre::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_Porg::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
    S_TH3PO4::PreallocationTools.DiffCache{Array{T,1},Array{T,1}}
end

function init(u0::Array{T,1}, Ngrid::Int) where {T}
    P_ads = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TH3PO4_ads_nsf = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TH3PO4_ads = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TH3PO4_dis = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TH3PO4_dis_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    TH3PO4_ads_tran = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Rremin = PreallocationTools.DiffCache(zeros(T, Ngrid))
    Rpre = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_Porg = PreallocationTools.DiffCache(zeros(T, Ngrid))
    S_TH3PO4 = PreallocationTools.DiffCache(zeros(T, Ngrid))

    cache = Reactran(
        P_ads,
        TH3PO4_ads_nsf,
        TH3PO4_ads,
        TH3PO4_dis,
        TH3PO4_dis_tran,
        TH3PO4_ads_tran,
        Rremin,
        Rpre,
        S_Porg,
        S_TH3PO4,
    )
    return cache
end
end
