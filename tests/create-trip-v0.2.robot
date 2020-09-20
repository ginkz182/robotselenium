*** Settings ***
Documentation     Planit
Library           SeleniumLibrary
Library            DebugLibrary
Library         DateTime

*** Variables ***
${HOME_URL}      https://planit-tripplaner.azurewebsites.net
${BROWSER}       Chrome

*** Test Cases ***
Create Trip
    Open Chrome Browser    ${HOME_URL}
    Maximize Browser Window
    Wait Until Element Is Not Visible   css:div.loading-screen      timeout=10sec

    #fill destination
    Input Text      name:destination    Chiang Mai
    Click Element   name:destination
    Click Element   css:div#downshift-1-menu > div
    Click Element   css:div.home-cover button

    #select date
    Wait Until Element Is Visible   css:div.page-content div.modal.fade.show
    Click Element   css:div#calendar-wrap input
    Wait Until Element Is Visible   css:div.flatpickr-calendar.open
    ${date1}=       Get Current Date      UTC      exclude_millis=yes
    ${date1}=       Add Time To Date      ${date1}      1 day
    ${date2}=       Add Time To Date      ${date1}      2 days
    ${startdate}    Convert Date      ${date1}      result_format=%d
    ${enddate}      Convert Date      ${date2}      result_format=%d
    Click Element   xpath://div[@class='dayContainer']/span[@class='flatpickr-day '][text()='${startdate}']
    Click Element   xpath://div[@class='dayContainer']/span[@class='flatpickr-day'][text()='${enddate}']
    Click Element   css:div.flatpickr-calendar button.btn-p--light
    Click Element   css:div.modal-footer button

    #interest
    Click Element   css:div.interest-item div
    Click Element   xpath://div[@class='modal-footer justify-content-between']/button[2]
    Wait Until Element Is Not Visible   css:div.loading-screen

    #next
    Click Element   xpath://div[@class='modal-footer justify-content-between']/button[2]
    Wait Until Element Is Not Visible   css:div.loading-screen

    #next get itinerary
    Wait Until Element Is Visible   css:div.attraction__list-item img
    Click Element   css:div.modal-footer button.btn-q4-get-itinerary
    Wait Until Element Is Not Visible   css:div.loading-screen

    #verify itinerary page
    ${url}          Get Location
    Should Match Regexp    ${url}    ${HOME_URL}/itinerary/*
    [Teardown]    Close Browser


*** Keywords ***
Open Chrome Browser
    [Arguments]     ${browserurl}
    ${chrome_options}=  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
    Call Method    ${chrome_options}    add_argument    --no-sandbox
    Call Method    ${chrome_options}    add_argument    --disable-extensions
    Call Method    ${chrome_options}    add_argument    --disable-dev-shm-usage
    Create Webdriver    Chrome    chrome_options=${chrome_options}
#    Create Webdriver    Chrome    chrome_options=${chrome_options}  executable_path=/usr/bin/chromedriver
    Go To           ${browserurl}
#    [Arguments]     ${browserurl}
#    ${list} =       Create list   --no-sandbox    --disable-dev-shm-usage
#    ${args} =       Create Dictionary       args=${list}
#    ${desired caps} =   Create Dictionary   chromeOptions=${args}
#    Open Browser    ${browserurl}      browser=Chrome   desired_capabilities=${desired caps}
#


