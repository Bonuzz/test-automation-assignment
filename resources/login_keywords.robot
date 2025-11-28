*** Settings ***
Documentation     Reusable Login Keywords - สำหรับใช้ซ้ำในโปรเจค
Library           SeleniumLibrary

*** Variables ***
${LOGIN_URL}          http://the-internet.herokuapp.com/login
${BROWSER}            chrome
${USERNAME_FIELD}     id=username
${PASSWORD_FIELD}     id=password
${LOGIN_BUTTON}       css=button[type='submit']
${SUCCESS_MESSAGE}    css=.flash.success
${ERROR_MESSAGE}      css=.flash.error
${LOGOUT_BUTTON}      css=a[href='/logout']

${VALID_USERNAME}     tomsmith
${VALID_PASSWORD}     SuperSecretPassword!
${INVALID_USERNAME}   tomholland
${INVALID_PASSWORD}   Password!

*** Keywords ***

# ===== BASIC STEPS =====

Open Browser And Go To Login Page
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains Element    ${USERNAME_FIELD}    10s
    Page Should Contain    Login Page

Input Username And Password
    [Arguments]    ${username}    ${password}
    Input Text    ${USERNAME_FIELD}    ${username}
    Input Text    ${PASSWORD_FIELD}    ${password}

Click Login
    Click Button    ${LOGIN_BUTTON}
    Wait For Login Response

Wait For Login Response
    [Documentation]    รอจนกว่าจะได้ response จาก login (success หรือ error)
    Wait Until Keyword Succeeds    10s    0.5s    Page Should Contain Element    css=.flash

Close Browser Session
    [Documentation]    ปิด browser และ capture screenshot ถ้า test fail
    Run Keyword If Test Failed    Capture Page Screenshot
    Close Browser

# ===== LOGIN SUCCESS CASE =====

Test Login Success
    [Documentation]    ทดสอบ Login สำเร็จ
    Open Browser And Go To Login Page
    Input Username And Password    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Click Login
    Wait Until Page Contains Element    ${SUCCESS_MESSAGE}    10s
    Element Should Contain    ${SUCCESS_MESSAGE}    You logged into a secure area!
    Page Should Contain    Secure Area
    Page Should Contain Element    ${LOGOUT_BUTTON}

Test Login Success And Logout
    [Documentation]    ทดสอบ Login สำเร็จแล้ว Logout
    Test Login Success
    Click Link    ${LOGOUT_BUTTON}
    Wait Until Page Contains Element    ${SUCCESS_MESSAGE}    10s
    Element Should Contain    ${SUCCESS_MESSAGE}    You logged out of the secure area!
    Page Should Contain    Login Page

# ===== LOGIN FAILED - PASSWORD INCORRECT =====

Test Login Failed Password Incorrect
    [Documentation]    ทดสอบ Login ล้มเหลว - Password ผิด
    Open Browser And Go To Login Page
    Input Username And Password    ${VALID_USERNAME}    ${INVALID_PASSWORD}
    Click Login
    Wait Until Page Contains Element    ${ERROR_MESSAGE}    10s
    Element Should Contain    ${ERROR_MESSAGE}    Your password is invalid!
    Page Should Contain    Login Page

# ===== LOGIN FAILED - USERNAME NOT FOUND =====

Test Login Failed Username Not Found
    [Documentation]    ทดสอบ Login ล้มเหลว - Username ไม่พบ
    Open Browser And Go To Login Page
    Input Username And Password    ${INVALID_USERNAME}    ${INVALID_PASSWORD}
    Click Login
    Wait Until Page Contains Element    ${ERROR_MESSAGE}    10s
    Element Should Contain    ${ERROR_MESSAGE}    Your username is invalid!
    Page Should Contain    Login Page
