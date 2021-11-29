##Clean Facilites Table
library(readr)

#Import scraped data
facilities <- read_csv("FDA-503B/scrape/data/facilitytable_112921.csv", 
                                 col_types = cols(`Initial Date of Registration as an Outsourcing Facility1` = col_date(format = "%m/%d/%Y"), 
                                                  `Date of Most Recent Registration as an Outsourcing Facility1` = col_date(format = "%m/%d/%Y"), 
                                                  `End Date of Last FDA Inspection Related to Compounding2` = col_date(format = "%m/%d/%Y")))

#Seperate Facility Name,  City, and State

#Seperate Contact Name and Phone Number

