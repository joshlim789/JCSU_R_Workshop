# ============================================================
# Module 04 — Which Statistical Test?
# Instructor Version
# Introduction to Statistics for Health Science
# ============================================================
#
# Timing:   2:00 – 3:00 PM
# Audience: Undergraduate students, health science backgrounds
# Dataset:  data/nhanes_sample.csv
#
# Tests covered:
#   1. Two-sample t-test
#   2. One-way ANOVA + TukeyHSD post-hoc
#   3. Paired t-test
#   4. Chi-square test (+ Fisher's exact)
#   5. Simple linear regression (with diagnostics)
#   6. Logistic regression
#   7. Wilcoxon rank-sum (non-parametric)
#
# BONUS:
#   - Cohen's d (effect size for t-test)
#   - Multiple linear regression
#   - Model comparison with anova()
# ============================================================


# ---- Setup ----

nhanes <- read.csv("../../data/nhanes_sample.csv")

str(nhanes)
summary(nhanes)

# Derived variables used throughout the module
nhanes$hypertensive <- ifelse(nhanes$SBP >= 140, 1, 0)
nhanes$obese        <- ifelse(nhanes$BMI >= 30,  1, 0)

table(nhanes$hypertensive)
table(nhanes$obese)


# ---- Two-Sample t-Test ----

# Research question: Is mean SBP different between smokers and non-smokers?
# Outcome:   SBP (continuous)
# Predictor: Smoker (categorical, 2 independent groups)

# Visual check first: are the distributions roughly symmetric per group?
boxplot(SBP ~ Smoker, data = nhanes,
        names = c("Non-smoker", "Smoker"),
        main  = "SBP by Smoking Status",
        ylab  = "Systolic Blood Pressure (mmHg)",
        col   = c("lightblue", "salmon"))

table(nhanes$Smoker)   # sample sizes per group

# t.test() uses Welch's t-test by default — does not assume equal variances
result_t <- t.test(SBP ~ Smoker, data = nhanes)
result_t

# Key output:
#   t        — (mean_group0 - mean_group1) / SE; larger |t| → more evidence vs H0
#   p-value  — P(|T| >= observed t | H0 true); p < 0.05 → reject H0
#   95% CI   — interval for the difference in means; CI excludes 0 → significant
#   estimates — actual group means; always report alongside the p-value

result_t$statistic
result_t$p.value
result_t$conf.int
result_t$estimate


# ---- One-Way ANOVA ----

# Research question: Does mean SBP differ across racial/ethnic groups?
# Outcome:   SBP (continuous)
# Predictor: Race (categorical, 3+ groups)
#
# Why ANOVA and not multiple t-tests?
#   With k=5 groups there are 10 pairwise t-tests.
#   At alpha = 0.05 each, the chance of at least one false positive is ~40%.
#   ANOVA tests all groups simultaneously, controlling Type I error at 0.05.

boxplot(SBP ~ Race, data = nhanes,
        main = "SBP by Race/Ethnicity",
        ylab = "Systolic Blood Pressure (mmHg)",
        xlab = "",
        col  = "lightblue",
        las  = 2)

# Fit the one-way ANOVA
fit_aov <- aov(SBP ~ Race, data = nhanes)
summary(fit_aov)

# Key output:
#   F value — ratio of between-group variance to within-group variance
#   Pr(>F)  — p-value; significant → at least one group mean differs

# Post-hoc: TukeyHSD identifies WHICH pairs differ
# Adjusts p-values for all pairwise comparisons simultaneously
TukeyHSD(fit_aov)

# Key output per comparison row:
#   diff   — mean difference between the two groups
#   p adj  — p-value adjusted for multiple comparisons


# ---- Paired t-Test ----

# Research question: Did an exercise intervention reduce SBP after 8 weeks?
# Design: Before/after on the SAME 50 participants
# Equivalent to a one-sample t-test on differences d_i = post_i - pre_i
# H0: mu_d = 0

pre <- nhanes$SBP[1:50]
set.seed(42)
post <- pre - rnorm(50, mean = 5, sd = 8)   # simulate 5 mmHg average reduction

diffs <- post - pre
mean(diffs)
sd(diffs)

