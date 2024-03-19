setwd("/Users/")
some_packages <- c('tidyverse','fpp2', 'forecast', 'tibbletime','tsbox','gridExtra','knitr', 'ggthemes','zoo','haven', 'quantmod', 'lubridate','tseries','TSstudio','readxl','stargazer','urca','broom')
lapply(some_packages, library, character.only=TRUE)
rm(list = ls())
ds<-read_excel("unemployment.xls")
colnames(ds)[1]<-"unemp"
colnames(ds)[3]<-"year"
colnames(ds)[4]<-"month"
ds$date <- as.yearmon(paste(ds$year, ds$month), "%Y %m")
ds$date
ts<-zoo(ds$unemp, order.by = ds$date)
par(mar = c(1, 1, 1, 1))
plot.zoo(ts)
ggAcf(ts, lag.max = 100)
ggPacf(ts, lag.max = 50)

adf.test(ts,k=36)
summary(ur.df(ts, type = c("trend"),lags = 36))
summary(ur.df(ts, type = c("none"),lags=36))
summary(ur.df(ts, type = c("drift"), lags = 36)) 

summary(ur.ers(diff(ts), type = c("DF-GLS"), model = c("trend"),lag.max = 36))
summary(ur.ers(diff(ts), type = c("DF-GLS"), model = c("constant"),lag.max = 36))

test<-ur.df(ts, type = c("drift"), lags = 36)
summary(test)
urca::plot(test)
plot.zoo(ts)

ndiffs(ts)
kpss.test(ts, null="Level")
kpss.test(ts, null="Trend")
pp.test(ts)
ggtsdisplay(ts)
ts %>%
  diff(lag=12) %>%
  ggtsdisplay()

ar1<-Arima(ts, order = c(4,1,3))
summary(ar1)
checkresiduals(ar1)
ts %>%
  Arima(order = c(4,1,2)) %>%
  residuals() %>%
  ggAcf(lag.max = 42) + theme_test() 

