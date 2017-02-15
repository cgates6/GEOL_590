``` r
library(ggplot2)
```

This script is able to analyze contact angle over time data from a sessile droplet profile. The dynamic nature of the sessile droplet placed on a porous surface such as a rock prevents an equilibrium contact angle from being determined, due to initial spreading of the droplet and imbibition of the droplet into the porous medium throughout the life of the droplet.

Upon contact, the base of the droplet spreads due to attractive forces on the surface. Eventually the base of the droplet will cease spreading and will come to a relatively constant value. After the droplet has reached this maximum base size, all changes in contact angle are assumed to be due to imbibition of the droplet into the rock. Previous studies attempting to determine the equilibrium contact angle of sessile droplets on porous surfaces have analyzed this spreading nature of the droplet to determine the time at which the droplet has reached its maximum base, and thus surface energies are in balance with the internal energies of the droplet. The mean of the left and right contact angles at this time of maximum spreading should thus be used as a quasi-equilibrium contact angle for the surface.

Step 1- This script first imports the raw data from excel files which contain the mean contact angle and diameter of the droplet over time. This data is then transformed into a data frame and the initial contact angle and diameter are determined so that a ratio of the contact angle at a given time to the initial contact angle and diameter at a given time to the initial diameter may be made. Several regression models are going to be compared using these ratios, these ratios will be expressed as the variables CAT and CAO.

``` r
#Determination of Contact Angle from Multiple Regression of Diameter vs Time and Multiple Regression of Contact Angle vs Time#
#set working directory to work on EXCEL files#

#Pull the data from the desktop#
cadata <- readxl::read_excel("MR-S2-2D-FINAL.xlsx")
cadata <- data.frame(cadata)

#Select on the variables of CA, Time, and Diameter#
CAM <- data.frame(CA=c(cadata$Var.6), Time=c(cadata$Var.13), Diam=c(cadata$Var.11))

#Select only the values in the column which are numeric#
CAM <- CAM[!is.na(as.numeric(as.character(CAM$CA))), ]
```

    ## Warning in `[.data.frame`(CAM, !is.na(as.numeric(as.character(CAM$CA))), :
    ## NAs introduced by coercion

``` r
#Transform the data back into numbers, extract initial contact angle (Co) and intial diameter (Do)#
CA<-c(as.numeric(levels(CAM$CA))[CAM$CA])
```

    ## Warning: NAs introduced by coercion

``` r
Time<-c(as.numeric(levels(CAM$Time))[CAM$Time])
```

    ## Warning: NAs introduced by coercion

``` r
Diam<-c(as.numeric(levels(CAM$Diam))[CAM$Diam])
```

    ## Warning: NAs introduced by coercion

``` r
Co<-CA[c(1)]
Do<-Diam[c(1)]

Diam <- c(Diam/Do)
CAT <- c(Co/CA)
CAO <- c(CA/Co)

#Data frame which has all of the data for regressions and plots#
CAM <- data.frame(CA=c(CA), Time=c(Time), Diam=c(Diam), CAO=c(CAO), CAT=c(CAT))
```

Step 2- An exponential model will be fit to the diameter over time data, this is a model often used in semivariograms where three times the a parameter represents the range of the data, which in this case represents the time at which the diameter has reached its maximum size. This variable now known as the range will be used in the subsequent regressions of Contact angle over time to determine the semi-equilibrium contact angle.

``` r
#Plot of raw data Diam vs Time#
library(ggplot2)
Diamplot <- ggplot(CAM, aes(Time, Diam))+
  geom_point()+
  scale_y_continuous(limits=c(1,1.1))+
  scale_x_continuous(limits=c(0,100))

print(Diamplot)
```

![](task6_files/figure-markdown_github/unnamed-chunk-3-1.png)

``` r
#regression for Diam vs Time#
m <- nls(Diam ~ 1+b*(1-exp(-Time/a)),start=list(a=1,b=1), data=CAM)
m
```

    ## Nonlinear regression model
    ##   model: Diam ~ 1 + b * (1 - exp(-Time/a))
    ##    data: CAM
    ##       a       b 
    ## 2.09550 0.07718 
    ##  residual sum-of-squares: 0.0006145
    ## 
    ## Number of iterations to convergence: 9 
    ## Achieved convergence tolerance: 5.7e-06

``` r
#plot for Diam vs time#
Diamplot1<-ggplot(data=CAM, aes(x=Time,y=Diam))+
  geom_point()+
  geom_smooth(method="nls", 
              formula=y~1+b*(1-exp(-x/a)),
              method.args=list(start=c(a=1, b=1)),
              se=FALSE,
              data=CAM,
              color="red")+
  scale_y_continuous(limits=c(1,1.1))+
  scale_x_continuous(limits=c(0,100))

print(Diamplot1)
```

![](task6_files/figure-markdown_github/unnamed-chunk-3-2.png)

``` r
#Coefficient of Correlation for Diam vs Time model#
Rsquared_Diam <- cor(CAM$Diam, predict(m))

#generate table for regression parameters#
library(broom)
reg <- tidy(m)

#transform a parameter into range of regression#
a <- reg[1 , reg$estimate]
range <- 3*a

#make a variable for the b parameter for diameter vs time#
b <- reg[2, reg$estimate]
```

