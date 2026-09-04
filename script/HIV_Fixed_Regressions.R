# Define your list of packages
my_packages <- c("tidyverse","readxl","tigris",
                 "sf","fixest")

# Load them all at once
lapply(my_packages, library, character.only = TRUE)

# Import and .csv file of HIV diagnosis in state and Covariates
hdiag <- read_csv("data/table_data.csv")
cov <- read_csv("data/Covariates_HIV.csv")

# Warning on Data: Due to the impact of the COVID-19 pandemic, 
# HIV diagnoses data for the year 2020 should be interpreted with caution.
data <- hdiag
head(data)

# Convert Data from Wide to Long
hiv_long <- data %>%
  pivot_longer(
    cols = `2017`:`2024`,
    names_to = "year",
    values_to = "diagnosis_rate"
  )

hiv_long <- hiv_long %>%
  mutate(year = as.numeric(year))
head(hiv_long)

# Change Format of cov
cov2 <- cov

colnames(cov2)
head(cov2)

# Rename Indicators
unique(cov2$Indicator)
cov2 <- cov2 %>%
  mutate(
    Indicator = case_when(
      Indicator == "Households living below the federal poverty level" ~ "poverty_rate",
      Indicator == "Population 25 years and older w/o HS diploma" ~ "low_education",
      Indicator == "Uninsured" ~ "uninsured_rate",
      Indicator == "Vacant housing" ~ "vacant_housing_rate",
      TRUE ~ Indicator
    )
  )

unique(cov2$Indicator)

cov_wide <- cov2 %>%
  pivot_wider(
    names_from = Indicator,
    values_from = Percent
  )

# Adjust Year Column to only have numbers
cov_wide <- cov_wide %>%
  mutate(
    Year = as.numeric(sub(" .*", "", Year))
  )

unique(cov_wide$Year)

unique(hiv_long$year)

# Temporarily: Remove 2024 data
hiv_data <- hiv_long %>%
  filter(year != 2024)

unique(hiv_data$year)

# Join HIV Data with Covariates
colnames(hiv_data)
colnames(cov_wide)

cov_wide <- cov_wide %>%
  rename(
    State = Geography
  )

hiv_data <- hiv_data %>%
  rename(Year = year)

colnames(cov_wide)

unique(cov_wide$State)

unique(hiv_data$State)

# Remove 'National' & Others from Dataset
hiv_data <- hiv_data %>%
  filter(!State %in% c("National","District of Columbia","Puerto Rico"))

cov_data <- cov_wide %>%
  filter(State != "District of Columbia")

unique(hiv_data$State)

colnames(cov_data)
colnames(hiv_data)

# Join Two Datasets
hiv_panel <- hiv_data %>%
  left_join(cov_data,
            by = c("State", "Year")

  )

unique(hiv_panel$State)

# Check for Nulls
colSums(is.na(hiv_panel)) #Zero Values with Nulls

# Correlation Matrices
library(corrplot)
library(Hmisc)

mydata <- hiv_panel[, c("poverty_rate",
                        "low_education",
                        "uninsured_rate",
                        "vacant_housing_rate")]
mydata <- mydata %>%
  rename("Poverty" = "poverty_rate",
         "Education" = "low_education",
         "Uninsured" = "uninsured_rate",
         "Vacant Housing" = "vacant_housing_rate")

res <- cor(mydata)
p.mat <- rcorr(as.matrix(mydata))$P
diag(p.mat) <- 0

corrplot(
  res, p.mat = p.mat, sig.level = 0.05, insig = "blank",
  diag = FALSE, tl.col = "black", tl.srt = 45,
  col = colorRampPalette(c("#b2182b", "white", "#3a86d4"))(200)
)


# Perform Fixed Effects Model with new dataset: hiv_panel
mydata <- hiv_panel[, c("diagnosis_rate",
                        "poverty_rate",
                        "low_education",
                        "uninsured_rate",
                        "vacant_housing_rate")]

# Model 1 — Cross-sectional/pool model
model <- feols(
  diagnosis_rate ~
    poverty_rate +
    low_education +
    uninsured_rate +
    vacant_housing_rate,
  data = hiv_panel
)

summary(model)

