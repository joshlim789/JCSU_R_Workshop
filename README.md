# Workshop: Introduction to Statistics for Health Science Using R
## Claude Code Handoff — Master Brief

---

## Project Overview

Generate all materials for a **one-day undergraduate workshop** introducing
statistics and R for health science. Approximately 12 students, no prior R
experience assumed, some may have seen basic stats concepts before.

The deliverables are:
- **6 Quarto Beamer slide decks** (`.qmd` → PDF via LaTeX)
- **10 R scripts** (instructor + student version for each of the 5 coding modules)
- **1 shared `_quarto.yml`** with Beamer theme config
- **Data folder** with NHANES subset (see Data section below)

---

## File Tree

```
workshop/
├── README.md
├── _quarto.yml
├── data/
│   ├── nhanes_sample.csv
│   └── case_study_data.csv          # Can be same NHANES subset, renamed
├── slides/
│   ├── 00_intro/
│   │   └── 00_intro.qmd
│   ├── 01_descriptive_stats/
│   │   └── 01_descriptive_stats.qmd
│   ├── 02_data_science_primer/
│   │   └── 02_data_science_primer.qmd
│   ├── 03_inferential_stats/
│   │   └── 03_inferential_stats.qmd
│   ├── 04_which_test/
│   │   └── 04_which_test.qmd
│   └── 05_case_study/
│       └── 05_case_study.qmd
└── scripts/
    ├── 01_descriptive_stats_instructor.R
    ├── 01_descriptive_stats_student.R
    ├── 02_data_science_primer_instructor.R
    ├── 02_data_science_primer_student.R
    ├── 03_inferential_stats_instructor.R
    ├── 03_inferential_stats_student.R
    ├── 04_which_test_instructor.R
    ├── 04_which_test_student.R
    ├── 05_case_study_instructor.R
    └── 05_case_study_student.R
```

---

## _quarto.yml

Use a clean academic Beamer theme. No institutional branding.

```yaml
project:
  type: book

format:
  beamer:
    theme: Madrid
    colortheme: default
    fonttheme: structurebold
    fontsize: 11pt
    aspectratio: 169
    header-includes: |
      \setbeamercolor{frametitle}{bg=darkblue, fg=white}
      \setbeamercolor{title}{fg=darkblue}
      \setbeamercolor{block title}{bg=darkblue, fg=white}
      \definecolor{darkblue}{RGB}{0, 51, 102}
      \setbeamerfont{frametitle}{size=\large}
      \setbeamertemplate{footline}[frame number]
      \setbeamertemplate{navigation symbols}{}

execute:
  echo: true
  warning: false
  message: false
```

Each `.qmd` should include at the top:

```yaml
---
title: "Module Title"
subtitle: "Introduction to Statistics for Health Science"
author: "Workshop Instructor"
date: today
format: beamer
---
```

---

## Data

Use a **subset of NHANES** (National Health and Nutrition Examination Survey).
Either pull from the `NHANES` R package (`library(NHANES)`) or simulate a
realistic CSV. The dataset used throughout should contain these variables:

| Variable       | Type        | Description                              |
|----------------|-------------|------------------------------------------|
| `ID`           | integer     | Participant ID                           |
| `Age`          | integer     | Age in years                             |
| `Sex`          | character   | "Male" / "Female"                        |
| `Race`         | character   | Race/ethnicity category                  |
| `BMI`          | numeric     | Body mass index                          |
| `SBP`          | numeric     | Systolic blood pressure (mmHg)           |
| `DBP`          | numeric     | Diastolic blood pressure (mmHg)          |
| `Smoker`       | integer     | 1 = current smoker, 0 = non-smoker       |
| `Diabetes`     | integer     | 1 = diabetic, 0 = not                   |
| `PhysActive`   | integer     | 1 = physically active, 0 = not          |
| `Chol`         | numeric     | Total cholesterol (mg/dL)                |
| `Income`       | character   | Income bracket                           |

Save as `data/nhanes_sample.csv`. All scripts load data with:

```r
nhanes <- read.csv("../data/nhanes_sample.csv")
```

---

## Code Style Conventions

