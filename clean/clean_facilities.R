##Clean Facilites Table
require(tidyverse)
require(readr)

# Import scraped data
facility_table_raw <- read_csv("FDA-503B/scrape/data/FacilityTable_11_3_2021.csv", 
                           col_types = cols(`Initial Date of Registration as an Outsourcing Facility1` = col_date(format = "%m/%d/%Y"), 
                                                     `Date of Most Recent Registration as an Outsourcing Facility1` = col_date(format = "%m/%d/%Y"), 
                                                     `End Date of Last FDA Inspection Related to Compounding2` = col_date(format = "%m/%d/%Y")))

# Drop X1 & Correct Column Names
facility_table_reform <- facility_table_raw %>%
  select(-X1) %>%
  rename(`Initial Date of Registration as an Outsourcing Facility` = `Initial Date of Registration as an Outsourcing Facility1`,
         `Date of Most Recent Registration as an Outsourcing Facility` = `Date of Most Recent Registration as an Outsourcing Facility1`,
         `End Date of Last FDA Inspection Releated to Compounding` = `End Date of Last FDA Inspection Related to Compounding2`,
         `Was a Form FDA-483 issued?` = `Was a Form FDA-483 issued?3`,
         `Other Action, if Any, Based on Last Inspection` = `Other Action, if Any, Based on Last Inspection4,5`,
         `Intends to Compounds Sterile Drugs From Bulk Drug Substances` = `Intends to Compounds Sterile Drugs From Bulk Drug Substances6`)

# Separate Contact Name and Phone Number
names_numbers <- facility_table_reform$`Contact Name and Phone Number` %>%
  str_split_fixed(pattern = "(?<=[a-zA-Z\\s])(?=[0-9])", n = 2)


facility_table_reform_1 <- facility_table_reform %>%
  select(-`Contact Name and Phone Number`) %>%
  bind_cols(names_numbers[ ,1]) %>%
  bind_cols(names_numbers[ ,2]) %>%
  rename(`Contact Name` = ...8, `Phone Number` = ...9)
  
# Separate State and City
# state <- facility_table_reform_1$`Facility Name` %>%
#   str_split_fixed(pattern = "(?=[^ ]+$)", n = 2)
# 
# facility_table_reform_2 <- facility_table_reform_1 %>%
#   select(-`Facility Name`) %>%
#   bind_cols(state[ ,1]) %>%
#   bind_cols(state[ ,2]) %>%
#   rename(`Facility Name` = ...9, State = ...10)

# facility_table_reform_2$`Facility Name` <- gsub("\\,", "", as.character(facility_table_reform_2$`Facility Name`))

# Separate Facility Name and City

# facility_table_reform_2 %>%
#   add_column(new_col = "City")
# 
# for (i in seq_along(facility_table_reform_2)) {
#   if (facility_table_reform_2$`Facility Name`[[i]] %in% uscities) {
#     city <- filter(uscities == facility_table_reform_2$`Facility Name`[[i]])
#     facility_table_reform_2$City[[i]] = city
#   }
#   else {
#     facility_table_reform_2$City[[i]] = "NA"
#   }
# }
# 
# for (i in seq_along(facility_table_reform_2)) {
#   if (grepl(facility_table_reform_2$`Facility Name`[[i]], uscities)) {
#     city <- filter(uscities = facility_table_reform_2$`Facility Name`[[i]])
#     facility_table_reform_2$City[[i]] = city
#   }
#   else {
#     facility_table_reform_2$City[[i]] = "NA"
#   }
# }

write.csv(facility_table_reform_1, "~/FDA-503B/clean/data/facility_table_clean.csv")
