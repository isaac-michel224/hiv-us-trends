## README

# Examining State-Level HIV Diagnosis Rates and Socioeconomic Conditions in the United States, 2017–2023

## Executive Summary

HIV remains an important public health issue in the United States, despite substantial advances in HIV prevention, diagnosis, and treatment. HIV burden also varies considerably across geographic areas, with the South continuing to experience disproportionately high rates of HIV diagnoses. Understanding whether changes in state-level socioeconomic conditions are associated with changes in HIV diagnosis rates can help contextualize these geographic and temporal disparities.

This project examined HIV diagnosis rates across all 50 U.S. states from 2017 through 2023 using publicly available data from the Centers for Disease Control and Prevention (CDC) America's HIV Epidemic Analysis Dashboard (AHEAD). The analysis combined HIV diagnosis rates with four state-level socioeconomic indicators: poverty, low educational attainment, uninsured rates, and vacant housing. Descriptive visualizations were developed in R to examine geographic and temporal variation, followed by pooled ordinary least squares (OLS), state fixed-effects, and two-way fixed-effects models.

The results demonstrated that associations between socioeconomic conditions and HIV diagnosis rates depended substantially on the analytical specification. In pooled analyses, low educational attainment was positively associated with HIV diagnosis rates, while other associations were less consistent. After accounting for time-invariant state characteristics, low educational attainment remained positively associated with diagnosis rates and uninsured rates were negatively associated with diagnosis rates. However, after additionally accounting for year-specific effects, none of the four socioeconomic indicators was statistically associated with HIV diagnosis rates.

These findings suggest that cross-state differences in HIV diagnosis rates should not necessarily be interpreted as evidence that short-term changes in socioeconomic conditions drive changes in diagnosis rates. The results also demonstrate the importance of accounting for both state-specific and national temporal factors when analyzing longitudinal public health data.

---

## 1. Background

Approximately 1.2 million people in the United States are living with HIV. Although HIV prevention, testing, and treatment have improved considerably, the burden of HIV remains unevenly distributed geographically and across populations.

The U.S. South has consistently experienced a disproportionate share of HIV diagnoses and infections. In 2022, the South accounted for approximately 49% of new HIV infections among people aged 13 years and older, compared with approximately 23% in the West. These geographic differences raise important questions about the factors associated with variation in HIV burden across states.

The federal government has undertaken several major initiatives to reduce HIV transmission and improve diagnosis and treatment. In 2012, the U.S. Food and Drug Administration approved pre-exposure prophylaxis (PrEP) as an HIV prevention strategy. In 2019, the federal government launched Ending the HIV Epidemic in the United States (EHE), an initiative with a goal of reducing new HIV infections by 90% by 2030.

Socioeconomic conditions may play an important role in shaping health outcomes through access to healthcare, prevention services, testing, housing stability, and other structural factors. However, state-level relationships observed at a single point in time do not necessarily indicate that changes in socioeconomic conditions cause changes in HIV outcomes.

This project therefore examined both cross-state differences and changes within states over time.

### Research Questions

The analysis addressed three primary questions:

1. **Where is HIV diagnosis burden changing across the United States?**
2. **What changes in socioeconomic conditions are associated with those trends?**
3. **Do those associations persist when states are compared with themselves over time and national year-specific changes are accounted for?**

---

## 2. Data and Methods

### Data

The primary outcome was the **HIV diagnosis rate**, defined as the number of people receiving an HIV diagnosis per 100,000 population.

HIV data were obtained from the CDC's America's HIV Epidemic Analysis Dashboard (AHEAD). State-level socioeconomic data were obtained from publicly available CDC data containing measures of social and structural conditions.

The analysis included:

* Poverty rate: proportion of households living below the federal poverty level
* Low educational attainment: proportion of the population aged 25 years and older without a high school diploma
* Uninsured rate: proportion of the population without health insurance
* Vacant housing rate: proportion of housing units classified as vacant

The analytical dataset contained all 50 U.S. states over seven years, resulting in **350 state-year observations**. Puerto Rico, the District of Columbia, the U.S. Virgin Islands, and other U.S. territories and districts were excluded.

The regression analysis covered **2017–2023**.

### Data Preparation

The socioeconomic dataset was initially organized in long format, with socioeconomic indicators represented as individual values in an indicator column. The data were transformed so that each socioeconomic measure became its own variable before being merged with the HIV diagnosis dataset by state and year.

Variable names were standardized to facilitate analysis in R. The resulting analytical panel contained one observation for each state-year combination.

### Software

