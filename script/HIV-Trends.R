# Define your list of packages
my_packages <- c("tidyverse","readxl","tigris","sf","gganimate","gifski")

# Load them all at once
lapply(my_packages, library, character.only = TRUE)

#Import and .csv file of HIV diagnosis in state
hdiag <- read_csv("data/table_data.csv")
#Warning on Data: Due to the impact of the COVID-19 pandemic, HIV diagnoses data for the year 2020 should be interpreted with caution.

#Insert Calculations into the Dataset
#Rate of Change
hdiag <- hdiag %>%
  mutate(absolute_change = `2024` - `2017`)
view(hdiag)

#Percent change
hdiag <- hdiag %>%
  mutate(percent_change = (`2024` - `2017`)/(`2017`)*(100))
view(hdiag)

#Create a Line Chart of HIV diagnosis rate, 2017 - 2024
head(hdiag)
#Convert Data from Wide to Long
hiv_long <- hdiag %>%
  pivot_longer(
    cols = `2017`:`2024`,
    names_to = "year",
    values_to = "diagnosis_rate"
  )
hiv_long <- hiv_long %>%
  mutate(year = as.numeric(year))
head(hiv_long)

#Line Chart for the National HIV Diagnosis Rate
ggplot(
  hiv_long %>% filter(State == "National"),
  aes(x = year, y = diagnosis_rate)
) +
  geom_line() +
  geom_point() +
  coord_cartesian(ylim = c(0, 40)) +
  labs(
    title = "National HIV Diagnosis Rate, 2017-2024",
    x = "Year",
    y = "Diagnosis rate per 100,000"
  ) + 
  theme_minimal()

#Line Chart for National vs. Certain States

#Specify States to Visualize on Plot
selected_states <- hiv_long %>%
  filter(State %in% c("National", "Vermont", 
                      "Georgia", 
                      "Florida",
                      "Wyoming"
                      ))

#Create Multi-Line Visualization
ggplot(
  selected_states,
  aes(x = year, y = diagnosis_rate, color = State)
) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  scale_color_manual(
    values = c(
      "Wyoming" = "blue",
      "Georgia" = "red",
      "Florida" = "darkgreen",
      "Vermont" = "orange",
      "National" = "darkgrey"
    )
  ) +
  coord_cartesian(ylim = c(0, 40)) +
  labs(
    title = "National HIV Diagnosis Rate, 2017-2024",
    x = "Year",
    y = "Diagnosis rate per 100,000"
  ) + 
  theme_minimal(base_family = "Corbel") + 
  theme(plot.title = element_text(hjust = 0.5))

#Animate It

p <- ggplot(
  selected_states,
  aes(x = year, 
      y = diagnosis_rate, 
      color = State, 
      group = State
      )
) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  scale_color_manual(
    values = c(
      "Wyoming" = "blue",
      "Georgia" = "red",
      "Florida" = "darkgreen",
      "Vermont" = "orange",
      "National" = "darkgrey"
    )
  ) +
  coord_cartesian(ylim = c(0, 40)) +
  labs(
    title = "HIV Diagnosis Rates in Selected States",
    subtitle = "Year: {frame_along}",
    x = "Year",
    y = "Diagnosis rate per 100,000",
    color = "State"
  ) + 
  theme_minimal(base_family = "Corbel") + 
  theme(plot.title = element_text(size = 16, 
                                  face = "bold",
                                  hjust = 0.5)) +
  transition_reveal(year)


animate(p, renderer = gifski_renderer())
#-----------------------------------------------------------------------------------------------------

#Choropleth Maps of the United States

#Pull Census Geographic Boundaries for the United States
states <- tigris::states(cb = TRUE)
head(states)

#Visualize to Take a Look at the U.S. Boundaries
ggplot(states) +
  geom_sf() +
  theme_void()


#2024 Map

#Data: state and year and rename year data to 'diagnosis_rate
hiv_2024 <- hdiag %>%
  select(State, `2024`) %>%
  rename(
    diagnosis_rate = `2024`
  )

head(hiv_2024)

#Join dataset with map

states_hiv_2024 <- states %>%
  left_join(
    hiv_2024,
    by =c("NAME" = "State")
  )

states_hiv_2024 %>%
  select(NAME, diagnosis_rate) 

map24 <- states_hiv_2024 %>%
  filter(!NAME %in% c("Puerto Rico","Guam","Alaska","Hawaii",
                       "Commonwealth of the Northern Mariana Islands",
                       "United States Virgin Islands","American Samoa"
                       ))

#Visualize

ggplot(map24) +
  geom_sf(aes(fill = diagnosis_rate)) +
  scale_fill_gradient(
    low = "lightblue", high = "darkblue",limits = c(0, 40)) +
  labs(
    title = "HIV Diagnosis Rate by State, 2024",
    fill = "Diagnosis rate\nper 100,000"
  ) +
  theme_void() +
    theme(plot.title = element_text(
      size = 16, 
      face = "bold",
      hjust = 0.5)
      )

#2017 Map

#Data: state and year and rename year data to 'diagnosis_rate
hiv_2017 <- hdiag %>%
  select(State, `2017`) %>%
  rename(
    diagnosis_rate = `2017`
  )


#Join dataset with map

states_hiv_2017 <- states %>%
  left_join(
    hiv_2017,
    by =c("NAME" = "State")
  )

states_hiv_2017 %>%
  select(NAME, diagnosis_rate) 

map17 <- states_hiv_2017 %>%
  filter(!NAME %in% c("Puerto Rico","Guam","Alaska","Hawaii",
                      "Commonwealth of the Northern Mariana Islands",
                      "United States Virgin Islands","American Samoa"
  ))

#Visualize

