# installs the needed packages for R
if (!requireNamespace("tidyverse", quietly = TRUE)) install.packages("tidyverse")
if (!requireNamespace("forecast",  quietly = TRUE)) install.packages("forecast")

# loads the libraries/packages for the assignment
# tidyverse for importing, cleaning, transforming and plotting the weather data
# forecast for calculating the moving average
library(tidyverse)
library(forecast)

# imports the data from the assignment excel sheet
weather <- read_csv(
  "Data Athenry.csv",
  skip = 24, # ignore the first 24 lines of the excel file which are metadata
  na = c("", " ", "NA"), # treats blanks as missing values
  show_col_types = FALSE
)

# keep only needed columns and clean data
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

# Monthly rainfall totals
monthly_rain <- weather %>%
  group_by(year, month_num, month_name) %>% # used for the rainfall graphs
  summarise(monthly_rain = sum(rain, na.rm = TRUE), .groups = "drop") %>%
  mutate(month_date = as.Date(paste(year, month_num, "01", sep = "-")))

# Plot 1: Monthly rainfall over time
p1 <- ggplot(monthly_rain, aes(x = month_date, y = monthly_rain)) +
  geom_line(color = "#0B5A7A") +
  labs(
    title = "Monthly Rainfall Over Time at Athenry",
    x = "Date",
    y = "Monthly Rainfall (mm)"
  ) +
  theme_minimal()

print(p1)
ggsave("monthly_rainfall_time_plot.png", plot = p1, width = 8, height = 5)

# plot 2: histogram of monthly rainfall
p2 <- ggplot(monthly_rain, aes(x = monthly_rain)) +
  geom_histogram(bins = 20, fill = "#AED3E6", color = "#0B5A7A") +
  labs(
    title = "Histogram of Monthly Rainfall at Athenry",
    x = "Monthly Rainfall (mm)",
    y = "Frequency"
  ) +
  theme_minimal()

# outputs the plot 2
print(p2)
ggsave("monthly_rainfall_histogram.png", plot = p2, width = 8, height = 5)

# getting the wettest month
wettest_month_totals <- monthly_rain %>%
  group_by(month_name) %>%
  summarise(avg_monthly_rain = mean(monthly_rain, na.rm = TRUE), .groups = "drop") %>%
  arrange(desc(avg_monthly_rain))

print(wettest_month_totals)

# probability of a rainy day
prob_rainy_day <- mean(weather$rain > 0, na.rm = TRUE) 
prob_rainy_day_percent <- prob_rainy_day * 100 # the percentage

print(prob_rainy_day)
print(prob_rainy_day_percent)

# month moving average
weather <- weather %>%
  arrange(date) %>%
  mutate(
    lta_mean_temp = as.numeric(ma(mean_temp, order = 31, centre = FALSE))
  )

# year for daily temperature plot
chosen_year <- 2020

temp_year <- weather %>%
  filter(year == chosen_year)

# quartiles
q1 <- quantile(temp_year$mean_temp, 0.25, na.rm = TRUE)
q2 <- quantile(temp_year$mean_temp, 0.50, na.rm = TRUE)
q3 <- quantile(temp_year$mean_temp, 0.75, na.rm = TRUE)

print(q1)
print(q2)
print(q3)

# plot 3: daily temperature vs long-term average with quartiles
p3 <- ggplot(temp_year, aes(x = date)) +
  geom_line(aes(y = mean_temp, colour = "Daily Mean Temperature"), size = 0.8) +
  geom_line(aes(y = lta_mean_temp, colour = "31-day Long-Term Average"), size = 1) +
  geom_hline(yintercept = q1, linetype = "dashed", colour = "#AED3E6") +
  geom_hline(yintercept = q2, linetype = "dashed", colour = "#0B5A7A") +
  geom_hline(yintercept = q3, linetype = "dashed", colour = "#1F6787") +
  labs(
    title = paste("Daily Mean Temperature vs Long-Term Average in", chosen_year),
    x = "Date",
    y = "Temperature (°C)",
    colour = "Legend"
  ) +
  theme_minimal()

# outputs the plot 3
print(p3)
ggsave("temperature_lta_quartiles_plot.png", plot = p3, width = 9, height = 5)

# average monthly rainfall by calendar month
avg_month_rain <- monthly_rain %>%
  group_by(month_name) %>%
  summarise(
    avg_rain = mean(monthly_rain, na.rm = TRUE),
    .groups = "drop"
  )

# plot 4: average monthly rainfall by calendar month bar chart
p4 <- ggplot(avg_month_rain, aes(x = month_name, y = avg_rain)) +
  geom_col(fill = "#AED3E6", color = "#0B5A7A") +
  labs(
    title = "Average Monthly Rainfall at Athenry",
    x = "Month",
    y = "Average Rainfall (mm)"
  ) +
  theme_minimal()

# outputs the plot 4
print(p4)
ggsave("avg_monthly_rainfall_barplot.png", plot = p4, width = 8, height = 5)

# plot 5: boxplot of daily mean temperature by month
p5 <- ggplot(weather, aes(x = month_name, y = mean_temp)) +
  geom_boxplot(fill = "#AED3E6", alpha = 0.7, color = "#0B5A7A") +
  labs(
    title = "Distribution of Daily Mean Temperature by Month",
    x = "Month",
    y = "Mean Temperature (°C)"
  ) +
  theme_minimal()

print(p5)
ggsave("temperature_boxplot_by_month.png", plot = p5, width = 8, height = 5)