- **Base R throughout** — no tidyverse. Use `read.csv()`, `subset()`, `$`,
  `[`, `hist()`, `boxplot()`, `plot()`, `tapply()`, `table()`, `lm()`,
  `glm()`, `t.test()`, `chisq.test()`, `wilcox.test()`.
- **Pipe**: do not use `|>` or `%>%` — write step-by-step for clarity.
- **Comments**: every meaningful line commented, written as if the student
  is reading the script cold.
- **Section headers** in scripts using `# ---- Section Name ----` style.
- **No package dependencies** beyond base R and `epitools` (for odds ratios).
  If `epitools` is used, include `install.packages("epitools")` commented
  at the top.

---

## Script Conventions

### Instructor version (`_instructor.R`)
- Fully complete, heavily commented.
- Each section begins with a comment block explaining the concept before
  the code (2–4 lines of plain English).
- Includes "extension" or "bonus" code at the bottom of each section,
  clearly marked, for students who finish early.

### Student version (`_student.R`)
- **First 1–2 sections have light scaffolding**: function names and
  argument names are provided, students fill in the values.
  Example:
  ```r
  # Calculate the mean of BMI
  mean(___)
  
  # Create a histogram of systolic blood pressure
  hist(___, main = "___", xlab = "___")
  ```
- **All subsequent sections are blank**: only comment headers and
  plain-English instructions remain. No code at all.
  Example:
  ```r
  # ---- Boxplot by smoking status ----
  # Create a side-by-side boxplot comparing SBP between smokers and non-smokers.
  # Use boxplot(). Color the boxes using col=.
  
  
  
  ```
- Student scripts should feel like a guided worksheet that progressively
  removes scaffolding.

---

## Slide Conventions

- **Build concepts progressively** across slides — don't show everything
  at once. Use Beamer `\pause` or incremental reveals where appropriate.
- **One idea per slide** as a target. Dense slides are acceptable for
  reference tables only.
- **Every concept slide should be followed by a code/output slide**
  showing the base R implementation.
