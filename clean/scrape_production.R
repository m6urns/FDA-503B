#Scrape Production Lists
library(RSelenium)

# start the server and browser(you can use other browsers here)
rD <- rsDriver(browser=c("firefox"))

driver <- rD[["client"]]

driver$navigate("https://www.accessdata.fda.gov/scripts/cder/outsourcingfacility/index.cfm")

option <- driver$findElement(using = 'xpath', "//*[(@id = 'report')]/option[@value = '2020-1']")
option$clickElement()

option <- driver$findElement(using = 'xpath', "//*[(@id = 'sugg')]/option[@value = 'establishment_info']")
option$clickElement()

element <- driver$findElement(using = "css", "#searchbox")
driver$mouseMoveToLocation(webElement = element)
driver$click()

element$sendKeysToElement(list("Empower Pharmacy"))

#Search
element <- driver$findElement(using = "css", ".btn-primary")
driver$mouseMoveToLocation(webElement = element)
driver$click()

#Download CSV
element <- driver$findElement(using = "css", ".buttons-html5")
driver$mouseMoveToLocation(webElement = element)
driver$click()

#close the driver
driver$close()

#close the server
rD[["server"]]$stop()