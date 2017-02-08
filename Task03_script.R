a <- 1
b <- 2
c <- a + b
set.seed(0) 
d <- rnorm(20)
e <- rnorm(20)
f <- d + e


str(a)
typeof(a)
is.integer(a)
is.atomic(a)
is.double(a)
is.logical(a)
is.character(a)

str(b)
typeof(b)
is.integer(b)
is.atomic(b)
is.double(b)
is.logical(b)
is.character(b)

str(c)
typeof(c)
is.list(c)
is.integer(c)
is.atomic(c)
is.double(c)
is.logical(c)
is.character(c)

str(d)
typeof(d)
is.integer(d)
is.atomic(d)
is.double(d)
is.logical(d)
is.character(d)

str(e)
typeof(e)
is.list(e)
is.integer(e)
is.atomic(e)
is.double(e)
is.logical(e)
is.character(e)

str(f)
typeof(f)
is.integer(f)
is.atomic(f)
is.double(f)
is.logical(f)
is.character(f)


#create vector g with 5 elements#
g <- 1:5
#names the 5 elements of g#
g <- 1:5; names(g) <- c("a","b","c","d","e")
#recall names for elements of g#
names(g)
#asigns a description to g#
attr(g, "my_attribute") <- "This is a vector"
#recall all attributes of g#
str(attributes(g))

#for 2.2.2.3#
f1 <- factor(letters)
levels(f1) <- rev(levels(f1))
class(f1)
levels(f1)
f1

f2 <- rev(factor(letters))
f3 <- factor(letters, levels = rev(letters))
f2
f3

table (f1)
table (f2)
table (f3)

#For 2.3.1.1#
#create matrix z with 6 elements organized into 2 rows and 3 columns#
z <- matrix(1:6, ncol = 3, nrow =2)
#recall the dimensions of matrix z#
dim(z)

#recall dimensions of vector a#
#should return as NULL#
dim(a)

#For 2.3.1.2#
is.matrix(z)
is.array(z)

#For 2.3.1.3#
x1 <- array(1:5, c(1, 1, 5))
x2 <- array(1:5, c(1, 5, 1))
x3 <- array(1:5, c(5, 1, 1))

x1
x2
x3

#For 2.4.5.1#
df <- data.frame(x=1:3, y = c("a", "b", "c"))
str(df)
str(attributes(df))
df

#For 2.4.5.2, not sure if this is what is needed?#
as.matrix(df)

#For 2.4.5.3#
w <- 
dfw <- data.frame(w)

#simple operations#
plate_data <- read.csv("C:/Users/Chris/Desktop/GEOL_590/2016_10_11_plate_reader.csv", skip = 33)
(str(plate_data))
library(tidyverse)
plate_data_2 <- read_csv("C:/Users/Chris/Desktop/GEOL_590/2016_10_11_plate_reader.csv")

#subsetting#
nrow(mtcars)
length(mtcars)
ncol(mtcars)

#mtcars cyl vectors#
mtcars[]
mtcars[[c("cyl")]]
mtcars_cyl <-mtcars[[c("cyl")]]
mtcars_cyl1 <- mtcars$cyl
mtcars[c("cyl")]

#cars that weigh more than 4 and less than 3#
mtcars_wt <- subset(mtcars, wt < 3 | wt > 4)

#mpg and wt#
mtcars_mpgwt <- mtcars[c("mpg","wt")]

#car with median mpg#
median_mpg <- mtcars[which(mtcars$mpg == median(mtcars$mpg)), ]


mtcars[mtcars$cyl == 4, ] #trying to create a data frame of cars with 4 cylinders only#
mtcars[-(1:4), ]
mtcars[mtcars$cyl <= 5, ] #cars with less than 5 cylinders# #what does , do at end?#
mtcars[mtcars$cyl == 4 |mtcars$cyl == 6, ]

