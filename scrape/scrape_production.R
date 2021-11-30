#Scrape Production Lists
require(RSelenium)
require(readr)
require(tidyverse)

# start the server and browser(you can use other browsers here)
rD <- rsDriver(browser=c("firefox"))
driver <- rD[["client"]]

retrive.csv <- function(facility) {
  driver <- rD[["client"]]
  driver$navigate("https://www.accessdata.fda.gov/scripts/cder/outsourcingfacility/index.cfm")
  
  ##Need to implement check for successful download, rather than just waiting
  ##Add skip if not data is in table

  #Retrive 2019-1
  option <- driver$findElement(using = 'xpath', "//*[(@id = 'report')]/option[@value = '2019-1']")
  option$clickElement()

  option <- driver$findElement(using = 'xpath', "//*[(@id = 'sugg')]/option[@value = 'establishment_info']")
  option$clickElement()

  element <- driver$findElement(using = "css", "#searchbox")
  driver$mouseMoveToLocation(webElement = element)
  driver$click()

  #element$sendKeysToElement(list("AnazaoHealth Corporation"))
  element$sendKeysToElement(list(facility))

  #Search
  element <- driver$findElement(using = "css", ".btn-primary")
  driver$mouseMoveToLocation(webElement = element)
  driver$click()
  Sys.sleep(3)
  
  #Download CSV
  element <- driver$findElement(using = "css", ".buttons-html5")
  driver$mouseMoveToLocation(webElement = element)
  driver$click()
  Sys.sleep(7)
  
  #Append to open file
  Sys.sleep(5)
  report1 <- read_csv("~/Downloads/Outsourcing Facility Product Report.csv")
  file.remove("~/Downloads/Outsourcing Facility Product Report.csv")
  
  driver$goBack()
  
  #Retrive 2019-2
  option <- driver$findElement(using = 'xpath', "//*[(@id = 'report')]/option[@value = '2019-2']")
  option$clickElement()
  
  option <- driver$findElement(using = 'xpath', "//*[(@id = 'sugg')]/option[@value = 'establishment_info']")
  option$clickElement()
  
  element <- driver$findElement(using = "css", "#searchbox")
  driver$mouseMoveToLocation(webElement = element)
  driver$click()
  
  element$sendKeysToElement(list(facility))
  
  #Search
  element <- driver$findElement(using = "css", ".btn-primary")
  driver$mouseMoveToLocation(webElement = element)
  driver$click()
  Sys.sleep(3)
  
  #Download CSV
  element <- driver$findElement(using = "css", ".buttons-html5")
  driver$mouseMoveToLocation(webElement = element)
  driver$click()
  
  #Append to open file
  Sys.sleep(5)
  report2 <- read_csv("~/Downloads/Outsourcing Facility Product Report.csv")
  file.remove("~/Downloads/Outsourcing Facility Product Report.csv")
  
  driver$goBack()
  
  #Retrive 2020-1
  option <- driver$findElement(using = 'xpath', "//*[(@id = 'report')]/option[@value = '2020-1']")
  option$clickElement()
  
  option <- driver$findElement(using = 'xpath', "//*[(@id = 'sugg')]/option[@value = 'establishment_info']")
  option$clickElement()
  
  element <- driver$findElement(using = "css", "#searchbox")
  driver$mouseMoveToLocation(webElement = element)
  driver$click()
  
  element$sendKeysToElement(list(facility))
  
  #Search
  element <- driver$findElement(using = "css", ".btn-primary")
  driver$mouseMoveToLocation(webElement = element)
  driver$click()
  Sys.sleep(3)
  
  #Download CSV
  element <- driver$findElement(using = "css", ".buttons-html5")
  driver$mouseMoveToLocation(webElement = element)
  driver$click()
  
  #Append to open file
  Sys.sleep(5)
  report3 <- read_csv("~/Downloads/Outsourcing Facility Product Report.csv")
  file.remove("~/Downloads/Outsourcing Facility Product Report.csv")
  
  driver$goBack()
  
  #Retrive 2020-1
  option <- driver$findElement(using = 'xpath', "//*[(@id = 'report')]/option[@value = '2020-2']")
  option$clickElement()
  
  option <- driver$findElement(using = 'xpath', "//*[(@id = 'sugg')]/option[@value = 'establishment_info']")
  option$clickElement()
  
  element <- driver$findElement(using = "css", "#searchbox")
  driver$mouseMoveToLocation(webElement = element)
  driver$click()
  
  element$sendKeysToElement(list(facility))
  
  #Search
  element <- driver$findElement(using = "css", ".btn-primary")
  driver$mouseMoveToLocation(webElement = element)
  driver$click()
  Sys.sleep(3)
  
  #Download CSV
  element <- driver$findElement(using = "css", ".buttons-html5")
  driver$mouseMoveToLocation(webElement = element)
  driver$click()
  
  #Append to open file
  Sys.sleep(5)
  report4 <- read_csv("~/Downloads/Outsourcing Facility Product Report.csv")
  file.remove("~/Downloads/Outsourcing Facility Product Report.csv")
  
  #Combine and return report
  report_combined <- bind_rows(report1, report2, report3, report4)

  return(report_combined)
}

