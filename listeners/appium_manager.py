"""
Appium Manager Listener
เปิด Emulator และ Appium Server อัตโนมัติเมื่อรันเทส
"""
import subprocess
import time
import urllib.request
import os
import signal


class appium_manager:
    ROBOT_LISTENER_API_VERSION = 3

    def __init__(self, port="4723", emulator="Pixel_7_API_34"):
        self.port = port
        self.emulator_name = emulator
        self.appium_process = None
        self.started_appium = False
        self.started_emulator = False

    def start_suite(self, data, result):
        """เริ่มต้นเมื่อ suite เริ่มรัน"""
        # เช็คว่าเป็น Appium test หรือไม่
        if not self._is_appium_test(data):
            return

        # Step 1: เช็ค/เปิด Emulator
        self._ensure_emulator_running()

        # Step 2: เช็ค/เปิด Appium
        self._ensure_appium_running()

    def end_suite(self, data, result):
        """จบเมื่อ suite รันเสร็จ"""
        if not self._is_appium_test(data):
            return

        # ปิด Appium ที่เราเปิดเอง
        if self.started_appium and self.appium_process:
            print("🛑 Stopping Appium server...")
            self._stop_appium()

        # ไม่ปิด Emulator เพราะเปิดนาน

    def _is_appium_test(self, data):
        """เช็คว่าเป็น Appium test โดยดูจาก source"""
        source = str(data.source) if data.source else ""
        return "appium" in source.lower()

    # ==================== EMULATOR ====================

    def _is_emulator_running(self):
        """เช็คว่า Emulator รันอยู่หรือไม่"""
        try:
            result = subprocess.run(
                ["adb", "devices"],
                capture_output=True,
                text=True,
                timeout=5
            )
            return "emulator" in result.stdout
        except:
            return False

    def _is_emulator_booted(self):
        """เช็คว่า Emulator boot เสร็จหรือยัง"""
        try:
            result = subprocess.run(
                ["adb", "shell", "getprop", "sys.boot_completed"],
                capture_output=True,
                text=True,
                timeout=5
            )
            return result.stdout.strip() == "1"
        except:
            return False

    def _ensure_emulator_running(self):
        """เช็คและเปิด Emulator ถ้าจำเป็น"""
        if self._is_emulator_running() and self._is_emulator_booted():
            print("✅ Android Emulator already running")
            return

        print(f"🚀 Starting Android Emulator: {self.emulator_name}")
        print("   (รอสักครู่ อาจใช้เวลา 1-2 นาที...)")

        try:
            # เปิด Emulator
            subprocess.Popen(
                ["emulator", "-avd", self.emulator_name, "-no-snapshot-load"],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL
            )
            self.started_emulator = True

            # รอให้ device เชื่อมต่อ
            print("   รอ device เชื่อมต่อ", end="", flush=True)
            for _ in range(60):
                if self._is_emulator_running():
                    break
                print(".", end="", flush=True)
                time.sleep(2)
            print()

            # รอให้ boot เสร็จ
            print("   รอ boot เสร็จ", end="", flush=True)
            for _ in range(60):
                if self._is_emulator_booted():
                    break
                print(".", end="", flush=True)
                time.sleep(2)
            print()

            # รอเพิ่มให้ระบบเสถียร
            time.sleep(5)

            if self._is_emulator_booted():
                print("✅ Android Emulator ready")
            else:
                print("⚠️ Emulator may not be fully ready")

        except Exception as e:
            print(f"❌ Failed to start Emulator: {e}")

    # ==================== APPIUM ====================

    def _is_appium_running(self):
        """เช็คว่า Appium server รันอยู่หรือไม่"""
        try:
            url = f"http://127.0.0.1:{self.port}/status"
            req = urllib.request.urlopen(url, timeout=2)
            return req.status == 200
        except:
            return False

    def _ensure_appium_running(self):
        """เช็คและเปิด Appium ถ้าจำเป็น"""
        if self._is_appium_running():
            print(f"✅ Appium server already running on port {self.port}")
            return

        print(f"🚀 Starting Appium server on port {self.port}...")

        try:
            self.appium_process = subprocess.Popen(
                ["appium", "--port", str(self.port), "--relaxed-security"],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
                preexec_fn=os.setsid
            )
            self.started_appium = True

            # รอให้ Appium พร้อม
            for _ in range(30):
                if self._is_appium_running():
                    print(f"✅ Appium server ready on port {self.port}")
                    return
                time.sleep(1)

            print("⚠️ Appium server may not be ready")

        except Exception as e:
            print(f"❌ Failed to start Appium: {e}")

    def _stop_appium(self):
        """ปิด Appium server"""
        try:
            if self.appium_process:
                os.killpg(os.getpgid(self.appium_process.pid), signal.SIGTERM)
                self.appium_process = None
                print("✅ Appium server stopped")
        except Exception as e:
            print(f"⚠️ Error stopping Appium: {e}")
