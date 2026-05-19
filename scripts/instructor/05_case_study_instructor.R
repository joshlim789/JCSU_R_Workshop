# ============================================================
# Module 05 — Case Study: Putting It All Together
# Instructor Version
# Introduction to Statistics for Health Science
# ============================================================
#
# Timing:   3:00 – 4:00 PM (capstone session)
# Audience: Undergraduate students, health science backgrounds
# Dataset:  data/nhanes_sample.csv
# Format:   Live coding — instructor types, students follow along
#
# Your PI asks three research questions.
# Each is answered sequentially:
#   Summarize → Visualize → Model → Interpret
#
# Q1: Is BMI associated with systolic blood pressure?
#     → Simple linear regression
# Q2: Is smoking associated with hypertension?
#     → Chi-square + fisher.test() for OR
# Q3: After adjusting for BMI and physical activity,
#     is smoking independently associated with diabetes?
#     → Multivariable logistic regression
#
# BONUS:
#   - Multiple regression model comparison with anova()
#   - Sensitivity / specificity from logistic regression
# ============================================================


# ---- Setup ----

nhanes <- read.csv("../../data/nhanes_sample.csv")

str(nhanes)
summary(nhanes)


# ---- Step 1: Data Cleaning ----

nhanes_clean <- nhanes

# Verify coding of binary variables
table(nhanes_clean$Smoker)
table(nhanes_clean$Diabetes)
table(nhanes_clean$PhysActive)
range(nhanes_clean$BMI)
range(nhanes_clean$SBP)

# Derived variables
nhanes_clean$hypertensive <- ifelse(nhanes_clean$SBP >= 140, 1, 0)
nhanes_clean$obese        <- ifelse(nhanes_clean$BMI >= 30,  1, 0)

table(nhanes_clean$hypertensive)
table(nhanes_clean$obese)


# ---- Step 2: Baseline Description (Table 1) ----

# Sample size
nrow(nhanes_clean)
table(nhanes_clean$Smoker)

# Continuous variables by smoking status (bracket notation)
mean(nhanes_clean$Age[nhanes_clean$Smoker == 0]);  sd(nhanes_clean$Age[nhanes_clean$Smoker == 0])
mean(nhanes_clean$Age[nhanes_clean$Smoker == 1]);  sd(nhanes_clean$Age[nhanes_clean$Smoker == 1])

mean(nhanes_clean$BMI[nhanes_clean$Smoker == 0]);  sd(nhanes_clean$BMI[nhanes_clean$Smoker == 0])
mean(nhanes_clean$BMI[nhanes_clean$Smoker == 1]);  sd(nhanes_clean$BMI[nhanes_clean$Smoker == 1])

mean(nhanes_clean$SBP[nhanes_clean$Smoker == 0]);  sd(nhanes_clean$SBP[nhanes_clean$Smoker == 0])
mean(nhanes_clean$SBP[nhanes_clean$Smoker == 1]);  sd(nhanes_clean$SBP[nhanes_clean$Smoker == 1])

# Categorical variables by smoking status
sex_tab <- table(nhanes_clean$Smoker, nhanes_clean$Sex)
prop.table(sex_tab, margin = 1) * 100

diab_tab <- table(nhanes_clean$Smoker, nhanes_clean$Diabetes)
prop.table(diab_tab, margin = 1) * 100

pa_tab <- table(nhanes_clean$Smoker, nhanes_clean$PhysActive)
prop.table(pa_tab, margin = 1) * 100

# Are groups comparable? Imbalances suggest potential confounders.


# ============================================================
# Q1: BMI → Systolic Blood Pressure
# ============================================================

# ---- Q1: Summarize ----

mean(nhanes_clean$SBP);  sd(nhanes_clean$SBP)
mean(nhanes_clean$BMI);  sd(nhanes_clean$BMI)

# Pearson correlation — direction and strength before modeling
cor(nhanes_clean$BMI, nhanes_clean$SBP)


# ---- Q1: Visualize ----

plot(nhanes_clean$BMI, nhanes_clean$SBP,
     main = "BMI vs Systolic Blood Pressure",
     xlab = "BMI (kg/m²)",
     ylab = "SBP (mmHg)",
     pch  = 16,
     col  = rgb(0, 0, 1, 0.3))
# Does the scatter suggest a positive linear trend?


# ---- Q1: Model ----

fit_lm <- lm(SBP ~ BMI, data = nhanes_clean)
summary(fit_lm)

