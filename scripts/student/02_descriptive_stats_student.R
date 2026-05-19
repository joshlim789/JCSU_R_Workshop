# ============================================================
# Module 02 — Descriptive Statistics 101
# Student Worksheet
# Introduction to Statistics for Health Science
# ============================================================
#
# Fill in every ___ with the correct function name, variable
# name, or value.
# ============================================================


# ---- Setup ----

nhanes <- read.csv("___")

head(___)
str(___)
dim(___)


# ---- Measures of Central Tendency ----

# What is the average BMI?
___(nhanes$___)

# What is the average SBP?
mean(nhanes$___)

# What is the middle value of SBP?
___(nhanes$___)

# How many Males and Females are in the sample?
table(nhanes$___)

# What proportion of participants are current smokers?
mean(nhanes$___)


# ---- Measures of Spread ----

# How spread out is BMI around the mean?
___(nhanes$___)

# Calculate the variance of BMI
___(nhanes$___)

# What is the interquartile range of SBP?
___(nhanes$___)

# What are the minimum and maximum values of SBP?
___(nhanes$___)

# Find the 25th, 50th, and 75th percentiles of SBP
___(nhanes$___, probs = c(0.25, 0.50, 0.75))

# Get a full statistical overview of every column at once
___(nhanes)


# ---- Data Types ----

# What data type is each of these columns?
___(nhanes$___)   # Age
___(nhanes$___)   # Sex
___(nhanes$___)   # Smoker

# Counts and proportions for Diabetes
table(nhanes$___)
prop.table(table(nhanes$___))

# Cross-tabulation: Smoker (rows) by Diabetes (columns)
table(nhanes$___, nhanes$___)


# ---- Bivariate Analysis ----

# How strongly and in what direction are BMI and SBP related?
___(nhanes$___, nhanes$___)

# Fit a simple linear model: SBP predicted by BMI
fit <- ___(___ ~ ___, data = nhanes)
summary(___)


# ---- Visualizations ----

# Plot the distribution of BMI
___(nhanes$___,
    main = "Distribution of ___",
    xlab = "___",
    col  = "steelblue")

# Compare the spread of SBP between smokers and non-smokers
___(nhanes$___ ~ nhanes$___,
    names = c("Non-smoker", "Smoker"),
    main  = "SBP by Smoking Status",
    ylab  = "SBP (mmHg)",
    col   = c("lightblue", "salmon"))

# Plot the relationship between BMI and SBP
___(nhanes$___, nhanes$___,
    main = "BMI vs SBP",
    xlab = "BMI (kg/m²)",
    ylab = "SBP (mmHg)",
    pch  = 16,
    col  = rgb(0, 0, 1, 0.3))

# Add the fitted regression line to the scatter plot
___(fit, col = "red", lwd = 2)

# Plot the count of participants in each racial/ethnic group
race_counts <- table(nhanes$___)
___(race_counts,
    main = "Participants by Race/Ethnicity",
    ylab = "Count",
    col  = "steelblue",
    las  = 2)

# Compare the distribution of SBP across racial/ethnic groups
boxplot(nhanes$___ ~ nhanes$___,
        main = "SBP by Race/Ethnicity",
        ylab = "SBP (mmHg)",
        col  = "lightblue",
        las  = 2)


# ---- On Your Own ----

# 1. Compute mean and SD of Chol (total cholesterol).

# 2. Plot a histogram of Age.

# 3. Compute the correlation between Age and SBP.
#    Is it stronger or weaker than the BMI–SBP correlation?

# 4. Fit a linear model predicting Chol from Age.
