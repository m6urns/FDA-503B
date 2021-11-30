#Scrape Production Lists
library(RSelenium)
library(readr)
library(tidyverse)

# start the server and browser(you can use other browsers here)
rD <- rsDriver(browser=c("firefox"))

retrive.csv <- function(facility) {
  driver <- rD[["client"]]
  driver$navigate("https://www.accessdata.fda.gov/scripts/cder/outsourcingfacility/index.cfm")

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
  Sys.sleep(2)
  
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
  Sys.sleep(2)
  
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
  Sys.sleep(2)
  
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
  Sys.sleep(2)
  
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

#close the driver
driver$close()

#close the server
rD[["server"]]$stop()