# Model_2 - State Fixed Effects (No Year)
model_2 <- feols(
  diagnosis_rate ~
    poverty_rate +
    low_education +
    uninsured_rate +
    vacant_housing_rate |
    State,
  data = hiv_panel,
  cluster = ~State
)

summary(model_2)

# Model_3 - Two Way Fixed Effects (State + Year)
model_3 <- feols(
  diagnosis_rate ~
    poverty_rate +
    low_education +
    uninsured_rate +
    vacant_housing_rate |
    State + Year,
  data = hiv_panel,
  cluster = ~State
)

summary(model_3)

# Table for All 3 Models - Part I
library(sjPlot)

tab_model(
  model, model_2, model_3,
  title = "<b>Table 1. Association between socioeconomic 
  indicators and HIV diagnosis rates</b>",
  CSS = list(css.caption = "text-align: center;",
             css.tdata = "padding: 15px 10px;",
             css.thead = "padding: 15px 10px"),
  dv.labels = c("Model 1: Cross Sectional", 
                "Model 2: State Fixed Effects", 
                "Model 3: State & Year Fixed Effects"),
  pred.labels = c(
    "(Intercept)" = "Baseline",
    "low_education" = "Education (without H.S. Diploma)",
    "uninsured_rate" = "Uninsured",
    "vacant_housing_rate" = "Vacant Housing",
    "poverty_rate" = "Poverty"
  ),
  file = "Table-1.doc"
)

# Diagnostics
model_2_clustered <- feols(
  diagnosis_rate ~
    poverty_rate +
    low_education +
    uninsured_rate +
    vacant_housing_rate,
  data = hiv_panel,
  cluster = ~State
)

summary(model_2_clustered)

# Models Part II: Remove Covariates, Poverty and Education, Separately

# 2A: No Poverty

model_2a <- feols(
  diagnosis_rate ~
    low_education +
    uninsured_rate +
    vacant_housing_rate |
  State,
  data = hiv_panel,
  cluster = ~State
)

summary(model_2a)

model_2b <- feols(
  diagnosis_rate ~
    poverty_rate +
    uninsured_rate +
    vacant_housing_rate |
    State,
  data = hiv_panel,
  cluster = ~State
)

summary(model_2b)

tab_model(
  model_2a, model_2b,
  title = "<b>Table 2. Sensitivity analysis: 
  Alternative State Fixed-Effects Specifications</b>",
  CSS = list(css.caption = "text-align: center;",
             css.tdata = "padding: 15px 10px;",
             css.thead = "padding: 15px 10px"),
  dv.labels = c( "Model 2a: Without Poverty", 
                "Model 2b: Without Education"),
  pred.labels = c(
    "(Intercept)" = "Baseline",
    "low_education" = "Education (without H.S. Diploma)",
    "uninsured_rate" = "Uninsured",
    "vacant_housing_rate" = "Vacant Housing",
    "poverty_rate" = "Poverty"
  ), 
  file = "Table-2.doc"
)


# Within-state poverty/education correlation
hiv_panel %>%
  group_by(State) %>%
  mutate(
    poverty_within = poverty_rate - mean(poverty_rate),
    education_within = low_education - mean(low_education)
  ) %>%
  ungroup() %>%
  summarise(
    within_correlation = cor(
      poverty_within,
      education_within,
      use = "complete.obs"
    )
  )

library(car)

# VIF Scores
vif(
  lm(
    diagnosis_rate ~
      poverty_rate +
      low_education +
      uninsured_rate +
      vacant_housing_rate,
    data = hiv_panel
  )
)

# Coefficient Plot as Alternative Table 1 
coefplot(
  list(model,
  model_2,
  model_3),
  dict = c(
    model = "Cross-sectional",
    model_2 ="State Fixed Effects",
    model_3 ="State + Year Fixed Effects",
    poverty_rate = "Poverty",
    low_education = "Education",
    uninsured_rate = "Uninsured",
    vacant_housing_rate = "Vacant housing"
  ),
  main = "Association Between Socioeconomic Indicators and HIV Diagnosis Rates",
  ref.line = 0,
  drop = "Constant"
)

# Legend for the Coefficient Plot
legend("topright", col = 1:3, pch = 20, lwd = 1, lty = 1:3,
       legend = c("Cross-Sectional", "State FE", "State + Year FE"),
       title = "Model")

#-------------------------------------------------------------------------------