Step 3- The regression models of mean contact angle over time, CAO over time, and CAT over time will be computed, plotted, and a summary of the regression statistics will be outputted in reg2, reg3, and reg4. The semi-equilibrium mean contact angles will be backcalculated from the ratio transformation to the variables. A summary output of the Coefficient of Correlation for each regression and the corresponding semi-equilibrium mean contact angles is contained in the Output data frame.

``` r
#regression for CA vs Time#
m2 <- nls(CA~c*d^Time,start=list(c=50,d=0.8), data=CAM)
m2
```

    ## Nonlinear regression model
    ##   model: CA ~ c * d^Time
    ##    data: CAM
    ##       c       d 
    ## 57.4585  0.9985 
    ##  residual sum-of-squares: 123.4
    ## 
    ## Number of iterations to convergence: 5 
    ## Achieved convergence tolerance: 2.037e-07

``` r
#plot for CA vs Time#
CAplot<-ggplot(data=CAM, aes(x=Time, y=CA))+
  geom_point()+
  geom_smooth(method="nls",
              formula=y~c*d^x,
              method.args=list(start=c(c=50, d=1)),
              se=FALSE)+
  scale_y_continuous(limits=c(40,60))+
  scale_x_continuous(limits=c(0,100))

print(CAplot)
```

    ## Warning: Removed 3 rows containing non-finite values (stat_smooth).

    ## Warning: Removed 3 rows containing missing values (geom_point).

![](task6_files/figure-markdown_github/unnamed-chunk-4-1.png)

``` r
#Coefficient of correlation for CA vs Time#
Rsquared_CA <- cor(CAM$CA, predict(m2))

#generate table for regression parameters (model=m2)#
reg2 <- tidy(m2)
c <- reg2[1, reg$estimate]

d <- reg2[2, reg$estimate]

#regression for CAO=(CA/Co) vs Time#
m3 <- nls(CAO~1+e*(Time^f),start=list(e=1,f=1), data=CAM)
m3
```

    ## Nonlinear regression model
    ##   model: CAO ~ 1 + e * (Time^f)
    ##    data: CAM
    ##        e        f 
    ## -0.06892  0.24750 
    ##  residual sum-of-squares: 0.004177
    ## 
    ## Number of iterations to convergence: 9 
    ## Achieved convergence tolerance: 3.799e-07

``` r
#plot for m3#
CAOplot <- ggplot(data=CAM, aes(x=Time, y=CAO))+
  geom_point()+
  geom_smooth(method="nls",
              formula=y~1+(e*x^f),
              method.args=list(start=c(e=1, f=1)),
              se=FALSE)+
  scale_y_continuous(limits=c(0.75,1))+
  scale_x_continuous(limits=c(0,100))

print(CAOplot)
```

![](task6_files/figure-markdown_github/unnamed-chunk-4-2.png)

``` r
#Coefficient of correlation for CA/CAo vs Time (model=m3)#
Rsquared_CAO <- cor(CAM$CAO, predict(m3))

#generate table for regression parameters#
reg3<- tidy(m3)

e<- reg3[1, reg$estimate]

f<- reg3[2, reg$estimate]

#regression for CA using next method#
m4 <- nls(CAT~h*(Time^g)+1,start=list(h=1,g=1), data=CAM)
m4
```

    ## Nonlinear regression model
    ##   model: CAT ~ h * (Time^g) + 1
    ##    data: CAM
    ##       h       g 
    ## 0.06935 0.29795 
    ##  residual sum-of-squares: 0.009464
    ## 
    ## Number of iterations to convergence: 8 
    ## Achieved convergence tolerance: 6.893e-06

``` r
CATplot <- ggplot(data=CAM, aes(x=Time, y=CAT))+
  geom_point()+
  geom_smooth(method="nls",
              formula=y~1+(h*(x^g)),
              method.args=list(start=c(h=1, g=1)),
              se=FALSE)
print(CATplot)
```

![](task6_files/figure-markdown_github/unnamed-chunk-4-3.png)

``` r
Rsquared_CAT <- cor(CAM$CAT, predict(m4))

#generate table or regression parameters#
reg4 <- tidy(m4)

h <- reg4[1, reg$estimate]

g <- reg4[2, reg$estimate]

#Fit CAeq using the range from Diam vs Time regression and the model m4#
CATeq <- (Co)/(1+(h*(range^g)))

#Fit CAeq using the range from Diam vs Time regression and the model m2#
CAeq <- c*d^range

#Fit CAeq using the range from Diam vs Time regression and the model m3#
CAOeq <- (1+e*range^f)*(Co)

#Store the information for this rep in a data frame#
OUTPUT <- data.frame(range, b, c, d, Rsquared_Diam, Rsquared_CA, Rsquared_CAO, Rsquared_CAT, CAOeq, CATeq, CAeq)
```

Results/Discussion

From the OUTPUT data frame, it can be seen that the regression for the CAO ratio has the highest R squared value of all the contact angle regressions and thus the semi-equilibrium mean contact angle of 57.58 from this regression should be used as the value for this trial. Additionally, the R squared value for the diameter over time data is 0.9777 which is a good fit for this data.
