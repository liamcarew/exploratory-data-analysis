# Use the tools above to see if there are more purchases made on certain days of the week.

library(dplyr)
library(lubridate)
library(tsibble)
library(ggplot2)
library(feasts)

# 1. Load data
load("timeseries/data/purchase_data.rdata")

# 2. Use group_by and count() to get number of purchases (any brand) for each day in each 
# month
purchases <- purchase_data %>%
  group_by(month, day) %>%
  count()
  
# 3. Turn this into a tsibble. What's the key, what's the index? Is it regular?
store_counts_ts <- as_tsibble(x = purchases,
                              key = month,
                              index = day,
                              regular = TRUE)

# 4. Plot the number of purchases per day in each month (facet or colour by month)
store_counts_ts %>%
  ggplot(aes(x = day,
             y = n, colour=factor(day))) + 
  geom_line(group = 1) +
  labs(y ='number of purchases', colour = 'day') +
  facet_wrap(~ month)
#I've factored the days so that they can be more easily compared in the TS plots

# 5. Do a seasonal decomposition using STL
sdecomp <- store_counts_ts %>%
  model(STL(n ~ season())) %>%
  components

autoplot(sdecomp) + xlab("Day")



