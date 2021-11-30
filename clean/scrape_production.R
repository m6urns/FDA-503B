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
element$sendKeysToElement(list("Establishment"))

driver$navigate("https://www.accessdata.fda.gov/scripts/cder/outsourcingfacility/index.cfm/#sugg")


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

###
element <- driver$findElement(using = "css", "#report > option:nth-child(1)")
driver$mouseMoveToLocation(webElement = element)
driver$click()

element <- driver$findElement(using = "xpath", "//*[@id='report']")
driver$mouseMoveToLocation(webElement = element)
driver$click()

option <- driver$findElement(using "xpath", "")

option <- driver$findElement(using = "xpath", "//*/option[@value = '2020-1']")

driver$mouseMoveToLocation(webElement = element)
driver$click()

element <- driver$findElement(using = "xpath", "//*[@id='report']/option[@value='2019-1']")
driver$mouseMoveToLocation(webElement = element)
driver$click()

option <- driver$findElement(using = "xpath", "//*/option[@value='2019-1']")
driver$mouseMoveToLocation(webElement = option)
driver$click()

option <- driver$findElement(using = "xpath", "//*[@id='report']/option[2]")
driver$mouseMoveToLocation(webElement = option)
driver$click()

element <- driver$findElement(using = "xpath", "//*[@id='report']/option[@value='2019-1']")
driver$mouseMoveToLocation(webElement = element)
driver$click()

element <- driver$findElement(using = "xpath", "//*[@id='report']")
driver$mouseMoveToLocation(webElement = element)
driver$click()

element$sendKeysToElement(list("2020-1"))
element$sendKeysToElement(list(key="enter"))
driver$click()


###

element <- driver$findElement(using = "css", "#sugg")
driver$mouseMoveToLocation(webElement = element)
driver$click()

element$sendKeysToElement(list("Active"))
driver$click()

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

element <- driver
#driver$navigate("https://www.accessdata.fda.gov/scripts/cder/outsourcingfacility/index.cfm")

#close the driver
driver$close()

#close the server
rD[["server"]]$stop()