All data preparation, visualization, statistical analysis, and modeling were conducted using **R 4.6.1**, primarily within Posit Cloud.

Packages used included `ggplot2` for visualization and `fixest` for regression analysis.

---

## 3. Descriptive Analysis

The first stage of the analysis examined geographic and temporal variation in HIV diagnosis rates.

Choropleth maps were created to visualize state-level HIV diagnosis rates and changes in diagnosis rates across the study period. Horizontal bar charts were also used to rank states according to changes in diagnosis rates between 2017 and 2024 for descriptive purposes.

Longitudinal line charts were created for selected states to illustrate differences in HIV diagnosis trajectories over time. These visualizations demonstrated substantial variation across states, with some states experiencing larger changes in diagnosis rates than others.

The descriptive analysis established that HIV diagnosis burden is not geographically uniform and that changes over time differ considerably across states.

### Exploratory Associations

Scatterplots with linear trend lines were subsequently used to examine the bivariate relationship between HIV diagnosis rates and each socioeconomic indicator.

These exploratory analyses provided an initial assessment of whether states with different socioeconomic conditions tended to have different HIV diagnosis rates. However, these relationships were interpreted as descriptive associations rather than causal relationships because the bivariate models did not account for state-specific or time-specific factors.

---

## 4. Correlation and Multicollinearity Assessment

Because poverty and low educational attainment represent related dimensions of socioeconomic disadvantage, correlation between the explanatory variables was assessed before estimating the multivariable models.

Poverty and low educational attainment demonstrated the strongest pooled correlation:

**r = 0.774**

The correlations between poverty and uninsured rates and between low educational attainment and uninsured rates were weaker:

* Poverty and uninsured: **r = 0.408**
* Low education and uninsured: **r = 0.420**

Vacant housing demonstrated relatively weak correlations with the other socioeconomic indicators.

Although the pooled correlation between poverty and low educational attainment was relatively high, variance inflation factor (VIF) diagnostics ranged from **1.17 to 2.84**. These values did not indicate severe multicollinearity among the predictors.

Importantly, the within-state correlation between poverty and low educational attainment was lower than the pooled correlation:

**within-state r = 0.433**

This distinction is relevant because fixed-effects models estimate relationships using variation occurring within states over time rather than relying primarily on differences between states.

---

# 5. Regression Analysis

Three primary regression specifications were estimated.

### Model 1: Cross-sectional/Pooled OLS

The first model pooled all state-year observations without state or year fixed effects. This model captures both differences between states and changes occurring over time.

### Model 2: State Fixed Effects

The second model incorporated state fixed effects. This specification controls for time-invariant characteristics of states, allowing the analysis to focus on changes occurring within states over time.

### Model 3: State and Year Fixed Effects

The third model incorporated both state and year fixed effects. This specification controls for characteristics that are constant within states as well as year-specific factors common across states.

Standard errors were clustered at the state level in all models.

---

## 6. Regression Results

### Model 1: Cross-sectional/Pooled OLS

The pooled model showed a strong positive association between low educational attainment and HIV diagnosis rates.

The estimated coefficient for low educational attainment was approximately:

**β = 1.389, p < 0.001**

This indicates that, holding the other socioeconomic indicators constant, higher levels of low educational attainment were associated with higher HIV diagnosis rates in the pooled state-year data.

The uninsured coefficient was positive but was not statistically significant after clustering standard errors at the state level:

**β = 0.370, p = 0.118**

Poverty was also not statistically significant:

**β = 0.122, p = 0.756**

Vacant housing had a negative coefficient that approached, but did not reach, conventional statistical significance:

**β = −0.184, p = 0.053**

The pooled model therefore suggested substantial cross-sectional association between low educational attainment and HIV diagnosis rates, but these estimates could reflect persistent differences between states rather than changes occurring within states.

---

## 7. Model 2: State Fixed Effects

After controlling for time-invariant state characteristics, the estimated relationships changed substantially.

Low educational attainment remained positively associated with HIV diagnosis rates:

**β = 0.456, p = 0.051**

The coefficient was considerably smaller than the pooled estimate of 1.389.

The uninsured rate was negatively associated with HIV diagnosis rates:

**β = −0.444, p = 0.008**

Poverty was positive but not statistically significant:

**β = 0.260, p = 0.119**

Vacant housing was also not statistically significant:

**β = −0.092, p = 0.286**

The change in coefficient magnitude and direction between the pooled model and State FE model demonstrates the importance of accounting for persistent state-level differences.

---

## 8. Model 3: State and Year Fixed Effects

The final model incorporated both state and year fixed effects.

