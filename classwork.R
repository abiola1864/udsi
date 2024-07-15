# Load necessary libraries
library(tibble)      # For creating and manipulating tibbles, which are modern data frames
library(dplyr)       # For data manipulation using data frames
library(tidyverse)   # A collection of R packages for data science (includes ggplot2, dplyr, etc.)
library(writexl)     # For writing data frames to Excel files
library(readr)       # For reading data from files (CSV, etc.)

# Set the working directory
# This is the folder where your data files are located and where any output will be saved
global_wd <- "/Users/User3/Desktop/UDSI"
setwd(global_wd)

# # # # # # # # # # # #
# # Import Data
# # # # # # # # # # # #

# Read the CSV file into a data frame
officew <- read_csv("officew.csv")
# Display the first few rows of the data frame to verify the contents
head(officew)

# Rename the gender column and create subsets for Male and Female

# Filter the data for males, rename the Gender column, and add a suffix to differentiate
m <- officew %>% 
  filter(Gender == "Male") %>% 
  mutate(Gender = "Male_") %>% 
  rename(Gender1 = Gender)

# Filter the data for females and rename the Gender column
f <- officew %>% 
  filter(Gender == "Female") %>% 
  rename(Gender1 = Gender)

# Combine the male and female subsets into one data frame
final <- rbind(m, f)

# Create a data frame for males with sample data
df_m <- tibble(
  ID = 1:11,
  Gender1 = rep("Male", 11),  # Repeat the value "Male" 11 times
  weight1 = c(89, 75, 88, 75, 49, 89, 110, 120, 89, NA, 75),
  rating1 = c(5, 1, 2, 4, 9, 9, 8, 1, 9, NA, 7)
)

# Create a data frame for females with sample data
df_w <- tibble(
  ID = 1:11,
  Gender1 = rep("Female", 11),  # Repeat the value "Female" 11 times
  weight1 = c(75, 76, 87, 110, 67, 76, 43, NA, 55, 59, 60),
  rating1 = c(4, 6, 4, 1, 1, 4, 3, 6, NA, 9, 4)
)

# # # # # # # # # # # #
# # Join Data
# # # # # # # # # # # #

# Perform a left join to combine the male and female data frames by the "ID" column
df <- left_join(df_m, df_w, by = "ID")

# # # # # # # # # # # #
# # Make Data Longer
# # # # # # # # # # # #

# Pivot the data longer, converting Gender columns to a single column
df1 <- df %>% pivot_longer(
  cols = starts_with("Gender"),
  values_to = "Gender"
)

# Pivot the data longer, splitting columns into multiple rows and using regex to separate values
df2 <- df %>% pivot_longer(
  cols = -ID,
  names_to = c(".value", "count"),
  names_pattern = "(.*)\\.(.)"
)

# # # # # # # # # # # #
# # Work on Missing Data
# # # # # # # # # # # #

# Check for NA values in each column
colSums(is.na(df))

# Filter out rows with missing values in specific columns
df_nona <- df %>% 
  filter(!is.na(rating1.x)) %>% 
  filter(!is.na(weight1.x))

# Create a new column "weightclass" based on weight thresholds
df3 <- df2 %>% 
  mutate(weightclass = if_else(weight1 > 100, "Overweight", "Underweight"))

# Add a column with the mean weight, ignoring NA values
df4 <- df3 %>% 
  mutate(meanweight = mean(weight1, na.rm = TRUE))

# Summarize the data by Gender and City, calculating mean and median weights, frequency, and mean rating
df_mean <- df3 %>%
  group_by(Gender1, city) %>%
  summarise(
    meanweight = mean(weight1, na.rm = TRUE),
    medianweight = median(weight1, na.rm = TRUE),
    Freq = n(),
    mean_rating1 = mean(rating1, na.rm = TRUE)
  ) %>%
  mutate(
    proportion_ = Freq / sum(Freq),
    percentage = Freq / sum(Freq) * 100
  )



# # # # # # # # # # # #
# # EXPORTING FILES
# # # # # # # # # # # 


# Write the summary table to CSV and Excel files
write_csv(df_mean, "summarytable.csv")
write_xlsx(df_mean, "summarytable.xlsx")


# # # # # # # # # # # #
# # PLOTTING
# # # # # # # # # # # 



# Plot the data using ggplot2
plot1 <- ggplot(df_mean, aes(y = meanweight, x = mean_rating1)) +
  geom_point() +
  geom_smooth(se = FALSE, method = "lm") +
  labs(
    y = "Mean of weight",
    x = "Mean of rating",
    title = "Relationship between rating and weight by Gender and Residence"
  )

# Save the plot as a JPEG image
ggsave("plot.jpg", plot = plot1, width = 10, height = 6, dpi = 300)






# Define a custom color palette for plots
custom_colors1 <- c("#126e96", "#8B4513")

# Create a bar plot with custom colors
ggplot(df_mean, aes(y = meanweight, x = Gender1, fill = CityCentral)) +
  geom_bar(stat = "identity") +
  labs(
    y = "Mean of Gender City",
    x = "Gender"
  ) +
  scale_fill_manual(values = custom_colors1)



# # # # # # # # # # # #
# # LINEAR REGRESSION in R
# # # # # # # # # # # 

# Linear model example: fit a model predicting weight by gender
reg1 <- lm(weight1 ~ Gender1, data = df3)
summary(reg1)
