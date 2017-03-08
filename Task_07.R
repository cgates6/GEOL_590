library(nycflights13)
library(tidyverse)
library(babynames)
weather <- data.frame(nycflights13::weather)

library(ggplot2)
#Question 1:Determine whether there are any clear outliers in wind speed (wind_speed) that should be rejected. If so, filter those bad point(s) and proceed.

#plot the data so that we can visualize wind speed for outliers
ggplot(weather, aes(x=weather$time_hour, y=weather$wind_speed))+
  geom_point()

#filter the data so that outliers in wind speed are removed  
filtered_wind_speed<- filter(weather, wind_speed<250)

#Question 2:What direction has the highest median speed at each airport? Make a table and a plot of median wind speed by direction, for each airport.

#sort the median wind speed for each direction for each airport
median <- filtered_wind_speed %>%
  group_by(origin, wind_dir) %>% #Split
  summarize (
    speed=median(wind_speed, na.rm=TRUE) #Apply
  )
#combine
median

#make a bar graph of this information
bar_graph <-ggplot(median, aes(x=wind_dir, y=speed, fill=origin))+
  facet_wrap(~origin)+geom_bar(stat="identity")

print(bar_graph)

#now make this plot as a rose diagram
rose_plot <- bar_graph+coord_polar()
print(rose_plot)

#Question 3:Make a table with two columns: airline name (not carrier code) and median distance flown from JFK airport. The table should be arranged in order of decreasing mean flight distance.

#look at the data
nycflights13::flights

airline_flights <- nycflights13::flights %>% #data set to pipe into next step
  left_join(nycflights13::airlines, by="carrier") %>% #join the data frames using carrier
  filter(origin =="JFK") %>% #filter for planes leaving JFK
  arrange(desc(distance)) %>% #arrange in order of decreasing mean flight distance
  select(name,distance) #only keep the two columns
head(airline_flights) #preview the table

#Question 4: Make a wide-format data frame that displays the number of flights that leave Newark ("EWR") airport each month, from each airline.

#Split-Apply-Combine to SPLIT the data into groups based on airlines and month and filter to only use EWR data, APPLY the mean function to the data, and COMBINE the data into a wise format table.
EWR <- nycflights13::flights%>% #define the data set to pipe into the next step
  filter(origin =="EWR") %>% #filter the planes that left EWR
  group_by(carrier, month) %>% #Split into groups based on month and carrier
  summarize(n=n()) #applies a count function to the groups
EWR #look at the table

#convert this table to a wide format using the spread function
#specify that we want to split the count data, the "n" column

EWR_month <- spread(EWR, key=month, n)
EWR_month

#Question 5:Using the babynames dataset:
#Identify the ten most common male and female names in 2014. Make a plot of their frequency (prop) since 1880. (This may require two separate piped statements).

#preview the data
head(babynames)

#determine top 10 baby names in 2014
top10<-babynames %>% 
  filter(year==2014) %>% #only want baby names from 2014
  group_by(sex) %>% #group by sex
  top_n(10,n) %>% #select the top 10 values in the count column labeled n
  rename(sex2 = sex) %>% #renamed sex column to make it easier to join in the next step
  select(name,sex2) 

#need to preserve only the names that appear in the top 10
top10_all <- top10 %>%
  left_join(babynames, by="name", na.rm=TRUE)
top10_all

#need to filter out the males that were given female names
#apply a condition filter so that I can remove rows where sex2 does not equal sex

top10_mf <- top10 %>%
  left_join(babynames, by="name") %>%
  filter(sex2==sex)

#plot the name data
top10_plot <- ggplot(top10_mf, aes(x=year, y=prop, colour=sex))+
  geom_point()+
  ylab("Frequency of Names")+
  facet_wrap(~name)
print(name_plot)

#Question 6:Make a single table of the 26th through 29th most common girls names in the year 1896, 1942, and 2016
girl_names<-babynames %>%
  filter(sex=="F", year==1896|year==1942|year==2014) %>%
  group_by(year) %>%
  mutate(rank = dense_rank(desc(n))) %>% #add a column that assigns a rank to the count column 
  filter((rank > 25) & (rank < 30)) #only rank 26, 27, 28, and 29 are displayed
girl_names

#Question 7 Do something with a data set using dplyr
library(ggplot2)
summary(diamonds)

data <- diamonds %>%
  group_by(carat, cut) %>%
  filter(color == "E")
