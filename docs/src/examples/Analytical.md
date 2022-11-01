# pHBB1991

## `substances` sheet
|include|substance|	type	    |formula|top\_bc\_type|bot\_bc\_type|
|-------|---------|-------------|-------|-------------| ------------|
|1      |O2       |	dissolved   |		|Dirichlet    |	Dirichlet   |
|1      |H        |	dissolved_pH|		|Dirichlet    |	Dirichlet   |
|1      |TCO2     |	dissolved_pH|		|Dirichlet    |	Dirichlet   |
|1      |TH2S     |	dissolved_pH|		|Dirichlet    |	Dirichlet   |
|1      |TH3BO3   |	dissolved_pH|		|Dirichlet    |	Dirichlet   |

## `reactions` sheet
|include|	check|	label|	equation	                       |rate	            |Omega|
|-------|--------|-------|-------------------------------------|--------------------|-----|
|1      |	1    |	ROS	 |  HS{-} + 2\*O2 = H{+} + SO4{2-} |kOS\*exp(-a*(x-x0)^2)|	  |

## `parameters` sheet
|include|class|type|parameter|value|unit|comment|
|:----|:----|:----|:----|:----|:----|:----|
|1|global|const|depth|0|m|water depth|
|1|global|const|salinity|20|psu|bottom water salinity|
|1|global|const|temp|20|Celsius|bottom water temperature|
|1|global|const|ds_rho|2.6|g cm^-3|dry sediment density|
|1|grid|const|L|0.2|cm|model sediment section thickness|
|1|grid|const|Ngrid|200|integer|number of model grid|
|1|grid|const|b|2| |parameter in gridtran|
|1|grid|const|A|1/2b\*log((1+(exp(b)-1)\*0.055/L)/(1+(exp(-b)-1)\*0.055/L))| |parameter in gridtran|
|1|grid|function|gridtran|0.055\*(1+sinh(b\*(x/L-A))/sinh(b\*A))-0.05|cm|grid transformation function|
|1|porosity|function|phi|0.9999|dimensionless|porosity as a function of depth|
|1|porosity|const|phi_Inf|0.9999|dimensionless|porosity at burial depth|
|1|burial|const|Fsed|1.00E-06|g cm^-2 yr^-1|total sediment flux|
|1|bioturbation|function|Dbt|0|cm^2/yr|bioburbation coefficient as a function of depth|
|1|bioirrigation|function|Dbir|0|yr^-1|bioirrigation coefficient as a function of depth|
|1|BoundaryCondition|const|O20|2.50E-04|mmol cm^-3|Concentration of O2 at the TOP of sediment column|
|1|BoundaryCondition|const|O2L|0.00E+00|mmol cm^-3|Concentration of O2 at the BOTTOM of sediment column|
|1|BoundaryCondition|const|pH0|8.15|free pH scale|pH at the TOP of sediment column|
|1|BoundaryCondition|const|pHL|7.39|free pH scale|pH at the BOTTOM of sediment column|
|1|BoundaryCondition|const|TCO20|2.00E-03|mmol cm^-3|Concentration of TCO2 at the TOP of sediment column|
|1|BoundaryCondition|const|TCO2L|2.00E-03|mmol cm^-3|Concentration of TCO2 at the BOTTOM of sediment column|
|1|BoundaryCondition|const|TH2S0|0|mmol cm^-3|Concentration of TH2S at the TOP of sediment column|
|1|BoundaryCondition|const|TH2SL|3.83E-04|mmol cm^-3|Concentration of TH2S at the BOTTOM of sediment column|
|1|BoundaryCondition|const|TH3BO30|4.90E-05|mmol cm^-3|Concentration of TH3BO3 at the TOP of sediment column|
|1|BoundaryCondition|const|TH3BO3L|4.90E-05|mmol cm^-3|Concentration of TH3BO3 at the BOTTOM of sediment column|
|1|Reaction|const|a|1.00E+04|cm| |
|1|Reaction|const|x0|5.00E-03|cm| |
|1|Reaction|const|kOS|1.00E+00|mmol cm^-3 yr^-1| |

Here we discuss the model `pHBB1991`. Boudreau (1991) created a diagenetic model with analytical solution to explain the pH change across the mat of sulfur oxidizing bacteria Beggiatoa in sediments from the Danish lagoons (Jørgensen and Revsbech, 1983). This model is now generated here using SedTrace. It includes one reaction, the oxidation of $HS^-$ by $O_2$. The kinetic rate is $k_{OS}e^{-a(x-x_0 )^2}$⁡, where $k_{OS}$ is the rate constant, $x$ is depth. The reaction is assumed to happen close to the mat at $x_0=0.005$ cm where dissolved $O_2$ disappears and $H_2S$ starts to increase, and a controls the sharpness of this interface. The model substances are dissolved $O_2$, $H^+$ and the EIs $TCO_2$, $TH_2S$ and $TH_3BO_3$. Their Dirichlet boundary conditions are specified at the top (-0.05 cm) and bottom (0.15 cm) of the model domain. Porosity is assumed to be constant and equal to 1 and thus no distinction is made between seawater above the SWI and the pore water below. The only transport mechanism is molecular diffusion. 
	

The gridtran for the non-uniform grid is constructed using hyperbolic functions:

$$gridtran(x)=(x_0+0.05)(1+\dfrac{\sinh⁡(b(x/L-A))}{\sinh⁡(bA)})-0.05, \\ A=\dfrac{1}{2b}  \ln\dfrac{⁡1+(e^b-1)(x_0+0.05)/L}{1+(e^{-b}-1)(x_0+0.05)/L}$$

where $L = 0.2$ cm is the length of the model domain and 0.05 cm is the depth offset. The resulting grid points are concentrated near $x_0 = 0.005$ cm, the degree of which is controlled by $b$. 

