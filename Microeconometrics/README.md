# Microeconometrics 2016-1

```diff
- This assigment is wrong (because of the model, please do not use this work for reference. 
- Feel free to use the code to generate the election's data.
``` 

_“I can’t go back to yesterday because I was a different person then.”_ (Alice)

<img src="https://goo.gl/d0dZ1S" width="200" align = "right">

This is the virtual repository to all data and codes used in the final assignment for the Microeconometrics Course - from the Master Degree Course  in Economics at Federal University of Santa Catarina (2016-2).

Description:
The aim of this work is to investigate the effect of the gender quota bill in women elected share for seats in city councils. For such, data from TSE (Tribunal Superior Eleitoral) from the years 2004, 2008, 2012 and 2016 were analyzed. The final model incorporates some census (IBGE, 2010) variables as covariates as well a dummy variable indicating the periods before and after the law.

The archive `Article-Aishameriane.pdf`contains the final draft, for evaluation. You can see by the last commit to check if it attends the  deadline (spoiler: it extrapolated the deadline in one day). The online version (Overleaf) can be seen here: https://www.overleaf.com/read/chxkwsqbzxvc (this is a read-only link because my github and overleaf repos aren't private, but I can provide an edit link).

Note that the article is intended to be published (Feminist Economics or similar journal), so it's more focused in the problematics of the gender quota than in the model, because the approach is not inovative in the econometrics sense (I just used a well-stablished model).

Also, I kept it small because of Guilherme: he said you would like a shorter paper.

How to use the files:

- You can download dados_completos.csv to handle the data already merged and tidy; or
- You can use Preparing_data.R along the other data files to make your own data (although possible, I don't recommend to do it, because my code has a `for` loop (to prepare the electoral data) highly inefficient that takes ages (about 2h) to run.

About the (poor) choices made for the model:

- Since all cities were subjected to the refered law (imposing quotas) simultaneously, it doesn't make sense to use an impact evaluation model (like diff-in-diff, RDD, etc) because I don't have a control group;
- At the same time, all municipalities were observed 4 times (in each one of the elections - 2 before the law and another 2 after the law). This suggests that there will be correlation between the subjects;
- To accomodate the time-dependent data structure, I used a panel model (the most simplistic one). First, I got the estimatives for FE, then compared to RE using Hausman test. All routines were from plm() package (R) (See more: https://cran.r-project.org/web/packages/plm/vignettes/plm.pdf).

To soothen the wrath of the professor for disrespecting the deadline, here goes a cute cat picture as tribute: 

![Kiiro](https://goo.gl/FIf0LW)

To-do list for Aisha from the future:

1. Improve the introduction with more content about gender equality in parliaments;
2. Improve the Brazil's electoral system explanation as well improve the literature review for this part;
3. Add some review of studies that evaluated the gender quota with econometric methods;
4. Explain better the model and verify if there is not another way to estimate the effects;
5. Try to incorporate info from the 2000 census and suppose that this refers to "pre-quota" period. Use 2010 census data only for the 2012 and 2016 observations. Estimate a first difference model;
6. Enhance the model calibration. See if the method of selecting variables is correct;
7. Improve the covariates explanation, trying to relate with other studies to justify them;
8. Look for cities that have only 3 periods (probably new municipalities) and remove them from the data base;
9. Analyze the "phantom candidates": women candidates without votes;
10. Analyze the flutuation in number of votes to female candidates: since the city council offices are based on proportional elections system;
11. Analyze the region's differences (based on http://www.scielo.br/pdf/ref/v14n2/a03v14n2.pdf) [future study, maybe?];
12. Check with Francis the source for Gini Index and HDI to incorporate in the final version;
13. Read carefully Hughes article (The increasing effectiveness of national gender quotas);
14. More importantly, never again start working 3 days before the deadline limit <**sigh**>.
