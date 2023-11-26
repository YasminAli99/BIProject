# STEP 1. Install and Load the required packages/Libraries
# Install renv:
if (!is.element("renv", installed.packages()[, 1])) {
  install.packages("renv", dependencies = TRUE)
}
require("renv")

# renv::restore() command.
if (!is.element("languageserver", installed.packages()[, 1])) {
  install.packages("languageserver", dependencies = TRUE)
}
require("languageserver")


## Loading Library
library(data.table)
library(magrittr)
library(ggplot2)

## STEP 2:Load Data 
library(readr)
diabetes <- read_csv("C:/Users/User/github-classroom/BIProject/Milestone 1/data/diabetes.csv")
setnames(diabetes, old = c("DiabetesPedigreeFunction", "Outcome"), 
         new = c("DPF", "Diagnosis"))
head(diabetes)

# Dimensions ----
## STEP 3: Preview the Loaded Datasets ----
# Dimensions refer to the number of observations (rows) and the number of
# attributes/variables/features (columns). Execute the following commands to
# display the dimensions of your datasets:

dim(diabetes)

# Data Types ----
## STEP 4: Identify the Data Types ----
# Knowing the data types will help you to identify the most appropriate
# visualization types and algorithms that can be applied. 

sapply(diabetes, class)

### STEP 5. Measure the distribution of the data for each variable ----
summary (diabetes)

### STEP 6. Measure the standard deviation of each variable ----
sapply(diabetes[, c(1, 2, 3, 5, 6, 7, 8, 9)], sd)

### STEP 7. Measure the variance of each variable ----
sapply(diabetes[, 1:9], var)

### STEP 8. Measure the kurtosis of each variable ----
if (!is.element("e1071", installed.packages()[, 1])) {
  install.packages("e1071", dependencies = TRUE)
}
require("e1071")

sapply(diabetes[, 1:9],  kurtosis, type = 2)

### STEP 9. Measure the skewness of each variable ----
sapply(diabetes[, 1:9],  skewness, type = 2)

## STEP 10. Measure the covariance between variables ----
diabetes_cov <- cov(diabetes[, 1:9])
View(diabetes_cov)

## STEP 11. Measure the correlation between variables ----
diabetes_cor <- cor(diabetes[, 1:9])
View(diabetes_cor)


### STEP 12. Create Box and Whisker Plots for Each Numeric Attribute ----
par(mfrow = c(1, 8))
for (i in 1:8) {
  boxplot(diabetes[, i], main = names(diabetes)[i])
}

### STEP 13. Create a Missingness Map to Identify Missing Data ----
if (!is.element("Amelia", installed.packages()[, 1])) {
  install.packages("Amelia", dependencies = TRUE)
}
require("Amelia")

missmap(diabetes, col = c("red", "grey"), legend = TRUE)

### STEP 14. Create a Correlation Plot ----
if (!is.element("corrplot", installed.packages()[, 1])) {
  install.packages("corrplot", dependencies = TRUE)
}
require("corrplot")

corrplot(cor(diabetes[, 1:8]), method = "circle")

