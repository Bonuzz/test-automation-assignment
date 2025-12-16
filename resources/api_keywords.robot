*** Settings ***
Documentation     Reusable API Keywords - สำหรับทดสอบ REST API
Library           RequestsLibrary
Library           Collections

*** Variables ***
${BASE_URL}           https://reqres.in/api
${VALID_USER_ID}      12
${INVALID_USER_ID}    1234
${API_KEY}            reqres_a1b4e1521118423089afc306da5b9c01

*** Keywords ***

# ===== BASIC SETUP =====

Setup API Session
    [Documentation]    สร้าง API session
    ${headers}=    Create Dictionary
    ...    x-api-key=${API_KEY}
    ...    User-Agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
    Create Session    reqres    ${BASE_URL}    headers=${headers}    verify=${True}

Teardown API Session
    [Documentation]    ปิด API session
    Delete All Sessions

# ===== GET USER PROFILE SUCCESS =====

Test Get User Profile Success
    [Documentation]    ทดสอบ GET user profile สำเร็จ (user ID = 12)
    Setup API Session
    ${response}=    GET On Session    reqres    /users/${VALID_USER_ID}
    
    # Verify Status Code
    Status Should Be    200    ${response}
    
    # Verify Response Body
    ${json}=    Set Variable    ${response.json()}
    ${data}=    Get From Dictionary    ${json}    data
    
    # Verify User Data
    Should Be Equal As Numbers    ${data}[id]    12
    Should Be Equal As Strings    ${data}[email]    rachel.howell@reqres.in
    Should Be Equal As Strings    ${data}[first_name]    Rachel
    Should Be Equal As Strings    ${data}[last_name]    Howell
    Should Be Equal As Strings    ${data}[avatar]    https://reqres.in/img/faces/12-image.jpg
    
    Log    User Profile Retrieved Successfully: ${data}

# ===== GET USER PROFILE NOT FOUND =====

Test Get User Profile Not Found
    [Documentation]    ทดสอบ GET user profile ล้มเหลว (user ID ไม่พบ)
    Setup API Session
    
    # ใช้ expected_status เพื่อไม่ให้ test fail เมื่อได้ 404
    ${response}=    GET On Session    reqres    /users/${INVALID_USER_ID}    expected_status=404
    
    # Verify Status Code
    Status Should Be    404    ${response}
    
    # Verify Response Body (should be empty {})
    ${json}=    Set Variable    ${response.json()}
    ${length}=    Get Length    ${json}
    Should Be Equal As Numbers    ${length}    0    msg=Response body should be empty for 404
    Log    Response Body: ${json}
