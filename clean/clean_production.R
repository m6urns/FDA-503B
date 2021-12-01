require(tidyverse)
require(readr)

production_data_raw <- read_csv("FDA-503B/scrape/data/Production_2019+2020_11_30_2021.csv")

# raw_product_list_for <- raw_product_list %>%
#   select(-X1, -`Active Ingredients Info`, -`Package Description`, -`NDC Package Code`) %>%
#   separate(`Estab. Name`, into = c("Facility", "UID"), sep = "\\(") %>%
#   separate(`Report Year`, into = c("Year", "Period"), sep = "\\-") %>%
#   rename(Active = `Active Ingredients`)
# 
# raw_product_list_for$UID <- gsub("\\)", "", as.character(raw_product_list_for$UID))

## Drop X1 and Separate Facility Name from Facility UID
production_data_reform <- production_data_raw %>%
  select(-X1) %>%
  separate(`Estab. Name`, into = c("Facility", "Facility UID"), sep = "\\(")

# Drop the final ) from the end of facility UID
production_data_reform$`Facility UID` <- gsub("\\)", "", as.character(production_data_reform$`Facility UID`))

# Remove duplicate entries just in case. Scrapper uses several possible names for
# some facilities because of buy outs, etc. Removing duplicates is ok because 
# production reports do not reflect unique production runs ness, but reflect
# production of an active in unique conc and delivery method. 

# production_data_reform for 2019+2020 has 10,207 entries

production_data <- production_data_reform %>%
  distinct(across(everything()))

# production data for 2019+2020 has 9,791 entries. Scrapping at some point is 
# downloading the same data twice. 

# Save production data to new csv in clean data directory
write.csv(production_data, "~/FDA-503B/clean/data/Production_2019+2020_11_30_2021.csv")