# Key output:
#   Estimate (BMI)  — slope: SBP change per 1 kg/m² increase in BMI
#   Pr(>|t|)        — p-value for H0: beta1 = 0
#   R-squared       — proportion of SBP variance explained by BMI

coef(fit_lm)
confint(fit_lm)
summary(fit_lm)$r.squared

# Scatter plot with regression line
plot(nhanes_clean$BMI, nhanes_clean$SBP,
     main = "Q1: BMI Predicts SBP",
     xlab = "BMI (kg/m²)", ylab = "SBP (mmHg)",
     pch  = 16, col = rgb(0, 0, 0.8, 0.3))
abline(fit_lm, col = "red", lwd = 2)
legend("topleft",
       legend = paste("R² =", round(summary(fit_lm)$r.squared, 3)),
       bty = "n")

# Assumption check: four diagnostic plots
par(mfrow = c(2, 2))
plot(fit_lm)
par(mfrow = c(1, 1))
# Residuals vs Fitted: random scatter → linearity ok
# Normal Q-Q:          points on diagonal → normality ok
# Scale-Location:      flat band → equal variance
# Residuals vs Leverage: no points past Cook's distance → no influential outliers


# ---- Q1: Interpret ----

cat("Slope (BMI on SBP):", round(coef(fit_lm)[2], 3), "mmHg per kg/m²\n")
cat("95% CI:            ", round(confint(fit_lm)[2, 1], 2),
    "to", round(confint(fit_lm)[2, 2], 2), "\n")
cat("R-squared:         ", round(summary(fit_lm)$r.squared, 3), "\n")

# Template sentence:
# "Each 1-unit increase in BMI was associated with a [slope] mmHg increase in SBP
#  (95% CI: [lower]–[upper]; p < 0.05)."


# ============================================================
# Q2: Smoking → Hypertension
# ============================================================

# ---- Q2: Summarize ----

ct <- table(Hypertensive = nhanes_clean$hypertensive,
            Smoker       = nhanes_clean$Smoker)
dimnames(ct)$Hypertensive <- c("No", "Yes")
dimnames(ct)$Smoker       <- c("Non-smoker", "Smoker")
ct
addmargins(ct)

# Check expected cell counts (chi-square needs all >= 5)
chisq.test(ct)$expected


# ---- Q2: Visualize ----

props <- prop.table(ct, margin = 2)   # column proportions
barplot(props["Yes", ] * 100,
        names.arg = c("Non-smoker", "Smoker"),
        ylim   = c(0, 40),
        main   = "Hypertension Prevalence by Smoking Status",
        ylab   = "% Hypertensive",
        col    = c("lightblue", "salmon"),
        border = "white")
# Do smokers appear more likely to be hypertensive?


# ---- Q2: Model ----

# Chi-square test of independence
result_chi <- chisq.test(ct)
result_chi
# X-squared: sum of (O - E)^2 / E; df = 1 for 2x2; p-value tests independence

# fisher.test(): always valid; returns OR + 95% CI + exact p-value
ft <- fisher.test(ct)
ft

ft$estimate   # Odds Ratio
ft$conf.int   # 95% CI for OR
ft$p.value    # exact p-value

cat("OR =", round(ft$estimate, 2),
    "  95% CI: (", round(ft$conf.int[1], 2), ",", round(ft$conf.int[2], 2), ")",
    "  p =", round(ft$p.value, 3), "\n")

# If the CI includes 1.0, the association is not significant at alpha = 0.05


# ---- Q2: Interpret ----

# Template sentence:
# "Smokers had [OR] times the odds of hypertension compared to non-smokers
#  (95% CI: [lower]–[upper]; p = [value])."


# ============================================================
# Q3: Smoking → Diabetes (Adjusted for BMI + PhysActive)
# ============================================================

# ---- Q3: Summarize ----

# Diabetes prevalence by smoking status
mean(nhanes_clean$Diabetes[nhanes_clean$Smoker == 0])  # non-smokers
mean(nhanes_clean$Diabetes[nhanes_clean$Smoker == 1])  # smokers

# Mean BMI by diabetes status
mean(nhanes_clean$BMI[nhanes_clean$Diabetes == 0])
mean(nhanes_clean$BMI[nhanes_clean$Diabetes == 1])

# Physical activity by diabetes status
mean(nhanes_clean$PhysActive[nhanes_clean$Diabetes == 0])
mean(nhanes_clean$PhysActive[nhanes_clean$Diabetes == 1])


# ---- Q3: Visualize ----

par(mfrow = c(1, 2))

# Panel 1: Diabetes prevalence by smoking status
diab_props <- prop.table(
  table(nhanes_clean$Smoker, nhanes_clean$Diabetes),
  margin = 1)
