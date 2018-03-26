library(stringr)
library(lubridate)
df<-read.csv("ad_org_train.csv")
x=as.Date(df[,6], format = "%d-%m-%Y")
c<-"21-02-2018"
c<-dmy(c)
pub_date<-interval(x,c)/ddays(1)
#for test data
df_test<-read.csv("ad_org_test.csv")
y=as.Date(df_test[,6])
pub_date_test<-interval(y,c)/ddays(1)