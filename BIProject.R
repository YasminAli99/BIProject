if (!is.element("languageserver", installed.packages()[, 1])) {
  install.packages("languageserver", dependencies = TRUE)
}
require("languageserver")




#Milestone 1----


###Issue 1: DESCRIPTIVE STATISTICS ----
#Code 
library(readr)
# Load the mice package
library(mice)

# Read the CSV file with read.csv
library(readxl)
diabetes_prediction_dataset <- read_excel("data/diabetes_prediction_dataset.xlsx")
View(diabetes_prediction_dataset)

#Dimensions
dim(diabetes_prediction_dataset)

# Data Types 
sapply(diabetes_prediction_dataset, class)


# Measure of Frequency
diabetes_prediction_frequencies <- table(diabetes_prediction_dataset$gender)

# Measure of Central Tendency
diabetes_prediction_dataset_freq <- diabetes_prediction_dataset$smoking_history
cbind(frequency = table(diabetes_prediction_dataset_freq),
      percentage = prop.table(table(diabetes_prediction_dataset_freq)) * 100)


diabetes_prediction_dataset_mode <- names(table(diabetes_prediction_dataset$gender))[
  which(table(diabetes_prediction_dataset$gender) ==
          max(table(diabetes_prediction_dataset$gender)))
]
print(diabetes_prediction_dataset_mode)

# Measure of Distribution
summary(diabetes_prediction_dataset)

#Measure of Standard deviation
sapply(diabetes_prediction_dataset[, c(2, 3, 6, 7, 8, 9)], sd)

#Measure the variance of each variable 
sapply(diabetes_prediction_dataset[, c(2, 3, 6, 7, 8, 9)], var)

#Measure of kurtosis of each variable
if (!is.element("e1071", installed.packages()[, 1])) {
  install.packages("e1071", dependencies = TRUE)
}
require("e1071")

sapply(diabetes_prediction_dataset[, 6:9],  kurtosis, type = 2)

#Measure of skewness of each variable
sapply(diabetes_prediction_dataset[, 6:9],  skewness, type = 2)

# Measure of Relationship
#diabetes_prediction_dataset_association <- chisq.test(diabetes_prediction_dataset$gender)

###Issue 2: STATISTICAL TEST (ANOVA)----
diabetes_prediction_dataset_one_way_anova <- aov(age ~ diabetes, data = diabetes_prediction_dataset)
summary(diabetes_prediction_dataset_one_way_anova)


###Issue 3: UNVARIATE AND MULTIVARIATE PLOTS----
# Load required libraries
if (!is.element("caret", installed.packages()[, 1])) {
  install.packages("caret", dependencies = TRUE)
}
require("caret")
featurePlot(x = diabetes_prediction_dataset[, 2:4], y = diabetes_prediction_dataset[, 9],
            plot = "box")

if (!is.element("corrplot", installed.packages()[, 1])) {
  install.packages("corrplot", dependencies = TRUE)
}
require("corrplot")
corrplot(cor(diabetes_prediction_dataset[, 6:9]), method = "circle")


#Milestone 2----

###Issue 5 :MISSING VALUES, DATA IMPUTATION AND DATA TRANSFORMATION----

# Load required libraries
## dplyr ----
if (require("dplyr")) {
  require("dplyr")
} else {
  install.packages("dplyr", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

#Is there missing data?
any(is.na(diabetes_prediction_dataset))


#Milestone 3----
###Issue 6 : TRAINING THE MODEL MILESTONE ----
#split the dataset
train_index <- createDataPartition(diabetes_prediction_dataset$gender,
                                   p = 0.75,
                                   list = FALSE)
diabetes_prediction_dataset_train <- diabetes_prediction_dataset[train_index, ]
diabetes_prediction_dataset_test <- diabetes_prediction_dataset[-train_index, ]

###Classification: LDA with k-fold Cross Validation ----
train_control <- trainControl(method = "cv", number = 5)

diabetes_prediction_dateset_model_lda <-
  caret::train(`gender` ~ ., data = diabetes_prediction_dataset_train,
               trControl = train_control, na.action = na.omit, method = "lda2",
               metric = "Accuracy")

###Cross validation ----
#check if the outcome variable is a factor
str(diabetes_prediction_dataset$diabetes)

# If 'Outcome' is not a factor, convert it to one
diabetes_prediction_dataset$diabetes <- as.factor(diabetes_prediction_dataset$diabetes)

# Set the seed for reproducibility
set.seed(123)

# Define the training control
library(caret)
# Define the training control
train_control <- trainControl(method = "cv",
                              number = 10,
                              search = "grid",
                              classProbs = TRUE,
                              summaryFunction = multiClassSummary)

#Model training Random Forest 
###Train a Random Forest model----
library(randomForest)
rf_model <- train(gender~ ., data = diabetes_prediction_dataset_train, method = "rf", trControl = train_control)

# Make predictions on the testing set
predictions <- predict(rf_model, newdata = diabetes_prediction_dataset_test)

###Train an SVM model----
library(e1071)
svm_model <- train(gender ~ ., data = diabetes_prediction_dataset_train, method = "svmRadial", trControl = train_control)

#Model sampling and comparison
# Define the control parameters for resampling
train_control <- trainControl(method = "cv", number = 10)  # 10-fold cross-validation

# List of trained models
models_list <- list(
  Random_Forest = rf_model,
  SVM = svm_model
)

# Compare model performance using resampling techniques
results <- resamples(models_list, control = train_control)

# Summarize and compare model performance metrics (e.g., accuracy, sensitivity, specificity)
summary(results)

#Milestone 4 ----
### Issue 7 : HYPER-PARAMETER TUNING AND ENSEMBLES

# Load necessary libraries
library(caret)
library(randomForest)

# Define the grid of hyperparameters for mtry
grid <- expand.grid(mtry = c(2, 4, 6, 8, 10)) # Vary the number of variables randomly sampled as candidates at each split

# Set up the control parameters for grid search
control <- trainControl(method = "cv", number = 5) 

# Perform grid search for hyperparameters (only mtry)
model_grid_search <- train(gender ~ ., data = diabetes_prediction_dataset_train, method = "rf",
                           trControl = control, tuneGrid = grid)

#Milestone 5 ----
### Issue 8 : CONSOLIDATION ---
saveRDS(diabetes_prediction_dateset_model_lda, "./model/saved_diabetes_prediction_dateset_model_lda.rds")
