*** Settings ***
Documentation     Assignment 4: Mobile Web App Test Automation - TodoMVC
...               ทดสอบ Todo web app ในมุมมอง Mobile โดยใช้ Chrome Mobile Emulation
...               Source: https://todomvc.com/examples/react/dist/
Resource          ../resources/mobile_keywords.robot

*** Test Cases ***

TC1: Add New Todo Item
    [Documentation]    ทดสอบการเพิ่ม Todo item ใหม่บน Mobile
    [Tags]    mobile    add    smoke
    Test Add New Todo Item
    [Teardown]    Close Mobile App

TC2: View Todo Details
    [Documentation]    ทดสอบการดู Todo items ทั้งหมด
    [Tags]    mobile    view
    Test View Todo Details
    [Teardown]    Close Mobile App

TC3: Delete Todo Item
    [Documentation]    ทดสอบการลบ Todo item บน Mobile
    [Tags]    mobile    delete
    Test Delete Todo Item
    [Teardown]    Close Mobile App

TC4: Mark Todo As Complete
    [Documentation]    ทดสอบการทำเครื่องหมายว่าเสร็จแล้วบน Mobile
    [Tags]    mobile    complete
    Test Mark Todo As Complete
    [Teardown]    Close Mobile App
