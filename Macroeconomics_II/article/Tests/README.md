# Tests

<p align = "left">
    <img src="https://imgs.xkcd.com/comics/automation.png" alt="Programming." width="400" align = "right">
</p>

This folder contains all the Var specifications I have tried.

Because the algorithm is a little slow, I ran each model separately and saved the graphs (and the markdown file is loading the images).
I thinks too many images made my RStudio unstable, so I had to divide in different files, one for each model.

To run the bvar, I used the [`bvarsv`](https://cran.r-project.org/web/packages/bvarsv/index.html) package, 
from [Fabian Kruger](https://sites.google.com/site/fk83research/papers). These two files helped me a lot: [bvarsv: An R implementation of the Primiceri (2005) model for macroeconomic time series](https://github.com/FK83/bvarsv/blob/master/bvarsv_Nov2015_website.pdf) 
and [Replication of figures in Del Negro and Primiceri (2015)](https://github.com/FK83/bvarsv/blob/master/bvarsv_replication.pdf).

All models have monthly measured variables, with some changes in the period and the sample size used to estimate the prior hyperparameters 
(the algorithm uses OLS in the first _n_ observations and then discard then in the bayesian estimation part).

As usual, use this site to visualize html files: https://htmlpreview.github.io

Cartoon credits: [XKCD](https://xkcd.com/1319/)

## Variables

Here are the main description of the variables. I chose them based on [Haroon Mumtaz and Angeliki Theophilopoulou paper (2017)](http://www.sciencedirect.com/science/article/pii/S0014292117301332).
When not said, the series are from Brazil's Central Bank and can be obtained [here](https://www3.bcb.gov.br/sgspub) or using the BETS 
R package with the series code.

1. Capital/Labor Ratio, calculated from the following series:
    * `Receitas tributárias - Regime de competência - Imposto de renda - Retido na fonte - Rendimento do trabalho (7620)`
    * `Receitas tributárias - Regime de competência - Imposto de renda - Retido na fonte - Rendimento do capital (7621)`

I used X-13ARIMA to remove seasonality with no prior transformation.

2. Interest rate (Selic) from the following series:
    * `Taxa de juros - Selic acumulada no mês (4390)`.
I calculated the year rate using this formula: $\left((1+tx/100)^12 -1\right)*100$ and also removed seasonality.

3. Inflation (IPCA) from the following series:
    * `Índice nacional de preços ao consumidor-amplo (IPCA) (433)`. 
Since it is in monthly variation, I calculated the acummulated inflation from past 12 months using: 
$$IPCA_i = \left[\left(\prod\limits_{j=i-11}^i \left(\frac{IPCA_j}{100}+1\right) \right) -1\right]*100$$

4. For GDP, I tried two series:
    1. IBC-Br (it is an index for economic activity) using the series:
        * `	Índice de Atividade Econômica do Banco Central (IBC-Br) - com ajuste sazonal (24364)`. 
I calculated the log and then took the first difference.
    2. GDP (PIB mensal) using the series from [IPEA Data](http://www.ipeadata.gov.br/Default.aspx)
        * 	`Produto interno bruto (PIB)`
I used IPEA series because I tried to deflate the GDP without success. :(

5. Growth of the nominal effective exchange rate (Ex. rate). Used the series:
    * `Taxa de câmbio - Livre - Dólar americano (venda) - Fim de período - mensal (3696)`. ]
Like IBC-Br, I calculated the log and took the first difference.

6. Log monthly returns of Ibovespa Index (Ibovespa). Used the series from [Yahoo Finance](https://finance.yahoo.com/quote/%5EBVSP/history?period1=820461600&period2=1515981600&interval=1mo&filter=history&frequency=1mo) downloded using `getSymbols()` from `quantmod` package.

## Experiments description

![Var specifications](https://github.com/aishameriane/msc-economics/blob/master/Macroeconomics_II/article/Tests/Testes.png)

1. **Experiment 1** ([Var 1](https://htmlpreview.github.io/?https://github.com/aishameriane/msc-economics/blob/master/Macroeconomics_II/article/Tests/Var1.html)) is a 5 variable model, from **January, 2003** to **October, 2017** (181 obs.) containing the following variables:
    * _Capital/Labor Ratio_
    * _Selic_
    * _IBC-Br_
    * _Exchange Rate_
    * _IPCA_
    
I used 24 observations to estimate the prior hyperparameters and 1 lag in the VAR series.

2. **Experiment 2** ([Var 2](https://htmlpreview.github.io/?https://github.com/aishameriane/msc-economics/blob/master/Macroeconomics_II/article/Tests/Var2.html)) is a 5 variable model, from **January, 1996** to **November, 2017** (263 obs.) containing the following variables:
    * _Capital/Labor Ratio_
    * _Selic_
    * _PIB_
    * _Exchange Rate_
    * _IPCA_
    
I used 48 observations to estimate the prior hyperparameters and 1 lag in the VAR series.
    
3. **Experiment 3** ([Var 3](https://htmlpreview.github.io/?https://github.com/aishameriane/msc-economics/blob/master/Macroeconomics_II/article/Tests/Var3.html)) is a 4 variable model, from **January, 1996** to **November, 2017** (263 obs.) containing the following variables:
    * _Capital/Labor Ratio_
    * _Selic_
    * _PIB_
    * _IPCA_
    
I used 48 observations to estimate the prior hyperparameters and 1 lag in the VAR series.

4. **Experiment 4** ([Var 4](https://htmlpreview.github.io/?https://github.com/aishameriane/msc-economics/blob/master/Macroeconomics_II/article/Tests/Var4.html)) is a 4 variable model, from **January, 1996** to **November, 2017** (263 obs.) containing the following variables:
    * _Capital/Labor Ratio_
    * _Selic_
    * _PIB_
    * _IPCA_
    
I used 48 observations to estimate the prior hyperparameters, 2 lag in the VAR series and 1 period forecasting.

5. **Experiment 5** ([Var 5](https://htmlpreview.github.io/?https://github.com/aishameriane/msc-economics/blob/master/Macroeconomics_II/article/Tests/Var5.html)) is a 5 variable model, from **January, 1999** to **November, 2017** (227 obs.) containing the following variables:
    * _Capital/Labor Ratio_
    * _Selic_
    * _PIB_
    * _Exchange Rate_
    * _IPCA_
    
I used 48 observations to estimate the prior hyperparameters and 2 lag in the VAR series.

6. **Experiment 6** ([Var 6](https://htmlpreview.github.io/?https://github.com/aishameriane/msc-economics/blob/master/Macroeconomics_II/article/Tests/Var6.html)) is a 6 variable model, from **January, 1996** to **November, 2017** (263 obs.) containing the following variables:
    * _Capital/Labor Ratio_
    * _Selic_
    * _PIB_
    * _Exchange Rate_
    * _IPCA_
    * _Ibovespa_
    
I used 48 observations to estimate the prior hyperparameters and 1 lag in the VAR series.
    
## Specifications of the `bvar.sv.tvp()` function:

* <a href="https://www.codecogs.com/eqnedit.php?latex=p" target="_blank"><img src="https://latex.codecogs.com/gif.latex?p" title="p" /></a> is the lag of the variables in the var model;
* <a href="https://www.codecogs.com/eqnedit.php?latex=\tau" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\tau" title="\tau" /></a> is the number of observations used to obtain the hyperparameters using OLS. Default is 40;
* <a href="https://www.codecogs.com/eqnedit.php?latex=nf" target="_blank"><img src="https://latex.codecogs.com/gif.latex?nf" title="nf" /></a> is the number of periods used to prediction;
* <a href="https://www.codecogs.com/eqnedit.php?latex=pdrift" target="_blank"><img src="https://latex.codecogs.com/gif.latex?pdrift" title="pdrift" /></a> is a parameter for drift. Default is `TRUE`;
* Prior distributions are the same used in [Primiceri (2005)](http://faculty.wcas.northwestern.edu/~gep575/tvsvar_final_july_04.pdf):
    * <a href="https://www.codecogs.com/eqnedit.php?latex=B_0" target="_blank"><img src="https://latex.codecogs.com/gif.latex?B_0" title="B_0" /></a> are the initial betas and follow a normal distribution with parameters obtained via OLS regressions;
    * <a href="https://www.codecogs.com/eqnedit.php?latex=A_0" target="_blank"><img src="https://latex.codecogs.com/gif.latex?A_0" title="A_0" /></a> is the initial covariance, also following a normal distribution (**I need to check this because covariances cannot be negative**. The variances of <a href="https://www.codecogs.com/eqnedit.php?latex=A_0" target="_blank"><img src="https://latex.codecogs.com/gif.latex?A_0" title="A_0" /></a> and <a href="https://www.codecogs.com/eqnedit.php?latex=B_0" target="_blank"><img src="https://latex.codecogs.com/gif.latex?B_0" title="B_0" /></a> are multiplied by 4;
    * <a href="https://www.codecogs.com/eqnedit.php?latex=log&space;\&space;\sigma_0" target="_blank"><img src="https://latex.codecogs.com/gif.latex?log&space;\&space;\sigma_0" title="log \ \sigma_0" /></a> is the initial log volatility, also following a normal distribution with unitary variance and mean obtained via OLS;
    * <a href="https://www.codecogs.com/eqnedit.php?latex=Q&space;\text{&space;is&space;}&space;B_t" target="_blank"><img src="https://latex.codecogs.com/gif.latex?Q&space;\text{&space;is&space;}&space;B_t" title="Q \text{ is } B_t" /></a> covariance matrix following an Inverse Wishart distribution and some weird parameters (https://github.com/FK83/bvarsv/blob/master/bvarsv_Nov2015_website.pdf - see page 2)
    * <a href="https://www.codecogs.com/eqnedit.php?latex=W" target="_blank"><img src="https://latex.codecogs.com/gif.latex?W" title="W" /></a> is the covariance matrix of the shocks in  <a href="https://www.codecogs.com/eqnedit.php?latex=log&space;\&space;\sigma_0" target="_blank"><img src="https://latex.codecogs.com/gif.latex?log&space;\&space;\sigma_0" title="log \ \sigma_0" /></a>
    * <a href="https://www.codecogs.com/eqnedit.php?latex=S_j" target="_blank"><img src="https://latex.codecogs.com/gif.latex?S_j" title="S_j" /></a> is the covariance matrix of <a href="https://www.codecogs.com/eqnedit.php?latex=A_t" target="_blank"><img src="https://latex.codecogs.com/gif.latex?A_t" title="A_t" /></a>
