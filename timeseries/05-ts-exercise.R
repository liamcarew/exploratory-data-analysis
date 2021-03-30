# Repeat the analysis above for the `ChickWeight` dataset. Look for any interesting 
# patterns in individual chicks.

library(dplyr)
library(lubridate)
library(tsibble)
library(ggplot2)
library(brolgar)

# 1. Load the `ChickWeight` data
data("ChickWeight")

# 2. Turn this into a tsibble. What's the key, what's the index? Is it regular?
chick_weight <- as_tsibble(x = ChickWeight,
                           key = Chick,      # individual identifier
                           index = Time,     # number of days since hatching
                           regular = TRUE)

# Sample a handful of time series
chick_weight %>%
  sample_n_keys(size=5) %>%
  ggplot(aes(x=Time,y=weight,group=Chick)) +
  geom_line() +
  labs(x = 'Number of days since hatched', y = 'Weight of chick (g)')
  
# Plot 4 chicks per facet, in 5 facets
chick_weight %>%
  ggplot(aes(x=Time,y=weight,group=Chick)) +
  geom_line() +
  labs(x = 'Number of days since hatched', y = 'Weight of chick (g)') +
  facet_sample(n_per_facet=4, n_facets=5)