##Madeleine deBlois
##R workshop
##2023.9.21

#load packages
library(readr)
library(tidyr)
library(dplyr)

#read data
PIINS <- read_csv("data/practice_dataset.csv")

str(PIINS)

class(PIINS)

numPIINS <- PIINS  %>% select_if(is.numeric)
 