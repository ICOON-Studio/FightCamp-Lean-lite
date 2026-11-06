"""Renders each mockup with headless Chrome, taller than the screen, then crops to 1920x1080. Nothing opens on screen."""
import os
import subprocess
import sys
from PIL import Image

D = 'E:/FightCamp/tmp/s393/menu/'
C = os.path.expandvars(r'%LOCALAPPDATA%\Google\Chrome\Application\chrome.exe')
for n in sys.argv[1:]:
    subprocess.run([C, '--headless=new', '--disable-gpu', '--hide-scrollbars', '--allow-file-access-from-files',
                    '--force-device-scale-factor=2', '--user-data-dir=' + D + 'hc', '--window-size=1920,1240',
                    '--virtual-time-budget=2500', '--screenshot=' + D + n + '.png', 'file:///' + D + n + '.html'],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=60)
    i = Image.open(D + n + '.png')
    print(n, i.size)
    i.crop((0, 0, 3840, 2160)).resize((1920, 1080), Image.LANCZOS).save(D + n + '.png')
