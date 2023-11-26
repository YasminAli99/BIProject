LOADING AND PREPROCESSING DATA

```         
library(readr)
diabetes <- read_csv("C:/Users/User/github-classroom/BIProject/Milestone 1/data/diabetes.csv")

## Rows: 768 Columns: 9
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## dbl (9): Pregnancies, Glucose, BloodPressure, SkinThickness, Insulin, BMI, D...
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

library(data.table)
setnames(diabetes, old = c("DiabetesPedigreeFunction", "Outcome"), 
         new = c("DPF", "Diagnosis"))
head(diabetes)

## # A tibble: 6 × 9
##   Pregnancies Glucose BloodPressure SkinThickness Insulin   BMI   DPF   Age
##         <dbl>   <dbl>         <dbl>         <dbl>   <dbl> <dbl> <dbl> <dbl>
## 1           6     148            72            35       0  33.6 0.627    50
## 2           1      85            66            29       0  26.6 0.351    31
## 3           8     183            64             0       0  23.3 0.672    32
## 4           1      89            66            23      94  28.1 0.167    21
## 5           0     137            40            35     168  43.1 2.29     33
## 6           5     116            74             0       0  25.6 0.201    30
## # ℹ 1 more variable: Diagnosis <dbl>

dim(diabetes)

## [1] 768   9

sapply(diabetes, class)

##   Pregnancies       Glucose BloodPressure SkinThickness       Insulin 
##     "numeric"     "numeric"     "numeric"     "numeric"     "numeric" 
##           BMI           DPF           Age     Diagnosis 
##     "numeric"     "numeric"     "numeric"     "numeric"
```

DATA DISTRIBUTION AND MEASURES

```         
##   Pregnancies        Glucose      BloodPressure    SkinThickness  
##  Min.   : 0.000   Min.   :  0.0   Min.   :  0.00   Min.   : 0.00  
##  1st Qu.: 1.000   1st Qu.: 99.0   1st Qu.: 62.00   1st Qu.: 0.00  
##  Median : 3.000   Median :117.0   Median : 72.00   Median :23.00  
##  Mean   : 3.845   Mean   :120.9   Mean   : 69.11   Mean   :20.54  
##  3rd Qu.: 6.000   3rd Qu.:140.2   3rd Qu.: 80.00   3rd Qu.:32.00  
##  Max.   :17.000   Max.   :199.0   Max.   :122.00   Max.   :99.00  
##     Insulin           BMI             DPF              Age       
##  Min.   :  0.0   Min.   : 0.00   Min.   :0.0780   Min.   :21.00  
##  1st Qu.:  0.0   1st Qu.:27.30   1st Qu.:0.2437   1st Qu.:24.00  
##  Median : 30.5   Median :32.00   Median :0.3725   Median :29.00  
##  Mean   : 79.8   Mean   :31.99   Mean   :0.4719   Mean   :33.24  
##  3rd Qu.:127.2   3rd Qu.:36.60   3rd Qu.:0.6262   3rd Qu.:41.00  
##  Max.   :846.0   Max.   :67.10   Max.   :2.4200   Max.   :81.00  
##    Diagnosis    
##  Min.   :0.000  
##  1st Qu.:0.000  
##  Median :0.000  
##  Mean   :0.349  
##  3rd Qu.:1.000  
##  Max.   :1.000

##   Pregnancies       Glucose BloodPressure       Insulin           BMI 
##     3.3695781    31.9726182    19.3558072   115.2440024     7.8841603 
##           DPF           Age     Diagnosis 
##     0.3313286    11.7602315     0.4769514

##   Pregnancies       Glucose BloodPressure SkinThickness       Insulin 
##  1.135406e+01  1.022248e+03  3.746473e+02  2.544732e+02  1.328118e+04 
##           BMI           DPF           Age     Diagnosis 
##  6.215998e+01  1.097786e-01  1.383030e+02  2.274826e-01

##   Pregnancies       Glucose BloodPressure SkinThickness       Insulin 
##     0.1592198     0.6407798     5.1801566    -0.5200719     7.2142596 
##           BMI           DPF           Age     Diagnosis 
##     3.2904429     5.5949535     0.6431589    -1.6009298

##   Pregnancies       Glucose BloodPressure SkinThickness       Insulin 
##     0.9016740     0.1737535    -1.8436080     0.1093725     2.2722509 
##           BMI           DPF           Age     Diagnosis 
##    -0.4289816     1.9199111     1.1295967     0.6350166
```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.

RELATIONSHIPS AND ASSOCIATIONS

```         
diabetes_cov <- cov(diabetes[, 1:9])
View(diabetes_cov)

diabetes_cor <- cor(diabetes[, 1:9])
View(diabetes_cor)
```

VISUALIZATION

```         
par(mfrow = c(1, 8))
for (i in 1:8) {
  boxplot(diabetes[, i], main = names(diabetes)[i])
}
```

![](Milestone1-Markdown_files/figure-markdown_strict/unnamed-chunk-3-1.png)

```         
library(Amelia)

## Loading required package: Rcpp

## ## 
## ## Amelia II: Multiple Imputation
## ## (Version 1.8.1, built: 2022-11-18)
## ## Copyright (C) 2005-2023 James Honaker, Gary King and Matthew Blackwell
## ## Refer to http://gking.harvard.edu/amelia/ for more information
## ##

missmap(diabetes, col = c("red", "grey"), legend = TRUE)

## Warning: Unknown or uninitialised column: `arguments`.
## Unknown or uninitialised column: `arguments`.

## Warning: Unknown or uninitialised column: `imputations`.
```

![](Milestone1-Markdown_files/figure-markdown_strict/unnamed-chunk-3-2.png)

```         
library("corrplot")

## corrplot 0.92 loaded

corrplot(cor(diabetes[, 1:8]), method = "circle")
```

![](Milestone1-Markdown_files/figure-markdown_strict/unnamed-chunk-3-3.png)
