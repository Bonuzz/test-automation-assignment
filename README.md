# Test Automation Assignment

A complete test automation project using **Robot Framework** and **Python**.

## Tech Stack

| Tool | Purpose |
|------|---------|
| Robot Framework | Test automation framework |
| SeleniumLibrary | Web browser testing |
| RequestsLibrary | REST API testing |
| AppiumLibrary | Mobile app testing |
| Python | Scripting assignments |
| Jenkins | CI/CD pipeline |

## Project Structure

```
├── scripts/                    # Python/SQL assignments
│   ├── assignment_1_duplicates.py
│   ├── assignment_5_sql.sql
│   └── assignment_6_cipher.py
├── tests/                      # Robot Framework tests
│   ├── assignment_2_login_tests.robot
│   ├── assignment_3_api_tests.robot
│   ├── assignment_4_mobile_tests.robot
│   └── assignment_4_appium_tests.robot
├── resources/                  # Reusable keywords
│   ├── login_keywords.robot
│   ├── api_keywords.robot
│   ├── mobile_keywords.robot
│   └── appium_keywords.robot
├── Jenkinsfile                 # CI/CD pipeline
├── requirements.txt            # Python dependencies
└── run_all_tests.sh           # Script to run all tests
```

## Setup

```bash
# Install dependencies
pip install -r requirements.txt

# Download ChromeDriver (or use webdriver-manager)
```

## How to Run

### Python Scripts

```bash
# Assignment 1: Find duplicates
python scripts/assignment_1_duplicates.py

# Assignment 6: Caesar cipher decoder
python scripts/assignment_6_cipher.py
```

### Robot Framework Tests

```bash
# Run all tests
robot --outputdir results tests/

# Run specific assignment
robot --outputdir results tests/assignment_2_login_tests.robot
robot --outputdir results tests/assignment_3_api_tests.robot
robot --outputdir results tests/assignment_4_mobile_tests.robot

# Run Appium tests (requires Appium server and Android emulator)
robot --outputdir results tests/assignment_4_appium_tests.robot

# Run all assignments with script (includes Python scripts)
./run_all_tests.sh
```

## Assignments Overview

### Assignment 1: Find Duplicates (Python)
Find duplicate items between two lists.

**Input:**
- List A: `[1, 2, 3, 5, 6, 8, 9]`
- List B: `[3, 2, 1, 5, 6, 0]`

**Output:** `[1, 2, 3, 5, 6]`

---

### Assignment 2: Web Login Tests (Robot Framework)
Automated tests for login functionality on [The Internet - Herokuapp](https://the-internet.herokuapp.com/login).

| Test Case | Description |
|-----------|-------------|
| TC1 | Login with valid credentials |
| TC2 | Login with invalid username |
| TC3 | Login with invalid password |
| TC4 | Logout after successful login |

---

### Assignment 3: API Tests (Robot Framework)
REST API testing using [JSONPlaceholder](https://jsonplaceholder.typicode.com/).

| Test Case | Method | Endpoint |
|-----------|--------|----------|
| TC1 | GET | /users (list all) |
| TC2 | GET | /users/1 (single user) |
| TC3 | GET | /users/9999 (not found) |

---

### Assignment 4: Mobile App Tests (Robot Framework + Appium)
Native Android app testing using [Minimal-Todo](https://github.com/avjinder/Minimal-Todo) app.

| Test Case | Description |
|-----------|-------------|
| TC1 | Add new todo item |
| TC2 | Add multiple todo items |
| TC3 | Delete todo item by swipe |

**Requirements:**
- Android SDK and emulator (Pixel 7, API 34)
- Appium server running on port 4723
- UiAutomator2 driver installed

---

### Assignment 5: SQL Queries
Basic SQL queries for data retrieval.

| Query | Description |
|-------|-------------|
| Q6 | Select all product names |
| Q7 | Select users registered in 2022 |
| Q8 | Join Products with Customers |

---

### Assignment 6: Caesar Cipher Decoder (Python)
Decode encrypted text using Caesar cipher.

**Example:**
- Input: `VTAOG`, k=2
- Output: `TRYME`

## Jenkins Pipeline

The `Jenkinsfile` includes:
1. Checkout code
2. Install dependencies
3. Run Python scripts (Assignment 1, 6)
4. Run Robot Framework tests (Assignment 2, 3, 4)
5. SQL queries available in scripts/ (Assignment 5)
6. Publish test reports

## Test Results

After running tests, view the reports:
- `results/report.html` - Summary report
- `results/log.html` - Detailed log
