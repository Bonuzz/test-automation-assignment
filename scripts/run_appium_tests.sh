#!/bin/bash
# =============================================================================
# Run Appium Tests Automatically
# สคริปต์รัน Appium tests อัตโนมัติ - เปิด Emulator และ Appium Server ให้เอง
# =============================================================================

set -e

# Configuration
EMULATOR_NAME="Pixel_7_API_34"
APPIUM_PORT=4723
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TEST_FILE="tests/assignment_4_appium_tests.robot"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Flags
STARTED_EMULATOR=false
STARTED_APPIUM=false

echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║          📱 Appium Mobile Test Runner 📱                   ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Cleanup function
cleanup() {
    echo ""
    echo -e "${YELLOW}🧹 Cleaning up...${NC}"

    if [ "$STARTED_APPIUM" = true ]; then
        echo "   Stopping Appium server..."
        pkill -f "appium" 2>/dev/null || true
    fi

    # Don't close emulator by default (takes long to restart)
    # Uncomment below if you want to close emulator after tests
    # if [ "$STARTED_EMULATOR" = true ]; then
    #     echo "   Stopping emulator..."
    #     adb emu kill 2>/dev/null || true
    # fi

    echo -e "${GREEN}✅ Cleanup complete${NC}"
}

trap cleanup EXIT

# -----------------------------------------------------------------------------
# Step 1: Check/Start Android Emulator
# -----------------------------------------------------------------------------
echo -e "${YELLOW}[1/4] Checking Android Emulator...${NC}"

if adb devices | grep -q "emulator"; then
    echo -e "   ${GREEN}✅ Emulator already running${NC}"
else
    echo -e "   ${BLUE}🚀 Starting emulator: ${EMULATOR_NAME}${NC}"

    # Start emulator in background
    nohup emulator -avd "$EMULATOR_NAME" -no-snapshot-load > /dev/null 2>&1 &
    STARTED_EMULATOR=true

    echo "   Waiting for emulator to boot..."

    # Wait for device to be connected
    adb wait-for-device

    # Wait for boot to complete
    echo -n "   "
    while [ "$(adb shell getprop sys.boot_completed 2>/dev/null)" != "1" ]; do
        echo -n "."
        sleep 2
    done
    echo ""

    # Extra wait for system to stabilize
    sleep 5

    echo -e "   ${GREEN}✅ Emulator ready${NC}"
fi

# -----------------------------------------------------------------------------
# Step 2: Check/Start Appium Server
# -----------------------------------------------------------------------------
echo -e "${YELLOW}[2/4] Checking Appium Server...${NC}"

if curl -s http://127.0.0.1:${APPIUM_PORT}/status > /dev/null 2>&1; then
    echo -e "   ${GREEN}✅ Appium server already running${NC}"
else
    echo -e "   ${BLUE}🚀 Starting Appium server on port ${APPIUM_PORT}${NC}"

    # Start Appium in background
    nohup appium --port ${APPIUM_PORT} --relaxed-security > /tmp/appium.log 2>&1 &
    STARTED_APPIUM=true

    # Wait for Appium to be ready
    echo -n "   "
    for i in {1..30}; do
        if curl -s http://127.0.0.1:${APPIUM_PORT}/status > /dev/null 2>&1; then
            break
        fi
        echo -n "."
        sleep 1
    done
    echo ""

    if curl -s http://127.0.0.1:${APPIUM_PORT}/status > /dev/null 2>&1; then
        echo -e "   ${GREEN}✅ Appium server ready${NC}"
    else
        echo -e "   ${RED}❌ Failed to start Appium server${NC}"
        exit 1
    fi
fi

# -----------------------------------------------------------------------------
# Step 3: Install UiAutomator2 driver if needed
# -----------------------------------------------------------------------------
echo -e "${YELLOW}[3/4] Checking Appium drivers...${NC}"

if appium driver list --installed 2>/dev/null | grep -q "uiautomator2"; then
    echo -e "   ${GREEN}✅ UiAutomator2 driver installed${NC}"
else
    echo -e "   ${BLUE}📦 Installing UiAutomator2 driver...${NC}"
    appium driver install uiautomator2
    echo -e "   ${GREEN}✅ Driver installed${NC}"
fi

# -----------------------------------------------------------------------------
# Step 4: Run Tests
# -----------------------------------------------------------------------------
echo -e "${YELLOW}[4/4] Running Appium tests...${NC}"
echo ""

cd "$PROJECT_DIR"

# Run Robot Framework tests
python3 -m robot \
    --outputdir results \
    --listener listeners/open_report.py \
    --loglevel INFO \
    "$TEST_FILE"

TEST_RESULT=$?

echo ""
if [ $TEST_RESULT -eq 0 ]; then
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗"
    echo "║              🎉 ALL TESTS PASSED! 🎉                        ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
else
    echo -e "${RED}╔════════════════════════════════════════════════════════════╗"
    echo "║              ❌ SOME TESTS FAILED ❌                        ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
fi

exit $TEST_RESULT
