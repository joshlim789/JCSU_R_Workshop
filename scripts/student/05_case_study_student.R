# ============================================================
# Module 05 — Case Study: Putting It All Together
# Student Worksheet
# Introduction to Statistics for Health Science
# ============================================================
#
# For each research question, work through the pipeline:
#   Summarize → Visualize → Model → Interpret
#
# Fill in every ___ with the correct variable name, value, or argument.
# ============================================================


# ---- Setup ----

nhanes <- read.csv("___")

str(nhanes)
summary(nhanes)


# ---- Step 1: Data Cleaning ----

nhanes_clean <- nhanes

# Binary hypertension indicator: SBP >= 140 mmHg
nhanes_clean$hypertensive <- ifelse(nhanes_clean$___ >= ___, 1, 0)

# Binary obesity indicator: BMI >= 30 kg/m²
nhanes_clean$obese <- ifelse(nhanes_clean$___ >= ___, 1, 0)

table(nhanes_clean$hypertensive)
table(nhanes_clean$obese)


# ---- Step 2: Baseline Description ----

nrow(nhanes_clean)
table(nhanes_clean$Smoker)

# Mean BMI and SBP by smoking status
mean(nhanes_clean$___[nhanes_clean$Smoker == 0])   # non-smokers
mean(nhanes_clean$___[nhanes_clean$Smoker == 1])   # smokers
mean(nhanes_clean$___[nhanes_clean$Smoker == 0])
mean(nhanes_clean$___[nhanes_clean$Smoker == 1])

# Sex distribution within each smoking group (row percentages)
sex_tab <- table(nhanes_clean$___, nhanes_clean$___)
prop.table(sex_tab, margin = 1)


# ============================================================
# Q1: BMI → Systolic Blood Pressure
# ============================================================

# ---- Q1: Summarize ----

mean(nhanes_clean$___);  sd(nhanes_clean$___)   # SBP
mean(nhanes_clean$___);  sd(nhanes_clean$___)   # BMI

cor(nhanes_clean$___, nhanes_clean$___)          # Pearson correlation


# ---- Q1: Visualize ----

plot(nhanes_clean$___, nhanes_clean$___,
     main = "BMI vs Systolic Blood Pressure",
     xlab = "BMI (kg/m²)",
     ylab = "SBP (mmHg)",
     pch  = 16,
     col  = rgb(0, 0, 1, 0.3))


# ---- Q1: Model ----

fit_lm <- lm(___ ~ ___, data = nhanes_clean)
summary(fit_lm)

coef(fit_lm)
confint(fit_lm)
summary(fit_lm)$r.squared

# Add the regression line to the scatter plot
plot(nhanes_clean$___, nhanes_clean$___,
     main = "Q1: BMI Predicts SBP",
     xlab = "BMI (kg/m²)", ylab = "SBP (mmHg)",
     pch  = 16, col = rgb(0, 0, 0.8, 0.3))
abline(___, col = "red", lwd = 2)

# Four diagnostic plots
par(mfrow = c(2, 2))
plot(___)
par(mfrow = c(1, 1))


# ---- Q1: Interpret ----

# Fill in the blanks from your model output:
# "Each 1-unit increase in BMI was associated with a ___ mmHg increase in SBP
#  (95% CI: ___ to ___; p < 0.05)."


# ============================================================
# Q2: Smoking → Hypertension
# ============================================================

# ---- Q2: Summarize ----

ct <- table(Hypertensive = nhanes_clean$___,
            Smoker       = nhanes_clean$___)
dimnames(ct)$Hypertensive <- c("No", "Yes")
dimnames(ct)$Smoker       <- c("Non-smoker", "Smoker")
addmargins(ct)

chisq.test(ct)$expected   # all cells should be >= 5


# ---- Q2: Visualize ----

props <- prop.table(ct, margin = 2)
barplot(props["___", ] * 100,
        names.arg = c("Non-smoker", "Smoker"),
        ylim   = c(0, 40),
        main   = "Hypertension Prevalence by Smoking Status",
        ylab   = "% Hypertensive",
        col    = c("lightblue", "salmon"),
        border = "white")


# ---- Q2: Model ----

chisq.test(ct)

ft <- fisher.test(ct)
ft$___    # Odds Ratio
ft$___    # 95% CI
ft$___    # exact p-value


# ---- Q2: Interpret ----

# "Smokers had ___ times the odds of hypertension compared to non-smokers
#  (95% CI: ___–___; p = ___)."


# ============================================================
# Q3: Smoking → Diabetes (Adjusted)
# ============================================================

# ---- Q3: Summarize ----

# Diabetes prevalence by smoking status
mean(nhanes_clean$___[nhanes_clean$Smoker == 0])   # non-smokers
mean(nhanes_clean$___[nhanes_clean$Smoker == 1])   # smokers

# Mean BMI by diabetes status
mean(nhanes_clean$___[nhanes_clean$Diabetes == 0])
mean(nhanes_clean$___[nhanes_clean$Diabetes == 1])


# ---- Q3: Visualize ----

par(mfrow = c(1, 2))

diab_props <- prop.table(
  table(nhanes_clean$___, nhanes_clean$___),
  margin = 1)
barplot(diab_props[, 2] * 100,
        names.arg = c("Non-smoker", "Smoker"),
        ylim = c(0, 30),
        main = "Diabetes Prevalence\nby Smoking Status",
        ylab = "% with Diabetes",
        col  = c("lightblue", "salmon"), border = "white")

boxplot(___ ~ ___, data = nhanes_clean,
        names = c("No Diabetes", "Diabetes"),
        main  = "BMI by Diabetes Status",
        ylab  = "BMI (kg/m²)",
        col   = c("lightblue", "salmon"))

par(mfrow = c(1, 1))


# ---- Q3: Model ----

fit_log <- glm(___ ~ ___ + ___ + ___,
               data   = nhanes_clean,
               family = binomial)
summary(fit_log)

exp(coef(___))        # Odds Ratios
exp(confint(___))     # 95% CIs for ORs


# ---- Q3: Visualize — Forest Plot ----

ors    <- exp(coef(fit_log))[-1]
ci_mat <- exp(confint(fit_log))[-1, ]
labs   <- c("Smoker", "BMI", "Phys. Active")

plot(ors, seq_along(ors),
     xlim = c(min(ci_mat) * 0.85, max(ci_mat) * 1.15),
     ylim = c(0.5, length(ors) + 0.5),
     pch  = 15, cex = 1.8,
     xlab = "Odds Ratio (95% CI)",
     yaxt = "n", ylab = "",
     main = "Q3: Predictors of Diabetes")
arrows(ci_mat[, 1], seq_along(ors),
       ci_mat[, 2], seq_along(ors),
       angle = 90, code = 3, length = 0.07, lwd = 2)
abline(v = ___, lty = 2, col = "red")
axis(2, at = seq_along(ors), labels = ___, las = 1)


# ---- Q3: Interpret ----

# Fill in the blanks from your model output:
# "After adjusting for BMI and physical activity, smokers had ___
#  times the odds of diabetes (95% CI: ___–___; p = ___)."
#
# "Physically active participants had ___ times the odds of diabetes
#  compared to inactive participants (95% CI: ___–___)."