ar<-Arima(ts, order = c(2,1,2))
summary(ar)
checkresiduals(ar)
arplus<-Arima(ts, order = c(4,1,2), seasonal = c(1,0,1))
summary(arplus)
checkresiduals(arplus)
checkresiduals(arplus, 12)
ggAcf(arplus$residuals, lag.max = 100) + theme_test() + labs(title = "ACF for the residuals of a 
Sarima (4,1,2)(1,0,1)[12]")
ar2<-Arima(ts, order = c(2,1,2), seasonal = c(1,0,1))
summary(ar2)
checkresiduals(ar2)
checkresiduals(ar2, 12)
ar3<-Arima(ts, order = c(3,1,2), seasonal = c(1,0,1))
summary(ar3)
checkresiduals(ar3)
checkresiduals(ar3, 12)

ar4<-Arima(ts, order = c(3,1,2), seasonal = c(2,0,1))
summary(ar4)
checkresiduals(ar4)
ar5<-Arima(ts, order = c(4,1,2), seasonal = c(2,0,1))
summary(ar5)
checkresiduals(ar5)
checkresiduals(ar5, 12)
stargazer(arima(ts, order = c(4,1,2), seasonal = c(1,0,1)))


autoplot(ar3)

dm.test(ar2$residuals, ar3$residuals)
dm.test(ar2$residuals, arplus$residuals)
dm.test(ar3$residuals, arplus$residuals)
ts
training<-subset(ts, year(time(ts)) < "2004") 
testing<-subset(ts, year(time(ts)) >= "2004") 

ar2<-Arima(training, order = c(2,1,2), seasonal = c(1,0,1))
ar3<-Arima(training, order = c(3,1,2), seasonal = c(1,0,1))
ar5<-Arima(training, order = c(4,1,2), seasonal = c(2,0,1))
fcast1 <- forecast(ar2, h=2)
fcast2 <- forecast(ar3, h=2)
fcast3 <- forecast(ar5, h=2)
autoplot(training) +
  autolayer(fcast1, series = "ARIMA(2,1,2)", alpha = 0.6) +
  autolayer(fcast2, series = "ARIMA(3,1,2)", alpha = 1) +
  autolayer(fcast3, series = "ARIMA(4,1,2)", alpha = 0.3) +
  autolayer(as.ts(testing), series = "Actual", alpha = 1) +
  guides(colour = guide_legend("Model")) + xlim(2003.8,2004.1)
testing
fcast1
fcast2
fcast3
far1 <- function(x, h){forecast(Arima(x, order=c(4,1,2), seasonal= c(1,0,1)), h=h)}
e <- tsCV(ts, far1, h=2)
fc <- c(ts[3:637] - e[1:635])
fc

autoplot(as.ts(ts)) + autolayer(as.ts(fc), alpha=1) + geom_line(aes(col="black"),alpha=0.5) + 
  theme_test() + 
  labs(color="", y="Unemployment Rate", title = "Sarima (4,1,2)(1,0,1) Recursive Window 
Forecast") + 
  scale_color_manual(labels= c("Sarima (4,1,2)(1,0,1)","Data"), values = c("orange","black"))
e2 <- tsCV(ts, far1, h=2, window = 50)
fc2 <- c(ts[3:637] - e2[1:635])

autoplot(as.ts(ts)) + autolayer(as.ts(fc2), alpha=1) + geom_line(aes(col="black"),alpha=0.5) + 
  theme_test() + 
  labs(color="", y="Unemployment Rate", title = "Sarima (4,1,2)(1,0,1) Rolling Window Forecast") + 
  scale_color_manual(labels= c("Sarima (4,1,2)(1,0,1)","Data"), values = c("orange","black"))
autoplot(as.ts(ts)) + autolayer(as.ts(fc2), alpha=0.8)

far2 <- function(x, h){forecast(Arima(x, order=c(3,1,2), seasonal= c(1,0,1)), h=h)}
e3 <- tsCV(ts, far2, h=2)
fc3 <- c(ts[3:637] - e3[1:635])
autoplot(as.ts(ts)) + autolayer(as.ts(fc3), alpha=1) + geom_line(aes(col="black"),alpha=0.5) + 
  theme_test() + 
  labs(color="", y="Unemployment Rate", title = "Sarima (3,1,2)(1,0,1) Recursive Window 
Forecast") + 
  scale_color_manual(labels= c("Sarima (3,1,2)(1,0,1)","Data"), values = c("red","black"))
fc

autoplot(as.ts(ts)) + autolayer(as.ts(fc), alpha=0.8)
e4 <- tsCV(ts, far2, h=2, window = 50)
fc4 <- c(ts[3:637] - e4[1:635])
autoplot(as.ts(ts)) + autolayer(as.ts(fc4), alpha=1) + geom_line(aes(col="black"),alpha=0.5) + 
  theme_test() + 
  labs(color="", y="Unemployment Rate", title = "Sarima (3,1,2)(1,0,1) Rolling Window Forecast") + 
  scale_color_manual(labels= c("Sarima (3,1,2)(1,0,1)","Data"), values = c("red","black"))
ar3<-Arima(ts, order = c(3,1,2), seasonal = c(1,0,1))
fcast2 <- forecast(ar3, h=2)
fcast2
arplus<-Arima(ts, order = c(4,1,2), seasonal = c(1,0,1))
fcastplus <- forecast(arplus, h=2)
fcastplus

summary(Arima(ts, order = c(2,1,2)))
Arima(ts, order = c(2,1,2)) %>%
  checkresiduals()

ts_lag<-diff(ts, lag = 12)
ts_lag
autoplot(ts_lag)
adf.test(ts_lag)
Arima(ts_lag, order = c(2,0,2), seasonal = c(1,0,1)) %>%
  checkresiduals()


