## Product Report v1.0 Cleanup

# Import Libraries

library(tidyverse)
library(readr)
library(readxl)
# library(gt)
# library(ggplot2)
# library(maps)
# library(DT)
# library(ggrepel)
# library(ggmap)
# library(plotly)

# Import Data

## Import Facility Info

facility_info <- read_excel("~/Desktop/FDA-503B/data/facility_info.xlsx")

## Import Geographic Data

geographic_data <- read_excel("~/Desktop/FDA-503B/data/geographic_data.xlsx")

## Import Raw Product List

raw_product_list <- read_csv("~/Desktop/FDA-503B/data/CompiledProductList.csv")

## Import Raw Segmentation Data

product_segmentation <- read_excel("~/Desktop/FDA-503B/data/Outsourcing Facility Product Segmentation.xlsx")

# Reformat and Modify for Visualization 

## Reformat product_segmentation

### Select only active and segment data. This would be where to begin keeping
### dosage data
product_segmentation_refor <- product_segmentation %>%
  select(-...8, -`Active Ingredients Info`, -`Package Description`, -`NDC Package Code`,
         -`Estab. Name`, -`Report Year`, -Dosage) %>%
  rename(Active = `Active Ingredients`,
         SkinCare = `Skin Care`,
         PlasticSurgery = `Plastic Surgery`,
         FacialPlasticSurgery = `Facial Plastic Surgery`,
         InfusionTherapy = `Infusion Therapy`) %>%
  distinct(Active, .keep_all = TRUE)

### Combined segmentation X's into a single column

product_segmentation_comb <- product_segmentation_refor %>%
  mutate(Dental = case_when(Dental == "X" ~ "Dental")) %>%
  mutate(Optical = case_when(Optical == "X" ~ "Optical")) %>%
  mutate(Surgical = case_when(Surgical == "X" ~ "Surgical")) %>%
  mutate(Dermatology = case_when(Dermatology == "X" | SkinCare == "X" ~ "Dermatology")) %>%
  mutate(PlasticSurgery = case_when(PlasticSurgery == "X" | FacialPlasticSurgery == "X" ~ "PlasticSurgery")) %>%
  mutate(Nutraceuticals = case_when(Nutraceuticals == "X" ~ "Nutraceuticals")) %>%
  mutate(InfusionTherapy = case_when(InfusionTherapy == "X" ~ "InfusionTherapy")) %>%
  mutate(Other = case_when(Other == "X" ~ "Other")) %>%
  select(-SkinCare, -FacialPlasticSurgery) %>%
  unite("Segmentation", Dental:Other, sep = ", ", na.rm = TRUE) %>%
  mutate_all(list(~na_if(.,"")))

## Reformat Raw Product Data raw_product_data

### Standard FDA data reformat

raw_product_list_for <- raw_product_list %>%
  select(-X1, -`Active Ingredients Info`, -`Package Description`, -`NDC Package Code`) %>%
  separate(`Estab. Name`, into = c("Facility", "UID"), sep = "\\(") %>%
  separate(`Report Year`, into = c("Year", "Period"), sep = "\\-") %>%
  rename(Active = `Active Ingredients`)

raw_product_list_for$UID <- gsub("\\)", "", as.character(raw_product_list_for$UID))

# Combine raw_product_data and product_segmentation

product_list_segmented <- raw_product_list_for %>%
  left_join(product_segmentation_comb, by = "Active")

# Add brand names to product_list