hist(diffs,
     main = "Distribution of SBP Changes (Post - Pre)",
     xlab = "Change in SBP (mmHg)",
     col  = "lightgreen")
abline(v = 0, col = "red", lty = 2)

# Correct: paired = TRUE accounts for within-person correlation
result_paired <- t.test(pre, post, paired = TRUE)
result_paired

# Wrong: unpaired test ignores pairing, loses statistical power
result_unpaired <- t.test(pre, post, paired = FALSE)

cat("Paired p-value:   ", result_paired$p.value,   "\n")
cat("Unpaired p-value: ", result_unpaired$p.value,  "\n")
# Paired gives smaller p-value — more powerful when data are truly paired


# ---- Chi-Square Test ----

# Research question: Is smoking associated with diabetes?
# Both variables are categorical — use a 2x2 contingency table

ct <- table(nhanes$Smoker, nhanes$Diabetes)
dimnames(ct) <- list(
  Smoker   = c("Non-smoker", "Smoker"),
  Diabetes = c("No Diabetes", "Diabetes")
)
ct
addmargins(ct)   # row and column totals

# Check expected cell counts — chi-square needs all expected counts >= 5
chisq.test(ct)$expected

result_chi <- chisq.test(ct)
result_chi

# Key output:
#   X-squared — sum of (O - E)^2 / E across all cells
#   df        — (rows - 1) * (cols - 1) = 1 for a 2x2 table
#   p-value   — evidence against independence of the two variables

# Fisher's exact test: valid at any sample size; also returns the OR + 95% CI
# chi-square only gives a p-value; fisher.test() gives everything
ft <- fisher.test(ct)
ft

ft$estimate   # Odds Ratio
ft$conf.int   # 95% CI for the OR
ft$p.value    # exact p-value

cat("OR =", round(ft$estimate, 2),
    "  95% CI: (", round(ft$conf.int[1], 2), ",", round(ft$conf.int[2], 2), ")",
    "  p =", round(ft$p.value, 3), "\n")

# Rule: if CI for OR includes 1.0, the association is not significant at alpha = 0.05


# ---- Simple Linear Regression ----

# Research question: How does BMI predict SBP?
# Outcome:   SBP (continuous)
# Predictor: BMI (continuous)
# Model:     SBP_i = beta0 + beta1 * BMI_i + epsilon_i

plot(nhanes$BMI, nhanes$SBP,
     main = "BMI vs Systolic Blood Pressure",
     xlab = "BMI (kg/m²)",
     ylab = "SBP (mmHg)",
     pch  = 16,
     col  = rgb(0, 0, 1, 0.4))

fit <- lm(SBP ~ BMI, data = nhanes)
abline(fit, col = "red", lwd = 2)

summary(fit)

# Key output:
#   Estimate (BMI)  — slope: mmHg change in SBP per 1 kg/m² increase in BMI
#   Pr(>|t|)        — p-value for H0: beta1 = 0 (no linear relationship)
#   R-squared       — proportion of SBP variance explained by BMI

coef(fit)
confint(fit)
summary(fit)$r.squared

# --- Check LINE assumptions with four diagnostic plots ---
# L = Linearity, I = Independence, N = Normality, E = Equal variance
par(mfrow = c(2, 2))
plot(fit)
par(mfrow = c(1, 1))

# Plot 1 — Residuals vs Fitted:  random scatter around 0 → linearity ok, equal variance ok
# Plot 2 — Normal Q-Q:           points on the diagonal → residuals approximately normal
# Plot 3 — Scale-Location:       flat horizontal band → constant variance (homoscedasticity)
# Plot 4 — Residuals vs Leverage: no points past Cook's distance → no influential outliers


# ---- Logistic Regression ----

# Research question: What factors predict hypertension?
#
# THE OUTCOME IS BINARY: hypertensive = 0 (no) or 1 (yes)
# We are modeling the PROBABILITY of being a "1":
#   P(hypertensive = 1 | BMI, Smoker)
#
# Why not linear regression on a 0/1 outcome?
#   It can produce predicted probabilities outside [0, 1] (e.g., -0.2 or 1.4).
# Logistic regression fixes this by modeling the log-odds:
#   log(p / (1-p)) = beta0 + beta1*BMI + beta2*Smoker
# This guarantees all predicted values stay in (0, 1).

