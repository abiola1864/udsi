
# Package Installation (if needed)
# install.packages("dplyr")


# Basic Arithmetic Operations
1 * 4  # Multiplication
mymaths <- 1 + 1  # Addition and assignment

# Mathematical Functions
sqrt(16)  # Square root of 16

# Comparison Operators
5 < 6  # Less than
5 > 6  # Greater than
5 <= 5  # Less than or equal to
5 != 6  # Not equal to

# Creating Vectors
ingredient <- c("sugar", "garri", "water")
costprice <- c(10, 20, 40)

# Creating a Data Frame
df1 <- data.frame(ingredient, costprice)
df1  # Display the data frame

# Adding a New Column to the Data Frame
df1$selling_price <- c(5, 6, 7)

# Using dplyr for Data Manipulation
library(dplyr)
df1 <- df1 %>% mutate(
  selling_price1 = c(5, 6, 7)
)

# Accessing Data Frame Columns
df1$costprice  # Access 'costprice' column
df1$ingredient  # Access 'ingredient' column

# Calculating Percent and Profit
df1$percent <- df1$costprice / 100  # Calculate percent of cost price
df1$profit <- df1$selling_price - df1$costprice  # Calculate profit
df1$Gender <- c("Male", "Female", "Male")  # Add a 'Gender' column

# Basic Functions
colnames(df1)  # Column names of the data frame
class(df1$Gender)  # Class of the 'Gender' column

# Converting to Factor
df1$Gender <- as.factor(df1$Gender)

# Attach the Data Frame (not recommended for large data frames)
attach(df1)

# Reading Data from CSV
library(haven)
officew <- read.csv("~/Desktop/Desktop Jan -May2023/officew.csv")

# Calculating Mean and Median
mean(officew$income)  # Mean of 'income'
median(officew$rating)  # Median of 'rating'

# Converting 'Marstatus' to Factor and Checking Levels
class(officew$Marstatus)  # Check class of 'Marstatus'
officew$Marstatus <- as.factor(officew$Marstatus)  # Convert to factor
levels(officew$Marstatus)  # Check levels of 'Marstatus'

# Selecting Specific Columns with dplyr
officew_gender_marital <- officew %>% select(Marstatus, Gender)
officew_gender_marital  # Display selected columns

# Filtering Data with dplyr
officew %>% filter(income >= 50000)  # Filter rows with 'income' >= 50000

# Using mutate and case_when for Conditional Mutations
# Example placeholders
# df1 <- df1 %>% mutate(new_column = case_when(condition1 ~ result1, condition2 ~ result2, ...))

# Handling Missing Values
# Example placeholders
# df1 <- df1 %>% filter(!is.na(column_name))  # Remove rows with missing values in 'column_name'

# Filtering Based on Multiple Conditions
women_80 <- officew %>% filter(Gender == "Female" | weight >= 80) %>% 
  filter(CityCentral == "Yes")
women_80  # Display filtered data


# Example Data Frame Creation
df <- data.frame(
  myingredient = ingredient,
  myprice = costprice
)

# Data Types
# Numerical data: 10, 20.5
# Nominal data / character: "sugar", "garri", "water"

# Display the final data frame
df1
