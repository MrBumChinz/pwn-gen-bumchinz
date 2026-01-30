"""
Nexmon Stability Plugin for Pwnagotchi
Monitors and recovers WiFi interface from nexmon crashes
"""

import logging
import subprocess
import time
import pwnagotchi.plugins as plugins
from pwnagotchi.ui.components import LabeledValue
from pwnagotchi.ui.view import BLACK

class NexmonStability(plugins.Plugin):
    __author__ = 'MrBumChinz'
    __version__ = '1.0.0'
    __license__ = 'GPL3'
    __description__ = 'Monitors nexmon stability and auto-recovers from crashes'

    def __init__(self):
        self.ready = False
        self.crashes = 0
        self.last_check = 0
        self.check_interval = 30  # seconds

    def on_loaded(self):
        logging.info("[nexmon_stability] Plugin loaded")

    def on_ready(self, agent):
        self.ready = True
        logging.info("[nexmon_stability] Ready - monitoring wlan0")

    def _check_interface(self):
        """Check if wlan0 is in monitor mode and working"""
        try:
            result = subprocess.run(['iwconfig', 'wlan0'], 
                                  capture_output=True, text=True, timeout=5)
            if 'Monitor' in result.stdout:
                return True
            return False
        except:
            return False

    def _recover_interface(self):
        """Attempt to recover the WiFi interface"""
        logging.warning("[nexmon_stability] Attempting recovery...")
        try:
            # Try soft recovery first
            subprocess.run(['ip', 'link', 'set', 'wlan0', 'down'], timeout=5)
            time.sleep(1)
            subprocess.run(['ip', 'link', 'set', 'wlan0', 'up'], timeout=5)
            time.sleep(2)
            
            if not self._check_interface():
                # Hard recovery - reload driver
                logging.warning("[nexmon_stability] Soft recovery failed, reloading driver")
                subprocess.run(['modprobe', '-r', 'brcmfmac'], timeout=10)
                time.sleep(2)
                subprocess.run(['modprobe', 'brcmfmac'], timeout=10)
                time.sleep(3)
                subprocess.run(['/usr/bin/monstart'], timeout=10)
                
            self.crashes += 1
            return self._check_interface()
        except Exception as e:
            logging.error(f"[nexmon_stability] Recovery failed: {e}")
            return False

    def on_epoch(self, agent, epoch, epoch_data):
        """Check interface health each epoch"""
        now = time.time()
        if now - self.last_check < self.check_interval:
            return
            
        self.last_check = now
        
        if not self._check_interface():
            logging.warning("[nexmon_stability] Interface problem detected!")
            if self._recover_interface():
                logging.info("[nexmon_stability] Recovery successful")
            else:
                logging.error("[nexmon_stability] Recovery failed - may need reboot")

    def on_ui_setup(self, ui):
        ui.add_element('nexmon_crashes', LabeledValue(
            color=BLACK, label='NX:', value='0',
            position=(ui.width() - 40, 0),
            label_font=None, text_font=None))

    def on_ui_update(self, ui):
        ui.set('nexmon_crashes', str(self.crashes))
