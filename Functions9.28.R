# 2023.9.28
#workshop demo
#building our own functions part 2

library(dplyr)

######functions####
#simplify the environment that you have to deal with 
#my_function <- function(data_url = "https://github.com/cct-datascience/repro-data-sci/raw/r-lessons/lessons/7-intermediate-r-1/lesson-data/Biscoe.csv") {

#setting up function to decide what url 
#can set to default with putting value in inital function line, in this case after island to use =
#if that island is Biscoe, then do the function inside curly braces

my_function <- function(island_to_use) {
  if (island_to_use == "Biscoe") {
    data_url <- "https://github.com/cct-datascience/repro-data-sci/raw/r-lessons/lessons/7-intermediate-r-1/lesson-data/Biscoe.csv"
  }
  else if (island_to_use == "Dream"){
    data_url <- "https://github.com/cct-datascience/repro-data-sci/raw/r-lessons/lessons/7-intermediate-r-1/lesson-data/Dream.csv"
  } 
  else if (island_to_use == "Torgersen") {
    data_url <- "https://github.com/cct-datascience/repro-data-sci/raw/r-lessons/lessons/7-intermediate-r-1/lesson-data/Torgersen.csv"
  } #next line is the catchall for everything leftover with a stop function, kind of like pulling fire alarm on code 
  else {
    stop("The island_to_use doesn't exist!")
  }
  
# 
# my_function_output <- my_function(island_to_use = "Torgersen")
# #print output in console
# my_function_output 
  
  #writing code that will take a test - chceck if it is true. if true, do 1 thing, if false, do something else

   island_dat <- read.csv(data_url)
  island_dat <- island_dat %>%
    na.omit()

  island_dat_means <- island_dat %>%
    group_by(species, sex) %>%
    summarize(across(ends_with("mm") | ends_with("g"), mean))

  island_dat_means_imperial <- island_dat_means %>%
    mutate(across(ends_with("mm"), ~ . * 0.03937008, .names ="{col}_in"),
           across(ends_with("g"), ~ . * 0.002204623, .names ="{col}_lb"))

  island_dat_means_imperial <- island_dat_means_imperial %>%
    rename_with(~stringr::str_replace(. , "mm_in", "in"), .cols = ends_with("mm_in")) %>%
    rename_with(~stringr::str_replace(. , "g_lb", "lb"), .cols = ends_with("g_lb"))

  island_dat_means_imperial <- island_dat_means_imperial %>%
    select(c(where(is.character) |
               ends_with("in") |
               ends_with("lb")))

  return (island_dat_means_imperial)
}


####analysis#####
#now applying our function to other islands' data

#if you had left a default
#biscoe_output <- my_function()

#if you haven't specified a default
biscoe_output <- my_function(island_to_use = "Biscoe")
torg_output <- my_function(island_to_use = "Torgersen")
dream_output <- my_function(island_to_use = "Dream") 


#### For loops ####

#run my_function on each island (Biscoe, Torgesen, Dream)
#creating a list called cleaned data where we're storing the results of for loop
#lists have a thing called name

#getting unique values for a var example code
#could then swap this in for the enumerated islands 
#unique(my_data$island)

islands_we_want <- c("Biscoe", "Torgersen", "Dream")
cleaned_data <- list()
#for i = 1 to 3, we're gong to print of islands we want, then select i element of that vector. if i = 1, get first element, if i=2, second element, etc)
for (i in 1:3) {
  cleaned_data[[i]] <- my_function(islands_we_want[i])
}

names(cleaned_data) <- islands_we_want

#stuck the dataframes back together 
#.id function for bind rows
cleaned_data_df <- bind_rows(cleaned_data, .id = "island")

View(cleaned_data_df)