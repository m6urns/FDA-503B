# Pull Clean Production Data and Format for Manual Database Creation

production <- read_csv("FDA-503B/clean/data/Production_2019+2020_11_30_2021.csv")

production <- production %>%
  select(`Active Ingredients`) %>%
  distinct(`Active Ingredients`, .keep_all = TRUE) %>%
  arrange(`Active Ingredients`) %>%
  mutate(UID = paste("A" ,row_number() + 1000, sep = "")) %>%
  mutate(`Brand Name` = NA)
  
# write.csv(production, "~/FDA-503B/databases/data/production_2019_2020.csv")

## Reassigned UID's

# BLT A1070
# LT A1416
# 
