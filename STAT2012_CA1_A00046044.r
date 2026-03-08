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

