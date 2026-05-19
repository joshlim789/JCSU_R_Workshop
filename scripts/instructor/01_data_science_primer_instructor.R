# ============================================================
# Module 01 — Data Science Primer
# Instructor Version
# Introduction to Statistics for Health Science
# ============================================================
#
# Audience : Undergraduate students, no prior R experience
# Duration : 60 minutes (10:00 AM – 11:00 AM)
# Dataset  : data/nhanes_sample.csv
#            (simplified NHANES teaching sample)
#
# Sections:
#   1. Loading and Inspecting Data
#   2. Accessing and Subsetting
#   3. Creating New Variables
#   4. Summarizing Data
#   5. Visualizations
#   BONUS: apply() family, aggregate(), which()
# ============================================================


# ---- Section 1: Loading and Inspecting Data ----
#
# Before any analysis, we need to get our data into R.
# The most common format in health research is CSV (comma-separated values).
# read.csv() loads a CSV file and stores it as a "data frame" — R's main
# rectangular data structure, much like a spreadsheet.
#
# We then use a set of first-look functions to understand the size and
# shape of the data before touching a single number.

# Load the dataset from the data/ folder
# header = TRUE tells R the first row contains column names (the default)
# stringsAsFactors = FALSE keeps text columns as character, not factor
nhanes <- read.csv("../../data/nhanes_sample.csv",
                   header          = TRUE,
                   stringsAsFactors = FALSE)

# Show the first 6 rows — get a sense of layout and values
head(nhanes)

# Show the last 6 rows — check for trailing blank rows or junk data
tail(nhanes)

# Count the number of rows (observations / participants)
nrow(nhanes)

# Count the number of columns (variables)
ncol(nhanes)

# dim() returns both at once as a vector: c(rows, cols)
dim(nhanes)

# names() lists all column names in order
names(nhanes)

# str() is the single most informative first-look function:
# it shows every column's type (int, num, chr) and the first few values
# Connect this to Module 02: int = integer, num = numeric, chr = character
str(nhanes)


# ---- Section 2: Accessing and Subsetting ----
#
# Once data is loaded, we often need to pull out specific columns or rows.
# R's bracket notation [rows, cols] is the core tool.
# nhanes[row_condition, "column_name"] — leave either blank to mean "all".

# Dollar sign: access a single column by name — returns a vector
nhanes$BMI       # all BMI values

# Bracket notation: [rows, columns]
# Leaving rows blank means "all rows"; "BMI" selects the column
nhanes[, "BMI"]  # identical result to nhanes$BMI

# Subset rows: keep only smokers (Smoker == 1)
# Note: == is comparison (asking if equal); = is assignment (setting a value)
smokers <- nhanes[nhanes$Smoker == 1, ]
nrow(smokers)   # how many smokers in the sample?

# Subset rows: keep only non-smokers
non_smokers <- nhanes[nhanes$Smoker == 0, ]
nrow(non_smokers)

# Subset with multiple conditions using & (AND)
# Keep participants who smoke AND are over 40
older_smokers <- nhanes[nhanes$Smoker == 1 & nhanes$Age > 40, ]
nrow(older_smokers)

# Subset with OR condition using | (OR)
# Keep participants who are diabetic OR physically inactive
at_risk <- nhanes[nhanes$Diabetes == 1 | nhanes$PhysActive == 0, ]
nrow(at_risk)

# Subset rows AND select specific columns at the same time
# Keep Age, BMI, SBP for female participants only
females_slim <- nhanes[nhanes$Sex == "Female", c("Age", "BMI", "SBP")]
head(females_slim)


# ---- Section 3: Creating New Variables ----
#
# Health research frequently requires deriving new variables from raw data.
# BMI is measured continuously, but clinical decisions use categories.
# ifelse() is the key tool: test a condition, return one value if TRUE,
# another if FALSE. We assign the result as a new column using $.

# Create a binary "obese" indicator: BMI >= 30 is the WHO/CDC cutoff
# ifelse(test, value_if_TRUE, value_if_FALSE)
nhanes$obese <- ifelse(nhanes$BMI >= 30, 1, 0)

# Verify: look at the new column alongside BMI
head(nhanes[, c("BMI", "obese")])

# Create a hypertension indicator: SBP >= 140 mmHg (JNC 7 Stage 2 threshold)
nhanes$hypertensive <- ifelse(nhanes$SBP >= 140, 1, 0)

# Check counts: how many are hypertensive?
table(nhanes$hypertensive)

# Create a 4-level BMI category using nested ifelse()
# This builds categories: Underweight, Normal, Overweight, Obese
nhanes$BMI_cat <- ifelse(nhanes$BMI < 18.5, "Underweight",
                  ifelse(nhanes$BMI < 25,   "Normal",
                  ifelse(nhanes$BMI < 30,   "Overweight",
                                            "Obese")))

# Verify the distribution across BMI categories
table(nhanes$BMI_cat)

# Create an age group variable using cut() — cleaner for many breaks
nhanes$age_group <- cut(nhanes$Age,
                        breaks = c(0, 30, 45, 60, Inf),  # break points
                        labels = c("< 30", "30-44", "45-59", "60+"),
                        right  = FALSE)   # intervals are [left, right)

# Check distribution across age groups
table(nhanes$age_group)

# Confirm all new variables were added
names(nhanes)


# ---- Section 4: Summarizing Data ----
#
# Summary statistics translate raw data into interpretable numbers.
# In health science, we routinely report means, medians, and distributions
# both for the full sample and broken down by key subgroups (sex, smoking).
# R's base functions make this straightforward.

# summary() on the whole data frame:
# numeric columns -> min, Q1, median, mean, Q3, max (and NA count)
# character columns -> length and class
summary(nhanes)

# summary() on a single variable — useful for a closer look
summary(nhanes$BMI)
summary(nhanes$SBP)

# One-way table: count participants by sex
table(nhanes$Sex)

# One-way table: count by smoking status
table(nhanes$Smoker)

# Two-way table: Sex (rows) by Smoker (columns)
# Cells contain the count of participants in each combination
table(nhanes$Sex, nhanes$Smoker)

# Two-way table: obesity by hypertension
# INSTRUCTOR: point out the pattern — do obese people have higher hypertension?
table(nhanes$obese, nhanes$hypertensive)

# Add margin totals to the two-way table
addmargins(table(nhanes$Sex, nhanes$Smoker))

# Convert to proportions (prop.table):
# margin = 1 gives row proportions; margin = 2 gives column proportions
prop.table(table(nhanes$Sex, nhanes$Smoker), margin = 1)

# ---- BONUS: which(), which.min(), which.max() ----
#
# which() returns the INDEX (row number) of elements that match a condition.

# Which rows have SBP >= 180? (hypertensive crisis level)
crisis_rows <- which(nhanes$SBP >= 180)
length(crisis_rows)          # how many such participants?
nhanes[crisis_rows, ]        # show those rows

# which.min() and which.max() return the index of the min/max value
low_bmi_index  <- which.min(nhanes$BMI)
nhanes[low_bmi_index, ]

high_sbp_index <- which.max(nhanes$SBP)
nhanes[high_sbp_index, ]
