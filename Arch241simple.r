Intro {
  x<-9 # write notes
  sqrt(x)
  log(x)
  x<-c(3,-2,4,2,0,6)
  x
  x[3]
  x[1:3]
  mean(x)
  sum(x)
  max(x)
  z<-x>2;z
  v1=seq(1,10, by=0.5) #Variables are case sensitive
  V1='Ciao'
  v1;V1
  sd(v1)
  v2<-v1^2
  v3<-v1[v1>5];v3
  plot(v1,v2, type='p')
  help(plot)
  plot(v1,v2, type='l')
  plot(v1,v2, type='b')
  plot(sin(seq(0,8*pi,length=100)),type='l')
  summary(v1)
  plot(v1,v2, type='l',ylab='V2', xlab='V1',main='Arch 241', sub='First plot')
  cor(v1,v2)
  LinearModel<-lm(v2~v1); summary(LinearModel)
       }

Load file and summary {
load("~/Dropbox/2017-Arch 241/Arch241simple.rda");attach(Arch241simple);
save("Arch241simple", file="~/Dropbox/2017-Arch 241/Arch241simple.rda")


Arch241simple [1:30,]
summary(Arch241simple) #stat summary
summary(Arch241simple$Weight)

names(Arch241simple) #variable names

Arch241simpleMale<-subset(Arch241simple, Gender=="Male");summary(Arch241simpleMale) #subset

Arch241simple$AgeBin<-ifelse(Arch241simple$Age<=40,c("Less then 40"),c("More then 40"))
Arch241simple$AgeBin<-as.factor(Arch241simple$AgeBin)
summary(Arch241simple$AgeBin)

xtabs(~Gender+AgeBin)

}

Histogram, density plot{
  library('ggplot2')
  library('splines')
  library('MASS')
  library('GGally')
  qplot(Weight,data=Arch241simple, geom="histogram")
  qplot(Weight,data=Arch241simple, geom="histogram",binwidth=5)
  qplot(Weight,data=Arch241simple, geom="histogram",binwidth=10)
  qplot(Weight,data=Arch241simple,facets=Gender~., geom="histogram",binwidth=10)

  
  #getting the same but a bit more flexibility
  Arch141Hist<-ggplot(data=Arch241simple, aes(x=Weight))
  Arch141Hist+ geom_histogram(binwidth = 5)
  Arch141Hist+ geom_histogram(binwidth = 5,aes(fill = ..count..))
  Arch141Hist+ geom_histogram(binwidth = 5)+ facet_grid(Gender ~ .)
  Arch141Hist+ geom_histogram(binwidth = 5)+ facet_grid(Gender ~ AgeBin)
  Arch141Hist<-ggplot(data=Arch241simple, aes(x=Weight,fill=Gender))
  Arch141Hist+ geom_histogram(binwidth = 5,alpha=.5, position="identity")
  
  Arch141Hist<-ggplot(data=Arch241simple, aes(x=Weight))
  Arch141Hist+geom_density()
  Arch141Hist+geom_density() + xlim(60, 100)
  Arch141Hist+ geom_histogram(aes(y = ..density..)) + geom_density()
  
}

boxplot {
  qplot(Gender, Weight, data=Arch241simple, geom="boxplot") #qplot (factor, num, ...)
  qplot(Gender, Weight, data=Arch241simple, geom="boxplot") +ylab("Weight [kg]")
  qplot(Gender, Weight, data=Arch241simple, geom="boxplot") + facet_grid(AgeBin~.,)
  qplot(Gender, Weight, data=Arch241simple, geom="boxplot") + facet_grid(AgeBin~.,)+ theme_bw()
  
  #getting the same but a bit more flexibility
  Arch141Box<-ggplot(data=Arch241simple, aes(factor(Gender),Weight))
  Arch141Box+geom_boxplot()
  Arch141Box+geom_boxplot()+ coord_flip()
  Arch141Box+geom_boxplot(aes(fill=Gender))
  Arch141Box+geom_boxplot(aes(fill=factor(AgeBin)))+ theme_bw()
}

scatterplot {
  qplot(Height, Weight, data=Arch241simple)
  qplot(Height, Weight, data=Arch241simple, size=5)
  
  
  Arch141XY<- ggplot(data=Arch241simple, aes(x=Height, Weight))
  Arch141XY+geom_point()
  Arch141XY+geom_point(shape=1)
  Arch141XY+geom_point(shape=3)
  Arch141XY+geom_point(aes(colour = Gender))
  Arch141XY+geom_point(aes(colour = Gender,shape = AgeBin))
  Arch141XY+geom_point(aes(colour = Gender,shape = AgeBin), size=5)
  Arch141XY+geom_point(aes(size=Age))
  Arch141XY+geom_point(size=10)
  Arch141XY+geom_point(size=10,alpha = 1/3)
  
  plotmatrix(with(Arch241simple, data.frame(Age,Weight, Height)))
  plotmatrix(with(Arch241simple, data.frame(Age,Weight, Height)))+ geom_smooth(method="lm")
  plotmatrix(with(Arch241simple, data.frame(Age,Weight, Height)))
  
 
  
  ggpairs(Arch241simple[,2:4])
  ggpairs(Arch241simple, columns = 2:5)
  ggpairs(Arch241simple, columns = c(2,3,4))
  
  ggscatmat(Arch241simple, columns = 3:5, color = "Gender") #ggscatmat is similar to ggpairs but only works for purely numeric multivariate data
  
}

