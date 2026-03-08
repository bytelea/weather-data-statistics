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

# monthly rainfall totals
monthly_rain <- weather %>%
  group_by(year, month_num, month_name) %>% # used for the rainfall graphs
  summarise(monthly_rain = sum(rain, na.rm = TRUE), .groups = "drop") %>%
  mutate(month_date = as.Date(paste(year, month_num, "01", sep = "-")))

# plot 1: monthly rainfall over time
p1 <- ggplot(monthly_rain, aes(x = month_date, y = monthly_rain)) +
  geom_line(color = "#0B5A7A") +
  labs(
    title = "Monthly Rainfall Over Time at Athenry",
    x = "Date",
    y = "Monthly Rainfall (mm)"
  ) +
  theme_minimal()

# outputs the plot 1
print(p1) 
ggsave("monthly_rainfall_time_plot.png", plot = p1, width = 8, height = 5)
