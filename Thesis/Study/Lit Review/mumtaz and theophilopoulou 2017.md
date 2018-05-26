# The impact of monetary policy on inequality in the UK. An epirical analysis

MUMTAZ, Haroon; THEOPHILOPOULOU, Angeliki. The impact of monetary policy on inequality in the UK. An empirical analysis. European Economic Review, v. 98, p. 410-423, 2017.

# Dúvidas

1. Eles usaram o índice da taxa de câmbio nominal efetiva. Qual a diferença prática? Tem alguma justificativa para isso?
2. Nas funções impulso resposta cada linha de gráficos corresponde a um dos 4 modelos diferentes 

# Abstract

Using microdata from surveys in UK for the period between 1969 to 2012, they estimated a VAR model to investigate the effect of monetary shocks in inequality.
They constructed 4 Gini indexes: (1) disposable income, (2) total consumption, (3) consumption of non durables and (4) gross personal wage.
As results, they found that contractionary monetary policy shocks lead to an increase in earnings (wage), income and consumption inequality, as well contribute to their volatility.
Income and consumptionhave different responses accordingly to the quantile and the negative effect of the monetary policy is higher in low income households and those with lower consume (in comparison with the ones in the higher quantiles of the income and consumption distributions).
They investigated also the effect of the quantitative easing policy and found that it may have increased inequality during the great recession (2008+).

## Methodology

They used a structural bayesian VAR with fixed coefficients to estimate the effect of monetary policy on earnings, income and consumption. Besides estimating the model for the whole sample, they divided their data accordingly to quantiles, in order to verify if the effect was different depending on how rich or poor the households are.
To analyze the effect of quantitative easing, they used a TVP-VAR.

# Introduction

Empirical evidence shows a rising in inequality levels in the western economies since the 2008 financial crisis. There was an increase in the Gini calculated for UK's households (using disposable income) that went from 0.26 (in 1967) to 0.36 (2007). An increasing pattenr was also observed when considering net labor earnings (0.32 in 1968 to 0.35 in 2008).
Among the factors that could explain the rising trend in inequality are skill based education and technological advances, changes in the families structures, labor market characteristics and reforms, and international trade. Although significant, these factors explain only half of the increase in the inequality in UK in the last 40 years.

Like other authors, Mumtaz and Theophilopoulou highlight the fact that fiscal policy has been linked to inequality extensively in the literature, whilst the link between monetary policy and inequality have been less exploited. Even among the few studies in the area, the conclusions are not unanimous:
* Galbraith (1998) [[article](https://njfac.org/index.php/with-economic-inequality-for-all/)] - strict inflation target was responsible for causing recessions and decrease in the empoyment rates which prompted to increase in inequality;
* Coibion et al (2012) [[working paper](http://www.nber.org/papers/w18170)] - the policy of diminishing interest rates increased the asset prices (which benefited the shareholders). At the same time, when the interest rates are lower, there are an increase in inflation rates, which penalize the individuals with more liquid assets (in general, the ones with lower income and wealth).
* Auclert (2017) [[working paper](http://www.nber.org/papers/w23451)] - Impact of monetary policy on inequality goes through 5 redistribution channels and will depend on the assets portfolio composition and maturity. When the monetary authority makes a monetary expansion, families whose liabilities have more duration than their assets will benefit (because they can negotiate new credit at lower rates). 
* Dopke and Schneider (2006) [[article](https://onlinelibrary.wiley.com/doi/full/10.1162/jeea.2006.4.2-3.493)] - Found a similar effect, in which expansionary policy favors borrowers.

They go deeper in this discussion about conflicting results in literature, but exploits the differences when taking in consideration the source of income. The effects of monetary policy will affect wages differently from assets.

# Data

They constructed four inequality variables using microdata: (1) disposable income, (2) total consumption, (3) consumption of non durables and (4) gross wage.
First three are household level and the fourth is at individual level.
Data ranges from 1969 to 2012.

Besides inequality, they used macro data:
1. GPD per capita in real terms;
2. Inflation (seasonally adjusted harmonised index of consumer prices spliced with the retail price index excluding mortgage payments);
3. 3 month treasury bill rate
4. Norminal effective exchange rate (?)

# Empirical model

The model used is a structural VAR and is given by

<a href="https://www.codecogs.com/eqnedit.php?latex=Z_t&space;=&space;c&space;&plus;&space;\sum_{j=1}^{p}&space;B_j&space;Z_{t-j}&space;&plus;&space;\nu_t,&space;\qquad&space;\nu_t&space;\sim&space;\mathcaL{N}(0,&space;\Omega)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?Z_t&space;=&space;c&space;&plus;&space;\sum_{j=1}^{p}&space;B_j&space;Z_{t-j}&space;&plus;&space;\nu_t,&space;\qquad&space;\nu_t&space;\sim&space;\mathcaL{N}(0,&space;\Omega)" title="Z_t = c + \sum_{j=1}^{p} B_j Z_{t-j} + \nu_t, \qquad \nu_t \sim \mathcaL{N}(0, \Omega)" /></a>

The variables, except for the interest rate and the inequality measure enter in log differences (variation rate). They used a VAR(4) model (ouch).

## Identification of the shock

They used sign restrictions to identify the monetary policy shock. The assuptions are that a contractionary monetary policy shock lead to a contemporaneous increase in the interest rate and the nominal exchange rate, as well as a fall in GDP growth and inflation. The response of the inequality measures is left unaffected.


