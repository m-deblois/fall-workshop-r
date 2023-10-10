# 2023.9.26
#workshop demo
#building our own functions 

library(dplyr)

biscoe_dat <- read.csv("https://github.com/cct-datascience/repro-data-sci/raw/r-lessons/lessons/7-intermediate-r-1/lesson-data/Biscoe.csv")

head(biscoe_dat)

#checking for and removing NAs
#returns true or false
anyNA(biscoe_dat)

#listwise deletion for missing data, saved in same data frame 
biscoe_dat <- biscoe_dat %>% 
  na.omit()

#calculating means for species and sex combos
biscoe_dat_means <- biscoe_dat %>% 
  group_by(species, sex) %>% 
  summarize(n = dplyr::n())
 
#can say what summaries you want
#calculating means for species and sex combos
biscoe_dat_means <- biscoe_dat %>% 
  group_by(species, sex) %>% 
summarize (mean_bill_length = mean(bill_length_mm),
mean_bill_depth = mean(bill_depth_mm),
mean_flipper_length = mean(flipper_length_mm))

#using the across function to transform multiple columns at once
#use ?across to explore in more detail 
#take this data frame, group it, calculate mean for each column that ends in millimeter
biscoe_dat_means <- biscoe_dat %>% 
  group_by(species, sex) %>% 
  summarize(across(ends_with("mm"), mean))

#take everything that ends with mm *OR* g and calculate means 
biscoe_dat_means <- biscoe_dat %>% 
  group_by(species, sex) %>% 
  summarize(across(ends_with("mm") | ends_with("g"), mean))

#converting mm to inches 
#want output to be everything to right of tilda~ 
# . is the original data value
biscoe_dat_means_imperial <- biscoe_dat_means %>% 
  mutate(across(ends_with("mm"), ~ . * 0.03937008, .names ="{col}_in"))

#renaming vars in batch with string replace function
#with rename_with
#and stringr
biscoe_dat_means_imperial <- biscoe_dat_means_imperial %>% 
  rename_with(~stringr::str_replace(., "mm_in", "in"), .cols = ends_with("mm_in"))

#more renaming
#can mutate multiple lines within one mutate command 
biscoe_dat_means_imperial <- biscoe_dat_means %>% 
  mutate(across(ends_with("mm"), ~ . * 0.03937008, .names ="{col}_in"),
         across(ends_with("g"), ~ . * 0.002204623, .names ="{col}_lb"))

#use a new pipe for a new operation (can't nest these in one paranthetical)
biscoe_dat_means_imperial <- biscoe_dat_means_imperial %>% 
  rename_with(~stringr::str_replace(. , "mm_in", "in"), .cols = ends_with("mm_in")) %>% 
  rename_with(~stringr::str_replace(. , "g_lb", "lb"), .cols = ends_with("g_lb"))

#i want to select all character columns or end with inches or end with lbs
#vertical line means "or" 
#could also use & for an & option
#or where(is.numeric)
#search for ?where "selection helpers" 
#select function selects columns (vs. filter selects the rows) )
biscoe_dat_means_imperial <- biscoe_dat_means_imperial %>% 
  select(c(where(is.character) |
             ends_with("in") |
             ends_with("lb")))
  
######functions

#creating a function - basic format. needs curly brace.
my_function <- function() {
  return ("I need coffee!")
  
  
}
#running my function 
my_function()

#getting more complicated
#paste is a function for combining character strings
#paste0 is telling it to not put spaces in things
# eg, paste("my cat", "is named", "gorp")
my_function <- function(favorite_beverage = "coffee") {
  what_to_say <- paste0("I need ", favorite_beverage, "!")
  return (what_to_say)
}
#running my function 
my_function(favorite_beverage = "la croix")

#let's make one that calls a data url
#can't override anything inside the curly braces
#will default to this url, but can give it another one in your function 
my_function <- function(data_url = "https://github.com/cct-datascience/repro-data-sci/raw/r-lessons/lessons/7-intermediate-r-1/lesson-data/Biscoe.csv") {
  island_dat <- read.csv(data_url)
  
  return (island_dat)
}
#
my_function()


#going BIG
#generally, she copies script and modifies to fit function 
my_function <- function(data_url = "https://github.com/cct-datascience/repro-data-sci/raw/r-lessons/lessons/7-intermediate-r-1/lesson-data/Biscoe.csv") {
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

function_output <- my_function()

#now applying our function to other islands' data 

torg_output <- my_function("https://github.com/cct-datascience/repro-data-sci/raw/r-lessons/lessons/7-intermediate-r-1/lesson-data/Torgersen.csv")

dream_output <- my_function("https://github.com/cct-datascience/repro-data-sci/raw/r-lessons/lessons/7-intermediate-r-1/lesson-data/Dream.csv")
