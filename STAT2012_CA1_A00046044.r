# Install needed packages
if (!requireNamespace("tidyverse", quietly = TRUE)) install.packages("tidyverse")
if (!requireNamespace("forecast",  quietly = TRUE)) install.packages("forecast")

library(tidyverse)
library(forecast)

# Import data from the assignment excel sheet
weather <- read_csv(
  "Data Athenry.csv",
  skip = 24, # ignore the first 24 lines of the excel file which are metadata
  na = c("", " ", "NA"), # treats blanks as missing values
  show_col_types = FALSE
)
