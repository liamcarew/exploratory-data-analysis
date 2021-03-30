library(dplyr)
library(lubridate)
library(nycflights13)
library(ggplot2)

# 1. Open the `flights` dataset

data(flights)
head(flights, 5)
names(flights)

# 2. Use make_datetime() to combine the year, month, day, hour and minute variables
# into a single variable containing the departure time

flights_dt <- flights %>% 
  dplyr::select(year, month, day, hour, minute, dep_delay) %>% 
  mutate(departure = make_datetime(year=year, month=month, day=day, hour=hour, min=minute))

# 3. Remove the variables you used to make up the departure variable
flights_dt <- flights_dt %>% 
  dplyr::select(-c('year', 'month', 'day', 'hour', 'minute'))

# 4. Make a line plot of the average departure delay within each hour of the day

#isolate the hour component of the time of each departure and add it in as a row.
#group these hours and then summarise the average departure delay using summarise() and mean()
flights_dt %>%
  filter(!is.na(flights_dt)) %>%
  mutate(hour = hour(departure)) %>%
  group_by(hour) %>%
  summarise(meandepdelay = mean(dep_delay)) %>%
  ggplot(aes(x=hour, y=meandepdelay)) +
  geom_line()


