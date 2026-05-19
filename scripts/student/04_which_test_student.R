# ============================================================
# Module 04 — Which Statistical Test?
# Student Worksheet
# Introduction to Statistics for Health Science
# ============================================================
#
# Fill in every ___ with the correct variable name, value,
# or argument. Run each block as you go.
# ============================================================


# ---- Setup ----

nhanes <- read.csv("___")

nhanes$hypertensive <- ifelse(nhanes$___ >= ___, 1, 0)
nhanes$obese        <- ifelse(nhanes$___ >= ___, 1, 0)

table(nhanes$___)
table(nhanes$___)


# ---- Section 1: Two-Sample t-Test ----

# Research question: Is mean SBP different between smokers and non-smokers?

boxplot(___ ~ ___, data = nhanes,
        names = c("Non-smoker", "Smoker"),
        main  = "SBP by Smoking Status",
        ylab  = "Systolic Blood Pressure (mmHg)",
        col   = c("lightblue", "salmon"))

t_result <- t.test(___ ~ ___, data = ___)
t_result

t_result$___     # group means
t_result$___     # t-statistic
t_result$___     # p-value
t_result$___     # 95% CI for the difference

# Do you reject H0 at alpha = 0.05?


# ---- Section 2: One-Way ANOVA ----

# Research question: Does mean SBP differ across racial/ethnic groups?

# Why not run pairwise t-tests instead?
# Because ___

boxplot(___ ~ ___, data = nhanes,
        main = "SBP by Race/Ethnicity",
        ylab = "SBP (mmHg)",
        col  = "lightblue",
        las  = 2)

fit_aov <- aov(___ ~ ___, data = nhanes)
summary(___)

# Post-hoc: which pairs of groups differ?
TukeyHSD(___)


# ---- Section 3: Paired t-Test ----

# Research question: Did an exercise intervention lower SBP after 8 weeks?

pre <- nhanes$SBP[1:50]

set.seed(42)
post <- pre - rnorm(___, mean = ___, sd = ___)

diffs <- ___ - ___
mean(___)
sd(___)
hist(___, main = "Distribution of SBP Changes", xlab = "Change in SBP (mmHg)",
     col = "lightgreen")
abline(v = 0, col = "red", lty = 2)

# Correct: paired test
result_paired <- t.test(___, ___, paired = ___)
result_paired

# Wrong: unpaired test (for comparison only)
result_unpaired <- t.test(___, ___, paired = ___)

# Which gives a smaller p-value? Why?
result_paired$___
result_unpaired$___


# ---- Section 4: Chi-Square Test ----

# Research question: Is smoking associated with diabetes?

ct <- table(nhanes$___, nhanes$___)
dimnames(ct) <- list(Smoker   = c("Non-smoker", "Smoker"),
                     Diabetes = c("No Diabetes", "Diabetes"))
addmargins(___)

# Check expected cell counts
chisq.test(___)$expected

# Run chi-square test
chisq.test(___)

# Run Fisher's exact test — also gives OR and 95% CI
ft <- fisher.test(___)
ft$___     # Odds Ratio
ft$___     # 95% CI
ft$___     # exact p-value

# "Smokers had ___ times the odds of diabetes (95% CI: ___, ___).
#  This association [was / was not] statistically significant (p = ___)."


# ---- Section 5: Simple Linear Regression ----

# Research question: How does BMI predict systolic blood pressure?

plot(nhanes$___, nhanes$___,
     main = "BMI vs SBP",
     xlab = "BMI (kg/m²)",
     ylab = "SBP (mmHg)",
     pch  = 16,
     col  = rgb(0, 0, 1, 0.4))

fit <- lm(___ ~ ___, data = nhanes)
abline(___, col = "red", lwd = 2)

summary(___)
coef(___)
confint(___)
summary(___)$r.squared

# Four diagnostic plots
par(mfrow = c(2, 2))
plot(___)
par(mfrow = c(1, 1))

# What do you observe in each panel?
# Residuals vs Fitted:
# Normal Q-Q:
# Scale-Location:
# Residuals vs Leverage:


# ---- Section 6: Logistic Regression ----

# Research question: What factors predict hypertension?
# Outcome is BINARY (0/1) — we model P(hypertensive = 1 | BMI, Smoker)

fit_log <- glm(___ ~ ___ + ___,
               data   = nhanes,
               family = ___)
summary(___)

# Exponentiate to get Odds Ratios
exp(coef(___))

# 95% CIs for ORs
exp(confint(___))

# BMI OR:    for each 1-unit increase in BMI, the odds of hypertension ___
# Smoker OR: compared to non-smokers, smokers have ___ times the odds


# ---- Section 7: Wilcoxon Rank-Sum Test ----

# When should you use a non-parametric test instead of a t-test?
# Write your answer as a comment:
#

wilcox.test(___ ~ ___, data = nhanes)

# Compare the p-value to the t-test p-value from Section 1.
# Are the conclusions the same? Which test makes fewer assumptions?
