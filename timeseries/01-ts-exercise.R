library(lubridate)

# Use the appropriate lubridate function to parse each of the following dates:

d1 <- "January 1, 2010"
mdy(d1)

d2 <- "2015-Mar-07"
ymd(d2)

d3 <- "06-Jun-2017"
dmy(d3)

d4 <- c("August 19 (2015)", "July 1 (2015)")
mdy(d4)

d5 <- "12/30/14" # Dec 30, 2014
mdy(d5)
