#### For loops ###

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