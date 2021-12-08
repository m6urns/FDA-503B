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

### Lidocaine; Tetracaine; Benzocaine A1070
### Lidocaine; Tetracaine A1416
### Epinephrine; Lidocaine Hydrocloride A1241
### Lidocaine; Epinephrine; Tetracaine A1245
### Racepinephrine; Lidocaine; Tetracaine A1421
### Lidocaine; Prilocaine; Tetracaine A1420
### Lidocaine; Prilocaine; Tetracaine; Phenylephrine A1413
### Lidocaine, Bupivacine A1403
### Aspartic Acid; Glutamic Acid A1057

## From here back recheck for inclusion of whole list. 

# Bupivacaine Hydrochloride; Fentanyl Citrate A1107
### Fentanyl Citrate; Ropivacaine Hydrochloride A1266
### Lidocaine Hydrochloride; Phenylephrine Hydrochloride A1412
### Phenylephrine Hydrochloride; Tropicamide A1591
### Tropicamide; Phenylephrine Hydrochloride; Cyclopentolate Hydrochloride A1184
### Lidocaine A1400
### Vancomycin A1833
### Hydrocortisone; Tretinoin; Hydroquinone A1329
### Finasteride; Minoxidil A1267


### Notes:
# Lidocaine Hydrochloride; Tetracaine Hydrochloride; Phenylephrine Hydrochloride
# Look into combinations of ingredients including Phenylenphrine

# Phenylephrine Hydrochloride; Tropicamide; Cyclopentolate Hydrochloride
# Phenylephrine Hydrochloride; Tropicamide; Ketorolac Tromethamine; Ciprofloxacin Hydrochloride
# Phenylephrine Hydrochloride; Tropicamide; Proparacaine Hydrochloride; Ketorolac Tromethamine

