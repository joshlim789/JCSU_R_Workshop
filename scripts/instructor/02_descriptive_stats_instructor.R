# ============================================================
# Module 02 — Descriptive Statistics 101
# Instructor Version
# Introduction to Statistics for Health Science
# ============================================================
#
# Dataset: NHANES sample (data/nhanes_sample.csv)
# Columns:
#   ID          - participant identifier (integer)
#   Age         - age in years (integer)
#   Sex         - "Male" or "Female" (character)
#   Race        - race/ethnicity category (character)
#   BMI         - body mass index (numeric)
#   SBP         - systolic blood pressure, mmHg (numeric)
#   DBP         - diastolic blood pressure, mmHg (numeric)
#   Smoker      - current smoker: 0 = No, 1 = Yes (integer)
#   Diabetes    - diabetes diagnosis: 0 = No, 1 = Yes (integer)
#   PhysActive  - physically active: 0 = No, 1 = Yes (integer)
#   Chol        - total cholesterol, mg/dL (numeric)
#   Income      - income bracket (character)
#
# NOTE: Base R only — no packages required.
#       Optional: install.packages("epitools") for odds ratios later.
# ============================================================


# ---- Setup ----
# Before any analysis, we load the data and take a quick look.
# read.csv() reads a comma-separated values file into a data frame.
# The path is relative to the scripts/ folder — navigate up one level
# with "../" to reach the data/ folder.

nhanes <- read.csv("../../data/nhanes_sample.csv")   # load dataset into R

# head() shows the first 6 rows — a quick sanity check that the file
# loaded correctly and columns are named as expected
head(nhanes)

# str() shows the structure: column names, data types, and a preview
# of values. Crucial for catching misclassified columns (e.g., an
# ID column that R thinks is numeric but should be treated as a label).
str(nhanes)

# dim() returns number of rows and columns as a two-element vector
dim(nhanes)    # [rows, columns]

# names() lists every column name — handy when writing $ references
names(nhanes)


# ---- Measures of Central Tendency ----
# Central tendency answers: "What is a typical value?"
# Two main measures: mean (arithmetic average) and median (middle value).
# For skewed health data, mean and median can differ substantially —
# always compare both.

# --- Mean ---
# The arithmetic mean sums all observations and divides by n.

mean(nhanes$BMI)     # mean BMI across all participants
mean(nhanes$SBP)     # mean systolic blood pressure
mean(nhanes$Age)     # mean age

# Binary variable trick: mean of a 0/1 column = proportion of 1s
mean(nhanes$Smoker)   # proportion who currently smoke
mean(nhanes$Diabetes)   # proportion with diabetes

# --- Median ---
# The median is the value at the 50th percentile.
# It is resistant to outliers — one extreme value barely moves it.

median(nhanes$BMI)   # median BMI
median(nhanes$SBP)   # median SBP

# Compare mean vs. median for SBP — are they close or far apart?
# A large gap suggests skewness.
cat("SBP mean:  ", mean(nhanes$SBP), "\n")
cat("SBP median:", median(nhanes$SBP), "\n")

# ---- Measures of Spread ----
# Spread answers: "How variable are the values around the center?"
# High spread means observations differ widely; low spread means they
# cluster tightly. Two patients with the same mean BP but different
# spread have very different clinical pictures.

# --- Standard deviation and variance ---
# sd() is the typical (root-mean-square) distance from the mean.
# var() is sd()^2 — useful in formulas but harder to interpret directly
# because the units are squared (e.g., mmHg² for blood pressure).

sd(nhanes$BMI)    # SD of BMI — same units as BMI
var(nhanes$BMI)    # variance of BMI (BMI²)

sd(nhanes$SBP)    # SD of systolic BP
sd(nhanes$Chol)    # SD of total cholesterol

# --- IQR and range ---
# IQR() returns the interquartile range: Q3 - Q1 (middle 50% of data).
# It is resistant to outliers, unlike range().

IQR(nhanes$SBP)    # IQR of SBP
IQR(nhanes$BMI)    # IQR of BMI

# range() returns a two-element vector: c(minimum, maximum)
range(nhanes$SBP)  # min and max SBP in the sample
range(nhanes$Age)  # min and max age

# quantile() is the most flexible — specify any percentile(s)
# probs is a vector of proportions between 0 and 1
quantile(nhanes$SBP, probs = c(0.10, 0.25, 0.50, 0.75, 0.90))   # deciles and quartiles of SBP

# --- Five-number summary ---
# summary() on a numeric column returns: Min, Q1, Median, Mean, Q3, Max
# This is the fastest single-function overview of a continuous variable.
summary(nhanes$SBP)              # five-number summary + mean for SBP
summary(nhanes$BMI)              # same for BMI

