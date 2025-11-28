*** Settings ***
Documentation     Assignment 4: Mobile App Testing with Appium
...               Testing Minimal-Todo Android app using Robot Framework + Appium
...               App source: https://github.com/avjinder/Minimal-Todo
Library           AppiumLibrary
Resource          ../resources/appium_keywords.robot
Test Setup        Open Minimal Todo App
Test Teardown     Close Minimal Todo App

*** Test Cases ***
TC1: Add New Todo Item
    [Documentation]    Verify user can add a new todo item
    [Tags]    mobile    appium    add
    Add New Todo Item    Buy groceries
    Verify Todo Item Exists    Buy groceries

TC2: Add Multiple Todo Items
    [Documentation]    Verify user can add multiple todo items
    [Tags]    mobile    appium    add
    Add New Todo Item    Task 1 - Meeting at 10am
    Add New Todo Item    Task 2 - Lunch with team
    Add New Todo Item    Task 3 - Review code
    Verify Todo Item Exists    Task 1 - Meeting at 10am
    Verify Todo Item Exists    Task 2 - Lunch with team
    Verify Todo Item Exists    Task 3 - Review code

TC3: Delete Todo Item
    [Documentation]    Verify user can delete a todo item by swiping
    [Tags]    mobile    appium    delete
    Add New Todo Item    Item to delete
    Verify Todo Item Exists    Item to delete
    Delete Todo Item By Swipe    Item to delete
    Verify Todo Item Not Exists    Item to delete
