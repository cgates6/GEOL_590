my.variable <- 2+2
my.variable/3

####
# This is an R script to demonstrate some basic operations in R
####

# Make three vectors 

x <- seq(from=1, to=20, length.out=10)
y <- rnorm(10)
labels <- letters[10] 

d <- data.frame(x, y, labels)

# Save a plot
png("test_plot.png", height=3, width=4, units="in", res=300)
plot(x, y)
dev.off()

# Save a .csv file with the data
write.csv(d,"c:/users/chris/desktop/GEOL_590/R/test_data.csv")

library(tidyverse)