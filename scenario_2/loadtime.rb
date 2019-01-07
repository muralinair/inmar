# Required import statements
require "watir"
require "uri"
require "colorize"

# Configarations for browser drivers
Selenium::WebDriver::Chrome.driver_path=File.expand_path(File.dirname( __FILE__) + '/../Drivers/chromedriver.exe')
Selenium::WebDriver::Firefox.driver_path=File.expand_path(File.dirname( __FILE__) + '/../Drivers/geckodriver.exe')

# required variable for code execution
@@browsers=["chrome","firefox"]#,"phantomjs"]  # Comented PhantomJS as its not being supported by Selenium 3 anymore
@@elementXpathTextBox="//input[@id='search_form_input_homepage']"  # Xpath for the element on the page
@@elementXpathResult="//*[@id='links']//*[contains(@id,'r1')]"  # Xpath for the element on the page
@@timeVar={}

# Timer function which takes care of calculating time for page loading after search query has been entered in the textbox
def timer(driver)
    t=Time.now
    result=yield(driver)
    @@timeVar[driver.driver.browser.to_s.downcase]=(Time.now-t)
end

# Main method which interacts with the browser
# createBorwser: url 'URL of the page'
#                browser 'browser object'
def createBorwser(url,browser)
    driver=Watir::Browser.new browser.to_sym  
    driver.goto url
    timer(driver) { |driver|
        if driver.element(:xpath=>@@elementXpathTextBox).present?
            driver.element(:xpath=>@@elementXpathTextBox).send_keys("watir webdriver")
            driver.element(:xpath=>@@elementXpathTextBox).send_keys :enter
            Watir::Wait.until(timeout:10) { driver.element(:xpath=>@@elementXpathResult).present? } 
        end
    }
    driver.close
end


def main()
    # SAMPLE url: https://duckduckgo.com/
    if ARGV.length != 0
        url=ARGV[0]
        if url =~ URI::regexp
            for eachBrowser in @@browsers
                createBorwser(url,eachBrowser) 
            end
            for t in @@timeVar.keys()
                puts "#{t} : #{@@timeVar[t]} secs".green
            end
        else
            puts "Pass in valid URL".red
        end
    else
        puts "Pass URL as test argument".red
    end
end
main()