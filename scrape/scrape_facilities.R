require(tidyverse)

html <- read_html("https://www.fda.gov/drugs/human-drug-compounding/registered-outsourcing-facilities")

title <- html %>%
  html_nodes("th") %>%
  html_text()

table <- html %>%
  html_nodes("td") %>%
  html_text()

#Facility Names
facility <- table[seq(1, length(table), 8)]

#Contact 
contact <- table[seq(2, length(table), 8)]

#Initial Registration
int_reg <- table[seq(3, length(table), 8)]

#Most Recent Registration
rec_reg <- table[seq(4, length(table), 8)]

#End Date Last FDA Inspection
fda_inspec <- table[seq(5, length(table), 8)]

#Form FDA-483
form_issue <- table[seq(6, length(table), 8)]

#Other Actions
other_ac <- table[seq(7, length(table), 8)]

#Compounds Sterile
sterile <- table[seq(8, length(table), 8)]

facility_table <- bind_cols(facility, contact, int_reg, rec_reg, fda_inspec, 
                            form_issue, other_ac, sterile)

oldnames = c('...1', '...2', '...3', '...4', '...5', '...6', '...7', '...8')

facility_table <- facility_table %>%
  rename_at(vars(oldnames), ~ title)

write.csv(facility_table, '~/FDA-503B/scrape/data/facilitytable_112921.csv')