product_list_competitors <- product_list_segmented %>%
  mutate(BrandName = case_when(Active == "Bevacizumab" ~ "Avastin",
                               Active == "Cyanocobalamin" ~ "Methylcobalamin",
                               Active == "Methylcobalamin" ~ "Methylcobalamin",
                               Active == "Procaine Hydrochloride" ~ "Procaine",
                               Active == "Aflibercept" ~ "Eylea",
                               Active == "Lidocaine Hydrochloride; Prilocaine Hydrochloride; Tetracaine Hydrochloride; Phenylephrine Hydrochloride" ~ "TAP Gel",
                               Active == "Tetracaine; Phenylephrine; Prilocaine; Lidocaine" ~ "TAP Gel",
                               Active == "Prilocaine; Lidocaine; Tetracaine; Phenylephrine" ~ "TAP Gel",
                               Active == "Lidocaine; Prilocaine Hydrochloride; Tetracaine Hydrochloride; Phenylephrine" ~ "TAP Gel",
                               Active == "Lidocaine Hydrochloride; Epinephrine Bitartrate; Tetracaine Hydrochloride" ~ "LET Gel",
                               Active == "Lidocaine Hydrochloride; Tetracaine Hydrochloride; Epinephrine Bitartrate" ~ "LET Gel",
                               Active == "Tetracaine Hydrochloride; Epinephrine Bitartrate; Lidocaine Hydrochloride" ~ "LET Gel",
                               Active == "Epinephrine; Lidocaine Hydrochloride; Tetracaine Hydrochloride" ~ "LET Gel",
                               Active == "Lidocaine; Tetracaine" ~ "LT Oint",
                               Active == "Tetracaine; Lidocaine" ~ "LT Oint",
                               Active == "Lidocaine Hydrochloride; Tetracaine Hydrochloride" ~ "LT Oint",
                               Active == "Tetracaine; Benzocaine; Lidocaine" ~ "BLT Cream",
                               Active == "Lidocaine; Tetracaine; Benzocaine" ~ "BLT Cream",
                               Active == "Lidocaine; Benzocaine; Tetracaine" ~ "BLT Cream",
                               Active == "Tetracaine; Lidocaine; Benzocaine" ~ "BLT Cream",
                               Active == "Benzocaine; Tetracaine; Lidocaine" ~ "BLT Cream",
                               Active == "Lidocaine; Tetracaine; Benzocaine" ~ "BLT Cream",
                               Active == "Lidocaine; Prilocaine; Tetracaine" ~ "Profound",
                               Active == "Dexpanthenol" ~ "Dexpanthenol"
  ))

# Combined facility_info to product_list, not super needed, you will also
# combine facility_info later. But there may be some dependencies. 

product_list <- product_list_competitors %>%
  left_join(facility_info, by = "Facility")

# Copy product_list to product_list_graphics, because you want to do things the
# hard way. 

#product_list_graphics <- product_list

# Begin Modifying product_list to remove double entries. 

## Select Active, Segmentation, Facility. (This is ok, you are going to perform
## further modification later) Add a UID for each line to facilitate filter and
## join operations. 
products_in_each <- product_list %>%
  select(Active, Segmentation, Facility) %>%
  mutate(UID = row_number())

### Lidocaine; Tetracaine; Benzocaine
### Select all instances that match the actives for BLT, mutate the segment info
### at the same time
modify_blt <- products_in_each %>%
  filter(grepl("Tetracaine", Active) & grepl("Benzocaine", Active) & grepl("Lidocaine", Active)) %>%
  mutate(Active = "Lidocaine; Benzocaine; Tetracaine") %>%
  mutate(Segmentation = "Dental, Surgical, Dermatology, PlasticSurgery")

### Remove the modified products from products_in_each, to avoid remodifying
### with future filters. These sets will be saved and recombined with the 
### unmodifed rows at the end
products_in_each <- products_in_each %>%
  filter(!UID %in% modify_blt$UID) 

### Lidocaine; Epinephrine
modify_lidoepi <- products_in_each %>%
  filter(grepl("Epinephrine", Active) & grepl("Lidocaine", Active) != grepl("Tetracaine", Active)) %>%
  mutate(Active = "Lidocaine; Epinephrine") %>%
  mutate(Segmentation = "Dental, Optical, Dermatology")

products_in_each <- products_in_each %>%
  filter(!UID %in% modify_lidoepi$UID) 

### Lidocaine; Epinephrine; Tetracaine
modify_lidoepitetra  <- products_in_each %>%
  filter(grepl("Epinephrine", Active) & grepl("Lidocaine", Active) & grepl("Tetracaine", Active)) %>%
  mutate(Active = "Lidocaine; Epinephrine; Tetracaine") %>%
  mutate(Segmentation = "Dental, Optical, Dermatology")

products_in_each <- products_in_each %>%
  filter(!UID %in% modify_lidoepitetra$UID)

### Racepinephrine; Lidocaine; Tetracaine
modify_rac  <- products_in_each %>%
  filter(grepl("Racepinephrine", Active) & grepl("Lidocaine", Active) & grepl("Tetracaine", Active)) %>%
  mutate(Active = "Tetracaine Hydrochloride; Racepinephrine Hydrochloride; Lidocaine Hydrochloride") %>%
  mutate(Segmentation = "Dental, PlasticSurgery")

products_in_each <- products_in_each %>%
  filter(!UID %in% modify_rac$UID)

### Lidocaine; Prilocaine; Tetracaine
modify_lidoprilotetra <- products_in_each %>%
  filter(grepl("Prilocaine", Active) & grepl("Lidocaine", Active) & grepl("Tetracaine", Active)) %>%
  mutate(Active = "Lidocaine; Prilocaine; Tetracaine") %>%
  mutate(Segmentation = "Dental, PlasticSurgery")

