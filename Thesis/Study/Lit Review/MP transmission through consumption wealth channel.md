# Monetary Policy transmission through the consumption wealth channel

Reference: LETTAU, Martin; LUDVIGSON, Sydney; STEINDEL, Charles. **Monetary policy transmission through the consumption-wealth channel**. FRBNY Economic Policy Review, v. 5, p. 117-133, 2002.

# Introduction

**Objective**: they want to quantify the impact that monetary policy has on consumption of nondurable goods and services through the changes in asset values.

**Conclusions**: There is little evidence of the importance of a wealth channel of monetary policy. However, in large scale models, there is an effect of the consumption-wealth channel, whereas this is not observed when using a structural VAR approach.

# Evolution of thought on the wealth effect

Baberler and Pigou: if the economy is undergoing an inflationary or deflationary process, then it is possible that changes in the real value of money can desincentive or incentivize spending, generating an opposing force that would counterbalance the changes in prices through a chance in consumer spending. The work from Modigliani and Patinkin would give the necessary conditions in terms of money, goods and labor markets, for which such countercyclical effect would take place.
Modigliani also worked on showing that the changes in wealth could be induced by the monetary policy decisions (it seems that the literature until then agreeded that the changes would be more passive). If we think on the life cycle theory, it is obvious that the decision regarding spending is not passive and wealth has a major role in determining the consumer spending levels.
In the late sixties, large macroeconometric models were being employed and an empirical analysis of Modigliani suggested that almost 50% os the changes in the real economy due to monetary policy could be tied to the changes in spending that arose as consequence of the impact of the interest rate in equity prices.

# Evidence on the wealth channel from large scale models

In this part they use some of the classical macro models that were used before the Lucas critique. I just skimmed through this part since it is not the main model the authors are using to sustain their arguments.

Def: *Wealth effect on consumption* - "is defined typically as the marginal impact of wealth on consumption, controlling for other fundamentals of spending such as labor income".

# A small structural VAR

They focus on the impulse response analysis of non-anticipated shocks in the federal funds rate. They want to investigate "how innovations in the fed funds rate incluence households wealth, and how those changes in wealth influence consumer spending". _Note for myself:_ In my case I'm not analyzing consumer spending, just the effect on the income from capital and labor.

This section has a very nice discussion regarding they identification scheme (they didn't use the lower triangular approach, instead they opted by other way that also leads to a fully identified system). Another different thing that they did was to make a counterfactual analysis, shutting down the wealth channel. _Note to myself:_ I'm not sure if I would like to do this in my model, maybe shutting down the inflation channel... Anyway, they do the complete analysis, then the counterfactual and the differente between the two scenarios will be the wealth effect on consumption.

# Results

## The overall effect of a Fed Funds rate shock

VAR setup:
* Five variables, four lags
* One standard deviation shock

Response to a monetary shock:
* Labor income and consumption fall immediately after the shock and take ten quarters or so to recover to the older levels;
* Inflation rises before falling, something that the authors say is the "price puzzle" ([link 1](https://files.stlouisfed.org/files/htdocs/publications/net/20061001/cover.pdf), [link 2](https://www.anpec.org.br/encontro/2012/inscricao/files_I/i3-e08ba5ec640793c2baef254dfefede0b.pdf)).
* The price of assets starts to lower its value after on quarter and during the three quarters after the initial shock the effect is significative. The overall effect of monetary policy on wealth is transitory and takes approximately two years and a half to disapear completely.

Wealth shock:
* Interest rates rise after a positive shock in wealth. A possible explanation would be that the wealth shock can have impacts in real variables, which would require a response from FED whenever the differente in wealth was hihg enough.

