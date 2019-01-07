# require statements
#require 'au3'
require 'colorize'

#include AutoItX3

# waitForElement(): Wait for wait_time time for element to be present
#   parameters: driver: driver object
#               xpath: xpath of the element
#               wait_time: Amount of time needed to wait
#   return: element reference
def waitForElement(driver,xpath,wait_time=3)
    begin
        if driver.nil? || xpath.nil? then
            puts "Pass in valid argument"
            return false
        end
        blnPresent = Watir::Wait.until(timeout:wait_time){ driver.element(:xpath => xpath).present?}
        return blnPresent
    rescue Exception => e
        return false
    end
end

# getElementReference(): Returns the element reference for given xpath
#   parameters: driver: driver: driver object
#               xpath: xpath of the element
#               elementName: Name for element 
#   return: element reference
def getElementReference(driver,xpath,elementName='')
    begin
        blnPresent = waitForElement(driver,xpath)
        if blnPresent
          return driver.element(:xpath => xpath)
        else
            puts "Element #{elementName} not found".red
            return false
        end
    rescue Exception => e
        puts e
        return false
    end
end

# getElementsReference(): Returns array of elements reference for given xpath
#   parameters: driver: driver: driver object
#               xpath: xpath of the element
#               elementName: Name for element 
#   return: element reference
def getElementsReference(driver,xpath,elementName='')
    begin
        blnPresent = waitForElement(driver,xpath)
        if blnPresent
          return driver.elements(:xpath => xpath)
        else
            puts "Element #{elementName} not found"
            return false
        end
    rescue Exception => e
        puts e
        return false
    end
end