# summary() on the full data frame applies to every column at once
summary(nhanes)                  # overview of the entire dataset


# ---- Data Types ----
# Knowing each column's data type is essential: it determines which
# statistics and visualizations are appropriate.
# class() reports R's internal storage class for a column.

class(nhanes$Age)        # "integer" — discrete numeric
class(nhanes$BMI)        # "numeric" — continuous
class(nhanes$Sex)        # "character" — categorical / nominal
class(nhanes$Smoker)     # "integer" — binary (0/1)
class(nhanes$Income)     # "character" — ordered categorical (stored as text)

# table() for binary and categorical columns — see how values are distributed
table(nhanes$Smoker)       # counts of non-smokers (0) vs. smokers (1)
table(nhanes$Diabetes)     # counts for diabetes
table(nhanes$PhysActive)   # counts for physical activity

# Cross-tabulation: table() with two arguments shows a contingency table
# Rows = Smoker status, Columns = Diabetes status
table(nhanes$Smoker, nhanes$Diabetes)

# Add meaningful row and column labels with dnn argument
table(Smoker   = nhanes$Smoker,
      Diabetes = nhanes$Diabetes)


# ---- Bivariate Analysis ----
# Bivariate means "two variables." We now ask whether two variables
# are associated — do they move together in a systematic way?
# Two main tools: correlation (strength of linear association) and
# linear regression (a predictive equation for that association).

# --- Correlation ---
# cor() computes Pearson's r, ranging from -1 to +1.

cor(nhanes$BMI, nhanes$SBP)    # BMI vs. SBP
cor(nhanes$BMI, nhanes$Chol)   # BMI vs. cholesterol
cor(nhanes$Age, nhanes$SBP)    # age vs. SBP

# Interpret: r > 0 means both variables tend to rise together;
# r < 0 means one rises as the other falls;
# r near 0 means no linear relationship.

# --- Simple linear regression ---
# lm() fits a linear model.
# Formula syntax: outcome ~ predictor
# The result is an object we save to fit_sbp_bmi for later use.
fit_sbp_bmi <- lm(SBP ~ BMI, data = nhanes)

# summary() on an lm object shows:
#   Coefficients table (Estimate, Std. Error, t value, p-value)
#   R-squared (proportion of variance in SBP explained by BMI)
#   Residual standard error (typical prediction error)
summary(fit_sbp_bmi)

# How to read the output:
#   (Intercept) Estimate = predicted SBP when BMI = 0 (not directly meaningful)
#   BMI Estimate         = for every 1-unit increase in BMI, SBP changes by this amount
#   Pr(>|t|) < 0.05      = the slope is statistically significantly different from zero

# Additional regression: SBP predicted by Age
fit_sbp_age <- lm(SBP ~ Age, data = nhanes)
summary(fit_sbp_age)

# Multiple regression: SBP predicted by both BMI and Age simultaneously
fit_sbp_multi <- lm(SBP ~ BMI + Age, data = nhanes)
summary(fit_sbp_multi)

# coef() extracts just the coefficient estimates if you need them separately
coef(fit_sbp_bmi)           # c(Intercept, BMI slope)
coef(fit_sbp_bmi)["BMI"]   # just the BMI slope by name


# ---- Visualizations ----
# Always visualize your data — summary statistics alone can be misleading.
# Four essential plots for health data: histogram, boxplot, scatter, bar chart.

# --- Histogram: distribution of BMI ---
# hist() divides a continuous variable into bins and draws a bar for each.
# breaks controls the number of bins (R may adjust the exact count slightly).
hist(nhanes$BMI,
     breaks = 25,                              # request ~25 bins
     col    = "steelblue",                     # fill color for bars
     border = "white",                         # white border between bars
     main   = "Distribution of BMI",           # chart title
     xlab   = "BMI (kg/m²)",                   # x-axis label
     ylab   = "Frequency")                     # y-axis label

# Add reference lines for WHO BMI categories
abline(v = 18.5, col = "darkgreen", lwd = 2, lty = 2)  # underweight cutoff
abline(v = 25.0, col = "orange",    lwd = 2, lty = 2)  # overweight cutoff
abline(v = 30.0, col = "red",       lwd = 2, lty = 2)  # obese cutoff

# Add a legend to explain the reference lines
legend("topright",
       legend = c("Underweight (18.5)", "Overweight (25)", "Obese (30)"),
       col    = c("darkgreen", "orange", "red"),
       lty    = 2, lwd = 2,
       bty    = "n")    # bty = "n" removes the legend box border


