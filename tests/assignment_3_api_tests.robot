*** Settings ***
Documentation     Assignment 3: REST API Test - GET User Profile
...               ทดสอบ REST API เพื่อดึงข้อมูล user profile
Resource          ../resources/api_keywords.robot

*** Test Cases ***

TC1: Get User Profile Success
    [Documentation]    ทดสอบการดึงข้อมูล user profile ที่มีอยู่ในระบบ (user ID = 12)
    [Tags]    api    get    positive
    Test Get User Profile Success
    [Teardown]    Teardown API Session

TC2: Get User Profile But User Not Found
    [Documentation]    ทดสอบการดึงข้อมูล user profile ที่ไม่มีในระบบ (user ID = 1234)
    [Tags]    api    get    negative
    Test Get User Profile Not Found
    [Teardown]    Teardown API Session
