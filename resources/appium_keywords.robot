*** Settings ***
Documentation     Keywords for Appium Mobile Testing (Minimal-Todo App)
Library           AppiumLibrary

*** Variables ***
${APPIUM_SERVER}          http://127.0.0.1:4723
${PLATFORM_NAME}          Android
${PLATFORM_VERSION}       14
${DEVICE_NAME}            Pixel_7_API_34
${APP_PATH}               ${CURDIR}/../apk/app-release.apk
${AUTOMATION_NAME}        UiAutomator2
${APP_PACKAGE}            com.avjindersinghsekhon.minimaltodo
${APP_ACTIVITY}           com.example.avjindersinghsekhon.toodle.MainActivity

# Locators for Minimal-Todo App
${ADD_TODO_BUTTON}        id=com.avjindersinghsekhon.minimaltodo:id/addToDoItemFAB
${TODO_TITLE_INPUT}       id=com.avjindersinghsekhon.minimaltodo:id/userToDoEditText
${TODO_SAVE_BUTTON}       id=com.avjindersinghsekhon.minimaltodo:id/makeToDoFloatingActionButton
${TODO_LIST}              id=com.avjindersinghsekhon.minimaltodo:id/toDoRecyclerView
${TODO_ITEM_TEXT}         id=com.avjindersinghsekhon.minimaltodo:id/toDoListItemTextview

*** Keywords ***
Open Minimal Todo App
    [Documentation]    Open the Minimal-Todo app on Android emulator
    Open Application    ${APPIUM_SERVER}
    ...    platformName=${PLATFORM_NAME}
    ...    platformVersion=${PLATFORM_VERSION}
    ...    deviceName=${DEVICE_NAME}
    ...    app=${APP_PATH}
    ...    automationName=${AUTOMATION_NAME}
    ...    appPackage=${APP_PACKAGE}
    ...    appActivity=${APP_ACTIVITY}
    ...    noReset=false
    ...    autoGrantPermissions=true
    # Handle welcome dialog if present
    ${dialog_present}=    Run Keyword And Return Status
    ...    Wait Until Page Contains Element    id=android:id/button1    3s
    Run Keyword If    ${dialog_present}    Click Element    id=android:id/button1
    Wait Until Page Contains Element    ${ADD_TODO_BUTTON}    10s

Close Minimal Todo App
    [Documentation]    Close the app and end session
    ${test_name}=    Evaluate    '${TEST NAME}'.replace(' ', '_').replace(':', '')
    Capture Page Screenshot    filename=appium-${test_name}.png
    Close Application

Add New Todo Item
    [Documentation]    Add a new todo item with the given title
    [Arguments]    ${todo_title}
    Click Element    ${ADD_TODO_BUTTON}
    Wait Until Page Contains Element    ${TODO_TITLE_INPUT}    5s
    Input Text    ${TODO_TITLE_INPUT}    ${todo_title}
    Click Element    ${TODO_SAVE_BUTTON}
    Wait Until Page Contains    ${todo_title}    5s

Verify Todo Item Exists
    [Documentation]    Verify that a todo item with the given title exists
    [Arguments]    ${todo_title}
    Wait Until Page Contains    ${todo_title}    5s

Delete Todo Item By Swipe
    [Documentation]    Delete a todo item by swiping left
    [Arguments]    ${todo_title}
    ${element}=    Get WebElement    xpath=//android.widget.TextView[@text='${todo_title}']
    ${location}=    Get Element Location    ${element}
    ${size}=    Get Element Size    ${element}
    ${start_x}=    Evaluate    int(${location['x']} + ${size['width']} - 10)
    ${end_x}=    Evaluate    int(${location['x']} + 10)
    ${y}=    Evaluate    int(${location['y']} + ${size['height']} / 2)
    Swipe    start_x=${start_x}    start_y=${y}    end_x=${end_x}    end_y=${y}    duration=500
    Sleep    1s

Verify Todo Item Not Exists
    [Documentation]    Verify that a todo item with the given title does not exist
    [Arguments]    ${todo_title}
    Sleep    1s
    Page Should Not Contain Text    ${todo_title}

Mark Todo As Complete By Tap
    [Documentation]    Mark a todo item as complete by tapping on it
    [Arguments]    ${todo_title}
    Click Element    xpath=//android.widget.TextView[@text='${todo_title}']
    Sleep    0.5s

Get Todo Items Count
    [Documentation]    Get the count of todo items in the list
    ${elements}=    Get WebElements    ${TODO_ITEM_TEXT}
    ${count}=    Get Length    ${elements}
    RETURN    ${count}