- **Real health-science framing** throughout — always anchor examples to
  a plausible research question (e.g., "Is BMI associated with
  hypertension?", "Do smokers have higher systolic blood pressure?").
- **Slide count targets** are listed per module below.
- Use `echo: true` in code chunks so students see the code.
- Use `#| fig-height` and `#| fig-width` to keep plots readable on slides.

---

## Module Specifications

---

### Module 00 — Introduction & Overview
**File:** `slides/00_intro/00_intro.qmd`
**Time:** 9:30–10:00am (30 min)
**No R script** — conceptual only.
**Target:** ~12 slides

**Slide outline:**

1. Title slide — workshop name, date, instructor
2. Logistics — wifi, bathrooms, schedule overview, "this is a follow-along
   workshop"
3. Who is this for? — no stats background assumed; health science context
4. Motivating question — "How do we know a drug works?" or "Is smoking
   really bad for your heart?" Lead with a real claim from the literature.
5. The data analysis pipeline — visual: Question → Data → Analysis →
   Interpretation → Communication (draw as a cycle or linear flow)
6. What is R? What is RStudio? — one slide, screenshot or diagram of the
   4-pane layout. No code yet.
7. Why R for health science? — brief: reproducibility, free, used in
   bioinformatics/epi/clinical research
8. What we'll cover today — visual roadmap of the 5 modules with times
9. Introducing our dataset — one slide showing what NHANES is, who
   collected it, what questions it can answer
10. A first look at the data — show the first 6 rows with `head()`,
    minimal explanation, just to make it feel real
11. Ground rules — ask questions, it's okay to be wrong, follow along at
    your own pace
12. Let's go — transition slide

---

### Module 01 — Descriptive Statistics 101
**File:** `slides/01_descriptive_stats/01_descriptive_stats.qmd`
**Scripts:** `scripts/01_descriptive_stats_instructor.R`,
             `scripts/01_descriptive_stats_student.R`
**Time:** 10:00–11:00am (60 min)
**Target:** ~22 slides

**Slide outline:**

*Part A — What is a statistic?*
1. Population vs. sample — define both with a health example. We want to
   know something about all adults in the US; we can only measure some.
2. What is a statistic? — a number that summarizes a sample. The goal is
   to use it to learn about the population.

*Part B — Measures of central tendency*
3. The mean — formula, intuition, base R: `mean(nhanes$BMI)`
4. The median — intuition, resistant to outliers, `median()`
5. The mode — brief, `table()` trick for categorical data
6. Mean vs. median — when does it matter? Skewed health data example
   (income, hospital costs). Show a skewed histogram.

*Part C — Measures of spread*
7. Why spread matters — two patients with same mean BP but very different
   variability; clinical implications
8. Variance and standard deviation — formula intuition (average distance
   from mean), `var()`, `sd()`
9. IQR and range — `IQR()`, `range()`, `quantile()`
10. The five-number summary — `summary()` on a numeric column; walk
    through each number

*Part D — Data types*
11. Data types overview — table: categorical (nominal, ordinal) vs.
    numeric (continuous, discrete). Give NHANES examples of each.
12. Binary variables — 0/1 coding, why they matter in health research
    (case/control, smoker/non-smoker). `table()` to summarize.
13. Choosing the right summary stat — matching stat to data type (table
    slide for reference)

*Part E — Bivariate data and intro to regression*
14. What is a relationship between two variables? — scatter plot of
    BMI vs. SBP as motivating example
15. Correlation — direction, strength, `cor()`. Emphasize: correlation
    is not causation.
16. Introducing regression — "the line that summarizes a trend."
    `lm(SBP ~ BMI, data = nhanes)`, show the line on the scatter plot.
17. Interpreting slope and intercept — plain English: "for each 1-unit
    increase in BMI, SBP increases by ___ mmHg on average"

*Part F — Appropriate graphics*
18. Histogram — one continuous variable, shape/skew/outliers.
    `hist(nhanes$BMI)`
19. Boxplot — comparing groups. `boxplot(SBP ~ Smoker, data = nhanes)`
20. Scatter plot — two continuous variables. `plot(nhanes$BMI, nhanes$SBP)`
21. Bar chart — categorical summary. `barplot(table(nhanes$Sex))`
22. "Which plot?" — decision guide table/flowchart slide. Reference slide
    students can return to.

---

### Module 02 — Data Science Primer
**File:** `slides/02_data_science_primer/02_data_science_primer.qmd`
**Scripts:** `scripts/02_data_science_primer_instructor.R`,
             `scripts/02_data_science_primer_student.R`
**Time:** 11:00am–12:00pm (60 min)
**Target:** ~20 slides

**Slide outline:**

*Part A — Where does health data come from?*
1. Sources of health data — EHR, surveys (NHANES), clinical trials,
   registries, wearables. One slide, brief.
2. Tidy data — rows = observations, columns = variables. Show a tidy
   vs. messy table side by side.

*Part B — Reading data in*
3. `read.csv()` — syntax, the `header = TRUE` argument, relative paths.
   Load the NHANES dataset live.
4. First look functions — `head()`, `tail()`, `nrow()`, `ncol()`,
   `dim()`, `names()`. Run all on NHANES and show output.
5. `str()` — structure of the data frame. Emphasize data types: `int`,
   `num`, `chr`. Connect back to Module 01 data types.
6. Common import pitfalls — NAs coded as -999 or blank, strings read as
   factors, date formats. Show `is.na()` and `sum(is.na(...))`.

*Part C — Subsetting and summarizing*
7. Accessing columns — `nhanes$BMI`, `nhanes[, "BMI"]`
8. Subsetting rows — `subset()` with a condition.
   `subset(nhanes, Smoker == 1)`. Show the result.
9. Creating new variables — `nhanes$obese <- ifelse(nhanes$BMI >= 30, 1, 0)`.
   Health example: categorizing BMI.
10. `summary()` on the whole data frame — show what it produces. Useful
    for a quick audit.
11. `table()` for categorical variables — one-way and two-way tables.
    `table(nhanes$Sex, nhanes$Smoker)`.
12. `tapply()` for grouped summaries — mean SBP by smoking status.
    The base R equivalent of group_by + summarize.

*Part D — Base R graphics*
13. Grammar of a base R plot — `plot()` arguments: `main`, `xlab`,
    `ylab`, `col`, `pch`. Show the anatomy.
14. Histogram walkthrough — `hist()` with `breaks`, `col`, `main`,
    `xlab`. Build it up argument by argument across 1–2 slides.
15. Boxplot walkthrough — `boxplot()` with group formula notation,
    `col`, `names`, `main`. Side-by-side comparison by group.
16. Scatter plot walkthrough — `plot()` with `abline()` to add a
    regression line. Connect to Module 01 regression intro.
17. `par(mfrow = c(1,2))` — putting two plots side by side. Show a
    before/after or two-group comparison.
18. Saving plots — `pdf()` / `png()` + `dev.off()` pattern. Why this
    matters for reproducibility.
19. Base R vs. ggplot2 — one honest comparison slide. Both exist; this
    workshop uses base R because it requires no packages; ggplot2 is
    widely used in research and worth learning next.
20. Recap + transition — what we can now do; preview of afternoon.

---

### Module 03 — Inferential Statistics 101
**File:** `slides/03_inferential_stats/03_inferential_stats.qmd`
**Scripts:** `scripts/03_inferential_stats_instructor.R`,
             `scripts/03_inferential_stats_student.R`
**Time:** 1:00–2:00pm (60 min)
**Target:** ~22 slides

**Slide outline:**

*Part A — Why inference?*
1. The core problem — we have a sample; we want to say something about
   the population. Descriptive stats describe the sample. Inferential
   stats make claims about the population.
2. Sampling variability — run the same study twice, get different numbers.
   Demonstrate: `replicate(5, mean(sample(nhanes$SBP, 30)))`. Each call
   gives a different value. That variation IS the problem inference solves.

*Part B — Sampling distributions*
3. What is a sampling distribution? — the distribution of a statistic
   (e.g., the sample mean) across many hypothetical samples.
4. CLT intuition — as sample size grows, the sampling distribution of
   the mean becomes normal regardless of the original distribution.
   Demonstrate with a simulation: `replicate(1000, mean(sample(...)))`,
   then `hist()` the results.
5. Standard error — the SD of the sampling distribution. Formula:
   `SE = sd / sqrt(n)`. Show calculation in R.

*Part C — Confidence intervals*
6. What is a CI? — a range of plausible values for the population
   parameter. The "fishing net" analogy: we don't know where the fish is,
   but we know the net captures it 95% of the time.
7. Constructing a 95% CI for a mean — formula: mean ± 1.96 × SE.
   Calculate manually in R, then with `t.test()$conf.int`.
8. Interpreting CIs — what "95% confident" actually means (if we repeated
   the study 100 times, ~95 of those intervals would contain the true
   mean). Common misconception: it does NOT mean 95% probability the
   true value is in this interval.
9. Visualizing CIs — `plotCI` style using `arrows()` in base R, or a
   simple `plot()` with error bars. Show CIs for mean SBP by group.
10. Wider vs. narrower CIs — what drives width? Sample size and
    variability. Show numerically.

*Part D — Hypothesis testing*
11. The logic — we assume nothing is happening (null hypothesis), then
    ask: how surprised would we be by our data if that were true?
12. Null vs. alternative hypothesis — H₀ and H₁. Health examples:
    "smokers and non-smokers have the same mean SBP" vs. "they differ."
13. The p-value — probability of observing data as extreme as ours
    assuming H₀ is true. NOT the probability H₀ is true.
14. Interpreting p-values — thresholds (α = 0.05), what significance
    means and does not mean. Common misinterpretations.
15. Type I and Type II error — false positive / false negative. 2×2
    table of: decision (reject/fail to reject) × truth (H₀ true/false).
    Connect to clinical stakes: a false positive drug approval vs. a
    missed treatment.
16. Statistical vs. clinical significance — a result can be statistically
    significant but clinically meaningless (e.g., a drug lowers SBP by
    0.5 mmHg, p < 0.001). Emphasize this distinction for health research.

*Part E — Odds ratios and 2×2 tables*
17. Risk vs. odds — define both with a concrete example. If 20/100
    patients develop disease: risk = 0.20, odds = 20/80 = 0.25.
18. The 2×2 table — exposure (rows) × outcome (columns). Label cells a,
    b, c, d. Health example: smoking × hypertension.
19. Calculating OR — formula: (a×d) / (b×c). Calculate by hand first,
    then in R with `epitools::oddsratio()` or manual calculation.
20. Interpreting OR — OR > 1: exposure associated with higher odds of
    outcome. OR = 1: no association. OR < 1: protective.
21. CI around an OR — why we need it; an OR of 2.5 means little without
    knowing if the CI includes 1.
22. Full worked example — smoking and hypertension from NHANES. Build the
    2×2 table with `table()`, calculate OR manually, interpret in plain
    English.

---

### Module 04 — Which Test?
**File:** `slides/04_which_test/04_which_test.qmd`
**Scripts:** `scripts/04_which_test_instructor.R`,
             `scripts/04_which_test_student.R`
**Time:** 2:00–3:00pm (60 min)
**Target:** ~22 slides

**Slide outline:**

1. The big question — "What does my research question actually ask?"
   Three things determine the test: outcome type, predictor type, study
   design.
2. Decision flowchart — visual: is the outcome continuous or binary? Is
   the predictor categorical or continuous? Are observations independent
   or paired? Routes lead to the correct test.
3. Overview table — all tests covered today, one row each: name,
   outcome type, predictor type, R function. Reference slide.

*Two-sample t-test*
4. Concept — comparing means between two independent groups. Research
   question: "Is mean SBP different between smokers and non-smokers?"
   Assumptions: normality (or large n), independence.
5. R implementation — `t.test(SBP ~ Smoker, data = nhanes)`. Walk
   through output: t-statistic, df, p-value, CI, group means.

*Paired t-test*
6. Concept — before/after, matched pairs. Research question: "Did a
   8-week exercise intervention lower SBP?" Each person is their own
   control. Key distinction from two-sample.
7. R implementation — `t.test(pre, post, paired = TRUE)`. Simulate
   paired data if needed. Show the difference in output from unpaired.

*Chi-square test*
8. Concept — two categorical variables. Research question: "Is smoking
   status associated with diabetes?" No continuous outcomes.
   Assumptions: expected cell counts ≥ 5.
9. R implementation — `table()` to build the contingency table, then
   `chisq.test()`. Walk through output. Connect to the 2×2 table from
   Module 03.

*Simple linear regression*
10. Concept — continuous outcome, continuous predictor. Research question:
    "How does BMI predict systolic blood pressure?" Assumptions: linearity,
    normality of residuals, constant variance.
11. R implementation — `lm(SBP ~ BMI, data = nhanes)`, `summary(lm(...))`.
    Walk through: coefficients, SE, t-value, p-value, R².
12. Checking assumptions — `plot(lm(...))` produces 4 diagnostic plots.
    Briefly show residuals vs. fitted and Q-Q plot.

*Logistic regression*
13. Concept — binary outcome (0/1). Research question: "What factors
    predict hypertension (yes/no)?" Why not linear regression for binary
    outcomes (predicted probabilities outside 0–1).
14. The logistic model — predict log-odds, convert to probability via
    sigmoid. Keep the math light; focus on interpretation.
15. R implementation — `glm(Diabetes ~ BMI + Smoker, data = nhanes,
    family = binomial)`, `summary()`, `exp(coef(...))` for ORs.
16. Interpreting logistic output — coefficients are log-odds; exponentiate
    for ORs. Connect back to Module 03 OR interpretation.

*Non-parametric equivalents*
17. When to go non-parametric — small samples, severe non-normality,
    ordinal outcomes. These tests make fewer assumptions.
18. Wilcoxon rank-sum (Mann-Whitney) — non-parametric alternative to
    two-sample t-test. Compares ranks, not means.
    `wilcox.test(SBP ~ Smoker, data = nhanes)`.
19. Wilcoxon signed-rank — non-parametric paired t-test.
    `wilcox.test(pre, post, paired = TRUE)`.
20. Kruskal-Wallis — non-parametric ANOVA for 3+ groups.
    `kruskal.test(SBP ~ Race, data = nhanes)`.

*Wrapping up*
21. Assumptions matter — brief checklist for each test covered. When
    assumptions are violated, results can mislead.
22. Effect size, not just p-values — Cohen's d, R², OR as effect
    measures. A p-value tells you significance; effect size tells you
    magnitude. Both matter in health research.

---

### Module 05 — Case Study: Putting It All Together
**File:** `slides/05_case_study/05_case_study.qmd`
**Scripts:** `scripts/05_case_study_instructor.R`,
             `scripts/05_case_study_student.R`
**Time:** 3:00–4:00pm (60 min)
**Target:** ~18 slides

This module is a **capstone live-coding session**. The instructor walks
through a complete analysis from raw data to interpreted results. Students
follow along in their own script.

**Research questions for the case study:**
1. Are BMI and systolic blood pressure associated?
2. Is smoking status associated with hypertension?
3. After adjusting for BMI and physical activity, is smoking independently
   associated with diabetes?

**Slide outline:**

1. Introducing the dataset — brief reminder of NHANES; show `str()` and
   `summary()` output.
2. Our research questions — list the three questions above. Emphasize:
   we start with the question, not the method.
3. Step 1: Data cleaning — handle NAs (`complete.cases()` or
   `na.omit()`), check variable coding, create derived variables
   (e.g., `hypertensive <- ifelse(nhanes$SBP >= 140, 1, 0)`).
4. Step 2: Table 1 (Descriptive Statistics) — summarize the sample.
   Mean/SD for continuous vars, n(%) for categorical. Do this manually
   with `tapply()` and `table()`. This is what Table 1 looks like in a
   health science paper.
5. Step 3: Exploratory visualization — histogram of SBP, boxplot of SBP
   by smoking status, scatter of BMI vs. SBP. Narrate what we see.
6. Step 4: Choose the test — walk through the decision framework for
   each research question. Students call out answers.
7. Step 5a: Linear regression (Q1) — `lm(SBP ~ BMI, data = nhanes)`.
   Interpret coefficients, check R², show the regression line on scatter.
8. Step 5b: Chi-square + OR (Q2) — build the 2×2 table: hypertensive ×
   smoker. `chisq.test()`, then manual OR calculation and interpretation.
9. Step 5c: Logistic regression (Q3) — `glm(Diabetes ~ Smoker + BMI +
   PhysActive, data = nhanes, family = binomial)`. Exponentiate
   coefficients for ORs. Interpret each predictor.
10. Step 6: Assumption checking — `plot(lm(...))` for linear model,
    discuss any issues visually.
11. Step 7: Visualizing results — coefficient plot for logistic model
    using base R `plot()` with `arrows()` for CIs. What a "forest plot"
    is and why it's used.
12. Step 8: Interpreting findings — write one sentence per result, in
    plain English. "Smokers had 2.1 times the odds of diabetes compared
    to non-smokers (OR = 2.1, 95% CI: 1.4–3.2), adjusting for BMI and
    physical activity."
13. Step 9: What can't we conclude? — causation vs. association,
    confounding, study design limitations. Critical thinking moment.
14. Step 10: Drafting a results paragraph — show a template. Give
    students 5 minutes to write one sentence about any finding. Share out.
15. Common mistakes recap — top 5: confusing p-value with effect size,
    not checking assumptions, dropping NAs without thought, reporting
    unstandardized results, implying causation.
16. Where to go next — R for Data Science (r4ds.hadley.nz), OpenIntro
    Statistics (free), Coursera/edX biostatistics courses, asking your
    advisor/collaborator for a stats consult.
17. Q&A slide — open floor.
18. Thank you + certificate/resources slide — list any handouts,
    GitHub link for scripts, contact info.

---

## Reference

- STA 199 Spring 2026 (Duke, Mine Çetinkaya-Rundel group):
  https://sta199-s26.github.io
  Use as pacing/structure reference only. Do not copy datasets or text.
  Borrow the "build concept progressively across slides" technique.
- NHANES documentation: https://www.cdc.gov/nchs/nhanes/
- Base R reference: https://cran.r-project.org/doc/manuals/R-intro.html
