# Required statements
require 'watir'
require 'json'
require 'faker'
require_relative 'utils.rb'

# Configarations
Selenium::WebDriver::Chrome.driver_path=File.expand_path(File.dirname( __FILE__) + '/../Drivers/chromedriver.exe')
@@pageURL="https://mgsdemo.mgscoder.com/mgscode/regform/index-2.html"
@@dataFile="/data.json"

# generatetFakeDetails(): Used to generate fake details for the test.
#   parameter: None
#   returns: fakeDetails<hash>: This holds the generated fake details for entering into form
def generatetFakeDetails()
    fakeDetails={}
    fakeDetails['username']=Faker::Name.name
    fakeDetails['email']=Faker::Internet.email
    fakeDetails['password']=fakeDetails['username']+fakeDetails['email']
    fakeDetails['cpassword']=fakeDetails['password']
    fakeDetails['fname']=Faker::Name.first_name
    fakeDetails['lname']=Faker::Name.last_name
    fakeDetails['gender']=["Male","Female"].sample
    fakeDetails['dob']="12/03/1990"
    fakeDetails['address']=Faker::Address.full_address
    fakeDetails['phone']=Faker::Number.number(10)
    fakeDetails['profilepic']=File.expand_path(File.dirname( __FILE__)+"/test.jpg").gsub("/","\\\\")
    fakeDetails['paymentmode']=["Visa Card","Master Card"].sample 
    fakeDetails['ccname']=Faker::Name.name
    fakeDetails['ccnumber']=Faker::Number.number(16)
    fakeDetails['cccvc']=Faker::Number.number(3)
    fakeDetails['ccexpiry']="12/03/2020"
    return fakeDetails
end

