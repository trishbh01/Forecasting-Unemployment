# Project Description
- Consider the U. S. monthly unemployment rate from January 1951 to February 2004 from unemployment.xlsx. The first column is the unemployment rate, the
second is help wanted ads (forget about this variable), the third is the year, and the last is the month. The data, provided by the St. Louis Fed, are seasonally adjusted. I build a time series model and use it to forecast unemployment in April 2004.
# Mechanism
- I first conduct stationarity tests on the series using an augmented Dickey-Fueller test. I conduct the test on a pure random walk model, a random walk model with drift and a random
walk model with drift plus trend although the data seems not to have a trend. I select 36 lags to begin with, as even though the data are seasonally adjusted we want to account for
possible seasonal autocorrelation. I find that the 36th lag is highly significant in all 3 models, and so are the 24th and the 12th lags, which confirms the presence of seasonal autocorrelation. Therefore the test is conducted
using 36 lags. For all 3 specifications, the test is not able to reject the null hypothesis. To further prove that the series is non-stationary, we conduct kpss, DF-GLS and PP test to confirm
our results. For kpss, I reject the null hypothesis and find the series has no trend stationarity. Similar results follow for PP test where we fail to reject the null and thus conclude that the
series is non stationary.
- I then plot the residuals of the test and find that the residuals behave like a white noise process. According to the test, I cannot reject the null hypothesis of a unit-root and on top of that I find no trend stationarity, and therefore the data should be differenced to make the series
stationary. I repeat the tests on the differenced series and conclude that the series is integrated of order 1. I try out different combinations of ARIMA where in the ACF functions of the residuals suggest the presence of a seasonal component, even though the data has been seasonally adjusted
already. This is consistent with the specification of the Dickey-Fuller test.
- By experimenting with different Sarima models, I can keep adding terms that are significant until I settle on a Sarima (4,1,2)(1,0,1)[12]. The model which is suggested by the R function
auto.arima, which automatically fits the best model, is instead a Sarima (4,1,2)(2,0,1)[12]. However, the second AR seasonal term for this model is not significant.
- I check the residuals for this model, they appear to behave as white noise. I am not able to reject the null hypothesis at 5% level when we conduct a Ljung Box with 12 and 24 lags.
- I reach similar conclusions for the models SARIMA(2,1,2)(1,0,1)[12] and SARIMA (3,1,2)(1,0,1)[12]. Instead, If I take the model suggested by the auto.arima function (Sarima (4,1,2)(2,0,1)[12]), I am able to reject the null of the Ljung Box test at 12 lags. We choose the models SARIMA
(4,1,2)(1,0,1)[12], SARIMA (3,1,2)(1,0,1)[12] and SARIMA (2,1,2)(1,0,1)[12] for further tests. I conduct DMariano tests between the three models, and find that I fail to reject the null. This means that the three models are not significantly different in terms of RSME. This is confirmed
by the comparison of AIC´s and BIC´s which report similar statistics and are consistent with my previous analysis.
- According to the information criteria, the SARIMA (2,1,2)(1,0,1)[12] model is the least preferable, but there is no clear choice between the other two models. However, the SARIMA
(3,1,2)(1,0,1)[12] is the most parsimonious of the two, and therefore based on these criteria it seems to be the better model among the three. I can test how the two models forecast using both a recursive and a rolling window.
-Both models are quite accurate in their predictions and indeed there is not much difference
between them. I would have chosen SARIMA (3,1,2)(1,0,1)[12] because of the result of
DMariano test but this selection seems unlikely to make a substantial difference. I report the predictions made with these two models for April 2004, and we see that indeed
the estimates are quite close.
