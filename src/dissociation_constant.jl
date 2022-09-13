using Interpolations
using JLD2
using Distributed
using SharedArrays
addprocs(8)

@everywhere using RCall
@everywhere begin

    function disConst(salinity,temperature,pressure)
        R"""
        # library(AquaEnv)
        library(seacarb)
        diss_const <- function(salinity,temp,pres){
        #   KW <- K_W(S=salinity,t=temp,p=pres)
        #   KH3BO3 <- K_BOH3(S=salinity,t=temp,p=pres)
        #   KCO2 <- K_CO2(S=salinity,t=temp,p=pres)
        #   KHCO3 <- K_HCO3(S=salinity,t=temp,p=pres)
        #   KHF <- K_HF(S=salinity,t=temp,p=pres)
        #   KHSO4 <- K_HSO4(S=salinity,t=temp,p=pres)
        #   KH2S <- K_H2PO4(S=salinity,t=temp,p=pres)
        #   KH3PO4 <- K_H3PO4(S=salinity,t=temp,p=pres)
        #   KH2PO4 <- K_H2PO4(S=salinity,t=temp,p=pres)
        #   KHPO4 <- K_HPO4(S=salinity,t=temp,p=pres)
        #   KNH4 <- K_NH4(S=salinity,t=temp,p=pres)
        #   KH4SiO4 <- K_SiOH4(S=salinity,t=temp,p=pres)
        #   KCaCO3 <- Ksp_calcite(S=salinity,t=temp,p=pres)

          KH2O <- Kw(S=salinity,T=temp,P=pres, pHscale="F", warn="y")
          KH3BO3 <- Kb(S=salinity,T=temp,P=pres, pHscale="F", warn="y")
          KCO2 <- K1(S=salinity,T=temp,P=pres, pHscale="F", warn="y")
          KHCO3 <- K2(S=salinity,T=temp,P=pres, pHscale="F", warn="y")
          KHF <- Kf(S=salinity,T=temp,P=pres, pHscale="F", warn="y")
          KHSO4 <- Ks(S=salinity,T=temp,P=pres, warn="n")
          KH2S <- Khs(S=salinity,T=temp,P=pres, pHscale="F", warn="y")
          KH3PO4 <- K1p(S=salinity,T=temp,P=pres, pHscale="F", warn="y")
          KH2PO4 <- K2p(S=salinity,T=temp,P=pres, pHscale="F", warn="y")
          KHPO4 <- K3p(S=salinity,T=temp,P=pres, pHscale="F", warn="y")
          KNH4 <- Kn(S=salinity,T=temp,P=pres, pHscale="F", warn="y")
          KH4SiO4 <- Ksi(S=salinity,T=temp,P=pres, pHscale="F", warn="y")

          return(c(KH2O,KH3BO3,KCO2,KHCO3,KHF,KHSO4,KH2S,
                   KH3PO4,KH2PO4,KHPO4,KNH4,KH4SiO4))
        }
        K_diss <- diss_const(salinity=$salinity,temp=$temperature,pres=$pressure)
        """
        K_diss = @rget K_diss

        return K_diss
    end
end

SAL = 0:0.5:40
TEM = 0:0.5:40
PRE = 0:75:6000

KH2O = SharedArray{Float64}(length(SAL),length(TEM),length(PRE));
KCO2 =SharedArray{Float64}(length(SAL),length(TEM),length(PRE));
KHCO3 =SharedArray{Float64}(length(SAL),length(TEM),length(PRE));
KH2S =SharedArray{Float64}(length(SAL),length(TEM),length(PRE));
KH3BO3 =SharedArray{Float64}(length(SAL),length(TEM),length(PRE));
KHSO4 =SharedArray{Float64}(length(SAL),length(TEM),length(PRE));
KHF =SharedArray{Float64}(length(SAL),length(TEM),length(PRE));
KNH4 =SharedArray{Float64}(length(SAL),length(TEM),length(PRE));
KH3PO4 =SharedArray{Float64}(length(SAL),length(TEM),length(PRE));
KH2PO4 =SharedArray{Float64}(length(SAL),length(TEM),length(PRE));
KHPO4 =SharedArray{Float64}(length(SAL),length(TEM),length(PRE));
KH4SiO4 =SharedArray{Float64}(length(SAL),length(TEM),length(PRE));

@distributed for i in eachindex(SAL)
    for j in eachindex(TEM)
        for k in eachindex(PRE)
            K_diss = disConst(SAL[i],TEM[j],PRE[k])
            KH2O[i,j,k] = K_diss[1]
            KH3BO3[i,j,k] = K_diss[2]
            KCO2[i,j,k] = K_diss[3]
            KHCO3[i,j,k] = K_diss[4]
            KHF[i,j,k] = K_diss[5]
            KHSO4[i,j,k] = K_diss[6]
            KH2S[i,j,k] = K_diss[7]
            KH3PO4[i,j,k] = K_diss[8]
            KH2PO4[i,j,k] = K_diss[9]
            KHPO4[i,j,k] = K_diss[10]
            KNH4[i,j,k] = K_diss[11]
            KH4SiO4[i,j,k] = K_diss[12]
        end
    end
end


K_diss = (KH2O,KH3BO3,KCO2,KHCO3,KHF,KHSO4,KH2S,KH3PO4,KH2PO4,KHPO4,KNH4,KH4SiO4);
jldsave("dissociation_constants.jld2";K_diss)
