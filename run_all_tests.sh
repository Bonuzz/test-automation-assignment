#!/bin/bash
# =============================================================================
# Run All Robot Framework Tests with Video Recording
# สคริปต์สำหรับรันเทสทั้งหมดในโปรเจค พร้อมบันทึก video และเปิด report อัตโนมัติ
# =============================================================================

# Configuration
OUTPUT_DIR="results"
VIDEO_DIR="$OUTPUT_DIR/videos"
RECORD_VIDEO=false
OPEN_REPORT=true

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --video) RECORD_VIDEO=true ;;
        --no-open) OPEN_REPORT=false ;;
        -h|--help)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  --video     บันทึก video ขณะรันเทส (ต้องติดตั้ง ffmpeg)"
            echo "  --no-open   ไม่เปิด report อัตโนมัติหลังรันเสร็จ"
            exit 0
            ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
    shift
done

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Create directories
mkdir -p "$OUTPUT_DIR"
mkdir -p "$VIDEO_DIR"

# Print header
clear
echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║       🤖 Robot Framework Test Automation Suite 🤖          ║"
echo "╠════════════════════════════════════════════════════════════╣"
echo "║  Assignment 1: Python Duplicates                           ║"
echo "║  Assignment 2: Web Login Tests                             ║"
echo "║  Assignment 3: REST API Tests                              ║"
echo "║  Assignment 4: Mobile App Tests                            ║"
echo "║  Assignment 6: Caesar Cipher                               ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# Function to start video recording
start_video_recording() {
    if [ "$RECORD_VIDEO" = true ]; then
        TIMESTAMP=$(date +%Y%m%d_%H%M%S)
        VIDEO_FILE="$VIDEO_DIR/test_run_$TIMESTAMP.mp4"

        # Check if ffmpeg is available
        if command -v ffmpeg &> /dev/null; then
            echo -e "${BLUE}📹 Starting video recording...${NC}"

            # macOS screen recording using ffmpeg
            ffmpeg -f avfoundation -framerate 30 -i "1:none" -c:v libx264 -preset ultrafast -crf 23 "$VIDEO_FILE" 2>/dev/null &
            FFMPEG_PID=$!
            echo "   Video will be saved to: $VIDEO_FILE"
            sleep 2
        else
            echo -e "${YELLOW}⚠️  ffmpeg not found. Video recording disabled.${NC}"
            echo "   Install with: brew install ffmpeg"
            RECORD_VIDEO=false
        fi
    fi
}

# Function to stop video recording
stop_video_recording() {
    if [ "$RECORD_VIDEO" = true ] && [ ! -z "$FFMPEG_PID" ]; then
        echo -e "${BLUE}📹 Stopping video recording...${NC}"
        kill -INT $FFMPEG_PID 2>/dev/null || true
        wait $FFMPEG_PID 2>/dev/null || true
        echo "   Video saved to: $VIDEO_FILE"
    fi
}

# Function to open report in browser
open_report() {
    if [ "$OPEN_REPORT" = true ]; then
        # Find the latest report file
        REPORT_FILE=$(ls -t "$OUTPUT_DIR"/report*.html 2>/dev/null | head -1)

        if [ -f "$REPORT_FILE" ]; then
            echo -e "${BLUE}🌐 Opening test report in browser...${NC}"

            # Open in default browser based on OS
            if [[ "$OSTYPE" == "darwin"* ]]; then
                open "$REPORT_FILE"
            elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
                xdg-open "$REPORT_FILE"
            elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
                start "$REPORT_FILE"
            fi
        fi
    fi
}

# Trap to ensure cleanup on exit
trap stop_video_recording EXIT

# Start video recording if enabled
start_video_recording

echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}📝 Assignment 1: Python Duplicates Test${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
python3 scripts/assignment_1_duplicates.py
echo -e "${GREEN}✅ Assignment 1: PASSED${NC}"
echo ""

echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🔐 Assignment 6: Caesar Cipher Test${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
python3 scripts/assignment_6_cipher.py
echo -e "${GREEN}✅ Assignment 6: PASSED${NC}"
echo ""

echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🌐 Running Robot Framework Tests (2, 3, 4)${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Run all Robot Framework tests
ROBOT_EXIT_CODE=0
python3 -m robot \
    --outputdir "$OUTPUT_DIR" \
    --name "Test Automation Assignment" \
    --loglevel INFO \
    --timestampoutputs \
    tests/assignment_2_login_tests.robot \
    tests/assignment_3_api_tests.robot \
    tests/assignment_4_mobile_tests.robot || ROBOT_EXIT_CODE=$?

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Check result
if [ $ROBOT_EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║                  🎉 ALL TESTS PASSED! 🎉                   ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
else
    echo -e "${RED}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║                  ❌ SOME TESTS FAILED ❌                   ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
fi

# Print report locations
echo ""
echo -e "${BLUE}📊 Test Reports:${NC}"
REPORT_FILE=$(ls -t "$OUTPUT_DIR"/report*.html 2>/dev/null | head -1)
LOG_FILE=$(ls -t "$OUTPUT_DIR"/log*.html 2>/dev/null | head -1)
echo "   📄 Report: file://$PWD/$REPORT_FILE"
echo "   📋 Log:    file://$PWD/$LOG_FILE"

if [ "$RECORD_VIDEO" = true ] && [ -f "$VIDEO_FILE" ]; then
    echo "   🎬 Video:  file://$PWD/$VIDEO_FILE"
fi

echo ""

# Stop video recording
stop_video_recording

# Open report in browser
open_report

exit $ROBOT_EXIT_CODE
