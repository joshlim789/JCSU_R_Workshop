# ============================================================
# Module 03 — Inferential Statistics 101
# Instructor Version
# Introduction to Statistics for Health Science
# ============================================================
#
# Audience : Undergraduate students, no prior R experience
# Duration : 60 minutes (1:00 PM – 2:00 PM)
# Dataset  : data/nhanes_sample.csv
#
# Sections:
#   1. Setup + Sampling Variability
#   2. Sampling Distributions and CLT
#   3. Standard Error and Confidence Intervals
#   4. Hypothesis Testing
#   5. Odds Ratios and 2x2 Tables
#   BONUS: Bootstrap CI, prop.test()
# ============================================================


# ---- Section 1: Setup + Sampling Variability ----
#
# Inferential statistics begins with a fundamental problem:
# we have ONE sample but want to say something about the POPULATION.
# The same research question studied on a different sample of 30 people
# would yield a different mean — this is sampling variability.

nhanes <- read.csv("../../data/nhanes_sample.csv",
                   header           = TRUE,
                   stringsAsFactors = FALSE)

dim(nhanes)
names(nhanes)

# Draw ONE random sample of 30 and compute mean SBP
mean(sample(nhanes$SBP, 30, replace = TRUE))

# Run it again — the answer changes every time
mean(sample(nhanes$SBP, 30, replace = TRUE))
mean(sample(nhanes$SBP, 30, replace = TRUE))

# replicate() automates running the same expression n times
replicate(5, mean(sample(nhanes$SBP, 30, replace = TRUE)))

# The "true" mean in our full dataset
mean(nhanes$SBP)


# ---- Section 2: Sampling Distributions and CLT ----
#
# The distribution of sample means across many hypothetical study repetitions
# is the SAMPLING DISTRIBUTION. The CLT tells us it approaches normal as n
# grows — this justifies using t-tests and CIs for health data.

set.seed(42)

sample_means <- replicate(1000,
                           mean(sample(nhanes$SBP, 30, replace = TRUE)))

length(sample_means)
summary(sample_means)

hist(sample_means,
     breaks = 35,
     col    = "steelblue",
     border = "white",
     main   = "Sampling Distribution of Mean SBP (1000 simulations, n=30)",
     xlab   = "Sample Mean SBP (mmHg)")

abline(v = mean(nhanes$SBP), col = "red", lwd = 2, lty = 2)

# Center and spread of the sampling distribution
mean(sample_means)         # should be close to the true mean
mean(nhanes$SBP)

sd(sample_means)           # empirical SE
sd(nhanes$SBP) / sqrt(30)  # theoretical SE — should match closely


# ---- Section 3: Standard Error and Confidence Intervals ----
#
# The SE quantifies how much a sample mean varies from sample to sample.
# A 95% CI gives a range of plausible values for the true population mean.
# Correct interpretation: if we repeated the study many times, 95% of
# intervals constructed this way would contain the true mean.

n_sbp  <- nrow(nhanes)
sd_sbp <- sd(nhanes$SBP)
SE_sbp <- sd_sbp / sqrt(n_sbp)
SE_sbp

# Manual 95% CI: mean ± 1.96 × SE
x_bar    <- mean(nhanes$SBP)
lower_95 <- x_bar - 1.96 * SE_sbp
upper_95 <- x_bar + 1.96 * SE_sbp
cat("Manual 95% CI: (", round(lower_95, 2), ",", round(upper_95, 2), ")\n")

# t.test() uses the t-distribution — slightly wider for small n,
# nearly identical to z-based CI for large n
t_result <- t.test(nhanes$SBP)
t_result$conf.int

# CIs for smokers vs. non-smokers — visualise as a dot-and-whisker plot
ci_nonsmoker <- t.test(nhanes$SBP[nhanes$Smoker == 0])$conf.int
ci_smoker    <- t.test(nhanes$SBP[nhanes$Smoker == 1])$conf.int
m_nonsmoker  <- mean(nhanes$SBP[nhanes$Smoker == 0])
m_smoker     <- mean(nhanes$SBP[nhanes$Smoker == 1])

ylim_range <- c(min(ci_nonsmoker[1], ci_smoker[1]) - 2,
                max(ci_nonsmoker[2], ci_smoker[2]) + 2)

plot(c(1, 2), c(m_nonsmoker, m_smoker),
     xlim = c(0.5, 2.5), ylim = ylim_range,
     pch = 16, cex = 1.5, col = c("steelblue", "salmon"),
     xaxt = "n",
     main = "Mean SBP with 95% CI by Smoking Status",
     ylab = "Systolic BP (mmHg)", xlab = "")