normal distribution {
shapiro.test(Arch241simple$Age) #no normally distribyted p<0.05
shapiro.test(Arch241simple$Weight) #normally distributed p >0.07 W=1 and p>0.05 then it is normally distributed. 
shapiro.test(Arch241simple$Height) #almost normally distributed p=0.14
par(mfrow=c(1,3))
qqnorm(Arch241simple$Age, main='Age');qqnorm(Arch241simple$Weight,main='Weight');qqnorm(Arch241simple$Height,main='Height')
qqline(Arch241simple$Age);qqline(Arch241simple$Weight);qqline(Arch241simple$Height)

}

correlation{
cor(Arch241simple[,c("Height","Weight")], use="complete",method="pearson")
cor(Arch241simple[,c("Age","Height","Weight")], use="complete",method="spearman")
round(cor(Arch241simple[,c("Age","Height","Weight")], use="complete",method="spearman"),1)

#library(ellipse)
#corrTab<-cor(Arch241simple[,c("Age","Height","Weight")], use="complete",method="spearman")
#plotcorr(corrTab)
#colorfun <- colorRamp(c("#CC0000","white","#3366CC"), space="Lab")
#plotcorr(corrTab, col=rgb(colorfun((corrTab+1)/2), maxColorValue=255))

ggcorr(Arch241simple[,c("Age","Height","Weight")])
ggcorr(Arch241simple[,c("Age","Height","Weight")], label = TRUE)

}

hypothesis testing {

  qplot(Gender, Weight, data=Arch241simple, geom="boxplot") +ylab("Weight [kg]")
t.test(Weight~Gender, alternative='two.sided', conf.level=.95, var.equal=FALSE, data=Arch241simple) # the diiference is statistically significant. confidence interval is strong. 
AnovaModel.1 <- aov(Weight ~ Gender, data=Arch241simple); summary(AnovaModel.1) # same results as before
AnovaModel.5 <- aov(Weight ~ Organization.Name, data=Arch241simple); summary(AnovaModel.5) #multi 
t.test(Weight~Organization.Name, alternative='two.sided', conf.level=.95, var.equal=FALSE, data=Arch241simple) # to do to show the error that the t.test can manage only two levels, not many as Organization.Name

}

Example of linear model {
  lmWeightHeight <- lm(Weight ~ Height, data=Arch241simple);summary(lmWeightHeight) # explain estimate, significance, adj R2. p value
  oldpar <- par(oma=c(0,0,0,0), mfrow=c(2,2));plot(lmWeightHeight);par(oldpar);round(coefficients(lmWeightHeight),0) 
  
  LinMod<-ggplot(Arch241simple, aes(y=Weight, x=Height))+geom_point(aes(color=Gender, size=4))+ theme_bw()+xlab("Height [m]")+ylab("Weight [kg]")
  LinMod
  LinMod+geom_smooth() # add loess function
  LinMod+geom_smooth(method=lm)
  
  LinMod2<-ggplot(Arch241simple, aes(y=Weight, x=Height, color=Gender))+geom_point(aes(size=4))+ theme_bw()+xlab("Height [m]")+ylab("Weight [kg]")
  LinMod2
  LinMod2+geom_smooth(method=lm)
  
  LinMod+stat_smooth()
  LinMod+stat_smooth(level=0.90)
  LinMod+stat_smooth(method='lm')
  LinMod+stat_smooth(method='lm', formula=y~ns(x,2)) # polynomial.
  LinMod+stat_smooth(method=rlm, formula=y~ns(x,2)) # rlm roboust linear regression
  
  
  

  # non linear model
  v1=seq(1,10, by=0.5); v2<-v1^2
LinearModel<-lm(v2~v1); summary(LinearModel)
oldpar <- par(oma=c(0,0,0,0), mfrow=c(1,1))
plot(v1,v2, type='p')
abline(lm(v2~v1))
oldpar <- par(oma=c(0,0,0,0), mfrow=c(2,2));plot(LinearModel);par(oldpar);round(coefficients(LinearModel),0) 

# outlier
x1<-c(20,30,40,50,60,80,100,120,140,160,180)
y1<-c(24,28,34,36,39,80,48,51,59,64,72)
plot(x1,y1)
LinearModel<-lm(y1~x1); summary(LinearModel);oldpar <- par(oma=c(0,0,0,0), mfrow=c(2,2));plot(LinearModel);par(oldpar);round(coefficients(LinearModel),0) 

#  removed the outlier (80, 80) 
x1<-c(20,30,40,50,60,100,120,140,160,180)
y1<-c(24,28,34,36,39,48,51,59,64,72)
plot(x1,y1)
  LinearModel<-lm(y1~x1); summary(LinearModel);oldpar <- par(oma=c(0,0,0,0), mfrow=c(2,2));plot(LinearModel);par(oldpar);round(coefficients(LinearModel),0) 
  
  
}

--example of multivariable regression {
LinearModelM <- lm(Weight ~ Height+Gender+Age, data=Arch241simple); summary(LinearModelM)
LinearModelM <- lm(Weight ~ Height+Gender, data=Arch241simple); summary(LinearModelM) # here I lost 0.04 of adj R2. Is this a lot? Depend



}


