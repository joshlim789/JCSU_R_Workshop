# ============================================================
# Module 01 — Data Science Primer
# Student Worksheet
# Introduction to Statistics for Health Science
# ============================================================
#
# Fill in every ___ with the correct function name, variable
# name, or value.
#
# Tip: == is comparison   = is assignment
# ============================================================


# ---- Section 1: Loading and Inspecting Data ----

nhanes <- read.csv("___")

# How many participants are in the dataset?
___(nhanes)

# How many variables does the dataset have?
___(nhanes)

# Check the size of the dataset in both directions at once
___(nhanes)

# What are the variable names?
___(nhanes)

# Preview the first few rows
___(nhanes)

# Preview the last few rows
___(nhanes)

# Get a compact overview of every column's type and values
___(nhanes)


# ---- Section 2: Accessing and Subsetting ----

# Access the Age column using the $ operator
nhanes$___

# Access the SBP column using bracket notation
nhanes[, "___"]

# Create "smokers" — only rows where Smoker == 1
smokers <- nhanes[nhanes$___ == ___, ]
nrow(smokers)

# Create "females" — only rows where Sex == "Female"
females <- nhanes[nhanes$___ == "___", ]
nrow(females)

# Create "older_smokers" — smokers AND age > 50
older_smokers <- nhanes[nhanes$___ == ___ & nhanes$___ > ___, ]
nrow(older_smokers)


# ---- Section 3: Creating New Variables ----

# obese = 1 if BMI >= 30, 0 otherwise
nhanes$obese <- ifelse(nhanes$___ >= ___, 1, 0)

# How many participants fall into each category?
___(nhanes$obese)

# hypertensive = 1 if SBP >= 140, 0 otherwise
nhanes$hypertensive <- ifelse(nhanes$___ >= ___, 1, 0)

table(nhanes$___)


# ---- Section 4: Summarizing Data ----

# Get a statistical overview of every variable at once
___(nhanes)

# Count participants by Sex
table(nhanes$___)

# Two-way table: rows = Sex, columns = Smoker
table(nhanes$___, nhanes$___)

# What fraction of participants belong to each Race category?
___(table(nhanes$___))