axis(1, at = c(1, 2), labels = c("Non-Smoker", "Smoker"))
arrows(1, ci_nonsmoker[1], 1, ci_nonsmoker[2],
       code = 3, angle = 90, length = 0.1, col = "steelblue", lwd = 2)
arrows(2, ci_smoker[1],    2, ci_smoker[2],
       code = 3, angle = 90, length = 0.1, col = "salmon",    lwd = 2)

# Narrower CI with more data
small_sample <- sample(nhanes$SBP, 30)
diff(t.test(small_sample)$conf.int)   # wide — small sample
diff(t.test(nhanes$SBP)$conf.int)     # narrow — full sample


# ---- Section 4: Hypothesis Testing ----
#
# H0: mean SBP is the same for smokers and non-smokers
# H1: mean SBP differs (two-sided)
#
# p-value = probability of seeing a difference this large IF H0 were true.
# It is NOT the probability H0 is true.

# Group means before testing
mean(nhanes$SBP[nhanes$Smoker == 0])
mean(nhanes$SBP[nhanes$Smoker == 1])

# Two-sample Welch t-test (does not assume equal variances)
t_result <- t.test(SBP ~ Smoker, data = nhanes, var.equal = FALSE)
t_result

t_result$statistic   # t-statistic
t_result$p.value     # p-value
t_result$conf.int    # 95% CI for the difference in means
t_result$estimate    # group means

# Formal decision
alpha <- 0.05
if (t_result$p.value < alpha) {
  cat("p =", round(t_result$p.value, 4), "< 0.05: Reject H0.\n")
} else {
  cat("p =", round(t_result$p.value, 4), ">= 0.05: Fail to reject H0.\n")
}

# Mean difference — is it clinically meaningful?
cat("Mean SBP difference:", round(abs(diff(t_result$estimate)), 2), "mmHg\n")


# ---- Section 5: Odds Ratios and 2x2 Tables ----
#
# When both exposure and outcome are binary, use a 2x2 contingency table.
# fisher.test() returns the OR, 95% CI, and exact p-value in one call.

nhanes$hypertensive <- ifelse(nhanes$SBP >= 140, 1, 0)
table(nhanes$hypertensive)
prop.table(table(nhanes$hypertensive))

# Build the 2x2 table
tab <- table(Smoker       = nhanes$Smoker,
             Hypertensive = nhanes$hypertensive)
tab
addmargins(tab)

# fisher.test(): OR, 95% CI, and exact p-value
ft <- fisher.test(tab)
ft

# Extract individual components
ft$estimate    # OR
ft$conf.int    # 95% CI
ft$p.value     # exact p-value

cat("OR =", round(ft$estimate, 2),
    "  95% CI: (", round(ft$conf.int[1], 2), ",", round(ft$conf.int[2], 2), ")",
    "  p =", round(ft$p.value, 3), "\n")

# Does the CI include 1? If yes, not significant at alpha = 0.05
ft$conf.int[1] > 1   # TRUE = lower bound above 1 = significant

# Chi-square for comparison — p-value only, no OR
chisq.test(tab)


# ============================================================
# BONUS: Bootstrap CI, prop.test()
# ============================================================

# ---- BONUS 1: Bootstrap CI ----
#
# Construct a CI by resampling — no formula needed.
# Reinforces the conceptual meaning of a CI.

set.seed(123)
boot_means <- replicate(10000,
               mean(sample(nhanes$SBP, size = nrow(nhanes), replace = TRUE)))

boot_CI <- quantile(boot_means, c(0.025, 0.975))
cat("Bootstrap 95% CI: ", round(boot_CI, 2), "\n")
cat("Parametric 95% CI:", round(t.test(nhanes$SBP)$conf.int, 2), "\n")


# ---- BONUS 2: prop.test() for comparing proportions ----
#
# Compare % hypertensive among smokers vs. non-smokers.
# prop.test() gives a CI for the difference in proportions.

n_smokers        <- sum(nhanes$Smoker == 1)
n_hyp_smokers    <- sum(nhanes$Smoker == 1 & nhanes$hypertensive == 1)
n_nonsmokers     <- sum(nhanes$Smoker == 0)
n_hyp_nonsmokers <- sum(nhanes$Smoker == 0 & nhanes$hypertensive == 1)

prop.test(x = c(n_hyp_smokers, n_hyp_nonsmokers),
          n = c(n_smokers,     n_nonsmokers))
