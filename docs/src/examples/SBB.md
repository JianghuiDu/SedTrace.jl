# SBB

Santa Barbara Basin (SBB) is one of the California borderland basins. Its seasonally anoxic condition leads to organic rich and laminated sediments (Reimers et al., 1996). SBB is among the most studied location for sediment diagenesis, and has perhaps one of the most complete pore water dataset to offer in literature (Reimers et al., 1996). High equality pH measurements by in situ profiling micro-electrode, and the availability of various TEI data makes it ideal for benchmarking digenetic models (Meysman et al., 2003). Using SedTrace, we generate a diagenetic model for SBB that includes sediment biogeochemistry, pH and Mo cycling. This example is included in the /examples/SBB folder.


The biogeochemical reaction network includes the classic redox sequence of aerobic respiration, denitrification, Mn and Fe reduction, sulfate reduction and methanogenesis. We use the continuous model of POC reactivity (Boudreau et al., 2008), where the reaction rate depends on sediment age. The model also includes secondary redox reactions, and the authigenesis of carbonates, sulfide, opal and carbonate fluroapatite (CFA). The adsorption of $NH4{+}$, $Fe^{2+}$ and $Mn^{2+}$ are treated using the linear isothermal. To model pH, we include the following equilibrium invariants: $TCO_2$,  $TH_2S$, $THSO_4$, $TH_3BO_3$, $TH_3PO_4$ and $THF$.
    
Molybdenum is sensitive to sedimentary redox condition, and its stable isotope composition, expressed as
δ^98 Mo=(((_^98)Mo/〖(_^95)Mo〗_sample)/((_^98)Mo/〖(_^95)Mo〗_standard )-1)×〖10〗^3  +0.25, where NIST SRM-3134 is the commonly used standard and its δ98Mo is 0.25 ‰ by convention, is an important proxy to study past ocean deoxygenation (Kendall et al., 2017). SBB provides a useful analogy for anoxic ocean and modelling the sedimentary Mo cycle here may help understand how the δ98Mo works as a redox proxy. Here we show a test model of Mo diagenesis in SBB to demonstrate the capability of SedTrace for modelling stable isotope fractionation, complementing the radiogenic isotope example above.


In this model, we consider 5 dissolved Mo species, MoO42- and 4 thiomolybdate species (Erickson and Helz, 2000):
 MoO_4^(2-)+〖iH〗_2 S=MoO_(4-i) S_i^(2-)+〖iH〗_2 O (i=1 to 4),K_i=([MoO_(4-i) S_i^(2-)])/([MoO_4^(2-) ][H_2 〖S]〗^i ),				(54)
K_i are the apparent equilibrium constants. We assume the only the tetrathiomolybdate species can be removed by scavenging, due to high affinity with particulate surface:
RMo_removal=k_rm [MoS_4^(2-)] .										(55)

We include 98Mo (Moh) and 95Mo (Mol) as two tracers. We assume that equilibrium isotope fractionation is induced during thiolation:
〖α_i^(98/95)=(_^98)MoO_4^(2-) /(_^95)MoO_4^(2-)  /(_^98)MoO_(4-i) S_i^(2-) /(_^95)MoO_(4-i) S_i^(2-)  =K〗_i^98/K_i^95,								(56) 
α_i^(98/95) are the fractionation factor, which are 1.0014, 1.0028, 1.00455 and 1.0063 for i = 1 to 4 respectively estimated by ab initio calculation (Tossell, 2005) and recalculated by Kendall et al., (2017). In SedTrace, we add Eq. (54) to the speciation sheet, choosing MoO42- as the base species. Presently SedTrace does not provide special treatment of isotope fractionation, the user needs to incorporate the fractionation factor in the parameters (e.g., K_i) before supplying it to SedTrace. We use the constants from Erickson and Helz (2000) as K_i^95 and then multiply them by α_i^(98/95) to get K_i^98. In this test model we do not consider kinetic isotope fractionation, i.e., using the same k_rm and diffusion coefficient for the two isotopes. We assume the bottom water δ98Mo is the same as the seawater which is globally uniform at 2.34 ‰ (Kendall et al., 2017). The only source of authigenic Mo accumulation is pore water Mo removal supported by diffusion of seawater into sediment. In the model we also supply a lithogenic Mo flux that accounts for the reported 2 ppm lithogenic Mo in sediments (Zheng et al., 2000). The lithogenic δ98Mo is assumed to be the same as the Upper Continental Crust (UCC) ~0.3 ‰ (Kendall et al., 2017).


