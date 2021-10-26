*** Settings ***
Documentation     Test for Docker
Library           Selenium2Library
Library            DebugLibrary
Library         DateTime

*** Variables ***
${HOME_URL}      https://www.google.com/
${BROWSER}       Chrome

*** Test Cases ***
Test case sample
    Open Chrome Browser    ${HOME_URL}
    Maximize Browser Window
    Wait Until Element Is Visible   css:input[name='q']

    [Teardown]    Close Browser


*** Keywords ***
Open Chrome Browser
    [Arguments]     ${browserurl}
    ${chrome_options}=  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
    Call Method    ${chrome_options}    add_argument    --no-sandbox
    Call Method    ${chrome_options}    add_argument    --headless
    Call Method    ${chrome_options}    add_argument    --disable-setuid-sandbox
    Call Method    ${chrome_options}    add_argument    --disable-extensions
    Call Method    ${chrome_options}    add_argument    --disable-dev-shm-usage
    Call Method    ${chrome_options}    add_argument    ignore-certificate-errors
    ${userAgent}=  set variable         --user-agent=PlanIt-Automation
    Call Method    ${chrome_options}    add_argument    ${userAgent}
    Create Webdriver    Chrome    chrome_options=${chrome_options}
#    Create Webdriver    Chrome    chrome_options=${chrome_options}  executable_path=/usr/bin/chromedriver
#    Create Webdriver    Chrome    chrome_options=${chrome_options}  executable_path=C:\\chromedriver.exe
    Delete All Cookies
#    Maximize Browser Window
    Set Window Size     1920    1080
    Go To       ${HOME_URL}