None of the four socioeconomic indicators was statistically associated with HIV diagnosis rates:

| Variable                   | Coefficient | p-value |
| -------------------------- | ----------: | ------: |
| Poverty rate               |      −0.259 |   0.188 |
| Low educational attainment |      −0.072 |   0.763 |
| Uninsured rate             |      −0.135 |   0.379 |
| Vacant housing rate        |       0.079 |   0.500 |

The model's overall adjusted R² was approximately **0.964**, reflecting the substantial explanatory contribution of the fixed effects.

However, the **within R² was only 0.022**. This indicates that the four socioeconomic covariates explained approximately 2.2% of the remaining within-state variation in HIV diagnosis rates after accounting for state and year fixed effects.

This distinction is important. The high overall R² should not be interpreted as evidence that the four socioeconomic variables explain 96% of the variation in HIV diagnosis rates. Much of the model's explanatory power comes from the state and year fixed effects.

The primary finding of the analysis is therefore that **the socioeconomic associations observed in less restrictive specifications did not persist after accounting for both state-specific and year-specific effects.**

---

# 9. Sensitivity Analysis

A sensitivity analysis was conducted because poverty and low educational attainment were strongly correlated in the pooled data.

Two alternative State FE models were estimated.

### Model 2a: State FE Without Poverty

When poverty was excluded, the coefficient for low educational attainment increased:

**β = 0.640, p = 0.005**

The uninsured rate remained negatively associated with HIV diagnosis rates:

**β = −0.485, p = 0.004**

Vacant housing remained statistically insignificant.

### Model 2b: State FE Without Low Educational Attainment

When low educational attainment was excluded, poverty became statistically significant:

**β = 0.443, p = 0.007**

The uninsured rate remained negative and statistically significant:

**β = −0.361, p = 0.025**

Vacant housing again remained statistically insignificant.

These sensitivity analyses suggest that the positive associations for poverty and low educational attainment in the State FE framework were influenced to some degree by their simultaneous inclusion in the model. However, the direction of their associations remained positive when the competing socioeconomic measure was removed.

The uninsured coefficient remained negative and statistically significant across both sensitivity specifications, suggesting greater robustness within the State FE framework.

Importantly, these associations did not remain statistically significant in the preferred State + Year FE model.

---

# 10. Discussion

This analysis provides three primary insights.

First, **HIV diagnosis rates vary substantially across U.S. states**. The descriptive maps and longitudinal visualizations demonstrate that HIV burden and changes in diagnosis rates are not geographically uniform.

Second, **the apparent relationship between socioeconomic conditions and HIV diagnosis rates depends substantially on the analytical approach**. Pooled analyses identified a strong association between low educational attainment and HIV diagnosis rates. After controlling for time-invariant state characteristics, the association became smaller, while the uninsured coefficient changed direction.

Third, **none of the four examined socioeconomic indicators remained statistically significant after both state and year fixed effects were included**. This suggests that some of the associations observed in pooled or State FE models may reflect persistent differences between states or broader changes occurring nationally over time.

The negative association between uninsured rates and HIV diagnosis rates in the State FE models warrants particular caution. A lower diagnosis rate in states with higher uninsured rates should not automatically be interpreted as evidence that insurance coverage increases HIV diagnoses or that being uninsured protects against HIV. Instead, the association may reflect differences in HIV testing, healthcare utilization, diagnosis access, reporting, or other factors. The attenuation of this association after year fixed effects were introduced further suggests that broader temporal changes may contribute to the observed relationship.

Similarly, the strong pooled association between low educational attainment and HIV diagnosis rates should not be interpreted as evidence that changes in educational attainment directly cause changes in HIV diagnosis rates. The substantially smaller coefficient in the State FE model and the disappearance of statistical significance in the two-way fixed-effects model illustrate the importance of distinguishing between cross-state differences and within-state changes.

---

# 11. Important Epidemiological Consideration: Diagnosis Is Not Incidence

An important limitation of this analysis is that the outcome is **HIV diagnosis rate rather than HIV incidence**.

A diagnosis rate reflects not only underlying HIV transmission but also the ability of individuals to access testing and healthcare services and the extent to which infections are detected and reported.

Consequently, a decline in HIV diagnosis rates could reflect:

* fewer new HIV infections,
* changes in HIV testing,
* changes in healthcare utilization,
* changes in access to diagnosis,
* changes in reporting practices, or
* some combination of these factors.

Therefore, the results should be interpreted as evidence concerning **patterns in HIV diagnosis rates**, rather than direct evidence concerning changes in HIV transmission.

---

# 12. Limitations

