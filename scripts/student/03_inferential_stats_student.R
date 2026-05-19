# ============================================================
# Module 03 — Inferential Statistics 101
# Student Worksheet
# Introduction to Statistics for Health Science
# ============================================================
#
# Fill in every ___ with the correct variable name, value,
# or argument. Run each block as you go.
#
# Tip: == is comparison   = is assignment
# ============================================================


# ---- Section 1: Setup + Sampling Variability ----

nhanes <- read.csv("___")

dim(___)

# True mean SBP in the full dataset
mean(nhanes$___)

# Draw 5 random samples of size 30; compute mean SBP each time
replicate(___, mean(sample(nhanes$___, ___, replace = TRUE)))

# Run it again — do you get the same five numbers?


# ---- Section 2: Sampling Distributions and CLT ----

set.seed(42)

# 1000 simulations of mean SBP from samples of size 30
sample_means <- replicate(___, mean(sample(nhanes$___, ___, replace = TRUE)))

# How many values are in sample_means?
length(___)

# Mean of the sample means — should be close to the true mean
mean(___)

# SD of the sample means — this is the empirical Standard Error
sd(___)

# Plot the sampling distribution
hist(___,
     main = "Sampling Distribution of Mean SBP (1000 simulations, n=30)",
     xlab = "Sample Mean SBP (mmHg)",
     col  = "steelblue")

# Add a vertical line at the true mean
abline(v = mean(nhanes$___), col = "red", lwd = 2)


# ---- Section 3: Standard Error and Confidence Intervals ----

# Calculate SE manually: SD / sqrt(n)
SE <- sd(nhanes$___) / sqrt(nrow(___))
SE

# Manual 95% CI: mean ± 1.96 × SE
x_bar <- mean(nhanes$___)
lower <- x_bar - ___ * SE
upper <- x_bar + ___ * SE
c(lower, upper)

# Confirm with t.test() — uses the t-distribution (slightly wider for small n)
t.test(nhanes$___)$conf.int

# Compare CI width: small sample vs. full dataset
small_sample <- sample(nhanes$___, 30)
diff(t.test(___)$conf.int)      # width for small sample
diff(t.test(nhanes$___)$conf.int)   # width for full dataset
# Which is wider? Why?


# ---- Section 4: Hypothesis Testing ----

# Research question: Do smokers and non-smokers differ in mean SBP?

# H0:
# H1:

# Group means before testing
mean(nhanes$___[nhanes$Smoker == 0])   # non-smokers
mean(nhanes$___[nhanes$Smoker == 1])   # smokers

# Two-sample Welch t-test
t_result <- t.test(___ ~ ___, data = ___)
t_result

# Extract individual components
t_result$___     # t-statistic
t_result$___     # p-value
t_result$___     # 95% CI for the difference in means
t_result$___     # group means

# Formal decision at alpha = 0.05
alpha <- 0.05
if (t_result$___ < alpha) {
  cat("Reject H0\n")
} else {
  cat("Fail to reject H0\n")
}


# ---- Section 5: Odds Ratios and 2x2 Tables ----

# Create binary hypertension variable
nhanes$hypertensive <- ifelse(nhanes$___ >= ___, 1, 0)

# Build the 2x2 table: rows = Smoker, columns = hypertensive
tab <- table(nhanes$___, nhanes$___)
addmargins(___)

# Run Fisher's exact test — gives OR, 95% CI, and exact p-value
ft <- fisher.test(___)
ft

ft$___    # Odds Ratio
ft$___    # 95% CI
ft$___    # p-value

# Write an interpretation sentence as a comment:
# "Smokers had ___ times the odds of hypertension (95% CI: ___, ___).
#  This association [was / was not] statistically significant (p = ___)."

# BONUS: Run chisq.test(tab).
# Does its p-value agree with fisher.test()?
# What does chisq.test() NOT give you?
chisq.test(___)