anazaohealth <- retrive.csv("AnazaoHealth Corporation")

#Function to retrieve data for multiple facilities, combine into a single
#data frame

# 11/21 Currently Registered
# list <- c("AnazaoHealth Corporation", "ANNOVEX PHARMA", "Apollo Care",
#           "ASP CARES", "Athenex Pharma Solutions", "Atlas Pharmaceuticals",
#           "BayCare Integrated Service Center", "Belcher Pharmaceuticals",
#           "BPI Labs", "Brookfield Medical", "BSO LLC",
#           "Central Admixture Pharmacy Services", "Complete Pharmacy and Medical Solutions",
#           "Denver Solutions", "Eagle Pharmacy", "Edge Pharma", "Empower Pharmacy",
#           "Exela Pharma Sciences", "Excite Pharma Services", "F.H. Investments",
#           "Fagron Compounding Services", "Farmakeio Outsourcing", "Firefly Rx",
#           "Fresenius Kabi Compounding", "Hikma Injectables USA", "Hybrid Pharma",
#           "Imprimis NJOF", "INTACT PHARMACEUTICALS", "IntegraDose Compounding Services",
#           "JCB Laboratories", "Kashiv BioSciences", "KRS Global Biotechnology",
#           "Leesar Inc", "Medi-Fare Drug", "MedisourceRx", "Nephron Sterile Compounding Center",
#           "New England Life Care", "Nubratori", "Olympia Compounding Pharmacy",
#           "OurPharma", "Pharmaceutics International", "Pharmaceutic Labs", "Pine Pharmaceuticals",
#           "PQ Pharmacy", "Primera Compounding", "Prisma Health Outsourcing Facility",
#           "Providence Health", "QuVa Pharma", "RC Outsourcing", "Right Value Drug Stores",
#           "RXQ Compounding", "SCA Pharmaceuticals", "Sincerus Florida", "SSM Health Care Corporation",
#           "STAQ Pharma", "STASKA PHARMACEUTICALS", "STERRX", "Stokes Healthcare", 
#           "Strukmyer Medical", "Tailstorm Health", "The Ritedose Corporation",
#           "University of Tennessee", "US Specialty Formulations",
#           "Wedgewood Connect", "Wells Pharma of Houston", "Wells Pharmacy",
#           "RAM Pharma", "Baycare Central Pharmacy", "Asteria Health",
#           "Advanced Compounding Solutions", "Carie Boyd", "Epicure Pharma", "Leiters Compounding")

# 11/21 DBA's and formerly registered as
# list <- c("RAM Pharma", "Baycare Central Pharmacy", "Asteria Health",
#           "Advanced Compounding Solutions", "Carie Boyd", "Epicure Pharma", "Leiters Compounding")

# Test List
list <- c("RAM Pharma", "Baycare Central Pharmacy", "Asteria Health")

retrive.multiples <- function(facilities, temp_path = "~/FDA-503B/scrape/data/temp/") {

  for (i in seq_along(facilities)) {
    indv_facility <- retrive.csv(list[[i]])
    write.csv(indv_facility, file = paste(temp_path, "Products", facilities[[i]], ".csv"),
              row.names = FALSE)
    
  }

  files <- list.files(path=temp_path, full.names = TRUE, pattern = "*.csv") %>%
    lapply(read_csv) %>%
    bind_rows

  return(files)
}

comp_set <- retrive.multiples(list)

comp_set
#close the driver
driver$close()

#close the server
rD[["server"]]$stop()
