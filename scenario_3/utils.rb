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


# getElementReference(): Used to get reference of element based on passed mode and element type.
#   parameter: driver: Watir object
#              identifier: Value for the unique identification of the reference on page
#              [mode]: mode of verification.
#              [element_type]: defined by what method should the reference be fetched.   
#   returns: element reference
def getElementReferenceWithGeneric(driver,identifier,name="",mode="id",element_type="element",wait_time=5)
    begin
        case mode
            when "id"
                if(Watir::Wait.until(timeout:wait_time){driver.send(element_type.to_sym,:id=>identifier).present?})
                    return driver.send(element_type.to_sym,:id=>identifier)
                else
                    return false
                end
            when "partial"
                if(Watir::Wait.until(timeout:wait_time){driver.send(element_type.to_sym,:visible_text=>/#{identifier}/).present?})
                    return driver.send(element_type.to_sym,:visible_text=>/#{identifier}/)
                else
                    return false
                end
        end
    rescue Exception => e
        puts "Element #{name} was not found".red
        return false
    end
end

# performAction(): Used to perfomrm action on the element.
#   parameter: elementRef: Element reference
#              action: Value that signified what action needs to be performed
#              [details]: Signifies whaich value needs to selected/send
#   return: bool
def performAction(elementRef,action,details="")
    begin
        case action
            when "enter"
                if(elementRef.attribute_value("readonly")=="true" or elementRef.attribute_value("disabled")=="true")              # Check to see if input value is disabled/readonly
                    script="arguments[0].readOnly=false;arguments[0].disabled=false"
                    elementRef.execute_script(script,elementRef)
                end
                elementRef.send_keys(details)

            when "select"
                elementRef.to_subtype.select(details)
            when "click"
                elementRef.click
            when "get"
                $section4sum=((elementRef.attribute_value("value").to_i))+$section4sum
        end
        return true
    rescue Exception=>e
        puts e.to_s.red
        return false
    end
end
