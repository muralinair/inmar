# Required statements
require 'watir'
require 'json'
require 'faker'
require 'json'
require 'colorize'

require_relative 'utils.rb'

# Configarations
Selenium::WebDriver::Chrome.driver_path=File.expand_path(File.dirname( __FILE__) + '/../Drivers/chromedriver.exe')
#$pageURL="https://mgsdemo.mgscoder.com/mgscode/regform/index-2.html"
$pageURL="file:///C:/Work/inter_test/scenario_3/test.html"  #Hardcoding localfile because of 403 error
$dataFile="./data.json"

# generatetFakeDetails(): Used to generate fake details for the test.
#   parameter: None
#   returns: fakeDetails<hash>: This holds the generated fake details for entering into form
def generatetFakeDetails()
    begin
        jsonFile=File.open($dataFile)
        dataFile=JSON.parse(jsonFile.read)
        jsonFile.close
        dataFile['section1']['username']['details']=Faker::Name.name
        dataFile['section1']['email']['details']=Faker::Internet.email
        dataFile['section1']['password']['details']=dataFile['section1']['username']['details']+dataFile['section1']['email']['details']
        dataFile['section1']['cpassword']['details']=dataFile['section1']['password']['details']
        dataFile['section2']['fname']['details']=Faker::Name.first_name
        dataFile['section2']['lname']['details']=Faker::Name.last_name
        dataFile['section2']['gender']['details']=["Male","Female"].sample
        dataFile['section2']['dob']['details']="12/03/1990"
        dataFile['section2']['address']['details']=Faker::Address.full_address
        dataFile['section2']['phone']['details']=Faker::Number.number(10)
        dataFile['section2']['profilepic']['details']=File.expand_path(File.dirname( __FILE__)+"/test.jpg").gsub("/","\\\\")
        dataFile['section3']['paymentmode']['details']=["Visa Card","Master Card"].sample 
        dataFile['section3']['ccname']['details']=Faker::Name.name
        dataFile['section3']['ccnumber']['details']=Faker::Number.number(16)
        dataFile['section3']['cccvc']['details']=Faker::Number.number(3)
        dataFile['section3']['ccexpiry']['details']="12/03/2020"
        return dataFile
    rescue Exception=>e
        puts e.to_s.red
        return false
    end
end

# determineAction(): Used to determine actions that need to be performed on element.
#   parameter: driver: Watir object
#              actionsKey: key values from each section of each elemtn
#   return: bool
def determineAction(driver,actionsKey)
    if(actionsKey.keys().include? "id")
        identifier= actionsKey["id"]
        if(identifier=="humanCheckCaptchaInput")            # custom check for section4 captcha calculation 
            actionsKey["details"]=$section4sum
        end
        mode="id"
    else
        identifier=actionsKey["partialtext"]
        mode="partial"
    end
    element_type=actionsKey.keys.include?("element_type")? actionsKey["element_type"]:"element"
    name=actionsKey["name"]
    element=getElementReferenceWithGeneric(driver,identifier,name,mode,element_type)
    if(element!=false)
        action=actionsKey["action"]
        details=actionsKey.keys.include?("details")? actionsKey["details"]:""
        performAction(element,action,details)
    else
        return false
    end
    
end

# fillDetails(): Used to entry point for gathering and entering the data.
#   parameter: browser: browser object 
#   returns: returns bool
def fillDetails(browser)
    fakeDetails=generatetFakeDetails()
    if(fakeDetails!=false)
        $section4sum=0
        for sec in fakeDetails.keys
            secReference=getElementReferenceWithGeneric(browser,fakeDetails[sec]["id"],fakeDetails[sec]["name"])
            if(secReference!=false)
                for secKeys in fakeDetails[sec].keys
                    if(secKeys != "id" and secKeys != "name")
                        determineAction(secReference,fakeDetails[sec][secKeys])
                    end
                end
            else
                return false
            end
        end
        return true
    else
        return false
    end
end

def determineWizardLength(driver)
    begin
        arrElements=driver.elements(:id=>/^section-[0-9]$/)
        puts "Number of wizard: #{arrElements.length}".green
    rescue Exception=>e
        puts e.to_s.red
        return false
    end

end

def findFinisedPopup(driver)
    begin
        finishedElements=getElementReferenceWithGeneric(driver,"^You have finished .*$",name="Finished popup","partial",element_type="element",wait_time=5)
        if(finishedElements)
            puts "Completed testing".green
        else
            puts "Testing not completed".red
        end
    rescue Exception=>e
        puts e.to_s.red
        return false
    end
end

# main(): Entry point for code
#   parameter: none
#   returns: none
def main()
    begin
        for i in (0...3)
            browser=Watir::Browser.new :chrome
            begin
                browser.driver.manage.window.maximize
                browser.goto $pageURL
                determineWizardLength(browser)
                fillDetails(browser)   
                findFinisedPopup(browser)     
            rescue Exception => e
                puts e.to_s.red
            ensure
                browser.close
            end
        end
    rescue Exception => e
        puts e.to_s.red
    end    
end
main()