products_in_each <- products_in_each %>%
  filter(!UID %in% modify_lidoprilotetra$UID) 

### Lidocaine; Prilocaine; Tetracaine; Phenylephrine
modify_lidophen <- products_in_each%>%
  filter(grepl("Prilocaine", Active) & grepl("Lidocaine", Active) &
           grepl("Tetracaine", Active) & grepl("Phenylephrine", Active)) %>%
  mutate(Active = "Lidocaine; Prilocaine; Tetracaine; Phenylephrine") %>%
  mutate(Segmentation = "Dental, Surgical, PlasticSurgery")

products_in_each <- products_in_each %>%
  filter(!UID %in% modify_lidophen$UID)

### Lidocaine, Bupivacine
modify_lidobupi <- products_in_each %>%
  filter(grepl("Bupivacaine", Active) & grepl("Lidocaine", Active)) %>%
  mutate(Active = "Lidocaine; Bupivacaine") %>%
  mutate(Segmentation = "Dental, Optical, Surgical, Dermatology, PlasticSurgery, Other")

products_in_each <- products_in_each %>%
  filter(!UID %in% modify_lidobupi$UID) 

### Aspartic Acid; Glutamic Acid
modify_asparticglut <- products_in_each %>%
  filter(Active == "Aspartic Acid; Glutamic Acid" | Active == "Glutamic Acid; Aspartic Acid") %>%
  mutate(Active = "Aspartic Acid; Glutamic Acid") %>%
  mutate(Segmentation = "Dental, Optical, Surgical, Dermatology, PlasticSurgery, Nutraceuticals, InfusionTherapy, Other")

products_in_each <- products_in_each %>%
  filter(!UID %in% modify_asparticglut$UID)

### Lidocaine; Tetracaine
modify_lidotetrasol <- products_in_each %>%
  filter(grepl("Tetracaine", Active) & grepl("Lidocaine", Active)) %>%
  mutate(Active = "Tetracaine; Lidocaine") %>%
  mutate(Segmentation = "Dental, Optical, Dermatology")

products_in_each <- products_in_each %>%
  filter(!UID %in% modify_lidotetrasol$UID)

## Methylcobalamin (these are different it turns out)
# modify_meth <- products_in_each %>%
#   filter(Active == "Methylcobalamin" | Active == "Cyanocobalamin") %>%
#   mutate(Active = "Methylcobalamin") %>%
#   mutate(Segmentation = "Nutraceuticals")
# 
# products_in_each <- products_in_each %>%
#   filter(!UID %in% modify_meth$UID)

### Fentanyl Citrate; Ropivacaine Hydrochloride
modify_fent <- products_in_each %>%
  filter(grepl("Fentanyl Citrate", Active) & grepl("Ropivacaine Hydrochloride", Active)) %>%
  mutate(Active = "Fentanyl Citrate; Ropivacaine Hydrochloride") %>%
  mutate(Segmentation = "Surgical, PlasticSurgery")

products_in_each <- products_in_each %>%
  filter(!UID %in% modify_fent$UID)

### Lidocaine Hydrochloride; Phenylephrine Hydrochloride
modify_phenlido <- products_in_each %>%
  filter(grepl("Lidocaine Hydrochloride", Active) & grepl("Phenylephrine Hydrochloride", Active)) %>%
  mutate(Active = "Lidocaine Hydrochloride; Phenylephrine Hydrochloride")  %>%
  mutate(Segmentation = "Dental, PlasticSurgery")

products_in_each <- products_in_each %>%
  filter(!UID %in% modify_phenlido$UID) 

### Phenylephrine Hydrochloride; Tropicamide
modify_troicamide <- products_in_each %>%
  filter(grepl("Phenylephrine Hydrochloride", Active) & grepl("Tropicamide", Active)) %>%
  mutate(Active = "Phenylephrine Hydrochloride; Tropicamide") %>%
  mutate(Segmentation = "Optical")

products_in_each <- products_in_each %>%
  filter(!UID %in% modify_troicamide$UID) 

### Tropicamide; Phenylephrine Hydrochloride; Cyclopentolate Hydrochloride
modify_tropphencyc <- products_in_each %>%
  filter(grepl("Tropicamide", Active) & grepl("Phenylephrine Hydrochloride", Active) & grepl("Cyclopentolate Hydrochloride", Active)) %>%
  mutate(Active = "Tropicamide; Phenylephrine Hydrochloride; Cyclopentolate Hydrochloride") %>%
  mutate(Segmentation = "Surgical, PlasticSurgery, InfusionTherapy")

