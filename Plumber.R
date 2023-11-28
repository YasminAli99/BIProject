# Load required packages
if (require("plumber")) {
  require("plumber")
} else {
  install.packages("plumber", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
# Load required packages
library(randomForest)
library(plumber)

# Load your saved Random Forest model
loaded_random_forest_model <- readRDS("./model/saved_diabetes_prediction_dateset_model_lda.rds")

# Define the Plumber API endpoint for your model
# This assumes your Random Forest model is used for disease prediction

#* @apiTitle Diabetes Prediction Model API
#* @apiDescription Used to predict diabetes based on symptoms.

#* @param gender Value for gender
#* @param age Value for age
#* @param hypertension Value for hypertension
#* @param heart_disease Value for heart_disease
#* @param smoking_history Value for smoking_history
#* @param bmi Value for bmi
#* @param HbA1c_level Value for HbA1c_level
#* @param blood_glucose_level Value for blood_glucose_level

#* @get /predict_diabetes

predict_diabetes <- function(gender, age, hypertension, heart_disease,
                            bmi, HbA1c_level, blood_glucose_level) {
  # Create a data frame using the input symptoms
  input_data <- data.frame(
    gender = as.numeric(gender),
    age = as.numeric(age),
    hypertension = as.numeric(hypertension),
    heart_disease = as.numeric(heart_disease),
    bmi = as.numeric(bmi),
    HbA1c_level = as.numeric(HbA1c_level),
    blood_glucose_level = as.numeric(blood_glucose_level)
    
  )
  
  # Make a prediction based on the input data using the loaded Random Forest model
  predictions <- predict(loaded_random_forest_model, input_data)
  return(predictions)
}

# Run the plumber API
plumber::plumb("runplumber.R")$run(port=8000)