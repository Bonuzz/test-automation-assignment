*** Settings ***
Documentation     Assignment 2: Web Login Test Automation
...               ทดสอบการ Login บนเว็บไซต์ http://the-internet.herokuapp.com/login
Resource          ../resources/login_keywords.robot

*** Test Cases ***

TC1: Login Success
    [Documentation]    ทดสอบ Login สำเร็จด้วย username และ password ที่ถูกต้อง
    [Tags]    login    positive    smoke
    Test Login Success And Logout
    [Teardown]    Close Browser Session

TC2: Login Failed - Password Incorrect
    [Documentation]    ทดสอบ Login ล้มเหลวเมื่อใช้ password ผิด
    [Tags]    login    negative
    Test Login Failed Password Incorrect
    [Teardown]    Close Browser Session

TC3: Login Failed - Username Not Found
    [Documentation]    ทดสอบ Login ล้มเหลวเมื่อใช้ username ที่ไม่มีในระบบ
    [Tags]    login    negative
    Test Login Failed Username Not Found
    [Teardown]    Close Browser Session