# stepsExecute(): This method is responsible for executing all the test steps
#   parameters: browser: Driver object 
#   return: True when tests passed else false
def stepsExecute(browser)
    # Xpaths  ###############################################################################
    xpatSection1="//*[@id='section-1']"                                                     # Xpath for the account section
    xpatSection2="//*[@id='section-2']"                                                     # Xpath for the personal section 
    xpatSection3="//*[@id='section-3']"                                                     # Xpath for the payment section
    xpatSection4="//*[@id='section-4']"                                                     # Xpath for the confirm section
    xpathTotalWizard="//*[contains(@id,'section')]"                                         # Xpath for each section displayed on top 
    
    xpathSec1Username=xpatSection1+"//input[@id='uname']"                                   # Xpath for the username under account section
    xpathSec1Email=xpatSection1+"//input[@id='email']"                                      # Xpath for the Email under account section
    xpathSec1Password=xpatSection1+"//input[@id='pass']"                                    # Xpath for the Password under account section
    xpathSec1CnfPassword=xpatSection1+"//input[@id='cpass']"                                # Xpath for the confirm password under account section
    xpathSec1Next=xpatSection1+"//button[contains(@class,'pull-right')]"                    # Xpath for the next under account section
        
    xpathSec2FirstName=xpatSection2+"//input[@id='fname']"                                  # Xpath for the First Name under personal section
    xpathSec2LastName=xpatSection2+"//input[@id='lname']"                                   # Xpath for the Last Name under personal section    
    xpathSec2Gender=xpatSection2+"//select[@id='gender']"                                   # Xpath for the Gender under personal section
    xpathSec2DOB=xpatSection2+"//input[@id='birthdate']"                                    # Xpath for the Date of Birth under personal section
    xpathSec2Addr=xpatSection2+"//input[@id='address']"                                     # Xpath for the address under personal section
    xpathSec2Phone=xpatSection2+"//input[@id='phone']"                                      # Xpath for the phone under personal section
    xpathSec2PreferEmail=xpatSection2+"//input[@id='preferedcontact1']"                     # Xpath for the Prefered under personal section
    xpathSec2Browse=xpatSection2+"//label[.//span[contains(text(),'Browse')]]"              # Xpath for the profile pic under personal section
    xpathSec2Next=xpatSection2+"//button[contains(@class,'pull-right')]"                    # Xpath for the next under personal section

    xpathSec3paymode=xpatSection3+"//select[@id='paymenttype']"                             # Xpath for the Payment under payment section
    xpathSec3payname=xpatSection3+"//input[@id='hname']"                                    # Xpath for the Card Name under payment section
    xpathSec3paynum=xpatSection3+"//input[@id='cardnumber']"                                # Xpath for the Card number under payment section
    xpathSec3paycvc=xpatSection3+"//input[@id='cvc']"                                       # Xpath for the CVC under payment section
    xpathSec3payexpirydate=xpatSection3+"//input[@id='expirydate']"                         # Xpath for the Expiry date under payment section
    xpathSec3payaggre=xpatSection3+"//input[@id='aggre']"                                   # Xpath for the license agreement under payment section
    xpathSec3Next=xpatSection3+"//button[contains(@class,'pull-right')]"                    # Xpath for the next under payment section

    xpathSec4FirstNum=xpatSection4+"//input[@id='mathfirstnum']"                            # Xpath for the first number under confirm section
    xpathSec4SecondNum=xpatSection4+"//input[@id='mathsecondnum']"                          # Xpath for the second number under confirm section    
    xpathSec4Captcha=xpatSection4+"//input[@id='humanCheckCaptchaInput']"                   # Xpath for the calculation box under confirm section
    xpathSec4Submit=xpatSection4+"//button[@id='Submit']"                                   # Xpath for the submit under confirm section

    xpathFinished="//*[contains(text(),'You have finished all steps successfully!')]"       # Xpath for all steps finished
    #########################################################################################
    eleWizard=getElementsReference(browser,xpathTotalWizard,"Wizard")
    if (eleWizard)
        puts "Number of wizard: #{eleWizard.length}".green
        
        # get fake details
        details=generatetFakeDetails
        
        # get reference to account section element
        eleSec1Username=getElementReference(browser,xpathSec1Username,"Username")
        eleSec1Email=getElementReference(browser,xpathSec1Email,"Email")
        eleSec1Password=getElementReference(browser,xpathSec1Password,"Password")
        eleSec1CnfPassword=getElementReference(browser,xpathSec1CnfPassword,"confirm password")
        eleSec1Next=getElementReference(browser,xpathSec1Next,"Next button")
        
        # Check if any element is not present
        if(eleSec1Username and eleSec1Email and eleSec1Password and eleSec1CnfPassword and eleSec1Next)
        
            # Send details to account section elements
            eleSec1Username.send_keys(details['username'])
            eleSec1Email.send_keys(details['email'])
            eleSec1Password.send_keys(details['password'])
            eleSec1CnfPassword.send_keys(details['cpassword'])
            eleSec1Next.click()
            
            # get reference to personal section element
            eleSec2FirstName=getElementReference(browser,xpathSec2FirstName,"First Name")
            eleSec2LastName=getElementReference(browser,xpathSec2LastName,"Last Name")
            eleSec2Gender=getElementReference(browser,xpathSec2Gender,"Gender")
            eleSec2DOB=getElementReference(browser,xpathSec2DOB,"Date of Birth")
            eleSec2Addr=getElementReference(browser,xpathSec2Addr,"Address")
            eleSec2Phone=getElementReference(browser,xpathSec2Phone,"Phone")
            eleSec2PreferEmail=getElementReference(browser,xpathSec2PreferEmail,"Prefered contact")
            eleSec2Browse=getElementReference(browser,xpathSec2Browse,"Profile pic browser")
            eleSec2Next=getElementReference(browser,xpathSec2Next,"next")
            
            # Check if any element is not present
            if(eleSec2FirstName and eleSec2LastName and eleSec2Gender and eleSec2DOB and eleSec2Addr and eleSec2Phone and eleSec2PreferEmail and eleSec2Browse and eleSec2Next)
                
                # Send details to personal section elements
                eleSec2FirstName.send_keys(details['fname'])
                eleSec2LastName.send_keys(details['lname'])
                eleSec2Gender.to_subtype.select(details['gender'])
                eleSec2DOB.send_keys(details['dob'])
                eleSec2Addr.send_keys(details['address'])
                eleSec2Phone.send_keys(details['phone'])
                eleSec2PreferEmail.click()
                eleSec2Browse.click()
                system("autoit3 C:\\Work\\inter_test\\scenario_3\\open.au3")
                sleep(8)
                eleSec2Next.click()
                
                # get reference to payment section element
                eleSec3paymode=getElementReference(browser,xpathSec3paymode,"Payment mode")
                eleSec3payname=getElementReference(browser,xpathSec3payname,"Card name")
                eleSec3paynum=getElementReference(browser,xpathSec3paynum,"card number")
                eleSec3paycvc=getElementReference(browser,xpathSec3paycvc,"card cvc")
                eleSec3payexpirydate=getElementReference(browser,xpathSec3payexpirydate,"expiry date")
                eleSec3payaggre=getElementReference(browser,xpathSec3payaggre,"agreement")
                eleSec3Next=getElementReference(browser,xpathSec3Next,"next")
                
                # Check if any element is not present
                if(eleSec3paymode and eleSec3payname and eleSec3paynum and eleSec3paycvc and eleSec3payexpirydate and eleSec3payaggre and eleSec3Next)
                
                    # Send details to payment section elements
                    eleSec3paymode.to_subtype.select(details['paymentmode'])
                    eleSec3payname.send_keys(details['ccname'])
                    eleSec3paynum.send_keys(details['ccnumber'])
                    eleSec3paycvc.send_keys(details['cccvc'])
                    eleSec3payexpirydate.send_keys(details['ccexpiry'])
                    eleSec3payaggre.click()
                    eleSec3Next.click()
                    
                    # get reference to confirm section element
                    eleSec4FirstNum=getElementReference(browser,xpathSec4FirstNum,"Captcha first number")
                    eleSec4SecondNum=getElementReference(browser,xpathSec4SecondNum,"captcha second number")
                    eleSec4Captcha=getElementReference(browser,xpathSec4Captcha,"captcha")
                    eleSec4Submit=getElementReference(browser,xpathSec4Submit,"Submit")
                    
                    # Check if any element is not present
                    if(eleSec4FirstNum and eleSec4SecondNum and eleSec4Captcha and eleSec4Submit)
                    
                        # Send details to confirm section elements
                        captchCal=(eleSec4FirstNum.attribute_value("value").to_i)+(eleSec4SecondNum.attribute_value("value").to_i)
                        eleSec4Captcha.send_keys(captchCal.to_s)
                        eleSec4Submit.click()
                        sleep(2)
                        bTestFinished=getElementReference(browser,xpathFinished,"Finised")
                        if(bTestFinished)
                            puts "Test Finised".green
                            return true
                        else
                            return  false
                        end
                    else
                        return  false
                    end
                else
                    return  false
                end
            else
                return  false
            end
        else
            return  false
        end
    else
        return  false
    end   
end

def main()
    
    for i in (1..3)
        browser=Watir::Browser.new :chrome
        browser.driver.manage.window.maximize
        browser.goto @@pageURL
        stepsExecute(browser)
        browser.close
    end
    
end
main()