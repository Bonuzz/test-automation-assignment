"""
Robot Framework Listener - Auto Open Report
เปิด report อัตโนมัติหลังรันเทสเสร็จ
"""
import os
import subprocess
import sys


class open_report:
    ROBOT_LISTENER_API_VERSION = 3

    def __init__(self, open_log=False):
        self.output_dir = None
        self.open_log = open_log == 'True' or open_log is True

    def output_file(self, path):
        self.output_dir = os.path.dirname(path)

    def close(self):
        if not self.output_dir:
            return

        report_path = os.path.join(self.output_dir, 'report.html')

        if os.path.exists(report_path):
            self._open_file(report_path)

        if self.open_log:
            log_path = os.path.join(self.output_dir, 'log.html')
            if os.path.exists(log_path):
                self._open_file(log_path)

    def _open_file(self, path):
        if sys.platform == 'darwin':  # macOS
            subprocess.run(['open', path])
        elif sys.platform == 'linux':
            subprocess.run(['xdg-open', path])
        elif sys.platform == 'win32':
            os.startfile(path)
