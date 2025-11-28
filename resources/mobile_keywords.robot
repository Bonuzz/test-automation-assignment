*** Settings ***
Documentation     Reusable Mobile App Keywords - สำหรับทดสอบ TodoMVC บน Mobile
Library           SeleniumLibrary

*** Variables ***
${TODO_URL}           https://todomvc.com/examples/react/dist/
${DEVICE_NAME}        Pixel 7
${BROWSER}            chrome
${NEW_TODO_INPUT}     css=.new-todo
${TODO_LIST}          css=.todo-list
${TODO_ITEM}          css=.todo-list li
${TOGGLE_ALL}         css=.toggle-all
${CLEAR_COMPLETED}    css=.clear-completed
${FILTER_ALL}         xpath=//a[contains(text(),'All')]
${FILTER_ACTIVE}      xpath=//a[contains(text(),'Active')]
${FILTER_COMPLETED}   xpath=//a[contains(text(),'Completed')]

*** Keywords ***

# ===== BASIC SETUP =====

Open TodoMVC Mobile App
    [Documentation]    เปิด TodoMVC app ในโหมด Mobile emulation
    Open Browser    ${TODO_URL}    ${BROWSER}
    Set Window Size    412    915    # Pixel 7 dimensions
    Wait Until Element Is Visible    ${NEW_TODO_INPUT}    10s

Close Mobile App
    [Documentation]    ปิด browser และ capture screenshot ถ้า test fail
    Run Keyword If Test Failed    Capture Page Screenshot
    Close Browser

# ===== BASIC OPERATIONS =====

Add New Todo
    [Documentation]    เพิ่ม Todo item ใหม่
    [Arguments]    ${todo_text}
    Input Text    ${NEW_TODO_INPUT}    ${todo_text}
    Press Keys    ${NEW_TODO_INPUT}    RETURN
    Wait Until Element Is Visible    xpath=//label[text()='${todo_text}']    5s

Delete Todo Item
    [Documentation]    ลบ Todo item (ใช้ JavaScript click เพราะ Mobile ไม่มี hover)
    [Arguments]    ${todo_text}
    # Scroll to the todo item first
    Scroll Element Into View    xpath=//label[text()='${todo_text}']/ancestor::li
    Sleep    0.5s
    # Use JavaScript to click delete button (bypasses overlay issues on mobile)
    Execute Javascript    document.evaluate("//label[text()='${todo_text}']/following-sibling::button", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();
    Wait Until Element Is Not Visible    xpath=//label[text()='${todo_text}']    5s

Toggle Todo Complete
    [Documentation]    ทำเครื่องหมายว่า Todo เสร็จแล้ว
    [Arguments]    ${todo_text}
    ${checkbox}=    Get WebElement    xpath=//label[text()='${todo_text}']/preceding-sibling::input
    Click Element    ${checkbox}
    Wait Until Element Is Visible    xpath=//li[contains(@class,'completed')]//label[text()='${todo_text}']    5s

# ===== VERIFICATION =====

Verify Todo Added
    [Documentation]    ตรวจสอบว่า Todo ถูกเพิ่มแล้ว
    [Arguments]    ${todo_text}
    Page Should Contain    ${todo_text}
    Element Should Be Visible    xpath=//label[text()='${todo_text}']

Verify Todo Deleted
    [Documentation]    ตรวจสอบว่า Todo ถูกลบแล้ว
    [Arguments]    ${todo_text}
    Page Should Not Contain    ${todo_text}

Verify Todo Count
    [Documentation]    ตรวจสอบจำนวน Todo items
    [Arguments]    ${count}
    ${items}=    Get WebElements    ${TODO_ITEM}
    Length Should Be    ${items}    ${count}

Verify Todo Is Complete
    [Documentation]    ตรวจสอบว่า Todo ทำเครื่องหมายเสร็จแล้ว
    [Arguments]    ${todo_text}
    ${element}=    Get WebElement    xpath=//label[text()='${todo_text}']/../..
    ${class}=    Get Element Attribute    ${element}    class
    Should Contain    ${class}    completed

# ===== TEST CASES =====

Test Add New Todo Item
    [Documentation]    ทดสอบการเพิ่ม Todo item ใหม่บน Mobile
    Open TodoMVC Mobile App
    Add New Todo    Buy groceries
    Verify Todo Added    Buy groceries

Test View Todo Details
    [Documentation]    ทดสอบการดู Todo items ทั้งหมด
    Open TodoMVC Mobile App
    Add New Todo    Meeting preparation
    Add New Todo    Finish homework
    Verify Todo Count    2

Test Delete Todo Item
    [Documentation]    ทดสอบการลบ Todo item บน Mobile
    Open TodoMVC Mobile App
    Add New Todo    Test item
    Delete Todo Item    Test item
    Verify Todo Deleted    Test item

Test Mark Todo As Complete
    [Documentation]    ทดสอบการทำเครื่องหมายว่าเสร็จแล้ว
    Open TodoMVC Mobile App
    Add New Todo    Complete this task
    Toggle Todo Complete    Complete this task
    Verify Todo Is Complete    Complete this task
