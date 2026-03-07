library(tidyverse)
library(forecast)

# Import data from the assignment excel sheet
weather <- read_csv(
  "Data Athenry.csv",
  skip = 24,
  na = c("", " ", "NA"),
  show_col_types = FALSE
)
