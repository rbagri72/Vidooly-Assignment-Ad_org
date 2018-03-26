library(neuralnet)
library(mice)
data1<-read.csv("ad_org_train.csv")
data2<-data.frame(matrix(NA, nrow = 14999, ncol = 1))

for(i in 1:5)
{
  data2<-cbind(data2,as.numeric(as.character(data1[,i])))
}
time<-read.csv("output.csv")
data2<-cbind(data2,time,pub_date)
colnames(data2)=c("x","adviews","views","likes","dislikes","comment","duration","pub_time")
data2=data2[,-1]
data2 <- mice(data2,m=5,maxit=20,meth='pmm',seed=500)
data2=complete(data2,2)
data2<-data2[complete.cases(data2),]

#Normalizing
maxs <- apply(data2, 2, max) 
mins <- apply(data2, 2, min)

scaled <- as.data.frame(scale(data2,center = FALSE, scale = maxs-mins))
NN = neuralnet(adviews ~ views + likes + dislikes + comment + duration + pub_time, scaled, hidden = 6 , linear.output = T )
predict_testNN = compute(NN, scaled[2:7])

predict_testNN = (predict_testNN$net.result * (max(data2$adviews) - min(data2$adviews))) 



RMSE.NN = (sum((scaled$adviews - predict_testNN)^2) / nrow(scaled)) ^ 0.5
model1<-lm(adviews ~ views + likes + dislikes + comment + duration + pub_time,scaled)
pred1<-predict(model1,scaled)
pred1<-pred1*(max(data2$adviews) - min(data2$adviews))
RMSE.LR=(sum((scaled$adviews - pred1)^2) / nrow(scaled)) ^ 0.5


#Test data evaluation
testdata<-read.csv("ad_org_test.csv")
test_frame<-data.frame(matrix(NA, nrow = 8764, ncol = 1))
for(i in 2:5)
{
  test_frame<-cbind(test_frame,as.numeric(as.character(testdata[,i])))
}
time_test<-read.csv("output_test.csv")
test_frame<-cbind(test_frame,time_test,pub_date_test)
colnames(test_frame)=c("x","views","likes","dislikes","comment","duration","pub_time")
test_frame=test_frame[,-1]
test_frame <- mice(test_frame,m=5,maxit=20,meth='pmm',seed=500)
test_frame<-complete(test_frame,2)
#Normalizing 
maxs_test <- apply(test_frame, 2, max) 
mins_test <- apply(test_frame, 2, min)
scaled_test <- as.data.frame(scale(test_frame,center = FALSE, scale = maxs_test-mins_test))
predict_testNN1 = compute(NN, scaled_test)
predict_testNN1 = (predict_testNN1$net.result * (max(data2$adviews) - min(data2$adviews)))
pred2<-predict(model1,scaled_test)
pred2<-pred2*(max(data2$adviews) - min(data2$adviews))
pred2<-as.data.frame(pred2)
pred2<-cbind(as.character(testdata[,1]),pred2)
colnames(pred2)<-c("vid_id","ad_view")
for(i in 1:nrow(pred2))
{
  if(pred2[i,2]<0)
  {
    pred2[i,2]=runif(1,0,1000)
  }
}