ggplot(map17) +
  geom_sf(aes(fill = diagnosis_rate)) +
  scale_fill_gradient(
    low = "lightgreen",high = "darkgreen") +
  labs(
    title = "HIV Diagnosis Rate by State, 2017",
    fill = "Diagnosis rate\nper 100,000"
  ) +
  theme_void() +
    theme(plot.title = element_text(size = 16, 
                                    face = "bold",
                                    hjust = 0.5))

#Horizontal Bar Chart

habs_change <- hdiag %>%
  select(State, absolute_change)

ggplot(
  habs_change,
  aes(
    x = reorder(State, absolute_change),
    y = absolute_change
  )
) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Change in HIV Diagnosis Rate by State, 2017 - 2024",
    x = "State",
    y = "Change in diagnosis rate per 100,000"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(
    size = 16, 
    face = "bold",
    hjust = 0.5)
  )


#-------------------------------------------------------------------------------------------
#Top States

#Findings: Before I excluded Washington D.C. and Puerto Rico,  
#D.C. had the highest HIV diagnosis rate for every year from 2017-2024
#For the lowest diagnosis rates, Wyoming (2017-2018, 2021), 
#Vermont (2019, 2022-2023), Maine (2020), and New Hampshire(2024)

head(hiv_long)
highest_by_year <- hiv_long %>%
  group_by(year) %>%
  slice_max(order_by = diagnosis_rate, n = 1) %>%
  ungroup()

highest_by_year

lowest_by_year <- hiv_long %>%
  group_by(year) %>%
  slice_min(order_by = diagnosis_rate, n = 1) %>%
  ungroup()

lowest_by_year 

hiv_long$State

#Remote non-U.S. States and Territories from Dataset
hiv_long_2 <- hiv_long %>%
  filter(!State %in% c("National",
                      "District of Columbia",
                      "Puerto Rico")
  )

#Find the Top 5 states for each year

#Georgia had the highest diagnosis rate among all U.S. states
#every year rom 2017 - 2024

#Same states with lowest HIV diagnosis rates 
#Wyoming, Vermont, Maine and New Hampshire before exclusion

top5_by_year <- hiv_long_2 %>%
  group_by(year) %>%
  slice_max(order_by = diagnosis_rate, n = 5) %>%
  ungroup()

top5_by_year
#Mode: Most Frequent Value that Appears in the data

get_mode <- function(x) {
  uniq_x <- table(x)
  names(uniq_x)[uniq_x == max(uniq_x)]
}

get_mode(top5_by_year$State)
#Florida, Georgia, and Louisiana appear frequently as the top
#U.S. states with the highest HIV diagnosis rates from 2017-2024
#----------------------------------------------------------------------------
#Animated Bar Chart
hiv_anim <- hiv_long %>%
  filter(State %in% c("Louisiana",
                       "Georgia",
                       "Florida",
                      "Mississippi",
                      "Texas",
                      "Nevada",
                      "Maryland")) %>%
           group_by(year) %>%
  mutate(
    rank = rank(-diagnosis_rate)
  ) %>%
  ungroup()


p2 <- ggplot(
  hiv_anim,
  aes(
    x = diagnosis_rate,
    y = reorder(State, diagnosis_rate),
    fill = State
  )
) +
  geom_col()+
  labs(
    title = "HIV Diagnosis Rates in Selected States",
    subtitle = "Year: {closest_state}",
    x = "HIV diagnosis rate per 100,000",
    y = NULL
  ) +
  theme_minimal(base_family = "Corbel") +
  theme(plot.title = element_text(size = 16, 
                                  face = "bold",
                                  hjust = 0.5)) +
  transition_states(
    year,
    transition_length = 2,
    state_length = 1
  )

animate(p2)
#-------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------


# #Data: state and year and rename year data to 'diagnosis_rate
# per_change <- hdiag %>%
#   select(State, percent_change)
#  
# 
# 
# #Join dataset with map
# 
# per_hiv_2024 <- states %>%
#   left_join(
#     per_change,
#     by =c("NAME" = "State")
#   )
# 
# 
# pc <- per_hiv_2024 %>%
#   filter(!NAME %in% c("Puerto Rico","Guam","Alaska","Hawaii",
#                       "Commonwealth of the Northern Mariana Islands",
#                       "United States Virgin Islands","American Samoa"
#   ))
# 
# #Visualize

# ggplot(pc) +
#   geom_sf(aes(fill = percent_change)) +
#   scale_fill_gradient2(
#     low = "white", mid= "mistyrose", high = "red4", midpoint = 0, labels = NULL) +
#   labs(
#     title = "Percent change in HIV diagnosis rate, 2017–2024",
#     fill = "Change"
#   ) +
#   theme_void() +
#   theme(plot.title = element_text(
#     size = 16,
#     face = "bold",
#     hjust = 0.5)
#   )

#scale_fill_gradient(low ="lightblue", high = "blue")
###BELOW: Potential GG Plots
#-------------------------------------------------------------------------------------------------------------------------#
# #All States Respective of their Values
# ggplot(hiv_long, aes(
#   x = year, 
#   y = diagnosis_rate
# )) +
#   geom_line() +
#   geom_point() +
#   facet_wrap(~ State) +
#   labs(
#     title = "HIV Diagnosis Rates by State, 2017-2024",
#     x = "Year",
#     y = "Diagnosis rate per 100,000"
#   ) +
#   theme_minimal()

#Line Chart of all 50 States
# ggplot(hiv_long, aes(
#   x = year,
#   y = diagnosis_rate,
#   group = State
# )) +
#   geom_line() +
#   labs(
#     title = "HIV Diagnosis Rates by State, 2017-2024",
#     x = "Year",
#     y = "Diagnosis rate per 100,000"
#   ) +
#   theme_minimal()

