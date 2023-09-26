#teeing up packages
#checking to make sure these are installed
library(tidyr)
library(dplyr)
#installing this new one
install.packages("palmerpenguins")
library(palmerpenguins)

penguins_data <- penguins

class(penguins_data)

#ways to learn more about dataframes or tibbles
#use head to make sure that data type matches what you expect
head(penguins_data)

#structure - another way of looking at things 
str(penguins_data)

#prints the unique values for a given var 
unique(penguins_data$species)

#slightly deeper dive into factors (could be done in the console in the future... just scratching a curiousity itch)
levels(penguins_data$sex)
is.ordered(penguins_data$sex)

#calculate mean for a column
mean(penguins_data$year)

#calculate mean for a column
mean(penguins_data$body_mass_g, na.rm = TRUE)
#if has missing data, inlcude the na.rm = TRUE command to tell it to ignore any NAs


#pasted "year" preface to all years
paste("Year: ", penguins_data$year)
#to save it as a new entity, do this:
years_of_sampling <- paste("Year: ", penguins_data$year)

#dplyr
#common goal - pull out some columns from the dataframe
island_year <- select(penguins_data, island, year)
#adds something new to the environment pane
#inspecting
str(island_year)

#subsetting
#what if we want all rows of a certain kind
torgs <- filter(penguins_data, island == "Torgersen")

#stringing together code of column and row selections 
torgs2.0 <- filter(penguins_data, island == "Torgersen") |>
  select(sex, species)

torgs2.0  

#adding or changing a data column 

torgs3.0 <- torgs |>
  mutate(rounded_bill_length = round(bill_length_mm)) |>
  select(species, sex, rounded_bill_length)

#display changes
torgs3.0

torgs_summary <- torgs |>
  group_by(species) |>
  summarize(mean_bill_length = mean(rounded_bill_length, na.rm = TRUE))
  
torgs_summary

#adding sex to group by
torgs_summary2 <- torgs |>
  group_by(species, sex) |>
  summarize(mean_bill_length = mean(rounded_bill_length, na.rm = TRUE))
torgs_summary2

#crosstabs type values
#creating a column called n with the counts
#dplyr n is counting a row for every one of these situations
penguins_counts <- penguins_data %>% 
  group_by(species, sex, island) %>% 
  summarize(n = dplyr::n())


#making the crosstabs more tabular 
#values fill to make the NAs turn to 0s if empty 
penguins_wide <- penguins_counts %>% 
  pivot_wider(names_from = island, values_from = n, values_fill = 0)
penguins_wide


penguins_long_again <- penguins_wide %>% 
  pivot_longer(-c(species, sex), values_to = "count")
#can do a bunch of stuff to manipulate col names
