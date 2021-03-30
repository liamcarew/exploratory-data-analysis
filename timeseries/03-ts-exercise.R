# Write a function that given your birthday (as a date), 
# returns how old you are in years.

#function would need to find the duration between your birthday and today()
#this would give seconds so needs to be converted to years

age <- function(bday) {
  age <- round((bday %--% today()) / years(1), 2)
  return(paste(age, 'years', sep=' '))
}

age(ymd("1981-03-13"))
