#!/usr/bin/env python3
"""
Mode Toggle for Pwnagotchi using PiSugar button
Cycles through: AUTO -> MANU -> AI -> AUTO
Single press on PiSugar button changes mode
"""

import subprocess
import time
import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s')
log = logging.getLogger('mode-toggle')

# Mode cycle order
MODES = ['AUTO', 'MANU', 'AI']

def get_current_mode():
    """Get current pwnagotchi mode from process args"""
    try:
        result = subprocess.run(['pgrep', '-af', 'pwnagotchi'], 
                              capture_output=True, text=True)
        if '--manual' in result.stdout:
            return 'MANU'
        elif result.stdout.strip():
            return 'AUTO'  # Running without --manual = AUTO mode
        return None
    except:
        return None

def set_mode(mode):
    """Change pwnagotchi mode"""
    log.info(f"Switching to {mode} mode")
    try:
        # Stop current instance
        subprocess.run(['systemctl', 'stop', 'pwnagotchi'], timeout=30)
        time.sleep(2)
        
        if mode == 'MANU':
            # Start in manual mode
            subprocess.run(['systemctl', 'start', 'pwnagotchi'])
            time.sleep(1)
            subprocess.run(['pwnagotchi', '--manual'], timeout=5)
        elif mode == 'AUTO':
            # Start in auto mode (default)
            subprocess.run(['systemctl', 'start', 'pwnagotchi'])
        elif mode == 'AI':
            # AI mode - same as AUTO but could trigger AI-specific behavior
            subprocess.run(['systemctl', 'start', 'pwnagotchi'])
            
        log.info(f"Mode changed to {mode}")
    except Exception as e:
        log.error(f"Failed to change mode: {e}")

def cycle_mode():
    """Cycle to next mode"""
    current = get_current_mode()
    if current is None:
        next_mode = 'AUTO'
    else:
        try:
            idx = MODES.index(current)
            next_mode = MODES[(idx + 1) % len(MODES)]
        except ValueError:
            next_mode = 'AUTO'
    set_mode(next_mode)

def read_pisugar_button():
    """Read PiSugar button state via I2C"""
    try:
        import smbus2
        bus = smbus2.SMBus(1)
        PISUGAR_ADDR = 0x57
        
        # Read button register (varies by PiSugar model)
        # PiSugar 2: register 0x02, bit 0 = single tap
        data = bus.read_byte_data(PISUGAR_ADDR, 0x02)
        
        if data & 0x01:  # Single tap detected
            # Clear the tap flag
            bus.write_byte_data(PISUGAR_ADDR, 0x02, data & ~0x01)
            return True
        return False
    except Exception as e:
        return False

def main():
    log.info("Mode Toggle service started")
    log.info("Press PiSugar button to cycle: AUTO -> MANU -> AI -> AUTO")
    
    last_press = 0
    debounce = 1.0  # 1 second debounce
    
    while True:
        try:
            if read_pisugar_button():
                now = time.time()
                if now - last_press > debounce:
                    log.info("Button press detected!")
                    cycle_mode()
                    last_press = now
            time.sleep(0.1)
        except KeyboardInterrupt:
            log.info("Shutting down")
            break
        except Exception as e:
            log.error(f"Error: {e}")
            time.sleep(1)

if __name__ == '__main__':
    main()