# --- Boxplot: SBP by Smoker status ---
# boxplot() with formula notation splits one continuous variable by a group.
# The box shows Q1–Q3; the line inside is the median; dots are outliers.
boxplot(SBP ~ Smoker,
        data  = nhanes,
        col   = c("lightblue", "salmon"),        # color for each group
        names = c("Non-Smoker (0)", "Smoker (1)"), # x-axis group labels
        main  = "Systolic Blood Pressure by Smoking Status",
        ylab  = "SBP (mmHg)",
        xlab  = "Smoking Status",
        notch = FALSE)                           # set TRUE for confidence notches

# --- Scatter plot: BMI vs SBP with regression line ---
# plot() creates a scatter — each point is one participant.
# adjustcolor() adds transparency (alpha) to reduce overplotting.
plot(nhanes$BMI, nhanes$SBP,
     xlab = "BMI (kg/m²)",
     ylab = "Systolic Blood Pressure (mmHg)",
     main = "BMI vs. Systolic Blood Pressure",
     pch  = 16,                                        # solid circle symbol
     col  = adjustcolor("steelblue", alpha.f = 0.4),   # 40% opacity
     cex  = 0.7)                                       # 70% of default size

# abline() with an lm object draws the fitted regression line
abline(fit_sbp_bmi, col = "red", lwd = 2)

# Add a legend explaining the line
legend("topleft",
       legend = "Regression line",
       col    = "red", lwd = 2, bty = "n")


# --- Bar chart: sample composition by Sex ---
# table() counts each category; barplot() converts those counts to bars.
sex_counts <- table(nhanes$Sex)    # count Males and Females

barplot(sex_counts,
        col   = c("lightpink", "lightblue"),
        main  = "Sample Composition by Sex",
        ylab  = "Number of Participants",
        xlab  = "Sex",
        ylim  = c(0, max(sex_counts) * 1.25))   # extra vertical space for labels

# Add count labels on top of each bar using text()
# barplot() returns the x-center of each bar; use those for positioning
bar_centers <- barplot(sex_counts,
                       col  = c("lightpink", "lightblue"),
                       main = "Sample Composition by Sex",
                       ylab = "Number of Participants",
                       xlab = "Sex",
                       ylim = c(0, max(sex_counts) * 1.25))
text(x      = bar_centers,
     y      = sex_counts + max(sex_counts) * 0.03,   # just above each bar
     labels = sex_counts,                             # display the raw counts
     cex    = 0.9)


# ---- BONUS / Extensions ----
# These examples extend the core material for students who finish early
# or want to explore on their own. Each block is self-contained.

# --- Custom histogram: breaks, colors, and density overlay ---
# Using freq = FALSE converts the y-axis from counts to density,
# which allows overlaying a smooth curve.
hist(nhanes$SBP,
     breaks = 30,
     freq   = FALSE,                              # density instead of count
     col    = "lightcoral",
     border = "white",
     main   = "SBP Distribution with Density Curve",
     xlab   = "SBP (mmHg)")

# lines() draws a smooth kernel density estimate on top of the histogram
lines(density(nhanes$SBP),
      col = "darkred", lwd = 2)


# --- Adding a legend to the boxplot ---
# par(xpd = TRUE) allows drawing outside the plot area (needed for some legends)
boxplot(SBP ~ Smoker,
        data  = nhanes,
        col   = c("lightblue", "salmon"),
        names = c("Non-Smoker", "Smoker"),
        main  = "SBP by Smoking Status",
        ylab  = "SBP (mmHg)")

legend("topright",
       legend = c("Non-Smoker", "Smoker"),
       fill   = c("lightblue", "salmon"),    # fill = colored rectangles
       bty    = "n",
       title  = "Group")


# --- Correlation matrix for multiple numeric variables ---
# Select only the continuous numeric columns, then pass to cor().
numeric_cols <- nhanes[, c("Age", "BMI", "SBP", "DBP", "Chol")]

# cor() on a data frame returns a symmetric matrix of pairwise correlations
cor_matrix <- cor(numeric_cols)
round(cor_matrix, 2)    # round to 2 decimal places for readability

# Visualize the correlation matrix with colored squares
# image() is a base-R heatmap function; we reverse the color scale
# so positive correlations appear warm (red) and negatives cool (blue)
image(cor_matrix,
      col  = rev(heat.colors(20)),
      main = "Correlation Matrix — Numeric Variables",
      axes = FALSE)                         # suppress default axis numbers

# Add variable name labels on both axes
axis(1, at = seq(0, 1, length.out = ncol(cor_matrix)),
     labels = colnames(cor_matrix), las = 2)
axis(2, at = seq(0, 1, length.out = nrow(cor_matrix)),
     labels = rownames(cor_matrix), las = 1)

