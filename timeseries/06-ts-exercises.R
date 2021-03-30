# Create interactive plot of weekly total purchases for each brand A, B, C, D

library(dplyr)
library(tidyr)
library(ggplot2)
library(dygraphs)

# 1. Load data
load("timeseries/data/purchase_data.rdata")

# 2. Use group_by and count() to get number of purchases for each brand in each week
brand_purchases <- purchase_data %>%
  group_by(brand, week) %>%
  count()
  
# 3. Use pivot_wider to spread long to wide for dygraph format (one column per brand)
brands <- brand_purchases %>%
  pivot_wider(names_from=brand, values_from=n)
  
# 4. Plot using dygraph
#unstacked
brands %>%
  dygraph() %>%
  dyOptions(stackedGraph=FALSE) %>%
  dyRangeSelector(height=20)
#stacked
brands %>%
  dygraph() %>%
  dyOptions(stackedGraph=TRUE) %>%
  dyRangeSelector(height=20)
  