barplot(diab_props[, 2] * 100,
        names.arg = c("Non-smoker", "Smoker"),
        ylim = c(0, 30),
        main = "Diabetes Prevalence\nby Smoking Status",
        ylab = "% with Diabetes",
        col  = c("lightblue", "salmon"), border = "white")

# Panel 2: BMI distribution by diabetes status
boxplot(BMI ~ Diabetes, data = nhanes_clean,
        names = c("No Diabetes", "Diabetes"),
        main  = "BMI by Diabetes Status",
        ylab  = "BMI (kg/m²)",
        col   = c("lightblue", "salmon"))

par(mfrow = c(1, 1))
# Both predictors appear associated with diabetes — need adjustment


# ---- Q3: Model ----

# THE OUTCOME IS BINARY: Diabetes = 0 or 1
# We model P(Diabetes = 1 | Smoker, BMI, PhysActive)
# Logistic regression keeps predicted probabilities in (0, 1)

fit_log <- glm(Diabetes ~ Smoker + BMI + PhysActive,
               data   = nhanes_clean,
               family = binomial)
summary(fit_log)

# Coefficients are on the log-odds scale — exponentiate to get ORs
exp(coef(fit_log))

# 95% CIs for ORs (profile likelihood)
exp(confint(fit_log))

# OR > 1 → associated with higher probability of diabetes
# OR < 1 → associated with lower probability (protective)
# CI excludes 1 → statistically significant at alpha = 0.05


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
abline(v = 1, lty = 2, col = "red", lwd = 1.5)
axis(2, at = seq_along(ors), labels = labs, las = 1)
text(ci_mat[, 2] + 0.02, seq_along(ors),
     labels = paste0("OR=", round(ors, 2)),
     pos = 4, cex = 0.8)


# ---- Q3: Interpret ----

cat("ORs:\n");   print(round(exp(coef(fit_log)), 3))
cat("95% CIs:\n"); print(round(exp(confint(fit_log)), 3))

# Template sentences:
# "After adjusting for BMI and physical activity, smoking was
#  [significantly/not significantly] associated with diabetes
#  (OR = [value], 95% CI: [lower]–[upper]; p = [value])."
#
# "Physically active participants had [OR] times the odds of diabetes
#  compared to inactive participants (95% CI: [lower]–[upper])."

# Predicted probabilities for specific profiles
predict(fit_log,
        newdata = data.frame(Smoker = 0, BMI = 25, PhysActive = 1),
        type    = "response")   # non-smoker, BMI = 25, active

predict(fit_log,
        newdata = data.frame(Smoker = 1, BMI = 35, PhysActive = 0),
        type    = "response")   # smoker, BMI = 35, inactive


# ============================================================
# BONUS: Model Comparison, Sensitivity / Specificity
# ============================================================

# ---- Bonus: Multiple Regression Model Comparison ----

fit_lm_simple <- lm(SBP ~ BMI, data = nhanes_clean)
fit_lm_multi  <- lm(SBP ~ BMI + Age + Sex, data = nhanes_clean)
fit_lm_full   <- lm(SBP ~ BMI + Age + Sex + Smoker, data = nhanes_clean)

anova(fit_lm_simple, fit_lm_multi)   # does adding Age + Sex help?
anova(fit_lm_multi,  fit_lm_full)    # does adding Smoker help further?

cat("R² (BMI only):             ", round(summary(fit_lm_simple)$r.squared, 3), "\n")
cat("R² (BMI + Age + Sex):      ", round(summary(fit_lm_multi)$r.squared,  3), "\n")
cat("R² (BMI + Age + Sex + Smoker):", round(summary(fit_lm_full)$r.squared, 3), "\n")


# ---- Bonus: Sensitivity and Specificity ----

pred_probs <- predict(fit_log, type = "response")
pred_class <- ifelse(pred_probs > 0.5, 1, 0)

conf_mat <- table(Actual    = nhanes_clean$Diabetes,
                  Predicted = pred_class)
conf_mat

TP <- conf_mat["1", "1"];  FN <- conf_mat["1", "0"]
FP <- conf_mat["0", "1"];  TN <- conf_mat["0", "0"]

cat("Sensitivity:", round(TP / (TP + FN), 3), "— true diabetics correctly identified\n")
cat("Specificity:", round(TN / (TN + FP), 3), "— true non-diabetics correctly identified\n")
cat("Accuracy:   ", round((TP + TN) / sum(conf_mat), 3), "\n")
