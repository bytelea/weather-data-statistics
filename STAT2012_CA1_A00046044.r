# installs the needed packages for R
if (!requireNamespace("tidyverse", quietly = TRUE)) install.packages("tidyverse")
if (!requireNamespace("forecast",  quietly = TRUE)) install.packages("forecast")

# loads the libraries/packages for the assignment
library(tidyverse)
library(forecast)

# imports the data from the assignment excel sheet
weather <- read_csv(
  "Data Athenry.csv",
  skip = 24, # ignore the first 24 lines of the excel file which are metadata
  na = c("", " ", "NA"), # treats blanks as missing values
  show_col_types = FALSE
)

# keeps only needed columns and cleans the data
weather <- weather %>%
  select(date, maxtp, mintp, rain) %>%
  mutate(
    date = as.Date(date, format = "%d-%b-%Y"),
    maxtp = as.numeric(maxtp), 
    mintp = as.numeric(mintp),
    rain = as.numeric(rain),
    mean_temp = (maxtp + mintp) / 2, # calculates the average daily temperature
    year = as.integer(format(date, "%Y")), # extracts the year and month from each date
    month_num = as.integer(format(date, "%m")), 
    month_name = factor(month.abb[month_num], levels = month.abb)
  )