Several limitations should be considered.

**First, the analysis is observational.** The regression models identify associations rather than causal effects.

**Second, the analysis uses state-level aggregate data.** Relationships observed at the state level may not represent relationships at the individual or local level.

**Third, the analysis includes only four socioeconomic indicators.** Other factors—including healthcare access, race and ethnicity, urbanization, HIV testing, PrEP utilization, incarceration, and demographic characteristics—could contribute to differences in HIV diagnosis rates.

**Fourth, the panel contains seven years of observations per state.** Although fixed-effects methods are appropriate for longitudinal state-level analysis, the relatively short time dimension limits the ability to assess longer-term changes.

**Finally, HIV diagnosis rates should not be interpreted as equivalent to HIV incidence.** Changes in testing and detection can influence diagnosis rates independently of changes in transmission.

---

# 13. Conclusion

This project examined geographic variation and socioeconomic correlates of HIV diagnosis rates across the 50 U.S. states from 2017 through 2023.

Descriptive analyses demonstrated substantial geographic and temporal variation in HIV diagnosis rates. Pooled regression analyses suggested positive associations between low educational attainment and HIV diagnosis rates, while State FE models produced different estimates after accounting for persistent state characteristics.

However, when both state and year fixed effects were introduced, none of the four socioeconomic indicators—poverty, low educational attainment, uninsured rates, or vacant housing—was statistically associated with HIV diagnosis rates.

The findings highlight an important methodological lesson: **cross-state differences in HIV diagnosis rates should not automatically be interpreted as evidence that changes in socioeconomic conditions drive changes in HIV diagnosis rates.** Accounting for both persistent state characteristics and national year-specific changes substantially altered the observed associations.

More broadly, the project demonstrates the value of combining descriptive epidemiological visualization with panel-data methods to investigate public health disparities. Future analyses could extend this work by incorporating additional determinants of HIV diagnosis, examining demographic subgroups, incorporating measures of HIV testing and PrEP utilization, or exploring county-level variation within states.

---

# 14. References

America’s 250th: Reflecting on progress against HIV. HIV.gov. (2026, July 24). https://www.hiv.gov/blog/americas-250th-reflecting-on-progress-against-hiv 
Centers for Disease Control and Prevention. (n.d.). Fast facts: HIV in the United States. Centers for Disease Control and Prevention. https://www.cdc.gov/hiv/data-research/facts-stats/index.html 
Centers for Disease Control and Prevention. NCHHSTP AtlasPlus. https://www.cdc.gov/nchhstp/about/atlasplus.html. Accessed August 26, 2026
Copeland, C., Martins, R., Thaliffdeen, R., Kotsopoulos, N., Jarrett, J., Chaudhari, P., Mordi, U., & Postma, M. J. (2025). The HIV Epidemic in the United States - Epidemiological Projections and Public Economic Impact of Achieving Zero Transmission Goals. ClinicoEconomics and outcomes research : CEOR, 17, 755–769. https://doi.org/10.2147/CEOR.S565189
Grapevine, R. (2025, February 6). Georgia leads in U.S. HIV cases. here’s why the Lifesaving Drug Prep faces barriers in the State. Georgia Public Broadcasting. https://www.gpb.org/news/2025/02/06/georgia-leads-in-us-hiv-cases-heres-why-the-lifesaving-drug-prep-faces-barriers-in 
Harrist, A. (2018, April 6). Department of Health: Summary of reportable diseases 2017 Annual Report. Wyoming Department of Health. https://health.wyo.gov/wp-content/uploads/2018/05/2017-Annual-Report_Draft_V1.3_Combined.pdf 
Hendricks, S., Huynh, A., Burns, D. T., Pena, S., & Johnson, P. (2026). "Viral Suppression Among Rural and Urban People Living With HIV in Wyoming". AIDS research and treatment, 2026, 7353282. https://doi.org/10.1155/arat/7353282
HIV & AIDS trends and U.S. statistics overview. HIV.gov. (n.d.). https://www.hiv.gov/hiv-basics/overview/data-and-trends/statistics 
Purcell, D. J., Standifer, M., Martin, E., Rivera, M., & Hopkins, J. (2025). Disparities in HIV Care: A Rural-Urban Analysis of Healthcare Access and Treatment Adherence in Georgia. Healthcare (Basel, Switzerland), 13(12), 1374. https://doi.org/10.3390/healthcare13121374
U.S. Health and Human Services, (2019, August 18). America’s HIV Epidemic Analysis Dashboard (AHEAD). Retrieved August 21, 2026, from https://ahead.hiv.gov