products_in_each <- products_in_each %>%
  filter(!UID %in% modify_tropphencyc$UID)

### Lidocaine
modify_lidocainehydro <- products_in_each %>%
  filter(Active == "Lidocaine Hydrochloride" | Active == "Lidocaine") %>%
  mutate(Active = "Lidocaine") %>%
  mutate(Segmentation = "Dental, Optical, Surgical, Dermatology, PlasticSurgery")

products_in_each <- products_in_each %>%
  filter(!UID %in% modify_lidocainehydro$UID)

### Vancomycin
modify_vancomycin <- products_in_each %>%
  filter(Active == "Vancomycin" | Active == "Vancomycin Hydrochloride") %>%
  mutate(Active = "Vancomycin") %>%
  mutate(Segmentation = "Dental, Optical, Surgical, PlasticSurgery")

products_in_each <- products_in_each %>%
  filter(!UID %in% modify_vancomycin$UID) 

### Hydrocortisone; Tretinoin; Hydroquinone
modify_hydrotret<- products_in_each %>%
  filter(grepl("Hydrocortisone", Active) & grepl("Tretinoin", Active) & grepl("Hydroquinone", Active)) %>%
  mutate(Active = "Hydrocortisone; Tretinoin; Hydroquinone") %>%
  mutate(Segmentation = "Dermatology")

products_in_each <- products_in_each %>%
  filter(!UID %in% modify_hydrotret$UID)

### Finasteride; Minoxidil
modify_finestride <- products_in_each %>%
  filter(grepl("Finasteride", Active) & grepl("Minoxidil", Active)) %>%
  mutate(Active = "Finasteride; Minoxidil") %>%
  mutate(Segmentation = "Dermatology")

products_in_each <- products_in_each %>%
  filter(!UID %in% modify_finestride$UID) 

## Bind together all the modified sets
bound_rename <- bind_rows(modify_blt, modify_lidoepi, modify_lidoepitetra, modify_rac,
                          modify_lidoprilotetra, modify_lidophen, modify_lidobupi,
                          modify_asparticglut, modify_lidotetrasol, modify_fent,
                          modify_phenlido, modify_troicamide, modify_tropphencyc,
                          modify_lidocainehydro, modify_vancomycin,
                          modify_hydrotret, modify_finestride)

## Bind sets back into the prefiltered products in each set. 
products_in_each <- products_in_each %>%
  bind_rows(bound_rename)

# Modify segmentation column to duplicate entries, one entry per facility, per
# segment, per product. 

## Remove NA entries. This needs work on the segmentation side at line 50, to
## add more comprehensive info on product segments. 
products_in_each <- products_in_each %>%
  filter(Segmentation != "NA")

## Filter, looking for segment entries in segmentation column, then make a
## column just to represent that piece of info. Leave filtered, recombine
## at the end.
products_other <- products_in_each %>%
  filter(grepl("Other", Segmentation)) %>%
  mutate(Catagory = "Other")

products_nutra <- products_in_each %>%
  filter(grepl("Nutraceuticals", Segmentation)) %>%
  mutate(Catagory = "Nutraceuticals")

products_infusion <- products_in_each %>%
  filter(grepl("InfusionTherapy", Segmentation)) %>%
  mutate(Catagory = "InfusionTherapy")

products_derma <- products_in_each %>%
  filter(grepl("Dermatology", Segmentation)) %>%
  mutate(Catagory = "Dermatology")

products_surgical <- products_in_each %>%
  filter(grepl("Surgical", Segmentation)) %>%
  mutate(Catagory = "Surgical")

products_plastic <- products_in_each %>%
  filter(grepl("PlasticSurgery", Segmentation)) %>%
  mutate(Catagory = "PlasticSurgery")

products_dental <- products_in_each %>%
  filter(grepl("Dental", Segmentation)) %>%
  mutate(Catagory = "Dental")

products_optical <- products_in_each %>%
  filter(grepl("Optical", Segmentation)) %>%
  mutate(Catagory = "Optical")

## Recombine into a single set. 
products_single_seg <- bind_rows(products_dental, products_other, products_derma,
                                 products_nutra, products_infusion, products_surgical,
                                 products_plastic, products_optical) %>%
  rename("Segment" = "Catagory") %>%
  select(-Segmentation, -UID)

## From single set, perform counting operations. 

## Number of products Facility produces within Segment
group_segment_facility <- products_single_seg %>%
  group_by(Segment, Facility) %>%
  distinct(Active, .keep_all = TRUE) %>%
  mutate(FacilitySegmentCount = n()) %>%
  ungroup() %>%
  select(Facility, Segment, FacilitySegmentCount)

