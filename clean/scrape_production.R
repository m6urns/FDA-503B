#Scrape Production Lists
library(RSelenium)

# start the server and browser(you can use other browsers here)
rD <- rsDriver(browser=c("firefox"))

driver <- rD[["client"]]

# Navigate to and select year
driver$navigate("https://www.accessdata.fda.gov/scripts/cder/outsourcingfacility/index.cfm")

driver$navigate("https://www.accessdata.fda.gov/scripts/cder/outsourcingfacility/index.cfm/#report")

element <- driver$findElement(using = "css", "#report")
driver$mouseMoveToLocation(webElement = element)
driver$click()

element$sendKeysToElement(list("2019-1"))

driver$navigate("https://www.accessdata.fda.gov/scripts/cder/outsourcingfacility/index.cfm/#report")


# Navigate to and select Type
driver$navigate("https://www.accessdata.fda.gov/scripts/cder/outsourcingfacility/index.cfm")

driver$navigate("https://www.accessdata.fda.gov/scripts/cder/outsourcingfacility/index.cfm/#sugg")

element <- driver$findElement(using = "css", "#sugg")
driver$mouseMoveToLocation(webElement = element)
driver$click()

#Weird, there must be a bug here in the FDA form, est selects active
#active selects est
element$sendKeysToElement(list("Establishment Name"))

driver$navigate("https://www.accessdata.fda.gov/scripts/cder/outsourcingfacility/index.cfm/#report")



#close the driver
driver$close()

#close the server
rD[["server"]]$stop()