fit_log <- glm(hypertensive ~ BMI + Smoker,
               data   = nhanes,
               family = binomial)

summary(fit_log)

# Coefficients are on the LOG-ODDS scale — exponentiate to get Odds Ratios
exp(coef(fit_log))

# 95% CIs for the ORs (profile likelihood — more accurate than Wald intervals)
exp(confint(fit_log))

# Interpreting ORs:
#   OR > 1 → predictor associated with higher probability of outcome = 1
#   OR = 1 → no association
#   OR < 1 → predictor associated with lower probability (protective)
#
#   Example: BMI OR = 1.08 → each 1 kg/m² increase in BMI is associated with
#            8% higher odds of being hypertensive
#   Example: Smoker OR = 1.40 → smokers have 40% higher odds of hypertension
#            than non-smokers, after adjusting for BMI

# Predicted probability of hypertension for specific profiles
predict(fit_log,
        newdata = data.frame(BMI = 25, Smoker = 0),
        type    = "response")   # non-smoker, BMI = 25

predict(fit_log,
        newdata = data.frame(BMI = 35, Smoker = 1),
        type    = "response")   # smoker, BMI = 35


# ---- Non-Parametric: Wilcoxon Rank-Sum Test ----

# When to use non-parametric tests instead of t-tests:
#   - Small samples (n < ~20 per group) and data look non-normal
#   - Severely skewed distributions (e.g., income, length of stay)
#   - Ordinal outcomes (pain scale 1–10, Likert items)
#   - Outliers that cannot be justified removing
# Trade-off: fewer assumptions, but less powerful when normality holds

# Wilcoxon rank-sum (Mann-Whitney U):
#   Non-parametric alternative to the two-sample t-test.
#   Ranks all observations, then tests whether rank sums differ between groups.
#   Does NOT require normality.

result_wilcox <- wilcox.test(SBP ~ Smoker, data = nhanes)
result_wilcox

# W: sum of ranks in one group; p-value tests whether distributions differ
cat("t-test p-value:       ", result_t$p.value,     "\n")
cat("Wilcoxon rank-sum p:  ", result_wilcox$p.value, "\n")
# When normality holds, t-test is slightly more powerful


# ============================================================
# BONUS: Cohen's d, Multiple Regression, Model Comparison
# ============================================================

# ---- Bonus: Cohen's d (Effect Size for t-Test) ----
# Statistical significance does not equal clinical importance.
# Cohen's d quantifies the size of the difference in standard deviation units.
# Benchmarks: 0.2 = small, 0.5 = medium, 0.8 = large

mean_nonsmoker <- mean(nhanes$SBP[nhanes$Smoker == 0])
mean_smoker    <- mean(nhanes$SBP[nhanes$Smoker == 1])
sd_nonsmoker   <- sd(nhanes$SBP[nhanes$Smoker == 0])
sd_smoker      <- sd(nhanes$SBP[nhanes$Smoker == 1])
n_nonsmoker    <- sum(nhanes$Smoker == 0)
n_smoker       <- sum(nhanes$Smoker == 1)

sd_pooled <- sqrt(((n_nonsmoker - 1) * sd_nonsmoker^2 +
                   (n_smoker    - 1) * sd_smoker^2) /
                  (n_nonsmoker + n_smoker - 2))

cohens_d <- (mean_smoker - mean_nonsmoker) / sd_pooled
cat("Cohen's d:", round(cohens_d, 3), "\n")


# ---- Bonus: Multiple Linear Regression ----
# Does smoking predict SBP after adjusting for BMI and Age?

fit_multi <- lm(SBP ~ BMI + Age + Smoker, data = nhanes)
summary(fit_multi)

# Each coefficient is adjusted for all other predictors in the model
cat("Simple R²:   ", round(summary(fit)$r.squared,       3), "\n")
cat("Multiple R²: ", round(summary(fit_multi)$r.squared, 3), "\n")


# ---- Bonus: Model Comparison with anova() ----
# Is the multivariable model (BMI + Age + Smoker) significantly better
# than the simple model (BMI only)?

anova(fit, fit_multi)
# F-statistic tests H0: added predictors have zero coefficients
# p < 0.05 → more complex model fits significantly better