## Number of times Active was reported as produced
group_active <- products_single_seg %>%
  group_by(Facility) %>%
  distinct(Active, .keep_all = TRUE) %>% 
  ungroup() %>%
  group_by(Active) %>%
  mutate(ActiveCount = n()) %>%
  ungroup() %>%
  select(Active, Segment, Facility, ActiveCount)

## Number of products Facility produces across segments  
group_facility <- group_segment_facility  %>%
  group_by(Facility) %>%
  distinct(Segment, .keep_all = TRUE) %>%
  mutate(ProductCount = sum(FacilitySegmentCount)) %>%
  ungroup() %>%
  select(Facility, ProductCount)

## Number of products within segment
group_segment <- group_segment_facility %>%
  group_by(Segment) %>%
  distinct(Facility, .keep_all = TRUE) %>%
  mutate(SegmentCount = sum(FacilitySegmentCount)) %>%
  ungroup() %>%
  select(Segment, SegmentCount)

## Chained join operation
joined_segments_1 <- products_single_seg %>%
  left_join(group_facility, by = "Facility") %>%
  distinct_all()

joined_segments_2 <- joined_segments_1 %>%
  left_join(group_segment, by = "Segment") %>%
  distinct_all()

joined_segments_3 <- joined_segments_2 %>%
  left_join(group_segment_facility, by = c("Facility", "Segment")) %>%
  distinct_all()

joined_segments_4 <- joined_segments_3 %>%
  left_join(group_active, by = c("Active")) %>%
  distinct_all()

## Produce a list of Products Produced by RAM/CP

### Select RAM products, and apply designator. 
ram_product_list <- product_list %>%
  filter(Facility == "RAM Pharma, Inc.") %>%
  mutate(ProducedByCP = "Y") %>%
  distinct(Active, .keep_all = TRUE) %>%
  select(Active, ProducedByCP)

### Products that CP currently produces. Uses the Active column to select
### rows. 
cp_actives <- c("Methylcobalamin", "Dexpanthenol", "Lidocaine; Benzocaine; Tetracaine", 
                "Tetracaine; Lidocaine", "Bevacizumab", "Procaine Hydrochloride", 
                "Cyanocobalamin", "Aflibercept", "Lidocaine; Epinephrine; Tetracaine",
                "Lidocaine; Prilocaine; Tetracaine; Phenylephrine", "Lidocaine; Prilocaine; Tetracaine")

cp_product_list <- product_list %>%
  filter(Active %in% cp_actives) %>%
  mutate(ProducedByCP = "Y") %>%
  distinct(Active, .keep_all = TRUE) %>%
  select(Active, ProducedByCP)

### Bind the two lists. 
cp_products <- bind_rows(cp_product_list, ram_product_list)

### Bind to facility_product_count, by Active, leaving Y/NA column intact. 
### remove duplicate columns, rename, and distinct_all() to remove duplicates. 
facility_product_count <- joined_segments_4 %>%
  left_join(cp_products, by = "Active") %>%
  select(Active, Facility.x, Segment.x, ActiveCount, ProductCount, FacilitySegmentCount,
         SegmentCount, ProducedByCP) %>%
  rename(Segment = Segment.x, Facility = Facility.x) %>%
  distinct_all() #%>%
  # left_join(facility_info, by = "Facility")

# Write facility_product_count to a csv file if needed. 
write.csv(facility_product_count, "~/Desktop/FDA-503B/data/facility_product_count.csv")

# Modify product_list to include ProductCount, Competing
product_count_p_l <- facility_product_count %>%
  select(Facility, ProductCount) %>%
  distinct(Facility, .keep_all = TRUE)

number_competing <- facility_product_count %>%
  select(Active, Facility, ProducedByCP) %>%
  group_by(Facility) %>%
  distinct(Active, .keep_all = TRUE) %>%
  filter(ProducedByCP == "Y") %>%
  mutate(Competing = n()) %>%
  distinct(Facility, .keep_all = TRUE) %>%
  select(Facility, Competing)

## Join ProductCount, and Competing
product_list <- product_list %>%
  left_join(product_count_p_l, by = "Facility")

product_list <- product_list%>%
  left_join(number_competing, by = "Facility")

# Modify product_list to include FacilitySqFt, and Employee #'s

# sqft_employee <- facility_info %>%
#   select(Facility, FacilitySqFt, Employees)
# 
# product_list <- product_list %>%
#   select(-FacilitySqFt, -Employees) %>%
#   left_join(sqft_employee, by = "Facility")

write_csv(product_list, "~/Desktop/FDA-503B/data/product_list.csv")





















































